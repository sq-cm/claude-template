# Theme SOP

**Owner:** The Orchestrator
**Audience:** The Orchestrator (execution), the Senior Researcher (character research when needed)
**Trigger:** User requests a naming theme, a member swap, a revert, or an archive — any time during the vault's life

---

## Overview

Covers every name-related operation: apply a theme, swap one member, revert to defaults, archive a retired member. Source of truth is `Vault/Memory/theme-name-map.md`. Supersedes the earlier `Theme Setup SOP.md` and `Theme-Swap SOP.md` (now removed).

**Scope.** Names and file paths only. Persona file *contents* (Identity, Personality Traits, Expertise Areas, Constraints) are not modified — only the name header, `@Name` address tag, cross-references to other team members, and file/folder paths.

**Name map.** `Vault/Memory/theme-name-map.md` holds the canonical YAML block (`RoleToken: CurrentName`) and an explicit role-token-to-file-path table. The Orchestrator fails loudly if this file is missing or out of sync with the filesystem.

**Change log.** All operations append a row to `Vault/Memory/theme-change-log.md` using the pipe-table format below.

---

## Operations covered

| Operation | Trigger | Workflow |
|---|---|---|
| Apply a theme | "Set theme to [X]" / "Re-theme to [X]" | Workflow A |
| Swap one member | "Replace [old] with [new] in role [X]" | Workflow C |
| Revert to defaults | "Revert theme" / "Restore default names" | Workflow B |
| Archive a retired member | "Archive [name]" | Workflow D |

---

## Pre-flight checks (all workflows)

Before any mutation, the Orchestrator must:

1. **Verify name map exists.** If `Vault/Memory/theme-name-map.md` is missing, halt and ask the user to confirm current team names before proceeding.
2. **Check for drift.** Scan `# [Name]` headings in `.claude/agents/` files against the YAML block in the map. If any mismatch, flag to user and resolve before proceeding. Running `bash Vault/Scripts/sync-theme.sh` first will report and repair header drift. *Workflow C exception:* one-line swaps may skip the drift scan for non-target roles — drift in unrelated roles must not block a single-member swap. The Orchestrator should still check the target role's H1 before mutating.
3. **Check for collisions.** Confirm no new name already appears as a name heading in `.claude/agents/`. Compare case-insensitively and strip Unicode diacritics ("Björn" and "bjorn" are equivalent). If a collision is detected, route to @{SeniorResearcher} for an alternative.
4. **No concurrent operations.** Before any mutation, the Orchestrator creates `Vault/Memory/.theme-lock`. On completion or failure, the Orchestrator deletes it. If the lock file already exists, halt and ask the user to confirm the previous operation finished (or delete the lock manually).

---

## Workflow A — apply or change a theme

Triggered by: "Set theme to Vikings", "Re-theme to Pokémon", "Change names to Greek mythology", etc.

### Step 1 — Route to Senior Researcher

The Orchestrator runs pre-flight checks, then routes to @{SeniorResearcher}:

> *"Research [theme]. Find N characters (where N = current roster size; check `Vault/Memory/theme-name-map.md`) and assign them to our roles using archetype matching. Return a confirmation table."*

The Senior Researcher:

1. Flags any culturally sensitive, offensive, or contentious characters to the Orchestrator before proceeding.
2. Searches Wikipedia or the web for a character list for the theme.
3. Counts the current roster from the map's YAML block — this is the authoritative N (the roster grows over time; do not hard-code). Selects exactly N distinct characters. If fewer than N are available, flags to @{Orchestrator} and asks whether to (a) broaden to related characters from the same universe, or (b) pick a different theme.
4. Assigns each character to a role using the archetype guide below. If two characters fit equally well, picks the one with stronger narrative fit and notes the reasoning.
5. Checks for idempotency. If the proposed mapping is identical to the current map, returns "already applied" and no changes are made.
6. Returns the mapping table to @{Orchestrator}.

#### Archetype-to-role guide

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
| Analytics and Reporting Specialist | Data sage, number-reader, pattern-finder |
| UX/UI Designer | Empathic builder, interface shaper, user advocate |
| Project Manager | Coordinator, task-master, timeline keeper |
| Creative Director | Visionary leader, taste-maker, aesthetic judge |
| Email Developer | Craftsperson, inbox engineer, cross-client tester |

> The live roster (`Vault/Memory/theme-name-map.md`) is authoritative. Later additions (Business Analyst, Mobile Developer, etc.) use archetypes derived from their persona/brief at theme-application time.

