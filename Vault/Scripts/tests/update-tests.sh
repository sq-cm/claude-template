#!/usr/bin/env bash
#
# update-tests.sh — characterization test harness for Vault/Scripts/update.sh
#
# Pins the exit-code contract documented at update.sh:12-19 (10 codes) using
# throwaway git fixtures built under mktemp -d. Every fixture is a bare
# "origin" repo plus a clone carrying the vault's two-branch model (`main`
# tracking origin, `local/main` with one commit on top). update.sh is
# invoked by absolute path, always with `cd` into the fixture — the real
# vault's git state (branches, `Vault/Memory/.update-check-state`) is never
# touched.
#
# This is a CHARACTERIZATION harness: it pins update.sh's current
# behaviour, defects included. It does not modify update.sh. A future
# change to update.sh's contract updates the asserts here to match — see
# Vault/Plans/README.md plan 115.
#
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`. `set -u`
# only (not -e), matching update.sh and tool-check.sh.
#
# Exit 1 (unexpected failure) is intentionally NOT covered: every fail-1
# site in update.sh (git-dir resolution failing after a repo was already
# confirmed to exist, a checkout of a branch just confirmed to exist
# failing) requires corrupting git internals mid-run in a way that has no
# reliable, portable trigger from a shell fixture. Documented gap, not an
# oversight.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
UPDATE_SH="$PROJECT_ROOT/Vault/Scripts/update.sh"

if [ ! -f "$UPDATE_SH" ]; then
  echo "FATAL: update.sh not found at $UPDATE_SH" >&2
  exit 1
fi

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

TOTAL=0
FAILED=0
FIXTURE_N=0

# ---------------------------------------------------------------------------
# Assert helpers
# ---------------------------------------------------------------------------

assert_exit() {
  # $1 = label, $2 = expected exit code, $3 = actual exit code
  label="$1"
  expected="$2"
  actual="$3"
  TOTAL=$((TOTAL + 1))
  if [ "$actual" = "$expected" ]; then
    echo "ok - $label (exit $actual)"
  else
    echo "FAIL - $label (expected exit $expected, got $actual)"
    FAILED=$((FAILED + 1))
  fi
}

assert_eq() {
  # $1 = label, $2 = expected, $3 = actual
  label="$1"
  expected="$2"
  actual="$3"
  TOTAL=$((TOTAL + 1))
  if [ "$expected" = "$actual" ]; then
    echo "ok - $label"
  else
    echo "FAIL - $label (expected [$expected], got [$actual])"
    FAILED=$((FAILED + 1))
  fi
}

assert_contains() {
  # $1 = label, $2 = haystack, $3 = needle
  label="$1"
  haystack="$2"
  needle="$3"
  TOTAL=$((TOTAL + 1))
  case "$haystack" in
    *"$needle"*)
      echo "ok - $label"
      ;;
    *)
      echo "FAIL - $label (expected to find [$needle] in output)"
      FAILED=$((FAILED + 1))
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Fixture helpers
# ---------------------------------------------------------------------------

configure_repo() {
  # $1 = repo path — set identity + disable signing so a machine's global
  # gpgsign config can't hang a fixture commit waiting on a passphrase.
  git -C "$1" config user.email "test@example.invalid"
  git -C "$1" config user.name "Test Fixture"
  git -C "$1" config commit.gpgsign false
}

fixture_gitdir() {
  # $1 = repo path — echoes the absolute path to its .git dir
  d="$(cd "$1" && git rev-parse --git-dir)"
  case "$d" in
    /*) printf '%s\n' "$d" ;;
    *) printf '%s\n' "$1/$d" ;;
  esac
}

# make_fixture: builds one fresh bare "origin" + a clone with the two-branch
# model (main tracking origin, local/main with one local commit on top of
# main). Sets FIXTURE_DIR to the fixture (clone) path — called as a plain
# statement, NEVER via $(...): command substitution forks a subshell, and
# the FIXTURE_N counter increment would be lost on return, silently
# reusing (colliding on) the same fixture directory for every test case.
# Every call gets its own origin — never reuse a fixture, or its origin,
# across test cases.
make_fixture() {
  FIXTURE_N=$((FIXTURE_N + 1))
  n="$FIXTURE_N"
  origin="$TMP_ROOT/origin-$n.git"
  seed="$TMP_ROOT/seed-$n"
  fixture="$TMP_ROOT/fixture-$n"

  git init -q --bare "$origin"
  git -C "$origin" symbolic-ref HEAD refs/heads/main

  git init -q "$seed"
  git -C "$seed" symbolic-ref HEAD refs/heads/main
  configure_repo "$seed"
  # Mirrors the real vault's .gitignore:99 — without this, update.sh's
  # successful-fetch stamp leaves an untracked state file and a SECOND run
  # in the same fixture would exit 5 (dirty tree) for the wrong reason.
  printf 'Vault/Memory/.update-check-state\n' > "$seed/.gitignore"
  printf 'seed line one\n' > "$seed/seed.txt"
  printf 'other content\n' > "$seed/other.txt"
  git -C "$seed" add -A
  git -C "$seed" commit -q -m "seed commit"
  git -C "$seed" remote add origin "$origin"
  git -C "$seed" push -q origin main

  git clone -q "$origin" "$fixture"
  configure_repo "$fixture"
  git -C "$fixture" checkout -q -b local/main main
  printf 'local change to seed line\n' > "$fixture/seed.txt"
  git -C "$fixture" commit -qam "local commit on local/main"

  FIXTURE_DIR="$fixture"
}

# run_update FIXTURE_DIR [--unattended]
#   Invokes update.sh by absolute path with cd into the fixture. Sets
#   LAST_OUT (combined stdout+stderr) and LAST_CODE globally.
run_update() {
  fixture_dir="$1"
  mode="${2:-}"
  LAST_OUT="$(cd "$fixture_dir" && bash "$UPDATE_SH" $mode 2>&1)"
  LAST_CODE=$?
}

# ---------------------------------------------------------------------------
# Step 2: guard exits — 2, 3, 4, 5, 10
# ---------------------------------------------------------------------------

# exit 2: not a git repository
PLAIN_DIR="$TMP_ROOT/plain-dir"
mkdir -p "$PLAIN_DIR"
run_update "$PLAIN_DIR"
assert_exit "exit 2: not a git repository" 2 "$LAST_CODE"

# exit 3: local/main (or main) missing
make_fixture
F3="$FIXTURE_DIR"
git -C "$F3" checkout -q main
git -C "$F3" branch -D local/main >/dev/null
run_update "$F3"
assert_exit "exit 3: local/main missing" 3 "$LAST_CODE"

# exit 4: rebase/merge already in progress
make_fixture
F4="$FIXTURE_DIR"
GD4="$(fixture_gitdir "$F4")"
mkdir -p "$GD4/rebase-merge"
run_update "$F4"
assert_exit "exit 4: rebase already in progress" 4 "$LAST_CODE"
rm -rf "$GD4/rebase-merge"

# exit 5: dirty working tree
make_fixture
F5="$FIXTURE_DIR"
printf 'uncommitted\n' >> "$F5/seed.txt"
run_update "$F5"
assert_exit "exit 5: dirty working tree" 5 "$LAST_CODE"

# exit 10: unattended mode, HEAD not on local/main
make_fixture
F10="$FIXTURE_DIR"
ORIGIN10="$(git -C "$F10" remote get-url origin)"
PUSHCLONE10="$TMP_ROOT/pushclone-10"
git clone -q "$ORIGIN10" "$PUSHCLONE10"
configure_repo "$PUSHCLONE10"
printf 'origin advance\n' >> "$PUSHCLONE10/other.txt"
git -C "$PUSHCLONE10" commit -qam "origin advances (exit 10 fixture)"
git -C "$PUSHCLONE10" push -q origin main
git -C "$F10" checkout -q main
run_update "$F10" "--unattended"
assert_exit "exit 10: unattended off local/main" 10 "$LAST_CODE"

# ---------------------------------------------------------------------------
# Step 3: network/state exits — 6, 7, 9
# ---------------------------------------------------------------------------

# exit 6: fetch failed
make_fixture
F6="$FIXTURE_DIR"
git -C "$F6" remote set-url origin /nonexistent/nowhere.git
run_update "$F6"
assert_exit "exit 6: fetch failed" 6 "$LAST_CODE"

# exit 7: local main diverged from origin/main
make_fixture
F7="$FIXTURE_DIR"
git -C "$F7" checkout -q main
printf 'local main only change\n' >> "$F7/seed.txt"
git -C "$F7" commit -qam "local main diverges"
run_update "$F7"
assert_exit "exit 7: main diverged from origin/main" 7 "$LAST_CODE"

# exit 9: already up to date — plus the state-file side effect
make_fixture
F9="$FIXTURE_DIR"
run_update "$F9"
assert_exit "exit 9: already up to date" 9 "$LAST_CODE"
STATE_FILE_9="$F9/Vault/Memory/.update-check-state"
if [ -f "$STATE_FILE_9" ]; then
  STATE_EXISTS_9=true
else
  STATE_EXISTS_9=false
fi
assert_eq "exit 9: state file written inside fixture" "true" "$STATE_EXISTS_9"
STATE_CONTENT_9="$(cat "$STATE_FILE_9" 2>/dev/null)"
assert_contains "exit 9: state file contains last_check=" "$STATE_CONTENT_9" "last_check="

# ---------------------------------------------------------------------------
# Step 4: happy path (0) and interactive conflict (8)
# ---------------------------------------------------------------------------

# exit 0: clean rebase, non-conflicting template advance
make_fixture
F0="$FIXTURE_DIR"
ORIGIN0="$(git -C "$F0" remote get-url origin)"
PUSHCLONE0="$TMP_ROOT/pushclone-0"
git clone -q "$ORIGIN0" "$PUSHCLONE0"
configure_repo "$PUSHCLONE0"
printf 'template advance content\n' >> "$PUSHCLONE0/other.txt"
git -C "$PUSHCLONE0" commit -qam "template advances cleanly"
git -C "$PUSHCLONE0" push -q origin main
NEW_ORIGIN_SHA_0="$(git -C "$PUSHCLONE0" rev-parse main)"

run_update "$F0"
assert_exit "exit 0: happy path rebase" 0 "$LAST_CODE"
FIXTURE_MAIN_SHA_0="$(git -C "$F0" rev-parse main)"
assert_eq "exit 0: main fast-forwarded to origin's new SHA" "$NEW_ORIGIN_SHA_0" "$FIXTURE_MAIN_SHA_0"
LOCALMAIN_LOG_0="$(git -C "$F0" log --oneline local/main)"
case "$LOCALMAIN_LOG_0" in
  *"local commit on local/main"*) HAS_LOCAL_0=true ;;
  *) HAS_LOCAL_0=false ;;
esac
case "$LOCALMAIN_LOG_0" in
  *"template advances cleanly"*) HAS_TEMPLATE_0=true ;;
  *) HAS_TEMPLATE_0=false ;;
esac
assert_eq "exit 0: local/main retains the local commit" "true" "$HAS_LOCAL_0"
assert_eq "exit 0: local/main contains the new template commit" "true" "$HAS_TEMPLATE_0"

# exit 0 unattended: clean rebase, non-conflicting template advance. Same
# shape as the interactive exit-0 case above, but this is the path plan
# 115's Step 8 checkout-skip actually changed — HEAD starts on local/main
# already (the exit-10 guard requires it), so the fixture never checks out
# local/main at all, and this pins that the rebase and fast-forward still
# land correctly without it.
make_fixture
F0U="$FIXTURE_DIR"
ORIGIN0U="$(git -C "$F0U" remote get-url origin)"
PUSHCLONE0U="$TMP_ROOT/pushclone-0u"
git clone -q "$ORIGIN0U" "$PUSHCLONE0U"
configure_repo "$PUSHCLONE0U"
printf 'template advance content (unattended)\n' >> "$PUSHCLONE0U/other.txt"
git -C "$PUSHCLONE0U" commit -qam "template advances cleanly (unattended)"
git -C "$PUSHCLONE0U" push -q origin main
NEW_ORIGIN_SHA_0U="$(git -C "$PUSHCLONE0U" rev-parse main)"

run_update "$F0U" "--unattended"
assert_exit "exit 0 unattended: happy path rebase" 0 "$LAST_CODE"
FIXTURE_MAIN_SHA_0U="$(git -C "$F0U" rev-parse main)"
assert_eq "exit 0 unattended: main fast-forwarded to origin's new SHA" "$NEW_ORIGIN_SHA_0U" "$FIXTURE_MAIN_SHA_0U"
LOCALMAIN_LOG_0U="$(git -C "$F0U" log --oneline local/main)"
case "$LOCALMAIN_LOG_0U" in
  *"local commit on local/main"*) HAS_LOCAL_0U=true ;;
  *) HAS_LOCAL_0U=false ;;
esac
case "$LOCALMAIN_LOG_0U" in
  *"template advances cleanly (unattended)"*) HAS_TEMPLATE_0U=true ;;
  *) HAS_TEMPLATE_0U=false ;;
esac
assert_eq "exit 0 unattended: local/main retains the local commit" "true" "$HAS_LOCAL_0U"
assert_eq "exit 0 unattended: local/main contains the new template commit" "true" "$HAS_TEMPLATE_0U"

POST_HEAD_BRANCH_0U="$(git -C "$F0U" symbolic-ref --short -q HEAD)"
assert_eq "exit 0 unattended: HEAD still on local/main" "local/main" "$POST_HEAD_BRANCH_0U"

GD0U="$(fixture_gitdir "$F0U")"
if [ -d "$GD0U/rebase-merge" ] || [ -d "$GD0U/rebase-apply" ] || [ -f "$GD0U/MERGE_HEAD" ]; then
  MIDREBASE_0U=true
else
  MIDREBASE_0U=false
fi
assert_eq "exit 0 unattended: not left mid-rebase" "false" "$MIDREBASE_0U"

DIRTY_0U="$(git -C "$F0U" status --porcelain)"
assert_eq "exit 0 unattended: git status --porcelain empty" "" "$DIRTY_0U"

# exit 8 interactive: conflicting edit, left mid-rebase for the user
make_fixture
F8I="$FIXTURE_DIR"
ORIGIN8I="$(git -C "$F8I" remote get-url origin)"
PUSHCLONE8I="$TMP_ROOT/pushclone-8i"
git clone -q "$ORIGIN8I" "$PUSHCLONE8I"
configure_repo "$PUSHCLONE8I"
printf 'origin change to seed line (interactive)\n' > "$PUSHCLONE8I/seed.txt"
git -C "$PUSHCLONE8I" commit -qam "origin changes seed line (conflict source, interactive)"
git -C "$PUSHCLONE8I" push -q origin main

run_update "$F8I"
assert_exit "exit 8 interactive: rebase conflict" 8 "$LAST_CODE"
assert_contains "exit 8 interactive: stdout says CONFLICTS:" "$LAST_OUT" "CONFLICTS:"
GD8I="$(fixture_gitdir "$F8I")"
if [ -d "$GD8I/rebase-merge" ] || [ -d "$GD8I/rebase-apply" ]; then
  MIDREBASE_8I=true
else
  MIDREBASE_8I=false
fi
assert_eq "exit 8 interactive: repo left mid-rebase" "true" "$MIDREBASE_8I"
( cd "$F8I" && git rebase --abort >/dev/null 2>&1 )

# ---------------------------------------------------------------------------
# Step 5: unattended rollback (exit 8 --unattended) — the keystone case
# ---------------------------------------------------------------------------

make_fixture
F8U="$FIXTURE_DIR"
ORIGIN8U="$(git -C "$F8U" remote get-url origin)"
PUSHCLONE8U="$TMP_ROOT/pushclone-8u"
git clone -q "$ORIGIN8U" "$PUSHCLONE8U"
configure_repo "$PUSHCLONE8U"
printf 'origin change to seed line (unattended)\n' > "$PUSHCLONE8U/seed.txt"
git -C "$PUSHCLONE8U" commit -qam "origin changes seed line (conflict source, unattended)"
git -C "$PUSHCLONE8U" push -q origin main

# Capture pre-run SHAs BEFORE the run — the rollback assert is worthless if
# these are captured after the fact.
PRE_MAIN_SHA_8U="$(git -C "$F8U" rev-parse main)"
PRE_LOCALMAIN_SHA_8U="$(git -C "$F8U" rev-parse local/main)"

run_update "$F8U" "--unattended"
assert_exit "exit 8 unattended: rebase conflict auto-cancelled" 8 "$LAST_CODE"
assert_contains "exit 8 unattended: stdout says auto-cancelled" "$LAST_OUT" "CONFLICTS (auto-cancelled"

GD8U="$(fixture_gitdir "$F8U")"
if [ -d "$GD8U/rebase-merge" ] || [ -d "$GD8U/rebase-apply" ] || [ -f "$GD8U/MERGE_HEAD" ]; then
  MIDREBASE_8U=true
else
  MIDREBASE_8U=false
fi
assert_eq "exit 8 unattended: repo NOT left mid-rebase" "false" "$MIDREBASE_8U"

POST_MAIN_SHA_8U="$(git -C "$F8U" rev-parse main)"
assert_eq "exit 8 unattended: main rolled back to its pre-run SHA" "$PRE_MAIN_SHA_8U" "$POST_MAIN_SHA_8U"

POST_LOCALMAIN_SHA_8U="$(git -C "$F8U" rev-parse local/main)"
assert_eq "exit 8 unattended: local/main untouched" "$PRE_LOCALMAIN_SHA_8U" "$POST_LOCALMAIN_SHA_8U"

POST_HEAD_BRANCH_8U="$(git -C "$F8U" symbolic-ref --short -q HEAD)"
assert_eq "exit 8 unattended: HEAD still on local/main" "local/main" "$POST_HEAD_BRANCH_8U"

# ---------------------------------------------------------------------------
# Plan 115: lock-contention recovery — another git process holds index.lock
# when update.sh --unattended runs, so the rebase never starts. Exit code and
# output were determined empirically (Odin Checkpoint A: not hardcoded from
# the plan text) by probing the post-fix behaviour directly, on git 2.50.1
# (Apple Git-155): with index.lock already held, `git rebase main` fails to
# detach HEAD before creating a rebase-merge or rebase-apply state directory
# — verified for both the merge and apply rebase backends explicitly (`git
# rebase --merge` / `git rebase --apply` against the same held lock) — so
# recovery takes the "rebase could not start" branch below: exit 8, main
# rolled back to its pre-run SHA, not left mid-rebase. This is a git-version
# observation, not a property this code enforces: on a git whose rebase
# implementation creates the state directory before acquiring index.lock,
# recovery would instead take the "our rebase in progress" branch — `git
# rebase --abort` would itself fail on the held lock, a RECOVERY FAILED line
# would print, and this case's exact-message and not-mid-rebase asserts
# below would fail, while the main-rolled-back invariant would still hold
# (that branch rolls main back too). The asserts are pinned to the observed
# behaviour on the git version above, not to a guarantee about all gits.
#
# recovery-failure messaging (the "RECOVERY FAILED: ..." lines) is
# inspection-only here — forcing `git branch -f` or `git rebase --abort` to
# fail portably from a shell fixture isn't worth the contortion, so no test
# case exercises that branch; the lines were verified by reading the code.
# ---------------------------------------------------------------------------

