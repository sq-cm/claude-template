# SOP — Project Folder Creation

**Purpose:** Define when and how a project folder is created under `Projects/`.
**Audience:** The Orchestrator (routing), all working personas.
**Status:** Active. Owned by the Orchestrator.

---

## When a project folder is justified

A request justifies a project folder when it meets any of:

- Produces multiple durable files (briefs, reports, code embeds, image sets, specs)
- Spans more than one team member's work
- Is client- or campaign-named work (has a distinct identity)
- Will be referenced or built on in future sessions

A request does **not** justify a project folder when:

- It produces a single file or a single answer
- It's a one-off lookup, audit, or quick task with no follow-on deliverables
- It's a meta-operation (roster change, SOP edit, etc.)

---

## Orchestrator's role at routing

When the Orchestrator receives a request, they assess whether it is project-eligible **before** routing to a team member.

If eligible, the Orchestrator:

1. Proposes a folder name following the naming convention below
2. Describes what will go inside it (subfolders, file types)
3. **Waits for explicit user approval** before creating anything
4. Once approved, creates the folder structure, then routes the task

The Orchestrator does not create a project folder speculatively or mid-task. If a team member discovers mid-work that a project folder is needed, they surface it to @{Orchestrator} — the Orchestrator then proposes and seeks approval before proceeding.

Before routing work into an existing foldered project, the Orchestrator reads that project's `README.md` (if present) then `HISTORY.md` — the fastest orientation on what the project is and its prior state. Dispatch specs to the working persona instruct them to read `README.md` (if present) then `HISTORY.md` too, before picking up the task.

---

## Folder naming convention

Client or campaign work uses:

```
Projects/[YYMMDD] [Client or Campaign Name] - [Deliverable Type]/
```

Examples:
```
Projects/260417 WellJoy - SEO Audit/
Projects/260417 AISA - CyberCon Countdown Embed/
Projects/260417 Su-Bridge - Hero Banner/
```

- Use the date the project folder is created (YYMMDD)
- Client or campaign name first, then a dash and the deliverable type
- No abbreviations unless they're universally understood within the studio

### Internal-project variant

Work on the vault/template itself or studio operations (audits, infrastructure, SOP/persona work, tooling) — anything with no external client or campaign — uses:

```
Projects/YYYY-MM-DD-kebab-slug/
```

Examples:
```
Projects/2026-07-05-vault-audit/
Projects/2026-07-06-context-creep-audit/
```

- ISO date (folder creation date) + short kebab-case slug, matching the `Vault/Memory/Notes/` convention.
- Naming only — the variant does not change eligibility. Internal work must still pass the justification test above; multi-file or multi-session internal work (e.g. a vault audit) qualifies, single-file meta-ops still don't get folders.
- The default folder structure below (`01 Briefs / 02 Working / 03 Deliverables`) applies to internal projects unchanged; the QA Gate keys off `03 Deliverables/`.
- When in doubt whether work is internal or client, use the client format.
- The variant flows through archive unchanged (e.g. `Vault/Archive/Projects/2026-07-05-vault-audit/`).
- Folders created before this variant landed are grandfathered as-is — no renames or restructures.

### Grandfather clause — HISTORY.md

Project folders created before `HISTORY.md` shipped carry no `HISTORY.md` — no proactive backfill. Seed the skeleton (from `Projects/Template/HISTORY.md`) on first touch: the first project-tagged `/memory-reconcile` for that project, or — seeded by the Orchestrator before routing — the first work dispatched into it, whichever comes first.

### Grandfather clause — README.md

Project folders created before the project `README.md` shipped carry no `README.md` — no proactive backfill. Seed the skeleton (from `Projects/Template/README.md`) on first touch: the Orchestrator seeds it before routing the first work dispatched into that folder.

---

## Default folder structure

The Orchestrator creates the minimum structure needed. A typical project folder:

```
Projects/[project name]/
├── README.md           ← living snapshot (what this project is now)
├── HISTORY.md          ← project-scoped memory (decision log, live state, gotchas)
├── 01 Briefs/          ← input briefs, docx files, reference assets
├── 02 Working/         ← drafts, iterations, intermediate files
└── 03 Deliverables/    ← final outputs ready for handoff
```

Numeric prefixes enforce workflow order in alphabetical file listings — Briefs → Working → Deliverables. Without prefixes, `Deliverables` sorts above `Working`, inverting the pipeline.

Not every project needs all three. The Orchestrator creates only what the task requires; gaps are fine (e.g., a copy-only project may have just `02 Working/`). Numbers stay fixed — they signal pipeline position, not presence.

`03 Deliverables/` also carries a folder-tier `CLAUDE.md` — ships with `Projects/Template/`, so every new project folder inherits it. See [Folder-Tier CLAUDE.md SOP](Folder-Tier%20CLAUDE.md%20SOP.md) for load semantics and governance. Where `03 Deliverables/` is added to an existing project folder later, copy the folder-tier `CLAUDE.md` in from `Projects/Template/03 Deliverables/`.

