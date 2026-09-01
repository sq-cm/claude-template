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

`Projects/<name>/CONTEXT.md` and `Projects/<name>/HISTORY.md` (§ Project-scoped memory, below) are further distinct reconcile-written surfaces — deliberately different filenames so the "never write `MEMORY.md`" rule stays unambiguous. Neither is injected into every prompt (both are read on demand, `CONTEXT.md` before routing), so they carry none of `context.md`'s budget pressure.

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

   `project` is optional. Set it when the note is about a specific foldered project — it routes the note into that project's own `CONTEXT.md` and `HISTORY.md` at reconcile time (see § Project-scoped memory below) instead of only a `context.md` pointer.

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

## Project-scoped memory (CONTEXT.md + HISTORY.md)

**Purpose.** `context.md` carries a hard 3 KB injected budget (below), so anything specific to one project competes with every other project for that same rent-controlled space. Project-scoped memory gives each foldered project its own durable pair of files, travelling inside the folder itself:

- **`Projects/<name>/CONTEXT.md` — current truths.** `## Vocabulary` (the project's ubiquitous language, persona-curated), `## Live state` (rewritten in place), `## Gotchas` (the sole home for operative traps — appended, prunable). Overwrite surface.
- **`Projects/<name>/HISTORY.md` — the trail.** A pure append-only `## Decision log`: how the project got where it is, and why.

Both survive folder handoffs, carry no size budget of their own, and take the pressure off `context.md`, which then holds only a one-line pointer per active project instead of accumulating project detail directly.

**Name disambiguation.** `Projects/<name>/CONTEXT.md` (per-project current truths, read on demand) is not `Vault/Memory/context.md` (this clone's injected memory index). Prose in this vault always path-qualifies which one it means.

**The `project:` field.** Optional Stage-1 frontmatter (see above). Set it to the exact `Projects/<name>/` folder name a note is about. `/memory-reconcile` validates it against a listing of `Projects/` and rejects to `Sessions/_rejected/` (logged, reported inline) when there is no exact match, the same treatment as any other unresolvable required field. `project: Template` is rejected — the scaffold is reserved, and it is the seed source for every new pair.

**Routing summary.** Full mechanics live in `.claude/commands/memory-reconcile.md` (step 2 validation, step 5.2 routing). A note with a valid `project:` field lands in that project's pair and leaves a one-line `context.md` pointer at its `CONTEXT.md` (deduped by project folder within `## Project context`, not by exact path); a note without `project:` behaves exactly as before this section existed.

**Self-contained entry style.** Decision-log entries must read standalone for a handoff recipient — no "see `Vault/Memory/...`" pointers, since `HISTORY.md` travels with the folder and the recipient may not have (or need) access to the rest of the vault's memory. Each entry: a `### YYYY-MM-DD — <topic>` heading, 3–6 lines of what/why/outcome, and a trailing `<!-- src: <session-note-filename> -->` anchor comment.

**Dedup anchor.** The anchor comment is the idempotency key — if it already exists anywhere in the file, the append is skipped. This is what makes a crash between the decision-log append and the `## Live state` rewrite safe to recover from by simply re-running the reconcile.

**Rejection rule.** An invalid `project:` value (no matching folder) is rejected exactly like a note with a genuinely unresolvable required field — never silently dropped, never silently reassigned to a different project.

**Write order.** Per note: `HISTORY.md § Decision log` appends first; new gotchas append to `CONTEXT.md § Gotchas` second; `CONTEXT.md § Live state` rewrites **last**, because it is a destructive replace rather than an append and must never run ahead of the durable log entries it summarises. The live-state rewrite runs **once per project per reconcile run**, after every note for that project has folded — not once per note, which would let an older note's status overwrite a newer one's.

**Vocabulary is persona-curated.** `/memory-reconcile` does not write `## Vocabulary`. A persona that coins a project term records it there itself, and dispatch specs into a foldered project carry that as a standing instruction.

**Gotcha upkeep.** New traps append with dedup by substance, not by exact string — the same trap in different words is not a new line. Anyone may prune a line once the trap is dead; that is what keeps the section readable by inspection. When a note records a trap as fixed or reversed, the matching `## Gotchas` line is deleted (supersession, not accretion) and the resolution lands in `HISTORY.md § Decision log` as usual.

**Load rule.** @{Orchestrator} reads a project's `README.md` (if present) then `CONTEXT.md` before routing new work into that project — the fast way to pick up what the project is and what is true about it now. `HISTORY.md` is consulted on demand, when the "why" behind a past decision matters. Dispatch specs to sub-agents working inside a foldered project carry the same rule.

**Lifecycle.** Archival is automatic in the sense that both files travel inside their `Projects/<name>/` folder — there is nothing separate to move. When a project goes inactive, its `context.md` pointer demotes at the next reconcile like any other stale `## Project context` entry (§ Context budget & auto-archival, below); the pair itself stays put, untouched, ready to be read again if the project reopens.

**Grandfathered folders.** Folders created before these files shipped carry no pair yet. There is no bulk backfill — seeding happens on first touch, project by project, from the `Projects/Template/` skeletons. First touch is whichever comes first: the first project-tagged `/memory-reconcile` for that project, or the Orchestrator seeding before routing the first work into it. Both arms run the same procedure below; no lock is needed, because the zone test makes a prior hand-carve a no-op.

**The carve (seeding `CONTEXT.md` beside an old-shape `HISTORY.md`).** Old-shape means the `HISTORY.md` still holds current truths that now belong in `CONTEXT.md`. Seed and carve are one atomic operation:

1. **Snapshot first.** Copy the project's `HISTORY.md` to `Vault/Memory/Notes/carve-backups/<project>-HISTORY-<YYYY-MM-DD>.md` (git-ignored, outside the travelling folder) — `Projects/` is git-ignored, so this snapshot is the only undo. One per carve; report the path.
2. **Identify the zones.** The carve zones are the H2 headings `## Live state` and `## Gotchas`, plus obvious variants of them (e.g. `## Gotchas carried in`), matched at line start and **outside fenced code blocks** — a decision-log entry quoting a heading is not a heading. This is a judgement call, not a regex: if a section is genuinely ambiguous, skip the carve for that zone and report it inline. Sections outside the carve zones stay in `HISTORY.md` untouched; report them once for maintainer triage.
3. **Test each zone for content.** A zone whose body is only HTML comments and blank lines is an untouched skeleton, not content. Empty zones are deleted without copying — placeholder prose must never land in `CONTEXT.md`, where it becomes a permanent false dedup anchor.
4. **Copy, then delete — per zone, independently.** `## Gotchas` copies line-wise into `CONTEXT.md § Gotchas` with dedup, keeping only traps still operative. `## Live state`: if `CONTEXT.md`'s is empty or skeleton, take `HISTORY.md`'s; if it is already populated, `CONTEXT.md` wins (it is the newer surface by construction) — scan the carried copy for unique operative lines, fold those in, and report. Only once a zone's content is in `CONTEXT.md` is that zone deleted from `HISTORY.md`. A crash between the two therefore leaves two copies, never none, and a half-carve is simply a re-run entry point.
5. **Verify the delete.** Re-read `HISTORY.md` after the deletion to confirm it landed before reporting — Drive sync can make a write look applied when it has not.

Post-carve, `HISTORY.md` holds its `## Decision log` (and any non-canonical legacy sections) and nothing else. Because the `Projects/Template/HISTORY.md` skeleton is itself new-shape, freshly seeded folders never contain carve zones.

---

## Context budget & auto-archival

`context.md` is injected into context at every session start, so it carries a hard budget: **3 KB injected** (comment-stripped), roughly the live-state entry plus a month of one-line pointers. `/memory-reconcile` enforces it at fold time (step 5.9 of the command):

- **Superseded** pointers (a newer note replaces, reverts, or closes them) demote immediately.
- Over budget, the **oldest** `## Project context` pointers demote until the file fits.
- **Exempt:** the live-state entry, pointers tagged `[standing]`, and all sections other than `## Project context`.

Demoted pointers move verbatim to `Vault/Memory/Notes/archive-index.md` (git-ignored, never injected), grouped by month — a grep surface over the archive, not a second memory file. The note files under `Vault/Memory/Notes/<YYYY-MM>/` remain the source of truth throughout; demotion never deletes information, it only stops paying per-session rent on it. If the file is still over budget once no eligible pointers remain, the reconcile stops and reports the over-budget state.

**The `[standing]` tag.** Suffix a pointer's hook with `[standing]` when it records an operative ruling, unresolved gotcha, or action-on-trigger item (e.g. a revert checklist) rather than completed work. Tagged pointers survive budget eviction; remove the tag when the ruling is codified into CLAUDE.md/an SOP or the trigger fires. Tags are re-tested against this eligibility test at every `/memory-reconcile` (step 5.9); a tag that fails is untagged there, after any operative fragment in its hook is preserved into the linked note. Nothing writes to `MEMORY.md` — that file remains maintainer-only, unchanged by this rule.

---

## End-of-turn check (Orchestrator)

The Orchestrator must surface a reminder when `Vault/Memory/Sessions/` contains files at end-of-turn:

> "N unreconciled session notes — run `/memory-reconcile`?"

Without this prompt the protocol silently rots: notes accumulate in `Sessions/`, never make it to `context.md`, and disappear on the next clone refresh.

The reminder runs lightly — one line, no escalation. The user decides when to reconcile.

---

## Concurrent sessions (one clone)

Running multiple Claude Code terminal sessions against one vault clone is a supported pattern — one project per session, and never two sessions open against the same `Projects/` folder at once. `Projects/` subfolders are git-ignored and disjoint per project, so parallel sessions on different projects have no file contention. Repo-level conflict is off the table too: the pre-commit guard allowlists commits to `Chats/`, `Notes/`, and `Projects/` only — all git-ignored — so no local commit can change template state underneath a running session.

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
- `Resources/SOPs/Project Folder SOP.md` (the `README.md`, `CONTEXT.md` and `HISTORY.md` skeletons and their place inside a project folder)
- `Resources/SOPs/README.md` (SOP index)
