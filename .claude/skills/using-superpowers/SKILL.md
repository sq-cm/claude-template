---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<!--
Source: https://github.com/obra/superpowers (superpowers plugin). Synced at upstream
v6.1.1 on 2026-07-06 (PR #133, straight replace). Vault adaptation (plan 025):
routing table unprefixed the `superpowers:`-scoped brainstorming route to the installed
`brainstorming` skill, and replaced the systematic-debugging route (whose upstream
target is not installed here) with a non-referencing equivalent. Re-sync rule: carry
these adaptations over any future upstream replace.
Phase-5 audit shrink (W19/C2, 11/07/2026): removed the 1% mandate block, plan-mode
brainstorm line, the rationalisation table section, and the harness-adaptation section
+ references/; carry over any future upstream replace.
-->

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming and systematic-debugging are Superpowers' most common process skills, but the rule holds for any of them.

- "Let's build X" → brainstorming first, then implementation skills.
- "Fix this bug" → systematic root-cause investigation first (reproduce, isolate, then fix), then domain skills.

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior. Only skip skill workflows or instructions when your human partner has explicitly told you to.
