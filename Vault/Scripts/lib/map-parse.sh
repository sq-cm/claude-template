#!/usr/bin/env bash

# map-parse.sh — shared theme-name-map parser
#
# Sourced by validate.sh and sync-theme.sh. Single source of truth for parsing
# Vault/Memory/theme-name-map.md — any future schema change to the map edits
# this file once instead of two scripts in lockstep.
#
# Contract:
#   - Callers set MAP_FILE (absolute path to theme-name-map.md) before calling
#     the path-table helpers.
#   - Callers initialise the YAML block once via:
#       yaml_lines=$(load_yaml_lines "$MAP_FILE")
#     get_yaml_tokens reads that $yaml_lines variable.

# All YAML token lines (between ```yaml fences).
# Anchor to lines starting with an ASCII letter to avoid catching values that
# contain a colon.
load_yaml_lines() {
    sed -n '/```yaml/,/```/p' "$1" | grep -v '```' | grep -E '^[A-Za-z][A-Za-z0-9_]*:'
}

# Extract all tokens from the YAML block, excluding Studio and Orchestrator carve-outs
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

# Extract all filename.md values from the path table
# Table format: | Token | `filename.md` |
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

# Look up an agent filename for a token using the markdown path table
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
