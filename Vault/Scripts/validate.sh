#!/usr/bin/env bash

# validate.sh — Template Vault Consistency Checker
#
# Runs 13 read-only checks to verify the vault's structural invariants.
# Call before committing template changes to surface drift early.
#
# Usage:
#   bash Vault/Scripts/validate.sh
#
# Exit code:
#   0  — all FAIL checks passed (warnings may still be present)
#   1  — one or more FAIL checks did not pass
#
# ──────────────────────────────────────────────────────────────────────────────
# EXIT-CODE CONTRACT (Odin correction 8)
#
# FAIL → exit 1:
#   Check 1  — theme-map path-table file missing from .claude/agents/
#   Check 2  — orphan agent file not in path table
#   Check 3  — token-without-row or row-without-token (after carve-outs)
#   Check 4  — unmapped @{Token} in governance files
#   Check 4  — hardcoded excluded path (Resources/Onboarding/Demos/) is missing
#   Check 5  — 'Agent' in persona frontmatter tools: / tool outside baseline without exception
#   Check 6  — broken internal markdown link
#   Check 7  — live agent/skill count does not match README assertion
#   Check 8  — required seed file missing
#   Check 9  — settings.json hook/statusLine script path does not exist
#   Check 10 — persona model: pin missing or outside documented tiers
#   Check 11 — skill SKILL.md missing, malformed frontmatter, or description over the 1024-char loader cap
#
# WARN → non-fatal, exit unaffected:
#   Check 4  — unmapped @{Token} in Projects/ or Vault/Memory/Notes/
#   Check 9  — prose `/command` reference with no command file, skill, or built-in
#   Check 10 — claude-fable-5 pin count differs from FABLE_PIN_COUNT tripwire
#   Check 12 — merged PR (recent history) missing a CHANGELOG.md entry, not exempt
#   Check 13 — settings.json marketplace and SETUP.md accepted-risk table disagree
# ──────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MAP_FILE="$PROJECT_ROOT/Vault/Memory/theme-name-map.md"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"
EXCEPTIONS_FILE="$PROJECT_ROOT/Vault/Memory/tool-exceptions.md"

# Colour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

fail_count=0
warn_count=0

fail() {
    echo -e "${RED}  FAIL: $1${NC}"
    ((fail_count++))
}

warn() {
    echo -e "${YELLOW}  WARN: $1${NC}"
    ((warn_count++))
}

pass() {
    echo -e "${GREEN}  PASS: $1${NC}"
}

