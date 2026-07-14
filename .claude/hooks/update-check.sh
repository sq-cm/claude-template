#!/usr/bin/env bash
# SessionStart hook — throttled upstream template-update check.
# MUST always exit 0 (non-zero blocks the session). Silent unless behind.

set -u

# Maintainer short-circuit
if [ "${CLAUDE_TEMPLATE_MAINTAINER:-}" = "1" ]; then exit 0; fi

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi
cd "$DIR" 2>/dev/null || exit 0

STATE_FILE="Vault/Memory/.update-check-state"
ERROR_LOG="Vault/Memory/update-check-errors.md"

emit_silent() { exit 0; }

emit_context() {
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' \
    "$(printf '%s' "$1" | jq -Rs . 2>/dev/null || printf '"%s"' "$1")"
  exit 0
}

log_error() {
  mkdir -p "Vault/Memory" 2>/dev/null || true
  printf '%s — %s\n' "$(date -u +%FT%TZ 2>/dev/null || echo '?')" "$1" \
    >> "$ERROR_LOG" 2>/dev/null || true
}

stamp_state() {
  # $1 = last_seen_origin sha (may be empty on failure)
  mkdir -p "Vault/Memory" 2>/dev/null || true
  NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
  {
    printf 'last_check=%s\n' "$NOW_EPOCH"
    printf 'last_seen_origin=%s\n' "${1:-}"
  } > "$STATE_FILE" 2>/dev/null || true
}

# Silent skips: not a git repo / no local/main / mid-rebase-merge / no origin
if ! git rev-parse --git-dir >/dev/null 2>&1; then emit_silent; fi
if ! git rev-parse --verify local/main >/dev/null 2>&1 || ! git rev-parse --verify main >/dev/null 2>&1; then
  emit_silent
fi
GITDIR="$(git rev-parse --git-dir 2>/dev/null)"
if [ -n "$GITDIR" ] && { [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ] || [ -f "$GITDIR/MERGE_HEAD" ]; }; then
  emit_silent
fi
if ! git remote get-url origin >/dev/null 2>&1; then emit_silent; fi

# Throttle — skip if checked within the last 24h
if [ -f "$STATE_FILE" ]; then
  LAST_CHECK="$(sed -n 's/^last_check=//p' "$STATE_FILE" 2>/dev/null | head -1)"
  [ -z "$LAST_CHECK" ] && LAST_CHECK=0
  NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
  ELAPSED=$((NOW_EPOCH - LAST_CHECK))
  if [ "$LAST_CHECK" -gt 0 ] && [ "$ELAPSED" -lt 86400 ]; then
    emit_silent
  fi
fi

# DFS collision guard — output appended to error log, never surfaced.
# The guard always prints a summary line (even a 0/0 no-op); only log it
# when it actually removed something.
if [ -f "Vault/Scripts/git-dfs-guard.sh" ]; then
  DFS_OUT="$(bash Vault/Scripts/git-dfs-guard.sh 2>&1)"
  case "$DFS_OUT" in
    *"removed 0 junk refs, 0 twin duplicates"*) : ;;
    *) [ -n "$DFS_OUT" ] && log_error "git-dfs-guard: $DFS_OUT" ;;
  esac
fi

# Bounded-hang fetch (offline machines must not block session start)
if ! git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 fetch --quiet origin >/dev/null 2>&1; then
  log_error "update-check fetch failed (offline or unreachable origin)"
  stamp_state ""
  emit_silent
fi

ORIGIN_SHA="$(git rev-parse origin/main 2>/dev/null || echo "")"
stamp_state "$ORIGIN_SHA"

BEHIND="$(git rev-list --count main..origin/main 2>/dev/null)"
[ -z "$BEHIND" ] && emit_silent
[ "$BEHIND" -eq 0 ] && emit_silent

# Recent upstream commit subjects — shas stripped, quotes stripped (jq-less
# fallback below does not escape quotes, so strip them at the source).
SUBJECTS="$(git log --oneline --no-decorate main..origin/main 2>/dev/null | cut -d' ' -f2- | tr -d '"')"

BULLETS=""
i=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  i=$((i + 1))
  if [ "$i" -le 5 ]; then
    BULLETS="${BULLETS}- ${line}
"
  fi
done <<EOF
$SUBJECTS
EOF

if [ "$i" -gt 5 ]; then
  MORE=$((i - 5))
  BULLETS="${BULLETS}…and $MORE more
"
fi

CTX="=== TEMPLATE UPDATE AVAILABLE ===

This vault's template is $BEHIND commit(s) behind upstream (origin/main).

Recent upstream changes:
${BULLETS}
ACTION: Mention in one short line that a template update is available and suggest the user run /update when convenient. Do not run /update automatically."

emit_context "$CTX"
