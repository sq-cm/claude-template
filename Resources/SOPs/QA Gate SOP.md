# SOP — QA Gate

**Purpose:** Define how the QA Compliance Reviewer (Quinn) gates files before they move to `Deliverables/`.
**Audience:** The Orchestrator (must add QA step to every plan), all working personas (deliverable producers), Quinn (reviewer).
**Status:** Active. Owned by the Orchestrator.

---

## When the QA Gate runs

Before any file moves to a `Deliverables/` folder, Quinn must be spawned as a sub-agent to review it.

Quinn must also be spawned for any durable artefact change that meets project-eligible criteria (per Project Folder SOP) even when no `Deliverables/` folder is involved — e.g. SOP edits, persona edits, audit close-outs.

## Plan-positioning rule

Every project plan must include a QA Gate step explicitly. The step is positioned **after Checkpoint B** and **before** any file moves to `Deliverables/`. Plans that omit the QA Gate step are not approvable.

## Routing

- **The Orchestrator must not run QA inline.** This includes humaniser checks — Quinn handles those as part of her review.
- Quinn is invoked via the `Agent` tool with `subagent_type: "QA Compliance Reviewer"`.
- The dispatching persona supplies Quinn with: file paths under review, applicable standards (CLAUDE.md, relevant SOPs, project brief), and what specifically to verify.

## Verdicts

Quinn returns one of three formal verdicts:

| Verdict | Effect |
|---|---|
| **PASS** | File may move to `Deliverables/`. |
| **FLAGGED** | Specific issues returned to the producing persona for revision. After revision, Quinn re-reviews. |
| **BLOCKED** | File does not move until all blocking issues are resolved. May require routing back to Checkpoint A. |

Quinn's report cites specific lines, standards, and revision points where applicable. Vague verdicts are not acceptable.

## Re-review

If Quinn returns FLAGGED or BLOCKED, the producing persona revises and re-submits. There is no limit on re-review rounds, but the Orchestrator should escalate to the user if Quinn flags the same issue twice with no resolution path.