echo ""
echo "=== Template Vault Validator ==="
echo "    Project root: $PROJECT_ROOT"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Prerequisite: map file must exist (Check 8 handles seed files, but we need it
# for checks 1-4 — abort early with a clear message if missing).
# ──────────────────────────────────────────────────────────────────────────────
if [ ! -f "$MAP_FILE" ]; then
    echo -e "${RED}FATAL: theme-name-map.md not found at $MAP_FILE — cannot run checks 1-4.${NC}"
    echo -e "${RED}       Run Check 8 result will also FAIL for this missing seed file.${NC}"
    fail_count=1
    echo ""
    echo "Summary: FAIL ($fail_count fail, $warn_count warn) — fatal prerequisite missing"
    exit 1
fi

# ──────────────────────────────────────────────────────────────────────────────
# Shared theme-map parser (also sourced by sync-theme.sh): load_yaml_lines,
# get_yaml_tokens, get_path_table_files, get_path_table_tokens,
# get_file_for_token. Schema changes edit lib/map-parse.sh once.
# ──────────────────────────────────────────────────────────────────────────────
source "$SCRIPT_DIR/lib/map-parse.sh"

# All YAML token lines
yaml_lines=$(load_yaml_lines "$MAP_FILE")

# ──────────────────────────────────────────────────────────────────────────────
# Check 1 — every `filename.md` in the path table exists in .claude/agents/
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 1: Path-table files exist in .claude/agents/ ---"
check1_pass=true
while IFS= read -r fname; do
    if [ -f "$AGENTS_DIR/$fname" ]; then
        : # exists — silent
    else
        fail "Path-table entry '$fname' not found at $AGENTS_DIR/$fname"
        check1_pass=false
    fi
done < <(get_path_table_files)

$check1_pass && pass "All path-table files exist in .claude/agents/"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 2 — every .claude/agents/*.md appears in the path table (no orphans)
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 2: No orphan agent files ---"
check2_pass=true
path_table_files=$(get_path_table_files)
for fpath in "$AGENTS_DIR"/*.md; do
    fname=$(basename "$fpath")
    [ "$fname" = "CLAUDE.md" ] && continue  # folder-tier CLAUDE.md is not a persona (Folder-Tier CLAUDE.md SOP)
    if echo "$path_table_files" | grep -qxF "$fname"; then
        : # found — silent
    else
        fail "Agent file '$fname' is not listed in the path table (orphan)"
        check2_pass=false
    fi
done

$check2_pass && pass "All agent files appear in the path table"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 3 — YAML tokens ↔ path-table rows match 1:1
#           (excluding Studio and Orchestrator, matching sync-theme.sh lines 84,87-90)
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 3: YAML tokens and path-table rows match 1:1 ---"
check3_pass=true
yaml_tokens=$(get_yaml_tokens)
path_table_tokens=$(get_path_table_tokens)

# Token in YAML but not in path table
while IFS= read -r tok; do
    if ! echo "$path_table_tokens" | grep -qxF "$tok"; then
        fail "YAML token '$tok' has no corresponding path-table row"
        check3_pass=false
    fi
done < <(echo "$yaml_tokens")

# Token in path table but not in YAML
while IFS= read -r tok; do
    if ! echo "$yaml_tokens" | grep -qxF "$tok"; then
        fail "Path-table token '$tok' has no corresponding YAML entry"
        check3_pass=false
    fi
done < <(echo "$path_table_tokens")

$check3_pass && pass "YAML tokens and path-table rows match 1:1"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 4 — @{Token} references resolve to known YAML tokens
#
# Odin correction 4: before excluding hardcoded paths, assert they EXIST.
# A missing excluded path is a FAIL (silent skip = silent broken check).
#
# Two passes:
#   (a) Governance files (.claude/, Resources/ excl. Demos, CLAUDE.md, README.md) → FAIL
#   (b) Projects/ and Vault/Memory/Notes/ → WARN
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 4: @{Token} references resolve to known YAML tokens ---"
check4_pass=true

# All known tokens (YAML block, including Studio and Orchestrator, drop RoleToken placeholder)
all_known_tokens=$(echo "$yaml_lines" | while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    line="${line%%#*}"
    token=$(echo "$line" | cut -d: -f1 | xargs)
    echo "$token"
done)

# Odin correction 4: assert excluded path exists before silently skipping it
DEMOS_DIR="$PROJECT_ROOT/Resources/Onboarding/Demos"
if [ ! -d "$DEMOS_DIR" ]; then
    fail "Hardcoded excluded path does not exist: $DEMOS_DIR — exclusion rule is broken (typo or directory moved)"
    check4_pass=false
fi

# Governance sources: .claude/, Resources/ (excluding Demos/), CLAUDE.md, README.md
# Use -E regex only, never -P (Odin correction 7 applies here too: no GNU -P in Git Bash)
governance_tokens=$(
    {
        grep -rEho '@\{[A-Za-z]+\}' "$PROJECT_ROOT/.claude/" 2>/dev/null
        grep -rEho '@\{[A-Za-z]+\}' "$PROJECT_ROOT/Resources/" \
            --exclude-dir="$(basename "$DEMOS_DIR")" 2>/dev/null
        grep -Eho '@\{[A-Za-z]+\}' "$PROJECT_ROOT/CLAUDE.md" 2>/dev/null
        grep -Eho '@\{[A-Za-z]+\}' "$PROJECT_ROOT/README.md" 2>/dev/null
    } | sed 's/@{//;s/}//' | sort -u
)

while IFS= read -r tok; do
    [[ -z "$tok" ]] && continue
    [[ "$tok" == "RoleToken" ]] && continue  # literal placeholder — drop
    if ! echo "$all_known_tokens" | grep -qxF "$tok"; then
        fail "Unmapped @{$tok} in governance files"
        check4_pass=false
    fi
done < <(echo "$governance_tokens")

$check4_pass && pass "All @{Token} references in governance files are mapped"

# WARN pass: Projects/ and Vault/Memory/Notes/
warn_sources=()
[ -d "$PROJECT_ROOT/Projects" ] && warn_sources+=("$PROJECT_ROOT/Projects")
[ -d "$PROJECT_ROOT/Vault/Memory/Notes" ] && warn_sources+=("$PROJECT_ROOT/Vault/Memory/Notes")

if [ ${#warn_sources[@]} -gt 0 ]; then
    warn_tokens=$(
        for src in "${warn_sources[@]}"; do
            grep -rEho '@\{[A-Za-z]+\}' "$src" 2>/dev/null
        done | sed 's/@{//;s/}//' | sort -u
    )
    while IFS= read -r tok; do
        [[ -z "$tok" ]] && continue
        [[ "$tok" == "RoleToken" ]] && continue
        if ! echo "$all_known_tokens" | grep -qxF "$tok"; then
            warn "Unmapped @{$tok} in Projects/Vault/Memory/Notes (non-fatal)"
        fi
    done < <(echo "$warn_tokens")
fi
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 5 — persona frontmatter tools: list validation
#
# Odin correction 5: extract tools ONLY from YAML frontmatter (first ---…--- block).
# Baseline = Read, Write, Edit, Glob, Grep, Bash
# FAIL if 'Agent' appears (whole token match — not substring).
# FAIL if extra tool not in tool-exceptions.md unless persona filename is listed there.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 5: Persona frontmatter tools validation ---"
check5_pass=true
BASELINE="Read Write Edit Glob Grep Bash"

for fpath in "$AGENTS_DIR"/*.md; do
    fname=$(basename "$fpath")
    [ "$fname" = "CLAUDE.md" ] && continue  # folder-tier CLAUDE.md is not a persona (Folder-Tier CLAUDE.md SOP)

    # Extract YAML frontmatter: content between first and second ---
    # Use awk to capture only the first ---…--- block (stops at second ---)
    # Strip a trailing \r first so CRLF files match the fence and list markers
    # identically to LF files — correctness must not depend on line endings.
    frontmatter=$(awk '
        { sub(/\r$/, "") }
        /^---$/ { count++; if (count == 2) exit; next }
        count == 1 { print }
    ' "$fpath")

    # Extract only lines under the tools: key until next non-list line
    # (handles both "tools: [A, B]" and list-form "  - Tool")
    tools_section=$(echo "$frontmatter" | awk '
        { sub(/\r$/, "") }
        /^tools:/ { in_tools=1; line=$0; sub(/^tools:[ \t]*/, "", line); gsub(/[\[\]]/, "", line); gsub(/,/, "\n", line); if (line != "") print line; next }
        in_tools && /^  - / { sub(/^  - /, ""); print; next }
        in_tools && /^[a-zA-Z]/ { exit }
        in_tools && /^\[/ { gsub(/[\[\]]/, ""); gsub(/,/, "\n"); print; exit }
    ')

    # Normalise: split comma-separated or newline-separated values.
    # POSIX [[:space:]] — NOT [ \t], which on BSD/macOS sed is the literal
    # character class {space, backslash, t} and strips a trailing 't'
    # (e.g. "Edit" -> "Edi").
    tool_list=$(echo "$tools_section" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$')

    # Loud-fail (Odin/Checkpoint A corr #4): a persona whose frontmatter or
    # tools: extraction comes back empty is a parser/file problem, not a
    # clean pass. Silent success here is exactly what hid the CRLF bug.
    if [ -z "$frontmatter" ]; then
        fail "$fname: no YAML frontmatter block parsed — file malformed or missing --- fences"
        check5_pass=false
        continue
    fi

    if ! echo "$frontmatter" | grep -q '^tools:'; then
        fail "$fname: no 'tools:' key in frontmatter — every persona must declare the explicit tool baseline (Read Write Edit Glob Grep Bash); absent key means inherit-all, which the tool-exceptions audit disallows"
        check5_pass=false
        continue
    fi

    if [ -z "$tool_list" ]; then
        fail "$fname: 'tools:' key present but no tool entries extracted — check list formatting"
        check5_pass=false
        continue
    fi

    while IFS= read -r tool; do
        [[ -z "$tool" ]] && continue

        # FAIL if Agent appears — whole-token match (Odin correction 5)
        if echo "$tool" | grep -qxE 'Agent'; then
            fail "$fname: 'Agent' found in frontmatter tools: (depth-1 invariant violation)"
            check5_pass=false
            continue
        fi

        # FAIL if tool is outside baseline and persona not in exceptions registry
        if ! echo "$BASELINE" | grep -qw "$tool"; then
            if grep -qF "$fname" "$EXCEPTIONS_FILE" 2>/dev/null; then
                : # exception registered — silent pass
            else
                fail "$fname: non-baseline tool '$tool' not in tool-exceptions.md"
                check5_pass=false
            fi
        fi
    done < <(echo "$tool_list")
done

$check5_pass && pass "All persona frontmatter tools are within baseline (no Agent, no unregistered extras)"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 6 — internal markdown links resolve to existing files
#
# Sources: CLAUDE.md, README.md, CHANGELOG.md, Vault/README.md, Resources/SOPs/*.md,
# .claude/skills/**/*.md, .claude/agents/*.md (top-level), Resources/Onboarding/**/*.md
# Extract ](relative/path) links, URL-decode %20→space.
# Skip http/https/mailto and pure-anchor (#…) links.
# Lines inside fenced code blocks (``` or ~~~) are skipped before extraction —
# illustrative markdown-template examples (e.g. write-a-skill's SKILL.md
# template) are not real links and must not false-positive as broken.
#
# Odin correction 7: resolve by STRING manipulation only — no readlink -f / realpath.
# Use -E regex only, never -P.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 6: Internal markdown links resolve ---"
check6_pass=true

# We need check6_pass to propagate — run the link check collecting failures
link_failures=0

check_links_file() {
    local source_file="$1"
    local source_dir="${source_file%/*}"
    [ "$source_dir" = "$source_file" ] && source_dir="."

    awk '
        /^[[:space:]]*(```|~~~)/ { in_fence = !in_fence; next }
        !in_fence { print }
    ' "$source_file" 2>/dev/null | grep -Eo '\]\([^)]+\)' | sed 's/^](//' | sed 's/)$//' | while IFS= read -r raw_target; do
        case "$raw_target" in
            http://*|https://*|mailto:*) continue ;;
            \#*) continue ;;
        esac

        target="${raw_target%%#*}"
        [ -z "$target" ] && continue
        target="${target//%20/ }"

        if [ "${target:0:1}" = "/" ]; then
            resolved="$PROJECT_ROOT$target"
        else
            resolved="$source_dir/$target"
        fi

        # Normalise double slashes
        while [[ "$resolved" == *//* ]]; do
            resolved="${resolved//\/\///}"
        done

        if [ ! -e "$resolved" ]; then
            echo "BROKEN:$(basename "$source_file"):$raw_target"
        fi
    done
}

link_check_sources=(
    "$PROJECT_ROOT/CLAUDE.md"
    "$PROJECT_ROOT/README.md"
    "$PROJECT_ROOT/CHANGELOG.md"
    "$PROJECT_ROOT/Vault/README.md"
)
# Add all SOPs
while IFS= read -r -d '' sop; do
    link_check_sources+=("$sop")
done < <(find "$PROJECT_ROOT/Resources/SOPs" -name "*.md" -print0 2>/dev/null)
# Add all skill files (any depth)
while IFS= read -r -d '' skl; do
    link_check_sources+=("$skl")
done < <(find "$PROJECT_ROOT/.claude/skills" -name "*.md" -print0 2>/dev/null)
# Add top-level agent (persona) files
while IFS= read -r -d '' agt; do
    link_check_sources+=("$agt")
done < <(find "$PROJECT_ROOT/.claude/agents" -maxdepth 1 -name "*.md" -print0 2>/dev/null)
# Add all onboarding files
while IFS= read -r -d '' onb; do
    link_check_sources+=("$onb")
done < <(find "$PROJECT_ROOT/Resources/Onboarding" -name "*.md" -print0 2>/dev/null)
# Add slash-command files
while IFS= read -r -d '' cmd; do
    link_check_sources+=("$cmd")
done < <(find "$PROJECT_ROOT/.claude/commands" -name "*.md" -print0 2>/dev/null)

for src in "${link_check_sources[@]}"; do
    [ -f "$src" ] || continue
    broken_list=$(check_links_file "$src")
    if [ -n "$broken_list" ]; then
        while IFS= read -r broken_line; do
            IFS=: read -r _ src_name link_path <<< "$broken_line"
            fail "Broken link in $src_name: '$link_path'"
            check6_pass=false
        done < <(echo "$broken_list")
    fi
done

$check6_pass && pass "All internal markdown links resolve"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 7 — doc counts match README assertions
#
# Live agent count: ls .claude/agents/*.md | wc -l → expect 28
# Live skill count: find .claude/skills -maxdepth 1 -mindepth 1 -type d | wc -l → expect 28
#
# Odin correction 6: target ONLY the numeric assertion in README.md (the line with
# "N reusable skill modules") — not the prose mention around line 58.
# Count reconciled at 24 via #144/#145; 25 with prompt-review, 26 with review-claudemd (2026-07-06); 27 with fast-path (2026-07-09); 28 with story-bible-builder (2026-07-14).
#
# EXPECTED_* below are a deliberate tripwire, not redundancy: adding or removing
# a skill or persona must consciously touch this file, README.md, and the docs
# together. Do not replace with live-derived counts. (Audit 2026-07-05, Senior
# Adviser ruling.)
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 7: Doc counts match README assertions ---"
check7_pass=true

EXPECTED_AGENT_COUNT=28
EXPECTED_SKILL_COUNT=28

# Live counts
live_agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | grep -cv '/CLAUDE\.md$' | tr -d ' ')
live_skill_count=$(find "$PROJECT_ROOT/.claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

# Check agent count expectation
if [ "$live_agent_count" -ne "$EXPECTED_AGENT_COUNT" ]; then
    fail "Live agent count is $live_agent_count, expected $EXPECTED_AGENT_COUNT"
    check7_pass=false
fi

# Check skill count expectation
if [ "$live_skill_count" -ne "$EXPECTED_SKILL_COUNT" ]; then
    fail "Live skill count is $live_skill_count, expected $EXPECTED_SKILL_COUNT"
    check7_pass=false
fi

# README.md: grep the numeric skill-count assertion (repo-layout block, line ~165)
# Odin correction 6: match only the specific line with a number + "reusable skill modules"
# NOT the prose mention at line ~58.
# Use grep without -n so the output is the raw line (no line-number prefix to confuse extraction).
readme_skill_line=$(grep -E '[0-9]+ reusable skill modules' "$PROJECT_ROOT/README.md" 2>/dev/null | head -1)
if [ -n "$readme_skill_line" ]; then
    readme_skill_num=$(echo "$readme_skill_line" | grep -Eo '[0-9]+' | head -1)
    if [ "$readme_skill_num" != "$live_skill_count" ]; then
        fail "README.md asserts $readme_skill_num skill modules, disk has $live_skill_count (README needs updating — plan 008)"
        check7_pass=false
    fi
else
    warn "Could not find a numeric skill-count assertion ('N reusable skill modules') in README.md"
fi

# skills/README.md: no numeric assertion line present currently — skip gracefully.

# README.md: grep the agent count assertion (the line with "N team members")
readme_agent_line=$(grep -E '[0-9]+ team members' "$PROJECT_ROOT/README.md" 2>/dev/null | head -1)
if [ -n "$readme_agent_line" ]; then
    readme_agent_num=$(echo "$readme_agent_line" | grep -Eo '[0-9]+' | head -1)
    if [ "$readme_agent_num" != "$live_agent_count" ]; then
        fail "README.md asserts $readme_agent_num team members, disk has $live_agent_count"
        check7_pass=false
    fi
fi

$check7_pass && pass "Doc counts match README assertions"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 8 — required seed files present
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 8: Required seed files present ---"
check8_pass=true

seed_files=(
    "$PROJECT_ROOT/Vault/Memory/context.example.md"
    "$PROJECT_ROOT/Vault/Memory/MEMORY.md"
    "$PROJECT_ROOT/Vault/Memory/theme-name-map.md"
    "$PROJECT_ROOT/Projects/Template/HISTORY.md"
    "$PROJECT_ROOT/Projects/Template/README.md"
)

for sf in "${seed_files[@]}"; do
    if [ -f "$sf" ]; then
        : # present — silent
    else
        fail "Seed file missing: $sf"
        check8_pass=false
    fi
done

$check8_pass && pass "All required seed files present"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 9 — reference integrity: settings.json script paths + command files
#
# (a) Every .claude/…/*.sh path embedded in .claude/settings.json "command"
#     strings (hooks and statusLine alike) must exist relative to repo root.
#     A renamed hook otherwise fails silently at session start — the same
#     silent-failure class as the #98 CRLF bug. → FAIL
# (b) Every `/name` prose reference in CLAUDE.md and .claude/hooks/*.sh should
#     resolve to .claude/commands/<name>.md, a .claude/skills/<name>/ dir, or a
#     known built-in. → WARN only (prose legitimately names plugin skills).
#
# grep -o over the JSON matches repo style; -E only, never -P.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 9: Reference integrity (settings.json scripts + command files) ---"
check9_pass=true
SETTINGS_FILE="$PROJECT_ROOT/.claude/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    fail ".claude/settings.json not found — cannot verify hook/statusLine script paths"
    check9_pass=false
else
    settings_script_paths=$(grep -Eo '\.claude/[A-Za-z0-9_./-]+\.sh' "$SETTINGS_FILE" | sort -u)

    # Loud-fail: zero extracted paths means the extraction pattern broke or the
    # hooks were removed — either way, not a clean pass (cf. Check 5's guard).
    if [ -z "$settings_script_paths" ]; then
        fail "No .claude/*.sh script paths extracted from settings.json — extraction pattern broken or hooks removed"
        check9_pass=false
    fi

    while IFS= read -r script_path; do
        [ -z "$script_path" ] && continue
        if [ ! -f "$PROJECT_ROOT/$script_path" ]; then
            fail "settings.json references missing script: $script_path"
            check9_pass=false
        fi
    done < <(echo "$settings_script_paths")
fi

$check9_pass && pass "All settings.json script references resolve"

# WARN pass: `/name` prose references in CLAUDE.md and hook scripts
BUILTIN_COMMANDS="clear model config context usage fast"
command_refs=$(grep -Eho '`/[a-z][a-z0-9-]+`' "$PROJECT_ROOT/CLAUDE.md" \
    "$PROJECT_ROOT/.claude/hooks/"*.sh 2>/dev/null | sed 's/`//g; s|^/||' | sort -u)
while IFS= read -r cmd; do
    [ -z "$cmd" ] && continue
    echo "$BUILTIN_COMMANDS" | grep -qw "$cmd" && continue
    [ -f "$PROJECT_ROOT/.claude/commands/$cmd.md" ] && continue
    [ -d "$PROJECT_ROOT/.claude/skills/$cmd" ] && continue
    warn "Prose reference '/$cmd' has no .claude/commands/$cmd.md and is not a built-in or local skill (non-fatal)"
done < <(echo "$command_refs")
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 10 — persona model: pins match documented tiers
#
# Allowed set per Persona Template SOP § Model assignment (post-plan-012).
# Frontmatter extraction reuses Check 5's CRLF-proof awk idiom.
#
# FABLE_PIN_COUNT is a deliberate hire/revert tripwire (same pattern as
# Check 7's EXPECTED_* constants): any Fable promotion/revert must consciously
# update it.
# claude-opus-4-8 is retired from the roster (Fable 5 migration, 25/07/2026):
# it is NOT in ALLOWED_MODELS, so any opus-4-8 pin fails as "undocumented".
# The invocation-time fallback for Fable 5 refusals is claude-opus-5 (released
# 24/07/2026) — an override at dispatch, never a frontmatter pin.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 10: Persona model pins match documented tiers ---"
check10_pass=true
ALLOWED_MODELS="claude-sonnet-5 claude-fable-5"  # Fable 5 roster migration (25/07/2026): opus-4-8 pins retired
FABLE_PIN_COUNT=8  # Odin + Quinn, Ryan, Harper, Finn, Drew, Remi, Lex (Fable 5 roster migration, 25/07/2026)
fable_pin_live=0

for fpath in "$AGENTS_DIR"/*.md; do
    fname=$(basename "$fpath")
    [ "$fname" = "CLAUDE.md" ] && continue  # folder-tier CLAUDE.md is not a persona (Folder-Tier CLAUDE.md SOP)

    # Same CRLF-proof first-frontmatter-block extraction as Check 5
    frontmatter=$(awk '
        { sub(/\r$/, "") }
        /^---$/ { count++; if (count == 2) exit; next }
        count == 1 { print }
    ' "$fpath")

    model_pin=$(echo "$frontmatter" | sed -n 's/^model:[[:space:]]*//p' | head -1 | sed 's/[[:space:]]*$//')

    if [ -z "$model_pin" ]; then
        fail "$fname: no 'model:' pin in frontmatter — every persona must pin a documented tier"
        check10_pass=false
        continue
    fi

    # Exact whole-value match against the allowed set (no -w: pins contain hyphens)
    case " $ALLOWED_MODELS " in
        *" $model_pin "*) : ;;
        *)
            fail "$fname: model pin '$model_pin' not in documented tiers ($ALLOWED_MODELS) — typo or undocumented model"
            check10_pass=false
            ;;
    esac

    [ "$model_pin" = "claude-fable-5" ] && ((fable_pin_live++))
done

if [ "$fable_pin_live" -ne "$FABLE_PIN_COUNT" ]; then
    warn "claude-fable-5 pin count is $fable_pin_live, tripwire expects $FABLE_PIN_COUNT — update FABLE_PIN_COUNT in this script on any Fable promotion/revert (that is its job)"
fi

$check10_pass && pass "All persona model pins match documented tiers"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 11 — skill manifest integrity
#
# Every .claude/skills/*/ dir must have a SKILL.md with 'name:' and
# 'description:' frontmatter keys, and the description must be within the
# 1024-char loader cap (plan 028 breached this once — cinema-worldbuilder-pro
# at 1195 chars — with no error anywhere; this check makes that class loud).
#
# Description may span multiple lines (YAML block/folded scalar or plain
# continuation) — continuation lines are joined with a single space before
# measuring length.
#
# Frontmatter extraction reuses Check 5/10's CRLF-proof awk idiom.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 11: Skill manifest integrity ---"
check11_pass=true
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"
DESCRIPTION_CAP=1024

for sdir in "$SKILLS_DIR"/*/; do
    sname=$(basename "$sdir")
    skill_md="$sdir/SKILL.md"

    if [ ! -f "$skill_md" ]; then
        fail "$sname: no SKILL.md"
        check11_pass=false
        continue
    fi

    # Same CRLF-proof first-frontmatter-block extraction as Check 5/10
    frontmatter=$(awk '
        { sub(/\r$/, "") }
        /^---$/ { count++; if (count == 2) exit; next }
        count == 1 { print }
    ' "$skill_md")

    if [ -z "$frontmatter" ]; then
        fail "$sname: no YAML frontmatter block parsed — SKILL.md malformed or missing --- fences"
        check11_pass=false
        continue
    fi

    if ! echo "$frontmatter" | grep -q '^name:'; then
        fail "$sname: no 'name:' key in SKILL.md frontmatter"
        check11_pass=false
    fi

    if ! echo "$frontmatter" | grep -q '^description:'; then
        fail "$sname: no 'description:' key in SKILL.md frontmatter"
        check11_pass=false
        continue
    fi

    # Join the description: line's value with any continuation lines (lines
    # until the next top-level 'key:' or end of frontmatter) into one string.
    description=$(echo "$frontmatter" | awk '
        /^description:/ { in_desc=1; line=$0; sub(/^description:[ \t]*/, "", line); buf=line; next }
        in_desc && /^[A-Za-z_-]+:/ { exit }
        in_desc { gsub(/^[ \t]+|[ \t]+$/, ""); if ($0 != "") buf = buf " " $0; next }
        END { print buf }
    ')

    desc_len=${#description}
    if [ "$desc_len" -gt "$DESCRIPTION_CAP" ]; then
        fail "$sname: description $desc_len chars exceeds the $DESCRIPTION_CAP-char loader cap"
        check11_pass=false
    fi
done

$check11_pass && pass "All 28 skills have SKILL.md, name/description frontmatter, descriptions within the 1024-char cap"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 12 — merged PRs (recent history) have a CHANGELOG.md entry
#
# CHANGELOG.md:3's own contract: "Each entry maps to a merged pull request."
# Merge style is squash-only, so every merged PR's number lands in a commit
# subject (conventional-commit style, e.g. "... (#209)"); this check reconciles
# the last 30 subjects on the current branch against CHANGELOG.md and WARNs on
# any non-exempt PR number that never made it in.
#
# CHANGELOG_EXEMPT_PRS is a maintained tripwire constant (same pattern as
# Check 7's EXPECTED_* and Check 10's FABLE_PIN_COUNT) pointing at CHANGELOG.md:3's
# own exemption clause — append to it deliberately, one PR at a time:
#   82, 100     — pure changelog-maintenance backfill PRs, named in CHANGELOG.md:3 itself.
#   184-199     — clone-local/non-template-facing era decisions, deliberately unlogged.
#   205         — drift-audit backfill PR (A1); the backfilled #201-#203 entries
#                 landed under their own numbers, so #205 (the backfill PR itself)
#                 is the pure-backfill exemption, same class as #82/#100.
#   222         — changelog backfill for #212–#219; pure-backfill class (#82/#100/#205).
#   228         — changelog backfill for #223–#227; pure-backfill class (#82/#100/#205).
#   234         — changelog backfill for #230–#232; pure-backfill class (#82/#100/#205).
#
# WARN, not FAIL: squash subject formats vary and the maintainer legitimately
# batches entries; this is a commit-time tripwire, not a hard gate.
#
# 30-commit lookback is deliberate: old unlogged pre-contract history must
# never start warning. Revisit only if warn noise appears on a quiet vault.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 12: Merged PRs reconciled against CHANGELOG.md ---"

if ! git rev-parse --git-dir >/dev/null 2>&1 || ! git log -1 >/dev/null 2>&1; then
    warn "Check 12 skipped — not a usable git history"
else
    check12_pass=true
    CHANGELOG_EXEMPT_PRS="82 100 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 205 222 228 234"

    pr_numbers=$(git log --format=%s -30 | grep -oE '#[0-9]+' | tr -d '#' | sort -un)

    for n in $pr_numbers; do
        case " $CHANGELOG_EXEMPT_PRS " in
            *" $n "*) continue ;;
        esac

        if ! grep -qE "#$n([^0-9]|$)" "$PROJECT_ROOT/CHANGELOG.md"; then
            warn "PR #$n in recent history has no CHANGELOG entry (backfill or add to CHANGELOG_EXEMPT_PRS if it's a pure-backfill PR)"
            check12_pass=false
        fi
    done

    $check12_pass && pass "All merged PRs in the last 30 commits are reconciled against CHANGELOG.md"
