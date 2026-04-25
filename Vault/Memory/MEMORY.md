# Memory Index

<!--
This file is the Orchestrator's persistent memory store for this vault.

What gets logged here:
- Decisions and context that should survive session resets
- Theme change logs and name maps (if a theme has been applied)
- Recurring preferences, project conventions, or user instructions
- Links to durable artifacts worth remembering across sessions

Format: freeform markdown. Use H2 headings to separate topics.
The Orchestrator reads and writes this file directly — do not delete entries without archiving them first.

SECURITY: Do not store API keys, passwords, or credentials here.
This file may be committed to git or synced to cloud storage.
-->

## Workflow preferences

- [Run humaniser on all content output](feedback_humaniser.md) — apply `/humaniser` to every written deliverable before finalising; no exceptions for short docs
- [QA routing — spawn Quinn as sub-agent](feedback_qa_routing.md) — Quinn must be spawned for all deliverable reviews; Orchestrator must not run QA inline; QA step belongs in every plan before files move to Deliverables

## System logs

- [Repo conflict rulings](repo-conflicts.md) — log of conflicts between `Resources/Git/` guidance and CLAUDE.md/SOPs, with Odin rulings and outcomes
- [Theme change log](theme-change-log.md) — append-only log of all theme-swap operations; see `Resources/SOPs/Theme Setup SOP.md` for workflow
