# /update

You are the Orchestrator. Pull the latest template changes from `origin/main` into the local vault using the two-branch model (`main` = upstream mirror, `local/main` = user's work). All update mechanics are deterministic and live in `Vault/Scripts/update.sh` — never run the old manual git steps yourself, and never run `git rebase --abort` on the user's behalf.

---

## Step 1 — Run the script

Run in one Bash call:

```bash
bash Vault/Scripts/update.sh
```

Relay its stdout to the user verbatim.

---

## Step 2 — Act on the exit code

- **0** or **9** — done. The script's own output ("Template updated…" / "Already up to date.") is the full report.
- **2, 3, 4, 5, 6, 7** — relay the script's output and stop. These are user-actionable conditions (not a repo, `local/main` missing, rebase/merge already in progress, dirty tree, fetch failed, diverged `main`) and the script's message already tells the user what to do next.
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

- **1** — unexpected failure. Report it plainly and show the script's output; do not guess at a fix.
