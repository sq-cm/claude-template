# Panel mode — adversarial judge pipeline

<!--
Vault-local adaptation, not upstream (shadcn/improve). Codifies the method of the
17/07/2026 vault drift audit (worked example: Vault/Plans/2026-07-17-vault-drift-audit.md).
Read by SKILL.md's `panel` invocation variant. Orchestrator-run only — see root CLAUDE.md
§ Orchestrator-Only Operations and Resources/SOPs/Sub-Agent Architecture SOP.md.
-->

Panel mode replaces Phase 3's solo vetting with an adversarial persona-judge pipeline. The judges also serve as the Phase 2 auditors — one dispatch per judge covers both jobs (audit their own lens, then cross-challenge the pooled findings). Everything else in the improve workflow is unchanged: Phase 1 recon runs first, Phase 4 plan-writing follows the report.

## 1. When panel runs

- **Only on the explicit `panel` keyword** in the invocation. Never implicitly, at any effort level.
- Composes with effort levels: `panel` (standard coverage), `deep panel`, `quick panel`. Effort still controls *coverage* (how much repo, per the Phase 2 table); panel controls *verification depth*.
- **Roster override:** the panel's 4–5 judges override the effort table's subagent column — `quick panel` still dispatches the full panel, just scoped to recon hotspots.
- **Cost warning:** expect roughly 3–5× the tokens of the same audit without panel (judge fan-out + cross-challenge round + Senior Adviser checkpoints). That cost is the point — reserve panel for audits whose findings feed governance changes or a prioritised backlog.

## 2. Roster selection

Chosen per run, at Checkpoint A, by the Orchestrator:

- **4–5 persona judges.** Persona agents, not generic Explore agents — domain priors are part of the method (in the worked example, the security judge caught the permission findings and the roster judge refuted a mis-attributed evidence leg from roster knowledge).
- **Lens-coverage rule:** the panel must cover the audit categories in scope for this run; each judge holds exactly one distinct lens; no lens doubled.
- **Senior Adviser is never a judge.** Their fixed roles: Checkpoint A (scope), Checkpoint B (draft findings), and tie-breaker on split verdicts. Tie-break authority must not sit with any finding's author.
- Resolve persona names via `Vault/Memory/theme-name-map.md` at run time — never hardcode names in briefs copied from old reports.

Worked default for governance-surface audits (the drift-audit five, by role):

| Lens | Role token |
|---|---|
| Architecture, simplicity, dead references | AutomationArchitect |
| Governance, SOP coherence | BusinessAnalyst |
| Persona, roster, tool registry | HRLead |
| Docs, onboarding | ContentStrategist |
| Security, permissions | QAComplianceReviewer |

## 3. Pipeline

Five mandatory stages, bracketed by the two checkpoints. Per the Advisor Checkpoints SOP, the Orchestrator dispatches the Senior Adviser and routes the verdict back at each checkpoint.

**Checkpoint A — scope (before any fan-out).** Senior Adviser reviews: audit surfaces in scope, the settled-decisions exclusion list (standing rulings, ADR-recorded tradeoffs, recently merged decisions — judges must not re-litigate these), the proposed roster against the lens-coverage rule, and output location. In the worked example Checkpoint A added surfaces and an exclusion list — expect corrections.

1. **Parallel judge fan-out.** All judges dispatched in a single message. Each audits the in-scope surfaces through their assigned lens only and returns findings in the playbook's Finding format. Brief contents: § 4 below.
2. **Cross-challenge round.** Pool round-1 findings, then send every judge every *other* judge's findings. Each returns, per finding: **AGREE** (independently verified — say what was checked), **DISSENT** (with evidence), or **SEVERITY-CHALLENGE** (up or down, with argument) — plus any **nominations**: new findings the pooled evidence suggests. In the worked example, three of ten final findings arrived as challenge-round nominations; the round is not optional.
3. **Senior Adviser tie-break.** Any finding with unresolved dissent or a split severity goes to the Senior Adviser, who rules: severity, keep, or drop. Rulings are recorded per finding.
4. **Single-author re-verification.** Any finding that ends the challenge round with no second judge's AGREE gets independently re-verified by the Orchestrator (open the cited files, confirm the evidence) before it may appear in the final report.
5. **Consensus recording.** Every surviving finding carries its consensus line (author; agree/dissent lists; any ruling). Every refuted or withdrawn finding is recorded in the report's refuted section with the refuting evidence — these records are what stop the next run re-auditing dead ends.

