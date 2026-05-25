---
date: 2026-05-25
type: project
scope: audit
persona: harper
topic: P1.2 onboarding fragility shipped (PR #15)
session: P1.2 onboarding fragility
pr: 15
commit: 0af80f4
---

## Shipped

P1.2 from 2026-05-24 strategic audit. PR #15 merged to main as `0af80f4`. Five files touched:

- `.claude/commands/onboard.md` — Step 5 guard blocks for `CLAUDE_PROJECT_DIR` (Win + Unix)
- `install.sh` + `install.bat` — 4-step "Next steps" tail; SessionStart hook explained, manual `/onboard` fallback, new-user/maintainer split
- `README.md` line 32 — flipped to privilege `team-onboarding-guide.md` (bolded), demoted `SETUP.md`
- `Resources/Onboarding/SETUP.md` line 74 — dropped Harper from theme Workflow A routing (matches consolidated Theme SOP from PR #14)

## Process

- grill-me before plan (10 questions, resolved branch by branch)
- Harper as single DRI, sequential across three sub-fixes
- Quinn QA Gate: PASS (humaniser clean; emoji in onboard.md warnings flagged non-blocking — consistent with existing file convention)
- No Odin checkpoint (not checkpoint-eligible per recommendations doc)
- Single squash PR

## Decisions worth remembering

- CLAUDE.md was deliberately NOT edited even though it has the same `${CLAUDE_PROJECT_DIR}` reference. Reasoning: it's an instruction to Sam at runtime where Claude Code harness sets the env var. Only `install.*` and `/onboard` execute in shells that may lack it.
- House convention: warning emoji `⚠️` in shell-string output is accepted; user-facing prose still no-emoji.

## Pass 1 status

4 of 5 P1s shipped:
- P1.5 #12 ✓
- P1.1 #13 ✓
- P1.3 #14 ✓
- P1.2 #15 ✓
- **P1.4 outstanding** — roster MVR doc, Harper DRI, S effort. Last Pass 1 item per `recommendations_2026-05-24_strategic.md`.

## Next session

Roll into P1.4, or pause Pass 1 and switch to P2. User to decide at session open.
