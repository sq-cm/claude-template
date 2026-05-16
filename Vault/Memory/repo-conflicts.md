# Repo Conflict Log

_Written to by the team whenever a conflict arises between `Resources/Git/` repo guidance and CLAUDE.md, an SOP, or a persona constraint. Each entry records the conflict, the Odin ruling, and the outcome._

_See `Resources/SOPs/Repo Consultation SOP.md` for the full conflict-resolution workflow._

---

<!-- Entries added below by the team as conflicts arise -->

## 2026-05-16 — Auto-onboarding hook: plan-mode gate dropped

**Context:** Checkpoint A design (auto-onboarding SessionStart hook) required Tier 1 ops to defer file writes when session is in plan mode.

**Conflict:** Claude Code exposes no environment variable for plan-mode detection inside a hook script. Tier 1 ops (`git config core.hooksPath`, `cp .env.example .env`, log writes) cannot be gated.

**Odin ruling (Checkpoint B):** Accept deviation. Tier 1 writes touch only gitignored/personal state — `.env` and `.claude/settings.local.json` are gitignored; `core.hooksPath` is local repo config. None are tracked content. Safe under plan mode.

**Outcome:** Hook proceeds with Tier 1 writes unconditionally. Plan-mode users will see the JSON `additionalContext` payload but no tracked-file modifications occur.
