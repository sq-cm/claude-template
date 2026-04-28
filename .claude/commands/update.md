# /update

You are the Orchestrator. Pull the latest core changes from the template repo into the current local branch. Execute all steps in order.

---

## Step 1 — Check for a git repo

If no `.git/` folder exists, print:

> ⚠️ Not a git repository — `/update` cannot run.

Stop here.

---

## Step 2 — Check for uncommitted changes

Run:

```bash
git status --porcelain
```

If output is non-empty, print:

> ⚠️ You have uncommitted changes. Commit or stash them before updating, then re-run `/update`.

Stop here.

---

## Step 3 — Fetch latest from origin

```bash
git fetch origin
```

Report: "Fetched latest from origin ✓"

---

## Step 4 — Merge origin/main

```bash
git merge origin/main
```

**If merge succeeds cleanly:** list the files that changed (from merge output), then print:

> **Template updated.** Your local work on `local/main` is preserved.

**If already up to date:** print:

> **Already up to date.** No changes to pull.

**If merge conflicts occur:** print the list of conflicting files, then print:

> ⚠️ Merge conflicts detected in the files above. Resolve them manually, then run:
> ```bash
> git merge --continue
> ```
> Your personal files (Projects/, Vault/Memory/, Inbox/) are never affected — conflicts will only be in core template files.
