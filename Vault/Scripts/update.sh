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
#   2 not a git repository        7 main could not be updated safely
#   3 local/main (or main) missing 8 rebase conflict (left mid-rebase)
#   4 rebase/merge already in progress
#   9 already up to date
#  10 not on local/main (unattended mode only)
#
# Modes:
#   (no args)      interactive /update — a conflict is left mid-rebase for
#                  the user to resolve.
#   --unattended   the daily SessionStart hook path. Same mechanics, two
#                  differences: it refuses to run unless HEAD is already on
#                  local/main (exit 10), and it cancels its own conflicted
#                  rebase instead of leaving the repo mid-rebase (exit 8).
#
# The auto-cancel is the single sanctioned exception to the rule that this
# vault never runs `git rebase --abort` on a user's behalf. It exists because
# a hook cannot ask a question: leaving a session that has just started
# sitting in a conflicted rebase the user did not ask for is worse than
# rolling back and telling them to run /update when they are ready.
# Cancelling also has to reset `main` to the SHA it held just before the
# fast-forward (`git branch -f main "$OLD_MAIN"` — safe here because HEAD is
# on local/main, so main is not checked out). After a Step 7 realignment
# (plan 190) that is the realigned point, the merge base with origin/main,
# not the commit main started on; nothing is lost, because those commits are
# on local/main. Without that reset, main stays fast-forwarded, the hook's
# `main..origin/main` count reads 0 on every later session, and the conflict
# the user still needs to resolve goes silent forever.

set -u

UNATTENDED=false
[ "${1:-}" = "--unattended" ] && UNATTENDED=true

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
# Drive for desktop drops the git hooks' exec bit; restore it on every run (plan 154).
chmod +x .githooks/pre-commit .githooks/pre-push 2>/dev/null || true

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
# Step 3b — unattended mode only: HEAD must already be on local/main
#
# The interactive path can check out local/main itself in Step 8 because a
# person is watching. Unattended, moving someone off the branch they were
# working on is not a decision a hook gets to make.
# ---------------------------------------------------------------------------
if [ "$UNATTENDED" = "true" ]; then
  HEAD_BRANCH="$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "")"
  if [ "$HEAD_BRANCH" != "local/main" ]; then
    fail 10 "Automatic update skipped — this vault is on '${HEAD_BRANCH:-a detached HEAD}', not local/main. Switch back and run /update when convenient."
  fi
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
  case "$DIRTY" in
    *".vscode/settings.json"*)
      echo "Note: .vscode/settings.json was edited by an older onboarding step (retired by plan 185). If 'git diff -- .vscode/settings.json' shows only a \"git.enabled\" line, clear it with: git checkout -- .vscode/settings.json"
      ;;
  esac
  echo "Note: if a file shows as modified here but 'git diff -- <file>' is empty, it is a Google Drive sync phantom — clear it with: git checkout -- <file>"
  exit 5
fi

# ---------------------------------------------------------------------------
# Step 6 — fetch latest from origin
# ---------------------------------------------------------------------------
# Bounded-hang fetch — same speed floor the SessionStart hook uses, so an
# unreachable origin fails in seconds instead of stalling a session start.
# The fetch also refuses to prompt, because /update is run by the agent
# without a terminal as well as by the hook (plan 188). GIT_TERMINAL_PROMPT=0
# makes git fail instead of asking, GCM_INTERACTIVE does the same for Git
# Credential Manager on Windows, and an empty GIT_ASKPASS stops git calling
# any askpass pop-up helper (GIT_ASKPASS, core.askPass or SSH_ASKPASS); saved-
# credential helpers still answer. For an SSH remote, BatchMode with a
# ConnectTimeout makes ssh fail instead of prompting. The user's own ssh
# command (GIT_SSH_COMMAND, else core.sshCommand) is kept and only extended.
# A plink or TortoisePlink command is left untouched because plink rejects
# OpenSSH -o options, and a user who sets only GIT_SSH keeps that program
# because GIT_SSH_COMMAND is then not exported at all, since git would let it
# override GIT_SSH.
FETCH_SSH="${GIT_SSH_COMMAND:-$(git config --get core.sshCommand 2>/dev/null || true)}"
case "$FETCH_SSH" in
  *[Pp][Ll][Ii][Nn][Kk]*) ;;
  "") [ -n "${GIT_SSH:-}" ] || FETCH_SSH="ssh -o BatchMode=yes -o ConnectTimeout=10" ;;
  *) FETCH_SSH="$FETCH_SSH -o BatchMode=yes -o ConnectTimeout=10" ;;
