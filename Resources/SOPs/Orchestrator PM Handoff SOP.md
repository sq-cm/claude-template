# SOP — Orchestrator ↔ Project Manager Handoff

**Purpose:** Define the clean boundary between @{Orchestrator} and @{ProjectManager} so pipeline ownership never overlaps or falls through.
**Audience:** @{Orchestrator} and @{ProjectManager}. Referenced at routing time and at task close.
**Status:** Active. Owned by @{Orchestrator}.

---

## The Boundary in One Line

**@{Orchestrator} routes. @{ProjectManager} tracks. Neither does the other's job.**

---

## Detailed Split

| Moment | Owner | Action |
|--------|-------|--------|
| Request arrives | @{Orchestrator} | Intercepts, assesses, routes to correct team member |
| Checkpoint-eligible flag set | @{Orchestrator} | Flags at routing time; @{ProjectManager} is looped in simultaneously |
| Task handed to team member | @{ProjectManager} | Takes over pipeline ownership; tracks through to delivery |
| Team member blocks or needs re-routing | @{ProjectManager} | Escalates to @{Orchestrator} — does NOT re-route directly |
| Deliverable declared done by team member | @{ProjectManager} | Confirms Checkpoint B was run; closes the task |
| Output handed back to user | @{Orchestrator} | Receives from @{ProjectManager}; announces completion to user |

---

## What @{Orchestrator} Does NOT do After Routing

- Track task status or progress
- Chase team members for updates
- Modify a task's scope post-routing (scope changes → new routing decision)

## What @{ProjectManager} Does NOT do

- Re-route tasks (only @{Orchestrator} routes)
- Make QA or compliance decisions
- Conduct research or produce deliverables
- Contact the user directly without @{Orchestrator} narrating the handoff

---

## Escalation Triggers

@{ProjectManager} escalates to @{Orchestrator} (not the user) when:

1. **Scope creep** — team member is doing work outside what @{Orchestrator} routed
2. **Stalled task** — no progress after a reasonable session window, no blocker surfaced
3. **Handoff failure** — Checkpoint B not run before "done" declared
4. **Capacity signal** — team member flags they cannot complete the task as routed

@{Orchestrator} resolves all escalations. @{ProjectManager} documents the escalation as a session note in `Vault/Memory/Sessions/` for `/memory-reconcile` to fold into `context.md` — never a direct edit of `context.md` or `MEMORY.md` (see the [Memory Protocol SOP](Memory%20Protocol%20SOP.md)).

---

## Conflict Resolution

If @{Orchestrator} and @{ProjectManager} disagree on task ownership or scope:

1. Both parties state their position in one sentence
2. The Orchestrator dispatches @{SeniorAdviser}: provide both positions and ask for ruling
3. Apply @{SeniorAdviser}'s ruling; log it as a session note to `Vault/Memory/Sessions/` for `/memory-reconcile` to fold into `context.md`

There is no default winner. @{SeniorAdviser} decides.
