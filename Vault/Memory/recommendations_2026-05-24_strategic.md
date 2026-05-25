---
title: Strategic Vault Recommendations — Distribution + Small-Team Lens
date: 2026-05-24
type: recommendations
lens: distribution + small-team safety
audience: cloning teams of 2-5 in creative/marketing studios
status: Pass 1 P0s shipped 2026-05-25 — Pass 1 P1s and Pass 2 pending triage
---

# Strategic Vault Recommendations

**Scope.** Gap-finding and shape review, not a correctness re-audit. Correctness was covered by the 2026-05-16 and 2026-05-24 full sweeps; eight fixes shipped in PR #4. This pass asks a different question: **is the template the right shape for distribution to small creative/marketing studios (2-5 people)?**

**Method.** Five parallel sub-agent investigations: fresh-clone walkthrough (Harper), multi-user safety (Axel), roster gap/bloat (Ryan), skill/command coverage (Ellis), distribution blindspots (Drew). Synthesized at Checkpoint A by Odin.

**Output structure.** Two passes, not one: (1) **distribution-safety patch** — fix before any new clone goes out; (2) **v2 roster + skills refactor** — strategic shape change. Each finding carries owner (single DRI), effort, checkpoint-eligibility, and a "verify on fresh clone" check.

**Effort legend.** S = ≤ half-day, ≤ 1 PR. M = 1-2 sessions, single PR. L = multi-PR or cross-persona.

---

## Cross-cutting themes

1. **Hardcoded studio identity** leaks into clones — Studio Quarantine footer (×2 files), Harper-as-author references, theme map coupling.
2. **Invisible external dependencies** — MCPs (Webflow, Figma, Higgsfield, Shopify), Gemini CLI extensions, Obsidian, external GitHub skill repos. No inventory, no graceful degradation.
3. **Roster sized for 20-person agency**, cloned by 2-5 person teams. No minimum-viable-roster guidance.
4. **State files tracked that should be per-clone** — `MEMORY.md` concurrent writes, onboarding flags, theme locks, prior audit logs.
5. **Documentation drift vs reality** — skills README has 8 phantom entries, Vault structure docs miss 4 folders, `Resources/Git/INDEX.md` empty but treated as mandatory.

---

# Pass 1 — Distribution-Safety Patch

**Goal:** no new clone should leave the maintainer's machine until P0 items close.

**P0 status (2026-05-25):** all five closed. P0.4 collapsed into P0.3 after recon confirmed grill-me is vault-local at `.claude/skills/grill-me/` — the bug was README drift, not install. P0.1 protocol designed at Checkpoint A by Odin, implemented in CLAUDE.md + `.claude/commands/memory-reconcile.md` + `Resources/SOPs/Memory Protocol SOP.md`.

## P0 — distribution-blocking

### P0.1 — `MEMORY.md` concurrent-write protocol
**Diagnosis.** CLAUDE.md mandates "every team member writes mid-task." Parallel sub-agents in one session overwrite each other; two users across machines guarantee a git merge conflict on the file the SessionStart hook loads as prompt context. Conflict markers inject malformed prompts.
**Recommendation.** Two-stage:
1. Document in CLAUDE.md that concurrent multi-user writes are unsupported pending the protocol below.
2. Define per-session temp file pattern (`Vault/Memory/Sessions/<timestamp>-<persona>.md`), reconciled to `MEMORY.md` at session close.
**DRI.** Axel. Contributor: Sam (CLAUDE.md update). **Checkpoint-eligible: yes.**
**Effort.** M.
**Verify.** Two simultaneous Claude Code sessions writing memory; no conflict markers in `MEMORY.md` after both close.

