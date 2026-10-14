# writing-for-agents: upstream provenance and vault adaptations

Source: https://github.com/mattpocock/skills/tree/49dd158d1076134a641b33efb035946536778336/skills/productivity/writing-for-agents
(by Matt Pocock, MIT). Vendored @ 49dd158 (09/10/2026) on 15/10/2026 (plan 153). Blobs at the
pin: SKILL.md a37608daf6e835e767deecfb498facecaaba82ba, SKILL-MECHANICS.md
9cdbdb22aadc438755392216e75ad9a14cc9832e. Upstream added this skill as writing-great-skills in
bc4cf90 (17/06/2026) and renamed it in 1fc6573 (23/07/2026); its last change to either file is
3216582 (19/08/2026, em-dash sweep).

Plan 135 (24/09/2026) recorded writing-for-agents as "Not adopted". A user ruling of 14/10/2026
reversed that: it is vendored here as its own skill so it stays resyncable against upstream, and
the frozen write-a-skill points to it (write-a-skill/SKILL.md header, plan 153, 15/10/2026).

SKILL-MECHANICS.md is byte-identical to upstream. SKILL.md is byte-identical to upstream from
"Reference for writing any document" to the end. Vault adaptations, all to be carried over any
future upstream replace:
  1. Description: upstream's two sentences are kept word for word, and one negative routing
     clause is appended (house style, plan 127): "Not for scaffolding a new skill's folder,
     frontmatter and template; use write-a-skill." write-a-skill owns the creation process and
     points here for the writing.
  2. Provenance keys `adapted_from` and `upstream_commit` added to the frontmatter (plan 092
     convention), with a one-line comment in SKILL.md pointing at this file.
  3. Output Locale blockquote added before the upstream body (PR #142 wording, as in humaniser,
     html-deliverable and shotlist-html-companion). Upstream already spells minimise,
     optimisation and behaviour, so no upstream byte changes for locale.
Deliberately not adapted:
  - No Vault depth rule. Upstream's only dispatch mention (SKILL.md, § Steps and completion
    criteria: "a hand-off or a subagent dispatch") is an example of a context boundary, not an
    instruction to dispatch. Add the rule if a future upstream body tells the reader to dispatch.
  - Upstream's agents/openai.yaml (Codex picker metadata) is not vendored, the same precedent as
    handoff and wait-what.
Resync method: fetch both files at the new upstream SHA and prove each with
`git hash-object --no-filters`; replace SKILL-MECHANICS.md whole; in SKILL.md keep the vault head
(frontmatter, the UPSTREAM.md comment, the Output Locale blockquote) and replace everything from
"Reference for writing any document" down; reapply adaptations 1 to 3; move `upstream_commit`.
Read upstream's `.changeset/*.md` first: it is the cheapest summary of what changed.
