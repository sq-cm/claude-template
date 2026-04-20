# SOP — Advisor Checkpoints

**Purpose:** Define how and when the team consults the Opus Advisor during non-trivial work.
**Audience:** Every working persona plus the Orchestrator at routing.
**Status:** Active. Owned by the Orchestrator.

---

## Why this exists

On longer, durable deliverables, having a stronger reviewer check the plan before substantive work and check the output before handoff catches structural mistakes cheaply — before they become files, embeds, or briefs that are hard to unwind.

This SOP is a Claude-Code-native adaptation of Anthropic's Advisor tool pattern. The native tool is an API feature that switches models mid-generation inside a single `/v1/messages` request. That feature is **not** available inside Claude Code sessions — our personas all run on one session model. So instead of pretending to invoke it, we spawn an Opus-powered subagent at fixed checkpoints. Same spirit: cheap executor for the bulk of work, strong reviewer at the moments that matter.

---

## Who is the Opus Advisor

The Opus Advisor is the team's advisor-only persona. They live at [Team/Odin - Opus Advisor/odin-opus-advisor.md](../../Team/Odin%20-%20Opus%20Advisor/odin-opus-advisor.md). They never write files, run tools, or produce deliverables — they only return ≤100-word enumerated advice when consulted.

The Opus Advisor is **not** directly addressable by the user. They are invoked only by other personas during their turn, using the Agent tool with an Opus model override.

---

## When to run a checkpoint

A task is **checkpoint-eligible** when it meets any of:

- Produces a durable artifact (research brief, persona file, audit report, code embed, generated image set).
- Involves committing to an interpretation or approach that's hard to unwind.
- Takes more than a few steps end-to-end.

A task is **not** checkpoint-eligible when:

- The next action is dictated entirely by tool output just read.
- It's a lookup, roster check, or single-line answer.
- It's a meta-operation the Orchestrator handles directly.

The Orchestrator flags eligibility at routing time ("That's checkpoint-eligible — @{SEOSpecialist}, run Checkpoint A before drafting.").

## The two checkpoints

1. **Checkpoint A — before substantive work.** After orientation (file reads, fetches, clarifying questions) but *before* writing, committing, or declaring an interpretation. The persona consults the Opus Advisor with their intended approach.
2. **Checkpoint B — before declaring done.** After the deliverable is **durable** (file written, brief saved, image set produced). The persona consults the Opus Advisor for a final review before handoff back to the Orchestrator.

**Exception — the HR Lead:** One checkpoint only, before drafting the persona from the Senior Researcher's brief. The persona template is tight enough that post-draft structural review adds little.

---

## How to invoke the Opus Advisor

Inside the persona's turn, call the Agent tool:

```
Agent(
  subagent_type: "general-purpose",
  model: "opus",
  description: "@{OpusAdvisor} advisor checkpoint [A|B]",
  prompt: "You are Odin — Opus Advisor
           (see Team/Odin - Opus Advisor/odin-opus-advisor.md).
           Respond in ≤100 words, enumerated steps, no explanations.

           <full task context — what the Orchestrator routed, what you've learned so far>
           <current plan or draft>
           <specific question you want the Opus Advisor to answer>"
)
```

Narrate the checkpoint in the persona's own voice so the user can see when advice is being sought:

> "Checkpoint A — consulting @{OpusAdvisor} before drafting."

---

## How to treat the Opus Advisor's advice

- **Give it serious weight.** A passing self-test is not evidence the advice is wrong — it's evidence your test doesn't check what the advice is checking.
- **Don't silently override.** If primary-source evidence in your transcript contradicts the advice (the file says X, the data shows Y), surface the conflict in one more call to @{OpusAdvisor}: *"I found X, you suggested Y, which constraint breaks the tie?"* A reconcile call is cheaper than committing to the wrong branch.
- **Two calls is the norm.** On non-trivial tasks, plan for exactly two @{OpusAdvisor} calls (Checkpoint A + Checkpoint B). More than three means either the task was misrouted or the persona is thrashing — loop back to @{Orchestrator}.

---

## Response-shape rules for the Opus Advisor

These are enforced in the Opus Advisor's persona file and must not be relaxed without the Orchestrator's approval — they are the cost-control lever:

- **≤100 words.**
- **Enumerated steps, not prose explanations.**
- **Name the risk or missing constraint**, not a style preference.
- **Evidence-anchored** — weight what's in the transcript over hypotheticals.
- **Reconcile explicitly** when the persona's evidence contradicts earlier advice.

---

## Cost notes

- Opus subagent calls bill at Opus rates, but only for the advisor turn. The persona's own output stays on the session model.
- The ≤100-word enumerated-steps guardrail cut advisor output roughly 35–45% in Anthropic's internal testing versus unconstrained advice.
- Two calls per non-trivial task caps the ceiling. Trivial routes skip checkpoints entirely.
- If a persona finds itself wanting a third or fourth call, that's a signal to loop back to @{Orchestrator}, not to keep consulting.

---

## Origin

Pattern adapted from Anthropic's Advisor tool (API feature, `advisor-tool-2026-03-01` beta). This SOP is the authoritative reference for the team; the original Anthropic documentation is an external source and may be moved or removed without notice.