esac
if ! (
  [ -z "$FETCH_SSH" ] || export GIT_SSH_COMMAND="$FETCH_SSH"
  GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never GIT_ASKPASS= \
    git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 fetch origin >/dev/null 2>&1
); then
  fail 6 "Failed to fetch from origin. Check your network connection, your git credentials and the remote configuration." \
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
# Step 7 — realign a main that is ahead of origin, then fast-forward main
# ---------------------------------------------------------------------------
# A teammate who commits on main before onboarding creates local/main ends up
# with those commits on both branches, because the onboarding hook copies main
# to make local/main. Main is then ahead of origin/main, and the old check
# here stopped every later update with exit 7 (plan 190). When every commit on
# main is also on local/main, moving main back loses nothing, so it is done
# automatically. Main moves to its merge base with origin/main, not to
# origin/main itself, so the behind count, OLD_MAIN, the incoming-changes
# list, the unattended rollback and the exit 9 case below all run unchanged.
AHEAD="$(git rev-list --count origin/main..main 2>/dev/null)"
[ -z "$AHEAD" ] && AHEAD=0
if [ "$AHEAD" -gt 0 ]; then
  # A commit on main that is not on local/main would be lost by moving main,
  # so stop and say how to bring it onto local/main first. A merge, not a
  # cherry-pick, is advised because only a merge makes main an ancestor of
  # local/main, which lets the next run pass this test (plan 190).
  if ! git merge-base --is-ancestor main local/main 2>/dev/null; then
    fail 7 "Local main has commits that are not on local/main, so /update has not moved any branch." \
      "To keep those commits, run these two commands, then re-run /update:" \
      "  git checkout local/main" \
      "  git merge --no-edit main"
  fi
  MAIN_BASE="$(git merge-base main origin/main 2>/dev/null)"
  if [ -z "$MAIN_BASE" ]; then
    fail 1 "Unexpected failure: local main and origin/main share no history, so main cannot be realigned."
  fi
  # git branch -f refuses to move the checked-out branch. Only an interactive
  # run can be on main here, because Step 3b stops an unattended run that is
  # not on local/main, and Step 8 would check out local/main anyway (plan 190).
  if [ "$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "")" = "main" ]; then
    if ! git checkout local/main >/dev/null 2>&1; then
      fail 1 "Unexpected failure: could not check out local/main to realign main. No branch was moved."
    fi
    echo "Switched to local/main."
  fi
  if ! git branch -f main "$MAIN_BASE" >/dev/null 2>&1; then
    fail 1 "Unexpected failure: could not realign main with the template. Your commits are still on local/main." \
      "Re-run /update once no other git process is running."
  fi
  echo "Realigned main with the template; no commits were lost (they are on local/main)."
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
    fail 7 "Could not fast-forward main to origin/main. Nothing was rebased and local/main is unchanged." \
      "Re-run /update once no other git process is running. Inspect with: git log --oneline main..origin/main"
  fi
else
  if ! git fetch . origin/main:main >/dev/null 2>&1; then
    fail 7 "Could not fast-forward main to origin/main. Nothing was rebased and local/main is unchanged." \
      "Re-run /update once no other git process is running. Inspect with: git log --oneline main..origin/main"
  fi
fi

# ---------------------------------------------------------------------------
# Step 8 — rebase local/main onto fresh main
# ---------------------------------------------------------------------------
# Unattended only: skip the checkout. The exit-10 guard at Step 3b already
# proved HEAD is on local/main, and nothing between there and here moves
# HEAD — so the checkout is redundant, and worse, it acquires index.lock
# even when HEAD is already on the target branch. With index.lock held by a
# concurrent process, that redundant acquisition is what previously made
# this run die here (fail 1) with main already fast-forwarded above and no
# rollback. Interactive mode keeps the checkout unchanged: a person may be
# on any branch, and this is what moves HEAD onto local/main for them.
if [ "$UNATTENDED" != "true" ]; then
  if ! git checkout local/main >/dev/null 2>&1; then
    fail 1 "Unexpected failure: could not check out local/main."
  fi
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

  # One-off Notes/ -> Inbox/ move (plan 179). Placed after the rebase: the
  # tracked Notes/ READMEs are gone by now, and Step 5's clean-tree check has
  # already passed, so moving git-ignored files cannot trip it.
  if [ -f "Vault/Scripts/migrate-notes-to-inbox.sh" ]; then
    bash Vault/Scripts/migrate-notes-to-inbox.sh --hook
  fi

  exit 0
elif [ "$UNATTENDED" = "true" ]; then
  if [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ]; then
    # Our own rebase attempt is what is in progress (Step 2 proved the repo
    # was not mid-rebase when we started) — cancel it and roll main back.
    # Capture the conflict list before aborting — the unmerged index is gone
    # once the rebase is cancelled.
    CONFLICTS="$(git diff --name-only --diff-filter=U 2>/dev/null)"
    if ! git rebase --abort >/dev/null 2>&1; then
      echo "RECOVERY FAILED: git rebase --abort did not complete — repo may be mid-rebase. Run /update to inspect."
    fi
    if ! git branch -f main "$OLD_MAIN" >/dev/null 2>&1; then
      echo "RECOVERY FAILED: could not reset main to $OLD_MAIN — run: git branch -f main $OLD_MAIN"
    fi
    echo "CONFLICTS (auto-cancelled — run /update to resolve interactively):"
    printf '%s\n' "$CONFLICTS"
  else
    # rebase failed without ever starting (e.g. another process holds
    # index.lock) — nothing of ours to abort, but Step 7's fetch fast-forward
    # already moved main (unattended always takes that branch: Step 3b
    # proved HEAD is on local/main, so CURRENT_BRANCH above is never "main")
    # — roll main back.
    if ! git branch -f main "$OLD_MAIN" >/dev/null 2>&1; then
      echo "RECOVERY FAILED: could not reset main to $OLD_MAIN — run: git branch -f main $OLD_MAIN"
    fi
    echo "Rebase could not start (another git process may be running). No rebase aborted; main rolled back. Run /update when the other operation finishes."
  fi
  exit 8
else
  echo "CONFLICTS:"
  git diff --name-only --diff-filter=U 2>/dev/null
  exit 8
fi
