# SOP — Advisor Checkpoints

**Purpose:** Define how and when the team consults the Senior Adviser during non-trivial work.
**Audience:** Every working persona plus the Orchestrator at routing.
**Status:** Active. Owned by the Orchestrator.

---

## Why this exists

On longer, durable deliverables, having a stronger reviewer check the plan before substantive work and check the output before handoff catches structural mistakes cheaply — before they become files, embeds, or briefs that are hard to unwind.

This SOP is a Claude-Code-native adaptation of Anthropic's Advisor tool pattern. The native advisor server-tool now ships in Claude Code (v2.1.98+) — Claude consults a stronger model at decision points, governed by the `advisorModel` setting. We layer our own discipline on top: rather than leaving advisor calls to Claude's discretion, we spawn a strong-model subagent (currently `claude-fable-5`; Fable 5 availability window — revert to `claude-opus-4-8` when it lapses) at *fixed* checkpoints. Same spirit: cheap executor for the bulk of work, strong reviewer at the moments that matter.

**Advisor-model pairing (load-bearing).** The platform requires the advisor to be **at least as capable as the request model** — peer is allowed, weaker is rejected. Odin and Quinn run on `claude-fable-5` (Fable 5 availability window; revert to `claude-opus-4-8` when it lapses), which requires `advisorModel` raised to the same tier — a user-level setting, per CHANGELOG #103. With `advisorModel` at Fable tier, their checkpoint and QA dispatches are accepted; if the setting is weaker than the gatekeeper tier, dispatches fail with `cannot be used as an advisor when the request model is '<model>'`.

> **Reverted clones:** the shipped default is Fable 5 with `advisorModel` raised to match. Clones that *revert* the gatekeepers to `claude-opus-4-8` (e.g. when the Fable window lapses) can drop the override — default Opus pairs with the default advisor and needs none.

---

## Who is the Senior Adviser

The Senior Adviser is the team's advisor-only persona. They live at `.claude/agents/senior-adviser.md`. They never write files, run tools, or produce deliverables — they only return ≤100-word enumerated advice when consulted.

The Senior Adviser is **not** directly addressable by the user. They are invoked only by **the Orchestrator**, via the Agent tool with a strong-model override (currently `claude-fable-5`; Fable 5 availability window — revert to `claude-opus-4-8` when it lapses). Per the depth-1 sub-agent rule, consulting personas never invoke the tool themselves — they return a checkpoint request to the Orchestrator, which dispatches the Senior Adviser and routes the verdict back.

---

## When to run a checkpoint

A task is **checkpoint-eligible** when it meets any of:

- Produces a durable artefact (research brief, persona file, audit report, code embed, generated image set).
- Involves committing to an interpretation or approach that's hard to unwind.
- Takes more than a few steps end-to-end.

A task is **not** checkpoint-eligible when:

- The next action is dictated entirely by tool output just read.
- It's a lookup, roster check, or single-line answer.
- It's a meta-operation the Orchestrator handles directly.

The Orchestrator flags eligibility at routing time ("That's checkpoint-eligible — @{SEOSpecialist}, run Checkpoint A before drafting.").

## The two checkpoints

1. **Checkpoint A — before substantive work.** After orientation (file reads, fetches, clarifying questions) but *before* writing, committing, or declaring an interpretation. The persona returns a checkpoint request to the Orchestrator with their intended approach; the Orchestrator dispatches the Senior Adviser and routes the verdict back.
2. **Checkpoint B — before declaring done.** After the deliverable is **durable** (file written, brief saved, image set produced). The persona returns a checkpoint request to the Orchestrator for a final review before handoff; the Orchestrator dispatches the Senior Adviser and routes the verdict back.

**Exception — the HR Lead:** One checkpoint only, before drafting the persona from the Senior Researcher's brief. The persona template is tight enough that post-draft structural review adds little.

---

## How to invoke the Senior Adviser

On receiving a persona's checkpoint request, the Orchestrator dispatches the Agent call — passing the Senior Adviser persona preamble plus the persona's context and question:

```
Agent(
  subagent_type: "general-purpose",
  model: "claude-fable-5",  # match the gatekeeper tier; see § pairing
  description: "@{SeniorAdviser} advisor checkpoint [A|B]",
  prompt: "You are @{SeniorAdviser} — Senior Adviser
           (see .claude/agents/senior-adviser.md).
           Respond in ≤100 words, enumerated steps, no explanations.

           <full task context — what the Orchestrator routed, what you've learned so far>
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
- **Orchestrator → Odin (the dispatch):** the Senior Adviser persona preamble plus the persona's request, dispatched via the `Agent` tool (the block above).
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
- The ≤100-word enumerated-steps guardrail cut advisor output roughly 35–45% in Anthropic's internal testing versus unconstrained advice.
- Two calls per non-trivial task caps the ceiling. Trivial routes skip checkpoints entirely.
- If a persona finds itself wanting a third or fourth call, that's a signal to loop back to @{Orchestrator}, not to keep consulting.

---

## Origin

Pattern adapted from Anthropic's Advisor tool (API feature, `advisor-tool-2026-03-01` beta). This SOP is the authoritative reference for the team; the original Anthropic documentation is an external source and may be moved or removed without notice.
