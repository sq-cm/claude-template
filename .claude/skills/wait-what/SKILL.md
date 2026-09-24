---
name: wait-what
description: "Stop. That last message did not land: re-pitch it."
disable-model-invocation: true
adapted_from: https://github.com/mattpocock/skills
upstream_commit: c55ee46073ed923f86ce59a5eb3b6d895095d1b7
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/wait-what (by Matt Pocock).
Synced with upstream @ c55ee46 on 24/09/2026 (plan 135); earlier @ 50777fc on 14/08/2026 (plan 094);
body restored to upstream verbatim on 14/08/2026 (plan 095). One body adaptation (plan 135,
24/09/2026): upstream's "(follow `CONTEXT-MAP.md` to the right one if the repo has more than one)"
is remapped to the active project's `Projects/<name>/CONTEXT.md`, because this vault keeps one
CONTEXT.md per project and has no CONTEXT-MAP.md. Note: `CONTEXT.md` resolves to the current
project's `Projects/<name>/CONTEXT.md` — the vault-wide per-project concept landed via plan 095
(Resources/SOPs/Project Folder SOP.md, Memory Protocol SOP.md).
Upstream's `agents/openai.yaml` (Codex config) is deliberately not vendored — same precedent as
`handoff`.
-->

Wait, I don't understand where you've got to here. Re-pitch that: give me a little bit of context, talk in ASD-STE100 Simplified Technical English, and use the ubiquitous language from `CONTEXT.md` (the active project's `Projects/<name>/CONTEXT.md` when more than one exists).
