#!/usr/bin/env bash
# SessionStart hook — throttled upstream template-update + tool-freshness check.
# MUST always exit 0 (non-zero blocks the session). Silent unless behind.

set -u

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
  # $1 = last_seen_origin sha (may be empty when the template section was
  # skipped or the fetch failed)
  mkdir -p "Vault/Memory" 2>/dev/null || true
  NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
  {
    printf 'last_check=%s\n' "$NOW_EPOCH"
    printf 'last_seen_origin=%s\n' "${1:-}"
  } > "$STATE_FILE" 2>/dev/null || true
}

# Throttle — shared across both sections. Skip if checked within the last
# 24h. This is the only early exit before the two sections run.
if [ -f "$STATE_FILE" ]; then
  LAST_CHECK="$(sed -n 's/^last_check=//p' "$STATE_FILE" 2>/dev/null | head -1)"
  [ -z "$LAST_CHECK" ] && LAST_CHECK=0
  NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
  ELAPSED=$((NOW_EPOCH - LAST_CHECK))
  if [ "$LAST_CHECK" -gt 0 ] && [ "$ELAPSED" -lt 86400 ]; then
    emit_silent
  fi
fi

# ---------------------------------------------------------------------------
# Template section — skipped (not exited) on: maintainer clone, not a git
# repo, no local/main or main, mid-rebase/merge, no origin remote, fetch
# failure. Any skip leaves TEMPLATE_CTX empty and ORIGIN_SHA empty; the tool
# section below always still runs.
# ---------------------------------------------------------------------------
TEMPLATE_CTX=""
ORIGIN_SHA=""

if [ "${CLAUDE_TEMPLATE_MAINTAINER:-}" = "1" ]; then
  : # maintainer clone — template section skipped, tool checks still run
elif ! git rev-parse --git-dir >/dev/null 2>&1; then
  :
elif ! git rev-parse --verify local/main >/dev/null 2>&1 || ! git rev-parse --verify main >/dev/null 2>&1; then
  :
elif GITDIR="$(git rev-parse --git-dir 2>/dev/null)" && [ -n "$GITDIR" ] && { [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ] || [ -f "$GITDIR/MERGE_HEAD" ]; }; then
  :
elif ! git remote get-url origin >/dev/null 2>&1; then
  :
else
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
  else
    ORIGIN_SHA="$(git rev-parse origin/main 2>/dev/null || echo "")"

    BEHIND="$(git rev-list --count main..origin/main 2>/dev/null)"
    [ -z "$BEHIND" ] && BEHIND=0

    if [ "$BEHIND" -gt 0 ]; then
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

      TEMPLATE_CTX="=== TEMPLATE UPDATE AVAILABLE ===

This vault's template is $BEHIND commit(s) behind upstream (origin/main).

Recent upstream changes:
${BULLETS}"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Tool section — always runs after the throttle gate, regardless of the
# template section's outcome (git-repo state, maintainer var, offline).
# ---------------------------------------------------------------------------
TOOLS_CTX=""
if [ -f "Vault/Scripts/tool-check.sh" ]; then
  TOOL_OUT="$(bash Vault/Scripts/tool-check.sh 2>/dev/null)"
  if [ -n "$TOOL_OUT" ]; then
    TOOLS_CTX="=== TOOL UPDATES AVAILABLE ===

${TOOL_OUT}
"
  fi
fi

stamp_state "$ORIGIN_SHA"

if [ -z "$TEMPLATE_CTX" ] && [ -z "$TOOLS_CTX" ]; then
  emit_silent
fi

CTX="${TEMPLATE_CTX}${TOOLS_CTX}ACTION: Mention in one short line that a template update and/or a tool update (herdr / plannotator) is available and suggest the user run /update when convenient. Do not run any update automatically."

emit_context "$CTX"
