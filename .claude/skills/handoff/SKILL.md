---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
adapted_from: https://github.com/mattpocock/skills
upstream_commit: c55ee46073ed923f86ce59a5eb3b6d895095d1b7
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff (by Matt Pocock).
Verbatim copy. Synced with upstream @ c55ee46 on 24/09/2026 (plan 135); previously 386d4ff (13/08/2026).
-->

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS - not the current workspace.

Include a "suggested skills" section in the document, naming which skills the next agent should call the Skill tool for.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
