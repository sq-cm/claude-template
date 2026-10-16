#!/usr/bin/env bash
# subagent-session-guard.sh — PreToolUse hook
# (matcher: mcp__ccd_session__start_session|mcp__ccd_session__hand_off_to_session).
# Blocks the desktop app's start-session and hand-off tools when a sub-agent
# calls them. Built-in sub-agents (general-purpose, the claude catch-all)
# inherit every MCP tool, and a probe on 16/10/2026 showed one could put a
# session card in front of the user with no user prompt; auto mode's
# classifier stopped a direct start, but that depends on the permission mode.
# Claude Code adds `agent_id` to the hook input only inside a sub-agent or
# in-process teammate, so the main session and `--agent` sessions pass.
# Exit 2 blocks the call and feeds stderr back to the sub-agent.
# Without jq it falls back to a raw substring check that can only block.
# Plan 166; Sub-Agent Architecture SOP § Constraint.

INPUT=$(cat)

MSG='Blocked: sub-agents do not start, propose or hand off sessions. Say in your reply what session you think is needed and why; the Orchestrator decides with the user (Sub-Agent Architecture SOP § Constraint).'

if ! command -v jq >/dev/null 2>&1; then
    case "$INPUT" in
        *'"agent_id"'*) echo "$MSG" >&2; exit 2 ;;
    esac
    exit 0
fi

AGENT_ID=$(printf '%s' "$INPUT" | jq -r '.agent_id // empty' 2>/dev/null)

if [ -n "$AGENT_ID" ]; then
    echo "$MSG" >&2
    exit 2
fi

exit 0
