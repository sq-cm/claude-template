# SOP — Persona File Template

**Purpose:** Define the required structure for every team member persona file.
**Audience:** Harper (HR Lead) when creating new personas.
**Status:** Active. Owned by the Orchestrator.

---

Every persona file must contain the following sections. **Note:** Personas use actual names (from `Vault/Memory/theme-name-map.md`), not role tokens. Role tokens (`@{RoleToken}`) appear only in `CLAUDE.md` and cross-references between persona files.

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
[Flat bullet list. Each bullet: `**skill-name** — one-line trigger specific to this persona`. Target 3 bullets. 2 + 1 TODO permitted only when no honest third match exists; justify in the mapping doc. Source: vault-local skills in `.claude/skills/` only (run `ls .claude/skills/` for current inventory). For missing-but-needed skills, use placeholder: `TODO: see P2.3 — \`skill-name\``.]

## How to Address
[Exact syntax for reaching this person, e.g. "@{HRLead} I need to hire a..." — use actual name at runtime, not token]

## Constraints & Guardrails
[What this person will and won't do. Scope boundaries.]

## Workflow — Advisor Checkpoints

[Name] follows the two-checkpoint pattern defined in CLAUDE.md ("Advisor Checkpoints").

- **Checkpoint A — [role-specific trigger: when this persona consults @{SeniorAdviser} before committing to an approach].**
- **Checkpoint B — [role-specific trigger: when this persona consults @{SeniorAdviser} before declaring the work done].**

Short reactive tasks skip checkpoints.

## Team Relationships
[Who they report to, collaborate with, and hand off to.]

## Basis
[Link or reference to the Senior Researcher's research brief that informed this persona, if applicable.]
```

**Note:** In the Workflow — Advisor Checkpoints section, the framing line — `follows the two-checkpoint pattern defined in CLAUDE.md ("Advisor Checkpoints")` — must reference CLAUDE.md's section name exactly as written — consistency audits grep for that phrase across persona files.

---

## Model assignment

| Tier | Model | Assignment criteria |
|---|---|---|
| Gatekeeper | `claude-opus-4-8` | Gatekeeping authority G=5: holds genuine PASS/BLOCKED verdict power over others' deliverables, with direct error-cascade consequences. Currently: Senior Adviser, QA Compliance Reviewer. |
| Production | `claude-sonnet-5` | All other personas (currently 26). Default for new hires unless Gatekeeper criteria are met at hire time. |
| (cost note) | `claude-haiku-*` | Not assigned. Clone owners running cost-sensitive API deployments may consider Haiku for personas scoring sum ≤10 across all four dimensions (see Haiku section of roster audit). Never apply without a full re-audit of that persona's current task surface. |

A temporary flagship-window promotion (as run for Fable 5, 2026-06 to 2026-07; reverted when the window lapsed) may elevate the gatekeepers and a decided set of judgement-heavy production personas. Any such promotion records its revert target in each promoted persona's in-file model note — that note is the durable signal.

Re-evaluate tier assignments when: (a) a persona's gatekeeping authority changes materially; (b) a newer flagship model releases — update the Gatekeeper model ID; (c) a new hire scores G=5 at hire time.

---

## Agent tool — forbidden in frontmatter

Do **not** include `Agent` in any persona's `tools:` list. Claude Code does not surface the `Agent` tool to sub-agents at runtime regardless of the frontmatter grant — listing it creates a false capability contract. Only the Orchestrator (no persona file) holds dispatch authority. See [Sub-Agent Architecture SOP](Sub-Agent%20Architecture%20SOP.md) for the depth-1 constraint and the fan-out spec handoff pattern personas use instead.

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

3. **Approved by the Orchestrator at hire time or persona edit time.** Harper (HR Lead) cannot self-grant non-canonical tools when drafting a persona. The Orchestrator approves the addition before the persona file is committed.

4. **Scoped narrowly.** Grant only the use case the persona needs. Broad grants ("anything web-related") are rejected. If a stated use case could be served by a canonical tool (e.g. `Bash` + `git` for repo checks), reject the non-canonical request and use the canonical path.

Removal of a non-canonical tool follows the same approval gate.

---

## Hiring Pipeline

When a new team member is needed:

1. **The Orchestrator** identifies the gap and asks the user for permission to hire.
2. **The Senior Researcher** researches the skills and knowledge real human professionals in that role typically have, then writes a brief to `Resources/Research/[role]-brief.md`.
3. **The HR Lead** reads the brief, runs Checkpoint A with the Senior Adviser, then drafts the full persona file at `.claude/agents/[role-slug].md` following this template.
4. **The Orchestrator** announces the new hire and updates `Vault/Memory/theme-name-map.md` per the Roster Drift SOP.

Hiring is checkpoint-eligible. Persona drafts are reviewed by Quinn under the QA Gate before being committed.
