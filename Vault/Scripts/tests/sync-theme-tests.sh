#!/usr/bin/env bash
#
# sync-theme-tests.sh - behavioural test harness for
# Vault/Scripts/sync-theme.sh and Vault/Scripts/lib/map-parse.sh
#
# Runs sync-theme.sh against throwaway skeleton trees built under mktemp -d
# (Vault/Scripts + lib, Vault/Memory, .claude/agents), never against the live
# vault's theme-name-map.md or persona files.
#
# What is pinned (plan 122, finding 16):
#   1. A persona name with an apostrophe (O'Brien) or balanced double quotes
#      (Alex "Ace" Doe) survives the trim, instead of aborting an `xargs`
#      parse and coming back empty or silently de-quoted.
#   2. An empty name for a role token is refused with a warning and a
#      non-zero exit instead of rewriting the H1 to "#  - Role Label".
#   3. A map that already matches every persona H1 is a no-op (exit 0,
#      Updated: 0).
#   4. The trim() helper in lib/map-parse.sh trims spaces and tabs and
#      leaves an apostrophe untouched.
#
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`. `set -u`
# only (not -e), matching onboarding-hook-tests.sh and update-tests.sh.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SYNC_THEME="$PROJECT_ROOT/Vault/Scripts/sync-theme.sh"
MAP_PARSE_LIB="$PROJECT_ROOT/Vault/Scripts/lib/map-parse.sh"

if [ ! -f "$SYNC_THEME" ]; then
  echo "FATAL: sync-theme.sh not found at $SYNC_THEME" >&2
  exit 1
fi
if [ ! -f "$MAP_PARSE_LIB" ]; then
  echo "FATAL: map-parse.sh not found at $MAP_PARSE_LIB" >&2
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
# Fixture helper
# ---------------------------------------------------------------------------

make_skeleton() {
  # $1 = name - echoes the path of a fresh skeleton sync-theme.sh accepts as
  # a project root: Vault/Scripts/{sync-theme.sh,lib/map-parse.sh} copied in,
  # Vault/Memory/ for the fixture map, .claude/agents/ for stub personas.
  d="$TMP_ROOT/$1"
  mkdir -p "$d/Vault/Scripts/lib"
  mkdir -p "$d/Vault/Memory"
  mkdir -p "$d/.claude/agents"
  cp "$SYNC_THEME" "$d/Vault/Scripts/sync-theme.sh"
  cp "$MAP_PARSE_LIB" "$d/Vault/Scripts/lib/map-parse.sh"
  echo "$d"
}

# ---------------------------------------------------------------------------
# Case 1 and 2: apostrophe/quotes kept, empty name refused (one map, one run)
# ---------------------------------------------------------------------------

echo "--- Case 1: apostrophe and quotes are kept ---"
S1="$(make_skeleton c1)"
cat > "$S1/Vault/Memory/theme-name-map.md" <<'EOF'
# map
```yaml
Studio: Test Studio
Orchestrator: Sam
Copywriter: O'Brien
Brand: Alex "Ace" Doe
Empty:
```
| Token | File |
|---|---|
| Copywriter | `copywriter.md` |
| Brand | `brand.md` |
| Empty | `empty.md` |
EOF
printf '%s\n' '# Finn — Copywriter' > "$S1/.claude/agents/copywriter.md"
printf '%s\n' '# Remi — Brand Strategist' > "$S1/.claude/agents/brand.md"
printf '%s\n' '# Someone — Empty Role' > "$S1/.claude/agents/empty.md"

OUT1="$(cd "$S1" && bash "$S1/Vault/Scripts/sync-theme.sh" 2>&1)"
CODE1=$?

assert_exit "case 1/2: sync-theme exits 1 (the empty-name error in the same map)" 1 "$CODE1"
assert_contains "case 1: apostrophe kept in output" "$OUT1" "✓ Updated: Copywriter → O'Brien (copywriter.md)"
assert_contains "case 1: balanced double quotes kept in output" "$OUT1" '✓ Updated: Brand → Alex "Ace" Doe (brand.md)'
assert_not_contains "case 1: no xargs quote-parse error" "$OUT1" "unmatched single quote"
H1_CW="$(head -1 "$S1/.claude/agents/copywriter.md")"
assert_eq "case 1: copywriter.md H1 rewritten with apostrophe" "# O'Brien — Copywriter" "$H1_CW"
H1_BR="$(head -1 "$S1/.claude/agents/brand.md")"
assert_eq "case 1: brand.md H1 rewritten with quotes" '# Alex "Ace" Doe — Brand Strategist' "$H1_BR"

echo "--- Case 2: empty name refused ---"
assert_contains "case 2: empty-name warning names the token" "$OUT1" "Empty name for role token 'Empty'"
assert_contains "case 2: error count is 1" "$OUT1" "Errors: 1"
H1_EMPTY="$(head -1 "$S1/.claude/agents/empty.md")"
assert_eq "case 2: empty.md H1 left unchanged" "# Someone — Empty Role" "$H1_EMPTY"
assert_not_contains "case 2: H1 never rewritten to an empty name" "$OUT1" "#  —"

# ---------------------------------------------------------------------------
# Case 3: a clean map is a no-op
# ---------------------------------------------------------------------------

echo "--- Case 3: clean map is a no-op ---"
S3="$(make_skeleton c3)"
cat > "$S3/Vault/Memory/theme-name-map.md" <<'EOF'
# map
```yaml
Studio: Test Studio
Orchestrator: Sam
Copywriter: Finn
```
| Token | File |
|---|---|
| Copywriter | `copywriter.md` |
EOF
printf '%s\n' '# Finn — Copywriter' > "$S3/.claude/agents/copywriter.md"

OUT3="$(cd "$S3" && bash "$S3/Vault/Scripts/sync-theme.sh" 2>&1)"
CODE3=$?

assert_exit "case 3: exit 0" 0 "$CODE3"
assert_contains "case 3: already synced 1" "$OUT3" "Already synced: 1"
assert_contains "case 3: updated 0" "$OUT3" "Updated: 0"

# ---------------------------------------------------------------------------
# Case 4: trim() unit checks
# ---------------------------------------------------------------------------

echo "--- Case 4: trim unit checks ---"
TRIM_A="$(source "$S1/Vault/Scripts/lib/map-parse.sh"; trim "  a b  ")"
assert_eq "case 4: trim collapses surrounding spaces" "a b" "$TRIM_A"
TRIM_B="$(source "$S1/Vault/Scripts/lib/map-parse.sh"; trim "$(printf '\tx\t')")"
assert_eq "case 4: trim strips tabs" "x" "$TRIM_B"
TRIM_C="$(source "$S1/Vault/Scripts/lib/map-parse.sh"; trim "")"
assert_eq "case 4: trim of an empty string is empty" "" "$TRIM_C"
TRIM_D="$(source "$S1/Vault/Scripts/lib/map-parse.sh"; trim "O'Brien")"
assert_eq "case 4: trim leaves an apostrophe untouched" "O'Brien" "$TRIM_D"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
echo "$TOTAL asserts, $FAILED failures"
if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
exit 0
