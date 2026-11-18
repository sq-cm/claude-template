# writing-plans — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 19/11/2026 (plan 180) so it stops loading on every invocation; only comment delimiters were removed. In the moved text, "this header" means the comment block that sat at the top of `SKILL.md`; "below" and "this file" refer to `SKILL.md`. Read it before any resync.

## Moved 19/11/2026 (plan 180)

Source: https://github.com/obra/superpowers (superpowers plugin). Synced at upstream
v6.1.1 on 2026-07-06 (PR #133, straight replace). Vault adaptation (plan 025):
plan save path repointed to Vault/Plans/ (git-ignored), dead superpowers:* sub-skill
dependencies (using-git-worktrees, subagent-driven-development, executing-plans)
remapped to Orchestrator-dispatch language, depth-1 guard added directing routed
personas to return reviewer dispatch to the Orchestrator instead of dispatching it
themselves. Band-1 trim (F11, 06/08/2026): one prose length-calibration line added
after the Overview's second paragraph ("Length calibration (vault adaptation): …");
it calibrates prose only and must never weaken the No Placeholders repeat-the-code
rule. Vault adaptation (plan 127): negative routing clauses appended to the description,
pointing exploration at brainstorming and design interrogation at grill-me.
Partial cherry-pick from upstream v6.4.1 (5bf4e78) on 24/09/2026 (plan 134): the plan-header
Spec line, the Review Focus template section, Self-Review item 4, and the
review-before-execution handoff wording (remapped onto the vault's Orchestrator-dispatched /
Inline options). Deliberately not taken from v6.4.1: the removal of ## Remember, the
REQUIRED SUB-SKILL lines, the Subagent-driven / Native option names and the
docs/superpowers/plans/ path. The base stays v6.1.1 for everything else.
Vault adaptation (plan 142): one sentence added to the Global Constraints template after
its bracketed guidance, pointing steps that need a human approval moment at Sub-Agent
Architecture SOP § Auto mode and permissions.
Vault adaptation (plan 148): one sentence added to the Global Constraints template pointing
time figures at AGENTS.md § Time Estimates & Status. The upstream "2-5 minutes" step line is
kept as step granularity, not a duration prediction.
Re-sync rule: carry these adaptations over any future upstream replace.
