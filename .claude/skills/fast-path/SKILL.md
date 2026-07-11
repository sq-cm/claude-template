---
name: fast-path
description: Explicitly request the Fast-Path Lane for a light task — the sanctioned shortcut for single-file, reversible, one-persona work. Asserts eligibility, then either runs the task on the lane or auto-escalates to the full pipeline. Use when the user invokes /fast-path. Explicit invocation tool — do not fire automatically on ordinary requests.
disable-model-invocation: true
argument-hint: "The light task to fast-path"
---

This skill lets the user **explicitly request** the Fast-Path Lane (CLAUDE.md § Fast-Path Lane).
It is a pre-routing gate, in the same class as grill-me and prompt-review: it decides how a task
is handled, then hands off. It can only *request* the lane — it can never override eligibility.

Take the task from the invocation arguments. If none is supplied, ask for it once — the sole
permitted question.

Read the eligibility rule from CLAUDE.md § Fast-Path Lane before judging; never improvise it from
memory. Then run these four steps in order.

## 1. Read the task

Restate the task in one line so the eligibility verdict is auditable against it.

## 2. Assert eligibility — output the verdict, never a silent pass

Test the task against the five CLAUDE.md conditions and print a five-line verdict, one line each,
`✓ pass` / `✗ fail` (the list below is a mirror — CLAUDE.md § Fast-Path Lane wins on any drift):

- Single-file or single-answer output
- Reversible, low blast-radius
- One persona, no fan-out
- No client Deliverable (nothing destined for `03 Deliverables/`)
- Not a governance-artefact edit (SOP, persona, or any CLAUDE.md)

**Ambiguous on any line → treat it as a fail.** The lane is fail-safe, not fast — when in doubt,
escalate. This is not optional; skipping it turns the command into a review-dodge.

## 3. All five pass → run on the lane

- **Route — never inline.** Dispatch the task to the fitting persona via an `Agent` call. The
  Orchestrator does not carry it out itself; speed does not dissolve the routing rule. (`/teach`
  is the only inline carve-out, and it is not this.)
- **Locale + humaniser.** Any prose shown to the user gets an inline Australian-English and
  humaniser pass before it lands. Quick inline check, not the full QA Gate.
- **Destination.** Never `03 Deliverables/`. In-project light work → that project's `02 Working/`.
  Standalone → inline in the reply, or `Notes/` if a file is genuinely produced.

## 4. Any line fails → auto-escalate, do not stop

Name the failing condition in one line, then re-enter the full pipeline: run grill-me on the
**original task arguments** — do not re-ask the user for the task they already gave — followed by
plan mode. The lane is skipped; the task still gets done, just governed.

## Mid-task escalation

If a lane task grows mid-flight — new constraints surface, it becomes a durable Deliverable, or it
needs fan-out — **stop the lane and re-enter the full pipeline.** Do not finish on the lane and
backfill governance afterwards. Promoting any fast-path artefact into `03 Deliverables/` requires
the full QA Gate first.

## Governance

This is an inline pre-routing utility, in the grill-me / prompt-review class: it produces no
Deliverable and is QA-exempt. It does **not** relax the Fast-Path Lane's kept guards — routing,
locale + humaniser, and destination are enforced here, never waived. `disable-model-invocation`
keeps the lane from ever auto-firing; only the user typing `/fast-path` triggers it.
