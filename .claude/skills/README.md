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
| `cinema-worldbuilder-pro-2.0` | Seedance video prompt director — five cinema modes, Frame Map / Subject Lock continuity grammar, diegetic audio; **photoreal/live-action and English-only** (for stylized/bilingual work use `seedance-bilingual-director`) | Dash (Seedance Director) |
| `code-minimalism-review` | Over-engineering review of diffs — five tags (delete/stdlib/native/yagni/shrink); findings only, applies nothing (adapted from ponytail, MIT) | Webflow Developer, Email Developer, Mobile Developer, Automation Architect, Creative Technologist |
| `dispatching-parallel-agents` | Launch independent sub-agents in parallel for multi-track tasks | Orchestrator only (depth-1 wall — personas needing fan-out return a spec to the Orchestrator) |
| `find-skills` | Discover and recommend installable agent skills from the skills.sh ecosystem (`npx skills find`) — vault adaptation: project-level installs stay maintainer-gated, never `-y` (vendored from vercel-labs/skills @ `ceea008`) | Orchestrator |
| `grill-me` | Interview user relentlessly to surface full requirements before work starts | Orchestrator (default intake for non-trivial requests) |
| `handoff` | Save and restore task context across sessions — mid-task handoff protocol | All |
| `html-deliverable` | Produce an interactive HTML companion for eligible MD deliverable types | All producing personas |
| `humaniser` | Rewrite AI-sounding prose to read as natural human writing | Copywriter, Content Strategist |
| `hyperframes` | HTML/CSS→deterministic MP4 composition authoring — title cards, captions, audio-reactive pieces, scene transitions (vendored from heygen-com/hyperframes @ `8fcbb63`, Apache 2.0; LICENSE in folder) | Nova (Video and Motion Producer), Ellis (Creative Technologist) |
| `hyperframes-cli` | HyperFrames dev loop — init, lint, inspect, preview, render, doctor via `npx hyperframes` | Nova (Video and Motion Producer) |
| `hyperframes-media` | HyperFrames asset preprocessing — TTS (Kokoro), transcription (Whisper), background removal (u2net) | Nova (Video and Motion Producer) |
| `improve` | Read-only codebase auditor and implementation-plan generator — surveys a repo as a senior adviser, produces prioritised self-contained plans for executor agents to implement; never modifies source code itself | Orchestrator (meta-op — runs on the Orchestrator session, not routed; `Vault/Plans/` are internal artefacts, not Deliverables; see CLAUDE.md § Orchestrator-Only Operations) |
| `prototype` | Build and iterate on interactive HTML/CSS/JS prototypes | All producing personas |
| `seedance-bilingual-director` | Seedance video prompt director for stylized/animated looks (cartoon, manga, claymation, mixed-media) — bilingual EN+ZH JSON output, dialogue-heavy scene support; **stylized/bilingual counterpart to `cinema-worldbuilder-pro-2.0`** (photoreal/live-action) | Dash (Seedance Director) |
| `seedance-commercial-director` | Seedance video prompt director for the **commercial-ad lane** — photoreal/English, twelve-block grammar adding Product Surface + Brand Grade blocks; route on intent (ad/product/brand), **not** CWP narrative or its M2 mode | Dash (Seedance Director) |
| `shotlist-html-companion` | Render a shotlist / Seedance prompt-set as a single self-contained editable HTML — per-scene checkboxes (localStorage), copy-per-prompt, edit-once style prefix; single-pass, routes through `html-deliverable` | All producing personas |
| `teach` | Personal-tutor skill — runs inline by the Orchestrator (CLAUDE.md carve-out: exempt from routing, QA Gate, PM tracking, and Advisor Checkpoints); teaches any topic across stateful sessions with lessons, reference docs, and learning records stored git-ignored under `Vault/Learning/<topic>/` | Orchestrator |
| `using-superpowers` | Establishes how to find and use skills, repos, and tools at session start | Orchestrator |
| `verification-before-completion` | Final self-check before claiming work is done | All (mirrors Checkpoint B intent) |
| `write-a-skill` | Create or improve SKILL.md skill files | Orchestrator, Ellis |
| `writing-plans` | Write an implementation plan from a spec before touching code | All |

---

## Plugin-Provided Skills

These skills are not stored in this directory. They are provided at runtime by marketplace plugins declared in `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`) — fresh clones auto-install them after a one-time trust prompt. Onboarding Step 3.55 remains the manual fallback. They will not work without their plugin.

**`superpowers` plugin** (`claude-plugins-official` marketplace):

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

**`obsidian` plugin** (`obsidian-skills` marketplace, kepano/obsidian-skills, MIT) — replaces the formerly vault-local copies, which were content-identical to upstream; the plugin keeps them auto-updated:

| Skill | Rationale |
|-------|-----------|
| `obsidian-bases` | Create and edit Obsidian Bases (.base files) with views, filters, formulas |
| `obsidian-cli` | Interact with Obsidian vault — read, create, search, update notes via CLI |
| `obsidian-markdown` | Create/edit Obsidian Flavored Markdown — wikilinks, embeds, callouts, properties |
| `json-canvas` | Create and edit JSON Canvas (.canvas) files |
| `defuddle` | Extract clean markdown from web pages via Defuddle CLI |

---

## Notes

- **Frontmatter standard.** Every vault-local `SKILL.md` carries a YAML frontmatter block with, at minimum, the two **required** keys `name` (must equal the skill's folder name) and `description`. The following keys are **allowed when functional** — keep them only where they change runtime behaviour: `disable-model-invocation`, `argument-hint`, `allowed-tools`. A `license` key (optionally with a `metadata` block) is **kept only as upstream attribution** for a vendored skill — never as cosmetic residue. Cosmetic keys (`version`, `compatibility`, and a bare `license` with no attribution to preserve) are not house-standard and should not be added.
- Before committing template changes, run `Vault/Scripts/validate.sh` — the read-only consistency checker for persona roster, token references, tool lists, doc counts, and seed files.
- Vault-local skills are available immediately in any session — no plugin required
- Plugin-provided skills require their plugin — auto-installed via `.claude/settings.json`; manual fallback in `.claude/commands/onboard.md` Step 3.55
- Skill files follow the SKILL.md format — see `write-a-skill` for authoring guidance
- To add a new vault-local skill: drop a valid SKILL.md directory here; it becomes available in the next session
- Version pinning: skills here are unpinned (copied at vault creation). To lock a version, note the source repo and commit in the skill's own SKILL.md
