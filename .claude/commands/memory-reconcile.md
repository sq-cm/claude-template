---
description: Reconcile session notes in Vault/Memory/Sessions/ into context.md and Vault/Memory/Notes/<YYYY-MM>/
---

# /memory-reconcile

Move pending session notes from `Vault/Memory/Sessions/` (gitignored, ephemeral) into the per-clone notes archive at `Vault/Memory/Notes/<YYYY-MM>/` (gitignored) and update `Vault/Memory/context.md` with pointer lines.

**Write target is `context.md`, never `MEMORY.md`.** `MEMORY.md` is the shipped, git-tracked vault-operations index, maintainer-curated and identical for every install — writing to it here causes rebase conflicts on `/update`. `context.md` is git-ignored per-clone local memory, so reconciled facts never participate in template updates. See `Resources/SOPs/Memory Protocol SOP.md`.

This is the Stage-2 step of the memory write protocol defined in CLAUDE.md and `Resources/SOPs/Memory Protocol SOP.md`. Sam (the Orchestrator) surfaces a reminder to run this whenever `Vault/Memory/Sessions/` contains files at end of turn.

---

## Procedure

Execute these steps in order. The procedure is idempotent — re-running on a partial state is safe.

### 1. Discover pending session notes

```bash
ls -1 Vault/Memory/Sessions/*.md 2>/dev/null
```

If the output is empty, report "No pending session notes — nothing to reconcile." and stop.

### 2. Read frontmatter and validate

For each session note, read its frontmatter. Required fields:

- `type` — must be one of `feedback`, `project`, `reference`, `user`, `system`
- `scope` — must be one of `workflow`, `theme`, `audit`, `persona`, `tooling`, `other`
- `date` — `YYYY-MM-DD`
- `persona` — persona slug (e.g. `axel`)
- `topic` — one-line summary

Reject any note that fails validation. Move rejected notes to `Vault/Memory/Sessions/_rejected/` and log to `Vault/Memory/reconcile-errors.md` (per-clone, add to `.gitignore` if not already excluded by a broader pattern). Continue with valid notes.

### 3. Determine destination

For each valid note, the destination path is:

```
Vault/Memory/Notes/<YYYY-MM>/<original-filename>
```

`<YYYY-MM>` is derived from the note's `date` frontmatter, not the current date — this keeps backdated session notes filed correctly.

Create the `<YYYY-MM>` directory if it doesn't exist.

### 4. Move the file

```bash
mv "Vault/Memory/Sessions/<filename>" "Vault/Memory/Notes/<YYYY-MM>/<filename>"
```

If the destination file already exists (idempotent re-run case), skip the move and continue — the pointer step below will re-check `MEMORY.md`.

### 5. Update context.md

If `Vault/Memory/context.md` does not exist (a clone that skipped install/onboarding), create it first by copying the tracked seed:

```bash
[ -f Vault/Memory/context.md ] || cp Vault/Memory/context.example.md Vault/Memory/context.md
```

For each moved note:

1. Read the note's `type`, `scope`, and `topic` frontmatter.
2. Find the matching H2 section in `context.md` using this routing:
   - `type: feedback` → `## Workflow preferences` (or `## Workflow corrections` if the scope is a correction)
   - `type: project` → `## Project context` (create if missing)
   - `type: reference` → `## References`
   - `type: user` → `## User profile` (create if missing)
   - `type: system` → `## System logs`
3. Append a pointer line of the form:
   ```markdown
   - [<topic>](notes/<YYYY-MM>/<filename>) — <one-line description from note body>
   ```
4. **Conflict rule:** if a pointer to this filename already exists in `context.md`, leave the existing one in place. If two new notes route to the same H2 section, **append both pointers** as separate lines — do not merge prose.
5. If no section matches and no fallback applies, append to `## Uncategorised` (create the section if missing) for triage on the next reconcile.

### 6. Report

After processing all notes, report:

- Number of notes moved
- Per-section context.md additions (one line each)
- Any rejected notes and reasons
- Any idempotent skips (file already at destination)

---

## Failure modes

| Symptom | Cause | Recovery |
|---|---|---|
| Note has invalid frontmatter | Drift from schema | Auto-move to `Sessions/_rejected/`; fix and re-stage manually |
| Destination file exists | Re-run on partial state | Skip move; re-check context.md pointer |
| context.md pointer duplicates | Re-run after pointer added | Skip duplicate; leave existing |
| No matching section in context.md | New topic | File to `## Uncategorised`; route on next reconcile |

---

## Related

- `CLAUDE.md` → `## Memory` (canonical protocol — MEMORY.md vs context.md split)
- `Resources/SOPs/Memory Protocol SOP.md` (frontmatter schema, deeper rationale)
- `Vault/Memory/context.example.md` (the tracked seed copied to `context.md`)