`HISTORY.md` ships with `Projects/Template/` as a blank skeleton, copied into every new project folder at creation. It is project-scoped memory, self-contained and written in place by `/memory-reconcile` — see [Memory Protocol SOP](Memory%20Protocol%20SOP.md) § Project-scoped memory for the write mechanics; this SOP governs only the folder-lifecycle side.

`README.md` also ships with `Projects/Template/` as a blank skeleton, copied in alongside `HISTORY.md` at creation. It is authored by a human or persona at kickoff and edited as the project evolves.

### README vs HISTORY boundary

The two seeded docs answer different questions and are written in different modes:

- **`README.md` — what IS this project now?** A living snapshot: identity, scope and success criteria, structure deviations, owners, links, coarse status. **Overwrite in place** to keep it current.
- **`HISTORY.md` — how did it get here?** An append log (decision trail, gotchas) plus one overwrite zone (`## Live state`), written by `/memory-reconcile` from session notes.

The distinction is overwrite-vs-append, not static-vs-changing — both evolve. README is overwritten to stay current; HISTORY is appended to preserve the trail.

**Status altitude rule.** The one overlap is status, split by altitude:

- **README § Status** — coarse lifecycle, one word: `Active / Blocked / Delivered / Archived`.
- **HISTORY § Live state** — detailed operational status: in-flight items, blockers, next action.

One word up top; the detail in the log.

**Tooling note:** any script or glob matching project subfolders should match by suffix (`*Briefs`, `*Working`, `*Deliverables`), not exact name, to survive future prefix changes.

### Sibling pair convention for HTML companions

For six deliverable types, `03 Deliverables/` holds a matched file pair — same stem name,
two extensions:

```
03 Deliverables/
  <name>.md     ← canonical source of truth
  <name>.html   ← render of approved MD content
```

**In-scope deliverable types:** the six types named in CLAUDE.md § HTML Deliverable Companion; `.claude/skills/html-deliverable/SKILL.md` carries the authoritative enumeration.

**MD is canonical. HTML is a render.** Within a companion pair, the HTML file is never edited
directly — when the MD changes, the HTML is rebuilt from the updated MD using the
`html-deliverable` skill.

This rule applies **only** to MD↔HTML companion pairs in the six in-scope types.
Standalone HTML — prototypes via the `prototype` skill, Webflow embeds, one-off interactive
artefacts, anything not paired with an MD source of truth — is unaffected and edited directly
as normal.

**Rebuild trigger (summary):** rebuild when sections move, findings change, data is corrected,
numbers or recommendations change. Skip rebuild for typo fixes, humaniser tweaks, and
prose-only edits with no semantic shift. The authoritative drift checklist is in
`.claude/skills/html-deliverable/SKILL.md` — that file governs ambiguous calls (when
ambiguous, rebuild).

**Cross-references:**

- Skill (drift checklist, footer spec, full workflow): `.claude/skills/html-deliverable/SKILL.md`
- Build standards (technical constraints): `Resources/Build Standards/html-deliverable-standards.md`
- QA checklist (HTML QA pass): `Resources/SOPs/QA Gate SOP.md` — HTML Deliverable QA Checklist section

---

## Template subfolder

`Projects/Template/` is reserved as a blank scaffold for reference. The Orchestrator never uses it as a working project folder — always create a new named folder. It also carries the blank `README.md` and `HISTORY.md` skeletons that seed every new project folder.

## Demo projects

Demo projects (for learning the system) live under `Resources/Onboarding/Demos/` — not in `Projects/`. See that folder's README for the index.

---

## Handoff

Once the project folder exists and the task is complete, the working persona notifies @{Orchestrator}. The Orchestrator confirms the deliverables are in `03 Deliverables/` and the folder is tidy before closing the task.

---

## Archive (retirement of a project)

When retiring any project, document, persona, brief, or other artefact, move it to `Vault/Archive/`. The Orchestrator handles all archive operations directly and never delegates them — archiving is a meta-operation (like roster management), not production work.

Rules:

- Preserve original folder structure inside `Vault/Archive/`. A retired project at `Projects/Foo/` moves to `Vault/Archive/Projects/Foo/`. A retired persona at `.claude/agents/foo.md` moves to `Vault/Archive/.claude/agents/foo.md`. Numeric prefixes on subfolders (`01 Briefs/` etc.) are preserved on archive — do not strip.
- `README.md` travels inside the folder automatically — no separate handling needed.
- `HISTORY.md` travels inside the folder automatically — no separate handling needed. Its one-line pointer in `Vault/Memory/context.md` demotes (is removed) at the next `/memory-reconcile` once the project is no longer active.
- `Vault/Archive/` must exist before first use. The repo ships with a `.keep` file.
- Archived items are not deleted. If a retired artefact must be permanently removed, the Orchestrator surfaces the deletion request to the user and waits for explicit approval.
- After archiving a persona, the Orchestrator updates `Vault/Memory/theme-name-map.md` and any cross-references in CLAUDE.md or other personas.
