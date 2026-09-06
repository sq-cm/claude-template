# This folder — persona files

> **Loads on Read.** `.claude/` injects like any other folder — the first Read of a file in this folder attaches this file to the tool result (verified 29/07/2026 and again 06/09/2026, the latter on Claude Code 2.1.263; a 06/07/2026 test recorded no injection — cause not recorded, most likely a harness change). The rules below restate their authoritative sources — the root CLAUDE.md and the SOPs cited here. See [Folder-Tier CLAUDE.md SOP](../../Resources/SOPs/Folder-Tier%20CLAUDE.md%20SOP.md).

Authoritative detail: [Persona Template SOP](../../Resources/SOPs/Persona%20Template%20SOP.md).

- Persona files are governance artefacts: full pipeline only — never Fast-Path; edits carry Advisor Checkpoints A and B.
- Structure and frontmatter follow the Persona Template SOP; tools beyond the canonical baseline must be registered in `Vault/Memory/tool-exceptions.md`.
- Roster changes update `Vault/Memory/theme-name-map.md` and `theme-change-log.md`.
- Writes under `.claude/` prompt for confirmation by design — expected, not an error.
- This file is Orchestrator-only, like the root CLAUDE.md.
