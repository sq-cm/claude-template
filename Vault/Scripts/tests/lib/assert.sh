#!/usr/bin/env bash
#
# assert.sh — shared assert helpers sourced by every *-tests.sh harness in
# Vault/Scripts/tests/.
#
# Owns TOTAL/FAILED. Callers set -u themselves; this library relies on the
# caller having initialised nothing beyond that (TOTAL/FAILED are set here).
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`.
#
# Helpers print exactly what the four original harnesses printed before this
# extraction: "ok - label" / "FAIL - label (…)". assert_summary prints the
# tally line and exits 1 if any assert failed, else 0 — callers end their
# script with a single call to it instead of repeating the tail themselves.

TOTAL=0
FAILED=0

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

assert_summary() {
  echo ""
  echo "$TOTAL asserts, $FAILED failures"
  if [ "$FAILED" -gt 0 ]; then
    exit 1
  fi
  exit 0
}