make_fixture
FLC="$FIXTURE_DIR"
ORIGINLC="$(git -C "$FLC" remote get-url origin)"
PUSHCLONELC="$TMP_ROOT/pushclone-lc"
git clone -q "$ORIGINLC" "$PUSHCLONELC"
configure_repo "$PUSHCLONELC"
printf 'template advance content (lock contention)\n' >> "$PUSHCLONELC/other.txt"
git -C "$PUSHCLONELC" commit -qam "template advances cleanly (lock contention fixture)"
git -C "$PUSHCLONELC" push -q origin main

PRE_MAIN_SHA_LC="$(git -C "$FLC" rev-parse main)"
PRE_LOCALMAIN_SHA_LC="$(git -C "$FLC" rev-parse local/main)"

GDLC="$(fixture_gitdir "$FLC")"
printf 'lock held by another process\n' > "$GDLC/index.lock"

run_update "$FLC" "--unattended"
assert_exit "lock contention: rebase could not start" 8 "$LAST_CODE"
assert_contains "lock contention: stdout says rebase could not start" "$LAST_OUT" "Rebase could not start"

if [ -d "$GDLC/rebase-merge" ] || [ -d "$GDLC/rebase-apply" ] || [ -f "$GDLC/MERGE_HEAD" ]; then
  MIDREBASE_LC=true
else
  MIDREBASE_LC=false
fi
assert_eq "lock contention: repo NOT left mid-rebase" "false" "$MIDREBASE_LC"

POST_MAIN_SHA_LC="$(git -C "$FLC" rev-parse main)"
assert_eq "lock contention: main rolled back to its pre-run SHA" "$PRE_MAIN_SHA_LC" "$POST_MAIN_SHA_LC"

POST_LOCALMAIN_SHA_LC="$(git -C "$FLC" rev-parse local/main)"
assert_eq "lock contention: local/main untouched" "$PRE_LOCALMAIN_SHA_LC" "$POST_LOCALMAIN_SHA_LC"

assert_eq "lock contention: HEAD still on local/main" "local/main" "$(git -C "$FLC" symbolic-ref --short -q HEAD)"

rm -f "$GDLC/index.lock"

# ---------------------------------------------------------------------------
# Step 6: summary
# ---------------------------------------------------------------------------

echo ""
echo "$TOTAL asserts, $FAILED failures"
if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
