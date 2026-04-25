# Theme-Swap SOP

## Overview

Swap team members, change naming themes, or manage team roster with a single source of truth: `Vault/Memory/theme-name-map.md`.

This SOP covers three scenarios:
1. **Swap one team member** — replace person in a role
2. **Change the full naming theme** — rebrand all names at once
3. **Archive a retired member** — preserve attribution with date-stamped snapshots

---

## Quick Start: Sync Script

After editing `Vault/Memory/theme-name-map.md`, run:

```bash
bash Vault/Scripts/sync-theme.sh
```

This validates and syncs persona file headers to match the map. Reports what was updated.

---

## Scenario 1: Swap One Team Member

### Example: Replace Alex (SEO Specialist) with Jordan

**Step 1: Update the Map**
```yaml
# File: Vault/Memory/theme-name-map.md
SEOSpecialist: Jordan  # changed from Alex
```

**Step 2: At Next Session Start**
- The Orchestrator loads the map
- `@{SEOSpecialist}` now routes to `@Jordan`
- No folder renames, no file updates needed

**Instant result:** All routing automatically uses the new name.

---

## Scenario 2: Change Full Naming Theme

### Example: Rebrand All Names (e.g., use Character Theme)

**Step 1: Update All Names in the Map**
```yaml
# File: Vault/Memory/theme-name-map.md
Orchestrator: Frodo
HRLead: Gandalf
SeniorResearcher: Aragorn
SEOSpecialist: Legolas
WebflowDeveloper: Gimli
# ... update all 20 names
```

**Step 2: At Next Session Start**
- The Orchestrator loads the updated map
- All `@{RoleToken}` routing uses new names
- Folders and file paths unchanged

**Instant result:** Complete theme rebrand with one file edit.

---

## Scenario 3: Archive a Retired Member

When retiring or rotating out a team member, preserve historical attribution:

### Example: Archive Alex (SEO Specialist) after 2024–2026 tenure

**Step 1: Create Date-Stamped Archive Folder**
```
Vault/Archive/Team/SEO Specialist/[2024-2026-Alex]/
```

**Step 2: Move Persona File**
- Copy `.claude/agents/seo-specialist.md` to the archive folder
- Files stay intact; dates document the tenure

**Step 3: Add Successor to Role (if applicable)**
```yaml
# File: Vault/Memory/theme-name-map.md
SEOSpecialist: Jordan  # new hire
```

**Result:**
- Historical record preserved: `[2024-2026-Alex]/` shows who held the role and when
- Successor takes over the role immediately
- Future sessions use new person's name

---

## File Structure Reference

### Current Role-Based Structure
```
.claude/
  agents/
    orchestrator.md          ← Orchestrator's persona (also CLAUDE.md)
    hr-lead.md               ← HR Lead's persona
    senior-researcher.md     ← Senior Researcher's persona
    [role].md                ← all other specialist personas
Resources/
  Research/
    [role]-brief.md          ← Senior Researcher's research briefs
```

### Archive Structure (Example)
```
Vault/Archive/Team/
  SEO Specialist/
    [2024-2026-Alex]/
      seo-specialist.md      ← Alex's archived persona
      [any other files]
    [2022-2024-Kim]/
      seo-specialist.md      ← Previous SEO Specialist
```

---

## Permissions & Safeguards

- **Map edits**: Anyone can update `Vault/Memory/theme-name-map.md` to swap names
- **Archive ops**: The Orchestrator owns archival decisions but executes only when asked
- **CLAUDE.md edits**: The Orchestrator only — roster table is derived from the map, not edited directly

---

## Verification

After any theme change:

1. **Test routing**: Send `@{RoleToken}` — confirm it routes to the new person
2. **Check map**: Verify `Vault/Memory/theme-name-map.md` has the correct names
3. **Confirm no side effects**: Other routing and team operations should be unaffected

---

## Common Questions

**Q: Do I need to rename folders when I swap team members?**
No. Folders are role-based, not person-based. Swaps only require a one-line edit in the YAML map.

**Q: What if I want to bring back a retired member?**
Restore their name in the YAML map. Their archive folder stays in place for historical reference.

**Q: Can I have two people with the same name (e.g., two "Alex"s)?**
Yes, but they must be in different roles. The map key is the role token, not the person. Example: `AnalyticsReportingSpecialist: Alex` and `ContentStrategist: Alex` are fine.

**Q: Does the theme change affect existing file paths or project history?**
No. Project folders, commits, and logs reference roles, not person names. Theme changes are cosmetic (who is routing requests) and don't alter project structure.

---

## Timeline

- **Immediate**: Update map file
- **Next session start**: The Orchestrator loads new map
- **Routing**: Instantly uses new names in routing narration
- **No downtime**: No renames, no build process, no deployment

