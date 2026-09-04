#!/usr/bin/env bash
#
# onboarding-hook-tests.sh — behavioural test harness for
# .claude/hooks/session-start-onboarding.sh
#
# Runs the SessionStart onboarding hook against throwaway skeleton trees
# built under mktemp -d (an empty CLAUDE.md plus an empty .claude/agents/,
# nothing else) with CLAUDE_PROJECT_DIR pointed at the skeleton and
# CLAUDE_TEMPLATE_MAINTAINER cleared — never against the live vault. The
# hook performs Tier 1 writes (git config core.hooksPath, the .env copy, the
# Notes seed), so a run against the real tree mutates it; the CHANGELOG
# entries for plans 089 and 091 record that trap.
#
# What is pinned (plan 119):
#   1. The TRIGGERED path emits valid JSON whose ACTION continues past a
#      missing Node (Steps 8, 9 and 10), points at the Learn guide, and
#      still carries the string "skipped" in quotes.
#   2. A present-but-failing jq makes the hook exit 0 with NO stdout and one
#      "encoding failed" line in the skeleton's onboarding-errors.md — never
#      unescaped, invalid JSON.
#   3. An absent jq still emits the fixed AUTO-ONBOARDING SKIPPED message as
#      valid JSON (the "say something" guarantee).
#   4. A flags file with every REQUIRED_KEYS key true keeps the hook silent.
#
# Case 3 is skipped (not failed) on machines where jq resolves on
# /usr/bin:/bin — it cannot be hidden from PATH there.
#
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`. `set -u`
# only (not -e), matching update-tests.sh and the hook itself.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HOOK="$PROJECT_ROOT/.claude/hooks/session-start-onboarding.sh"

if [ ! -f "$HOOK" ]; then
  echo "FATAL: hook not found at $HOOK" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "FATAL: jq is required to run this harness" >&2
  exit 1
fi

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

TOTAL=0
FAILED=0

# ---------------------------------------------------------------------------
# Assert helpers — same shape as update-tests.sh
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
# Fixture helper
# ---------------------------------------------------------------------------

make_skeleton() {
  # $1 = name — echoes the path of a fresh skeleton the hook accepts as a
  # template root (CLAUDE.md + .claude/agents/). No .git, no .env.example, no
  # Notes sample, no flags file: Tier 1 has nothing to copy, behavioural_pass
  # is false, so the hook takes the TRIGGERED path and writes nothing.
  d="$TMP_ROOT/$1"
  mkdir -p "$d/.claude/agents"
  : > "$d/CLAUDE.md"
  echo "$d"
}

# ---------------------------------------------------------------------------
# Case 1: TRIGGERED path, jq present
# ---------------------------------------------------------------------------

echo "--- Case 1: TRIGGERED path (jq present) ---"
S1="$(make_skeleton c1)"
LAST_OUT="$(CLAUDE_TEMPLATE_MAINTAINER="" CLAUDE_PROJECT_DIR="$S1" bash "$HOOK" 2>/dev/null)"
LAST_CODE=$?
assert_exit "case 1: hook exits 0" 0 "$LAST_CODE"
printf '%s' "$LAST_OUT" | jq empty >/dev/null 2>&1
assert_exit "case 1: stdout is valid JSON" 0 "$?"
CTX1="$(printf '%s' "$LAST_OUT" | jq -r '.hookSpecificOutput.additionalContext' 2>/dev/null)"
assert_contains "case 1: payload is the TRIGGERED block" "$CTX1" "=== AUTO-ONBOARDING TRIGGERED ==="
assert_contains "case 1: Node-missing branch continues with Steps 8, 9 and 10" "$CTX1" "then continue with Steps 8, 9 and 10"
assert_not_contains "case 1: 'stop Tier 2' is gone" "$CTX1" "stop Tier 2"
assert_contains "case 1: closes with a pointer at the Learn guide" "$CTX1" "Resources/Learn/index.html"
assert_contains "case 1: the \"skipped\" quoting survived the ACTION edits" "$CTX1" 'the string "skipped" (never true)'

# ---------------------------------------------------------------------------
# Case 2: jq present but failing (a shim that exits 1, first on PATH)
# ---------------------------------------------------------------------------

echo "--- Case 2: jq present but failing (shim exits 1) ---"
S2="$(make_skeleton c2)"
mkdir -p "$TMP_ROOT/shim"
printf '#!/bin/sh\nexit 1\n' > "$TMP_ROOT/shim/jq"
chmod +x "$TMP_ROOT/shim/jq"
LAST_OUT="$(PATH="$TMP_ROOT/shim:$PATH" CLAUDE_TEMPLATE_MAINTAINER="" CLAUDE_PROJECT_DIR="$S2" bash "$HOOK" 2>/dev/null)"
LAST_CODE=$?
assert_exit "case 2: hook exits 0" 0 "$LAST_CODE"
assert_eq "case 2: stdout is empty (no unescaped fallback JSON)" "" "$LAST_OUT"
ERRLOG2="$(cat "$S2/Vault/Memory/onboarding-errors.md" 2>/dev/null)"
assert_contains "case 2: encoding failure is logged" "$ERRLOG2" "encoding failed"

# ---------------------------------------------------------------------------
# Case 3: jq absent (PATH narrowed to /usr/bin:/bin)
# ---------------------------------------------------------------------------

echo "--- Case 3: jq absent (PATH=/usr/bin:/bin) ---"
if PATH=/usr/bin:/bin bash -c 'command -v jq >/dev/null 2>&1'; then
  echo "skip - case 3: jq resolves on /usr/bin:/bin on this machine; cannot hide it (3 asserts not run)"
else
  S3="$(make_skeleton c3)"
  LAST_OUT="$(PATH=/usr/bin:/bin CLAUDE_TEMPLATE_MAINTAINER="" CLAUDE_PROJECT_DIR="$S3" bash "$HOOK" 2>/dev/null)"
  LAST_CODE=$?
  assert_exit "case 3: hook exits 0" 0 "$LAST_CODE"
  printf '%s' "$LAST_OUT" | jq empty >/dev/null 2>&1
  assert_exit "case 3: stdout is valid JSON" 0 "$?"
  CTX3="$(printf '%s' "$LAST_OUT" | jq -r '.hookSpecificOutput.additionalContext' 2>/dev/null)"
  assert_contains "case 3: SKIPPED message emitted" "$CTX3" "AUTO-ONBOARDING SKIPPED: jq is not installed"
fi

# ---------------------------------------------------------------------------
# Case 4: every REQUIRED_KEYS key true -> silent
# ---------------------------------------------------------------------------

echo "--- Case 4: every REQUIRED_KEYS key true -> silent ---"
S4="$(make_skeleton c4)"
REQUIRED_KEYS_LINE="$(grep -m1 '^REQUIRED_KEYS=' "$HOOK" | sed -E 's/^REQUIRED_KEYS="(.*)"$/\1/')"
mkdir -p "$S4/Vault/Memory"
jq -n --arg keys "$REQUIRED_KEYS_LINE" \
  '{onboarded: ($keys | split(" ") | map({key: ., value: true}) | from_entries)}' \
  > "$S4/Vault/Memory/onboarding-flags.json"
LAST_OUT="$(CLAUDE_TEMPLATE_MAINTAINER="" CLAUDE_PROJECT_DIR="$S4" bash "$HOOK" 2>/dev/null)"
LAST_CODE=$?
assert_exit "case 4: hook exits 0" 0 "$LAST_CODE"
assert_eq "case 4: stdout is empty (all flags satisfied)" "" "$LAST_OUT"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
echo "$TOTAL asserts, $FAILED failures"
if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
