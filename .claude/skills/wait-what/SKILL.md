---
name: wait-what
description: "Stop. That last message did not land: re-pitch it."
disable-model-invocation: true
adapted_from: https://github.com/mattpocock/skills
upstream_commit: 49dd158d1076134a641b33efb035946536778336
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/wait-what (by Matt Pocock).
Synced with upstream @ 49dd158 on 14/10/2026 (plan 150); earlier @ c55ee46 on 24/09/2026 (plan 135)
and @ 50777fc on 14/08/2026 (plan 094); body restored to upstream verbatim on 14/08/2026 (plan 095).
One body adaptation (plan 135, 24/09/2026; updated by plan 150): upstream's last sentence ends
"`GLOSSARY.md` (follow `GLOSSARY-MAP.md` to the right one if the repo has more than one)"; ours
ends "`CONTEXT.md` (the active project's `Projects/<name>/CONTEXT.md` when more than one exists)",
because this vault keeps one CONTEXT.md per project and has no glossary or map file. Upstream
renamed its CONTEXT.md/CONTEXT-MAP.md convention to GLOSSARY.md/GLOSSARY-MAP.md in d80fa0f
(merged 24/09/2026 via e484a80). Our file name matched upstream's old one by coincidence, so
upstream's GLOSSARY wording is covered by this adaptation, not drift. Note: `CONTEXT.md` resolves
to the current project's `Projects/<name>/CONTEXT.md` — the vault-wide per-project concept landed
via plan 095 (Resources/SOPs/Project Folder SOP.md, Memory Protocol SOP.md).
Upstream's `agents/openai.yaml` (Codex config) is deliberately not vendored — same precedent as
`handoff`.
-->

Wait, I don't understand where you've got to here. Re-pitch that: give me a little bit of context, talk in ASD-STE100 Simplified Technical English, and use the ubiquitous language from `CONTEXT.md` (the active project's `Projects/<name>/CONTEXT.md` when more than one exists).