### P0.2 — `Studio Quarantine` footer hardcoded
**Diagnosis.** `Resources/Build Standards/html-deliverable-standards.md` and `.claude/skills/html-deliverable/SKILL.md` both ship `Produced by Studio Quarantine · <date>` verbatim. QA-passed HTML deliverables stamp the wrong studio name on cloning team's client work.
**Recommendation.** Add `STUDIO_NAME` to `Vault/Memory/theme-name-map.md` (single source of truth, already loaded at session start). Replace both hardcodes with template substitution. Add to onboard flow: prompt for studio name at first run, write to map.
**DRI.** Tate. **Checkpoint-eligible: no** (mechanical).
**Effort.** S.
**Verify.** Generate an HTML companion on fresh clone with `STUDIO_NAME="Acme"`; footer shows "Acme".

### P0.3 — `.claude/skills/README.md` drift
**Diagnosis.** Lists 19 skills; 14 exist. 8 phantom entries (`executing-plans`, `finishing-a-development-branch`, etc.), 3 real skills missing (`handoff`, `html-deliverable`, `prototype`), 1 name mismatch (`writing-skills` vs `write-a-skill`). README is ground truth for new operators; they will reach for skills that don't exist.
**Recommendation.** Reconcile README against `ls .claude/skills/` output. Make this a pre-commit hook check.
**DRI.** Ellis. **Checkpoint-eligible: no.**
**Effort.** S.
**Verify.** `diff <(ls .claude/skills/) <(grep -oE '^- [a-z-]+' .claude/skills/README.md)` is empty.

### P0.4 — `grill-me` referenced but not installed
**Diagnosis.** CLAUDE.md line 15: "For any non-trivial or actionable request, run the `grill-me` skill first." `grill-me` is not in onboard.md Step 3.55 plugin install list. First substantive task on fresh clone fails. Note: grill-me IS present on this vault — check whether it ships via `superpowers` plugin or is vault-local. If vault-local, ensure it's in the template; if external, add to onboard installer.
**Recommendation.** Confirm source, ensure install path on fresh clone. If unfixable, remove the CLAUDE.md mandate and replace with optional invocation.
**DRI.** Sam. **Checkpoint-eligible: no** (investigation + small mechanical fix).
**Effort.** M (S investigate + S-to-M fix depending on source).
**Verify.** Two branches:
- (a) If installer fix lands: fresh clone, first non-trivial prompt, `grill-me` activates without error.
- (b) If mandate removed: CLAUDE.md no longer requires `grill-me`; default routing proceeds without it.

### P0.5 — Per-clone state tracked in git
**Diagnosis.** `Vault/Memory/onboarding-flags.json`, `Vault/Memory/onboarding-errors.md`, `Vault/Memory/.theme-lock` not in `.gitignore`. User A's flags push to remote; User B clones with flags pre-set and skips real onboarding. Stale lock from mid-op commit halts all subsequent theme operations.
**Recommendation.** Add to `.gitignore`:
```
Vault/Memory/onboarding-flags.json
Vault/Memory/onboarding-errors.md
Vault/Memory/.theme-lock
Vault/Memory/theme-name-map-*.md
Vault/Memory/Sessions/
```
Also consider: tracked `audit_2026-05-16_full-sweep.md` and `audit_2026-05-24_full-sweep.md` are maintainer-vault history; either annotate as template history or move to `Vault/Archive/`.
**DRI.** Axel. **Checkpoint-eligible: no.**
**Effort.** S.
**Verify.** Fresh clone, run onboarding, `git status` shows no tracked changes from those paths.

## P1 — high-friction

### P1.1 — MCP / external-tool dependencies invisible
**Diagnosis.** Casey hardcodes Webflow MCP URL; Cleo requires `gemini-2.5-flash-image` + `/nano-banana` Gemini CLI extension; Nova names Runway/Kling/Sora/Pika/After Effects as production tools; Figma/Higgsfield/Shopify MCPs assumed by other personas. No "persona not applicable" path. Template ships no inventory.
**Recommendation.** Two artifacts:
1. `Resources/Onboarding/dependencies.md` — table: tool, persona, required/optional, where to get, fallback when missing.
2. Top-of-persona "Runtime requirements" callout for affected personas (Casey, Cleo, Nova, Jordan).
**DRI.** Drew. Contributor: Harper (persona callouts). **Checkpoint-eligible: yes** (durable inventory artifact).
**Effort.** M.
**Verify.** Fresh clone with no MCPs configured — affected personas state their dependency at first invocation rather than failing silently.

