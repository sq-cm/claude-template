# SOP — Roster Drift Check

**Purpose:** Ensure the two sources of team roster truth stay in sync: `Vault/Memory/theme-name-map.md` and the `.claude/agents/` files on disk.
**Audience:** Orchestrator. Run before any hire, fire, or theme-swap operation.
**Status:** Active. Owned by the Orchestrator.

---

## The Two Sources of Truth

| Source | What it governs |
|--------|----------------|
| `Vault/Memory/theme-name-map.md` | Canonical role list. Contains both the role → name YAML and the role → file-path table. Source of truth for token resolution. |
| `.claude/agents/[role].md` files | Actual persona files on disk |

`CLAUDE.md` `## Active Team Roster` section is a pointer-only; it defers entirely to `theme-name-map.md` and is not a separate source of truth.

Drift = the two sources disagree.

---

## When to run

- Before hiring a new team member
- Before firing or archiving a team member
- Before applying or reverting a naming theme
- Whenever a discrepancy is suspected

---

## Checklist

Run these checks in order. Stop and resolve any failure before proceeding with the triggering operation.

### Check 1 — theme-name-map.md file-path table ↔ .claude/agents/ files

For every row in the file-path table in `theme-name-map.md`:
- [ ] Corresponding `.claude/agents/[role].md` file exists at the path the table specifies
- [ ] Filename and path on disk match the table row exactly (does not check file contents — that is Check 2)

### Check 2 — .claude/agents/ files ↔ theme-name-map.md

For every `.claude/agents/[role].md` file:
- [ ] A matching role token exists in `theme-name-map.md` (YAML name map AND file-path table)
- [ ] The mapped name matches the `# [Name]` heading in the persona file

### Check 3 — theme-name-map.md internal consistency

Within `theme-name-map.md`:
- [ ] Every role token in the YAML name map appears in the file-path table (except `Orchestrator`, which has no agent file by design)
- [ ] Every role token in the file-path table appears in the YAML name map
- [ ] Role token spelling matches exactly between the two

### Check 4 — No orphans

- [ ] No `.claude/agents/` files exist without a matching row in `theme-name-map.md`'s file-path table
- [ ] No file-path table row references a file that does not exist

---

## Resolving Drift

| Drift type | Resolution |
|------------|------------|
| File exists, theme-name-map.md file-path row missing | Add row to the file-path table in `theme-name-map.md` |
| theme-name-map.md file-path row exists, file missing | Investigate — file may be deleted or moved; restore or remove row |
| YAML name map entry missing for a role that has a file-path row | Add entry with correct role token and current name |
| Name mismatch between YAML name map and persona file `# [Name]` heading | Correct the map entry (the persona file heading is canonical) |

After resolving, re-run all four checks before proceeding.

---

## Logging

No log entry required for a clean check. If drift is found and resolved, append a dated entry to `Vault/Memory/roster-drift-log.md` (create the file on first run) with: date, what was corrected, and the triggering operation. Ensure a one-line pointer to this log exists under `## System logs` in `Vault/Memory/context.md` (per-clone local memory — not the tracked `MEMORY.md`).