fi
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Check 13 — settings.json marketplaces reconciled against SETUP.md's
# accepted-risk table
#
# Motivating incident: SETUP.md's "Accepted risk — unpinned GitHub-sourced
# plugin marketplaces" section is the audit trail for third-party marketplace
# code, naming every GitHub-sourced marketplace in .claude/settings.json
# extraKnownMarketplaces plus its reviewed HEAD SHA. PR #230 removed the
# `impeccable` marketplace registration but SETUP.md kept naming it, while
# `higgsfield` (added by #172) was never added to SETUP.md at all — the doc
# drifted in both directions at once (F10, 2026-07-17 deep panel audit).
#
# Named-set reconciliation, not a count: a count check would have stayed
# green through this exact drift (one repo out, one in — count unchanged).
# This check diffs the actual repo slugs in both directions.
#
# WARN, not FAIL: same rationale as Check 12 — commit-time tripwire, not a
# hard gate; SETUP.md updates lag settings.json by design (maintainer review
# of a newly added marketplace's HEAD SHA takes time).
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 13: settings.json marketplaces reconciled against SETUP.md ---"

SETTINGS_FILE="$PROJECT_ROOT/.claude/settings.json"
SETUP_FILE="$PROJECT_ROOT/Resources/Onboarding/SETUP.md"

