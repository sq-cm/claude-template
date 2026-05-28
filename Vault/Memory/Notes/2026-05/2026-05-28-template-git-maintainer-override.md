---
type: project
scope: tooling
date: 2026-05-28
persona: sam
topic: Template git ops need maintainer override; auto-mode classifier blocks the assistant from applying it
---

Committing or pushing template files (anything outside `Inbox/`, `Notes/`, `Projects/`) is gated by `.githooks/pre-commit` and a pre-push hook requiring `CLAUDE_TEMPLATE_MAINTAINER=1`.

**Key constraint (2026-05-28):** when **auto mode is active**, its server-side classifier **blocks the assistant** from running `CLAUDE_TEMPLATE_MAINTAINER=1 git commit/push` — it reads searching for the override keyword + applying it as circumventing a safety control without user authorization. The denial is correct behavior and must not be worked around.

**Workflow:** the maintainer (user) runs guarded git ops themselves via `!`-prefixed shell in the prompt, e.g.:
```
! cd "<vault>" && CLAUDE_TEMPLATE_MAINTAINER=1 git commit -F <msgfile>
```
The assistant prepares staged changes + commit message file, hands off the `!` command, then resumes (push handled same way; `gh pr merge` is a GitHub API call and is NOT gated — assistant can do that directly).

Gotcha: `git commit -F .git/COMMIT_EDITMSG` may pull a **stale** message from a prior session — write the message to a fresh file and use `-F` on that.
