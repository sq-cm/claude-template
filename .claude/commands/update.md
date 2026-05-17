# /update

You are the Orchestrator. Pull the latest template changes from `origin/main` into the local vault using the two-branch model (`main` = upstream mirror, `local/main` = user's work). Execute all steps in order.

---

## Step 1 — Check for a git repo

If no `.git/` folder exists, print:

> ⚠️ Not a git repository — `/update` cannot run.

Stop here.

---

## Step 2 — Check `local/main` exists

Run:

```bash
git rev-parse --verify local/main
```

If this fails, print:

> ⚠️ `local/main` branch not found. Run `/onboard` first to set up the two-branch model, then re-run `/update`.

Stop here.

---

## Step 3 — Check for uncommitted changes

Run:

```bash
git status --porcelain
```

If output is non-empty, print:

> ⚠️ You have uncommitted changes. Commit or stash them before updating, then re-run `/update`.

Stop here.

---

## Step 4 — Fetch latest from origin

```bash
git fetch origin
```

Report: "Fetched latest from origin ✓"

---

## Step 5 — Fast-forward `main` to `origin/main`

```bash
git checkout main
git merge --ff-only origin/main
```

**If already up to date:** report "main already at origin/main ✓" and continue.

**If fast-forward fails:** local `main` has diverged from `origin/main` (shouldn't happen post-onboard since push is disabled and work lives on `local/main`). Print:

> ⚠️ Local `main` has diverged from `origin/main`. Inspect with `git log main..origin/main` and `git log origin/main..main`, then reset with `git reset --hard origin/main` if local `main` commits are not needed.

Stop here.

---

## Step 6 — Rebase `local/main` onto fresh `main`

```bash
git checkout local/main
git rebase main
```

**If rebase succeeds cleanly:** print:

> **Template updated.** `local/main` rebased onto fresh `main`. Your personal commits replay on top.

Stop here.

**If already up to date:** print:

> **Already up to date.** No template changes to pull.

Stop here.

**If rebase conflicts occur:** capture the conflicting files from `git diff --name-only --diff-filter=U`, then print:

> ⚠️ Rebase conflicts in the files above. Resolve them, then run:
> ```bash
> git add <resolved-files>
> git rebase --continue
> ```
> To abort and return to your pre-update state:
> ```bash
> git rebase --abort
> ```
> Your personal files (Projects/, Vault/Memory/, Inbox/) are never affected by template updates — conflicts only appear when both you and the template edited the same core file.

Stop here.
