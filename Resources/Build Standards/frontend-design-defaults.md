# Frontend Design Defaults

**Purpose:** Fallback bans for frontend and visual work that arrives with **no style direction**.

*Last updated: 29/09/2026*

---

## Precedence

This list is a fallback, not a style. Client brand guidelines, a project's declared design system, and the studio house style ([`html-deliverable`](../../.claude/skills/html-deliverable/SKILL.md) with its `studio-shell.css`, and [`shotlist-html-companion`](../../.claude/skills/shotlist-html-companion/SKILL.md)) always win. Where any of them sets a look, the list does not apply. The house shell's off-white `--paper` is exempt.

## Why specific bans

Without design direction, Claude Opus 5.5 falls back on a few default styles, and a general instruction such as "avoid a generic AI look" mostly swaps one default for another. Naming the exact patterns to avoid works better ([Prompting Claude Opus 5.5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5)).

## The list

When a brief gives no style direction, do not use:

1. A cream or off-white background.
2. Italic accent words in headlines.
3. Numbered "01/02/03" section labels.
4. Monospace labels.
5. Pill-shaped buttons.

Bans only say what not to do. If a brief carries any positive direction (a reference, a mood, a palette), pair the bans with it.

## Maintenance

- Cap: 10 items.
- Check which styles the first result used in place of the banned ones. If a result swaps a banned look for a new default you don't want, add that default.
- Changes route through @{Orchestrator}.