### P1.2 — Onboarding fragility cluster
**Diagnosis.** Three issues compound:
- `$CLAUDE_PROJECT_DIR` undefined on fresh Unix clones; `open "${CLAUDE_PROJECT_DIR}/Resources/Learn/index.html"` fails silently.
- SessionStart hook silent failure has no install.sh fallback message ("run `/onboard` manually").
- README has two equally weighted entry points (`team-onboarding-guide.md` vs `SETUP.md`); new users don't know which to read first.
**Recommendation.**
- Use `pwd`-based path in onboard.md Step 5, or test for `$CLAUDE_PROJECT_DIR` and fail loud with instruction.
- Add "If you didn't see the onboarding flow, run `/onboard`" to install.sh tail output.
- Privilege `team-onboarding-guide.md` in README; demote `SETUP.md` to "for maintainers/ops."
**DRI.** Harper. **Checkpoint-eligible: no.**
**Effort.** M total (3× S sub-fixes).
**Verify (per sub-issue):**
- (a) `$CLAUDE_PROJECT_DIR`: fresh clone on macOS — Step 5 opens `Resources/Learn/index.html` without env shim.
- (b) SessionStart fallback: simulate hook failure — install.sh tail prints "run `/onboard` manually".
- (c) README entry points: README has one prominent first-touch link; SETUP.md demoted to maintainers section.

### P1.3 — Two Theme SOPs with incompatible concurrency models
**Diagnosis.** `Theme Setup SOP.md` requires `.theme-lock`; `Theme-Swap SOP.md` doesn't mention it. Both tracked, both look authoritative. Two users on different branches follow different SOPs.
**Recommendation.** Designate one authoritative (recommend Theme-Swap SOP — simpler, script-based). Mark the other "superseded by X" with a redirect. Or merge into one.
**DRI.** Sam. **Checkpoint-eligible: yes** (hard-to-unwind interpretation).
**Effort.** S.
**Verify.** Search for "theme" SOPs returns one canonical document.

### P1.4 — Roster too large for distribution audience
**Diagnosis.** 24 personas optimized for 20-person studio; cloning teams are 2-5. Cognitive load on routing (Reid vs Kai vs Ryan; Sage vs Remi vs Vera) creates errors before work begins. No "minimum viable roster" guidance.
**Recommendation.** Defer concrete cuts to Pass 2 (P2.1). For Pass 1: add `Resources/Onboarding/minimum-viable-roster.md` — a checklist of 8-10 essential personas with "delete the rest if your team is under 5" instruction. Keeps full roster available; reduces decision paralysis.
**Sequencing.** P1.4 ships the MVR doc (lightweight guidance). P2.1 enacts the cuts (strategic reshape). Do not block P1.4 on P2.1.
**DRI.** Harper. **Checkpoint-eligible: no** (advisory doc, not roster change). Note: Ryan owned the original investigation but would be self-deprecating as a cut target — DRI reassigned to Harper.
**Effort.** S.
**Verify.** Fresh-clone walkthrough by a 3-person team reports they knew which personas mattered within 5 minutes.

### P1.5 — `Resources/Git/INDEX.md` empty but mandatory
**Diagnosis.** CLAUDE.md: "Before checkpoint-eligible work, consult relevant repos in `Resources/Git/` via `Resources/Git/INDEX.md`." Index is empty by design. Repo Consultation SOP has no "skip if empty" clause. Day-one behavior: silent skip or halt.
**Recommendation.** Add explicit empty-state clause to INDEX.md ("On a fresh clone this is empty by design — repo consultation is a no-op until you populate. See Repo Setup SOP"). Mirror that clause in CLAUDE.md.
**DRI.** Sam. **Checkpoint-eligible: no.**
**Effort.** S.
**Verify.** Empty INDEX.md doesn't halt checkpoint-eligible work; Orchestrator narrates skip.

