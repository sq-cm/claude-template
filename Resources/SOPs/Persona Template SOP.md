# SOP — Persona File Template

**Purpose:** Define the required structure for every team member persona file.
**Audience:** @{HRLead} when creating new personas.
**Status:** Active. Owned by the Orchestrator.

---

Every persona file must contain the following sections. **Note:** Personas use actual names (from `Vault/Memory/theme-name-map.md`), not role tokens. Role tokens (`@{RoleToken}`) appear in `AGENTS.md`, SOPs, and cross-references between persona files.

```markdown
---
name: [Role Title]
description: [One-line description of what this agent does — used by the Orchestrator for routing]
model: [see model assignment guidance below]
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# [Name] — [Role Title]

## Identity
[Who this person is, in a short paragraph. Their voice, attitude, and way of working.]

## Personality Traits
[3–5 bullet points describing how they communicate and approach problems.]

## Expertise Areas
[Specific skills and knowledge domains this person covers.]

## Skills I Reach For
[Flat bullet list. Each bullet: `**skill-name** — one-line trigger specific to this persona`. Target 3 bullets. 2 + 1 TODO permitted only when no honest third match exists. Source: vault-local skills in `.claude/skills/` only (run `ls .claude/skills/` for current inventory). For missing-but-needed skills, use placeholder: `TODO: <capability needed — no matching vault skill yet>`.]

## Constraints & Guardrails
[What this person will and won't do. Scope boundaries.]
- **Deliverable length:** cover the substance; do not pad with filler sections, redundant summaries, or boilerplate.

## Workflow — Advisor Checkpoints

[Name] follows the two-checkpoint pattern defined in AGENTS.md ("Advisor Checkpoints").

- **Checkpoint A — [role-specific trigger: when this persona consults @{SeniorAdviser} before committing to an approach].**
- **Checkpoint B — [role-specific trigger: when this persona consults @{SeniorAdviser} before declaring the work done].**

Short reactive tasks skip checkpoints.

## Team Relationships
[Who they report to, collaborate with, and hand off to.]

## Basis
[Link or reference to the Senior Researcher's research brief that informed this persona, if applicable.]
```

**Note:** Lighter checkpoint variants exist by design where the role warrants them (e.g. the HR Lead's single pre-draft checkpoint, the Business Analyst's single pre-handoff checkpoint). Audits check the section's presence and substance, not an exact phrase.

**Note:** Persona files carry no "How to Address" section. The Orchestrator routes on frontmatter `description` (and the theme name map), not on in-file address syntax — removed corpus-wide 2026-07-11 (audit D4).

---

## Model assignment

| Tier | Model | Effort | Assignment criteria |
|---|---|---|---|
| Gatekeeper | `claude-opus-5-5` | xhigh | Gatekeeping authority G=5: holds genuine PASS/BLOCKED verdict power over others' deliverables, with direct error-cascade consequences. Currently: Senior Adviser (`claude-opus-5-5`, `effort: xhigh` — moved from `claude-fable-5-1` at `effort: high` on 14/10/2026, because on Team plan Standard seats Fable models are not bundled into plan limits and need usage credits, as reported by the user; `claude-fable-5-1` stays in `ALLOWED_MODELS` as the documented revert target) and QA Compliance Reviewer (`claude-opus-5-5`, `effort: xhigh` — moved from Fable 5 on cost/efficiency 13/08/2026 and from `claude-opus-5` to `claude-opus-5-5` on 23/09/2026, verdict authority unchanged; `xhigh` held at the 23/09/2026 re-tune by user ruling). The gatekeepers share the roster model; the tier is carried by `effort: xhigh`, the deepest effort on the roster. A flagged request falls under the platform-level Opus 5.5 fallback noted in the Judgement row — surfaced to the Orchestrator as a blocker, never a silent drop. |
| Judgement | `claude-opus-5-5` | high | Judgement-heavy production personas elevated above the Production tier without gatekeeping authority — the elevation is effort depth, not the model, as Production also runs Opus 5.5: `high` vs the Production `medium` since the 23/09/2026 re-tune (`xhigh` vs `high` from 13/08/2026 to 23/09/2026). Currently: HR Lead, Senior Researcher, Copywriter, Business Analyst, Brand Strategist, Legal and Compliance Writer. Fable 5.1-level capability at 40% less cost than Opus 5 (Opus 5.5, released 22/09/2026); revert target `claude-sonnet-5`. A flagged Opus 5.5 request can fall back to an older model in Claude Code (the 22/09/2026 launch page names `claude-opus-4-8` for cybersecurity and `claude-opus-5` for biology) — a platform-level fallback, outside roster control — surfaced to the Orchestrator as a blocker, never a silent drop. |
| Production | `claude-opus-5-5` | medium | All other personas. Default for new hires unless Gatekeeper criteria are met at hire time (a default-tier hire therefore increments both `OPUS55_PIN_COUNT` and `MEDIUM_EFFORT_COUNT` in `Vault/Scripts/validate.sh`). Moved from `claude-sonnet-5` to `claude-opus-5` on 13/08/2026 and to `claude-opus-5-5` on 23/09/2026; `claude-sonnet-5` remains the documented revert/cost target and stays in `ALLOWED_MODELS`. |
| (cost note) | `claude-haiku-*` | — | Not assigned. Clone owners running cost-sensitive API deployments may consider Haiku for personas scoring sum ≤10 across all four dimensions. Never apply without a full re-audit of that persona's current task surface. |

