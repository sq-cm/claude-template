# SOP — Repo Setup

**Purpose:** Govern how repos listed in `Resources/Git/INDEX.md` are cloned when setting up a new vault instance from the template.
**Audience:** Anyone initialising a vault from this template. Trigger: first vault setup, or when a repo needs to be added or refreshed. Owned by the Orchestrator.
**Status:** Active.
**See also:** [Repo Consultation SOP.md](Repo%20Consultation%20SOP.md)

---

## When it applies

Repo setup applies in these situations:

- First-time vault setup from the template
- Adding a new repo to `INDEX.md` for the first time
- Refreshing a stale local clone

Does **not** apply to: routine repo consultation (see Repo Consultation SOP), meta-operations the Orchestrator handles directly, or single-step lookups.

---

## Core set vs. on-demand

Repos in `Resources/Git/INDEX.md` fall into two tiers:

- **Core set** — repos tagged `best-practices` or `claude-code` in `INDEX.md`. Clone these during initial vault setup.
- **On-demand** — all other repos. Clone only when first needed, as directed by the Repo Consultation SOP.

---

## Clone procedure

```bash
# Shallow clone (default)
git clone --depth 1 [GitHub URL] Resources/Git/[repo-name]

# Full clone (only when git history is required)
git clone [GitHub URL] Resources/Git/[repo-name]
```

- Use **HTTPS** by default. Switch to SSH (`git@github.com:[owner]/[repo].git`) if HTTPS is rate-limited or the repo is private.
- Clone destination is always `Resources/Git/[repo-name]/` relative to vault root.

---

## Failure handling

- If a repo is marked `⚠️ verify` in `INDEX.md`: skip it, log the failure to `Vault/Logs/clone-failures.md`, and continue with remaining repos.
- If a **network error** occurs: retry once. If still failing, skip and log. Never block setup on a single failed clone.

Log format for `Vault/Logs/clone-failures.md`:

```
## YYYY-MM-DD — [repo-name]
- URL attempted: [url or "unknown"]
- Error: [message]
- Action: skipped / retried
```

---

## Staleness policy

- **Core repos:** refresh monthly; **On-demand repos:** refresh before each use
- Refresh command (works for shallow and full clones):
  ```bash
  git -C Resources/Git/[repo] fetch --depth 1 && git -C Resources/Git/[repo] reset --hard origin/HEAD
  ```
  Note: `git pull` does not work reliably on shallow clones — use the fetch + reset pattern above.
- Default tracking branch is `main`. Pin to a specific commit only when a confirmed breaking upstream change requires it: `git -C Resources/Git/[repo] checkout [commit-hash]`

---

## Adding a new repo to INDEX.md

1. The Senior Researcher adds the row (Repo, Description, Tags, GitHub URL) to `Resources/Git/INDEX.md`.
2. If the repo is core-set (`best-practices` or `claude-code` tag), the Orchestrator clones it immediately using the clone procedure above.
3. If on-demand, no clone is needed until first use.
4. If GitHub URL is unknown, mark the URL cell `⚠️ verify` — the Senior Researcher resolves before the repo can be cloned.

---

## Edge cases

- **Large repos / LFS:** If a repo uses Git LFS or is unusually large, use `GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1` to skip LFS objects at clone time. Pull LFS files explicitly only if needed.
- **Disk space:** On-demand clones are shallow by default. If available disk is below 2 GB, defer non-essential clones and log a note to `Vault/Logs/clone-failures.md`.

---

## Vault hygiene

- `Resources/Git/*/` is excluded from version control via `.gitignore`. Cloned repos are **never** committed to the vault.
- Only `Resources/Git/INDEX.md` is committed.
