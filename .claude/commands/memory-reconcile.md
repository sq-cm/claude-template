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

### 2. Read frontmatter — validate, infer-and-fill, or reject

The frontmatter schema is **canonical** (see `Resources/SOPs/Memory Protocol SOP.md`) — do **not** loosen the required fields or enums. Required YAML frontmatter:

- `type` — must be one of `feedback`, `project`, `reference`, `user`, `system`
- `scope` — must be one of `workflow`, `theme`, `audit`, `persona`, `tooling`, `other`
- `date` — `YYYY-MM-DD`
- `persona` — persona slug (e.g. `axel`)
- `topic` — one-line summary

Optional field:

- `project` — the exact folder name of a `Projects/<name>/` folder this note is about. When present, the note routes into that project's own `CONTEXT.md` + `HISTORY.md` at reconcile time (see step 5, item 2) in addition to the type-based `context.md` routing above. **Validation:** if `project` is present, list the `Projects/` directory and require an **exact string match** against a listed folder name — never a bare path-existence probe (NTFS/Drive are case-insensitive, so a probe passes on wrong case). `Template` is reserved (the seed scaffold) and is always rejected as a `project:` value. If the value doesn't match, the note is genuinely ambiguous for this field and is rejected the same way any other unresolvable required-field case is: move to `Sessions/_rejected/`, log it, and surface the reason inline in the run summary (`invalid project: <value> — no matching Projects/ folder`). Infer-and-fill applies here too — if a note is obviously about a foldered project (it names the folder, or the topic/body makes the match unambiguous) but is missing the `project:` line, fill it in during backfill.

Write-time discipline drifts (notes get authored with body-prose `**Type:**` or no frontmatter at all). So this step is **self-healing**: it backfills what it can derive and rejects only what it genuinely cannot. For each note, in order:

1. **Conforming** — valid YAML frontmatter, all five fields present and in-enum → use as-is.
2. **Infer-and-fill** — frontmatter missing, partial, or body-prose → derive the missing fields, then **write the completed YAML frontmatter back into the note file** (prepend, preserving the existing body). This makes the archived note conformant and stops bad examples from propagating to the next author. Inference rules:
   - `date` ← the leading `YYYY-MM-DD` in the filename (authoritative), else a date in the body.
   - `persona` ← the author slug if the note states one, else `sam` (reconcile is Sam-run; session notes default to the orchestrator).
   - `topic` ← the note's H1 / first H2 heading, trimmed to ≤ 100 chars.
   - `type` / `scope` ← classify from content: roster/persona work → `project` / `persona`; skill/tooling/infra/memory work → `project` (or `system` for an observed-behaviour log) / `tooling`; a standing instruction on how to work → `feedback` / `workflow`; a pointer to an external resource → `reference` / `other`. Fill when the value is defensible from content.
3. **Reject — loudly, and only when genuinely ambiguous** — if a required field cannot be inferred with reasonable confidence (no derivable `date`, or content too thin to classify `type`): move to `Vault/Memory/Sessions/_rejected/`, log to `Vault/Memory/reconcile-errors.md` (per-clone), **and surface each rejection inline in the run summary with its reason** — never silent. Do **not** reject for *format* drift alone (body-prose or missing frontmatter) when the fields are inferable — backfill those instead.

### 3. Determine destination

For each processed note (conforming or backfilled), the destination path is:

```
Vault/Memory/Notes/<YYYY-MM>/<original-filename>
```

`<YYYY-MM>` is derived from the note's `date` frontmatter, not the current date — this keeps backdated session notes filed correctly.

Create the `<YYYY-MM>` directory if it doesn't exist.

### 4. Move the file

```bash
mv "Vault/Memory/Sessions/<filename>" "Vault/Memory/Notes/<YYYY-MM>/<filename>"
```

If the destination file already exists (idempotent re-run case), skip the move and continue — the pointer step below will re-check `context.md`.

### 5. Update context.md

If `Vault/Memory/context.md` does not exist (a clone that skipped install/onboarding), create it first by copying the tracked seed:

