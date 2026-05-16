#!/bin/bash
input=$(cat)

# ---------------------------------------------------------------------------
# JSON parsing — prefer jq, fall back to Python, then use static defaults
# ---------------------------------------------------------------------------

SESSION_ID=""
_in=0
_out=0

if command -v jq >/dev/null 2>&1; then
    # --- jq path ---
    CONTEXT_WINDOW_USED_PERCENTAGE=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0 | floor | tostring' 2>/dev/null || echo "0")
    MODEL_DISPLAY_NAME=$(printf '%s' "$input" | jq -r '.model.display_name // ""' 2>/dev/null || echo "")
    MODEL_ID=$(printf '%s' "$input" | jq -r '.model.id // ""' 2>/dev/null || echo "")
    WORKSPACE_PROJECT_DIR=$(printf '%s' "$input" | jq -r '.workspace.project_dir // "" | split("/") | last | split("\\") | last' 2>/dev/null || echo "")
    _in=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null || echo "0")
    _out=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0' 2>/dev/null || echo "0")
    SESSION_ID=$(printf '%s' "$input" | jq -r '.session_id // ""' 2>/dev/null || echo "")
    SESSION_TOKENS=$(( _in + _out ))

else
    # --- Python path ---
    PYTHON_BIN=""
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_BIN="python3"
    elif command -v python >/dev/null 2>&1; then
        PYTHON_BIN="python"
    fi

    if [ -n "$PYTHON_BIN" ]; then
        # Parse everything in one Python call to avoid repeat stdin reads
        _parsed=$(printf '%s' "$input" | "$PYTHON_BIN" -c "
import sys, json, math, os
try:
    d = json.load(sys.stdin)
    pct = math.floor(d.get('context_window', {}).get('used_percentage') or 0)
    model = d.get('model', {}) or {}
    name = model.get('display_name') or ''
    mid = model.get('id') or ''
    p = d.get('workspace', {}).get('project_dir') or ''
    proj = os.path.basename(p.rstrip('/\\\\'))
    cw = d.get('context_window', {}) or {}
    tin = cw.get('total_input_tokens', 0) or 0
    tout = cw.get('total_output_tokens', 0) or 0
    sid = d.get('session_id') or ''
    print('\t'.join([str(pct), name, mid, proj, str(tin), str(tout), sid]))
except Exception:
    print('0\t\t\t\t0\t0\t')
" 2>/dev/null)
        IFS=$'\t' read -r CONTEXT_WINDOW_USED_PERCENTAGE MODEL_DISPLAY_NAME MODEL_ID WORKSPACE_PROJECT_DIR _in _out SESSION_ID <<< "$_parsed"
        SESSION_TOKENS=$(( _in + _out ))
    else
        # --- static fallback (neither jq nor Python available) ---
        CONTEXT_WINDOW_USED_PERCENTAGE="?"
        MODEL_DISPLAY_NAME="claude"
        MODEL_ID=""
        WORKSPACE_PROJECT_DIR="$(basename "$(pwd)" 2>/dev/null || echo "")"
        SESSION_TOKENS=0
    fi
fi

# ---------------------------------------------------------------------------
# Git branch
# ---------------------------------------------------------------------------

GIT_BRANCH=""
_raw_project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // ""' 2>/dev/null || echo "")
if [ -z "$_raw_project_dir" ] && command -v python3 >/dev/null 2>&1; then
    _raw_project_dir=$(printf '%s' "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('workspace',{}).get('project_dir') or '')" 2>/dev/null || echo "")
fi
if [ -n "$_raw_project_dir" ]; then
    if command -v cygpath >/dev/null 2>&1; then
        _posix_project_dir=$(cygpath -u "$_raw_project_dir" 2>/dev/null || echo "$_raw_project_dir")
    else
        _posix_project_dir=$(echo "$_raw_project_dir" | sed 's|\\|/|g; s|^\([A-Za-z]\):|/\L\1|')
    fi
    if git -C "$_posix_project_dir" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git -C "$_posix_project_dir" branch --show-current 2>/dev/null)
        [ -n "$BRANCH" ] && GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

