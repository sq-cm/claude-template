---
name: tool-exceptions
description: Registry of personas holding non-canonical tools (outside the 6-tool baseline). Audits diff persona frontmatter against this file.
metadata:
  type: reference
---

# Tool Exceptions Registry

Canonical baseline (Persona Template SOP): `Read, Write, Edit, Glob, Grep, Bash`. `Agent` is forbidden in persona frontmatter — see [Sub-Agent Architecture SOP](../../Resources/SOPs/Sub-Agent%20Architecture%20SOP.md).

Any persona frontmatter declaring a tool outside the baseline must be listed here, with the Orchestrator's approval recorded. Removal follows the same gate.

## Active exceptions

| Persona | Tool | Scope | Rationale | Approved | Approver |
|---|---|---|---|---|---|
| Casey (Webflow Developer) | `WebFetch` | `link-checker` skill only — crawling static + CMS links for broken/insecure/redirect detection. Not for general web browsing, not for skills-repo update checks (use `Bash` + `git` against `Resources/Git/` clones for those). | Webflow MCP server does not expose a generic external URL fetcher. Canonical 6 cannot perform live HTTP requests against arbitrary URLs. | 2026-05-15 | Sam (per Odin Checkpoint A, vault audit H5) |

## Removed / historical exceptions

_None yet._

## How to add an entry

1. Persona's Constraints & Guardrails section must declare the three required fields (tool name, use case, why canonical insufficient) — see `Resources/SOPs/Persona Template SOP.md` § Non-canonical tool exceptions.
2. Orchestrator approves at hire time or edit time.
3. Append row to the Active exceptions table above with date and approver.
4. Persona frontmatter `tools:` list updated to include the granted tool.

## How to remove an entry

1. Orchestrator approves removal.
2. Persona frontmatter updated to remove tool.
3. Persona Constraints section updated to remove the exception block.
4. Row moved from Active to Removed/historical with date and reason.
