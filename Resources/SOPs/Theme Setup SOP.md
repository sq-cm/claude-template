# Theme Setup SOP

**Owner:** The Orchestrator  
**Audience:** The Orchestrator (execution), the Senior Researcher (research)  
**Trigger:** User requests a naming theme at any time — during setup or later

---

## Overview

This SOP governs replacing AI team member names with characters from a user-chosen theme (e.g. Vikings, Pokémon, Greek mythology), and reverting to previous names. It can be run at initial setup or at any later point.

**Scope:** Names and file paths only. Persona file *contents* (Identity, Personality Traits, Expertise Areas, Constraints) are never modified — only the name header, `@Name` address tag, cross-references to other team members, and file/folder paths.

**Name map:** `Vault/Memory/theme-name-map.md` is the source of truth for current names. Format is a YAML block (`RoleToken: CurrentName`) followed by an explicit role-token-to-file-path table. The Orchestrator fails loudly if this file is missing or appears out of sync with the filesystem. Factory defaults (Sam, Harper, Ryan, etc.) are recorded in `Vault/Memory/theme-change-log.md` as the baseline entry — that log is the audit trail for theme operations.

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

The Orchestrator routes to @{SeniorResearcher}: *"Research [theme]. Find N characters (where N = current roster size; check `Vault/Memory/theme-name-map.md`) and assign them to our roles using archetype matching. Return a confirmation table."*

The Senior Researcher:
1. Checks theme is appropriate — flags to the Orchestrator if the theme contains culturally sensitive, offensive, or contentious characters before proceeding
2. Searches Wikipedia or the web for a character list for the theme
3. Counts the current roster from `Vault/Memory/theme-name-map.md` YAML block — this is the authoritative N (roster grows over time; do not hard-code). Selects exactly N characters — if fewer than N clearly distinct characters exist, flags this to @{Orchestrator} and asks whether to (a) broaden to related characters from the same universe, or (b) pick a different theme
4. Assigns each character to a role using the archetype guide below — if two characters fit the same role equally well, picks the one with stronger narrative fit and notes the reasoning
5. Checks for idempotency — if the proposed mapping is identical to the current `theme-name-map.md`, returns "already applied" and no changes are made
6. Returns a mapping table to @{Orchestrator}

#### Archetype-to-Role Guide

Illustrative archetypes for the canonical core roles. For any role not listed (later hires), @{SeniorResearcher} derives the archetype from the persona's `description` field in `.claude/agents/[role-slug].md` and the role's research brief in `Resources/Research/`.

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

> **Note:** This table reflects the founding 20 roles. The live roster (`Vault/Memory/theme-name-map.md`) is authoritative — any later additions (e.g. Business Analyst, Mobile Developer, etc.) use archetypes derived from their persona/brief at theme-application time.

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
2. Update `Vault/Memory/theme-name-map.md` — replace YAML values with new names. Role tokens (keys) are immutable; only the names (values) change.

Name map format (canonical YAML — do not introduce alternate schemas):
```yaml
Orchestrator: [NewName]
HRLead: [NewName]
SeniorResearcher: [NewName]
...
```

The accompanying explicit role-token-to-file-path table below the YAML stays untouched — file paths are role-based, not name-based.

#### 4b — Find-replace names in all .md files

Perform a grep-and-replace sweep across **all** `.md` files in the vault. Process these files explicitly:
1. `CLAUDE.md` — any name references (file paths are role-token-based and need no rename)
2. All persona files in `.claude/agents/` — headers (`# Name — Role`), `@Name` addressing, cross-references
3. All SOPs in `Resources/SOPs/` that mention names — most use `@{RoleToken}` and need no rename; check `Advisor Checkpoints SOP.md`, `Persona Template SOP.md`, `Orchestrator PM Handoff SOP.md`
4. `Resources/Onboarding/SETUP.md`, `Resources/Onboarding/team-onboarding-guide.md` — directory tree and any prose name references
5. `Resources/Learn/index.html` — `TEAM` array name fields and `LAST_SYNCED` constant

