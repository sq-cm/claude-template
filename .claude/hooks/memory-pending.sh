#!/usr/bin/env bash
# memory-pending.sh — deterministic memory-reconcile nudge (plan 018).
# Wired under PreCompact and SessionEnd in .claude/settings.json: counts pending
# session notes in Vault/Memory/Sessions/ and emits a one-line reminder so notes
# don't silently age out when a session compacts or ends. Read-only — never
# writes into Vault/Memory/. Must ALWAYS exit 0 (non-blocking hook).

set -u

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi

SESSIONS_DIR="$DIR/Vault/Memory/Sessions"

if [ -d "$SESSIONS_DIR" ]; then
  # Top-level notes only — _rejected/ and other subdirectories don't count as pending.
  COUNT=$(find "$SESSIONS_DIR" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "${COUNT:-0}" -gt 0 ] 2>/dev/null; then
    echo "${COUNT} session note(s) pending in Vault/Memory/Sessions/ — run /memory-reconcile to fold them into context.md (and, for project-tagged notes, that project's HISTORY.md) before they age out."
  fi
fi

exit 0
