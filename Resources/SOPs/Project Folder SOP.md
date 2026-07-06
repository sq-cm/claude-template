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

---

## Default folder structure

The Orchestrator creates the minimum structure needed. A typical project folder:

```
Projects/[project name]/
├── 01 Briefs/          ← input briefs, docx files, reference assets
├── 02 Working/         ← drafts, iterations, intermediate files
└── 03 Deliverables/    ← final outputs ready for handoff
```

Numeric prefixes enforce workflow order in alphabetical file listings — Briefs → Working → Deliverables. Without prefixes, `Deliverables` sorts above `Working`, inverting the pipeline.

Not every project needs all three. The Orchestrator creates only what the task requires; gaps are fine (e.g., a copy-only project may have just `02 Working/`). Numbers stay fixed — they signal pipeline position, not presence.

`03 Deliverables/` also carries a folder-tier `CLAUDE.md` — ships with `Projects/Template/`, so every new project folder inherits it. See [Folder-Tier CLAUDE.md SOP](Folder-Tier%20CLAUDE.md%20SOP.md) for load semantics and governance. Where `03 Deliverables/` is added to an existing project folder later, copy the folder-tier `CLAUDE.md` in from `Projects/Template/03 Deliverables/`.

**Tooling note:** any script or glob matching project subfolders should match by suffix (`*Briefs`, `*Working`, `*Deliverables`), not exact name, to survive future prefix changes.

### Sibling pair convention for HTML companions

For six deliverable types, `03 Deliverables/` holds a matched file pair — same stem name,
two extensions:

```
03 Deliverables/
  <name>.md     ← canonical source of truth
  <name>.html   ← render of approved MD content
```

**In-scope deliverable types:**

1. **Audit reports** — findings, risk tables, prioritised recommendations.
2. **Status reports** — progress dashboards, KPI summaries, traffic-light tables.
3. **Implementation plans** — phased timelines, dependency maps, milestone trackers.
4. **Comparisons** — side-by-side option analyses, diff tables, scored matrices.
5. **Research / concept explainers** — tabbed sections, annotated references, structured arguments.
6. **Incident post-mortems** — timelines, root-cause trees, corrective action tables.

**MD is canonical. HTML is a render.** Within a companion pair, the HTML file is never edited
directly — when the MD changes, the HTML is rebuilt from the updated MD using the
`html-deliverable` skill.

This rule applies **only** to MD↔HTML companion pairs in the six in-scope types above.
Standalone HTML — prototypes via the `prototype` skill, Webflow embeds, one-off interactive
artefacts, anything not paired with an MD source of truth — is unaffected and edited directly
as normal.

**Rebuild trigger (summary):** rebuild when sections move, findings change, data is corrected,
numbers or recommendations change. Skip rebuild for typo fixes, humaniser tweaks, and
prose-only edits with no semantic shift. The authoritative drift checklist is in
`.claude/skills/html-deliverable/SKILL.md` — that file governs ambiguous calls (PM judges
when the call is unclear).

**Cross-references:**

- Skill (drift checklist, footer spec, full workflow): `.claude/skills/html-deliverable/SKILL.md`
- Build standards (technical constraints): `Resources/Build Standards/html-deliverable-standards.md`
- QA checklist (HTML QA pass): `Resources/SOPs/QA Gate SOP.md` — HTML Deliverable QA Checklist section

---

## Template subfolder

`Projects/Template/` is reserved as a blank scaffold for reference. The Orchestrator never uses it as a working project folder — always create a new named folder.

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
- `Vault/Archive/` must exist before first use. The repo ships with a `.keep` file.
- Archived items are not deleted. If a retired artefact must be permanently removed, the Orchestrator surfaces the deletion request to the user and waits for explicit approval.
- After archiving a persona, the Orchestrator updates `Vault/Memory/theme-name-map.md` and any cross-references in CLAUDE.md or other personas.
