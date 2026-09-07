#!/usr/bin/env bash
#
# validate-tests.sh — characterisation harness for Vault/Scripts/validate.sh
#
# Proves every one of validate.sh's 20 checks both fires on the defect it
# guards (a trip case) and clears on a clean tree (the shared base case).
# Never runs against the live vault: every case builds a throwaway skeleton
# under mktemp -d, copying validate.sh and lib/map-parse.sh into it, and runs
# the copy — validate.sh derives PROJECT_ROOT from its own script location
# (SCRIPT_DIR/../..), so a copy run in place behaves exactly like the real
# thing rooted at the skeleton.
#
# cwd/git note: validate.sh never `cd`s, and Checks 12 and 17 (LAST_SYNCED
# leg) read the CURRENT WORKING DIRECTORY's git history, not the skeleton's.
# run_validator therefore takes an explicit cwd argument; case 12c pins what
# happens when that cwd is not a git repository at all (both legs WARN-skip).
#
# VALIDATE_UNDER_TEST override: set this env var to point at a different
# validate.sh (e.g. an older revision from git show) to run this harness's
# fixtures against it — used for the red run that proves the Check 19/20
# cases actually bite. lib/map-parse.sh always comes from the live tree
# regardless of this override.
#
# Constants-derived sizing: the base skeleton's roster and skill catalogue
# are generated at run time from validate.sh's own tripwire constants
# (EXPECTED_AGENT_COUNT, EXPECTED_SKILL_COUNT, FABLE_PIN_COUNT,
# OPUS5_PIN_COUNT, XHIGH_EFFORT_COUNT, HIGH_EFFORT_COUNT) and its
# LEARN_OMITTED list, read fresh at start-up — so a hire that bumps a
# tripwire constant needs no fixture edit here.
#
# Documented gaps (characteristics pinned, not defects to fix):
#   - Check 15's perl-absent WARN can only be pinned where PATH=/usr/bin:/bin
#     lacks perl — never true on Git Bash or most Linux boxes. Case 15c
#     skips itself (prints a "skip -" line) when perl still resolves there.
#   - Check 18's zero-files FAIL is unreachable from any fixture: the copied
#     validate.sh is itself always one of the glob's matches.
#
# Bash 3.2 / Git Bash safe: no arrays, no `mapfile`, no `timeout`. `set -u`
# only (not -e), matching the four existing harnesses.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FIXTURES="$SCRIPT_DIR/fixtures/validate"
VALIDATE_UNDER_TEST="${VALIDATE_UNDER_TEST:-$PROJECT_ROOT/Vault/Scripts/validate.sh}"
MAP_PARSE_LIB="$PROJECT_ROOT/Vault/Scripts/lib/map-parse.sh"

if [ ! -f "$VALIDATE_UNDER_TEST" ]; then
  echo "FATAL: validator not found at $VALIDATE_UNDER_TEST" >&2
  exit 1
fi
if [ ! -f "$MAP_PARSE_LIB" ]; then
  echo "FATAL: map-parse.sh not found at $MAP_PARSE_LIB" >&2
  exit 1
fi
if [ ! -d "$FIXTURES" ]; then
  echo "FATAL: fixtures directory not found at $FIXTURES" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "FATAL: jq is required to run this harness" >&2
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "FATAL: git is required to run this harness" >&2
  exit 1
fi

ESC="$(printf '\033')"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

