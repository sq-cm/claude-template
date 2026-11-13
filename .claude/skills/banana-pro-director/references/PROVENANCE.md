# banana-pro-director — Provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 13/11/2026 (plan 177) so it stops loading on every invocation; only comment delimiters were removed. Read it before folding a future upstream drop.

## Moved 13/11/2026 (plan 177)

STUDIO-LOCAL BEGIN: upstream ships a bare H1 with no version block; this note records the studio's drop-2 fold, the routing split that narrows this skill's primary lane to scene and environment work, and the STUDIO-LOCAL marking convention used throughout this file.
> **Version:** Upstream drop 2 adopted 04/08/2026 onto the 3.0-merged base (diff-and-fold merge). This drop is routing-level only: character work (face locks, outfit refs, character sheets) now routes to the `character-builder` skill by default — this skill's primary lane narrows to scene/environment plates, GPT Image 2 detail stills, and outfit replacement. Modes 0–5 are all retained in full for legacy/explicit-request use. The studio-local headless 3-panel Seedance-handoff sheet (formerly a character-sheet variant here) and the wardrobe-test escalation chain have migrated to `character-builder` — see that skill for both. See the Mode 2 section below for what's retained here. **Marking convention:** every studio divergence from the upstream base is wrapped in a paired `STUDIO-LOCAL` begin/end HTML comment carrying a one-line justification, so a future upstream drop can be diffed mechanically; file-wide label and renumber sweeps are declared collectively in the `STUDIO-LOCAL SWEEPS` block immediately below rather than wrapped at every occurrence.
STUDIO-LOCAL END

STUDIO-LOCAL SWEEPS: file-wide studio deltas marked collectively here, because an inline wrapper on every occurrence would be unreadable. (a) Frontmatter — `name:` is `banana-pro-director`, not upstream's `banana-pro-director-30`, and `description:` is rewritten to the narrowed primary lane with character work routed to `character-builder`; YAML cannot carry HTML comments, so the divergence is declared here. The H1 title drops upstream's "3.0" version suffix for the same reason. (b) Tool labels — `GPT-2` → `GPT Image 2` and `Nano Banana` → `Nano Banana 2` at every site, matching Higgsfield's current product naming. (c) Character-sheet renumber — upstream already ships the 2A (3-panel) / 2B (6-panel) split natively, so no file-wide renumber applies; the studio corrects only the two residual sites where upstream still reads `Mode 2` for the 6-panel sheet — the **Canonical Mode 2B prompt structure** heading in the MODE 2B — 6-PANEL CHARACTER SHEET section, and the `Mode selected` row of the INVENTORY EXTRACTION CHECKLIST, where upstream's single `2 six-panel` entry is split into `2A three-panel sheet / 2B six-panel sheet`. (d) Flat-grade terminology aligned to this file's LOCKED FLAT GRADE heading in place of upstream's "lighting close". No upstream drop-3 content is adopted anywhere in this file — its sole change is the brand-policy inversion rejected in PR #261, marked at every site below.

STUDIO-LOCAL: FLAT-CLOSE DIVERGENCE FROM character-builder — UPSTREAM PARITY BY DESIGN, NOT DRIFT.
     Recorded 19/08/2026 at the close of the drop-3 adoption, so a future maintainer does not "align" the two files and silently import drop-3 content into this one.

     What is NOT divergent: film grain. This file's LOCKED FLAT GRADE has always closed on
     "Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated."
     at every character-mode site, and this file carries no grain prohibition anywhere. The drop-2
     `character-builder` install *did* ban grain on its flat plate while simultaneously requiring
     "matched grain" on its sheets — a live self-contradiction. Drop 3 resolved it by adopting
     upstream's close verbatim, grain included. So the drop-3 flip CLOSED a real grain divergence
     between the two skills rather than opening one; they now agree. Verified by inspection at
     adoption time. Do not re-open this question on drop 4.

     What IS divergent, and deliberately so: the wording of the flat close itself.
       - `character-builder` (drop-3 base) describes the background as a flat COLOUR FIELD — explicitly
         not a photographed backdrop, with no surface, no floor, no wall, no corner, no horizon and no
         plane the figure stands on or in front of — and adds a standalone zero-light-bleed clause.
       - This file describes an 18% neutral gray SEAMLESS and retains floor-referencing language
         ("no ambient occlusion on the floor beneath the feet").
     Both enforce the same policy: one uniform value corner to corner, shadowless illumination, zero
     shadow on the backdrop, matte skin, true colour, the 50mm/grain close. The wording differs only
     because this file deliberately adopted no drop-3 content and holds parity with its own upstream
     base for mechanical diffability, which is the entire reason its legacy character modes 0/1/2
     still exist. Do NOT reconcile the two texts. Each skill emits its own close verbatim; a future
     drop diffs this file against upstream banana, and `character-builder` against upstream
     character-builder, and both stay clean.

## Upstream-text edits 13/11/2026 (plan 177, prompt audit)

Edits to upstream-derived text in `SKILL.md`, each wrapped in its own STUDIO-LOCAL marker or logged here. Carry them over any resync:

- Step 0 scoped to character work; pure environment plates (Mode 3B) skip the "existing or new character?" question.
- The five-rule lock scoped to Mode 3 scene plates and the white-card still; character plates and sheets close with the LOCKED FLAT GRADE.
- The pre-prompt lighting bullets (six modes) and the Step 1B.1 note now describe the flat, shadowless grade the prompt actually closes with, not side-keyed light.
- `(CRITICAL)` emphasis tags dropped from three rule labels, and rule 8's "non-negotiable" becomes "required" with its close matched to the current Paragraph 5 camera-spec close.
