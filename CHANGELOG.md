# Changelog

All notable changes to this template are logged here, newest first. Each entry maps to a merged pull request; the `#nn` reference links to the PR on GitHub. For full diffs, see the git history.

This log tracks the **template itself** — structural changes clones inherit on a fresh pull. It does not track work done inside an individual clone (that lives in `Vault/Memory/`, which is per-clone and largely git-ignored).

## 2026-05-29

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