subst() {
  # $1 = file, $2 = sed BRE pattern, $3 = replacement. Escape *, ., [, ], &
  # and | in $2 when meant literally (^model: .* is a regex on purpose); $3
  # escapes & and | only. No sed -i (BSD/GNU divergence) — temp file + mv.
  sed "s|$2|$3|" "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

insert_after() {
  # $1 = file, $2 = literal substring to find (matched via index(), never
  # a regex — awk -v strips backslash escapes before a dynamic regex ever
  # sees them, which silently corrupts patterns containing |, [, (, etc.;
  # plain substring search sidesteps that entirely), $3 = line(s) to
  # insert after each match. $3 may itself be a multi-line string.
  awk -v pat="$2" -v line="$3" '{print} index($0, pat) > 0 {print line}' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

delete_matching() {
  # $1 = file, $2 = grep BRE pattern (basic — | and ( are literal here)
  grep -v "$2" "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

read_const() {
  # $1 = constant name as it appears in the validator, e.g. EXPECTED_AGENT_COUNT
  sed -n "s/^$1=\([0-9]*\).*/\1/p" "$VALIDATE_UNDER_TEST" | head -1
}

crlf() {
  # $1 = file — appends a CR before every line's trailing LF (BSD sed
  # treats a backslash-r in the replacement as literal "r", so the
  # printf-built CR byte is the portable form).
  CR="$(printf '\r')"
  sed "s/$/$CR/" "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

count_lines() {
  # $1 = grep BRE pattern, counted against the last run_validator's $VAL_OUT
  printf '%s\n' "$VAL_OUT" | grep -c "$1"
}

run_validator() {
  # $1 = skeleton root; $2 = cwd to run from (default: $1); $3 = optional
  # PATH override (case 15c only — empty means inherit). Sets VAL_OUT
  # (ANSI-stripped) and VAL_CODE. Exit 97 from the subshell is a harness
  # fault (the cd failed), never a validator result.
  VAL_OUT="$( cd "${2:-$1}" || exit 97; PATH="${3:-$PATH}" bash "$1/Vault/Scripts/validate.sh" 2>&1 )"
  VAL_CODE=$?
  VAL_OUT="$(printf '%s\n' "$VAL_OUT" | sed "s/$ESC\[[0-9;]*m//g")"
}

fixture_commit() {
  # $1 = skeleton dir, $2 = commit message, $3 = optional extra git-commit
  # flags (e.g. --allow-empty). Fixed author/committer dates so Check 17's
  # LAST_SYNCED leg is deterministic. core.hooksPath points at a directory
  # that does not exist so no global hook can fire.
  d="$1"; msg="$2"; extra="${3:-}"
  ( cd "$d" || exit 97
    git add -A
    GIT_AUTHOR_DATE="2026-01-01T12:00:00" GIT_COMMITTER_DATE="2026-01-01T12:00:00" \
      git -c user.name=fixture -c user.email=fixture@example.invalid -c commit.gpgsign=false \
          -c core.hooksPath="$d/.no-hooks" \
      commit -q -m "$msg" $extra )
}

make_skeleton() {
  # $1 = name — echoes the path of a fresh skeleton the copied validate.sh
  # accepts as PROJECT_ROOT. Sized from AGENT_N/SKILL_N/FABLE_N/OPUS_N/
  # XHIGH_N/HIGH_N and LEARN_OMITTED, read once at start-up (see below).
  name="$1"
  d="$TMP_ROOT/$name"
  mkdir -p "$d"
  cp -R "$FIXTURES/base/." "$d/"
  mv "$d/dot-claude" "$d/.claude"
  mv "$d/CLAUDE.fixture.md" "$d/CLAUDE.md"

  mkdir -p "$d/Vault/Scripts/lib"
  cp "$VALIDATE_UNDER_TEST" "$d/Vault/Scripts/validate.sh"
  cp "$MAP_PARSE_LIB" "$d/Vault/Scripts/lib/map-parse.sh"

  # Personas: i = 1 .. AGENT_N-1 (the static qa-compliance-reviewer.md
  # supplies the AGENT_Nth file, one claude-opus-5 pin and one xhigh effort
  # — which is why the model/effort quotas below are offset by one).
  yaml_rows=""
  table_rows=""
  i=1
  last=$((AGENT_N - 1))
  while [ "$i" -le "$last" ]; do
    nn=$(printf '%02d' "$i")
    tok="Persona$nn"
    if [ "$i" -le "$FABLE_N" ]; then
      model="claude-fable-5-1"
    elif [ "$i" -le "$((FABLE_N + OPUS_N - 1))" ]; then
      model="claude-opus-5"
    else
      model="claude-sonnet-5"
    fi
    if [ "$i" -le "$((XHIGH_N - 1))" ]; then
      effort="xhigh"
    elif [ "$i" -le "$((XHIGH_N - 1 + HIGH_N))" ]; then
      effort="high"
    else
      effort="medium"
    fi
    pf="$d/.claude/agents/persona-$nn.md"
    cp "$FIXTURES/templates/persona.md" "$pf"
    subst "$pf" "__TOKEN__" "$tok"
    subst "$pf" "__MODEL__" "$model"
    subst "$pf" "__EFFORT__" "$effort"
    if [ -z "$yaml_rows" ]; then
      yaml_rows="$tok: Name $nn"
    else
      yaml_rows="$yaml_rows
$tok: Name $nn"
    fi
    if [ -z "$table_rows" ]; then
      table_rows="| $tok | \`persona-$nn.md\` |"
    else
      table_rows="$table_rows
| $tok | \`persona-$nn.md\` |"
    fi
    i=$((i + 1))
  done

  MAP_F="$d/Vault/Memory/theme-name-map.md"
  insert_after "$MAP_F" "QAComplianceReviewer: Quinn" "$yaml_rows"
  delete_matching "$MAP_F" '^__YAML_ROWS__$'
  insert_after "$MAP_F" '| QAComplianceReviewer | `qa-compliance-reviewer.md` |' "$table_rows"
  delete_matching "$MAP_F" '^__TABLE_ROWS__$'

  # Skills: SKILL_N total, minus the LEARN_OMITTED count as flat skill-NN
  # dirs, plus one dir per LEARN_OMITTED entry (on disk, off the Learn page).
  skill_entries=""
  i=1
  while [ "$i" -le "$FLAT_SKILL_COUNT" ]; do
    nn=$(printf '%02d' "$i")
    sname="skill-$nn"
    sdir="$d/.claude/skills/$sname"
    mkdir -p "$sdir"
    cp "$FIXTURES/templates/SKILL.md" "$sdir/SKILL.md"
    subst "$sdir/SKILL.md" "__NAME__" "$sname"
    entry_line="  { name: \"$sname\", type: \"skill\", category: \"Fixture\", desc: \"\" },"
    if [ -z "$skill_entries" ]; then
      skill_entries="$entry_line"
    else
      skill_entries="$skill_entries
$entry_line"
    fi
    i=$((i + 1))
  done

  printf '%s\n' "$LEARN_OMITTED" | while IFS= read -r om; do
    [ -z "$om" ] && continue
    oname="${om#skill:}"
    odir="$d/.claude/skills/$oname"
    mkdir -p "$odir"
    cp "$FIXTURES/templates/SKILL.md" "$odir/SKILL.md"
    subst "$odir/SKILL.md" "__NAME__" "$oname"
  done

  LEARN_F="$d/Resources/Learn/index.html"
  insert_after "$LEARN_F" "const SLASH_COMMANDS = [" "$skill_entries"
  delete_matching "$LEARN_F" '^  __SKILL_ENTRIES__$'
  subst "$LEARN_F" "__ENTRY_COUNT__" "$ENTRY_COUNT"

  README_F="$d/README.md"
  subst "$README_F" "__AGENT_COUNT__" "$AGENT_N"
  subst "$README_F" "__SKILL_COUNT__" "$SKILL_N"

  git init -q "$d" >/dev/null 2>&1
  fixture_commit "$d" "test: fixture baseline (#1)"

  echo "$d"
}

# ---------------------------------------------------------------------------
# Read tripwire constants and LEARN_OMITTED from the validator under test
# ---------------------------------------------------------------------------

AGENT_N="$(read_const EXPECTED_AGENT_COUNT)"
SKILL_N="$(read_const EXPECTED_SKILL_COUNT)"
FABLE_N="$(read_const FABLE_PIN_COUNT)"
OPUS_N="$(read_const OPUS5_PIN_COUNT)"
XHIGH_N="$(read_const XHIGH_EFFORT_COUNT)"
HIGH_N="$(read_const HIGH_EFFORT_COUNT)"

for pair in "EXPECTED_AGENT_COUNT $AGENT_N" "EXPECTED_SKILL_COUNT $SKILL_N" "FABLE_PIN_COUNT $FABLE_N" "OPUS5_PIN_COUNT $OPUS_N" "XHIGH_EFFORT_COUNT $XHIGH_N" "HIGH_EFFORT_COUNT $HIGH_N"; do
  cname="${pair%% *}"; cval="${pair#* }"
  if [ -z "$cval" ]; then
    echo "FATAL: could not read constant $cname from $VALIDATE_UNDER_TEST" >&2
    exit 1
  fi
done

LEARN_OMITTED="$(sed -n '/^LEARN_OMITTED="/,/"$/p' "$VALIDATE_UNDER_TEST" | sed 's/^LEARN_OMITTED="//; s/"$//')"
if [ -z "$LEARN_OMITTED" ]; then
  echo "FATAL: could not read LEARN_OMITTED from $VALIDATE_UNDER_TEST" >&2
  exit 1
fi
printf '%s\n' "$LEARN_OMITTED" | while IFS= read -r om; do
  case "$om" in
    skill:*) : ;;
    *) echo "FATAL: LEARN_OMITTED entry '$om' does not start with skill: — the fixture generator only models skills" >&2; exit 1 ;;
  esac
done
if printf '%s\n' "$LEARN_OMITTED" | grep -qv '^skill:'; then
  echo "FATAL: LEARN_OMITTED contains an entry not starting with skill: — the fixture generator only models skills" >&2
  exit 1
fi

OMITTED_COUNT="$(printf '%s\n' "$LEARN_OMITTED" | grep -c .)"
FLAT_SKILL_COUNT=$((SKILL_N - OMITTED_COUNT))
ENTRY_COUNT=$((FLAT_SKILL_COUNT + 3))
LAST_NN="$(printf '%02d' "$((AGENT_N - 1))")"
LAST_PERSONA="persona-$LAST_NN.md"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

. "$SCRIPT_DIR/lib/assert.sh"

# ---------------------------------------------------------------------------
# Case 0: clean base skeleton
# ---------------------------------------------------------------------------

echo "--- Case 0: clean base skeleton ---"
S0="$(make_skeleton c0)"
run_validator "$S0"
assert_exit "case 0: clean skeleton exits 0" 0 "$VAL_CODE"
assert_contains "case 0: RESULT: PASS" "$VAL_OUT" "RESULT: PASS"
assert_contains "case 0: (clean) — no warnings" "$VAL_OUT" "(clean)"
assert_eq "case 0: 20 PASS lines" "20" "$(count_lines '^  PASS: ')"
assert_eq "case 0: 0 FAIL lines" "0" "$(count_lines '^  FAIL: ')"
assert_eq "case 0: 0 WARN lines" "0" "$(count_lines '^  WARN: ')"
assert_contains "case 0: Check 18 saw three entry points" "$VAL_OUT" "All 3 shell entry points parse cleanly"
assert_contains "case 0: Check 19 counts" "$VAL_OUT" "(2 slots, 2 examples, 2 lead-ins, 2 checklist items, 2 template lines, 5 sections)"
assert_contains "case 0: Check 15 skipped-as-pass with no context.md" "$VAL_OUT" "Check 15 skipped — no local context.md"

# ---------------------------------------------------------------------------
# FATAL + Checks 1-10 trip cases
# ---------------------------------------------------------------------------

echo "--- Case FATAL: theme-name-map.md missing ---"
S="$(make_skeleton fatal)"
rm "$S/Vault/Memory/theme-name-map.md"
run_validator "$S"
assert_contains "fatal: theme-name-map.md not found" "$VAL_OUT" "FATAL: theme-name-map.md not found"
assert_contains "fatal: fatal prerequisite missing" "$VAL_OUT" "fatal prerequisite missing"
assert_exit "fatal: exit 1" 1 "$VAL_CODE"

echo "--- Case 1: path-table file missing ---"
S="$(make_skeleton c1)"
rm "$S/.claude/agents/persona-01.md"
run_validator "$S"
assert_contains "case 1: path-table entry not found" "$VAL_OUT" "Path-table entry 'persona-01.md' not found"
assert_exit "case 1: exit 1" 1 "$VAL_CODE"

echo "--- Case 2: orphan agent file ---"
S="$(make_skeleton c2)"
cp "$S/.claude/agents/persona-01.md" "$S/.claude/agents/orphan.md"
run_validator "$S"
assert_contains "case 2: orphan agent file" "$VAL_OUT" "Agent file 'orphan.md' is not listed in the path table (orphan)"
assert_exit "case 2: exit 1" 1 "$VAL_CODE"

echo "--- Case 3a: YAML token with no path-table row ---"
S="$(make_skeleton c3a)"
insert_after "$S/Vault/Memory/theme-name-map.md" "QAComplianceReviewer: Quinn" "Ghost: Nobody"
run_validator "$S"
assert_contains "case 3a: ghost YAML token" "$VAL_OUT" "YAML token 'Ghost' has no corresponding path-table row"
assert_exit "case 3a: exit 1" 1 "$VAL_CODE"

echo "--- Case 3b: path-table row with no YAML entry ---"
S="$(make_skeleton c3b)"
insert_after "$S/Vault/Memory/theme-name-map.md" '| QAComplianceReviewer | `qa-compliance-reviewer.md` |' '| Ghost | `ghost.md` |'
run_validator "$S"
assert_contains "case 3b: ghost path-table row" "$VAL_OUT" "Path-table token 'Ghost' has no corresponding YAML entry"
assert_exit "case 3b: exit 1" 1 "$VAL_CODE"

echo "--- Case 4a: unmapped @{Token} in CLAUDE.md ---"
S="$(make_skeleton c4a)"
printf '\n@{Nobody}\n' >> "$S/CLAUDE.md"
run_validator "$S"
assert_contains "case 4a: unmapped token in governance files" "$VAL_OUT" "Unmapped @{Nobody} in governance files"
assert_exit "case 4a: exit 1" 1 "$VAL_CODE"

echo "--- Case 4b: unmapped @{Token} in Projects (WARN) ---"
S="$(make_skeleton c4b)"
printf '\n@{Nobody}\n' >> "$S/Projects/Template/README.md"
run_validator "$S"
assert_contains "case 4b: warn unmapped token in projects" "$VAL_OUT" "Unmapped @{Nobody} in Projects/Vault/Memory/Notes (non-fatal)"
assert_contains "case 4b: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 4b: exit 0" 0 "$VAL_CODE"

echo "--- Case 4c: hardcoded excluded path missing ---"
S="$(make_skeleton c4c)"
rm -r "$S/Resources/Onboarding/Demos"
run_validator "$S"
assert_contains "case 4c: hardcoded excluded path missing" "$VAL_OUT" "Hardcoded excluded path does not exist"
assert_exit "case 4c: exit 1" 1 "$VAL_CODE"

echo "--- Case 5a: Agent in persona tools: ---"
S="$(make_skeleton c5a)"
insert_after "$S/.claude/agents/persona-01.md" "tools:" "  - Agent"
run_validator "$S"
assert_contains "case 5a: Agent tool violation" "$VAL_OUT" "persona-01.md: 'Agent' found in frontmatter tools: (depth-1 invariant violation)"
assert_exit "case 5a: exit 1" 1 "$VAL_CODE"

echo "--- Case 5b: non-baseline tool not in exceptions ---"
S="$(make_skeleton c5b)"
insert_after "$S/.claude/agents/persona-01.md" "tools:" "  - WebFetch"
run_validator "$S"
assert_contains "case 5b: non-baseline tool" "$VAL_OUT" "persona-01.md: non-baseline tool 'WebFetch' not in tool-exceptions.md"
assert_exit "case 5b: exit 1" 1 "$VAL_CODE"

echo "--- Case 5c: non-baseline tool WITH exception registered (clean) ---"
S="$(make_skeleton c5c)"
insert_after "$S/.claude/agents/persona-01.md" "tools:" "  - WebFetch"
printf '\npersona-01.md\n' >> "$S/Vault/Memory/tool-exceptions.md"
run_validator "$S"
assert_not_contains "case 5c: no non-baseline tool complaint" "$VAL_OUT" "persona-01.md: non-baseline tool 'WebFetch' not in tool-exceptions.md"
assert_contains "case 5c: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_contains "case 5c: clean" "$VAL_OUT" "(clean)"
assert_exit "case 5c: exit 0" 0 "$VAL_CODE"

echo "--- Case 5d: tools: key deleted ---"
S="$(make_skeleton c5d)"
delete_matching "$S/.claude/agents/persona-01.md" '^  - '
delete_matching "$S/.claude/agents/persona-01.md" '^tools:$'
run_validator "$S"
assert_contains "case 5d: no tools key" "$VAL_OUT" "persona-01.md: no 'tools:' key in frontmatter"
assert_exit "case 5d: exit 1" 1 "$VAL_CODE"

echo "--- Case 5e: CRLF persona frontmatter still parses clean ---"
S="$(make_skeleton c5e)"
crlf "$S/.claude/agents/persona-01.md"
run_validator "$S"
assert_contains "case 5e: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_contains "case 5e: clean" "$VAL_OUT" "(clean)"
assert_exit "case 5e: exit 0" 0 "$VAL_CODE"

echo "--- Case 6: broken link in CLAUDE.md ---"
S="$(make_skeleton c6)"
printf '\n[gone](missing.md)\n' >> "$S/CLAUDE.md"
run_validator "$S"
assert_contains "case 6: broken link" "$VAL_OUT" "Broken link in CLAUDE.md: 'missing.md'"
assert_exit "case 6: exit 1" 1 "$VAL_CODE"

echo "--- Case 7a: extra agent bumps the live count ---"
S="$(make_skeleton c7a)"
cp "$S/.claude/agents/persona-01.md" "$S/.claude/agents/persona-extra.md"
subst "$S/.claude/agents/persona-extra.md" "Persona01" "PersonaExtra"
insert_after "$S/Vault/Memory/theme-name-map.md" "QAComplianceReviewer: Quinn" "PersonaExtra: Name Extra"
insert_after "$S/Vault/Memory/theme-name-map.md" '| QAComplianceReviewer | `qa-compliance-reviewer.md` |' '| PersonaExtra | `persona-extra.md` |'
run_validator "$S"
AGENT_N_PLUS_1=$((AGENT_N + 1))
assert_contains "case 7a: live agent count bumped" "$VAL_OUT" "Live agent count is $AGENT_N_PLUS_1, expected $AGENT_N"
assert_exit "case 7a: exit 1" 1 "$VAL_CODE"

echo "--- Case 7b: no numeric skill-count assertion in README (WARN) ---"
S="$(make_skeleton c7b)"
delete_matching "$S/README.md" 'reusable skill modules'
printf -- '- no count here\n' >> "$S/README.md"
run_validator "$S"
assert_contains "case 7b: could not find skill-count assertion" "$VAL_OUT" "Could not find a numeric skill-count assertion"
assert_contains "case 7b: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 7b: exit 0" 0 "$VAL_CODE"

echo "--- Case 8: required seed file missing ---"
S="$(make_skeleton c8)"
rm "$S/Chats/README.md"
run_validator "$S"
assert_contains "case 8: seed file missing" "$VAL_OUT" "Seed file missing:"
assert_contains "case 8: chats readme path" "$VAL_OUT" "Chats/README.md"
assert_exit "case 8: exit 1" 1 "$VAL_CODE"

echo "--- Case 9a: settings.json references missing hook script ---"
S="$(make_skeleton c9a)"
subst "$S/.claude/settings.json" "session-start-onboarding.sh" "missing-hook.sh"
run_validator "$S"
assert_contains "case 9a: missing script referenced" "$VAL_OUT" "settings.json references missing script: .claude/hooks/missing-hook.sh"
assert_exit "case 9a: exit 1" 1 "$VAL_CODE"

echo "--- Case 9b: settings.json has no script paths ---"
S="$(make_skeleton c9b)"
printf '{}\n' > "$S/.claude/settings.json"
run_validator "$S"
assert_contains "case 9b: no script paths extracted" "$VAL_OUT" "No .claude/*.sh script paths extracted from settings.json"
assert_exit "case 9b: exit 1" 1 "$VAL_CODE"

echo "--- Case 9c: prose /nothing has no command file (WARN) ---"
S="$(make_skeleton c9c)"
printf '\n`/nothing`\n' >> "$S/CLAUDE.md"
run_validator "$S"
assert_contains "case 9c: prose reference has no command file" "$VAL_OUT" "Prose reference '/nothing' has no .claude/commands/nothing.md"
assert_contains "case 9c: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 9c: exit 0" 0 "$VAL_CODE"

echo "--- Case 10a: undocumented model pin ---"
S="$(make_skeleton c10a)"
subst "$S/.claude/agents/persona-01.md" '^model: .*' 'model: claude-opus-4-8'
run_validator "$S"
assert_contains "case 10a: undocumented model pin" "$VAL_OUT" "persona-01.md: model pin 'claude-opus-4-8' not in documented tiers"
assert_exit "case 10a: exit 1" 1 "$VAL_CODE"

echo "--- Case 10b: effort key deleted ---"
S="$(make_skeleton c10b)"
delete_matching "$S/.claude/agents/persona-01.md" '^effort: '
run_validator "$S"
assert_contains "case 10b: no effort key" "$VAL_OUT" "persona-01.md: no 'effort:' key in frontmatter"
assert_exit "case 10b: exit 1" 1 "$VAL_CODE"

echo "--- Case 10c: effort value not in enum ---"
S="$(make_skeleton c10c)"
subst "$S/.claude/agents/persona-01.md" '^effort: .*' 'effort: extreme'
run_validator "$S"
assert_contains "case 10c: effort value not in enum" "$VAL_OUT" "persona-01.md: effort value 'extreme' not in harness enum"
assert_exit "case 10c: exit 1" 1 "$VAL_CODE"

echo "--- Case 10d: opus pin count drops below tripwire (WARN) ---"
S="$(make_skeleton c10d)"
assert_contains "case 10d: pre-mutation model is opus" "$(cat "$S/.claude/agents/$LAST_PERSONA")" "model: claude-opus-5"
assert_contains "case 10d: pre-mutation effort is high" "$(cat "$S/.claude/agents/$LAST_PERSONA")" "effort: high"
subst "$S/.claude/agents/$LAST_PERSONA" '^model: .*' 'model: claude-sonnet-5'
run_validator "$S"
OPUS_N_MINUS_1=$((OPUS_N - 1))
assert_contains "case 10d: opus pin count drop" "$VAL_OUT" "claude-opus-5 pin count is $OPUS_N_MINUS_1, tripwire expects $OPUS_N"
assert_contains "case 10d: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 10d: exit 0" 0 "$VAL_CODE"

echo "--- Case 10e: high effort count drops below tripwire (WARN) ---"
S="$(make_skeleton c10e)"
assert_contains "case 10e: pre-mutation effort is high" "$(cat "$S/.claude/agents/$LAST_PERSONA")" "effort: high"
subst "$S/.claude/agents/$LAST_PERSONA" '^effort: .*' 'effort: medium'
run_validator "$S"
HIGH_N_MINUS_1=$((HIGH_N - 1))
assert_contains "case 10e: high effort count drop" "$VAL_OUT" "effort: high count is $HIGH_N_MINUS_1, tripwire expects $HIGH_N"
assert_contains "case 10e: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 10e: exit 0" 0 "$VAL_CODE"

# ---------------------------------------------------------------------------
# Checks 11-18 trip cases
# ---------------------------------------------------------------------------

echo "--- Case 11a: SKILL.md missing ---"
S="$(make_skeleton c11a)"
rm "$S/.claude/skills/skill-01/SKILL.md"
run_validator "$S"
assert_contains "case 11a: no SKILL.md" "$VAL_OUT" "skill-01: no SKILL.md"
assert_exit "case 11a: exit 1" 1 "$VAL_CODE"

echo "--- Case 11b: description exceeds 1024-char loader cap ---"
S="$(make_skeleton c11b)"
LONG_DESC="$(printf 'x%.0s' $(seq 1 1100))"
subst "$S/.claude/skills/skill-01/SKILL.md" '^description: .*' "description: $LONG_DESC"
run_validator "$S"
assert_contains "case 11b: description exceeds cap" "$VAL_OUT" "skill-01: description 1100 chars exceeds the 1024-char loader cap"
assert_exit "case 11b: exit 1" 1 "$VAL_CODE"

echo "--- Case 11c: explicit-invocation phrase without the flag ---"
S="$(make_skeleton c11c)"
subst "$S/.claude/skills/skill-01/SKILL.md" '^description: .*' 'description: Explicit invocation tool.'
run_validator "$S"
assert_contains "case 11c: missing disable-model-invocation flag" "$VAL_OUT" "skill-01: description declares explicit-invocation-only but frontmatter lacks disable-model-invocation: true"
assert_exit "case 11c: exit 1" 1 "$VAL_CODE"

echo "--- Case 11d: same as 11c but flag present (clean) ---"
S="$(make_skeleton c11d)"
subst "$S/.claude/skills/skill-01/SKILL.md" '^description: .*' 'description: Explicit invocation tool.'
insert_after "$S/.claude/skills/skill-01/SKILL.md" "name: skill-01" "disable-model-invocation: true"
run_validator "$S"
assert_not_contains "case 11d: no missing-flag complaint" "$VAL_OUT" "skill-01: description declares explicit-invocation-only but frontmatter lacks disable-model-invocation: true"
assert_contains "case 11d: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 11d: exit 0" 0 "$VAL_CODE"

echo "--- Case 11e: name: key deleted from SKILL.md ---"
S="$(make_skeleton c11e)"
delete_matching "$S/.claude/skills/skill-01/SKILL.md" '^name: '
run_validator "$S"
assert_contains "case 11e: no name key" "$VAL_OUT" "skill-01: no 'name:' key in SKILL.md frontmatter"
assert_exit "case 11e: exit 1" 1 "$VAL_CODE"

echo "--- Case 12a: unlogged PR in recent history (WARN) ---"
S="$(make_skeleton c12a)"
fixture_commit "$S" "feat: unlogged (#2)" "--allow-empty"
run_validator "$S"
assert_contains "case 12a: unlogged PR warning" "$VAL_OUT" "PR #2 in recent history has no CHANGELOG entry"
assert_contains "case 12a: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 12a: exit 0" 0 "$VAL_CODE"

echo "--- Case 12b: exempt PR is not flagged ---"
S="$(make_skeleton c12b)"
fixture_commit "$S" "chore: backfill (#82)" "--allow-empty"
run_validator "$S"
assert_not_contains "case 12b: no PR 82 complaint" "$VAL_OUT" "PR #82"
assert_contains "case 12b: clean" "$VAL_OUT" "(clean)"
assert_exit "case 12b: exit 0" 0 "$VAL_CODE"

echo "--- Case 12c: cwd outside the repository skips checks 12 and 17's git legs ---"
if git -C "$TMP_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "skip - case 12c: TMP_ROOT is inside a git repository"
else
  S="$(make_skeleton c12c)"
  run_validator "$S" "$TMP_ROOT"
  assert_contains "case 12c: check 12 skipped" "$VAL_OUT" "Check 12 skipped — not a usable git history"
  assert_contains "case 12c: check 17 LAST_SYNCED leg skipped" "$VAL_OUT" "Check 17 LAST_SYNCED leg skipped — not a usable git history"
  assert_exit "case 12c: exit 0" 0 "$VAL_CODE"
fi

echo "--- Case 13a: marketplace slug drifts from SETUP.md (WARN both directions) ---"
S="$(make_skeleton c13a)"
subst "$S/Resources/Onboarding/SETUP.md" "owner/fixture-repo" "owner/other-repo"
run_validator "$S"
assert_contains "case 13a: settings.json marketplace missing from SETUP.md" "$VAL_OUT" "marketplace owner/fixture-repo in settings.json has no reviewed-SHA row in SETUP.md"
assert_contains "case 13a: SETUP.md lists a repo settings.json no longer has" "$VAL_OUT" "SETUP.md SHA table lists owner/other-repo but settings.json no longer registers it"
assert_exit "case 13a: exit 0" 0 "$VAL_CODE"

echo "--- Case 14a: REQUIRED_KEYS plugin flag maps to disabled plugin ---"
S="$(make_skeleton c14a)"
subst "$S/.claude/settings.json" '"fixture-plugin@fixture": true' '"fixture-plugin@fixture": false'
run_validator "$S"
assert_contains "case 14a: disabled plugin" "$VAL_OUT" "REQUIRED_KEYS flag tier2_plugin_fixture_plugin maps to a disabled plugin"
assert_exit "case 14a: exit 1" 1 "$VAL_CODE"

echo "--- Case 14b: REQUIRED_KEYS flag has no matching enabledPlugins entry ---"
S="$(make_skeleton c14b)"
subst "$S/.claude/hooks/session-start-onboarding.sh" 'tier2_plugin_fixture_plugin' 'tier2_plugin_fixture_plugin tier2_plugin_nothing'
run_validator "$S"
assert_contains "case 14b: no matching enabledPlugins entry" "$VAL_OUT" "REQUIRED_KEYS flag tier2_plugin_nothing has no matching enabledPlugins entry (tried name 'nothing')"
assert_exit "case 14b: exit 1" 1 "$VAL_CODE"

echo "--- Case 15a: context.md over budget (WARN) ---"
S="$(make_skeleton c15a)"
head -c 4000 /dev/zero | tr '\0' a > "$S/Vault/Memory/context.md"
run_validator "$S"
assert_contains "case 15a: context.md over budget" "$VAL_OUT" "context.md injects 4000 bytes comment-stripped, budget is 3072"
assert_contains "case 15a: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 15a: exit 0" 0 "$VAL_CODE"

echo "--- Case 15b: context.md comment-stripped size is within budget ---"
S="$(make_skeleton c15b)"
{ printf '%s\n' "$(head -c 1999 /dev/zero | tr '\0' a)"; printf '<!--%s-->' "$(head -c 500 /dev/zero | tr '\0' b)"; } > "$S/Vault/Memory/context.md"
run_validator "$S"
assert_contains "case 15b: context.md within budget after comment-strip" "$VAL_OUT" "context.md injected size 2000 bytes is within the 3072-byte budget"
assert_exit "case 15b: exit 0" 0 "$VAL_CODE"

echo "--- Case 15c: perl unavailable (WARN, conditional skip) ---"
if PATH=/usr/bin:/bin bash -c 'command -v perl >/dev/null 2>&1'; then
  echo "skip - case 15c: perl resolves on /usr/bin:/bin on this machine; cannot hide it (documented gap)"
else
  S="$(make_skeleton c15c)"
  head -c 10 /dev/zero | tr '\0' a > "$S/Vault/Memory/context.md"
  run_validator "$S" "$S" "/usr/bin:/bin"
  assert_contains "case 15c: perl unavailable skip" "$VAL_OUT" "Check 15 skipped — perl unavailable"
  assert_exit "case 15c: exit 0" 0 "$VAL_CODE"
fi

echo "--- Case 16a: no name: in output style frontmatter ---"
S="$(make_skeleton c16a)"
delete_matching "$S/.claude/output-styles/test-style.md" '^name: '
run_validator "$S"
assert_contains "case 16a: no name in frontmatter" "$VAL_OUT" "test-style.md: no 'name:' in frontmatter"
assert_exit "case 16a: exit 1" 1 "$VAL_CODE"

echo "--- Case 16b: duplicate style name ---"
S="$(make_skeleton c16b)"
cp "$S/.claude/output-styles/test-style.md" "$S/.claude/output-styles/zz-style.md"
run_validator "$S"
assert_contains "case 16b: duplicate style name" "$VAL_OUT" "zz-style.md: duplicate style name 'TestStyle'"
assert_exit "case 16b: exit 1" 1 "$VAL_CODE"

echo "--- Case 16c: output-styles directory missing (WARN skip) ---"
S="$(make_skeleton c16c)"
rm -r "$S/.claude/output-styles"
run_validator "$S"
assert_contains "case 16c: check 16 skipped" "$VAL_OUT" "Check 16 skipped —"
assert_contains "case 16c: RESULT PASS" "$VAL_OUT" "RESULT: PASS"
assert_exit "case 16c: exit 0" 0 "$VAL_CODE"

echo "--- Case 17a: skill on disk not on Learn page or LEARN_OMITTED (WARN) ---"
S="$(make_skeleton c17a)"
mkdir -p "$S/.claude/skills/extra-skill"
cp "$FIXTURES/templates/SKILL.md" "$S/.claude/skills/extra-skill/SKILL.md"
subst "$S/.claude/skills/extra-skill/SKILL.md" "__NAME__" "extra-skill"
run_validator "$S"
assert_contains "case 17a: skill not on page or omitted" "$VAL_OUT" "skill:extra-skill exists on disk but is neither on the Learn page nor in LEARN_OMITTED"
assert_exit "case 17a: exit 1" 1 "$VAL_CODE"

echo "--- Case 17b: Learn page lists a ghost skill (WARN) ---"
S="$(make_skeleton c17b)"
insert_after "$S/Resources/Learn/index.html" "plugin-thing" '  { name: "ghost", type: "skill", category: "Fixture", desc: "" },'
subst "$S/Resources/Learn/index.html" "$ENTRY_COUNT entries across" "$((ENTRY_COUNT + 1)) entries across"
run_validator "$S"
assert_contains "case 17b: learn page lists ghost" "$VAL_OUT" "Learn page lists skill:ghost which no longer exists on disk"
assert_exit "case 17b: exit 0" 0 "$VAL_CODE"

echo "--- Case 17c: LAST_SYNCED stamp does not match last commit date ---"
S="$(make_skeleton c17c)"
subst "$S/Resources/Learn/index.html" 'LAST_SYNCED = "2026-01-01"' 'LAST_SYNCED = "2025-12-31"'
run_validator "$S"
assert_contains "case 17c: LAST_SYNCED mismatch" "$VAL_OUT" "Learn page LAST_SYNCED (2025-12-31) ≠ last commit touching it (2026-01-01)"
assert_exit "case 17c: exit 0" 0 "$VAL_CODE"

echo "--- Case 17d: entries-across summary count mismatch ---"
S="$(make_skeleton c17d)"
subst "$S/Resources/Learn/index.html" "$ENTRY_COUNT entries across" "999 entries across"
run_validator "$S"
assert_contains "case 17d: summary count mismatch" "$VAL_OUT" "Learn page summary count (999) ≠ live SLASH_COMMANDS entry count ($ENTRY_COUNT)"
assert_exit "case 17d: exit 0" 0 "$VAL_CODE"

echo "--- Case 17e: LEARN_OMITTED entry pruned from disk (WARN + check7 FAIL) ---"
S="$(make_skeleton c17e)"
FIRST_OMITTED="$(printf '%s\n' "$LEARN_OMITTED" | head -1 | sed 's/^skill://')"
rm -r "$S/.claude/skills/$FIRST_OMITTED"
run_validator "$S"
assert_contains "case 17e: prune omitted entry" "$VAL_OUT" "LEARN_OMITTED entry skill:$FIRST_OMITTED no longer exists on disk — prune it"
assert_exit "case 17e: exit 1" 1 "$VAL_CODE"

echo "--- Case 18a: shell syntax error in a hook ---"
S="$(make_skeleton c18a)"
printf 'if [ ; then\n' > "$S/.claude/hooks/broken.sh"
run_validator "$S"
assert_contains "case 18a: shell syntax error" "$VAL_OUT" "shell syntax error in .claude/hooks/broken.sh:"
assert_exit "case 18a: exit 1" 1 "$VAL_CODE"

# ---------------------------------------------------------------------------
# Checks 19-20 trip cases
# ---------------------------------------------------------------------------

echo "--- Case 19a: leadins differ between MD and HTML ---"
S="$(make_skeleton c19a)"
subst "$S/Resources/Learn/prompt-formula-cheat-sheet.md" '\*\*Tip one\.\*\*' '**Tip renamed.**'
run_validator "$S"
assert_contains "case 19a: leadins differ" "$VAL_OUT" "Learn cheat sheet leadins differ between Markdown and HTML twin:"
assert_exit "case 19a: exit 0" 0 "$VAL_CODE"

echo "--- Case 19b: examples leg extracts nothing from MD ---"
S="$(make_skeleton c19b)"
delete_matching "$S/Resources/Learn/prompt-formula-cheat-sheet.md" '^### '
run_validator "$S"
assert_contains "case 19b: examples leg extracted nothing" "$VAL_OUT" "Check 19 examples leg extracted nothing (MD 0, HTML 2)"
assert_exit "case 19b: exit 0" 0 "$VAL_CODE"

echo "--- Case 19c: template line counts disagree ---"
S="$(make_skeleton c19c)"
insert_after "$S/Resources/Learn/prompt-formula-cheat-sheet.md" "> Line two." "> Line three."
run_validator "$S"
assert_contains "case 19c: template counts disagree" "$VAL_OUT" "Learn cheat sheet template line counts disagree — Markdown 3, HTML callout 2, TEMPLATE_TEXT 2"
assert_exit "case 19c: exit 0" 0 "$VAL_CODE"

echo "--- Case 19d: section counts disagree ---"
S="$(make_skeleton c19d)"
printf '\n## Extra\n' >> "$S/Resources/Learn/prompt-formula-cheat-sheet.md"
run_validator "$S"
assert_contains "case 19d: section counts disagree" "$VAL_OUT" "Learn cheat sheet section counts disagree — Markdown ## 6, HTML <h2> 5"
assert_exit "case 19d: exit 0" 0 "$VAL_CODE"

echo "--- Case 19e: slots differ (normalisation pinned) ---"
S="$(make_skeleton c19e)"
subst "$S/Resources/Learn/prompt-formula-cheat-sheet.html" 'Goal \&amp; scope' 'Goal and scope'
run_validator "$S"
assert_contains "case 19e: slots differ" "$VAL_OUT" "Learn cheat sheet slots differ between Markdown and HTML twin:"
assert_exit "case 19e: exit 0" 0 "$VAL_CODE"

echo "--- Case 19f: HTML twin missing ---"
S="$(make_skeleton c19f)"
rm "$S/Resources/Learn/prompt-formula-cheat-sheet.html"
run_validator "$S"
assert_contains "case 19f: twin file missing" "$VAL_OUT" "Check 19 skipped — twin file missing"
assert_exit "case 19f: exit 0" 0 "$VAL_CODE"

echo "--- Case 20a: owner heading renamed ---"
S="$(make_skeleton c20a)"
subst "$S/Resources/SOPs/Output Locale SOP.md" '^## QA severity$' '## Severity'
run_validator "$S"
assert_contains "case 20a: heading count is 0" "$VAL_OUT" "Output Locale SOP '## QA severity' heading count is 0 (expected 1)"
assert_exit "case 20a: exit 0" 0 "$VAL_CODE"

echo "--- Case 20b: FLAG row deleted ---"
S="$(make_skeleton c20b)"
delete_matching "$S/Resources/SOPs/Output Locale SOP.md" '^| Prose does not match the declared locale'
run_validator "$S"
assert_contains "case 20b: table shape changed" "$VAL_OUT" "Output Locale SOP § QA severity table shape changed (FLAG rows 0, BLOCK rows 1; expected 1/1)"
assert_exit "case 20b: exit 0" 0 "$VAL_CODE"

echo "--- Case 20c: Quinn persona loses the carve-out wording ---"
S="$(make_skeleton c20c)"
subst "$S/.claude/agents/qa-compliance-reviewer.md" 'compliance-sensitive' 'sensitive'
run_validator "$S"
assert_contains "case 20c: persona no longer states carve-out" "$VAL_OUT" "Quinn persona Locale check no longer states the compliance-sensitive block carve-out"
assert_exit "case 20c: exit 0" 0 "$VAL_CODE"

echo "--- Case 20d: QA Gate SOP pointer renamed ---"
S="$(make_skeleton c20d)"
subst "$S/Resources/SOPs/QA Gate SOP.md" '§ QA severity' 'section'
run_validator "$S"
assert_contains "case 20d: pointer no longer resolves" "$VAL_OUT" "QA Gate SOP no longer points at Output Locale SOP § QA severity"
assert_exit "case 20d: exit 0" 0 "$VAL_CODE"

echo "--- Case 20e: CLAUDE.md anchor phrase changes ---"
S="$(make_skeleton c20e)"
subst "$S/CLAUDE.md" 'verifies against the declared locale' 'checks locale'
run_validator "$S"
assert_contains "case 20e: CLAUDE.md anchor not found" "$VAL_OUT" "Check 20: CLAUDE.md § Output Locale anchor not found"
assert_exit "case 20e: exit 0" 0 "$VAL_CODE"

echo "--- Case 20f: QA Gate SOP file removed ---"
S="$(make_skeleton c20f)"
rm "$S/Resources/SOPs/QA Gate SOP.md"
run_validator "$S"
assert_contains "case 20f: check 20 skipped" "$VAL_OUT" "Check 20 skipped — Resources/SOPs/QA Gate SOP.md missing"
assert_exit "case 20f: exit 1" 1 "$VAL_CODE"

assert_summary
