# Context Overhead Audit SOP

Every enabled plugin, hook, MCP server, and memory file loads into context on **every session**, regardless of task size — fixed overhead that compounds across all sessions and silently erodes the working context window. This SOP is the recurring habit that keeps that overhead earning its keep.

## When to run

- Monthly, or
- Whenever the statusline session cost looks high for routine work, or
- After installing/enabling any new plugin, MCP server, or always-on hook, or
- **Garden loop trigger:** the same persona/sub-agent mistake observed twice → queue a candidate rule via step 7 (Log), at the lowest-cost tier that catches it (folder-tier `CLAUDE.md` or an SOP, before root `CLAUDE.md`).

## Procedure

1. **Measure.** Run `/context` at the start of a fresh session. Note the fixed overhead breakdown: system prompt, tool schemas, skills, MCP servers, memory.
2. **Audit both scopes** — most overhead does *not* live in this repo:
   - **Project scope:** `enabledPlugins` in `.claude/settings.json`, project hooks, and `.mcp.json` if one exists.
   - **User-global scope:** `~/.claude/settings.json` (`C:\Users\<you>\.claude\` on Windows) — global plugins, hooks, and MCP servers load in every project's sessions, not just this vault's.
3. **Check memory weight.** `Vault/Memory/MEMORY.md` and `context.md` load every prompt. `context.md`'s trigger is its hard injected budget in the [Memory Protocol SOP](Memory%20Protocol%20SOP.md) — if it is over budget, or either file has accumulated stale entries, run `/memory-reconcile` housekeeping and prune per that SOP.
4. **Decide per item:** still earning its per-session token cost? If a plugin/server hasn't been used in a month of sessions, disable it — re-enabling later is one settings line.
5. **Check folder-tier pointer validity.** For each folder-tier `CLAUDE.md` (see [Folder-Tier CLAUDE.md SOP](Folder-Tier%20CLAUDE.md%20SOP.md) for the canonical list), confirm its cited SOP still exists and still carries the rules the folder file points to — a broken or stale pointer is drift.
6. **Garden the rulebook.** Two candidate sources for pruning, both routed through step 7 (Log) — no separate channel: (a) any rule now observed as default model behaviour → candidate for deletion; (b) for each root `CLAUDE.md` rule, could it demote to a folder-tier file or SOP instead? This step only *nominates* — additions/deletions/demotions are governance-artefact edits taking the full pipeline (Checkpoints A/B; root `CLAUDE.md` stays Orchestrator-only).
7. **Log.** Note anything disabled (and why) in a session note under `Vault/Memory/Sessions/` so `/memory-reconcile` folds it into local memory.

## What this is not

- Not a licence to strip governance hooks (SessionStart context loaders, validators) — those are load-bearing, not overhead.
- Not a one-off: the value is in the recurrence. Fixed overhead only ever grows between audits.
- Not a licence to edit `CLAUDE.md` or SOPs inline mid-audit — the audit only queues candidates.
