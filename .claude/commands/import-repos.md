# /import-repos

You are Sam, the orchestrator. Process all GitHub repo URLs staged in `Resources/Git/IMPORT.md` and integrate them into the vault.

## Steps

### 1. Read IMPORT.md

Read `Resources/Git/IMPORT.md`. Extract all GitHub URLs (one per line, skip blank lines and comment lines starting with `#`).

If IMPORT.md is empty or has no valid URLs, report "IMPORT.md is empty — nothing to process." and stop.

### 2. For each URL

#### 2a. Derive repo name

Extract the repo name from the URL (last path segment, no `.git`). Apply the name collision rule: if a folder with that name already exists in `Resources/Git/`, append the owner username as suffix (e.g. `awesome-claude-plugins-composio`).

#### 2b. Clone

```bash
git clone --depth 1 [url] Resources/Git/[repo-name]
```

If clone fails: log to `Vault/Logs/clone-failures.md` using this format and skip to next URL:
```
## YYYY-MM-DD — [repo-name]
- URL attempted: [url]
- Error: [error message]
- Action: skipped
```

#### 2c. Generate description and tags

Read `Resources/Git/[repo-name]/README.md` (first 100 lines is enough). From that content, write:
- **Description**: 1–2 sentence summary of what the repo does, written for the INDEX.md audience (team members selecting repos for task guidance)
- **Tags**: select all that apply from the tag reference below

Tag reference:
| Tag | Covers |
|-----|--------|
| `claude-code` | Claude Code CLI itself, official tooling, core platform repos |
| `skills` | SKILL.md-based skill files installable into Claude Code or compatible agents |
| `hooks` | Claude Code hooks (PreToolUse, PostToolUse, SessionStart, etc.) |
| `mcp` | Model Context Protocol servers, clients, and integrations |
| `agents` | Sub-agent and multi-agent orchestration systems and collections |
| `seo` | SEO auditing, content optimization, GEO, local SEO, keyword research |
| `webflow` | Webflow CMS, designer automation, publishing, and component workflows |
| `image-gen` | AI image generation and editing |
| `content` | Content strategy, copywriting, blog creation, and marketing content pipelines |
| `obsidian` | Obsidian vault interaction, Markdown, Bases, and Canvas |
| `api` | Direct API integrations (Anthropic SDK, Google APIs, etc.) |
| `best-practices` | Reference implementations, guides, and curated patterns for Claude Code usage |
| `workflows` | Multi-step orchestration pipelines, session management, and automated task chains |
| `security` | Security hooks, permission hardening, threat databases, safe execution patterns |
| `git-actions` | GitHub Actions, PR automation, CI/CD integration with Claude |
| `ui-ux` | UI/UX design intelligence, design systems, visual styling, and front-end design patterns |

#### 2d. Append to README.md

Add a new row to the `## Cloned Repos` table in `Resources/Git/README.md`:

```
| `[repo-name]/` | [url] | [description] |
```

#### 2e. Append to INDEX.md

Add a new row to the `## Domain Index` table in `Resources/Git/INDEX.md`:

```
| [repo-name] | [description] | [tags as backtick-wrapped space-separated list] | [url] |
```

### 3. Clear IMPORT.md

After all URLs are processed (success or skipped), overwrite `Resources/Git/IMPORT.md` with empty content. This signals the queue is consumed.

### 4. Report

Print a summary:
```
Imported: [n] repos
Skipped:  [n] repos (see Vault/Logs/clone-failures.md)
---
[list of imported repo names]
```

## IMPORT.md format reference

```
# One GitHub URL per line. Blank lines and # comments are ignored.
https://github.com/owner/repo-name
https://github.com/another/repo
```
