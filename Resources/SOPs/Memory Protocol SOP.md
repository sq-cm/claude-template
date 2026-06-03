---
title: Memory Protocol SOP
type: SOP
status: active
date: 2026-05-25
supersedes: (none — new SOP for P0.1 from 2026-05-24 strategic audit)
---

# Memory Protocol SOP

**Audience.** All personas who write to `Vault/Memory/`, plus Sam (Orchestrator) who reconciles.

**Why this exists.** Direct concurrent writes to the memory index corrupt the file that the prompt-submit hook loads as context. Two failure modes — parallel sub-agents in one session racing on the same anchor, and multi-clone git merge conflicts — both produce `<<<<<<< HEAD` markers in loaded context, breaking every subsequent agent prompt.

Two safeguards eliminate both races:

1. **Two-stage write protocol** (below) — serialises writes through `/memory-reconcile`, never concurrent direct edits.
2. **Split index** — reconciled local memory lands in `context.md` (git-ignored, per-clone), **not** `MEMORY.md` (git-tracked, maintainer-owned, shipped with the template). This is what eliminates the multi-clone merge-conflict mode: cloners never write the tracked file, so `/update` rebases cleanly.

| File | Tracked? | Who writes | Purpose |
|---|---|---|---|
| `MEMORY.md` | Tracked | Template maintainer only | Shipped vault-operations index — same for every install |
| `context.md` | Git-ignored (seed: `context.example.md`) | `/memory-reconcile` + onboarding bootstrap | This clone's local team memory |

Both files load into context on every prompt.

---

## Stage 1 — Write a session note

When you (any persona) surface something worth remembering mid-task:

1. **Create** a new file at `Vault/Memory/Sessions/<ISO8601>-<persona-slug>-<topic-slug>.md`.
   - ISO8601 to the minute: `2026-05-25T12-47` (colons replaced with dashes for filename safety).
   - `persona-slug` is the role slug (e.g. `axel`, `harper`, `quinn`), **not** the display name from the theme map. Slugs are theme-stable; display names rotate on theme swap.
   - `topic-slug` is 2–5 hyphenated words describing the memory.

2. **Frontmatter is required.** Use the exact schema below — drift breaks the reconcile step.

   ```yaml
   ---
   type: feedback | project | reference | user | system
   scope: workflow | theme | audit | persona | tooling | other
   date: YYYY-MM-DD
   persona: <persona-slug>
   topic: <one-line summary, ≤ 100 chars>
   ---
   ```

3. **Body** is freeform markdown. Link related memories with `[[name]]` where `name` matches another note's filename without extension.

4. **Do not edit `context.md` or `MEMORY.md` directly** mid-task. Ever. Sam will reconcile your note into `context.md` in batch via `/memory-reconcile`.

`Vault/Memory/Sessions/` is gitignored. Session notes are ephemeral until reconciled.

### Type enum reference

| `type` | When to use |
|---|---|
| `feedback` | User correction or validated approach worth applying next time |
| `project` | Decision, motivation, or context about an active project |
| `reference` | Pointer to an external system or canonical document |
| `user` | Detail about the user's role, preferences, expertise |
| `system` | Audit finding, infrastructure observation, conflict ruling |

### Scope enum reference

| `scope` | Example topics |
|---|---|
| `workflow` | Plan structure, routing patterns, QA gate behaviour |
| `theme` | Persona swap, name map operation |
| `audit` | Vault sweep finding, blindspot, remediation |
| `persona` | Specific role's scope, capability, constraint |
| `tooling` | MCP server, plugin, skill, hook |
| `other` | Doesn't fit the above — flag for taxonomy review |

---

## Stage 2 — Reconcile via `/memory-reconcile`

The slash command at `.claude/commands/memory-reconcile.md` performs Stage 2 deterministically. Sam runs it (or prompts the user to run it) whenever `Vault/Memory/Sessions/` is non-empty.

The command:

1. Reads each file in `Vault/Memory/Sessions/`.
2. Validates frontmatter against the schema. Rejects non-conforming notes to `Sessions/_rejected/`.
3. Moves valid notes to `Vault/Memory/Notes/<YYYY-MM>/<original-filename>` (tracked).
4. Appends pointer lines to `context.md` (never `MEMORY.md`) under the matching topical H2 section. Creates `context.md` from `context.example.md` first if absent. New sections created if no match; uncategorised items go to `## Uncategorised`.
5. On conflict (two notes touch the same section), appends both pointers as separate lines. **Never merges prose.**
6. Is idempotent — re-running on a partial state skips already-moved files and already-added pointers.

Full procedure in the command file.

---

## End-of-turn check (Sam)

The Orchestrator must surface a reminder when `Vault/Memory/Sessions/` contains files at end-of-turn:

> "N unreconciled session notes — run `/memory-reconcile`?"

Without this prompt the protocol silently rots: notes accumulate in `Sessions/`, never make it to `context.md`, and disappear on the next clone refresh.

The reminder runs lightly — one line, no escalation. The user decides when to reconcile.

---

## Migration policy

Existing flat files at `Vault/Memory/*.md` **stay in place**. They are singletons referenced by name from hooks, SOPs, and other memory files; migrating them would break links across the vault.

The new protocol applies only to **memories created after this SOP shipped (2026-05-25)**.

### Existing patterns that keep their own pattern

| File | Pattern | Why |
|---|---|---|
| `MEMORY.md` | Maintainer-curated shipped index; edited only by the template maintainer | Git-tracked, same for every install — cloners never write it |
| `context.md` | Per-clone local index; the `/memory-reconcile` + bootstrap target | Git-ignored, seeded from `context.example.md`; absorbs all local writes |
| `theme-name-map.md` | Direct edit (theme swaps) | Hook-loaded; needs a stable path |
| `feedback_*.md` | Direct edit by Sam on user feedback | Singleton, single-writer |
| `theme-change-log.md`, `odin-misses.md`, `repo-conflicts.md` | Append-only single-writer logs | Already gitignored per-clone |
| `audit_*.md` | Created by audit runs, indexed in `context.md` | Maintainer history; consider archiving on cloner side |

---

## Conflict rules

1. **Two session notes touch the same context.md section.** Append both pointers as separate lines. Do not merge prose. Sam may consolidate manually in a later pass if the topic warrants it.

2. **A session note's topic doesn't match any existing section.** Append to `## Uncategorised`. Sam triages on the next reconcile and either creates a new section or files under an existing one.

3. **A pointer to the same filename already exists in context.md.** Skip — the existing pointer is canonical.

4. **A destination file already exists in `notes/<YYYY-MM>/`.** Skip move (idempotent re-run case). Re-check pointer in context.md.

---

## Failure recovery

The reconcile is designed to be resumable. If `/memory-reconcile` crashes mid-run:

1. The session notes that have already been moved are at their destination.
2. The session notes still in `Sessions/` are untouched.
3. Re-run `/memory-reconcile`. Already-moved files are skipped; remaining files process normally.

If a destination file is malformed (rare — would require manual edit of a `notes/<YYYY-MM>/` file mid-reconcile), the reconcile reports the failure and continues with the next note. Manual fix required.

---

## Related

- `CLAUDE.md` → `## Memory` (canonical protocol summary)
- `.claude/commands/memory-reconcile.md` (the slash command procedure)
- `Vault/Memory/MEMORY.md` (shipped vault-operations index, maintainer-curated)
- `Vault/Memory/context.md` (per-clone local memory, reconcile target; seed: `context.example.md`)
- `Resources/SOPs/README.md` (SOP index)
