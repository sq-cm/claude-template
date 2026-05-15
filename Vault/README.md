# Vault

Persistent internal storage for the studio. Everything in `Vault/` is durable and outlives any single session.

## Subfolder map

| Subfolder      | Purpose                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------- |
| `Memory/`      | Orchestrator's persistent memory store. See CLAUDE.md § Memory for read/write rules.     |
| `Archive/`     | Retired projects, personas, briefs, artefacts. Preserves original folder structure.      |
| `Audits/`      | Vault audit reports and source findings.                                                 |
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
