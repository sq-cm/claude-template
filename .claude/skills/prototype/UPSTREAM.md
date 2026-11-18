# prototype — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 19/11/2026 (plan 180) so it stops loading on every invocation; only comment delimiters were removed. In the moved text, "this header" means the comment block that sat at the top of `SKILL.md`; "below" and "this file" refer to `SKILL.md`. Read it before any resync.

## Moved 19/11/2026 (plan 180)

Source: https://github.com/mattpocock/skills/tree/main/skills/engineering/prototype (by Matt Pocock).
Re-pinned to upstream @ 49dd158 on 14/10/2026 (plan 150): no upstream change since c55ee46 (identical blob SHAs).
Synced with upstream @ c55ee46 on 24/09/2026 (plan 136), replacing the copy pinned at f304057
(12/05/2026). This resync adopts upstream's behaviour change (6bcbcb0, 17/07/2026): the LOGIC
branch builds a shareable single-file HTML demo instead of a TUI. `LOGIC.md` and `UI.md` are
byte-identical to upstream @ c55ee46. `SKILL.md` carries three vault adaptations, all to be carried
over any future upstream replace:
  1. Description: keeps the vault's trigger phrases and the plan 127 negative routing clauses
     (upstream shortened its description to neither); the logic-branch phrase names the HTML demo.
  2. Rule 6 (capture): upstream's throwaway-branch-plus-issue rule applies only in a code
     repository with its own git history. Vault projects keep the prototype in `02 Working/` and
     record the answer as a `project:` session note for /memory-reconcile; standalone work uses
     the chat `outputs/` or `Inbox/` destinations. The rule also tells readers how to read
     "throwaway branch" in LOGIC.md and UI.md, so those two files need no edits.
  3. UI-branch sub-bullet under "Pick a branch" (plan 137, 29/09/2026): with no style direction,
     variations avoid the bans in Resources/Build Standards/frontend-design-defaults.md; brand,
     design-system or house-style direction overrides it. UI branch only, not a shared rule.
The 13/08/2026 staleness warning is resolved by this resync. Upstream's `agents/openai.yaml`
(Codex config) is deliberately not vendored.
