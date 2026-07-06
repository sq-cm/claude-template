# Project Folder Template

Reference scaffold. Copy structure when starting a new project — never work directly in this folder.

See full rules: [Resources/SOPs/Project Folder SOP.md](../../Resources/SOPs/Project%20Folder%20SOP.md)

---

## Naming Convention

```
Projects/[YYMMDD] [Client or Campaign Name] - [Deliverable Type]/
```

Examples:
- `260417 WellJoy - SEO Audit/`
- `260417 AISA - CyberCon Countdown Embed/`

---

## Folder Structure

| Folder | Purpose |
|---|---|
| `HISTORY.md` | Project-scoped memory — decision log, live state, gotchas |
| `01 Briefs/` | Input briefs, reference assets, client-supplied files |
| `02 Working/` | Drafts, iterations, intermediate files |
| `03 Deliverables/` | Final outputs ready for handoff — nothing unfinished here |

Numeric prefixes enforce workflow order in alphabetical file listings (Briefs → Working → Deliverables). Not every project needs all three — Orchestrator creates only what the task requires, gaps are fine.

`HISTORY.md` is seeded from this template at folder creation and is self-contained — it travels with the project folder on handoff or archive. It's written via `/memory-reconcile` from project-tagged session notes; see [Memory Protocol SOP](../../Resources/SOPs/Memory%20Protocol%20SOP.md).
