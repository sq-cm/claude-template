# Theme Setup SOP

**Owner:** The Orchestrator  
**Audience:** The Orchestrator (execution), the Senior Researcher (research)  
**Trigger:** User requests a naming theme at any time — during setup or later

---

## Overview

This SOP governs replacing AI team member names with characters from a user-chosen theme (e.g. Vikings, Pokémon, Greek mythology), and reverting to previous names. It can be run at initial setup or at any later point.

**Scope:** Names and file paths only. Persona file *contents* (Identity, Personality Traits, Expertise Areas, Constraints) are never modified — only the name header, `@Name` address tag, cross-references to other team members, and file/folder paths.

**Name map:** `Vault/Memory/theme-name-map.md` is the source of truth for current and original names. The Orchestrator fails loudly if this file is missing or appears out of sync with the filesystem. The `Original` column is immutable — it always holds the factory defaults (Sam, Harper, Ryan, etc.) regardless of how many re-themes have been applied.

**Triggers:**
- `"Set theme to [X]"` / `"Re-theme to [X]"` — apply a new theme (replaces current names)
- `"Revert theme"` / `"Restore default names"` — roll back to original names using the map

---

## Pre-flight Checks (all operations)

Before any theme or revert operation, the Orchestrator must:

1. **Verify name map exists** — if `Vault/Memory/theme-name-map.md` is missing, halt and ask the user to confirm current team names before proceeding
2. **Check for drift** — scan `# [Name]` headings in `.claude/agents/` files against the `Current` column in the map; if any mismatch is found, flag to user and resolve before proceeding
3. **Check for collisions** — confirm no new character name already exists as a name heading in `.claude/agents/`; if collision found, ask the Senior Researcher to suggest an alternative
4. **No concurrent operations** — if a theme operation is already in progress, refuse to start another

---

## Workflow A — Apply or Change Theme

### Step 1 — User triggers

User sends a message like:
- "Set theme to Vikings"
- "Re-theme to Pokémon"
- "Change names to Greek mythology"

The Orchestrator runs pre-flight checks, then routes to the Senior Researcher.

### Step 2 — Senior Researcher researches

The Orchestrator routes to @{SeniorResearcher}: *"Research [theme]. Find 20 characters and assign them to our 20 roles using archetype matching. Return a confirmation table."*

The Senior Researcher:
1. Checks theme is appropriate — flags to the Orchestrator if the theme contains culturally sensitive, offensive, or contentious characters before proceeding
2. Searches Wikipedia or the web for a character list for the theme
3. Selects exactly 20 characters — if fewer than 20 clearly distinct characters exist, flags this to @{Orchestrator} and asks whether to (a) broaden to related characters from the same universe, or (b) pick a different theme
4. Assigns each character to a role using the archetype guide below — if two characters fit the same role equally well, picks the one with stronger narrative fit and notes the reasoning
5. Checks for idempotency — if the proposed mapping is identical to the current `theme-name-map.md`, returns "already applied" and no changes are made
6. Returns a mapping table to @{Orchestrator}

#### Archetype-to-Role Guide

| Role | Archetype to look for |
|------|-----------------------|
| Orchestrator | Leader, king, chief, main protagonist |
| HR Lead | Diplomat, mediator, people-person |
| Senior Researcher | Scholar, sage, lore-keeper, wise elder |
| SEO Specialist | Scout, messenger, networker |
| Webflow Developer | Builder, craftsperson, engineer |
| Visual AI Producer | Artist, visionary, creator |
| Senior Adviser | Elder advisor, oracle, strategist |
| Content Strategist | Storyteller, bard, communicator |
| QA Compliance Reviewer | Judge, guardian, rule-keeper |
| Copywriter | Wordsmith, poet, persuader |
| Brand Strategist | Identity-keeper, philosopher, visionary |
| Creative Technologist | Inventor, hybrid, bridge-builder |
| Video Motion Producer | Director, filmmaker, motion artist |
| Automation Architect | Systems-builder, efficiency-seeker, engineer |
| Social Media Manager | Messenger, community voice, trend-rider |
| Analytics & Reporting Specialist | Data sage, number-reader, pattern-finder |
| UX/UI Designer | Empathic builder, interface shaper, user advocate |
| Project Manager | Coordinator, task-master, timeline keeper |
| Creative Director | Visionary leader, taste-maker, aesthetic judge |
| Email Developer | Craftsperson, inbox engineer, cross-client tester |

### Step 3 — Orchestrator presents dry-run preview

The Orchestrator shows the user a confirmation table before making any changes:

| Role | Current Name | New Name | Why |
|------|-------------|----------|-----|
| Orchestrator | [current] | [NewName] | [archetype reason] |
| HR Lead | [current] | [NewName] | ... |
| Senior Researcher | [current] | [NewName] | ... |
| SEO Specialist | [current] | [NewName] | ... |
| Webflow Developer | [current] | [NewName] | ... |
| Visual AI Producer | [current] | [NewName] | ... |
| Senior Adviser | [current] | [NewName] | ... |
| Content Strategist | [current] | [NewName] | ... |
| QA Compliance Reviewer | [current] | [NewName] | ... |
| Copywriter | [current] | [NewName] | ... |
| Brand Strategist | [current] | [NewName] | ... |
| Creative Technologist | [current] | [NewName] | ... |
| Video Motion Producer | [current] | [NewName] | ... |
| Automation Architect | [current] | [NewName] | ... |
| Social Media Manager | [current] | [NewName] | ... |
| Analytics & Reporting Specialist | [current] | [NewName] | ... |
| UX/UI Designer | [current] | [NewName] | ... |
| Project Manager | [current] | [NewName] | ... |
| Creative Director | [current] | [NewName] | ... |
| Email Developer | [current] | [NewName] | ... |