Effort is set via each persona's frontmatter `effort:` key (overrides the session dial when set, inherits it when omitted; the Agent tool's per-call `effort` would override the key, so persona dispatches never pass one, and the `CLAUDE_CODE_EFFORT_LEVEL` env var overrides both, per Sub-Agent Architecture SOP § Dispatch brief; harness enum: `low`/`medium`/`high`/`xhigh`/`max`, available levels depend on the model); the column above is the durable convention, and the frontmatter key is the carrier. Current values: Senior Adviser `xhigh` (since its 14/10/2026 move from Fable 5.1 to Opus 5.5; `high` before), QA Compliance Reviewer `xhigh`, the Judgement six `high`, Production `medium` (the last three per the 23/09/2026 Opus 5.5 re-tune). Evidence for the 23/09/2026 re-tune is the Opus 5.5 launch page (22/09/2026). `medium` is the model's default effort, and at that setting Opus 5.5 beats Opus 5 at `max` on Terminal-Bench for about a fifth of the cost. Early testers also report that lowest-effort Opus 5.5 beats Opus 5 at `high` with about 60% fewer output tokens. Each Opus rung therefore moved down one level, except QA Compliance Reviewer, which was held at `xhigh` by user ruling. This supersedes the 13/08/2026 roster re-tier (Senior Adviser `high`, QA Compliance Reviewer and the Judgement six `xhigh`, Production `high`), which had superseded the uniform-`high` setting of the 11/08/2026 per-role review (whose evidence-based Gatekeeper raise from `medium` stands). The column stays per-tier and may diverge again on evidence.

A tier promotion may elevate a decided set of judgement-heavy production personas above the Production default — since 13/08/2026 (Production itself on Opus) the elevation is the effort value, not a different model — since 23/09/2026 that is `high` over the Production `medium`. Currently in the Judgement tier: HR Lead, Senior Researcher, Copywriter, Business Analyst, Brand Strategist, Legal and Compliance Writer. The durable signal for any such promotion is each promoted persona's frontmatter `effort:` key together with the tier table above (the `model:` pin no longer discriminates — every persona except the Senior Adviser has shared one Opus pin since 13/08/2026, `claude-opus-5-5` since 23/09/2026, and the Senior Adviser joined it on 14/10/2026); the persona's in-file model note is a readable pointer to this SOP, not the system of record. The revert target for the Judgement tier is `claude-sonnet-5`. `claude-opus-4-8` is retired from the roster (25/07/2026), and so is `claude-opus-5` (23/09/2026).

