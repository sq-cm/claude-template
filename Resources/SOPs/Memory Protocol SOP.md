---
title: Memory Protocol SOP
type: SOP
status: active
date: 2026-05-25
supersedes: (none — new SOP for P0.1 from 2026-05-24 strategic audit)
---

# Memory Protocol SOP

**Audience.** All personas who write to `Vault/Memory/`, plus @{Orchestrator}, who reconciles.

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

`Projects/<name>/HISTORY.md` (§ Project-scoped memory, below) is a third, distinct reconcile-written surface — deliberately a different filename so the "never write `MEMORY.md`" rule stays unambiguous. It is never injected into every prompt (it's read on demand), so it carries none of `context.md`'s budget pressure.

---

## Stage 1 — Write a session note

When you (any persona) surface something worth remembering mid-task:

1. **Create** a new file at `Vault/Memory/Sessions/<ISO8601>-<persona-slug>-<topic-slug>.md`.
   - ISO8601 to the minute: `2026-05-25T12-47` (colons replaced with dashes for filename safety).
   - `persona-slug` is the role slug (e.g. `automation-architect`, `hr-lead`, `qa-compliance-reviewer`), **not** the display name from the theme map. Slugs are theme-stable; display names rotate on theme swap.
   - `topic-slug` is 2–5 hyphenated words describing the memory.

2. **Frontmatter is required.** Use the exact schema below. Authors must emit it. As a safety net, `/memory-reconcile` will infer-and-fill missing or body-prose frontmatter from a note's content and write it back — but that is a backstop, not a licence to skip. A note is only rejected when a required field genuinely cannot be inferred (e.g. no derivable date).

   ```yaml
   ---
   type: feedback | project | reference | user | system
   scope: workflow | theme | audit | persona | tooling | other
   date: YYYY-MM-DD
   persona: <persona-slug>
   topic: <one-line summary, ≤ 100 chars>
   project: <optional — exact Projects/<name>/ folder name>
   ---
   ```

   `project` is optional. Set it when the note is about a specific foldered project — it routes the note into that project's own `HISTORY.md` at reconcile time (see § Project-scoped memory below) instead of only a `context.md` pointer.

3. **Body** is freeform markdown. Link related memories with `[[name]]` where `name` matches another note's filename without extension.

4. **Do not edit `context.md` or `MEMORY.md` directly** mid-task. Ever. @{Orchestrator} will reconcile your note into `context.md` in batch via `/memory-reconcile`.

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

The slash command at `.claude/commands/memory-reconcile.md` performs Stage 2 deterministically. @{Orchestrator} runs it (or prompts the user to run it) whenever `Vault/Memory/Sessions/` is non-empty.

The command validates each note (frontmatter handling per Stage 1, point 2), moves it to `Vault/Memory/Notes/<YYYY-MM>/` (per-clone, git-ignored), and appends pointer lines to `context.md` — never `MEMORY.md`, creating `context.md` from `context.example.md` first if absent. Two properties are load-bearing here: it **never merges prose** on conflict (see Conflict rules below), and it is **idempotent** — re-running on a partial state skips already-moved files and already-added pointers. The full procedure lives in the command file, not here.

**Deterministic trigger.** In addition to @{Orchestrator}'s end-of-turn prompt, the reconcile nudge now fires deterministically: `.claude/hooks/memory-pending.sh` is wired to the `PreCompact` and `SessionEnd` hook events in `.claude/settings.json`. When a session compacts or ends with unreconciled notes in `Vault/Memory/Sessions/`, the hook emits a one-line reminder to run `/memory-reconcile` — regardless of whether the model remembered to prompt. The hook is read-only (it counts top-level `.md` notes and echoes; it never writes into `Vault/Memory/`), and it does not run the reconcile itself — the fold step still needs model judgement.

---

## Project-scoped memory (HISTORY.md)

**Purpose.** `context.md` carries a hard 3 KB injected budget (below), so anything specific to one project competes with every other project for that same rent-controlled space. Project-scoped memory gives each foldered project its own durable log — `Projects/<name>/HISTORY.md` — that travels inside the folder itself. It survives folder handoffs, carries no size budget of its own, and takes the pressure off `context.md`, which then holds only a one-line pointer per active project instead of accumulating project detail directly.

**The `project:` field.** Optional Stage-1 frontmatter (see above). Set it to the exact `Projects/<name>/` folder name a note is about. `/memory-reconcile` validates it — the folder must exist — and rejects to `Sessions/_rejected/` (logged, reported inline) when it doesn't, the same treatment as any other unresolvable required field.

**Routing summary.** Full mechanics live in `.claude/commands/memory-reconcile.md` (step 2 validation, step 5.2 routing). A note with a valid `project:` field lands in that project's `HISTORY.md` and leaves a one-line `context.md` pointer (deduped by path, not filename); a note without `project:` behaves exactly as before this section existed.

**Self-contained entry style.** Decision-log entries must read standalone for a handoff recipient — no "see `Vault/Memory/...`" pointers, since `HISTORY.md` travels with the folder and the recipient may not have (or need) access to the rest of the vault's memory. Each entry: a `### YYYY-MM-DD — <topic>` heading, 3–6 lines of what/why/outcome, and a trailing `<!-- src: <session-note-filename> -->` anchor comment.

**Dedup anchor.** The anchor comment is the idempotency key — if it already exists anywhere in the file, the append is skipped. This is what makes a crash between the decision-log append and the `## Live state` rewrite safe to recover from by simply re-running the reconcile.

**Rejection rule.** An invalid `project:` value (no matching folder) is rejected exactly like a note with a genuinely unresolvable required field — never silently dropped, never silently reassigned to a different project.

**Write order.** Decision log (and Gotchas, if applicable) append first; `## Live state` rewrites last, because it is a destructive replace rather than an append and must never run ahead of the durable log entry it's summarising.

**Load rule.** @{Orchestrator} reads a project's `README.md` (if present) then `HISTORY.md` before routing new work into that project — the fast way to pick up what the project is, prior decisions, and known gotchas without re-deriving them. Dispatch specs to sub-agents working inside a foldered project should instruct the persona to read `README.md` (if present) then `HISTORY.md` first, same as they'd be pointed at a brief.

**Lifecycle.** Archival is automatic in the sense that the file travels inside its `Projects/<name>/` folder — there is nothing separate to move. When a project goes inactive, its `context.md` pointer demotes at the next reconcile like any other stale `## Project context` entry (§ Context budget & auto-archival, below); the `HISTORY.md` file itself stays put, untouched, ready to be read again if the project reopens. **Grandfathered folders** — those created before this feature shipped — have no `HISTORY.md` yet; one is seeded from the `Projects/Template/HISTORY.md` skeleton on first touch (the first note that reconciles against that project). There is no bulk backfill — it happens on demand only, project by project, as notes about it are reconciled.

---

## Context budget & auto-archival

`context.md` is injected into context at every session start, so it carries a hard budget: **3 KB injected** (comment-stripped), roughly the live-state entry plus a month of one-line pointers. `/memory-reconcile` enforces it at fold time (step 5.9 of the command):

- **Superseded** pointers (a newer note replaces, reverts, or closes them) demote immediately.
- Over budget, the **oldest** `## Project context` pointers demote until the file fits.
- **Exempt:** the live-state entry, pointers tagged `[standing]`, and all sections other than `## Project context`.

Demoted pointers move verbatim to `Vault/Memory/Notes/archive-index.md` (git-ignored, never injected), grouped by month — a grep surface over the archive, not a second memory file. The note files under `Vault/Memory/Notes/<YYYY-MM>/` remain the source of truth throughout; demotion never deletes information, it only stops paying per-session rent on it. If the file is still over budget once no eligible pointers remain, the reconcile stops and reports the over-budget state.

**The `[standing]` tag.** Suffix a pointer's hook with `[standing]` when it records an operative ruling, unresolved gotcha, or action-on-trigger item (e.g. a revert checklist) rather than completed work. Tagged pointers survive budget eviction; remove the tag when the ruling is codified into CLAUDE.md/an SOP or the trigger fires. Nothing writes to `MEMORY.md` — that file remains maintainer-only, unchanged by this rule.

---

## End-of-turn check (Orchestrator)

The Orchestrator must surface a reminder when `Vault/Memory/Sessions/` contains files at end-of-turn:

> "N unreconciled session notes — run `/memory-reconcile`?"

Without this prompt the protocol silently rots: notes accumulate in `Sessions/`, never make it to `context.md`, and disappear on the next clone refresh.

The reminder runs lightly — one line, no escalation. The user decides when to reconcile.

---

## Concurrent sessions (one clone)

Running multiple Claude Code terminal sessions against one vault clone is a supported pattern — one project per session, and never two sessions open against the same `Projects/` folder at once. `Projects/` subfolders are git-ignored and disjoint per project, so parallel sessions on different projects have no file contention. Repo-level conflict is off the table too: the pre-commit guard allowlists commits to `Notes/` and `Projects/` only — all git-ignored — so no local commit can change template state underneath a running session.

**Session notes are safe concurrently.** The `<ISO8601>-<persona-slug>-<topic-slug>.md` filename scheme (Stage 1) means two sessions writing notes at the same time land at different paths — no collision, no coordination required.

**`/memory-reconcile` is single-writer.** Run it from one session at a time. If several sessions each have unreconciled notes, pick one — ideally at a natural break or end of day — and reconcile there; skip the prompt in the others. Idempotency (Stage 2) protects re-running a *crashed* reconcile; it does **not** make *concurrent* reconciles safe. Two sessions appending to `context.md` at the same moment is the third failure mode above, and idempotency doesn't prevent it — only sequencing does.

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
| `feedback_*.md` | Direct edit by @{Orchestrator} on user feedback | Singleton, single-writer |
| `theme-change-log.md`, `odin-misses.md`, `repo-conflicts.md` | Append-only single-writer logs | Already gitignored per-clone |
| `audit_*.md` | Created by audit runs, indexed in `context.md` | Maintainer history; consider archiving on cloner side |

---

## Conflict rules

1. **Two session notes touch the same context.md section.** Append both pointers as separate lines. Do not merge prose. @{Orchestrator} may consolidate manually in a later pass if the topic warrants it.

2. **A session note's topic doesn't match any existing section.** Append to `## Uncategorised`. @{Orchestrator} triages on the next reconcile and either creates a new section or files under an existing one.

3. **A pointer to the same filename already exists in context.md.** Skip — the existing pointer is canonical.

4. **A destination file already exists in `Notes/<YYYY-MM>/`.** Skip move (idempotent re-run case). Re-check pointer in context.md.

---

## Failure recovery

The reconcile is designed to be resumable. If `/memory-reconcile` crashes mid-run:

1. The session notes that have already been moved are at their destination.
2. The session notes still in `Sessions/` are untouched.
3. Re-run `/memory-reconcile`. Already-moved files are skipped; remaining files process normally.

If a destination file is malformed (rare — would require manual edit of a `Notes/<YYYY-MM>/` file mid-reconcile), the reconcile reports the failure and continues with the next note. Manual fix required.

---

## Related

- `CLAUDE.md` → `## Memory` (canonical protocol summary)
- `.claude/commands/memory-reconcile.md` (the slash command procedure, incl. `project:` routing detail)
- `Vault/Memory/MEMORY.md` (shipped vault-operations index, maintainer-curated)
- `Vault/Memory/context.md` (per-clone local memory, reconcile target; seed: `context.example.md`)
- `Resources/SOPs/Project Folder SOP.md` (the `README.md` and `HISTORY.md` skeletons and their place inside a project folder)
- `Resources/SOPs/README.md` (SOP index)
