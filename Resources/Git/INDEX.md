# Resources/Git — Repo Index

_Use this index to find relevant repos for a task. Max 3 repos per task consultation._

---

## Domain Index

> **Empty by design on fresh clones.** Repo consultation is a no-op until this index is populated — the Orchestrator narrates the skip and proceeds with checkpoint-eligible work. To add repos, see the [Repo Setup SOP](../SOPs/Repo%20Setup%20SOP.md) and the example entries in [IMPORT.md](IMPORT.md). Audits should not flag an empty index as a defect.

| Repo | Description | Tags | GitHub URL |
|------|-------------|------|------------|
| `ponytail` | YAGNI decision ladder + minimalism-review patterns for coding agents. Reference-only, no local clone — adopted 2026-07 as code-minimalism-standard + code-minimalism-review skill. | `best-practices, claude-code, skills` | https://github.com/DietrichGebert/ponytail |
| `andrej-karpathy-skills` | Karpathy LLM-coding behavioural guidelines. Reference-only, no local clone — surgical-changes rule adopted 2026-07 into CLAUDE.md § Engineering Defaults. | `best-practices, skills` | https://github.com/multica-ai/andrej-karpathy-skills |


---

## Tag Reference

| Tag | Covers |
|-----|--------|
| `claude-code` | Claude Code CLI itself, official tooling, core platform repos |
| `skills` | SKILL.md-based skill files installable into Claude Code or compatible agents |
| `hooks` | Claude Code hooks (PreToolUse, PostToolUse, SessionStart, etc.) |
| `mcp` | Model Context Protocol servers, clients, and integrations |
| `agents` | Sub-agent and multi-agent orchestration systems and collections |
| `seo` | SEO auditing, content optimization, GEO, local SEO, keyword research |
| `webflow` | Webflow CMS, designer automation, publishing, and component workflows |
| `image-gen` | AI image generation and editing (Gemini, Google, Claude-native) |
| `content` | Content strategy, copywriting, blog creation, and marketing content pipelines |
| `obsidian` | Obsidian vault interaction, Markdown, Bases, and Canvas |
| `api` | Direct API integrations (Anthropic SDK, Google APIs, DataForSEO, GitHub API) |
| `best-practices` | Reference implementations, guides, and curated patterns for Claude Code usage |
| `workflows` | Multi-step orchestration pipelines, session management, and automated task chains |
| `security` | Security hooks, permission hardening, threat databases, safe execution patterns |
| `git-actions` | GitHub Actions, PR automation, CI/CD integration with Claude |
| `ui-ux` | UI/UX design intelligence, design systems, visual styling, and front-end design patterns |
