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

This step governs the template pull only — whatever happens here, still run Step 3. "Stop" below means stop reporting on the *template* update, not skip the rest of `/update`.

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

- **1** — unexpected failure. Report it plainly and show the script's output; do not guess at a fix.

---

## Step 3 — Refresh the plannotator binary

Always runs, regardless of Step 2's exit code — the tool step is independent of template-pull mechanics and never skipped because Step 1/2 stopped, failed, or left the repo mid-rebase.

Run in one Bash call:

```bash
bash Vault/Scripts/tool-check.sh --apply
```

Relay its stdout to the user verbatim. The script installs or updates the binary itself, from a checksum-verified download; on a non-zero exit its single output line already names what stopped and what to do about it.
