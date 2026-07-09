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
| `fast-path` | Explicitly invoke the Fast-Path Lane for a light task — asserts the five eligibility conditions (auditable verdict), then runs the lane or auto-escalates to the full pipeline; explicit `/fast-path` invocation only, cannot override eligibility | Orchestrator (pre-routing) |
| `find-skills` | Discover and recommend installable agent skills from the skills.sh ecosystem (`npx skills find`) — vault adaptation: project-level installs stay maintainer-gated, never `-y` (vendored from vercel-labs/skills @ `ceea008`) | Orchestrator |
| `grill-me` | Interview user relentlessly to surface full requirements before work starts | Orchestrator (default intake for non-trivial requests) |
| `handoff` | Save and restore task context across sessions — mid-task handoff protocol | All |
| `html-deliverable` | Produce an interactive HTML companion for eligible MD deliverable types | All producing personas |
| `humaniser` | Rewrite AI-sounding prose to read as natural human writing | Copywriter, Content Strategist |
| `hyperframes` | HTML/CSS→deterministic MP4 composition authoring — title cards, captions, audio-reactive pieces, scene transitions (vendored from heygen-com/hyperframes @ `8fcbb63`, Apache 2.0; LICENSE in folder) | Nova (Video and Motion Producer), Ellis (Creative Technologist) |
| `hyperframes-cli` | HyperFrames dev loop — init, lint, inspect, preview, render, doctor via `npx hyperframes` | Nova (Video and Motion Producer) |
| `hyperframes-media` | HyperFrames asset preprocessing — TTS (Kokoro), transcription (Whisper), background removal (u2net) | Nova (Video and Motion Producer) |
| `improve` | Read-only codebase auditor and implementation-plan generator — surveys a repo as a senior adviser, produces prioritised self-contained plans for executor agents to implement; never modifies source code itself | Orchestrator (meta-op — runs on the Orchestrator session, not routed; `Vault/Plans/` are internal artefacts, not Deliverables; see CLAUDE.md § Orchestrator-Only Operations) |
| `prompt-review` | One-pass prompt diagnosis and rewrite against the prompt formula cheat sheet (5 slots + a finish line, read at runtime as single source of truth) — explicit `/prompt-review` invocation only; inline pre-routing utility in the grill-me class (conversational output, never a Deliverable, QA-exempt) | Orchestrator (pre-routing) |
| `prototype` | Build and iterate on interactive HTML/CSS/JS prototypes | All producing personas |
| `review-claudemd` | Transcript-mined CLAUDE.md review — extracts recent session transcripts (zero-dep Node script; hook noise stripped, secrets redacted), fans out analysts across five lenses (violated / missing-local / missing-global / outdated / friction), writes a report-only findings file to `Vault/Plans/` for maintainer review; never edits any CLAUDE.md (idea from ykdojo/claude-code-tips @ `0307d5c`) | Orchestrator (meta-op — explicit `/review-claudemd` invocation only; see CLAUDE.md § Orchestrator-Only Operations) |
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

These skills are not stored in this directory. They are provided at runtime by marketplace plugins — the canonical, current roster is `.claude/settings.json` `enabledPlugins` (do not restate it here; it drifts as plugins are added or removed). Fresh clones auto-install the declared plugins after a one-time trust prompt; `.claude/commands/onboard.md` Step 3.55 is the manual fallback. A plugin's skills will not work without that plugin installed — run `/plugin` to see what is currently active and what each installed plugin provides.

Two plugins are worth a standing note beyond "check `/plugin`":

- **`obsidian` plugin** (`obsidian-skills` marketplace, kepano/obsidian-skills, MIT) replaces the formerly vault-local copies of the Obsidian skills (`obsidian-bases`, `obsidian-cli`, `obsidian-markdown`, `json-canvas`, `defuddle`), which were content-identical to upstream — the plugin keeps them auto-updated instead of the vault carrying a static snapshot.
- **`superpowers` plugin** (`claude-plugins-official` marketplace) supplies several skills that wrap the plugin's own runtime capabilities (agent-dispatch, git-worktree management, review-state tracking) rather than being self-contained — they will not function if the plugin is disabled, unlike most vault-local skills above.

---

## Notes

- **Frontmatter standard.** Every vault-local `SKILL.md` carries a YAML frontmatter block with, at minimum, the two **required** keys `name` (must equal the skill's folder name) and `description`. The following keys are **allowed when functional** — keep them only where they change runtime behaviour: `disable-model-invocation`, `argument-hint`, `allowed-tools`. A `license` key (optionally with a `metadata` block) is **kept only as upstream attribution** for a vendored skill — never as cosmetic residue. Cosmetic keys (`version`, `compatibility`, and a bare `license` with no attribution to preserve) are not house-standard and should not be added.
- Before committing template changes, run `Vault/Scripts/validate.sh` — the read-only consistency checker for persona roster, token references, tool lists, doc counts, and seed files.
- Vault-local skills are available immediately in any session — no plugin required
- Plugin-provided skills require their plugin — auto-installed via `.claude/settings.json`; manual fallback in `.claude/commands/onboard.md` Step 3.55
- Skill files follow the SKILL.md format — see `write-a-skill` for authoring guidance
- To add a new vault-local skill: drop a valid SKILL.md directory here; it becomes available in the next session
- Version pinning: skills here are unpinned (copied at vault creation). To lock a version, note the source repo and commit in the skill's own SKILL.md
