# Changelog

All notable changes to this template are logged here, newest first. Each entry maps to a merged pull request; the `#nn` reference links to the PR on GitHub. For full diffs, see the git history.

This log tracks the **template itself** — structural changes clones inherit on a fresh pull. It does not track work done inside an individual clone (that lives in `Vault/Memory/`, which is per-clone and largely git-ignored).

## 2026-06-09

- docs(learn): add `/teach`, `/html-deliverable`, and `/prototype` to the Learn guide's Slash Commands section (`Resources/Learn/index.html`, `SLASH_COMMANDS` array, 8→11 cards). Closes the onboarding gap where production skills — most notably `/teach` (shipped #46 but undocumented everywhere) — were absent while only operational/housekeeping commands were listed. Coverage stays curated, not exhaustive: `.claude/skills/README.md` remains the full catalog (#48)

## 2026-06-05

- feat(learn): add `Resources/Learn/prompt-formula-cheat-sheet.md` and its `.html` companion (MD↔HTML pair) — one prompt formula of 5 slots plus a "Done when" finish line, carried across the slot table, fill-in-the-blank template, and three worked examples (Design/Content/Code); includes an `@{RoleToken}` routing micro-tip, a copy-template button, and cross-links in both directions. Restyles `Resources/Learn/index.html` to the html-deliverable design system (CSS custom properties, dark/light theme toggle sharing the `html-deliverable-theme` key, color-mix tinted components), adds a "Write better prompts" section linking the cheat sheet, and bumps `LAST_SYNCED` to 2026-06-05 (#43)

## 2026-06-03

- fix(memory): split vault memory into `MEMORY.md` (tracked, maintainer-owned vault-operations index) and `context.md` (git-ignored, per-clone local team memory). `/memory-reconcile` and the onboarding bootstrap now write to `context.md`, never the tracked file — eliminating the rebase conflicts that put `<<<<<<< HEAD` markers into the prompt-loaded index on `/update`. Adds tracked seed `context.example.md`, install-time copy step (sh + bat), and a UserPromptSubmit loader for `context.md`. Synced across CLAUDE.md, Memory Protocol SOP, Roster Drift SOP, PM Handoff SOP, SETUP, and Learn guide (PR pending)
  - **Migration (existing clones).** After pulling this update, any local entries you previously added to `MEMORY.md` are still in the now-maintainer-owned tracked file and will conflict on the next `/update`. One-time fix: move your local entries into `Vault/Memory/context.md` (create it with `cp Vault/Memory/context.example.md Vault/Memory/context.md` if absent), then restore the shipped index with `git checkout MEMORY.md`. See SETUP Step 4.
  - **Note.** Cloner edits to other tracked memory files (`tool-exceptions.md`, `feedback_*.md`, `theme-name-map.md`) remain unsupported — they carry the same conflict risk and are reserved for maintainer/theme-op writes.
- feat(team): add Legal & Compliance Writer persona (Lex) — drafts T&Cs, privacy policies, disclaimers, and NDAs across AU/US/EU as pre-counsel drafts (never legal advice); scoped `WebFetch` grant for read-only statute/regulator lookups against a fixed domain allowlist, registered in the tool-exceptions registry; roster 27→28. Synced across README, Learn guide, minimum-viable-roster (Tier 4), SETUP, and Theme SOP factory-defaults list (PR pending)
- feat(team): add AI-Cinema unit — three personas (Marlowe/Cinema Showrunner, Iris/Stills Director, Dash/Seedance Director), the `cinema-world-bible` continuity skill, and the installed `banana-pro-director-2.0` + `cinema-worldbuilder-pro-2.0` Higgsfield/Seedance prompt skills; roster 24→27 (#39)
- docs(roster): add full trio entries to README team table, Learn guide persona cards, and minimum-viable-roster; backfill 5 roles missing from the README table (Competitive Intelligence, Market Research, Business Analyst, Meta Ads, Mobile Developer); bump Learn `LAST_SYNCED` to 2026-06-03 (#39)
- chore(settings): set `tui` to fullscreen in vault settings (#37)
- chore(vscode): sync recommended extensions with installed set (#36)

## 2026-05-29

- docs: sync stale team count (24) and model assignments (Opus 4.8 / Sonnet 4.6, no Haiku tier) across SETUP, Learn, and Persona Template SOP (#35)
- chore(gitignore): untrack per-clone audit sweeps and strategic recommendations (#34)
- feat(settings): enable remote control by default for clones (#32)
- chore(install): set core.fileMode=false on clone (#31)
- chore(model): move roster to Opus 4.8/Sonnet 4.6, 200k default for clones (#30)

## 2026-05-28

- docs(memory): add shell scoping gotcha to maintainer override note (#29)
- chore(vscode): expand dev-env defaults for clones (#28)
- chore(logs): untrack Vault/Logs/Sessions/INDEX.md (#27)
- docs(memory): reconcile permission-tuning session facts into MEMORY (#26)
- chore(permissions): add acceptEdits default + expand safe allowlist (#25)

## 2026-05-26

- fix(sub-agents): enforce depth-1 architecture (#24)
- fix(html-deliverable): restore list left-padding inside `<details>` (#23)

## 2026-05-25

- docs(memory): mark Pass 2 shipped items in strategic recommendations (#22)
- fix(p2.6): exec bits on shell scripts + drop non-portable Shared Projects path (#21)
- docs(env): inline documentation for .env.example (P2.5) (#20)
- feat(personas): scaffold "Skills I Reach For" section across roster (P2.2) (#19)
- chore(memory): reconcile P1.2 session note into MEMORY.md index (#18)
- docs(onboarding): add Minimum Viable Roster (P1.4) (#17)
- docs(learn): document /memory-reconcile in Slash Commands grid (#16)
- fix(onboarding): P1.2 — install scripts, /onboard, entry-point routing (#15)
- docs(theme): consolidate Theme SOPs and fix sync-theme.sh (#14)
- docs(onboarding): surface MCP and external-tool dependencies (#13)
- docs(repo-consultation): add empty-index no-op clause (#12)
- docs(audit): log 2026-05-24 strategic recommendations (#11)
- chore(gitignore): exclude per-clone state files and Sessions/ (#10)
- docs(skills): reconcile README with installed skills directory (#9)
- feat(template): parameterize studio attribution via {{Studio}} token (#8)
- feat(memory): two-stage write protocol with /memory-reconcile (#7)

## 2026-05-24

- chore(install): chmod .claude/hooks/*.sh in install.sh (#6)
- chore(memory): log 2026-05-24 audit sweep (#5)
- chore(audit): apply 2026-05-24 vault audit fixes (#4)

## 2026-05-23

- feat(html-deliverable): install skill + companion workflow (#3)

## 2026-05-22

- docs(handoff): sync handoff-save with updated SKILL.md (#2)

## 2026-05-20

- fix(settings): disable bg-isolation worktree requirement (#1)
