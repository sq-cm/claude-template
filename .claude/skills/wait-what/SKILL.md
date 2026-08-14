---
name: wait-what
description: Stop. That last message did not land — re-pitch it.
disable-model-invocation: true
adapted_from: https://github.com/mattpocock/skills
upstream_commit: 50777fcc0982d5867997a75a1e0731b9daac94eb
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/wait-what (by Matt Pocock).
Synced with upstream @ 50777fc on 14/08/2026 (plan 094). One vault adaptation, to be carried over
any future upstream replace:
  1. Upstream's closing clause reads "use the ubiquitous language from `CONTEXT.md`". This vault has
     no `CONTEXT.md`, so the clause is repointed to the current project's brief and `HISTORY.md`.
     If a vault-wide CONTEXT.md concept lands later, this clause is the carrier to update.
Upstream's `agents/openai.yaml` (Codex config) is deliberately not vendored — same precedent as
`handoff`.
-->

Wait — I don't understand where you've got to here. Re-pitch that: give me a little bit of context, talk in ASD-STE100 Simplified Technical English, and use the established vocabulary of the current project (its brief and `HISTORY.md`).
