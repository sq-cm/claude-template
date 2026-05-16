# Resources/SOPs

Standard operating procedures governing how the Orchestrator and the team work.

## Current SOPs

| File                                                           | Purpose                                                                                                      |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| [`Advisor Checkpoints SOP.md`](Advisor%20Checkpoints%20SOP.md) | When and how team members consult the Senior Adviser (Checkpoint A and B)                                    |
| [`Odin Fallback SOP.md`](Odin%20Fallback%20SOP.md)             | Team behaviour when Odin is unavailable — retry, self-review, logging                                        |
| [`Persona Template SOP.md`](Persona%20Template%20SOP.md)       | Required sections and file-location convention for every persona file                                        |
| [`Project Folder SOP.md`](Project%20Folder%20SOP.md)           | When to create a project folder, naming convention, structure, archive lifecycle                             |
| [`QA Gate SOP.md`](QA%20Gate%20SOP.md)                         | Quinn's review verdicts (PASS / FLAGGED / BLOCKED) and plan-positioning rule for the QA step                 |
| [`Repo Consultation SOP.md`](Repo%20Consultation%20SOP.md)     | When and how to consult Resources/Git repos for best practices; conflict resolution with the Senior Adviser  |
| [`Repo Setup SOP.md`](Repo%20Setup%20SOP.md)                   | How to clone and refresh repos in Resources/Git/ — core set vs on-demand, failure handling, staleness policy |
| [`Roster Drift SOP.md`](Roster%20Drift%20SOP.md)               | Pre-hire/fire/swap checklist to keep CLAUDE.md, .claude/agents/, and theme-name-map.md in sync               |
| [`Orchestrator PM Handoff SOP.md`](Orchestrator%20PM%20Handoff%20SOP.md) | Clean boundary between @{Orchestrator} (routes) and @{ProjectManager} (tracks); escalation triggers     |
| [`Theme Setup SOP.md`](Theme%20Setup%20SOP.md)                 | First-time theme application — initial onboarding flow to apply a naming theme to a fresh vault              |
| [`Theme-Swap SOP.md`](Theme-Swap%20SOP.md)                     | Live theme replacement — step-by-step process for swapping an already-applied theme to a different one       |

### Theme SOP scope boundary

The two Theme SOPs are not interchangeable:

- **Theme Setup SOP** runs once when a fresh vault is first themed. No prior theme exists; no swap log entry is created.
- **Theme-Swap SOP** runs every subsequent time. Assumes an active theme is in place and replaces it; appends to `Vault/Memory/theme-change-log.md`.

If unsure which applies: check `Vault/Memory/theme-change-log.md`. Empty or absent → Setup. Has entries → Swap.

## Ownership

SOPs are referenced directly from `CLAUDE.md`. Changes should be routed through @{Orchestrator} — edits affect team-wide behaviour and need to stay consistent with CLAUDE.md.

## Adding a new SOP

1. Draft the SOP as a new `.md` file in this folder
2. Link it from the relevant section in `CLAUDE.md`
3. The Orchestrator confirms it's consistent with existing operations