---

# Pass 2 — v2 Roster + Skills Refactor

**Goal:** strategic shape change. Run after Pass 1 ships.

## P2 — quality-degrading

### P2.1 — Target roster: 14-16 personas

Before/after sketch:

**Cut / merge:**
- Senior Researcher (Ryan) — fold brief-writing into HR Lead; meta-role doesn't fire in production.
- Market Research Specialist (Reid) + Competitive Intelligence Specialist (Kai) → merge to **Market & Competitive Intelligence Analyst**.
- Brand Strategist (Remi) + Creative Director (Vera) → merge to **Creative Director (with brand authority)**.
- Mobile Developer (Milo) → fold into broader **Developer** role; web + light backend + mobile-as-capability.
- Email Developer (Rory) → consider folding into Developer or keeping if email is a primary studio output.

**Add:**
- **Account/Client Manager** — owns client-facing comms, status updates, scope negotiation paper trail, presentation. Closes the weekly gap left by PM Handoff SOP.
- **Lifecycle Marketing Operator** (optional, if studio runs nurture programs) — owns email sequences, retention triggers, lifecycle segmentation. Connects Luca/Sage/Rory.

**Defer:**
- Finance/Billing — out of scope for marketing template v2.

Net: 24 → ~16.
**Dependency.** Follows P1.4 (MVR doc). MVR ships first; P2.1 turns guidance into structural change.
**DRI.** Harper (with Sam approval per Orchestrator-Only Operations — roster changes are meta-ops). **Checkpoint-eligible: yes** (durable, hard-to-unwind).
**Effort.** L (multi-PR).
**Verify.** Fresh clone, new operator names correct persona for a sample brief within one read of the roster.

### P2.2 — Persona skill scaffolding
**Diagnosis.** Only Casey (Webflow Developer) has explicit "Skills I reach for" section. Other technical personas rely on `using-superpowers` 1% heuristic. SEO Specialist (Alex) has zero skill references — most skill-naked production persona.
**Recommendation.** Adopt Casey's pattern across all technical personas. Three bullets minimum per persona: named skills with one-line trigger. Build missing skills first (see P2.3).
**DRI.** Ellis. **Checkpoint-eligible: no** (pattern application).
**Effort.** M.
**Verify.** Routing "@{SEOSpecialist} audit my site" — Alex narrates the skill she's reaching for.

### P2.3 — Missing skill packages
**Diagnosis.** Repeated patterns in SOPs/personas warrant SKILL.md packaging:
- `advisor-checkpoint` — every checkpoint-eligible persona reimplements the Odin narration inline.
- `repo-consultation` — Repo Consultation SOP describes a 3-repo-max pattern with no skill.
- `seo-audit` — Alex's first reach should be a structured intake.
- `qa-gate-review` — Quinn runs PASS/FLAGGED/BLOCKED verdict inline.
- `project-folder-setup` — Project Folder SOP creation steps unscripted.
**DRI.** Ellis. **Checkpoint-eligible: yes** (5 durable artifacts).
**Effort.** L (5 skills × M each).
**Verify.** Each skill passes write-a-skill rubric and surfaces via natural-language triggers on fresh clone.

### P2.4 — Vault structure documentation gap
**Diagnosis.** CLAUDE.md lists `Vault/Archive/`, `Logs/`, `Memory/`, `Templates/`. Actual `Vault/` adds `Attachments/`, `Bases/`, `Categories/`, `Scripts/`. Three of those are Obsidian artifacts (unstated dependency); `Scripts/` is genuinely undocumented.
**Recommendation.** Either document the four extras in CLAUDE.md + Vault/README.md, OR strip Obsidian-only folders from template seed and note Obsidian as optional companion.
**DRI.** Sam. **Checkpoint-eligible: no.**
**Effort.** S.
**Verify.** Vault structure docs and `ls Vault/` match.

