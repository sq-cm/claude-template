---
name: audit-2026-05-24-full-sweep
description: 6-agent parallel template audit + Odin synthesis on 2026-05-24, 8 fixes shipped via PR #4
metadata:
  type: project
---

# Full-vault audit + remediation, 2026-05-24

**Scope:** 6 parallel sub-agents covered structure/governance, personas/roster, skills/commands/hooks, memory system, Resources/SOPs, git/repo hygiene. Odin (SeniorAdviser) synthesized.

**Findings:** 9 punch list items across HIGH/MED/LOW. Roster came back GREEN (24/24 personas clean).

**Fixes shipped via PR #4 (squash-merged as 994af2a):**

1. `chmod 755 .githooks/{pre-commit,pre-push}` + `session-start-onboarding.sh` — hooks were 644, silently skipped. Pre-commit/pre-push template guards now actually fire.
2. Removed non-existent `Audits/` row from `Vault/README.md`.
3. Reworded `.env` carve-out in `CLAUDE.md` §Vault Structure to fix self-contradiction with permitted-files table.
4. Replaced hardcoded "Quinn" with `@{QAComplianceReviewer}` token across CLAUDE.md (3 spots: §QA Gate, §HTML Companion, §Authoritative References).
5. Added `metadata.type: reference` frontmatter to `reference_email_build_standards.md`.
6. Migrated `feedback_humaniser.md` + `feedback_qa_routing.md` from flat `type:` to nested `metadata.type:` convention (matches CLAUDE.md `# auto memory` spec).
7. Untracked per-vault append-only logs (`theme-change-log.md`, `odin-misses.md`, `repo-conflicts.md`) — gitignored + `git rm --cached`. Template seed memory remains tracked.
8. Annotated `Resources/Git/INDEX.md` Domain Index as intentionally empty — populated per-vault from `IMPORT.md` examples.

**Strategic pattern Odin named:** executable-bit discipline gap. Recommend adding `chmod 755 .githooks/* .claude/hooks/*.sh` to install scripts to close recurrence vector.

**Missed domains flagged for next sweep:**
- End-to-end resolution check of every `.claude/settings.json` hook path
- `install.sh` vs `install.bat` cross-platform parity
- Skill orphan detection (skills referenced nowhere)
- Theme-map → agent-file reverse direction check

**Related:** [[feedback-humaniser]], [[feedback-qa-routing]]

**PR:** https://github.com/sq-cm/claude-template/pull/4
