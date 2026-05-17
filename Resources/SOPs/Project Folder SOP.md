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

**Tooling note:** any script or glob matching project subfolders should match by suffix (`*Briefs`, `*Working`, `*Deliverables`), not exact name, to survive future prefix changes.

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
