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

## Theme

- [Theme name map](theme-name-map.md) — canonical token→name mappings + agent file paths; loaded at session start

## System logs

- [Repo conflict rulings](repo-conflicts.md) — log of conflicts between `Resources/Git/` guidance and CLAUDE.md/SOPs, with Odin rulings and outcomes
- [Theme change log](theme-change-log.md) — append-only log of all theme-swap operations; see `Resources/SOPs/Theme Setup SOP.md` for workflow
- [Odin misses log](odin-misses.md) — append-only log of issues Odin's checkpoints failed to catch; used to improve checkpoint prompts and SOP coverage

## Audits

- [Full-vault audit + remediation, 2026-05-24](audit_2026-05-24_full-sweep.md) — 6-agent parallel audit, Odin synthesis, 8 fixes shipped via PR #4 (executable-bit discipline, frontmatter normalization, log untracking, token replacement)
- [Full-vault audit + remediation, 2026-05-16](audit_2026-05-16_full-sweep.md) — 6-agent parallel audit, 2 blindspot scans, Odin synthesis, 13 fixes landed across SOPs/personas/hooks/onboarding

## References

- [Tool Exceptions Registry](tool-exceptions.md) — personas holding non-canonical tools beyond the 7-tool baseline; audits diff frontmatter against this file
- [Email Build Standards extraction](reference_email_build_standards.md) — 2026-05-15, Rory's technical build standards extracted to `Resources/Build Standards/email-build-standards.md` after Checkpoint A
