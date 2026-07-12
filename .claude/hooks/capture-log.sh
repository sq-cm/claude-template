#!/usr/bin/env bash
# capture-log.sh — unattended, deterministic, per-turn raw capture of every
# Stop event (Notes/Personal/Claude-Code-Memory-Plan-implementation-plan.md,
# Phase 1). Additive to, not a replacement for, the curated /log-session flow
# and the existing nudge Stop hook — writes verbatim, no model call, no
# summarisation. Never touches Vault/Memory/. Must ALWAYS exit 0.

set -u

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi

# Fail-safe: no jq, no capture. Better to capture nothing than corrupt a file.
command -v jq >/dev/null 2>&1 || exit 0

INPUT="$(cat)"

SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
TRANSCRIPT=$(printf '%s' "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
TURN_NUM=$(printf '%s' "$INPUT" | jq -r '.turn_number // empty' 2>/dev/null)
LAST_ASSISTANT=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // empty' 2>/dev/null)

[ -n "$SESSION_ID" ] || exit 0
[ -n "$TRANSCRIPT" ] || exit 0
[ -f "$TRANSCRIPT" ] || exit 0

YEAR=$(date +%Y)
OUT_DIR="$DIR/Vault/Logs/Sessions/$YEAR"
mkdir -p "$OUT_DIR" 2>/dev/null || exit 0
OUT_FILE="$OUT_DIR/${SESSION_ID}.md"

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

# Header on first write to a new session file.
if [ ! -f "$OUT_FILE" ]; then
  printf '# Session %s — captured turns\n\n' "$SESSION_ID" > "$OUT_FILE" 2>/dev/null || exit 0
fi

# Build the block in a temp file, then append atomically in one shot —
# avoids interleaving a partial block if the process is interrupted mid-write.
TMP_BLOCK=$(mktemp "${TMPDIR:-/tmp}/capture-log.XXXXXX" 2>/dev/null) || exit 0

{
  printf '<!-- capture: turn=%s ts=%s session=%s -->\n' "$KEY" "$TS" "$SESSION_ID"
  printf '## Turn %s — %s\n' "$KEY" "$TS"
  printf '**User:**\n'
  printf '%s\n' "$USER_TEXT"
  printf '\n**Assistant:**\n'
  printf '%s\n' "$ASSISTANT_TEXT"
  printf '\n---\n\n'
} > "$TMP_BLOCK" 2>/dev/null

cat "$TMP_BLOCK" >> "$OUT_FILE" 2>/dev/null
rm -f "$TMP_BLOCK" 2>/dev/null

exit 0