### Step 2 — Dry-run preview

The Orchestrator shows the user a confirmation table before making any changes:

| Role | Current Name | New Name | Why |
|------|-------------|----------|-----|
| Orchestrator | [current] | [NewName] | [archetype reason] |
| HR Lead | [current] | [NewName] | ... |

User confirms or requests specific swaps. The Orchestrator adjusts and re-presents until explicitly approved. No files are touched before confirmation.

### Step 3 — Execute

On confirmation, the Orchestrator performs the following in order:

**3a. Back up and update name map.**
1. Copy current `Vault/Memory/theme-name-map.md` to `Vault/Memory/theme-name-map-[YYYYMMDD-HHMM].md`.
2. Update `Vault/Memory/theme-name-map.md` — replace YAML values with new names. Role tokens (keys) are immutable; only the names (values) change.

**3b. Sync persona file headers.** Run `bash Vault/Scripts/sync-theme.sh`. The script updates the H1 line of each persona file in `.claude/agents/` so it matches the map.

**3c. Cross-file find-replace (manual).** The script only covers persona H1 headers. The Orchestrator must perform a manual sweep across the following for any name references:
1. `CLAUDE.md` — name references (file paths are role-token-based and need no rename).
2. All persona files in `.claude/agents/` — `@Name` addressing, cross-references to other team members. (The H1 is already handled by the script.)
3. SOPs in `Resources/SOPs/` — most use `@{RoleToken}`, but several carry display names directly. Don't rely on a fixed list: grep the folder for each current display name (the vault-wide grep in the final check below catches stragglers).
4. `Resources/Onboarding/SETUP.md`, `Resources/Onboarding/team-onboarding-guide.md` — directory tree and any prose name references.
5. `Resources/Learn/index.html` and any sibling JS/data files in `Resources/Learn/` — `TEAM` array name fields and the `LAST_SYNCED` constant.
6. `Notes/` — daily notes or weekly reviews may reference personas by name; sweep these too.

**Authoritative final check.** After the sweep, run a vault-wide grep for each replaced name to confirm no stragglers:

```bash
grep -rn "[OldName]" --include="*.md" --include="*.html" --include="*.js"
```

Names are case-sensitive — match exact capitalisation. If a character name contains special characters (e.g. "Björn"), normalise for file/folder names (`bjorn-researcher.md`) but preserve the display name in markdown headers (`# Björn — Senior Researcher`).

**3d. Log the operation.** Append to `Vault/Memory/theme-change-log.md`:

```
| YYYY-MM-DD | Applied | [PreviousTheme or "defaults"] | [ThemeName] | N | [notes] |
```

### Step 4 — Announce

The Orchestrator confirms completion and prints the updated roster.

---

## Workflow B — revert to defaults

Triggered by: "Revert theme" or "Restore default names".

### Step 1 — Dry-run preview

The Orchestrator reads `Vault/Memory/theme-change-log.md` to find the most recent baseline (or chosen prior-theme row) and shows:

| Role | Current Name | Reverts To |
|------|-------------|------------|
| Orchestrator | [current] | [original from log] |
| HR Lead | [current] | [original from log] |

User confirms before any changes are made.

### Step 2 — Execute

Same as Workflow A Step 3, but uses the baseline values from `theme-change-log.md` as the new names. Append to the log using the standard six-column row schema:

```
| YYYY-MM-DD | Reverted | [CurrentTheme] | defaults | N | reverted via Workflow B |
```

The `defaults` value in column 4 is the canonical "no theme applied" label. Use the same column shape for all workflows so the log stays parseable.

---

## Workflow C — swap one member

Triggered by: "Replace [old] with [new] in role [X]" or a one-line YAML edit.

This is the lightweight path. No Senior Researcher routing, no dry-run preview required (the user has already named the swap).

### Step 1 — Update the map

```yaml
# Vault/Memory/theme-name-map.md
SEOSpecialist: Jordan  # changed from Alex
```

### Step 2 — Sync

Run `bash Vault/Scripts/sync-theme.sh`. The script updates the persona file's H1.

### Step 3 — Sweep (if there are name references outside the persona file)

For one-line swaps, most existing references in CLAUDE.md, SOPs, and onboarding files use `@{RoleToken}` and need no change. Cross-check by grep before declaring done:

```bash
grep -rn "[OldName]" --include="*.md" --include="*.html"
```

Update any prose references found.

### Step 4 — Log

