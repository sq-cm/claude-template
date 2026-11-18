# improve — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 19/11/2026 (plan 180) so it stops loading on every invocation; only comment delimiters were removed. In the moved text, "this header" means the comment block that sat at the top of `SKILL.md`; "below" and "this file" refer to `SKILL.md`. Read it before any resync.

## Moved 19/11/2026 (plan 180)

Source: https://github.com/shadcn/improve (MIT). Synced against upstream commit `03369ee`
(2026-06-15) on 05/07/2026 — verified to include the secret-leakage hardening, the --issues
public-repo visibility check, the Hard Rule 1 plans/ vs advisor-plans/ fix, and stale-ADR
flagging. Vault adaptation: the over-engineering sub-lens in references/audit-playbook.md
(from the ponytail decision-ladder adoption) is local, not upstream. Vault adaptation: plan
output for THIS vault is repointed `plans/` → `Vault/Plans/` in this file,
`references/plan-template.md`, and `references/closing-the-loop.md` (vault root rule — no
new root-level folders); the `plans/`-in-repo-root + `advisor-plans/` fallback is retained
for external audited repos. Vault adaptation: the optional judge-panel mode — the `panel`
invocation bullet, one Phase 3 sentence, and references/panel-mode.md — is local, not upstream.
Vault adaptation (13/11/2026, plan 177): upstream's `execute <plan>` mode is removed — its
invocation bullet, the Hard Rules 1, 2 and 5 references, and the `execute` section of
references/closing-the-loop.md — because AGENTS.md § Orchestrator-Only Operations allows
`improve` read-only sub-agents only. Re-strip it on any resync.
