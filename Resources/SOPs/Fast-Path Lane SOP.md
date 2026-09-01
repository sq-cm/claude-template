# Fast-Path Lane SOP

The detail behind the [Fast-Path Lane](../../CLAUDE.md) section in CLAUDE.md. CLAUDE.md holds the operative rule (eligibility, invocation, what the lane bypasses, what it keeps, escalation); this SOP holds the rationale, worked examples, and the reasoning behind each guard. When the two disagree, **CLAUDE.md wins** — propose a fix here rather than diverging.

## Why the lane exists

The default pipeline — `grill-me` → plan → Checkpoint A → work → Checkpoint B → QA Gate — is built for durable, hard-to-unwind work. It is deliberately heavy because the cost of getting a client Deliverable wrong is high.

That same weight is disproportionate for a typo fix or a roster lookup. Before the lane existed, small tasks had only two options: run the full pipeline (wasteful) or quietly skip the framework altogether (ungoverned). The Fast-Path Lane is the sanctioned third option — it keeps light work inside the framework at a cost that matches its size, so nothing has to go off-book to stay quick.

## Invoking the lane

The lane is chosen two ways:

- **By judgement (default).** The Orchestrator assesses each request and takes the lane when all
  eligibility conditions hold. No command needed.
- **Explicitly, via `/fast-path <task>`.** The user requests the lane directly. The skill
  (`.claude/skills/fast-path/SKILL.md`) is `disable-model-invocation: true`, so only the user can
  trigger it — the model never auto-fires the lane.

Both routes assert eligibility rather than assume it. `/fast-path` prints an auditable five-line
verdict (one per condition) before acting. On an eligible task it runs the lane — routing to a
persona, declared-locale + humaniser pass, working-only destination. On an **ineligible** task it names the
failing condition and **auto-escalates**: it re-enters the full pipeline by feeding the original
task into grill-me, then plan mode. It never silently proceeds and never re-asks for the task.

The command can only *request* the lane. It cannot override eligibility, so it cannot be used to
push a governance edit, a Deliverable, or fan-out work through the light route — the escalation
path catches exactly those.

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

CLAUDE.md § Fast-Path Lane holds the operative Bypasses and Keeps lists. The reasoning behind each keep:

1. **Routing.** Ungoverned inline work is exactly what the lane exists to prevent — speed does not dissolve the routing rule, and Orchestrator-Only Operations are unchanged.
2. **Declared-locale + humaniser sanity-check.** Light copy can reach the user without ever becoming a Deliverable, so the inline pass is the only check it will ever get. The locale checked is the one the project declares — `en-AU` when nothing declares one (see [Output Locale SOP](Output%20Locale%20SOP.md)). It is a quick inline check, not the full QA Gate.
3. **Destination.** `03 Deliverables/` implies QA-passed — letting fast-path output land there would counterfeit that signal. Standalone files land in the active chat's `outputs/` when a chat is active — with the five-line verdict appended to that chat's `CHAT.md § Log`, which is the lane's audit trail there — and otherwise in `Notes/`, which keeps the staging function for unrouted material. See [Chats SOP](Chats%20SOP.md).

## Escalation

If scope grows mid-task — new constraints surface, it becomes a durable deliverable, or it needs fan-out — **stop the fast-path and re-enter the full pipeline.** Do not finish on the lane and backfill governance afterwards.

Promoting any fast-path artefact into `03 Deliverables/` requires the full QA Gate first. The lane produces working material; the Gate is the only route to client-facing status.
