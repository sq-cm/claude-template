# SOP — Advisor Checkpoints

**Purpose:** Define how and when the team consults the Senior Adviser during non-trivial work.
**Audience:** Every working persona plus the Orchestrator at routing.
**Status:** Active. Owned by the Orchestrator.

---

## Why this exists

On longer, durable deliverables, having a stronger reviewer check the plan before substantive work and check the output before handoff catches structural mistakes cheaply — before they become files, embeds, or briefs that are hard to unwind.

This SOP is a Claude-Code-native adaptation of Anthropic's Advisor tool pattern. The native advisor server-tool ships in Claude Code — Claude consults a stronger model at decision points, governed by the `advisorModel` setting. We layer our own discipline on top: rather than leaving advisor calls to Claude's discretion, we spawn a strong-model subagent at *fixed* checkpoints. Same spirit: cheap executor for the bulk of work, strong reviewer at the moments that matter.

**Advisor-model pairing (load-bearing).** The platform requires the advisor to be **at least as capable as the request model** — peer is allowed, weaker is rejected. Both gatekeepers — @{SeniorAdviser} and @{QAComplianceReviewer} — are pinned to the top tier, `claude-fable-5` (Fable 5 roster migration, 25/07/2026). Each clone owner must set `advisorModel` (a user-level setting the repo cannot ship) ≥ the gatekeeper pin — with the gatekeepers on Fable 5, that means raising `advisorModel` to `claude-fable-5` — otherwise gatekeeper dispatches fail with `cannot be used as an advisor when the request model is '<model>'`. Any clone that raises a gatekeeper above its `advisorModel` must raise `advisorModel` to match.

---

## Who is the Senior Adviser

The Senior Adviser is the team's advisor-only persona. They live at `.claude/agents/senior-adviser.md`. They never write files, run tools, or produce deliverables — they only return short enumerated advice when consulted (shape rules below).

The Senior Adviser is **not** directly addressable by the user. They are invoked only by **the Orchestrator**, via the `Agent` tool using the registered **Senior Adviser** agent type (which carries the model pin). Per the depth-1 sub-agent rule, consulting personas never invoke the tool themselves — they return a checkpoint request to the Orchestrator, which dispatches the Senior Adviser and routes the verdict back.

---

## When to run a checkpoint

This section **owns** the enumerated eligibility criteria — edit them here only; root `CLAUDE.md` § Advisor Checkpoints carries a one-line pointer, not a second copy.

A task is **checkpoint-eligible** when it meets any of:

- Produces a durable artefact (research brief, persona file, audit report, code embed, generated image set).
- Involves committing to an interpretation or approach that's hard to unwind.
- Takes more than a few steps end-to-end.

A task is **not** checkpoint-eligible when:

- The next action is dictated entirely by tool output just read.
- It's a lookup, roster check, or single-line answer.
- It's an administrative Orchestrator-only meta-op (roster review, hiring/firing/archiving, folder creation, read-only audit skills).

Governance-artefact edits — any CLAUDE.md, SOP, or persona file — stay checkpoint-eligible even though the Orchestrator executes them itself. CLAUDE.md § Advisor Checkpoints carries the operative rule.

The Orchestrator flags eligibility at routing time ("That's checkpoint-eligible — @{SEOSpecialist}, run Checkpoint A before drafting.").

## The two checkpoints

1. **Checkpoint A — before substantive work.** After orientation (file reads, fetches, clarifying questions) but *before* writing, committing, or declaring an interpretation. The persona returns a checkpoint request to the Orchestrator with their intended approach; the Orchestrator dispatches the Senior Adviser and routes the verdict back.
2. **Checkpoint B — before declaring done.** After the deliverable is **durable** (file written, brief saved, image set produced). The persona returns a checkpoint request to the Orchestrator for a final review before handoff; the Orchestrator dispatches the Senior Adviser and routes the verdict back.

**Exception — the HR Lead:** one checkpoint only, before drafting the persona from the Senior Researcher's brief. The [Persona Template SOP](Persona%20Template%20SOP.md) § Hiring Pipeline owns this exception.

---

## How to invoke the Senior Adviser

On receiving a persona's checkpoint request, the Orchestrator dispatches the registered **Senior Adviser** agent type — the persona file, response-shape rules, and model pin travel with the type, so no pasted preamble or model override is needed:

```
Agent(
  subagent_type: "Senior Adviser",
  description: "@{SeniorAdviser} advisor checkpoint [A|B]",
  prompt: "<full task context — what the Orchestrator routed, what you've learned so far>
           <current plan or draft>
           <specific question you want the Senior Adviser to answer>"
)
```

The Orchestrator narrates the checkpoint in the consulting persona's voice so the user can see when advice is being sought:

> "Checkpoint A — consulting @{SeniorAdviser} before drafting."

---

## Checkpoint-request contract

The checkpoint is a three-leg handoff. The consulting persona never calls the `Agent` tool — it requests, and the Orchestrator dispatches.

- **Persona → Orchestrator (the request):** the task context, a pointer to the current plan or draft, the specific question, and which checkpoint this is (A or B).
- **Orchestrator → Odin (the dispatch):** the persona's request, dispatched via the registered Senior Adviser agent type (the block above).
- **Odin → Orchestrator → persona (the return):** Odin's ≤100-word enumerated verdict, which the Orchestrator routes back to the persona, narrated in the persona's voice.

If a dispatch fails, the Orchestrator owns the retry per the [Odin Fallback SOP](Odin%20Fallback%20SOP.md) (Step 1).

---

## How to treat the Senior Adviser's advice

- **Give it serious weight.** A passing self-test is not evidence the advice is wrong — it's evidence your test doesn't check what the advice is checking.
- **Don't silently override.** If primary-source evidence in your transcript contradicts the advice (the file says X, the data shows Y), surface the conflict in one more call to @{SeniorAdviser}: *"I found X, you suggested Y, which constraint breaks the tie?"* A reconcile call is cheaper than committing to the wrong branch.
- **Two calls is the norm.** On non-trivial tasks, plan for exactly two @{SeniorAdviser} calls (Checkpoint A + Checkpoint B). More than three means either the task was misrouted or the persona is thrashing — loop back to @{Orchestrator}.

---

## Response-shape rules for the Senior Adviser

These are enforced in the Senior Adviser's persona file and must not be relaxed without the Orchestrator's approval — they are the cost-control lever:

- **≤100 words.**
- **Enumerated steps, not prose explanations.**
- **Name the risk or missing constraint**, not a style preference.
- **Evidence-anchored** — weight what's in the transcript over hypotheticals.
- **Reconcile explicitly** when the persona's evidence contradicts earlier advice.

---

## Cost notes

- Flagship-model subagent calls bill at that model's rates, but only for the advisor turn. The persona's own output stays on the session model.
