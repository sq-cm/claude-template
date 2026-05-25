#!/bin/bash

# Sync Theme Script
# Synchronizes theme-name-map.md with persona file H1 headers in .claude/agents/.
# Run after editing Vault/Memory/theme-name-map.md to keep map and persona files in sync.
#
# Scope: replaces only the Name portion of each persona's H1 line ("Name — Role Label").
# The Role Label portion is preserved exactly as-is.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MAP_FILE="$PROJECT_ROOT/Vault/Memory/theme-name-map.md"
AGENTS_DIR="$PROJECT_ROOT/.claude/agents"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ ! -f "$MAP_FILE" ]; then
    echo -e "${RED}✗ Error: Map file not found at $MAP_FILE${NC}"
    exit 1
fi

if [ ! -d "$AGENTS_DIR" ]; then
    echo -e "${RED}✗ Error: Agents directory not found at $AGENTS_DIR${NC}"
    exit 1
fi

echo "Syncing theme map to persona files in $AGENTS_DIR ..."
echo ""

synced_count=0
already_synced=0
error_count=0

# Look up an agent filename for a token using the markdown path table in the map file.
# Table format: | Token | `filename.md` |
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

# Replace the Name portion of an H1 line. Preserves the " — Role Label" tail verbatim.
# Returns 0 on success and writes the new header to stdout; returns 1 if the header
# does not match the expected "# Name — Role Label" shape.
rewrite_h1() {
    local existing="$1"
    local new_name="$2"
    # Strip the leading "# " for parsing
    local body="${existing#\# }"
    # Find the " — " separator (em-dash with spaces)
    if [[ "$body" != *" — "* ]]; then
        return 1
    fi
    local tail="${body#*— }"
    echo "# ${new_name} — ${tail}"
    return 0
}

# Extract YAML mappings (lines between ```yaml and ```)
# Anchor to lines starting with an ASCII letter to avoid catching values that contain a colon.
yaml_lines=$(sed -n '/```yaml/,/```/p' "$MAP_FILE" | grep -v '```' | grep -E '^[A-Za-z][A-Za-z0-9_]*:')

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Strip inline comments
    line="${line%%#*}"

    # Parse role_token and role_name
    role_token=$(echo "$line" | cut -d: -f1 | xargs)
    role_name=$(echo "$line" | cut -d: -f2- | xargs)

    # Skip the Studio variable — it's not a role
    [[ "$role_token" == "Studio" ]] && continue

    # The Orchestrator token has no agent file by design
    if [[ "$role_token" == "Orchestrator" ]]; then
        echo -e "${GREEN}✓ Skipped: Orchestrator (no agent file by design)${NC}"
        continue
    fi

    agent_filename=$(get_file_for_token "$role_token")

    if [ -z "$agent_filename" ]; then
        echo -e "${YELLOW}⚠ Warning: No file mapping found for role token '$role_token' in map's path table${NC}"
        ((error_count++))
        continue
    fi

    found_file="$AGENTS_DIR/$agent_filename"

    if [ ! -f "$found_file" ]; then
        echo -e "${YELLOW}⚠ Warning: Persona file not found at $found_file${NC}"
        ((error_count++))
        continue
    fi

    # Find the first H1 line and parse it
    current_h1=$(grep -m1 '^# ' "$found_file")
    if [ -z "$current_h1" ]; then
        echo -e "${YELLOW}⚠ Warning: No H1 found in $agent_filename${NC}"
        ((error_count++))
        continue
    fi

    expected_h1=$(rewrite_h1 "$current_h1" "$role_name") || {
        echo -e "${YELLOW}⚠ Warning: H1 in $agent_filename does not match 'Name — Role Label' shape: '$current_h1'${NC}"
        ((error_count++))
        continue
    }

    if [ "$current_h1" != "$expected_h1" ]; then
        # Update the first H1 line. Use a python one-liner for portable in-place rewrite.
        python3 - "$found_file" "$current_h1" "$expected_h1" <<'PY'
import sys, pathlib
path = pathlib.Path(sys.argv[1])
old = sys.argv[2]
new = sys.argv[3]
text = path.read_text(encoding="utf-8")
# Replace only the first occurrence
idx = text.find(old)
if idx == -1:
    sys.exit(2)
path.write_text(text[:idx] + new + text[idx + len(old):], encoding="utf-8")
PY
        if [ $? -ne 0 ]; then
            echo -e "${YELLOW}⚠ Warning: Failed to rewrite H1 in $agent_filename${NC}"
            ((error_count++))
            continue
        fi
        echo -e "${GREEN}✓ Updated: $role_token → $role_name ($agent_filename)${NC}"
        ((synced_count++))
    else
        echo -e "${GREEN}✓ In sync: $role_token → $role_name${NC}"
        ((already_synced++))
    fi
done <<< "$yaml_lines"

echo ""
echo "Summary:"
echo "  Updated: $synced_count"
echo "  Already synced: $already_synced"
if [ $error_count -gt 0 ]; then
    echo -e "  ${RED}Errors: $error_count${NC}"
fi

if [ $error_count -eq 0 ]; then
    echo -e "${GREEN}✓ Sync complete!${NC}"
    exit 0
else
    echo -e "${RED}✗ Sync completed with errors.${NC}"
    exit 1
fi
