# Resources/SOPs

Standard operating procedures governing how the Orchestrator and the team work.

## Current SOPs

| File                                                           | Purpose                                                                                                      |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| [`Advisor Checkpoints SOP.md`](Advisor%20Checkpoints%20SOP.md) | When and how team members consult the Senior Adviser (Checkpoint A and B)                                    |
| [`Odin Fallback SOP.md`](Odin%20Fallback%20SOP.md)             | Team behaviour when Odin is unavailable — retry, self-review, logging                                        |
| [`Fast-Path Lane SOP.md`](Fast-Path%20Lane%20SOP.md)           | The light-work lane — eligibility reasoning, what it keeps/bypasses, escalation, worked examples             |
| [`Persona Template SOP.md`](Persona%20Template%20SOP.md)       | Required sections and file-location convention for every persona file                                        |
| [`Project Folder SOP.md`](Project%20Folder%20SOP.md)           | When to create a project folder, naming convention, structure, archive lifecycle                             |
| [`QA Gate SOP.md`](QA%20Gate%20SOP.md)                         | @{QAComplianceReviewer} review verdicts (PASS / FLAGGED / BLOCKED) and plan-positioning rule for the QA step |
| [`Sub-Agent Architecture SOP.md`](Sub-Agent%20Architecture%20SOP.md) | Depth-1 constraint, two-wave dispatch, fan-out spec handoff, and Orchestrator-only web fetch (`ctx_fetch_and_index`) |
| [`Repo Consultation SOP.md`](Repo%20Consultation%20SOP.md)     | When and how to consult Resources/Git repos for best practices; conflict resolution with the Senior Adviser  |
| [`Repo Setup SOP.md`](Repo%20Setup%20SOP.md)                   | How to clone and refresh repos in Resources/Git/ — core set vs on-demand, failure handling, staleness policy |
| [`Roster Drift SOP.md`](Roster%20Drift%20SOP.md)               | Pre-hire/fire/swap checklist to keep CLAUDE.md, .claude/agents/, and theme-name-map.md in sync               |
| [`Orchestrator PM Handoff SOP.md`](Orchestrator%20PM%20Handoff%20SOP.md) | Clean boundary between @{Orchestrator} (routes) and @{ProjectManager} (tracks); escalation triggers     |
| [`Theme SOP.md`](Theme%20SOP.md)                               | All name-related operations — apply a theme, change a theme, revert to defaults, swap one member, archive a retired member |
| [`Memory Protocol SOP.md`](Memory%20Protocol%20SOP.md)         | Two-stage write protocol for `Vault/Memory/`: session notes → `/memory-reconcile` → `context.md` pointers + git-ignored `Notes/<YYYY-MM>/`; project-tagged notes fold into the project's `CONTEXT.md` (current truths) + `HISTORY.md` (decision trail) |
| [`Context Overhead Audit SOP.md`](Context%20Overhead%20Audit%20SOP.md) | Recurring `/context` audit of per-session fixed overhead — plugins, hooks, MCP servers, memory files, both project and user-global scopes |
| [`Folder-Tier CLAUDE.md SOP.md`](Folder-Tier%20CLAUDE.md%20SOP.md) | Lazy-loaded folder-level CLAUDE.md files — placement test, verified load semantics, canonical folder list, Orchestrator-only governance, QA carve-out |
| [`Herdr SOP.md`](Herdr%20SOP.md)                               | herdr terminal workspace — concept model, first-run walkthrough, `HERDR_ENV=1` nesting rule, diagnosis recipes; condensed from herdr.dev with canonical links |
| [`Chats SOP.md`](Chats%20SOP.md)                               | Per-conversation chat workspaces — naming, `CHAT.md` anatomy, `/chat` commands, Fast-Path hookup, retention |

## Ownership

SOPs are referenced directly from `CLAUDE.md`. Changes should be routed through @{Orchestrator} — edits affect team-wide behaviour and need to stay consistent with CLAUDE.md.

## Adding a new SOP

1. Draft the SOP as a new `.md` file in this folder
2. Link it from the relevant section in `CLAUDE.md`
3. The Orchestrator confirms it's consistent with existing operations
