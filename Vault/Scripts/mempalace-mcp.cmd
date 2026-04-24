@echo off
REM Wrapper for mempalace MCP server — resolves palace path relative to vault root.
REM %~dp0 = this script's directory (Vault\Scripts\), so %~dp0.. = Vault\
set MEMPALACE_PALACE_PATH=%~dp0..\Logs\Palace
python -m mempalace.mcp_server