```
| YYYY-MM-DD | Swap | [OldName] ([RoleToken]) | [NewName] ([RoleToken]) | 1 | one-member swap |
```

---

## Workflow D — archive a retired member

Triggered by: "Archive [name]" or member rotation.

### Step 1 — Create archive folder

```
Vault/Archive/Team/[Role Name]/[YYYY-YYYY-OldName]/
```

### Step 2 — Move persona file

Copy `.claude/agents/[role-slug].md` to the archive folder. The role's persona file in `.claude/agents/` stays in place for the successor; the archive copy preserves the tenure record.

### Step 3 — Add successor (if applicable)

If there is a successor: update `Vault/Memory/theme-name-map.md` YAML to point the role token at the new person, then run Workflow C from Step 2.

If there is no successor: set the YAML value to `null` (e.g. `SEOSpecialist: null`) and leave the persona file in `.claude/agents/` in place. The role token stays reserved; routing to `@{RoleToken}` will surface the unfilled-role state. Do not delete the YAML line — that breaks the role token contract.

### Step 4 — Log

```
| YYYY-MM-DD | Archived | [OldName] ([RoleToken]) | — | 1 | tenure YYYY–YYYY |
```

---

## What the sync script covers (and what it doesn't)

`Vault/Scripts/sync-theme.sh` updates the H1 line of each persona file in `.claude/agents/` to match the YAML block in `Vault/Memory/theme-name-map.md`. It only rewrites the Name portion of the H1; the Role Label tail (e.g. `— UX/UI Designer`, `— Video and Motion Producer`) is preserved verbatim. That is the script's entire scope.

It does not update:
- `@Name` cross-references inside persona bodies
- Name references in CLAUDE.md, SOPs, onboarding docs
- The `TEAM` array in `Resources/Learn/index.html`
- The change log
- Backups of the map

Those are manual sweep responsibilities — see Workflow A Step 3c. A follow-up may expand the script to handle the sweep. Until then, treat it as a header-sync helper, not a complete sync tool.

---

## Constraints (all workflows)

- Roles never change — only names.
- `@Name` syntax must be updated in every persona's "How to Address" section during a sweep.
- Role tokens (YAML keys) in the name map are immutable across all re-themes; only names (values) change.
- Wikilinks and Obsidian backlinks are out of scope — Obsidian manages link integrity separately.
- Windows path length limit (260 chars) — if a new name would push a path over this limit, @{SeniorResearcher} must propose a shorter alternative.

### Backup retention

Timestamped backups are created by Workflows A and B (whole-roster operations). Workflows C and D do not create a backup — they touch one role at a time and the change log row carries enough context to recover. Keep the last 10 timestamped `theme-name-map-*.md` backups in `Vault/Memory/`. Delete the oldest when a new one is created and the count exceeds 10.

### Partial failure recovery

If a rename, find-replace, or script step fails mid-batch, the Orchestrator halts immediately, reports the last successful step, and instructs the user to either (a) resume from that step manually, or (b) restore the previous state using the most recent timestamped map backup. The Orchestrator does not attempt to auto-recover.

### Missing baseline (legacy vaults)

If `Vault/Memory/theme-change-log.md` has no baseline entry on a revert attempt, the Orchestrator halts and asks the user to confirm the original default names. For reference, the factory defaults at last SOP update were: Sam, Harper, Ryan, Alex, Casey, Cleo, Odin, Sage, Quinn, Finn, Remi, Ellis, Nova, Axel, Juno, Dex, Jordan, Tate, Vera, Rory, Kai, Reid, Drew, Luca, Milo, Lex, Marlowe, Iris, Dash. Check `Vault/Memory/theme-name-map.md` for any roles added since.

---

## Verification checklist

- [ ] Pre-flight checks passed (map exists, no drift, no collisions, no active lock).
- [ ] `.theme-lock` created before any mutation, deleted after.
- [ ] Dry-run preview confirmed by user (Workflows A and B).
- [ ] `Vault/Memory/theme-name-map.md` YAML values updated; role tokens unchanged.
- [ ] Timestamped backup of previous map exists in `Vault/Memory/`.
- [ ] `bash Vault/Scripts/sync-theme.sh` exited 0; persona H1 headers in sync.
- [ ] Manual sweep complete: CLAUDE.md, persona bodies, SOPs, onboarding docs, Learn/index.html.
- [ ] Operation logged to `Vault/Memory/theme-change-log.md`.
- [ ] Routing works — sending `@[NewName]` reaches the correct persona.
