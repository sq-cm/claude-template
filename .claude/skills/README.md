# .claude/skills

Skills installed in this vault. Each skill is a SKILL.md-based capability invocable via the Skill tool or `/skill-name` slash command.

---

## Installed Skills

| Skill | Purpose | Primary users |
|-------|---------|--------------|
| `brainstorming` | Structured creative ideation before feature or content work | Sage, Finn, Vera, Cleo |
| `dispatching-parallel-agents` | Launch independent sub-agents in parallel for multi-track tasks | All checkpoint-eligible personas |
| `executing-plans` | Execute a written implementation plan in a fresh agent context | All |
| `finishing-a-development-branch` | Pre-merge checklist for code work — tests, cleanup, PR readiness | Casey, Ellis, Axel |
| `grill-me` | Interview user relentlessly to surface full requirements before work starts | Sam (default intake for non-trivial requests) |
| `humaniser` | Rewrite AI-sounding prose to read as natural human writing | Finn, Sage |
| `obsidian-bases` | Create and edit Obsidian Bases (.base files) with views, filters, formulas | Sam, Jordan |
| `obsidian-cli` | Interact with Obsidian vault — read, create, search, update notes via CLI | All |
| `obsidian-markdown` | Create/edit Obsidian Flavored Markdown — wikilinks, embeds, callouts, properties | All |
| `receiving-code-review` | Process incoming code review feedback before implementing suggestions | Casey, Ellis, Axel |
| `requesting-code-review` | Request structured code review before merging or declaring done | Casey, Ellis, Axel |
| `subagent-driven-development` | Execute implementation plans with parallel sub-agents in current session | All |
| `systematic-debugging` | Structured debugging protocol before writing fixes | Casey, Ellis, Axel, Morgan |
| `test-driven-development` | Write tests before implementation code | Casey, Ellis, Axel |
| `using-git-worktrees` | Isolate feature work in a git worktree | Casey, Ellis, Axel |
| `using-superpowers` | Establishes how to find and use skills, repos, and tools at session start | Sam |
| `verification-before-completion` | Final self-check before claiming work is done | All (mirrors Checkpoint B intent) |
| `writing-plans` | Write an implementation plan from a spec before touching code | All |
| `writing-skills` | Create or improve SKILL.md skill files | Sam, Ellis |

---

## Notes

- Skills are loaded from this directory by Claude Code at session start
- Skill files follow the SKILL.md format — see `writing-skills` for authoring guidance
- To add a new skill: drop a valid SKILL.md directory here; it becomes available immediately in the next session
- Version pinning: skills here are unpinned (copied at vault creation). To lock a version, note the source repo and commit in the skill's own SKILL.md