User confirms or requests specific swaps. The Orchestrator adjusts and re-presents until explicitly approved. No files are touched before confirmation.

### Step 4 — Orchestrator executes

On confirmation, the Orchestrator performs the following in order:

#### 4a — Back up and update name map

1. Copy current `Vault/Memory/theme-name-map.md` to `Vault/Memory/theme-name-map-[YYYYMMDD-HHMM].md` (timestamped backup)
2. Update `Vault/Memory/theme-name-map.md` — set `Current` column to new names; `Original` column is never changed

Name map format:
```
| Role | Original | Current |
|------|----------|---------|
| Orchestrator | Sam | [NewName] |
| HR Lead | Harper | [NewName] |
...
```

#### 4b — Find-replace names in all .md files

Perform a grep-and-replace sweep across **all** `.md` files in the vault. Process these files explicitly:
1. `CLAUDE.md` — roster table (names + file paths atomically), hiring pipeline references, Advisor Checkpoints section
2. All 20 persona files — headers (`# Name — Role`), `@Name` addressing, cross-references, `Basis` section links
3. `Resources/SOPs/Advisor Checkpoints SOP.md` — audience list, file path references
4. `Resources/SOPs/Project Folder SOP.md` — any name references
5. `Resources/Onboarding/SETUP.md` — directory tree, Option B embedded template

Names are case-sensitive — match exact capitalisation. If a character name contains special characters (e.g. "Björn"), normalise for file/folder names (`bjorn-researcher.md`) but preserve the display name in markdown headers (`# Björn — Senior Researcher`).

#### 4e — Log operation

Append to `Vault/Memory/theme-change-log.md`:
```
[YYYY-MM-DD HH:MM] Applied theme: [ThemeName] — replaced [PreviousTheme or "defaults"]
```

### Step 5 — Orchestrator announces

The Orchestrator confirms completion and prints the updated roster.

---

## Workflow B — Revert to Previous or Default Names

### Step 1 — User triggers

User sends:
- `"Revert theme"` — restores the `Original` column from `theme-name-map.md`
- `"Restore default names"` — same as above

### Step 2 — Orchestrator presents dry-run preview

The Orchestrator reads `Vault/Memory/theme-name-map.md` and shows:

| Role | Current Name | Reverts To |
|------|-------------|------------|
| Orchestrator | [current] | Sam |
| HR Lead | [current] | Harper |
...

User confirms before any changes are made.

### Step 3 — Orchestrator executes

Same as Workflow A Step 4, but uses `Original` column values as the new names.

Appends to `Vault/Memory/theme-change-log.md`:
```
[YYYY-MM-DD HH:MM] Reverted to defaults
```

---

## Constraints (all operations)

- Roles never change — only names
- `@Name` syntax must be updated in every persona's "How to Address" section
- Roster table file paths must be updated atomically with folder/file renames — never update one without the other
- `Original` column in name map is immutable across all re-themes
- Wikilinks and Obsidian backlinks are **out of scope** — Obsidian manages link integrity separately
- Windows path length limit (260 chars) — if a new name would push a path over this limit, the Senior Researcher must propose a shorter alternative

### Backup retention
Keep the last 10 timestamped `theme-name-map-*.md` backups. Delete the oldest when a new one is created and the count exceeds 10.

### Concurrency lock
Before any mutation, the Orchestrator creates `Vault/Memory/.theme-lock`. On completion or failure, the Orchestrator deletes it. If a lock file already exists, the Orchestrator halts and asks the user to confirm the previous operation completed (or delete the lock manually to proceed).

### Partial failure recovery
If a rename or find-replace fails mid-batch, the Orchestrator halts immediately, reports the last successful step, and instructs the user to either (a) resume from that step manually, or (b) restore the previous state using the most recent timestamped map backup. The Orchestrator does not attempt to auto-recover.

### Missing Original column (legacy vaults)
If `Original` column is absent from the map on a revert attempt, the Orchestrator halts and asks the user to confirm the original default names (Sam, Harper, Ryan, Alex, Casey, Cleo, Odin, Sage, Quinn, Finn, Remi, Ellis, Nova, Axel, Juno, Dex, Jordan, Tate, Vera, Rory) before proceeding.

### Collision normalisation
For the collision check in pre-flight, compare names case-insensitively and strip Unicode diacritics (e.g. "Björn" and "bjorn" are treated as equivalent). If a collision is detected, the Senior Researcher proposes an alternative.

---

## Verification Checklist

- [ ] Pre-flight checks passed (map exists, no drift, no collisions)
- [ ] Dry-run preview confirmed by user
- [ ] `Vault/Memory/theme-name-map.md` `Current` column updated
- [ ] Timestamped backup of previous map exists
- [ ] All `@Name` references updated in persona files
- [ ] All `Basis` section file path links updated in persona files
- [ ] CLAUDE.md roster table shows new names and correct file paths (in sync with folders)
- [ ] `Resources/SOPs/Advisor Checkpoints SOP.md` audience list updated
- [ ] `Resources/Onboarding/SETUP.md` directory tree and Option B template updated
- [ ] Operation logged to `Vault/Memory/theme-change-log.md`
- [ ] Routing works — sending `@[NewOrchestratorName]` reaches the Orchestrator's equivalent
