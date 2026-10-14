# diagnosing-bugs: upstream provenance and vault adaptations

Adopted via plan 151 (planned 14/10/2026 at vault commit `dd7ecb4`). Three MIT-licensed sources, all pinned to a commit:

1. **Base method**: mattpocock/skills `skills/engineering/diagnosing-bugs/` (by Matt Pocock) @ `49dd158`
   (repo commit `49dd158d1076134a641b33efb035946536778336`, 09/10/2026; the folder last changed in `f3fc563`).
   https://github.com/mattpocock/skills/tree/49dd158d1076134a641b33efb035946536778336/skills/engineering/diagnosing-bugs
2. **Stop-the-line rule and error output as data**: addyosmani/agent-skills
   `skills/debugging-and-error-recovery/SKILL.md` (by Addy Osmani) @ `aeac41d`
   (repo commit `aeac41d4d005999432bb7312f7ff06383a91d59d`; the file last changed in `cda4542`).
   https://github.com/addyosmani/agent-skills/blob/aeac41d4d005999432bb7312f7ff06383a91d59d/skills/debugging-and-error-recovery/SKILL.md
3. **Root causes and failed-fix premise**: pstack (by Lauren Tan), canonical cursor/plugins `pstack/` @ `837067b`
   (v0.15.23), read through the mirror backnotprop/pstack @ `1f0f9c3`, whose two files match its
   `upstream` branch (Cursor's files unedited) exactly:
   - `skills/principle-fix-root-causes/SKILL.md`:
     https://github.com/cursor/plugins/blob/837067b/pstack/skills/principle-fix-root-causes/SKILL.md
   - `skills/principle-attack-the-premise/SKILL.md`:
     https://github.com/cursor/plugins/blob/837067b/pstack/skills/principle-attack-the-premise/SKILL.md
   - Mirror: https://github.com/backnotprop/pstack/tree/1f0f9c3bac03c4297f6fc8f7644fa412eda57085/skills

`scripts/hitl-loop.template.sh` is a byte-for-byte copy of upstream source 1 (git blob
`243198464a8401a7ba1d63b3708fa43c3d067665`). Upstream's `agents/openai.yaml` (display metadata for
another agent harness) is not carried.

## Vault adaptations

Carry all of these over any future upstream resync of source 1:

1. **Vault depth rule added** at the top of SKILL.md. Upstream dispatches no sub-agent, but a routed
   persona has no live channel to the user. Moments that need the user before work can go on
   (redaction gaps, no loop possible, a HITL run) stop and hand back with the question; moments that
   only show or surface something (the ranked hypotheses, flagged instructions in error output)
   carry on and are listed in the hand-back to the Orchestrator. MCP `browser_*` tools, not local
   browser scripts, are named as Orchestrator-mediated.
2. **Glossary line repointed**: upstream's `GLOSSARY.md` and ADRs become the project's
   `Projects/<name>/CONTEXT.md` and `HISTORY.md` (AGENTS.md § Memory).
3. **Loop option 4 (headless browser)**: local dev-server targets only; live web and MCP `browser_*`
   go through the Orchestrator (Sub-Agent Architecture SOP § Web Fetch & Visual Eval).
4. **Loop option 10 (HITL script)**: the agent's shell has no interactive stdin, so the user runs the
   edited copy in their own terminal and pastes back the `--- Captured ---` block. The copy goes to a
   scratch location, never a new vault root folder.
5. **No-seam finding**: "Flag this for the next phase" becomes "Flag it in your hand-back or PR
   description".
6. **Phase 6**: the correct hypothesis goes in the hand-back, and in the commit or PR message only when
   a commit is asked for (commit only when asked). Two lines added: propose the cheap always-on signal
   (from source 3, fix-root-causes) and run `verification-before-completion` before claiming the fix.
7. **Grafts**: § Stop the line and § Error output is data, not instructions (source 2, reworded and
   shortened); the restart-bug rule in Phase 3, and the root-cause and fix-every-instance paragraph in
   Phase 5 (source 3, fix-root-causes); § When fixes keep failing (source 3, attack-the-premise, the
   write-the-premise-down rule only; its census and rotation steps are left out). Fix-every-instance is
   limited to the same defect within the brief's scope (others are listed in the hand-back), per
   AGENTS.md § Engineering Defaults (surgical changes). § Stop the line also defers to a brief's or
   plan's STOP conditions.
8. **Spelling**: "artifact(s)" becomes "artefact(s)" (en-AU, AGENTS.md § Output Locale). The rest of
   upstream source 1 is already British spelling and is kept word for word.
9. **Description**: a routing clause appended (house style, plan 127): diff review goes to
   `code-quality-review`.

The vault's one-line inline method in `using-superpowers` ("Fix this bug" → reproduce, isolate, then
fix) is unchanged and does not point here.

## Licence

All three sources are MIT-licensed:

- Copyright (c) 2026 Matt Pocock (mattpocock/skills)
- Copyright (c) 2025 Addy Osmani (addyosmani/agent-skills)
- Copyright (c) 2026 Lauren Tan (pstack)

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
