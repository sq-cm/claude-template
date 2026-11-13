# hyperframes — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 13/11/2026 (plan 177) so it stops loading on every invocation; only comment delimiters were removed. Read it before any resync.

## Moved 13/11/2026 (plan 177)

Source: https://github.com/heygen-com/hyperframes (vendored). Frozen at upstream commit `8fcbb63`;
vendoring record: Vault/Memory/Notes/2026-07/2026-07-05-phase3-shortlist-execution.md (Odin
recommendation, adopted — do not re-litigate without demonstrated need).
Upstream restructured in 2026-07 (monolith split into modular skills; `skills/gsap` removed) and is
NO LONGER TRACKED — refresh attempts exceed the >60% rewrite threshold (plan 024, STOPPED).
Upstream-layout pointers in this skill (`packages/shader-transitions/`, `registry/blocks/`,
`skills/gsap`) describe the pre-restructure layout; `skills/gsap` no longer exists upstream. Runtime
surface is npm (`hyperframes`, `@hyperframes/shader-transitions`), verified publishing at v0.7.60,
2026-07-17.
Divergence annotated 17/07/2026 (plan 036).

## Upstream-text edits 13/11/2026 (plan 177, prompt audit)

Carry these over any resync:

- `SKILL.md` step 4 (exits): exits with `gsap.to()` only on the final scene or a single-scene composition; in multi-scene work the transition is the exit.
- `SKILL.md` GSAP closer: the pointer to upstream `skills/gsap` is replaced, because upstream removed that skill.
- `references/typography.md`: the four font rules lose their accusatory asides ("You do this constantly", "You will try to use 14px"); the rules themselves are unchanged.
