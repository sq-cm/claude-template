#!/bin/bash

# Sync Theme Script
# Synchronizes theme-name-map.md with persona file headers
# Run after editing Vault/Memory/theme-name-map.md to keep map and persona files in sync

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MAP_FILE="$PROJECT_ROOT/Vault/Memory/theme-name-map.md"
TEAM_DIR="$PROJECT_ROOT/Team"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ ! -f "$MAP_FILE" ]; then
    echo -e "${RED}✗ Error: Map file not found at $MAP_FILE${NC}"
    exit 1
fi

if [ ! -d "$TEAM_DIR" ]; then
    echo -e "${RED}✗ Error: Team directory not found at $TEAM_DIR${NC}"
    exit 1
fi

echo "Syncing theme map to persona files..."
echo ""

synced_count=0
already_synced=0
error_count=0

# Extract YAML mappings (lines between ```yaml and ```)
yaml_lines=$(sed -n '/```yaml/,/```/p' "$MAP_FILE" | grep -v '```' | grep ':')

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Parse role_token and role_name
    role_token=$(echo "$line" | cut -d: -f1 | xargs)
    role_name=$(echo "$line" | cut -d: -f2 | xargs)

    # Find persona file for this role token
    # Search in Team folders
    found_file=""
    for team_folder in "$TEAM_DIR"/*; do
        if [ -d "$team_folder" ]; then
            folder_name=$(basename "$team_folder")
            # Convert folder name to token format
            token=$(echo "$folder_name" | sed 's/ //g' | sed 's/&//g' | sed 's/-//g')

            if [ "$token" = "$role_token" ]; then
                # Found matching folder, look for persona file
                persona=$(find "$team_folder" -maxdepth 1 -name "*.md" -type f | head -1)
                if [ -n "$persona" ]; then
                    found_file="$persona"
                    break
                fi
            fi
        fi
    done

    if [ -z "$found_file" ]; then
        echo -e "${YELLOW}⚠ Warning: No persona file found for role token '$role_token'${NC}"
        ((error_count++))
        continue
    fi

    # Check if header matches
    current_header=$(head -1 "$found_file" | sed 's/^# //')
    expected_header="$role_name — $(basename "$(dirname "$found_file")")"

    if [ "$current_header" != "$expected_header" ]; then
        # Update header using safer sed with | delimiter
        folder_name=$(basename "$(dirname "$found_file")")
        sed -i.bak "1s|^.*|# $role_name — $folder_name|" "$found_file"
        rm -f "$found_file.bak"
        echo -e "${GREEN}✓ Updated: $role_token → $role_name${NC}"
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