if ! command -v jq >/dev/null 2>&1 || [ ! -f "$SETTINGS_FILE" ]; then
    warn "Check 13 skipped — jq or settings.json unavailable"
else
    check13_pass=true

    settings_repos=$(jq -r '.extraKnownMarketplaces | to_entries[] | .value.source.repo // empty' "$SETTINGS_FILE" | tr -d '\r' | sort -u)

    for repo in $settings_repos; do
        if ! grep -qF "$repo" "$SETUP_FILE"; then
            warn "marketplace $repo in settings.json has no reviewed-SHA row in SETUP.md"
            check13_pass=false
        fi
    done

    setup_repos=$(grep -oE '^\| [A-Za-z0-9._-]+/[A-Za-z0-9._-]+ \|' "$SETUP_FILE" | sed -E 's/^\| (.*) \|$/\1/' | tr -d '\r')

    for repo in $setup_repos; do
        if ! printf '%s\n' "$settings_repos" | grep -qxF "$repo"; then
            warn "SETUP.md SHA table lists $repo but settings.json no longer registers it"
            check13_pass=false
        fi
    done

    $check13_pass && pass "settings.json marketplaces and SETUP.md accepted-risk table agree"
fi
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────────────────────────────────────
echo "==================================="
if [ "$fail_count" -gt 0 ] && [ "$warn_count" -gt 0 ]; then
    echo -e "${RED}RESULT: FAIL${NC} ($fail_count failure(s), ${YELLOW}$warn_count warning(s)${NC})"
elif [ "$fail_count" -gt 0 ]; then
    echo -e "${RED}RESULT: FAIL${NC} ($fail_count failure(s))"
elif [ "$warn_count" -gt 0 ]; then
    echo -e "${GREEN}RESULT: PASS${NC} (${YELLOW}$warn_count warning(s)${NC})"
else
    echo -e "${GREEN}RESULT: PASS${NC} (clean)"
fi
echo "==================================="
echo ""

if [ "$fail_count" -gt 0 ]; then
    exit 1
else
    exit 0
fi
