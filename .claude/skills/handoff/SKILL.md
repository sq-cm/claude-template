---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
adapted_from: https://github.com/mattpocock/skills
upstream_commit: 272f99b22574f50e4266791c86b9302682970e23
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff (by Matt Pocock).
Verbatim copy. Synced with upstream @ 272f99b on 2026-07-05.
-->

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS - not the current workspace.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
