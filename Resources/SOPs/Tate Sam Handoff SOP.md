# SOP — Tate ↔ Sam Handoff

**Purpose:** Define the clean boundary between Sam (Orchestrator) and Tate (Project Manager) so pipeline ownership never overlaps or falls through.
**Audience:** Sam and Tate. Referenced at routing time and at task close.
**Status:** Active. Owned by the Orchestrator.

---

## The Boundary in One Line

**Sam routes. Tate tracks. Neither does the other's job.**

---

## Detailed Split

| Moment | Owner | Action |
|--------|-------|--------|
| Request arrives | Sam | Intercepts, assesses, routes to correct team member |
| Checkpoint-eligible flag set | Sam | Flags at routing time; Tate is looped in simultaneously |
| Task handed to team member | Tate | Takes over pipeline ownership; tracks through to delivery |
| Team member blocks or needs re-routing | Tate | Escalates to Sam — does NOT re-route directly |
| Deliverable declared done by team member | Tate | Confirms Checkpoint B was run; closes the task |
| Output handed back to user | Sam | Receives from Tate; announces completion to user |

---

## What Sam Does NOT do After Routing

- Track task status or progress
- Chase team members for updates
- Modify a task's scope post-routing (scope changes → new routing decision)

## What Tate Does NOT do

- Re-route tasks (only Sam routes)
- Make QA or compliance decisions
- Conduct research or produce deliverables
- Contact the user directly without Sam narrating the handoff

---

## Escalation Triggers

Tate escalates to Sam (not the user) when:

1. **Scope creep** — team member is doing work outside what Sam routed
2. **Stalled task** — no progress after a reasonable session window, no blocker surfaced
3. **Handoff failure** — Checkpoint B not run before "done" declared
4. **Capacity signal** — team member flags they cannot complete the task as routed

Sam resolves all escalations. Tate documents the escalation in `Vault/Memory/MEMORY.md` under `## Pipeline`.

---

## Conflict Resolution

If Sam and Tate disagree on task ownership or scope:

1. Both parties state their position in one sentence
2. Invoke Odin: provide both positions and ask for ruling
3. Apply Odin's ruling; log to `Vault/Memory/MEMORY.md`

There is no default winner. Odin decides.
