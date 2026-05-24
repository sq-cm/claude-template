---
name: feedback-qa-routing
description: Quinn (QA Compliance Reviewer) must be spawned as a sub-agent for all deliverable reviews, including humaniser checks. Orchestrator must not run these checks directly.
metadata:
  type: feedback
---

Always spawn Quinn (QA Compliance Reviewer) as a sub-agent before any file moves to Deliverables. This includes humaniser output review — do not run humaniser in the main conversation and call it done.

**Why:** The Orchestrator's core rule is it never carries out work itself. Running QA inline breaks that rule and bypasses the formal verdict (PASS / FLAGGED / BLOCKED) that Quinn is built to produce.

**How to apply:** In any project plan, add an explicit QA step between "Checkpoint B complete" and "move to Deliverables." Spawn Quinn with the deliverable path and the compliance standards to check against. Only move the file after Quinn returns PASS.
