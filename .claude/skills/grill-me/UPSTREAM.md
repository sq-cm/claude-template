# grill-me: upstream provenance and vault adaptations

Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling (by Matt Pocock).
Synced with upstream @ c55ee46 on 24/09/2026 (plan 135), and before that @ bfdaef8 on 13/08/2026
(plan 092), replacing the older copy pinned at e5932a7, which asked one question at a time. Vault
adaptations, all to be carried over any future upstream replace:
  1. Kept as a single skill named `grill-me`, and model-invocable. Upstream splits the engine
     into `grilling` and makes `grill-me` a thin `disable-model-invocation` wrapper; that split
     would break AGENTS.md § Default Mode, which auto-fires this skill at intake. Never add a
     `disable-model-invocation` key to SKILL.md's frontmatter.
  2. Description merges upstream's scope with this vault's explicit trigger phrase, which is a
     more reliable match target than upstream's "any 'grill' trigger phrases".
  3. Vault depth rule added in SKILL.md. Upstream's fact-finding paragraph tells the reader to
     dispatch a sub-agent; only the Orchestrator may do that here.
  4. Negative routing clauses appended to the description (plan 127): ideation goes to
     brainstorming, the step list that follows comes from plan mode (AGENTS.md § Default Mode),
     not from this skill.
