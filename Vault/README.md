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
| `Templates/`   | Reusable note templates (daily note, weekly note, etc.).                                 |
| `Scripts/`     | Vault-local automation scripts (e.g. theme sync).                                        |
| `Categories/`  | Obsidian-managed staging — note categorisation; empty placeholder until vault use begins.|
| `Bases/`       | Obsidian-managed staging — `.base` database views; empty placeholder.                    |
| `Attachments/` | Obsidian-managed staging — note attachments; empty placeholder.                          |

## Rules

- All persistent memory writes go to `Vault/Memory/` — not the Claude Code default internal path.
- New subfolder creation belongs to the Orchestrator. Working personas surface the need; they do not create the folder.
- Empty placeholder folders (Categories, Bases, Attachments) are kept for Obsidian convention even when unused.