# ---------------------------------------------------------------------------
# Format helper: 0–999 → "N", 1000+ → "N.Nk" (one decimal everywhere)
# ---------------------------------------------------------------------------
fmt_k() {
    local n=$1
    if [ "$n" -lt 1000 ] 2>/dev/null; then
        printf '%s' "$n"
    else
        awk -v n="$n" 'BEGIN{printf "%.1fk", n/1000}'
    fi
}

IN_FMT=$(fmt_k "$_in")
OUT_FMT=$(fmt_k "$_out")

# ---------------------------------------------------------------------------
# Threshold emoji based on context window %
# ---------------------------------------------------------------------------
PCT_NUM=$CONTEXT_WINDOW_USED_PERCENTAGE
case "$PCT_NUM" in
    ''|*[!0-9]*) PCT_NUM=0 ;;
esac
if [ "$PCT_NUM" -ge 90 ] 2>/dev/null; then
    BURN_EMOJI="🚨"
elif [ "$PCT_NUM" -ge 75 ] 2>/dev/null; then
    BURN_EMOJI="🥵"
else
    BURN_EMOJI="🔥"
fi

# ---------------------------------------------------------------------------
# Model emoji — Opus 👑, Sonnet 🎭, Haiku 🍃, fallback 🤖
# ---------------------------------------------------------------------------
_model_lc=$(printf '%s' "${MODEL_ID}${MODEL_DISPLAY_NAME}" | tr '[:upper:]' '[:lower:]')
case "$_model_lc" in
    *opus*)   MODEL_EMOJI="👑" ;;
    *sonnet*) MODEL_EMOJI="🎭" ;;
    *haiku*)  MODEL_EMOJI="🍃" ;;
    *)        MODEL_EMOJI="🤖" ;;
esac

# ---------------------------------------------------------------------------
# Cost estimate — model-aware per-million pricing (input + output approximation)
# Cache discount not exposed in payload; treats all input as full-rate (upper bound).
# ---------------------------------------------------------------------------
_model_lc=$(printf '%s' "${MODEL_ID}${MODEL_DISPLAY_NAME}" | tr '[:upper:]' '[:lower:]')
case "$_model_lc" in
    *opus*)   IN_RATE=15;   OUT_RATE=75 ;;
    *sonnet*) IN_RATE=3;    OUT_RATE=15 ;;
    *haiku*)  IN_RATE=0.80; OUT_RATE=4  ;;
    *)        IN_RATE=3;    OUT_RATE=15 ;;
esac
COST=$(awk -v i="$_in" -v o="$_out" -v ir="$IN_RATE" -v or="$OUT_RATE" \
    'BEGIN{printf "%.2f", (i*ir + o*or)/1000000}')

# ---------------------------------------------------------------------------
# Delta since last turn — state in temp dir keyed by session id
# ---------------------------------------------------------------------------
DELTA_FMT=""
if [ -n "$SESSION_ID" ]; then
    _state_dir="${TMPDIR:-/tmp}"
    _state_file="${_state_dir}/claude-statusline-${SESSION_ID}.last"
    _last=0
    [ -f "$_state_file" ] && _last=$(cat "$_state_file" 2>/dev/null || echo 0)
    case "$_last" in ''|*[!0-9]*) _last=0 ;; esac
    _delta=$(( SESSION_TOKENS - _last ))
    if [ "$_delta" -gt 0 ] 2>/dev/null; then
        DELTA_FMT=" (+$(fmt_k $_delta))"
    fi
    printf '%s' "$SESSION_TOKENS" > "$_state_file" 2>/dev/null
fi

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
echo "🧠 ${CONTEXT_WINDOW_USED_PERCENTAGE}% | ${BURN_EMOJI} ${IN_FMT}↑ ${OUT_FMT}↓ | ${MODEL_EMOJI} $MODEL_DISPLAY_NAME | 📁 $WORKSPACE_PROJECT_DIR${GIT_BRANCH}"
