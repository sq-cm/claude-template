# Fast-Path Lane SOP

The detail behind the [Fast-Path Lane](../../CLAUDE.md) section in CLAUDE.md. CLAUDE.md holds the operative rule (eligibility, what the lane bypasses, what it keeps, escalation); this SOP holds the rationale, worked examples, and the reasoning behind each guard. When the two disagree, **CLAUDE.md wins** — propose a fix here rather than diverging.

## Why the lane exists

The default pipeline — `grill-me` → plan → Checkpoint A → work → Checkpoint B → QA Gate — is built for durable, hard-to-unwind work. It is deliberately heavy because the cost of getting a client Deliverable wrong is high.

That same weight is disproportionate for a typo fix or a roster lookup. Before the lane existed, small tasks had only two options: run the full pipeline (wasteful) or quietly skip the framework altogether (ungoverned). The Fast-Path Lane is the sanctioned third option — it keeps light work inside the framework at a cost that matches its size, so nothing has to go off-book to stay quick.

## Eligibility — the reasoning

A task takes the lane only when **all** the CLAUDE.md eligibility conditions hold. Each condition maps to a specific risk the heavy pipeline is there to manage:

- **Single-file or single-answer output** — multi-artefact work accumulates interactions the checkpoints are designed to catch.
- **Reversible, low blast-radius** — if a mistake is cheap to undo, the upfront review earns less.
- **One persona, no fan-out** — fan-out coordination is exactly what the plan + PM layer exist for.
- **No client Deliverable** — anything destined for `03 Deliverables/` carries client-facing risk and must clear the QA Gate.
- **Not a governance-artefact edit** — SOP, persona, and CLAUDE.md changes alter how the whole team behaves; they keep the full checkpoints. CLAUDE.md edits additionally remain an Orchestrator-only operation regardless of size.

**When eligibility is ambiguous, take the full pipeline — fail safe, not fast.** The lane is a convenience, never a shortcut to dodge review.

### Examples that qualify

Terminology or typo fix · roster check · a quick reformat · a single factual question · a minor copy tweak.

## What the lane keeps, and why

The lane bypasses `grill-me`, plan mode and approval, Advisor Checkpoints A/B, and the QA Gate. It never bypasses these three:

1. **Routing.** Fast-path work is still delegated to a persona — the Orchestrator never carries it out inline. The only inline-by-Orchestrator carve-out remains `/teach`; Orchestrator-Only Operations are unchanged. Speed does not dissolve the routing rule.
2. **Locale + humaniser sanity-check.** Any prose shown to the user still gets an inline Australian-English and humaniser pass before it lands. "Working-only" is not a licence to skip this — light copy can reach the user without ever becoming a Deliverable. This is a quick inline check, not the full QA Gate.
3. **Destination.** Fast-path output never lands in `03 Deliverables/`. In-project light work → that project's `02 Working/`. Standalone light work → inline in the reply, or `Inbox/` if a file is genuinely produced. Never `Notes/` (reserved purpose).

## Escalation

If scope grows mid-task — new constraints surface, it becomes a durable deliverable, or it needs fan-out — **stop the fast-path and re-enter the full pipeline.** Do not finish on the lane and backfill governance afterwards.

Promoting any fast-path artefact into `03 Deliverables/` requires the full QA Gate first. The lane produces working material; the Gate is the only route to client-facing status.

## Relationship to the QA Gate's broad scope

The QA Gate's broad-scope opt-in (gating durable artefact changes, not just Deliverables moves) is less punishing now that this lane exists — light work has a sanctioned route that does not touch the Gate. Maintainers weighing the broad-scope opt-in should evaluate it against this lane. See [QA Gate SOP](QA%20Gate%20SOP.md) § When the QA Gate runs.
