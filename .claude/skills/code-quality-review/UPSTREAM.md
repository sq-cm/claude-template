# code-quality-review: upstream provenance and vault adaptations

This skill is a vault synthesis of three MIT-licensed upstreams, not a copy of any one of them.
Written 14/10/2026 (plan 149). A resync means re-reading each source below at its new commit and
re-applying every adaptation listed here. Never replace SKILL.md with any single upstream file.

## Sources

1. **mattpocock/skills** by Matt Pocock, read at repo commit `49dd158d1076134a641b33efb035946536778336` (09/10/2026).
   - `skills/engineering/code-review/SKILL.md`, last touched `3da8c01` (07/10/2026), blob `373a4f26e6cfa3617778397945bb069d9cb184bc`:
     https://github.com/mattpocock/skills/blob/49dd158d1076134a641b33efb035946536778336/skills/engineering/code-review/SKILL.md
   - Taken: separate axes reported side by side and never reranked across axes ("Why two axes");
     pin the fixed point and fail early on a bad ref or an empty diff; the spec-source search order;
     the standards-source search; the Fowler smell baseline as labelled judgment calls that a
     documented standard overrides; the three Spec questions (missing, not asked for, wrong).
2. **pstack** by Lauren Tan. Canonical home `cursor/plugins`, folder `pstack/`, at `837067b` (v0.15.23).
   Read through the mirror `backnotprop/pstack` at `1f0f9c3bac03c4297f6fc8f7644fa412eda57085`
   (13/10/2026), whose `main` is the canonical tree plus harness-neutral edits.
   - `skills/interrogate/SKILL.md`, mirror last touch `fce11a3`, blob `0148f158fe72239c3d88db7112b3cff7dc3cf954`:
     https://github.com/backnotprop/pstack/blob/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills/interrogate/SKILL.md
     (canonical: https://github.com/cursor/plugins/blob/837067b/pstack/skills/interrogate/SKILL.md)
   - `skills/interrogate/references/rubric.md`, mirror last touch `f3afb70`, blob `8dab195ab840554bfe5e74e9b5ca0d9edbe9b496`:
     https://github.com/backnotprop/pstack/blob/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills/interrogate/references/rubric.md
   - `skills/interrogate/references/lead-judgment.md`, mirror last touch `55bfdc2`, blob `5ce526097fdd3dfeaf4cd3b126a3f486c3ee36ae`:
     https://github.com/backnotprop/pstack/blob/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills/interrogate/references/lead-judgment.md
   - `skills/interrogate/references/reviewer-prompt.md`, mirror last touch `f3afb70`, blob `ef7bff3d77c35a0af2a9947187ccee15465657f4`:
     https://github.com/backnotprop/pstack/blob/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills/interrogate/references/reviewer-prompt.md
   - `skills/blast-radius/SKILL.md`, mirror last touch `4aed5af`, blob `b296cce0d746260a53c16e3671cb05bacfe82daf`:
     https://github.com/backnotprop/pstack/blob/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills/blast-radius/SKILL.md
   - Taken: state the intent before reviewing and judge the execution, not the intent; the rubric
     lenses (correctness including idempotency and concurrency, root causes against symptoms,
     structural integrity, verification, security with traced input paths); "trace the call chain"
     instead of "this could be nil"; the four buckets and the filtering principles of the lead
     judgment (Act on at most five, Dismissed as a trust mechanism, nitpick gravity, hypothetical
     against actual, "I would have done it differently", missing context); "an empty review is a
     valid outcome"; the blast-radius evidence ladder (said, pointed, walked, ran, reproduced) and
     its one load-bearing fact.
3. **addyosmani/agent-skills** by Addy Osmani, read at repo commit `aeac41d4d005999432bb7312f7ff06383a91d59d` (13/10/2026, v0.6.13).
   - `skills/code-review-and-quality/SKILL.md`, last touched `28f435e`, blob `08209ff2208d2883d48d945f7754c428b77f8d87`:
     https://github.com/addyosmani/agent-skills/blob/aeac41d4d005999432bb7312f7ff06383a91d59d/skills/code-review-and-quality/SKILL.md
   - `skills/constraint-driven-development/SKILL.md` § Step 6 "Guard the bar itself", last touched `cda4542`, blob `3028719c0bad95b3e439024b2f52255c0c9f1ffe`:
     https://github.com/addyosmani/agent-skills/blob/aeac41d4d005999432bb7312f7ff06383a91d59d/skills/constraint-driven-development/SKILL.md
   - Taken: the axis checklists for correctness and security; review the tests first; the
     invert-one-condition probe, restored from a copy; verify the verification; the Critical and
     Required labels; propose the move, not just the problem; the dependency-upgrade rules;
     honesty in review (no rubber stamp, no softening); the description clause "even when the
     diff is pasted inline"; the five moves that quietly lower the bar, and "tightening is silent,
     loosening is loud".

The two verbatim passages in SKILL.md § Panel mode (the read-only instruction and the anti-padding
line) are vault text, copied from `.claude/skills/improve/references/panel-mode.md` § 4. If they
change there, change them here.

## Vault adaptations (carry every one over any resync)

1. **Two run modes.** Single-reviewer mode runs inline and never dispatches. Panel mode is
   Orchestrator-only (AGENTS.md § Sub-Agent Depth and § Orchestrator-Only Operations). Upstream
   mattpocock always dispatches two sub-agents, and pstack interrogate dispatches one per model.
2. **Vault depth rule** block added near the top of SKILL.md, worded after `grill-me`'s.
3. **Variety from axes and personas, not models.** Dropped pstack's per-model reviewer table, its
   settings file and its `Task` and model-fallback instructions, and agent-skills' Multi-Model
   Review Pattern. Each persona's model is pinned in its own file.
4. **Over-engineering is routed to `code-minimalism-review`.** Dropped pstack's Complexity Budget
   lens and its `code-quality-review.md` lens (including "be ambitious" and "code judo", which
   clash with AGENTS.md § Engineering Defaults, Surgical changes), agent-skills' "fewer lines" and
   "abstractions earning their complexity" items and its Dead Code Hygiene section, and
   mattpocock's Speculative Generality and Middle Man smells.
5. **Five axes only.** Spec, Correctness, Security, Tests, Design risk. Performance counts only
   where it breaks behaviour. Dropped agent-skills' Change Sizing, Change Descriptions, Review
   Speed and Handling Disagreements sections: they govern the PR process, not the diff.
6. **Spec source repointed.** Upstream's issue tracker and `/setup-matt-pocock-skills` became the
   `Vault/Plans/` plan, the dispatch brief, and the project brief and `CONTEXT.md`.
7. **Standards sources repointed** to `Resources/Build Standards/`, AGENTS.md § Engineering
   Defaults and the project `CONTEXT.md`, plus a client repo's own contributing docs.
8. **Lists findings, applies nothing** (the `code-minimalism-review` house rule). The mutation probe
   is the only temporary edit, restored from a copy and checked with `cmp`. Throwaway proof scripts
   live outside the reviewed tree and are never committed. Both run in single-reviewer mode only:
   panel reviewers are read-only and share one tree, so they stop at rung 3 and mark a finding
   "probe recommended" (Checkpoint A, 14/10/2026). Dropped blast-radius's `arena`, `why`
   and `unslop` companions.
9. **One severity vocabulary.** agent-skills' labels are cut to `Critical` and `Required` inside
   Act on; its Optional and Consider map to Consider, and Nit and FYI map to Noted. pstack's
   reviewer severities (critical, warning, nit) are dropped.
10. **The Act on cap is per axis.** pstack caps Act on at five for the whole review; here the axes
    are never reranked against each other (mattpocock), so the cap applies within each axis.
11. **Evidence rungs are required per finding.** Act on needs rung 2 or higher; Critical needs
    rung 3 or higher or is marked "unproven".
12. **Bar-lowering list generalised.** `CONSTRAINTS.md` and its Exceptions table became any
    threshold, allowlist, exemption or carve-out. The suppression list gains `# noqa` and
    `shellcheck disable`, because the vault's own tooling is Bash and Python.
13. **Secrets:** name the location and the credential type, never the value.
14. **Negative routing clauses** in the description (plan 127 house style).
15. **Name.** `code-quality-review`, not upstream's `code-review`, which would clash with Claude
    Code's built-in `/code-review` skill.

## Licence

All three upstreams are released under the MIT License. Copyright notices:

- Copyright (c) 2026 Matt Pocock (mattpocock/skills)
- Copyright (c) 2026 Lauren Tan (pstack)
- Copyright (c) 2025 Addy Osmani (addyosmani/agent-skills)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
