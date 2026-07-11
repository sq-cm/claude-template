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

> **Intentionally empty.** No persona currently exceeds the 6-tool canonical baseline (`Read, Write, Edit, Glob, Grep, Bash`). This empty state is by design, not an un-run audit — a diff-audit finding the table empty should treat it as "no active exceptions to register," not "audit found nothing." The two former entries (Casey/`WebFetch`, Lex/`WebFetch`) were removed on 2026-06-19 (plan 004) and recorded in the Removed / historical section below.

| Persona | Tool | Scope | Rationale | Approved | Approver |
|---|---|---|---|---|---|
| _(none)_ | | | | | |

## Removed / historical exceptions

| Persona | Tool | Scope (when active) | Reason removed | Removed | Plan |
|---|---|---|---|---|---|
| Casey (Webflow Developer) | `WebFetch` | `link-checker` skill only — crawling static + CMS links for broken/insecure/redirect detection. Not for general web browsing, not for skills-repo update checks (used `Bash` + `git` against `Resources/Git/` clones for those). | `context-mode` hard-blocks `WebFetch` for sub-agents with no opt-out; Casey runs only as a sub-agent, so the grant was impossible to use at runtime. Live link-crawl is now routed via the Orchestrator pre-fetch pattern (`ctx_fetch_and_index` at top level, crawl results passed into Casey's prompt). | 2026-06-19 | 004 |
| Lex (Legal and Compliance Writer) | `WebFetch` | Read-only statute/regulator-source lookups against a fixed 10-domain allowlist only (oaic.gov.au, legislation.gov.au, accc.gov.au, acma.gov.au, ftc.gov, cppa.ca.gov, congress.gov, edpb.europa.eu, eur-lex.europa.eu, ico.org.uk). No form submission, no fetch outside the list; flag-and-stop if a source unreachable. | `context-mode` hard-blocks `WebFetch` for sub-agents with no opt-out; Lex runs only as a sub-agent, so the grant was impossible to use at runtime. Currency-of-law retrieval is now routed via the Orchestrator pre-fetch pattern (`ctx_fetch_and_index` against the allowlist at top level, excerpts passed into Lex's prompt); the CURRENCY WARNING fallback fires when no excerpt block is present. | 2026-06-19 | 004 |

> **Annotation (2026-07-01) — rationale corrected; the removals still stand.** The "Reason removed" cells above cite a runtime-impossibility claim (`context-mode` "hard-blocks `WebFetch` for sub-agents with no opt-out… impossible to use at runtime") that empirical re-verification on 2026-07-01 found false: the tools are technically reachable from a dispatched sub-agent. Both removals still stand and remain correct — Casey and Lex hold no exception — but on the corrected basis: self-service fetch/browse by a persona is **prohibited by policy and actively policed by the environment**, not technically impossible. Live fetch is the Orchestrator's job (main-session pre-fetch, results passed into the persona's prompt). See [Sub-Agent Architecture SOP](../../Resources/SOPs/Sub-Agent%20Architecture%20SOP.md) § "Web Fetch & Visual Eval for Sub-Agents" and its 2026-07-01 Change Log entry.

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

## Sub-baseline grants

Narrowings **below** the 6-tool baseline are recorded here for the same audit purpose — a diff of persona frontmatter against the baseline also surfaces missing tools, and this table says which gaps are deliberate.

| Persona | Granted tools | Removed from baseline | Rationale | Date | Plan |
|---|---|---|---|---|---|
| Odin (Senior Adviser) | `Read, Glob, Grep` | `Write, Edit, Bash` | Advice-only role — persona (:59 "No execution") and Advisor Checkpoints SOP state Odin never writes files, runs tools, or produces deliverables; the full grant was a false capability contract (audit C4). | 2026-07-11 | phase-4-personas |
