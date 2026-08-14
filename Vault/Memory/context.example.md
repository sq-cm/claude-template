# Local Context

<!--
This file is THIS CLONE's local team memory — per-machine, git-ignored, never pushed.

It is the write target for:
- The onboarding bootstrap entry (see Resources/Onboarding/SETUP.md, Step 4)
- `/memory-reconcile` Stage-2 pointer lines (session notes folded in from Vault/Memory/Sessions/)
- Any durable local fact, decision, or project context the team accumulates as it works

Why this file exists (and why NOT to write local facts into MEMORY.md):
`MEMORY.md` is the shipped, git-tracked vault-operations index — maintainer-curated, the
same for every install. Writing local facts there causes rebase conflicts on `/update`
(conflict markers land in a file that is cat'd into context every prompt, corrupting it).
This file is git-ignored, so it never participates in template updates. Write here freely.

Format: freeform markdown. Use the H2 headings below so `/memory-reconcile` always finds a
home for its pointer lines (it routes by note `type` — see the Memory Protocol SOP).

PRUNE POLICY: keep entries as ONE-LINE pointers (link + <=12-word hook). Budget: 3 KB
injected — /memory-reconcile auto-demotes the oldest Project-context pointers to
Notes/archive-index.md when exceeded. Tag operative rulings `[standing]` to exempt them —
tags are re-tested at every reconcile (step 5.9); completed-work tags are removed there.
Full detail lives in the linked Notes/YYYY-MM/ files. Only the live-state entry stays expanded.

`## Project context` holds ONE line per ACTIVE project, pointing at that project's own
`Projects/<name>/CONTEXT.md` — not the detail itself. Current truths (vocabulary, live state,
gotchas) accrue in that file; the decision trail accrues in `Projects/<name>/HISTORY.md`. Both
are written by /memory-reconcile from notes carrying a `project:` frontmatter field, and both
are read on demand, never injected, so neither has a size budget.
See Resources/SOPs/Memory Protocol SOP.md § Project-scoped memory.

SECURITY: Do not store API keys, passwords, or credentials here.
This file may be synced to cloud storage.
-->

## Session Bootstrap

<!-- Filled in during onboarding (SETUP.md, Step 4). Replace the placeholders below. -->

<!--
## Session Bootstrap — [YYYY-MM-DD]

- Vault deployed from template
- Theme: [default / name of theme applied]
- Active team size: 28
- Notes: [anything worth remembering from setup]
-->

## Workflow preferences

## Workflow corrections

## Project context

<!-- Example (once a project has an active CONTEXT.md) — one line, dedup by project folder
     within this section:
- [Client Onboarding Revamp](Projects/Client%20Onboarding%20Revamp/CONTEXT.md) — mid-build, webhook auth pending
-->

## References

## User profile

## System logs

## Uncategorised
