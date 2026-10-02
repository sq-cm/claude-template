# humaniser: upstream provenance and vault adaptations

Source: https://github.com/blader/humanizer (MIT), whose patterns are drawn from Wikipedia's
"Signs of AI writing", maintained by WikiProject AI Cleanup.
Resynced from upstream v3.0.0 @ 9862685 to v3.1.0 @ 225a6f3 on 29/09/2026 (plan 138).
v3.1.0 has 26 patterns in six families A to F; the new F Writing for the wrong reader adds §26
for replies that re-explain what the reader already knows. §1 to §25 keep their numbers.
Base-flipped from upstream v2.11.1 @ ebf637b to v3.0.0 @ 9862685 on 24/09/2026 (plan 133).
v3.0.0 is an upstream rewrite: 35 patterns became 25, grouped into five families (A Staging,
B Rhythm by rule, C Inflation and borrowed authority, D Formatting by rule, E Leftovers) and
ordered strongest first, so every pattern number changed. Nothing tracked in the vault outside
SKILL.md cites a pattern number, heading or anchor (git grep at 9053884). The pre-flip file
differed from ebf637b only by adaptations 1 to 5 and the previous provenance comment, which
this one supersedes, so nothing vault-authored was lost in the flip. Vault adaptations, all to
be carried over on any future resync:
  1. `name: humaniser` — AU spelling. Upstream is `humanizer`.
  2. Output Locale blockquote in SKILL.md (plan 029), asserting root AGENTS.md § Output Locale over
     SKILL.md's upstream US-English prose.
  3. `allowed-tools` re-added. Upstream has carried no such block since v2.11.1; without it the
     skill's tool grant silently changes and the tool-baseline audit drifts. `adapted_from` and
     `upstream_commit` are vault provenance keys and sit beside it.
  4. RETIRED 02/10/2026, plan 143, reason: restates the sample-matching sentence in the first
     `### Voice` paragraph; the plan 143 skill audit's voice-sample test showed the graft did no
     visible work. Do not re-graft. `### Voice` now matches upstream 225a6f3 byte for byte. Original note kept
     for history: `### Voice` is a merge, not upstream's subsection verbatim. Grafted from v2.8.2 between
     upstream's two paragraphs: the six-point sample-analysis checklist, the concrete matching
     guidance ("If they write short sentences..."), and `#### How to provide a sample`.
     Upstream's two paragraphs are byte-for-byte, and the first paragraph's
     sample-precedence sentence must survive every future merge. v2.11.1's pointer to "Add
     personality only when it fits" is retired:
     v3 carries that default voice guidance in its own second Voice paragraph.
  5. `## Full Example` (Lisbon) re-added verbatim from v2.8.2, before `## Source`. Upstream cut
     it in v2.11.0 and v3.0.0 did not restore it; it is the only end-to-end worked
     demonstration in SKILL.md. Its "Changes made" line names patterns by description, not by
     number, so renumbering upstream does not touch it. One edit since (02/10/2026, plan
     143): the final rewrite's fourth paragraph ended "…, not the castle.", a clipped not-X
     tail that showed the §1 tell; it now ends "That is the Lisbon I keep thinking about."
     Restore nothing else from v2.8.2 over it on a future resync.
  6. `metadata.version` adopted deliberately, not inherited by accident. Keeping upstream's own
     version field avoids a permanent phantom hunk in every diff-vs-upstream check.
  7. v2.8.2's long-form personality section is deliberately NOT re-added. v3.0.0 folds
     personality into the second paragraph of `### Voice` and keeps the same scoping guard
     (reference, technical, legal and factual text stays neutral). Do not restore it on a
     future resync.
  8. v2.11.1's "Filler phrases" pattern ("In order to" → "To", and five more) is deliberately
     NOT re-added. v3.0.0 cut it, and v3.1.0's §12 holds words that are tells wherever they
     appear, while phrase lists live in §13 to §18; a vault-local filler list would sit outside
     that scheme and carry a permanent hunk. Plain-English tightening belongs to the
     Copywriter's editorial pass, not to AI-tell removal.
  9. Absorbed upstream: the `§6`→`§8` dash-rule pointer in `### Voice` (plan 133) is no longer
     a vault adaptation. Upstream 225a6f3 already reads "dash rule in §8".
  Moot: `compatibility: any-agent` was removed from SKILL.md at an earlier sync. Upstream has
  no such key, so there is nothing left to drop and it is no longer an adaptation.
