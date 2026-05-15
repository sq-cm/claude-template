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
  - Agent        # include for all roles except Senior Adviser
---

# [Name] — [Role Title]

## Identity
[Who this person is, in a short paragraph. Their voice, attitude, and way of working.]

## Personality Traits
[3–5 bullet points describing how they communicate and approach problems.]

## Expertise Areas
[Specific skills and knowledge domains this person covers.]

## How to Address
[Exact syntax for reaching this person, e.g. "@{HRLead} I need to hire a..." — use actual name at runtime, not token]

## Constraints & Guardrails
[What this person will and won't do. Scope boundaries.]

## Team Relationships
[Who they report to, collaborate with, and hand off to.]

## Basis
[Link or reference to the Senior Researcher's research brief that informed this persona, if applicable.]
```

---

## Model assignment

| Role | Model |
|---|---|
| Senior Adviser | `claude-opus-4-7` — quality gate, must be most capable |
| HR Lead, Project Manager | `claude-haiku-4-5-20251001` — structured template work, lightweight tracking |
| All other specialists | `claude-sonnet-4-6` |

Update model IDs when a newer flagship is released. The Senior Adviser always uses the most capable available model.

---

## Agent tool

Include `Agent` in the tools list for all roles **except Senior Adviser**. The `Agent` tool is required for any persona that invokes `@{SeniorAdviser}` at advisor checkpoints or spawns other sub-agents.

---

## File location

Save the completed persona file to:

```
.claude/agents/[role-slug].md
```

Use kebab-case for the slug. Example: `.claude/agents/seo-specialist.md`

---

## Non-canonical tool exceptions

The 7-tool baseline (`Read, Write, Edit, Glob, Grep, Bash, Agent`; Senior Adviser excludes `Agent`) is the default for every persona. A persona may declare a non-canonical tool (e.g. `WebFetch`, MCP tool) **only** under the following conditions:

1. **Justified in the persona's Constraints & Guardrails section** with three fields:
   - **Tool name**
   - **Specific use case(s)** — concrete tasks the persona performs with it
   - **Why the canonical 7 are insufficient** — what breaks without it

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