**Checkpoint B — draft findings (before the final report).** Senior Adviser reviews the draft findings table, the tie-break rulings, and the backlog order. Corrections are applied and logged in the report's checkpoint log.

## 4. Judge brief checklist

Each judge brief contains, in addition to **everything on the Phase 2 subagent-brief list in SKILL.md** (playbook absolute path with the exact section headings **including "## Finding format"**, recon facts, domain risk hints, decided tradeoffs, findings-only instruction, Hard Rules 4 and 6 verbatim):

- **The assigned lens**, and an instruction to stay inside it — cross-lens observations become challenge-round nominations, not round-1 findings.
- **The settled-rulings exclusion list** from Checkpoint A, verbatim.
- **Read-only instruction with enforcement note** — persona agents hold Write/Edit, so read-only is behavioural, not config-enforced (do not claim otherwise in the brief). State it plainly: *"You are read-only for this task. Do not create, edit, or delete any file. Any write invalidates your findings."*
- **Anti-padding wording, verbatim:**

  > Report as many findings as survive your own verification — quality bar over count; an empty list is a valid result.

  Never give judges a minimum finding count. If the user's invocation named a count, treat it as a soft target, do not pass it to the judges, and note it in the report's method header.

For the cross-challenge round, the follow-up brief adds: the pooled findings of the *other* judges (never the judge's own), the AGREE / DISSENT / SEVERITY-CHALLENGE / nomination vocabulary, and an instruction to verify against the working tree before agreeing — an AGREE without stated evidence counts for nothing at stage 4.

## 5. Report skeleton

One date-named file: `Vault/Plans/YYYY-MM-DD-<slug>.md` (the writing-plans convention — deliberately distinct from improve's `NNN-<slug>.md` executor plans). Mirror the worked example's structure:

```markdown
# <Audit title>

**Date:** DD/MM/YYYY · **PM owner:** <name> · **Status:** <draft | final (Checkpoint B passed)>
**Audited at commit:** <git rev-parse --short HEAD, recorded during recon>
**Panel:** <judge (lens) · … · Senior Adviser (Checkpoints A and B, tie-breaker)>
**Method:** parallel N-judge fan-out, full cross-challenge round, <tie-breaks>, <re-verifications>
**Constraints honoured:** read-only on source; settled decisions excluded: <list>

## Checkpoint log
- Checkpoint A: <verdict + corrections applied>
- Checkpoint B: <verdict + corrections applied>

## Refuted during verification (recorded, not counted)
- <R-entries: claim, refuting evidence, root cause, disposition>

## Findings (N)
### <ID> — <title> — **<SEVERITY>** <(ruling note if tie-broken)>
**Judges:** <author>; agree: <…>; dissent: <…>. <Ruling if any.>
**Evidence:** <file:line refs — Finding format per .claude/skills/improve/references/audit-playbook.md § Finding format>
**Fix:** <one-liner>

## Prioritised backlog (<Senior Adviser>-approved order)
| # | Finding | Severity | Effort | Action |
```

Findings follow the Finding format in [audit-playbook.md](audit-playbook.md) § Finding format — do not restate it here or in briefs beyond the pointer.

## 6. After the report

- Hand back to the standard Phase 3→4 flow: present the backlog, ask which findings become plans. Selected ones become `NNN-<slug>.md` executor plans as normal. **Zero plans selected is a legitimate outcome** — panel backlogs often contain small fixes executed directly from the report.
- Mirror every refuted/rejected finding into `Vault/Plans/README.md` § considered-and-rejected (create the section if absent) so future runs — panel or solo — skip them.
- Verification lesson from the worked example (R1): when checking a relative markdown link cited in a finding, resolve it against the *citing file's own folder*, not the repo root.