### P2.5 — `.env.example` documentation
**Diagnosis.** Variable names with no context — `GOOGLE_API_KEY`, `GOOGLE_CLIENT_ID`, etc. No indication of what each unlocks, where to get it, or whether required vs optional.
**Recommendation.** Inline-comment each variable: 1 line "what it unlocks", 1 line "where to get it", 1 line "required/optional".
**DRI.** Drew. **Checkpoint-eligible: no.**
**Effort.** S.
**Verify.** Fresh-clone operator can complete `.env` without out-of-band help.

### P2.6 — `sync-theme.sh` executable bit + relative path
**Diagnosis.** `Vault/Scripts/sync-theme.sh` mode 644. `./sync-theme.sh` fails; only `bash sync-theme.sh` works. 2026-05-24 chmod sweep missed this. Separately: `.claude/settings.json` has relative `../../Shared Projects` path that breaks on teammate's machine.
**Recommendation.** Extend install.sh chmod sweep to cover `Vault/Scripts/*.sh`. Move `Shared Projects` path to `settings.local.json` (already gitignored) or document the required parent-directory layout.
**DRI.** Axel. **Checkpoint-eligible: no** (mechanical).
**Effort.** S.
**Verify.** Fresh clone — `./Vault/Scripts/sync-theme.sh` executable; `settings.json` portable.

## P3 — polish (defer or include with low cost)

- Tracked audit files confuse cloners — annotate as template history or move to `Vault/Archive/`.

Items previously listed here moved to "cut from scope" below to avoid duplication.

---

## Findings cut from scope (Odin)

1. Google Drive working-tree phantom files — environmental, not template defect.
2. Finance/Billing role — out of scope for marketing template v2.
3. Email standards ESP/font opinionation — feature, not bug.
4. `.env` duplicate creation — idempotent, cosmetic.
5. Persona Template SOP "Harper" reference — fixed automatically by P0.2.

---

## Acceptance criteria: fresh-clone test matrix

Pass 1 closes when all of these pass on a fresh clone in a clean directory by a new operator:

| # | Test | Pass condition |
|---|---|---|
| 1 | Clone, run install.sh, open Claude Code | Onboarding flow visible OR clear instruction to run `/onboard` |
| 2a | First non-trivial prompt to Sam (P0.4 branch a — installer fix) | `grill-me` activates without error |
| 2b | First non-trivial prompt to Sam (P0.4 branch b — mandate removed) | Default routing proceeds; no missing-skill error |
| 3 | `/onboard` Step 5 on macOS | `Resources/Learn/index.html` opens |
| 4 | `git status` after onboarding | No tracked changes from `Vault/Memory/onboarding-*` or `.theme-lock` |
| 5 | Generate HTML deliverable | Footer shows operator's studio name, not "Studio Quarantine" |
| 6 | Skim `.claude/skills/README.md` | Every listed skill exists on disk |
| 7 | "@{WebflowDeveloper} build a hero section" without Webflow MCP | Casey states dependency rather than failing silently |
| 8 | "@{SEOSpecialist} audit my site" | Alex narrates structured intake (post-P2.2/P2.3) |
| 9 | Read CLAUDE.md from a 3-person team's perspective | Roster-size guidance exists (`minimum-viable-roster.md`) |
| 10 | Search "theme" SOPs | One authoritative document |

---

## Next steps after this doc

1. Walk findings with maintainer.
2. Triage: which P0/P1 ship in next PR batch.
3. Decide whether Pass 2 (v2 roster/skills) is a one-shot refactor or a 4-week project.
4. Owner assignment confirmed; PM (Tate) tracks Pass 1 through delivery.
