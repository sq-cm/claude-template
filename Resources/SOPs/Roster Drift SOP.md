# SOP — Roster Drift Check

**Purpose:** Ensure the three sources of team roster truth stay in sync: `CLAUDE.md` table, `.claude/agents/` files, and `Vault/Memory/theme-name-map.md`.
**Audience:** Orchestrator. Run before any hire, fire, or theme-swap operation.
**Status:** Active. Owned by the Orchestrator.

---

## The Three Sources of Truth

| Source | What it governs |
|--------|----------------|
| `CLAUDE.md` — Active Team Roster table | Canonical role list; names and file paths shown to session |
| `.claude/agents/[role].md` files | Actual persona files on disk |
| `Vault/Memory/theme-name-map.md` | Runtime name → role mapping used for `@{RoleToken}` resolution |

Drift = any of the three disagrees with the others.

---

## When to run

- Before hiring a new team member
- Before firing or archiving a team member
- Before applying or reverting a naming theme
- Whenever a discrepancy is suspected

---

## Checklist

Run these checks in order. Stop and resolve any failure before proceeding with the triggering operation.

### Check 1 — CLAUDE.md ↔ .claude/agents/ files

For every row in the CLAUDE.md roster table:
- [ ] Corresponding `.claude/agents/[role].md` file exists
- [ ] File path in table matches actual path on disk

### Check 2 — .claude/agents/ files ↔ theme-name-map.md

For every `.claude/agents/[role].md` file:
- [ ] A matching role token exists in `theme-name-map.md`
- [ ] The mapped name matches the `# [Name]` heading in the persona file

### Check 3 — theme-name-map.md ↔ CLAUDE.md

For every entry in `theme-name-map.md`:
- [ ] Corresponding row exists in the CLAUDE.md roster table
- [ ] Role token resolves to the correct role folder

### Check 4 — No orphans

- [ ] No `.claude/agents/` files exist without a matching CLAUDE.md row
- [ ] No CLAUDE.md rows reference a file that does not exist

---

## Resolving Drift

| Drift type | Resolution |
|------------|------------|
| File exists, CLAUDE.md row missing | Add row to CLAUDE.md roster table |
| CLAUDE.md row exists, file missing | Investigate — file may be deleted or moved; restore or remove row |
| theme-name-map.md entry missing | Add entry with correct role token and current name |
| Name mismatch between map and persona file | Correct the map entry (the persona file heading is canonical) |

After resolving, re-run all four checks before proceeding.

---

## Logging

No log entry required for a clean check. If drift is found and resolved, note it in `Vault/Memory/MEMORY.md` under a `## Roster` heading with date and what was corrected.
