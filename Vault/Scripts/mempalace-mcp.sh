#!/usr/bin/env bash
# Wrapper for mempalace MCP server — resolves palace path relative to vault root.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export MEMPALACE_PALACE_PATH="${SCRIPT_DIR}/../Logs/Palace"
exec python3 -m mempalace.mcp_server
