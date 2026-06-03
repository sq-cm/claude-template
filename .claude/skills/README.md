# .claude/skills

Vault-local skills ship with the template. Plugin-provided skills require external plugins (see onboarding).

---

## Vault-Local Skills

Skills installed in this directory. Each is a SKILL.md-based capability invocable via the Skill tool or `/skill-name` slash command.

| Skill | Purpose | Primary users |
|-------|---------|--------------|
| `banana-pro-director-2.0` | Higgsfield still-image prompt director (Banana Pro / Soul Cinema / GPT-2) — face locks, character/outfit refs, 6-panel sheets, scene plates | Iris (Stills Director) |
| `brainstorming` | Structured creative ideation before feature or content work | All |
| `cinema-world-bible` | Continuity tracker for narrative AI-film — world bible, character bibles, reference-library index, shot specs that route to the two operator skills | Marlowe (Cinema Showrunner) |
| `cinema-worldbuilder-pro-2.0` | Seedance video prompt director — five cinema modes, Frame Map / Subject Lock continuity grammar, diegetic audio | Dash (Seedance Director) |
| `dispatching-parallel-agents` | Launch independent sub-agents in parallel for multi-track tasks | Orchestrator, all checkpoint-eligible personas |
| `grill-me` | Interview user relentlessly to surface full requirements before work starts | Orchestrator (default intake for non-trivial requests) |
| `handoff` | Save and restore task context across sessions — mid-task handoff protocol | All |
| `html-deliverable` | Produce an interactive HTML companion for eligible MD deliverable types | All producing personas |
| `humaniser` | Rewrite AI-sounding prose to read as natural human writing | Copywriter, Content Strategist |
| `obsidian-bases` | Create and edit Obsidian Bases (.base files) with views, filters, formulas | Orchestrator, Project Manager |
| `obsidian-cli` | Interact with Obsidian vault — read, create, search, update notes via CLI | All |
| `obsidian-markdown` | Create/edit Obsidian Flavored Markdown — wikilinks, embeds, callouts, properties | All |
| `prototype` | Build and iterate on interactive HTML/CSS/JS prototypes | All producing personas |
| `using-superpowers` | Establishes how to find and use skills, repos, and tools at session start | Orchestrator |
| `verification-before-completion` | Final self-check before claiming work is done | All (mirrors Checkpoint B intent) |
| `write-a-skill` | Create or improve SKILL.md skill files | Orchestrator, Ellis |
| `writing-plans` | Write an implementation plan from a spec before touching code | All |

---

## Plugin-Provided Skills

These skills are not stored in this directory. They are provided at runtime by the `superpowers` plugin (installed in onboarding Step 3.55). They will not work without the plugin.

| Skill | Rationale |
|-------|-----------|
| `executing-plans` | Execute a written implementation plan in a fresh agent context — requires plugin's agent-dispatch capability |
| `finishing-a-development-branch` | Pre-merge checklist for code work (tests, cleanup, PR readiness) — wraps plugin git tooling |
| `receiving-code-review` | Process incoming code review feedback before implementing — requires plugin review-state tooling |
| `requesting-code-review` | Request structured code review before merging — requires plugin review-state tooling |
| `subagent-driven-development` | Execute implementation plans with parallel sub-agents in current session — requires plugin sub-agent runtime |
| `systematic-debugging` | Structured debugging protocol before writing fixes — requires plugin diagnostic tooling |
| `test-driven-development` | Write tests before implementation code — requires plugin test-runner integration |
| `using-git-worktrees` | Isolate feature work in a git worktree — requires plugin worktree management tooling |

---

## Notes

- Vault-local skills are available immediately in any session — no plugin required
- Plugin-provided skills require the `superpowers` plugin; see `Resources/Learn/onboard.md` Step 3.55
- Skill files follow the SKILL.md format — see `write-a-skill` for authoring guidance
- To add a new vault-local skill: drop a valid SKILL.md directory here; it becomes available in the next session
- Version pinning: skills here are unpinned (copied at vault creation). To lock a version, note the source repo and commit in the skill's own SKILL.md
