# SOP — QA Gate

**Purpose:** Define how the QA Compliance Reviewer gates files before they move to `03 Deliverables/`.
**Audience:** The Orchestrator (must add QA step to every plan), all working personas (deliverable producers), @{QAComplianceReviewer} (reviewer).
**Status:** Active. Owned by the Orchestrator.

---

## When the QA Gate runs

Before any file moves to a `03 Deliverables/` folder, @{QAComplianceReviewer} must be spawned as a sub-agent to review it.

**Exemption:** the folder-tier `CLAUDE.md` inside `03 Deliverables/` is folder infrastructure, not a deliverable — it never goes to @{QAComplianceReviewer} and is exempt from the Gate; see [Folder-Tier CLAUDE.md SOP](Folder-Tier%20CLAUDE.md%20SOP.md).

**Optional broad scope (upgrade path) — not the default**. A maintainer may extend the Gate to durable artefact changes — for this purpose, edits to a governance or process artefact that persists and is relied upon going forward, such as SOP edits, persona edits, and audit close-outs — even when no `03 Deliverables/` folder is involved. The shipped default is narrow (Deliverables only). To adopt the broad scope, state it here and in CLAUDE.md § QA Gate. The [Fast-Path Lane SOP](Fast-Path%20Lane%20SOP.md) makes broad scope less operationally costly to adopt.

## Plan-positioning rule

Every project plan must include a QA Gate step explicitly. The step is positioned **after Checkpoint B** and **before** any file moves to `03 Deliverables/`. Plans that omit the QA Gate step are not approvable.

## Routing

- **The Orchestrator must not run QA inline.** This includes humaniser checks — @{QAComplianceReviewer} handles those as part of the review.
- @{QAComplianceReviewer} is invoked via the `Agent` tool with `subagent_type: "QA Compliance Reviewer"`.
- The Orchestrator supplies @{QAComplianceReviewer} with: file paths under review, applicable standards (CLAUDE.md, relevant SOPs, project brief), and what specifically to verify.

## Humaniser rule (canonical)

This is the canonical statement of the deliverable-side humaniser rule. Other
files state it as pointers to this section, except the sites listed under
"Different rule" below.

1. **Every written deliverable** — any client-facing or durable written
   artefact: briefs, proposals, copy, emails, reports — gets a `/humaniser`
   pass before it is finalised. No exceptions for short documents.
2. **Sequencing.** The producing persona runs `/humaniser` on the finished
   draft before Checkpoint B (where checkpoints apply), and always before the
   QA Gate review — see the Sequence diagram below.
3. **Review routing.** Humaniser output is reviewed by @{QAComplianceReviewer}
   as part of the Gate verdict; the Orchestrator never runs the check inline
   (see Routing above).

**Different rule — do not consolidate here:** the Fast-Path Lane's inline
AU-English + humaniser pass (CLAUDE.md § Fast-Path Lane, Fast-Path Lane SOP)
is a separate control. Fast-Path work bypasses the QA Gate, so this canonical
never fires on it — the inline pass is the only check that prose will ever
get, and its sites stay full rule text. Skill-level carve-outs (prompt
code-blocks are never humanised) also stay in-skill: they fire at generation
time.

## Verdicts

@{QAComplianceReviewer} returns one of three formal verdicts:

| Verdict | Effect |
|---|---|
| **PASS** | File may move to `03 Deliverables/`. |
| **FLAGGED** | Specific issues returned to the producing persona for revision. After revision, @{QAComplianceReviewer} re-reviews. |
| **BLOCKED** | File does not move until all blocking issues are resolved. May require routing back to Checkpoint A. |

@{QAComplianceReviewer}'s report cites specific lines, standards, and revision points where applicable. Vague verdicts are not acceptable.

## Re-review

If @{QAComplianceReviewer} returns FLAGGED or BLOCKED, the producing persona revises and re-submits. There is no limit on re-review rounds, but the Orchestrator should escalate to the user if @{QAComplianceReviewer} flags the same issue twice with no resolution path.

---

## HTML Deliverable QA Checklist

@{QAComplianceReviewer}'s second pass for HTML companions produced by the `html-deliverable` skill. Runs only after MD QA has issued PASS on the source — never against unreviewed or FLAGGED Markdown.

### Authoritative checklist

@{QAComplianceReviewer} applies BLOCK and FLAG rules verbatim from `Resources/Build Standards/html-deliverable-standards.md`. The build standards file is the single source of truth — no rules duplicated here, to prevent drift between gate and standards.

### Additional gate-level checks

Two checks that belong to the gate, not the build:

- **Footer hash matches source MD.** Recompute SHA-1 of MD (LF-normalised, trailing whitespace stripped per line). Compare first 8 chars to footer hash. **BLOCK** on mismatch — means HTML was rendered from a different MD version than the one on disk.
- **No new claims.** HTML must introduce no findings, numbers, or recommendations absent from approved MD. HTML renders approved content; it does not editorialise. **BLOCK** on additions.

### Verdict format

PASS, FLAGGED, or BLOCKED — same protocol as MD QA. Verdict includes: file path reviewed, source MD path and hash checked, list of checks run, and any FLAG/BLOCK items with specific location and rule violated. Vague verdicts are not acceptable.

### Sequence

```
MD produced → humaniser → @{QAComplianceReviewer} MD QA (PASS) → HTML rendered →
@{QAComplianceReviewer} HTML QA (this section) → sibling pair moves to 03 Deliverables/
```

Both gates issue independent PASS verdicts. HTML rendering does not begin while MD QA is FLAGGED or BLOCKED.

The HTML render carries no separate Checkpoint B: it is the same approved content as the source MD, which already cleared Checkpoint B before MD QA — rendering to HTML does not reopen that gate.

### Cross-references

- Build standards (authoritative rules): `Resources/Build Standards/html-deliverable-standards.md`
- Skill (workflow, drift policy, footer spec): `.claude/skills/html-deliverable/SKILL.md`
