# /hire

You are the Orchestrator. Guide a persona hire from capability gap to roster commit. This command codifies the hiring pipeline the Velora Studio demo teaches — it is a scaffold, not a shortcut: it automates artefact mechanics (file scaffolding, path wiring, roster-diff drafting) and holds every judgement point as a hard user pause. Nothing ships without the user saying so, four separate times.

**Orchestrator-only by construction:** hiring is an Orchestrator-only operation (root `CLAUDE.md` § Orchestrator-Only Operations — "Hiring, firing, or archiving a team member") and sub-agents are depth-1 only (§ Sub-Agent Depth), so a dispatched persona can neither run this pipeline nor dispatch the personas it requires. This command must always run at top level, never be delegated via `Agent`. If you are reading this file from within a dispatched sub-agent, stop and hand the request back to the Orchestrator.

Before starting, run the [Roster Drift SOP](../../Resources/SOPs/Roster%20Drift%20SOP.md) checks — never hire onto a drifted roster.

## Steps

### Step 1 — Gap note & permission

1. Draft a gap note (shaped like the demo's `02 Working/sam-gap-note.md`): state the capability gap, then check the existing roster inline against `Vault/Memory/theme-name-map.md` — quote the nearest existing roles and say why each does not cover the gap.
2. End the note with an explicit `[ACTION REQUIRED]` permission ask.
3. **[PAUSE 1 — role justification.]** Present the gap note and stop. Do not proceed until the user confirms the role is genuinely missing. If the user (or your own roster check) concludes an existing persona covers it, stop here — no hire, no artefacts beyond the gap note.

### Step 2 — Research brief

1. Dispatch @{SeniorResearcher} to research the role. His Advisor Checkpoints A and B are his own — they run inside his dispatch per his persona file; do not run them for him and do not strip them.
2. Scaffold the brief at `Resources/Research/[role]-brief.md` with the six sections: Role Overview, Skills Inventory, Knowledge Domains, Collaboration Patterns, Risk Areas, Voice & Personality Notes.
3. **[PAUSE 2 — brief-completeness sign-off.]** Present the completed brief and stop. The user signs off that every section is genuinely complete before @{HRLead} reads a word of it.

### Step 3 — Persona draft

1. Choose the persona's name and role token with the user. Slug rule: the token in kebab-case with acronyms flattened (e.g. `SEOSpecialist` → `seo-specialist`) — see the explicit note in `Vault/Memory/theme-name-map.md`; naive camelCase→kebab conversion breaks on acronym-heavy tokens.
2. Dispatch @{HRLead} to draft the persona from the brief. She runs Checkpoint A only — her persona file's explicit hiring carve-out; do not force a Checkpoint B onto her.
3. The draft targets `.claude/agents/[role-slug].md`, structured per the [Persona Template SOP](../../Resources/SOPs/Persona%20Template%20SOP.md): frontmatter, the 6-tool baseline, and model tier per that SOP's § Model assignment rubric (Production tier is the new-hire default; the Gatekeeper tier applies only if the gate score demands it at hire time; the Judgement tier is a decided-set promotion, never a hire-time default).
4. Schedule @{QAComplianceReviewer}'s plain post-draft review — dispatched by you, performed by Quinn's persona. This is a plain review, NOT the QA Gate: persona drafts never move to `03 Deliverables/`.
5. **[PAUSE 3 — persona-draft approval.]** Present the reviewed draft and stop until the user approves it. Writing the file into `.claude/agents/` will surface the `.claude/` write-confirmation prompt — that prompt is expected by design; never suppress or pre-approve it.

### Step 4 — Roster update & announcement

1. Draft (do not yet apply) the roster diff: the `theme-name-map.md` YAML name-map entry plus its file-path table row, and the roster announcement.
2. Walk the touchpoint checklist with the user:
   - `Vault/Memory/theme-name-map.md` — both surfaces: YAML name map AND file-path table.
   - New `.claude/agents/[role-slug].md` file on disk (written at Step 3 approval).
   - `Resources/Learn/index.html` `TEAM` JS array — add the new member's row (name, role, token, expertise, constraints) by hand; no SOP check or `validate.sh` check covers this surface.
   - `Vault/Scripts/validate.sh` `FABLE_PIN_COUNT` — update ONLY if this hire pins the Gatekeeper-tier model at hire time (rare). `OPUS5_PIN_COUNT` — update ONLY if this hire pins the Judgement-tier model (rarer still; that tier is a decided-set promotion, not a hire-time default). A default-tier hire touches neither constant.
   - `.claude/skills/README.md` dispatch lists are role-CLASS scoped — NOT a per-hire touchpoint; do not edit them per hire.
3. **[PAUSE 4 — final roster-commit confirmation.]** Present the full diff set and stop. Only on explicit confirmation, apply the roster changes and post the announcement.
4. Re-run the [Roster Drift SOP](../../Resources/SOPs/Roster%20Drift%20SOP.md) checks to confirm the roster is clean after the commit.

## Abandoned hires

A hire abandoned at any pause leaves only unwired artefacts — clean up what exists at that point: the gap note, the `Resources/Research/[role]-brief.md` scaffold, any `02 Working/`-style persona draft, and — if abandoned after PAUSE 3 — the `.claude/agents/[role-slug].md` file itself. Nothing lands in `.claude/agents/` until PAUSE 3 passes, and nothing touches `theme-name-map.md` or the Learn guide until PAUSE 4 passes; a persona file left on disk without its theme-map entry is exactly the drift the [Roster Drift SOP](../../Resources/SOPs/Roster%20Drift%20SOP.md) detects, so delete it on abandonment rather than leaving it for the next drift check.
