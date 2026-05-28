---
type: reference
scope: tooling
date: 2026-05-28
persona: sam
topic: Claude Code permission modes + Bash allowlist syntax facts
---

Claude Code permission/allowlist facts confirmed against code.claude.com docs (2026-05-28):

- **`defaultMode: "auto"` is ignored in project and local settings** — only honored in user settings (`~/.claude/settings.json`), and gated on account eligibility. For project-scope speed (this vault), **`acceptEdits` is the lever** — honored at project scope (verified live: status bar `⏵⏵ accept edits on`).
- `acceptEdits` auto-approves edits to **any non-protected path**, widening beyond a scoped `Write(Inbox/**)`-style allowlist. Protected paths never auto-approved.
- **Bash permission syntax:** `Bash(ls *)` (space) ≡ `Bash(ls:*)` (colon) for trailing wildcards. `:*` is **end-only** — a mid-pattern colon (`Bash(git:* push)`) is treated as a literal and breaks the rule. The permission dialog emits the **space form** natively, so no normalization needed.
- `Bash(ls *)` matches `ls -la` but NOT bare `ls`; `Bash(ls*)` wrongly matches `lsof`. Bare commands need their own exact entry (`Bash(ls)` + `Bash(ls *)`).
- Excluded from safe allowlists: `find` (`-exec`/`-delete` are write/destructive — use native `Glob`/`Grep`), `git branch:*` wildcard (allows `-D` force-delete; keep non-wildcard `git branch`).

Shipped to template via PR #25 (commit `856614d`). See [[feedback_qa_routing]] for related settings discipline.
