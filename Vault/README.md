# Vault

Persistent internal storage for the studio. Everything in `Vault/` is durable and outlives any single session.

## Subfolder map

| Subfolder      | Purpose                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------- |
| `Memory/`      | Orchestrator's persistent memory store. See CLAUDE.md § Memory for the two-stage write protocol. |
| `Memory/Sessions/` | Per-clone, gitignored. Stage-1 destination for new memories — pending `/memory-reconcile`. |
| `Memory/Notes/<YYYY-MM>/` | Per-clone, gitignored (skeleton kept via `.gitkeep`). Stage-2 destination after reconcile; `context.md` points here. |
| `Learning/`    | Personal `/teach` workspaces, one subfolder per topic. Git-ignored except `README.md` (data is personal, Drive-backed, never pushed). |
| `Archive/`     | Retired projects, personas, briefs, artefacts. Preserves original folder structure.      |
| `Logs/`        | Append-only operational logs. Example folder; create on first use.                       |
| `Plans/`       | Output home for `improve`, advisor plans, and `writing-plans` artefacts. Git-ignored (per-clone working plans, never Deliverables). |
| `Specs/`       | Output home for `brainstorming` design specs. Git-ignored.                               |
| `Templates/`   | Reusable note templates (daily note, weekly note, etc.).                                 |
| `Scripts/`     | Vault-local automation scripts (e.g. theme sync).                                        |
| `Categories/`  | Obsidian-managed staging — note categorisation; empty placeholder until vault use begins.|
| `Bases/`       | Obsidian-managed staging — `.base` database views; empty placeholder.                    |
| `Attachments/` | Obsidian-managed staging — note attachments; empty placeholder.                          |

## Rules

- All persistent memory writes go to `Vault/Memory/` — not the Claude Code default internal path.
- New subfolder creation belongs to the Orchestrator. Working personas surface the need; they do not create the folder.
- Empty placeholder folders (Categories, Bases, Attachments) are kept for Obsidian convention even when unused.
- Effort dial (operator mechanics, referenced from CLAUDE.md § Default Mode): set via `/model` or `--effort`; does not propagate to sub-agents; model pins unaffected.

## Root-level layout

Reference detail for CLAUDE.md § Vault Structure. The operative rules (root reserved for named folders, no new root folders, the dotfolder exemption, and the `.claude/`-write boundary) live in CLAUDE.md; the tables and rationale below are the lookup behind them.

### Permitted root-level folders

| Folder       | Purpose                                                     |
| ------------ | ----------------------------------------------------------- |
| `.claude/`   | Persona files (`agents/`), hooks/settings, skills, commands |
| `Inbox/`     | Staging area for unrouted material                          |
| `Notes/`     | Daily notes, weekly reviews, clippings, canvas files        |
| `Projects/`  | Client and campaign project folders                         |
| `Resources/` | SOPs, repo clones, research briefs, build standards, onboarding, shared assets |
| `Vault/`     | Persistent internal storage — see the subfolder map above   |

### Permitted root-level files

Repo conventions, not storage folders:

| File | Purpose |
| ------------ | ----------------------------------------------------------- |
| `CLAUDE.md` | Project instructions for Claude Code |
| `README.md` | Human-readable repo overview |
| `CHANGELOG.md` | Append-only log of shipped changes; upgrade reference for clones |
| `install.sh` | Installer script (bash) for new team members |
| `install.bat` | Installer script (Windows) for new team members |
| `.env` | API keys and secrets (git-ignored) |
| `.env.example` | Template for `.env` — safe to commit |

API keys and secrets live in `.env` at the vault root (git-ignored). Copy `.env.example` to `.env` before first use.

### Tool/VCS dotfolder carve-out

Dotfolders managed by external tooling (`.git/`, `.githooks/`, `.obsidian/`, `.vscode/`, `.claude/`) are exempt from the no-new-root-folders rule. Dotfiles such as `.gitignore` and `.gitattributes` are likewise exempt from the permitted-files table — repo conventions only. (`.env` and `.env.example` appear in the file table for clarity since they carry vault-level secrets policy.)

### `.claude/` write-permission rationale

There is deliberately no `Write(.claude/**)` / `Edit(.claude/**)` auto-approve grant in `.claude/settings.json`. Writes to the vault's own governance surface — persona files (`.claude/agents/`), skills, hooks, and settings — therefore prompt for confirmation even in auto mode. This is a safety boundary, not an oversight: changes to the rules the team runs on should be a deliberate, surfaced act. Do not add the grant without a maintainer decision to do so.
