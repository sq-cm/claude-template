---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, and to check for a relevant skill before responding, including before clarifying questions
---

<!-- Upstream provenance and vault adaptations: see UPSTREAM.md in this folder. Read it before any resync. -->

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

## The Rule

**Invoke a relevant or requested skill before you respond or act** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, track each item in your task list.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming is the most common process skill here, but the rule holds for any of them.

- "Let's build X" → brainstorming first, then implementation skills.
- "Fix this bug" → systematic root-cause investigation first (reproduce, isolate, then fix), then domain skills.

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior. Only skip skill workflows or instructions when your human partner has explicitly told you to.
