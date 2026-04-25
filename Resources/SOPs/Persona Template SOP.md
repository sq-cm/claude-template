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