Re-evaluate tier assignments when: (a) a persona's gatekeeping authority changes materially; (b) a newer flagship model releases — weigh it for the Gatekeeper tier against the team's plan access (the 14/10/2026 Senior Adviser move shows that a model behind usage credits blocks checkpoints for team members without them); (c) a new hire scores G=5 at hire time.

---

## Agent tool — forbidden in frontmatter

Do **not** include `Agent` in any persona's `tools:` list. Since Claude Code 2.1.219 a sub-agent that holds `Agent` can dispatch its own sub-agents, so leaving it out of `tools:` is one of two guards that keep a persona at depth 1 (validator Check 5 enforces this). Only the Orchestrator (no persona file) holds dispatch authority. See [Sub-Agent Architecture SOP](Sub-Agent%20Architecture%20SOP.md) for the depth-1 constraint and the fan-out spec handoff pattern personas use instead.

---

## `name:` field — avoid HTML-special characters

Persona `name:` fields must avoid `&` and other HTML-special characters: dispatch matches the raw `name:` value, and some callers HTML-escape the name when building the dispatch string inside a markdown/HTML context (e.g. `&` → `&amp;`), which breaks the literal match. Use `and` instead of `&`. Routing tokens (CamelCase, e.g. `AnalyticsReportingSpecialist`) are unaffected.

---

## File location

Save the completed persona file to:

```
.claude/agents/[role-slug].md
```

Use kebab-case for the slug. Example: `.claude/agents/seo-specialist.md`

---

## Non-canonical tool exceptions

The 6-tool baseline (`Read, Write, Edit, Glob, Grep, Bash`) is the default for every persona. `Agent` is never included — see "Agent tool — forbidden in frontmatter" above. Web-access tools (`WebFetch`, `ctx_*`, Playwright `browser_*`) are **never** grantable in frontmatter — they are Orchestrator-mediated per the [Sub-Agent Architecture SOP](Sub-Agent%20Architecture%20SOP.md) § Frontmatter Rule, and no exception can sanction them. A persona may declare any other non-canonical tool (e.g. a genuinely persona-scoped MCP tool) **only** under the following conditions:

1. **Justified in the persona's Constraints & Guardrails section** with three fields:
   - **Tool name**
   - **Specific use case(s)** — concrete tasks the persona performs with it
   - **Why the canonical 6 are insufficient** — what breaks without it

2. **Registered in the tool-exceptions registry.** Every non-canonical tool grant must appear in `Vault/Memory/tool-exceptions.md` with the persona name, tool name, scope, and rationale. Audits diff persona frontmatter against this registry.

3. **Approved by the Orchestrator at hire time or persona edit time.** @{HRLead} cannot self-grant non-canonical tools when drafting a persona. The Orchestrator approves the addition before the persona file is committed.

4. **Scoped narrowly.** Grant only the use case the persona needs. Broad grants ("anything web-related") are rejected. If a stated use case could be served by a canonical tool (e.g. `Bash` + `git` for repo checks), reject the non-canonical request and use the canonical path.

Removal of a non-canonical tool follows the same approval gate.

---

## Hiring Pipeline

When a new team member is needed:

1. **The Orchestrator** identifies the gap and asks the user for permission to hire.
2. **The Senior Researcher** researches the skills and knowledge real human professionals in that role typically have, then writes a brief to `Resources/Research/[role]-brief.md`.
3. **The HR Lead** reads the brief, runs Checkpoint A with the Senior Adviser, then drafts the full persona file at `.claude/agents/[role-slug].md` following this template.
4. **The Orchestrator** announces the new hire and updates `Vault/Memory/theme-name-map.md` per the Roster Drift SOP.

Hiring is checkpoint-eligible. This SOP owns the hiring exception to the two-checkpoint pattern: @{HRLead} runs **Checkpoint A only**, before drafting — no Checkpoint B, because the template is tight enough that post-draft structural review adds little. Persona drafts do not pass the QA Gate — the Gate fires only on `03 Deliverables/` moves, and persona files never move there. Instead, the Orchestrator dispatches @{QAComplianceReviewer} to review the draft against this template before it is committed: a plain review outside the Gate, not a formal PASS/FLAGGED/BLOCKED verdict.
