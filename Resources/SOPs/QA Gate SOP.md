# SOP — QA Gate

**Purpose:** Define how the QA Compliance Reviewer (Quinn) gates files before they move to `03 Deliverables/`.
**Audience:** The Orchestrator (must add QA step to every plan), all working personas (deliverable producers), Quinn (reviewer).
**Status:** Active. Owned by the Orchestrator.

---

## When the QA Gate runs

Before any file moves to a `03 Deliverables/` folder, Quinn must be spawned as a sub-agent to review it.

**Exemption:** the folder-tier `CLAUDE.md` inside `03 Deliverables/` is folder infrastructure, not a deliverable — it never goes to Quinn and is exempt from the Gate; see [Folder-Tier CLAUDE.md SOP](Folder-Tier%20CLAUDE.md%20SOP.md).

**Optional broad scope (upgrade path) — not the default** *(supersedes the prior mandatory broad reading)*. A maintainer may extend the Gate to durable artefact changes that meet project-eligible criteria (per the Project Folder SOP) — SOP edits, persona edits, audit close-outs — even when no `03 Deliverables/` folder is involved. The shipped default is narrow (Deliverables only). To adopt the broad scope, state it here and in CLAUDE.md § QA Gate. Revisit once the fast-path lane (S2) exists, which makes broad scope less operationally costly.

## Plan-positioning rule

Every project plan must include a QA Gate step explicitly. The step is positioned **after Checkpoint B** and **before** any file moves to `03 Deliverables/`. Plans that omit the QA Gate step are not approvable.

## Routing

- **The Orchestrator must not run QA inline.** This includes humaniser checks — Quinn handles those as part of her review.
- Quinn is invoked via the `Agent` tool with `subagent_type: "QA Compliance Reviewer"`.
- The dispatching persona supplies Quinn with: file paths under review, applicable standards (CLAUDE.md, relevant SOPs, project brief), and what specifically to verify.

## Verdicts

Quinn returns one of three formal verdicts:

| Verdict | Effect |
|---|---|
| **PASS** | File may move to `03 Deliverables/`. |
| **FLAGGED** | Specific issues returned to the producing persona for revision. After revision, Quinn re-reviews. |
| **BLOCKED** | File does not move until all blocking issues are resolved. May require routing back to Checkpoint A. |

Quinn's report cites specific lines, standards, and revision points where applicable. Vague verdicts are not acceptable.

## Re-review

If Quinn returns FLAGGED or BLOCKED, the producing persona revises and re-submits. There is no limit on re-review rounds, but the Orchestrator should escalate to the user if Quinn flags the same issue twice with no resolution path.

---

## HTML Deliverable QA Checklist

Quinn's second pass for HTML companions produced by the `html-deliverable` skill. Runs only after MD QA has issued PASS on the source — never against unreviewed or FLAGGED Markdown.

### Authoritative checklist

Quinn applies BLOCK and FLAG rules verbatim from `Resources/Build Standards/html-deliverable-standards.md`. The build standards file is the single source of truth — no rules duplicated here, to prevent drift between gate and standards.

### Additional gate-level checks

Two checks that belong to the gate, not the build:

- **Footer hash matches source MD.** Recompute SHA-1 of MD (LF-normalised, trailing whitespace stripped per line). Compare first 8 chars to footer hash. **BLOCK** on mismatch — means HTML was rendered from a different MD version than the one on disk.
- **No new claims.** HTML must introduce no findings, numbers, or recommendations absent from approved MD. HTML renders approved content; it does not editorialise. **BLOCK** on additions.

### Verdict format

PASS, FLAGGED, or BLOCKED — same protocol as MD QA. Verdict includes: file path reviewed, source MD path and hash checked, list of checks run, and any FLAG/BLOCK items with specific location and rule violated. Vague verdicts are not acceptable.

### Sequence

```
MD produced → humaniser → Quinn MD QA (PASS) → HTML rendered →
Quinn HTML QA (this section) → sibling pair moves to 03 Deliverables/
```

Both gates issue independent PASS verdicts. HTML rendering does not begin while MD QA is FLAGGED or BLOCKED.

### Cross-references

- Build standards (authoritative rules): `Resources/Build Standards/html-deliverable-standards.md`
- Skill (workflow, drift policy, footer spec): `.claude/skills/html-deliverable/SKILL.md`
