# Research Brief — Sample Onboarding Projects
**Researcher:** Ryan  
**Date:** 2026-01-18  
**Purpose:** Design rationale for the 5 sample projects in `Projects/`

---

## Objective

New human team members need onboarding material that teaches the orchestration system by *doing*, not reading. Sample projects should be: real-world plausible, simple enough to complete in one session, and half-done so the human has clear work to finish.

## Design Principles

1. **Each project teaches a different workflow layer** — no two projects should exercise the same primary skill
2. **Ordered by complexity** — early projects should build confidence; later projects should reveal the system's depth
3. **Checkpoints are real, not decorative** — at least one project must force an Odin consultation to completion
4. **The hiring pipeline is a first-class workflow** — it should appear as a project, not just documentation

## Project Set Rationale

### Project 1 — Bloom Bakery SEO Audit
*Most common real-world workflow.* SEO audits are the highest-frequency task in this system. Teaching Alex's format, Quinn's review layer, and the Working → Deliverables handoff covers 60% of real client work patterns.

### Project 2 — Meridian Law UX Review
*Cross-functional handoff.* Introduces Jordan + Finn + Quinn working in sequence. Teaches that deliverables are often assembled from multiple team members' outputs. WCAG checklist as a separate-but-connected artefact models how compliance work runs parallel to creative work.

### Project 3 — NovaStar Gym Social Calendar
*Multi-week, multi-specialist creative.* Teaches the Sage → Juno → Cleo production chain. Cleo's image prompt format is a concrete skill that transfers to real projects. The 4-week structure teaches calendar thinking and consistent format maintenance.

### Project 4 — Thornwood Coffee Brand Copy
*Core orchestration mechanic.* This project cannot be completed without invoking Odin twice. That's the design intent. The checkpoint-log.md with one pre-filled example entry shows the format — the human has to replicate it. Repo consultation is embedded as a TODO so the human encounters `Resources/Git/INDEX.md` in context.

### Project 5 — Velora Studio Hire Analytics Specialist
*System meta-literacy.* The hiring pipeline is the most important mechanic for long-term use of the system. Once a human understands how to hire, they understand they can extend the team for any capability gap. Placed last because it requires understanding the team structure before it makes sense. The Ryan brief is 60% done and Harper's stub is 15% done — two distinct incomplete artefacts forces the human to read two files before knowing what to do.

## What's Not Included (v1)

- **Conflict resolution** (two personas disagree → Odin tiebreak): complex to scaffold convincingly; reserved for v2
- **Archive exercise**: embedded as a bonus micro-task in Project 1 README instead
- **Marlowe's PM tracking**: Marlowe is referenced in Project 1 and 3 as part of the routing, but not the focus of any project

## Odin Advisory Notes

Odin reviewed this set and recommended:
- Reorder by complexity (implemented — see above)
- At least one project explicitly forces Checkpoint A+B (implemented — Project 4)
- Place hiring pipeline last (implemented — Project 5)
- Add repo consultation prompt (implemented — Project 4 README and checkpoint-log.md)
