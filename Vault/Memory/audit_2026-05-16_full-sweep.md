---
name: audit-2026-05-16-full-sweep
description: 2026-05-16 full-vault audit + remediation pass — 6 parallel auditors, 2 blindspot scans, Odin checkpoint, 13 fixes landed
metadata:
  type: project
---

Full-vault audit ordered by user 2026-05-16. Six parallel auditors covered personas, hooks/settings/commands, SOPs, Vault/Memory, root/CLAUDE.md, Learn/Research. Two blindspot scans covered persona↔theme-map referential integrity and settings drift.

**Why:** User requested comprehensive vault health check with fan-out execution and Odin synthesis. Prior remediation passes had focused on individual subsystems; this was the first end-to-end sweep.

**How to apply:** When a future audit produces overlapping findings, check whether this remediation already closed the issue — many "drift" findings (stale paths, name leakage, broken pointers) were addressed in this pass. Re-run with same fan-out shape for next major audit.

## Findings tally

- 3 HIGH, 5 MED, ~18 LOW across 6 domains
- Both blindspot scans clean: no referential breaks, no silent tool-permission failures

## Fixes landed

**SOP theme-portability (HIGH):**
- `Resources/SOPs/Odin Fallback SOP.md` body role-tokenized (filename retained per Odin recommendation)
- `Resources/SOPs/Tate Sam Handoff SOP.md` renamed → `Orchestrator PM Handoff SOP.md`, fully role-tokenized; CLAUDE.md row + SOPs README updated

**Persona consistency (HIGH/MED):**
- `business-analyst.md` heading normalized → `## Advisor Checkpoints`
- `senior-adviser.md` Advisor Checkpoints exemption section added (Odin IS the advisor)

**Documentation gaps (MED):**
- `Resources/Research/hr-lead-brief.md` written retroactively (Ryan, ~760 words, metadata flags reconstruction)
- `.env.example` documents `CLAUDE_TEMPLATE_MAINTAINER` as shell-profile-only var
- `Vault/Memory/theme-change-log.md` seeded with baseline row

**Theme Setup SOP (MED):**
- Numbering renumbered 4a/4b/4e → 4a/4b/4c
- Static 20-role list replaced with pointer to live roster (`theme-name-map.md`)
- Schema reconciled to YAML (was 3-column table — divergent from actual file)
- Verification checklist updated for current vault structure (Learn/index.html, Onboarding files)

**Onboarding canonicalization:**
- `Resources/Onboarding/setup-guide.md` retired (deleted); Option B prompt was stale (19-role roster, predated current 24-role structure)
- Caveman Mode block absorbed into `SETUP.md` as appendix
- `README.md` reference updated → `SETUP.md`

**Hooks & infrastructure (LOW):**
- `.claude/hooks/session-start-onboarding.sh:45` log string `settings.local.json` → `onboarding-flags.json`
- `Resources/Learn/index.html` `LAST_SYNCED` bumped 2026-05-04 → 2026-05-16

**CLAUDE.md polish:**
- Dotfolder/dotfile carve-out footnote added under Vault Structure table

## Judgment calls (both UPHELD by Odin)

1. Option B Claude prompt NOT preserved (deviated from Ryan's "absorb as appendix" rec) — stale instructions in live docs cause more harm than lost history; archive would be the home if preservation mattered
2. Odin Fallback SOP filename retained (only body tokenized) — filename is identifier not prose; renaming breaks inbound links for zero semantic gain

## Blindspots Odin flagged that turned out clean

- Persona ↔ theme-map referential integrity: 24/24 match both directions
- `.claude/skills/` health: all 13 skills present, only minor doc-drift (humaniser not explicitly named in CLAUDE.md but reachable)
- `.claude/settings.json` drift: no silent breaks; runtime prompts only for unknown WebFetch domains

## Items deferred / not addressed

- Skills doc-drift in CLAUDE.md (humaniser explicit naming) — LOW, deferred
- WebFetch domain allowlist for Casey's link-checker — runtime prompts acceptable
- Persona Template SOP using "Harper"/"Quinn" in prose examples — Odin downgraded to false-positive
- `subagent_type: "general-purpose"` vs named subagent invocation divergence — by design (Odin needs model override, Quinn doesn't)
- `onboard.md` Windows-vs-macOS path inconsistency — cosmetic

See [[feedback_humaniser]] for ongoing humaniser requirement; [[feedback_qa_routing]] for Quinn gate behaviour.
