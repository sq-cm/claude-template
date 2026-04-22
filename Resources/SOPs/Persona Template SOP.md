# SOP — Persona File Template

**Purpose:** Define the required structure for every team member persona file.  
**Audience:** Harper (HR Lead) when creating new personas.  
**Status:** Active. Owned by the Orchestrator.

---

Every persona file must contain the following sections. **Note:** Personas use actual names (from `Vault/Memory/theme-name-map.md`), not role tokens. Role tokens (`@{RoleToken}`) appear only in `CLAUDE.md` and cross-references between persona files.

```markdown
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

## File location

Save the completed persona file to:

```
Team/[Role Title]/[role].md
```

Example: `Team/SEO Specialist/seo-specialist.md`
