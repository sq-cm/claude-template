#!/usr/bin/env bash
#
# install-tests.sh - behavioural test harness for install.sh
#
# Runs install.sh against throwaway git repos built under mktemp -d, never
# against the live vault: install.sh rewrites git config (core.hooksPath,
# core.fileMode, and the push-block) for whatever repository it runs inside,
# so every case runs it in maintainer mode inside a subshell that exits if
# the `cd` fails - never a bare `cd "$REPO"` followed by `bash install.sh`.
#
# What is pinned (plan 122, finding 23):
#   1. All three sample files missing: install.sh used to die at the first
#      bare `cp` under `set -e`, leaving hooks armed and no "Next steps"
#      printed. It now warns and continues to "Next steps" for all three.
#   2. All three samples present: each copy succeeds silently (no warning).
#   3. One sample present but empty: that one copy is skipped with a
#      warning; the other two still succeed.
#   4. A second run is idempotent: three "already exists, skipping" lines,
#      no warnings, exit 0.
#
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`. `set -u`
# only (not -e), matching onboarding-hook-tests.sh and update-tests.sh.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
INSTALL_SH="$PROJECT_ROOT/install.sh"

if [ ! -f "$INSTALL_SH" ]; then
  echo "FATAL: install.sh not found at $INSTALL_SH" >&2
  exit 1
fi

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

TOTAL=0
FAILED=0

# ---------------------------------------------------------------------------
# Assert helpers - same shape as onboarding-hook-tests.sh
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

assert_not_contains() {
  # $1 = label, $2 = haystack, $3 = needle
  label="$1"
  haystack="$2"
  needle="$3"
  TOTAL=$((TOTAL + 1))
  case "$haystack" in
    *"$needle"*)
      echo "FAIL - $label (did not expect to find [$needle] in output)"
      FAILED=$((FAILED + 1))
      ;;
    *)
      echo "ok - $label"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Fixture helpers
# ---------------------------------------------------------------------------

run_installer() {
  # $1 = repo path - runs install.sh in maintainer mode inside the repo via
  # a subshell that exits 97 if the `cd` fails, and sets INSTALL_OUT /
  # INSTALL_CODE. Exit 97 is a harness fault, never an installer result.
  repo="$1"
  INSTALL_OUT="$( ( cd "$repo" || exit 97; CLAUDE_TEMPLATE_MAINTAINER=1 bash ./install.sh 2>&1 ) )"
  INSTALL_CODE=$?
  if [ "$INSTALL_CODE" = "97" ]; then
    echo "FATAL: cd into $repo failed (harness fault)" >&2
    exit 1
  fi
}

check_toplevel() {
  # $1 = label, $2 = repo path - asserts git resolves the repo's toplevel to
  # itself, resolving both sides through the same cd ... && pwd -P idiom. On
  # Git for Windows, git.exe prints a native "C:/..." path while pwd -P
  # prints the MSYS "/c/..." form for the same directory, so normalise the
  # git side through cygpath -u (present on Git Bash) before comparing.
  label="$1"
  repo="$2"
  resolved="$(cd "$repo" && pwd -P)"
  toplevel="$(cd "$repo" && git rev-parse --show-toplevel)"
  if command -v cygpath >/dev/null 2>&1; then
    toplevel="$(cygpath -u "$toplevel")"
  fi
  assert_eq "$label" "$resolved" "$toplevel"
}

exists_flag() {
  if [ -f "$1" ]; then
    echo "yes"
  else
    echo "no"
  fi
}

# ---------------------------------------------------------------------------
# Case 1: all three samples missing
# ---------------------------------------------------------------------------

echo "--- Case 1: all three samples missing ---"
REPO1="$TMP_ROOT/case1"
git init -q "$REPO1"
cp "$INSTALL_SH" "$REPO1/install.sh"
check_toplevel "case 1: git toplevel resolves to repo" "$REPO1"
run_installer "$REPO1"
assert_exit "case 1: exit 0" 0 "$INSTALL_CODE"
assert_contains "case 1: .env warning" "$INSTALL_OUT" ".env not created"
assert_contains "case 1: context.md warning" "$INSTALL_OUT" "context.md not created"
assert_contains "case 1: Notes.md warning" "$INSTALL_OUT" "Notes.md not created"
assert_contains "case 1: Next steps still printed" "$INSTALL_OUT" "Next steps:"
assert_not_contains "case 1: no raw cp failure" "$INSTALL_OUT" "cannot stat"
assert_eq "case 1: .env not created on disk" "no" "$(exists_flag "$REPO1/.env")"
assert_eq "case 1: context.md not created on disk" "no" "$(exists_flag "$REPO1/Vault/Memory/context.md")"
assert_eq "case 1: Notes.md not created on disk" "no" "$(exists_flag "$REPO1/Notes/Personal/Notes.md")"

# ---------------------------------------------------------------------------
# Case 2: all three samples present
# ---------------------------------------------------------------------------

echo "--- Case 2: all three samples present ---"
REPO2="$TMP_ROOT/case2"
git init -q "$REPO2"
cp "$INSTALL_SH" "$REPO2/install.sh"
mkdir -p "$REPO2/Vault/Memory" "$REPO2/Resources/Onboarding"
printf 'sample env line\n' > "$REPO2/.env.example"
printf 'sample context line\n' > "$REPO2/Vault/Memory/context.example.md"
printf 'sample notes line\n' > "$REPO2/Resources/Onboarding/Notes.example.md"
check_toplevel "case 2: git toplevel resolves to repo" "$REPO2"
run_installer "$REPO2"
assert_exit "case 2: exit 0" 0 "$INSTALL_CODE"
assert_eq "case 2: .env created" "yes" "$(exists_flag "$REPO2/.env")"
assert_eq "case 2: context.md created" "yes" "$(exists_flag "$REPO2/Vault/Memory/context.md")"
assert_eq "case 2: Notes.md created" "yes" "$(exists_flag "$REPO2/Notes/Personal/Notes.md")"
assert_contains "case 2: Next steps printed" "$INSTALL_OUT" "Next steps:"
assert_not_contains "case 2: no warning glyph" "$INSTALL_OUT" "⚠"

# ---------------------------------------------------------------------------
# Case 3: one empty sample
# ---------------------------------------------------------------------------

echo "--- Case 3: one empty sample ---"
REPO3="$TMP_ROOT/case3"
git init -q "$REPO3"
cp "$INSTALL_SH" "$REPO3/install.sh"
mkdir -p "$REPO3/Vault/Memory" "$REPO3/Resources/Onboarding"
: > "$REPO3/.env.example"
printf 'sample context line\n' > "$REPO3/Vault/Memory/context.example.md"
printf 'sample notes line\n' > "$REPO3/Resources/Onboarding/Notes.example.md"
check_toplevel "case 3: git toplevel resolves to repo" "$REPO3"
run_installer "$REPO3"
assert_exit "case 3: exit 0" 0 "$INSTALL_CODE"
assert_contains "case 3: .env warning (empty sample)" "$INSTALL_OUT" ".env not created"
assert_eq "case 3: .env not created on disk" "no" "$(exists_flag "$REPO3/.env")"
assert_eq "case 3: context.md created" "yes" "$(exists_flag "$REPO3/Vault/Memory/context.md")"
assert_eq "case 3: Notes.md created" "yes" "$(exists_flag "$REPO3/Notes/Personal/Notes.md")"

# ---------------------------------------------------------------------------
# Case 4: idempotent re-run (reuses Case 2's repo)
# ---------------------------------------------------------------------------

echo "--- Case 4: idempotent re-run ---"
check_toplevel "case 4: git toplevel resolves to repo" "$REPO2"
run_installer "$REPO2"
assert_exit "case 4: exit 0" 0 "$INSTALL_CODE"
SKIP_COUNT="$(printf '%s\n' "$INSTALL_OUT" | grep -c 'already exists, skipping')"
assert_eq "case 4: three skip lines" "3" "$SKIP_COUNT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
echo "$TOTAL asserts, $FAILED failures"
if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