```bash
[ -f Vault/Memory/context.md ] || cp Vault/Memory/context.example.md Vault/Memory/context.md
```

For each moved note:

1. Read the note's `type`, `scope`, `project`, and `topic` frontmatter.
2. **Project-scoped routing.** If the note carries a valid `project:` field (validated in step 2 above), route it into that project's own pair — `HISTORY.md` (append-only decision trail) and `CONTEXT.md` (current truths: locale, vocabulary, live state, operative gotchas) — instead of the type-based section matching in item 3 below:
   1. **Ensure both files exist; carve if old-shape.**
      - `CONTEXT.md` missing → seed it from the skeleton at `Projects/Template/CONTEXT.md` (section structure verbatim, placeholder comments intact). Present but missing a required H2 section (one of the skeleton's four: `## Locale`, `## Vocabulary`, `## Live state`, `## Gotchas`) → add the missing header only — no value, so a restored `## Locale` carries no `locale:` line and the `en-AU` default applies (non-destructive repair, report it); never reseed over a populated file.
      - `HISTORY.md` missing → seed from `Projects/Template/HISTORY.md`.
      - `HISTORY.md` old-shape — it carries **carve zones**: an H2 `## Live state`, `## Gotchas`, or an obvious variant (e.g. `## Gotchas carried in`), matched at line start **outside fenced code blocks**; when a section's status is ambiguous, skip it and report — → **carve** before folding:
        1. Snapshot `HISTORY.md` to `Vault/Memory/Notes/carve-backups/<project>-HISTORY-<YYYY-MM-DD>.md` (create the directory if absent); report the path.
        2. Per zone, independently: copy its non-skeleton content into the matching `CONTEXT.md` section — gotchas line-wise with dedup; live state replaces CONTEXT's only if CONTEXT's is empty/skeleton, otherwise CONTEXT (the newer surface) wins and any unique operative lines from HISTORY's copy are folded in and reported — then delete the zone from `HISTORY.md`. A zone whose body is only comments/blank lines is deleted without copying. **Copy first, delete last** — a crash mid-carve leaves both copies, and the re-run dedups.
        3. Re-read `HISTORY.md` after the delete to confirm it took (Drive phantom guard).
      - Sections that are neither `## Decision log` nor carve zones stay in `HISTORY.md` untouched (legacy trail); report them once for maintainer triage.
      Both first-touch arms — this step, and the Orchestrator seeding before first routing (Project Folder SOP, grandfather clause) — follow this same procedure; the zone test makes a prior hand-carve a no-op.
   2. Append a condensed, self-contained entry (3–6 lines) under `## Decision log`:
      ```markdown
      ### YYYY-MM-DD — <topic>
      <what happened / why / outcome — must read standalone, a handoff recipient
      has no access to Vault/Memory/ paths, so no "see notes/..." pointers here>
      <!-- src: <session-note-filename> -->
      ```
      **Idempotency:** if the anchor comment `<!-- src: <session-note-filename> -->` already exists anywhere in the file, skip the append entirely — this note has already been folded in.
   3. If the note records a trap, quirk, or gotcha, append a line to `CONTEXT.md` `## Gotchas` (dedup **in substance** — don't add a line covering the same trap in different words). If the note records a previously logged trap as fixed or reversed, **delete** the matching gotcha line instead — the resolution is already durable in the decision log. Gotchas here are operative and prunable; anyone may remove a dead one.
   4. Rewrite `## Live state` in `CONTEXT.md` **last**, and **once per project per run** — after *all* of that project's notes in this run have folded, derive the new live state from the full set. This section is a destructive rewrite (replaced, not appended), so it must never run ahead of the durable log entries.
   5. Ensure a one-line pointer exists in `context.md` under `## Project context`:
      ```markdown
      - [<project-name>](Projects/<name>/CONTEXT.md) — <≤12-word status hook>
      ```
      **Dedup by project folder, within `## Project context` only** — a line matches when its link target's first path segment after `Projects/` equals the note's `project:` value (percent-decode both sides, compare case-insensitively, whole segment only — prefix overlaps never match). Links into `Projects/<name>/` in other `context.md` sections never match. On a match, refresh in place: update the link target (this migrates old `HISTORY.md`-targeted pointers) and hook text, **preserving an existing `[standing]` tag**. If two pre-existing lines match the same project, collapse them to one — newest hook, `[standing]` kept if either had it — and report the collapse. This pointer, and any project-routed pointer like it, still participates in the shared prune-on-fold, live-state, and budget mechanics of items 7–9 below, since it lives in `## Project context` alongside type-routed pointers.
      The note's move to `Vault/Memory/Notes/<YYYY-MM>/` (steps 3–4 above) is unchanged and already happened before this step runs.
      Skip items 3–5 below for this note — the type-based section match and filename-dedup pointer rule are superseded by the project routing just performed.
3. For notes without a valid `project:` field, find the matching H2 section in `context.md` using this routing:
   - `type: feedback` → `## Workflow preferences` (or `## Workflow corrections` if the scope is a correction)
   - `type: project` → `## Project context` (create if missing)
   - `type: reference` → `## References`
   - `type: user` → `## User profile` (create if missing)
   - `type: system` → `## System logs`
4. Append a pointer line — **exactly one line**: link plus a hook of **≤12 words**. No multi-sentence prose, no paragraph summaries — the full detail already lives in the moved note and is retrievable on demand. `context.md` is cat'd into context **every prompt**, so each extra sentence is a permanent per-prompt tax. Form:
   ```markdown
   - [<topic>](Notes/<YYYY-MM>/<filename>) — <≤12-word hook>
   ```
5. **Conflict rule:** if a pointer to this filename already exists in `context.md`, leave the existing one in place. If two new notes route to the same H2 section, **append both pointers** as separate lines — do not merge prose.
6. If no section matches and no fallback applies, append to `## Uncategorised` (create the section if missing) for triage on the next reconcile.
7. **Prune-on-fold (`## Project context` only).** This is the section that grows every session. After appending, ensure **every** entry in it is a single line. If a prior entry spans multiple sentences or lines, collapse it to the one-line form — keep its link, distil a ≤12-word hook from it, discard the rest (the detail stays in the linked note). See the `PRUNE POLICY` note in the `context.md` header comment.
8. **Live-state entry.** `## Project context` may keep **one** expanded entry, prefixed `**Live state (<date>):**`, for the current in-flight thread. When a newer `project` note folds in and supersedes it, demote the previous live-state to a one-line pointer and promote the new note (or, if the new note isn't the active thread, just append it as a one-liner — default to one-liner).
9. **Budget check — `context.md` carries a 3 KB injected budget.** This budget applies to `context.md` only — `Projects/<name>/CONTEXT.md` and `HISTORY.md` files carry no size budget (they are read procedurally on demand, never injected into every prompt); only CONTEXT's `## Live state` section stays short by convention. **Re-test `[standing]` tags first.** Before the demotion loop below runs, re-test every `[standing]` tag in `## Project context` against the SOP's eligibility test (`Resources/SOPs/Memory Protocol SOP.md`, "The `[standing]` tag": an operative ruling, unresolved gotcha, or action-on-trigger item — **not completed work**). A tag that fails is auto-untagged: first append any operative fragment in its hook to the linked note (or the standing-rulings index), then remove the tag — the pointer becomes demotable normally. Auto-untag is safe because demotion is a reversible move, not a deletion. The "Never demote" exemption sentence below is unchanged; it applies to tags that survive this re-test. Report every untag, with its reason, in step 6.
   After all folds, measure the injected size: `perl -0777 -pe 's/<!--.*?-->//gs' Vault/Memory/context.md | wc -c`. While the result exceeds **3,072 bytes**, demote the oldest pointer line in `## Project context` (by note date): cut it from `context.md` and append it verbatim to `Vault/Memory/Notes/archive-index.md` under a `## <YYYY-MM>` heading matching the note's month (create file/heading if absent). Never demote: the live-state entry, any pointer tagged `[standing]`, or entries outside `## Project context`. If the file is still over budget once no eligible pointers remain, stop and report the over-budget state instead of looping. Demotion is a **move, not a deletion** — the pointer stays greppable in the archive index and the linked note remains the source of truth. Additionally, when a newly folded note supersedes an existing pointer (states it replaces, reverts, or closes it), demote the superseded pointer immediately regardless of budget.

### 6. Report

After processing all notes, report:

- Number of notes moved
- Any notes **backfilled** (inferred frontmatter) — list each with the `type`/`scope` that was filled in, so the user can correct a misclassification
- Per-section context.md additions (one line each)
- Any prior `## Project context` entries **collapsed** by prune-on-fold (and any live-state demotion/promotion)
- `[standing]` tags **re-tested** (step 5.9) — any untagged, listed one per line with the reason and where its operative fragment (if any) was appended
- Any pointers **demoted** to `Notes/archive-index.md` (supersession or budget), listed one per line
- Any **rejected** notes and reasons (must appear inline here, not only in the error log)
- Any idempotent skips (file already at destination)

---

## Failure modes

| Symptom | Cause | Recovery |
|---|---|---|
| Missing / body-prose / partial frontmatter | Write-time drift, fields inferable | Infer-and-fill, write completed YAML back into the note, proceed (report the backfill) |
| Required field not inferable (e.g. no derivable date) | Genuinely ambiguous | Loud reject to `Sessions/_rejected/` + log + inline report; fix and re-stage |
| Destination file exists | Re-run on partial state | Skip move; re-check context.md pointer |
| context.md pointer duplicates | Re-run after pointer added | Skip duplicate; leave existing |
| No matching section in context.md | New topic | File to `## Uncategorised`; route on next reconcile |
| `## Project context` bloated (multi-line entries) | Pointers authored as paragraphs, never pruned | Prune-on-fold (step 5.7) collapses each to a one-line hook; detail stays in the linked note |
| `context.md` over budget after fold | Pointer count grew past the 3 KB injected budget | Step 5.9 re-tests `[standing]` tags (untagging completed-work tags after extracting operative fragments), then demotes oldest untagged Project-context pointers to `Notes/archive-index.md` |
| Invalid `project:` value (no matching `Projects/` folder) | Typo, stale project name, or note about an un-foldered project | Reject to `Sessions/_rejected/` + log + inline report, same as any other unresolvable required field |
| `Projects/<name>/CONTEXT.md` or `HISTORY.md` missing | Grandfathered folder, or partial sync | Seed the missing file from its `Projects/Template/` skeleton (step 5.2.1); an old-shape `HISTORY.md` triggers the carve there too |
| `CONTEXT.md` present but missing a required section | Manual edit or partial seed | Add the missing H2 header (non-destructive repair, step 5.2.1); never reseed over a populated file |
| Crash mid-carve (zone copied but not deleted, or one zone done) | Interrupted first touch | Re-run the carve — copy-first/delete-last plus dedup makes each zone independently idempotent; the pre-carve snapshot in `Vault/Memory/Notes/carve-backups/` covers wrong outcomes |
| Crash between the `HISTORY.md` append and the `CONTEXT.md` live-state rewrite | Interrupted run mid-project-routing | Re-run the fold for that note **from its `Notes/<YYYY-MM>/` location** (step 4 already moved it out of `Sessions/`, so a plain re-run finds nothing pending) — the anchor comment (`<!-- src: ... -->`) makes the append idempotent and the live-state rewrite re-derives safely |
| Carved zone reappears after deletion | Drive duplication/phantom race | Re-read after delete (step 5.2.1); if it recurs, clear per the standing Drive traps and re-run — dedup prevents double-copies |

---

## Related

- `CLAUDE.md` → `## Memory` (canonical protocol — MEMORY.md vs context.md split)
- `Resources/SOPs/Memory Protocol SOP.md` (frontmatter schema, deeper rationale, § Project-scoped memory for the `CONTEXT.md` + `HISTORY.md` routing this command performs)
- `Resources/SOPs/Project Folder SOP.md` (the project-folder skeletons' home; grandfather clauses for `CONTEXT.md`, `HISTORY.md`, `README.md`)
- `Vault/Memory/context.example.md` (the tracked seed copied to `context.md`)
