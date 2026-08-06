# Memory Index

<!--
This file is the SHIPPED, git-tracked vault-operations index — maintainer-curated and the
same for every install. It is loaded into context on every prompt.

READ-ONLY for downstream clones. Do NOT write local facts here — local memory (reconciled
session notes, the onboarding bootstrap entry, per-clone decisions) belongs in `context.md`
(git-ignored). Writing local entries here causes rebase conflicts on `/update` that drop
`<<<<<<< HEAD` markers into this file and corrupt every subsequent prompt.

Who edits this file: only the template maintainer, when shipping durable changes to the
vault's operating knowledge (governance pointers, workflow rules, references). `/memory-reconcile`
NEVER writes here — it targets `context.md`. See CLAUDE.md § Memory and the Memory Protocol SOP.

Format: freeform markdown. Use H2 headings to separate topics.

SECURITY: Do not store API keys, passwords, or credentials here.
This file is committed to git.
-->

## Workflow preferences

- [Run humaniser on all content output](feedback_humaniser.md) — canonical rule in `Resources/SOPs/QA Gate SOP.md` § Humaniser rule (canonical); applies to every written deliverable, no size exemption

## Theme

- [Theme name map](theme-name-map.md) — canonical token→name mappings + agent file paths; loaded at session start

## System logs

- [Repo conflict rulings](repo-conflicts.md) — log of conflicts between `Resources/Git/` guidance and CLAUDE.md/SOPs, with Odin rulings and outcomes
- [Theme change log](theme-change-log.md) — append-only log of all theme operations; see `Resources/SOPs/Theme SOP.md` for workflow
- [Odin misses log](odin-misses.md) — append-only log of issues Odin's checkpoints failed to catch; used to improve checkpoint prompts and SOP coverage

## References

- [Tool Exceptions Registry](tool-exceptions.md) — personas holding non-canonical tools beyond the 6-tool baseline; audits diff frontmatter against this file
