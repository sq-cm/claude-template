#!/usr/bin/env bash
#
# update.sh — deterministic /update mechanics (two-branch model)
#
# Pulls template changes from origin/main into local/main via:
#   fetch origin -> fast-forward main -> rebase local/main onto main
#
# Bash 3.2 / Git Bash safe: no arrays, no `timeout`, POSIX+BSD/GNU portable.
# set -u only (not -e) — every failure path gets a controlled message + exit
# code instead of an uncontrolled abort.
#
# Exit codes:
#   0 success (rebase clean)      5 dirty working tree
#   1 unexpected failure          6 fetch failed
#   2 not a git repository        7 local main diverged from origin/main
#   3 local/main (or main) missing 8 rebase conflict (left mid-rebase)
#   4 rebase/merge already in progress
#   9 already up to date

set -u

STATE_FILE="Vault/Memory/.update-check-state"

fail() {
  # $1 = exit code, remaining args = message lines
  code="$1"
  shift
  for line in "$@"; do
    printf '%s\n' "$line"
  done
  exit "$code"
}

# ---------------------------------------------------------------------------
# Step 1 — resolve repo root, cd there
# ---------------------------------------------------------------------------
TOPLEVEL="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$TOPLEVEL" ]; then
  fail 2 "Not a git repository — /update cannot run."
fi
cd "$TOPLEVEL" || fail 1 "Could not cd to repo root: $TOPLEVEL"

# ---------------------------------------------------------------------------
# Step 2 — bail if a rebase or merge is already in progress
# ---------------------------------------------------------------------------
GITDIR="$(git rev-parse --git-dir 2>/dev/null)"
if [ -z "$GITDIR" ]; then
  fail 1 "Could not resolve .git directory."
fi
if [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ] || [ -f "$GITDIR/MERGE_HEAD" ]; then
  fail 4 "A rebase or merge is already in progress. Resolve it (git rebase --continue / --abort, or git merge --continue / --abort) before re-running /update."
fi

# ---------------------------------------------------------------------------
# Step 3 — local/main and main must both exist
# ---------------------------------------------------------------------------
if ! git rev-parse --verify local/main >/dev/null 2>&1 || ! git rev-parse --verify main >/dev/null 2>&1; then
  fail 3 "local/main branch not found. Run /onboard first to set up the two-branch model, then re-run /update."
fi

# ---------------------------------------------------------------------------
# Step 4 — DFS collision guard (non-fatal — summary passes through)
# ---------------------------------------------------------------------------
if [ -f "Vault/Scripts/git-dfs-guard.sh" ]; then
  DFS_OUT="$(bash Vault/Scripts/git-dfs-guard.sh 2>&1)"
  printf '%s\n' "$DFS_OUT"
fi

# ---------------------------------------------------------------------------
# Step 5 — clean working tree
# ---------------------------------------------------------------------------
DIRTY="$(git status --porcelain 2>/dev/null)"
if [ -n "$DIRTY" ]; then
  echo "You have uncommitted changes. Commit or stash them before updating, then re-run /update."
  echo ""
  echo "$DIRTY" | head -20
  echo ""
  echo "Note: if a file shows as modified here but 'git diff -- <file>' is empty, it is a Google Drive sync phantom — clear it with: git checkout -- <file>"
  exit 5
fi

# ---------------------------------------------------------------------------
# Step 6 — fetch latest from origin
# ---------------------------------------------------------------------------
if ! git fetch origin >/dev/null 2>&1; then
  fail 6 "Failed to fetch from origin. Check your network connection and remote configuration." \
    "If this persists and looks like local repo corruption, try: git fetch --refetch origin"
fi

# Successful fetch — record shared throttle state so the SessionStart hook
# stays quiet after a manual /update.
mkdir -p "Vault/Memory" 2>/dev/null || true
ORIGIN_SHA="$(git rev-parse origin/main 2>/dev/null || echo "")"
NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
{
  printf 'last_check=%s\n' "$NOW_EPOCH"
  printf 'last_seen_origin=%s\n' "$ORIGIN_SHA"
} > "$STATE_FILE" 2>/dev/null || true

# ---------------------------------------------------------------------------
# Step 7 — divergence check, then fast-forward main (no checkout when possible)
# ---------------------------------------------------------------------------
AHEAD="$(git rev-list --count origin/main..main 2>/dev/null)"
[ -z "$AHEAD" ] && AHEAD=0
if [ "$AHEAD" -gt 0 ]; then
  fail 7 "Local main has diverged from origin/main." \
    "Inspect with: git log main..origin/main    and    git log origin/main..main" \
    "Then reset with: git reset --hard origin/main    if local main commits are not needed."
fi

BEHIND="$(git rev-list --count main..origin/main 2>/dev/null)"
[ -z "$BEHIND" ] && BEHIND=0
if [ "$BEHIND" -eq 0 ]; then
  fail 9 "Already up to date. No template changes to pull."
fi

OLD_MAIN="$(git rev-parse main 2>/dev/null)"

CURRENT_BRANCH="$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "")"
if [ "$CURRENT_BRANCH" = "main" ]; then
  if ! git merge --ff-only origin/main >/dev/null 2>&1; then
    fail 7 "Local main has diverged from origin/main." \
      "Inspect with: git log main..origin/main    and    git log origin/main..main" \
      "Then reset with: git reset --hard origin/main    if local main commits are not needed."
  fi
else
  if ! git fetch . origin/main:main >/dev/null 2>&1; then
    fail 7 "Local main has diverged from origin/main." \
      "Inspect with: git log main..origin/main    and    git log origin/main..main" \
      "Then reset with: git reset --hard origin/main    if local main commits are not needed."
  fi
fi

# ---------------------------------------------------------------------------
# Step 8 — rebase local/main onto fresh main
# ---------------------------------------------------------------------------
if ! git checkout local/main >/dev/null 2>&1; then
  fail 1 "Unexpected failure: could not check out local/main."
fi

if git rebase main >/dev/null 2>&1; then
  echo "**Template updated.** \`local/main\` rebased onto fresh \`main\`. Your personal commits replay on top."
  echo ""
  echo "**Incoming template changes:**"

  LOG_LINES="$(git log --oneline --no-decorate "$OLD_MAIN"..main 2>/dev/null)"
  TOTAL="$(printf '%s\n' "$LOG_LINES" | grep -c .)"
  [ -z "$TOTAL" ] && TOTAL=0

  if [ "$TOTAL" -le 15 ]; then
    printf '%s\n' "$LOG_LINES" | while IFS= read -r line; do
      [ -n "$line" ] && printf -- '- %s\n' "$line"
    done
  else
    printf '%s\n' "$LOG_LINES" | head -15 | while IFS= read -r line; do
      [ -n "$line" ] && printf -- '- %s\n' "$line"
    done
    MORE=$((TOTAL - 15))
    echo "…and $MORE more — see CHANGELOG.md"
  fi

  exit 0
else
  echo "CONFLICTS:"
  git diff --name-only --diff-filter=U 2>/dev/null
  exit 8
fi
