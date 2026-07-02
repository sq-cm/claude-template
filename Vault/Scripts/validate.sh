#!/usr/bin/env bash

# validate.sh — Template Vault Consistency Checker
#
# Runs 8 read-only checks to verify the vault's structural invariants.
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
#
# WARN → non-fatal, exit unaffected:
#   Check 4  — unmapped @{Token} in Projects/ or Vault/Memory/Notes/
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
# Shared helpers: extract tokens and path-table entries from the map file
# (mirrors sync-theme.sh patterns)
# ──────────────────────────────────────────────────────────────────────────────

# All YAML token lines (same extraction as sync-theme.sh line 70)
yaml_lines=$(sed -n '/```yaml/,/```/p' "$MAP_FILE" | grep -v '```' | grep -E '^[A-Za-z][A-Za-z0-9_]*:')

# Extract all tokens from YAML block, excluding Studio and Orchestrator carve-outs
get_yaml_tokens() {
    echo "$yaml_lines" | while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        line="${line%%#*}"
        token=$(echo "$line" | cut -d: -f1 | xargs)
        [[ "$token" == "Studio" ]] && continue
        [[ "$token" == "Orchestrator" ]] && continue
        echo "$token"
    done
}

# Extract all filename.md values from the path table (awk pattern from sync-theme.sh lines 42-48)
get_path_table_files() {
    awk -F'|' '
        $0 ~ /\.md`/ {
            f = $3; gsub(/^[ \t]+|[ \t]+$/, "", f); gsub(/`/, "", f)
            if (f != "") print f
        }
    ' "$MAP_FILE"
}

# Extract all token values from the path table
get_path_table_tokens() {
    awk -F'|' '
        $0 ~ /\.md`/ {
            t = $2; gsub(/^[ \t]+|[ \t]+$/, "", t)
            if (t != "") print t
        }
    ' "$MAP_FILE"
}

# Look up filename for a token (sync-theme.sh get_file_for_token)
get_file_for_token() {
    local token="$1"
    awk -F'|' -v tok="$token" '
        $0 ~ /\.md`/ {
            t = $2; gsub(/^[ \t]+|[ \t]+$/, "", t)
            f = $3; gsub(/^[ \t]+|[ \t]+$/, "", f); gsub(/`/, "", f)
            if (t == tok) { print f; exit }
        }
    ' "$MAP_FILE"
}

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
        /^tools:/ { in_tools=1; line=$0; sub(/^tools:[ \t]*/, "", line); if (line != "") print line; next }
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
# Sources: CLAUDE.md, README.md, CHANGELOG.md, Resources/SOPs/*.md
# Extract ](relative/path) links, URL-decode %20→space.
# Skip http/https/mailto and pure-anchor (#…) links.
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

    grep -Eo '\]\([^)]+\)' "$source_file" 2>/dev/null | sed 's/^](//' | sed 's/)$//' | while IFS= read -r raw_target; do
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
)
# Add all SOPs
while IFS= read -r -d '' sop; do
    link_check_sources+=("$sop")
done < <(find "$PROJECT_ROOT/Resources/SOPs" -name "*.md" -print0 2>/dev/null)

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
# Live skill count: find .claude/skills -maxdepth 1 -mindepth 1 -type d | wc -l → expect 25
#
# Odin correction 6: target ONLY the numeric assertion in README.md (the line with
# "N reusable skill modules") — not the prose mention around line 58.
# Count reconciled at 25 (Higgsfield commercial-ad workflow build: added
# seedance-commercial-director + shotlist-html-companion). README.md line ~165 and
# this constant move together when a skill is added or removed.
# ──────────────────────────────────────────────────────────────────────────────
echo "--- Check 7: Doc counts match README assertions ---"
check7_pass=true

EXPECTED_AGENT_COUNT=28
EXPECTED_SKILL_COUNT=25

# Live counts
live_agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
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
