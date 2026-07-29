#!/usr/bin/env bash
# capture-log.sh — unattended, deterministic, per-turn raw capture of every
# Stop event (Notes/Personal/Claude-Code-Memory-Plan-implementation-plan.md,
# Phase 1). Additive to, not a replacement for, the curated /log-session flow
# and the existing nudge Stop hook — writes verbatim, no model call, no
# summarisation. Never touches Vault/Memory/. Must ALWAYS exit 0.
#
# Bash 3.2 / Git Bash safe: no arrays, no `timeout`, POSIX+BSD/GNU portable.

set -u

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi

# Fail-safe: no jq, no capture. Better to capture nothing than corrupt a file.
command -v jq >/dev/null 2>&1 || exit 0

# Redact common secret shapes from captured turn text. Reads stdin, writes
# stdout. HEURISTIC, NOT EXHAUSTIVE — a novel token format will pass through.
# This is a harm-reduction pass on a cloud-synced plaintext log, not a
# guarantee; the primary control is still "do not paste secrets into a prompt".
# Fails CLOSED: the caller substitutes a placeholder if this produces nothing,
# because writing the raw text on a redactor failure defeats the whole point.
redact() {
  # Case-insensitive keyword class spelled out character by character. BSD sed
  # has no `I` flag on s///, so this is the portable way to catch `api_key=`,
  # `Api_Key:` and `API_KEY=` with a single rule. This is the deliberately
  # over-broad rule — tighten the value pattern before dropping it.
  KW='([Aa][Pp][Ii]_?[Kk][Ee][Yy]|[Tt][Oo][Kk][Ee][Nn]|[Ss][Ee][Cc][Rr][Ee][Tt]|[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]|[Pp][Aa][Ss][Ss][Ww][Dd]|[Cc][Rr][Ee][Dd][Ee][Nn][Tt][Ii][Aa][Ll][Ss]?)'

  # First pass (awk): blank out the body of PEM-style key blocks, which span
  # lines and so cannot be matched by line-oriented sed.
  awk '
    /-----BEGIN [A-Z ]*PRIVATE KEY-----/ { print "***REDACTED PRIVATE KEY BLOCK***"; inkey=1; next }
    /-----END [A-Z ]*PRIVATE KEY-----/   { inkey=0; next }
    inkey != 1 { print }
  ' 2>/dev/null |
  # Second pass (sed): single-line token shapes. `-E`, never `-r` — `-r` is
  # GNU-only and this repo targets BSD sed (macOS) as well.
  sed -E \
    -e 's/sk-ant-[A-Za-z0-9_-]{16,}/sk-ant-***REDACTED***/g' \
    -e 's/sk-[A-Za-z0-9]{20,}/sk-***REDACTED***/g' \
    -e 's/gh[pousr]_[A-Za-z0-9]{16,}/gh_***REDACTED***/g' \
    -e 's/github_pat_[A-Za-z0-9_]{16,}/github_pat_***REDACTED***/g' \
    -e 's/AKIA[0-9A-Z]{16}/AKIA***REDACTED***/g' \
    -e 's/xox[abprs]-[A-Za-z0-9-]{10,}/xox-***REDACTED***/g' \
    -e 's#1//[A-Za-z0-9_-]{20,}#1//***REDACTED***#g' \
    -e 's/eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}/***REDACTED JWT***/g' \
    -e 's/([Bb]earer )[A-Za-z0-9._-]{20,}/\1***REDACTED***/g' \
    -e "s/(([A-Za-z_]*)${KW}[A-Za-z_]*[[:space:]]*[=:][[:space:]]*)[\"']?[^[:space:]\"']{8,}/\\1***REDACTED***/g" \
    2>/dev/null
}

INPUT="$(cat)"

SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
TRANSCRIPT=$(printf '%s' "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
TURN_NUM=$(printf '%s' "$INPUT" | jq -r '.turn_number // empty' 2>/dev/null)
LAST_ASSISTANT=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // empty' 2>/dev/null)

[ -n "$SESSION_ID" ] || exit 0
[ -n "$TRANSCRIPT" ] || exit 0
[ -f "$TRANSCRIPT" ] || exit 0

YEAR=$(date -u +%Y)
DATE=$(date -u +%Y-%m-%d)
CAP_ROOT="$DIR/Vault/Logs/Sessions/Captures"
OUT_DIR="$CAP_ROOT/$YEAR"

# Reuse this session's existing file if one exists (a session's first-turn date is
# stable — don't re-derive the prefix each fire, or a session spanning midnight/year
# would split into two files). A plain for-loop rather than a nullglob array:
# an unmatched glob stays literal, the -f test rejects it, and nothing is
# dereferenced under set -u. Bash 3.2 / Git Bash safe: no arrays
# (matches Vault/Scripts/update.sh:8 and tool-check.sh:11).
OUT_FILE=""
for existing in "$CAP_ROOT"/*/*"${SESSION_ID}".md; do
  [ -f "$existing" ] || continue
  OUT_FILE="$existing"
  break
done
NEW_SESSION_FILE=false
if [ -z "$OUT_FILE" ]; then
  mkdir -p "$OUT_DIR" 2>/dev/null || exit 0
  OUT_FILE="$OUT_DIR/${DATE}-${SESSION_ID}.md"
  NEW_SESSION_FILE=true
fi

# --- Idempotency key: turn_number, falling back to the last assistant
# transcript entry's uuid if turn_number is absent/empty.
KEY="$TURN_NUM"
if [ -z "$KEY" ]; then
  KEY=$(jq -r '
    select(.type == "assistant") | .uuid // empty
  ' "$TRANSCRIPT" 2>/dev/null | tail -n 1)
fi
[ -n "$KEY" ] || exit 0

# Already captured this turn — skip (handles double-Stop fires; does NOT
# collide with legitimately repeated identical text, since the key is the
# turn, not the text).
if [ -f "$OUT_FILE" ] && grep -qF "<!-- capture: turn=${KEY} " "$OUT_FILE" 2>/dev/null; then
  exit 0
fi

# --- Extract the last genuine human user turn from the transcript, scanning
# backward and skipping any "user" entry that is actually a tool_result.
USER_TEXT=$(jq -r '
  select(.type == "user") |
  select(.isSidechain != true) |
  select(
    (.message.content | type) == "string"
    or (
      (.message.content | type) == "array"
      and ([.message.content[] | select(.type == "tool_result")] | length) == 0
    )
  ) |
  select(has("tool_use_id") | not) |
  (
    if (.message.content | type) == "string" then .message.content
    else (.message.content | map(select(.type == "text") | .text) | join("\n"))
    end
  )
' "$TRANSCRIPT" 2>/dev/null | tail -n 1)

if [ -z "$USER_TEXT" ]; then
  USER_TEXT="(no human turn found)"
fi

# --- Assistant text: prefer last_assistant_message from stdin, else fall
# back to the last assistant text block in the transcript.
ASSISTANT_TEXT="$LAST_ASSISTANT"
if [ -z "$ASSISTANT_TEXT" ]; then
  ASSISTANT_TEXT=$(jq -r '
    select(.type == "assistant") |
    select(.isSidechain != true) |
    (
      if (.message.content | type) == "string" then .message.content
      else (.message.content | map(select(.type == "text") | .text) | join("\n"))
      end
    )
  ' "$TRANSCRIPT" 2>/dev/null | tail -n 1)
fi
[ -n "$ASSISTANT_TEXT" ] || ASSISTANT_TEXT="(no assistant turn found)"

TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Size bound: a single long session must not grow without limit. At 1 MB the
# current file is renamed to a .partN.md sibling and the next append starts a
# fresh file. The rename target deliberately does NOT end in
# "${SESSION_ID}.md", so the reuse glob above will not pick it up again.
# Placed here, after every early exit and after the duplicate-turn check: a
# rotation earlier would fire on turns that then exit without writing, and
# would leave the duplicate-turn grep reading the post-rotation empty file.
CAP_MAX_BYTES=1048576
if [ -f "$OUT_FILE" ]; then
  # wc -c, not stat — stat's flags differ between BSD and GNU.
  CUR_BYTES=$(wc -c < "$OUT_FILE" 2>/dev/null | tr -d '[:space:]')
  case "$CUR_BYTES" in ''|*[!0-9]*) CUR_BYTES=0 ;; esac
  if [ "$CUR_BYTES" -gt "$CAP_MAX_BYTES" ]; then
    n=1
    while [ -f "${OUT_FILE%.md}.part${n}.md" ]; do n=$((n + 1)); done
    mv "$OUT_FILE" "${OUT_FILE%.md}.part${n}.md" 2>/dev/null || true
  fi
fi

# Header on first write to a new session file.
if [ ! -f "$OUT_FILE" ]; then
  printf '# Session %s — captured turns\n\n' "$SESSION_ID" > "$OUT_FILE" 2>/dev/null || exit 0
fi

# Redact before writing. Fail closed: a placeholder beats a leaked secret.
# The guard is genuinely reachable — USER_TEXT already falls back to the
# literal "(no human turn found)" above, which survives redaction, so an empty
# result here means the pass failed rather than the turn being empty.
USER_TEXT_SAFE=$(printf '%s' "$USER_TEXT" | redact)
[ -n "$USER_TEXT_SAFE" ] || USER_TEXT_SAFE="(capture suppressed — redaction pass produced no output)"
ASSISTANT_TEXT_SAFE=$(printf '%s' "$ASSISTANT_TEXT" | redact)
[ -n "$ASSISTANT_TEXT_SAFE" ] || ASSISTANT_TEXT_SAFE="(capture suppressed — redaction pass produced no output)"

# Build the block in a temp file, then append atomically in one shot —
# avoids interleaving a partial block if the process is interrupted mid-write.
TMP_BLOCK=$(mktemp "${TMPDIR:-/tmp}/capture-log.XXXXXX" 2>/dev/null) || exit 0

{
  printf '<!-- capture: turn=%s ts=%s session=%s -->\n' "$KEY" "$TS" "$SESSION_ID"
  printf '## Turn %s — %s\n' "$KEY" "$TS"
  printf '**User:**\n'
  printf '%s\n' "$USER_TEXT_SAFE"
  printf '\n**Assistant:**\n'
  printf '%s\n' "$ASSISTANT_TEXT_SAFE"
  printf '\n---\n\n'
} > "$TMP_BLOCK" 2>/dev/null

cat "$TMP_BLOCK" >> "$OUT_FILE" 2>/dev/null
rm -f "$TMP_BLOCK" 2>/dev/null

# Age bound: drop captures older than 90 days. Gated on NEW_SESSION_FILE and
# placed after the write, so it runs once per session rather than once per
# turn — gating alone is not enough, because a turn that exits early never
# creates the file and the next turn would set the flag again.
# -exec rm -f {} + rather than -delete, which is not portable across BSD and
# GNU find.
CAP_RETAIN_DAYS=90
if [ "$NEW_SESSION_FILE" = "true" ] && [ -d "$CAP_ROOT" ] && command -v find >/dev/null 2>&1; then
  find "$CAP_ROOT" -type f -name '*.md' -mtime "+${CAP_RETAIN_DAYS}" -exec rm -f {} + 2>/dev/null || true
fi

exit 0
