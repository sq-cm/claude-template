---
description: "Pulls latest template changes from origin/main using the two-branch rebase model."
---

# /update

You are the Orchestrator. Pull the latest template changes from `origin/main` into the local vault using the two-branch model (`main` = upstream mirror, `local/main` = user's work). All update mechanics are deterministic and live in `Vault/Scripts/update.sh` — never run the old manual git steps yourself, and never run `git rebase --abort` on the user's behalf. The one exception is that script's own `--unattended` mode, which the SessionStart hook runs and which cancels its own conflicted rebase — see the header of `Vault/Scripts/update.sh` for why.

The SessionStart hook runs this same update automatically once a day, so most of the time there is nothing left to pull; `/update` is the manual path, and the way to resolve a conflict the hook cancelled.

---

## Step 1 — Run the script

Run in one Bash call:

```bash
bash Vault/Scripts/update.sh
```

Relay its stdout to the user verbatim.

---

## Step 2 — Act on the exit code (template mechanics only)

- **0** or **9** — done. The script's own output ("Template updated…" / "Already up to date.") is the full report.
- **2, 3, 4, 5, 6, 7** — relay the script's output and stop reporting on the template step. These are user-actionable conditions (not a repo, `local/main` missing, rebase/merge already in progress, dirty tree, fetch failed, diverged `main`) and the script's message already tells the user what to do next.
- **8** — rebase conflict. The script leaves the repo mid-rebase with the conflicting files listed (`CONFLICTS:`). Relay its output, then append:

  > Resolve the conflicts above, then run:
  > ```bash
  > git add <resolved-files>
  > git rebase --continue
  > ```
  > To abort and return to your pre-update state:
  > ```bash
  > git rebase --abort
  > ```
  > Your personal files (Projects/, Vault/Memory/, Notes/) are never affected by template updates — conflicts only appear when both you and the template edited the same core file.
  > If `CLAUDE.md` is among the conflicts, the template moved its instructions to `AGENTS.md`: move your own edits into `AGENTS.md`, keep `CLAUDE.md` as the one-line `@AGENTS.md` stub, then `git add` both and continue the rebase.

- **1** — unexpected failure. Report it plainly and show the script's output; do not guess at a fix.