Names are case-sensitive — match exact capitalisation. If a character name contains special characters (e.g. "Björn"), normalise for file/folder names (`bjorn-researcher.md`) but preserve the display name in markdown headers (`# Björn — Senior Researcher`).

#### 4c — Log operation

Append to `Vault/Memory/theme-change-log.md`:
```
| YYYY-MM-DD | Applied | [PreviousTheme or "defaults"] | [ThemeName] | N | [notes] |
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

The Orchestrator reads `Vault/Memory/theme-change-log.md` to find the most recent baseline (or chosen prior-theme row) and shows:

| Role | Current Name | Reverts To |
|------|-------------|------------|
| Orchestrator | [current] | [original from log] |
| HR Lead | [current] | [original from log] |
...

User confirms before any changes are made.

### Step 3 — Orchestrator executes

Same as Workflow A Step 4, but uses the baseline values from `theme-change-log.md` as the new names.

Appends to `Vault/Memory/theme-change-log.md`:
```
[YYYY-MM-DD HH:MM] Reverted to defaults
```

---

## Constraints (all operations)

- Roles never change — only names
- `@Name` syntax must be updated in every persona's "How to Address" section
- Roster table file paths must be updated atomically with folder/file renames — never update one without the other
- Role tokens (YAML keys) in name map are immutable across all re-themes; only names (values) change
- Wikilinks and Obsidian backlinks are **out of scope** — Obsidian manages link integrity separately
- Windows path length limit (260 chars) — if a new name would push a path over this limit, the Senior Researcher must propose a shorter alternative

### Backup retention
Keep the last 10 timestamped `theme-name-map-*.md` backups. Delete the oldest when a new one is created and the count exceeds 10.

### Concurrency lock
Before any mutation, the Orchestrator creates `Vault/Memory/.theme-lock`. On completion or failure, the Orchestrator deletes it. If a lock file already exists, the Orchestrator halts and asks the user to confirm the previous operation completed (or delete the lock manually to proceed).

### Partial failure recovery
If a rename or find-replace fails mid-batch, the Orchestrator halts immediately, reports the last successful step, and instructs the user to either (a) resume from that step manually, or (b) restore the previous state using the most recent timestamped map backup. The Orchestrator does not attempt to auto-recover.

### Missing baseline (legacy vaults)
If `Vault/Memory/theme-change-log.md` has no baseline entry on a revert attempt, the Orchestrator halts and asks the user to confirm the original default names (Sam, Harper, Ryan, Alex, Casey, Cleo, Odin, Sage, Quinn, Finn, Remi, Ellis, Nova, Axel, Juno, Dex, Jordan, Tate, Vera, Rory, Kai, Reid, Drew, Luca, Milo) before proceeding. Note: this list reflects the roster at last SOP update; for accuracy check `Vault/Memory/theme-name-map.md` and ask the user about any roles added since.

### Collision normalisation
For the collision check in pre-flight, compare names case-insensitively and strip Unicode diacritics (e.g. "Björn" and "bjorn" are treated as equivalent). If a collision is detected, the Senior Researcher proposes an alternative.

---

## Verification Checklist

- [ ] Pre-flight checks passed (map exists, no drift, no collisions)
- [ ] Dry-run preview confirmed by user
- [ ] `Vault/Memory/theme-name-map.md` YAML values updated; role tokens unchanged
- [ ] Timestamped backup of previous map exists
- [ ] All `@Name` references updated in persona files
- [ ] All `Basis` section file path links updated in persona files
- [ ] CLAUDE.md name references updated (file paths are role-based and need no change)
- [ ] SOPs that reference names directly are updated (most use `@{RoleToken}` and need no rename)
- [ ] `Resources/Onboarding/SETUP.md` directory tree and `Resources/Onboarding/team-onboarding-guide.md` prose names updated
- [ ] `Resources/Learn/index.html` `TEAM` array name fields and `LAST_SYNCED` updated
- [ ] Operation logged to `Vault/Memory/theme-change-log.md`
- [ ] Routing works — sending `@[NewOrchestratorName]` reaches the Orchestrator's equivalent
