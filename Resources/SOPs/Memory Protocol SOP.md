---
title: Memory Protocol SOP
type: SOP
status: active
date: 2026-05-25
supersedes: (none — new SOP for P0.1 from 2026-05-24 strategic audit)
---

# Memory Protocol SOP

**Audience.** All personas who write to `Vault/Memory/`, plus Sam (Orchestrator) who reconciles.

**Why this exists.** Direct concurrent writes to the memory index corrupt the file that the prompt-submit hook loads as context. Three failure modes — parallel sub-agents in one session racing on the same anchor, multi-clone git merge conflicts, and two concurrent sessions on one clone both running `/memory-reconcile` against `context.md` — each corrupts the loaded context in its own way: the first two produce `<<<<<<< HEAD` markers, the third produces duplicated or interleaved append lines from an unsequenced write race. In every case, every subsequent agent prompt loads a broken file.

Three safeguards eliminate all three races:

1. **Two-stage write protocol** (below) — serialises writes through `/memory-reconcile`, never concurrent direct edits.
2. **Split index** — reconciled local memory lands in `context.md` (git-ignored, per-clone), **not** `MEMORY.md` (git-tracked, maintainer-owned, shipped with the template). This is what eliminates the multi-clone merge-conflict mode: cloners never write the tracked file, so `/update` rebases cleanly.
3. **Single-writer reconcile rule** — `/memory-reconcile` runs from one session at a time on a given clone. This eliminates the concurrent-session race: see [Concurrent sessions (one clone)](#concurrent-sessions-one-clone) below.

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

2. **Frontmatter is required.** Use the exact schema below. Authors must emit it. As a safety net, `/memory-reconcile` will infer-and-fill missing or body-prose frontmatter from a note's content and write it back — but that is a backstop, not a licence to skip. A note is only rejected when a required field genuinely cannot be inferred (e.g. no derivable date).

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
2. Validates frontmatter against the schema. Infers-and-fills missing or body-prose frontmatter from note content (writing the completed YAML back into the note); rejects to `Sessions/_rejected/` **only** when a required field cannot be inferred, and reports each rejection inline.
3. Moves processed notes to `Vault/Memory/Notes/<YYYY-MM>/<original-filename>` (per-clone, git-ignored).
4. Appends pointer lines to `context.md` (never `MEMORY.md`) under the matching topical H2 section. Creates `context.md` from `context.example.md` first if absent. New sections created if no match; uncategorised items go to `## Uncategorised`.
5. On conflict (two notes touch the same section), appends both pointers as separate lines. **Never merges prose.**
6. Is idempotent — re-running on a partial state skips already-moved files and already-added pointers.

Full procedure in the command file.

**Deterministic trigger.** In addition to Sam's end-of-turn prompt, the reconcile nudge now fires deterministically: `.claude/hooks/memory-pending.sh` is wired to the `PreCompact` and `SessionEnd` hook events in `.claude/settings.json`. When a session compacts or ends with unreconciled notes in `Vault/Memory/Sessions/`, the hook emits a one-line reminder to run `/memory-reconcile` — regardless of whether the model remembered to prompt. The hook is read-only (it counts top-level `.md` notes and echoes; it never writes into `Vault/Memory/`), and it does not run the reconcile itself — the fold step still needs model judgement.

---

## End-of-turn check (Sam)

The Orchestrator must surface a reminder when `Vault/Memory/Sessions/` contains files at end-of-turn:

> "N unreconciled session notes — run `/memory-reconcile`?"

Without this prompt the protocol silently rots: notes accumulate in `Sessions/`, never make it to `context.md`, and disappear on the next clone refresh.

The reminder runs lightly — one line, no escalation. The user decides when to reconcile.

---

## Concurrent sessions (one clone)

Running multiple Claude Code terminal sessions against one vault clone is a supported pattern — one project per session, and never two sessions open against the same `Projects/` folder at once. `Projects/` subfolders are git-ignored and disjoint per project, so parallel sessions on different projects have no file contention. Repo-level conflict is off the table too: the pre-commit guard allowlists commits to `Inbox/`, `Notes/`, and `Projects/` only — all git-ignored — so no local commit can change template state underneath a running session.

**Session notes are safe concurrently.** The `<ISO8601>-<persona-slug>-<topic-slug>.md` filename scheme (Stage 1) means two sessions writing notes at the same time land at different paths — no collision, no coordination required.

**`/memory-reconcile` is single-writer.** Run it from one session at a time. If several sessions each have unreconciled notes, pick one — ideally at a natural break or end of day — and reconcile there; skip the prompt in the others. Idempotency (Stage 2, point 6) protects re-running a *crashed* reconcile; it does **not** make *concurrent* reconciles safe. Two sessions appending to `context.md` at the same moment is the third failure mode above, and idempotency doesn't prevent it — only sequencing does.

**Expect double nudges.** The deterministic trigger described under Stage 2 (`.claude/hooks/memory-pending.sh` on `PreCompact`/`SessionEnd`) fires per session, so multiple concurrent sessions can each surface the "run `/memory-reconcile`" reminder independently. Treat that as one job, not several — act in one session and disregard the rest.

**Staleness resolves at the next prompt.** Both memory files load into context on every prompt, so once a sibling session's reconcile lands in `context.md`, other sessions pick it up at their very next prompt. Any lag is one prompt long — cosmetic, not a data-integrity problem.

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
