#!/bin/bash
input=$(cat)

# ---------------------------------------------------------------------------
# JSON parsing — prefer jq, fall back to Python, then use static defaults
# ---------------------------------------------------------------------------

if command -v jq >/dev/null 2>&1; then
    # --- jq path ---
    CONTEXT_WINDOW_USED_PERCENTAGE=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0 | floor | tostring' 2>/dev/null || echo "0")
    MODEL_DISPLAY_NAME=$(printf '%s' "$input" | jq -r '.model.display_name // ""' 2>/dev/null || echo "")
    WORKSPACE_PROJECT_DIR=$(printf '%s' "$input" | jq -r '.workspace.project_dir // "" | split("/") | last | split("\\") | last' 2>/dev/null || echo "")

else
    # --- Python path ---
    PYTHON_BIN=""
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_BIN="python3"
    elif command -v python >/dev/null 2>&1; then
        PYTHON_BIN="python"
    fi

    if [ -n "$PYTHON_BIN" ]; then
        CONTEXT_WINDOW_USED_PERCENTAGE=$(printf '%s' "$input" | "$PYTHON_BIN" -c "
import sys, json, math
try:
    d = json.load(sys.stdin)
    v = d.get('context_window', {}).get('used_percentage') or 0
    print(str(math.floor(v)))
except Exception:
    print('0')
" 2>/dev/null || echo "0")

        MODEL_DISPLAY_NAME=$(printf '%s' "$input" | "$PYTHON_BIN" -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('model', {}).get('display_name') or '')
except Exception:
    print('')
" 2>/dev/null || echo "")

        WORKSPACE_PROJECT_DIR=$(printf '%s' "$input" | "$PYTHON_BIN" -c "
import sys, json, os
try:
    d = json.load(sys.stdin)
    p = d.get('workspace', {}).get('project_dir') or ''
    print(os.path.basename(p.rstrip('/\\\\')))
except Exception:
    print('')
" 2>/dev/null || echo "")

    else
        # --- static fallback (neither jq nor Python available) ---
        CONTEXT_WINDOW_USED_PERCENTAGE="?"
        MODEL_DISPLAY_NAME="claude"
        WORKSPACE_PROJECT_DIR="$(basename "$(pwd)" 2>/dev/null || echo "")"
    fi
fi

# ---------------------------------------------------------------------------
# Git branch (no JSON parsing needed)
# ---------------------------------------------------------------------------

GIT_BRANCH=""
# Derive a POSIX path from workspace.project_dir in the JSON payload.
# Prefer cygpath (Git for Windows / MSYS2); fall back to bash string substitution.
_raw_project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // ""' 2>/dev/null || echo "")
if [ -z "$_raw_project_dir" ] && command -v python3 >/dev/null 2>&1; then
    _raw_project_dir=$(printf '%s' "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('workspace',{}).get('project_dir') or '')" 2>/dev/null || echo "")
fi
if [ -n "$_raw_project_dir" ]; then
    if command -v cygpath >/dev/null 2>&1; then
        _posix_project_dir=$(cygpath -u "$_raw_project_dir" 2>/dev/null || echo "$_raw_project_dir")
    else
        # Convert  D:\foo\bar  →  /d/foo/bar
        _posix_project_dir=$(echo "$_raw_project_dir" | sed 's|\\|/|g; s|^\([A-Za-z]\):|/\L\1|')
    fi
    if git -C "$_posix_project_dir" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git -C "$_posix_project_dir" branch --show-current 2>/dev/null)
        [ -n "$BRANCH" ] && GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

echo "🧠 ${CONTEXT_WINDOW_USED_PERCENTAGE}% | 🤖 $MODEL_DISPLAY_NAME | 📁 $WORKSPACE_PROJECT_DIR${GIT_BRANCH}"
