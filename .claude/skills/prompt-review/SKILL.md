---
name: prompt-review
description: Reviews and improves a draft prompt against the vault's prompt formula cheat sheet (5 slots + a finish line). Use when the user asks to review, sharpen, score, or improve a prompt, or invokes /prompt-review. Explicit invocation tool — do not fire automatically on ordinary requests.
---

Read the cheat sheet at `${CLAUDE_PROJECT_DIR}/Resources/Learn/prompt-formula-cheat-sheet.md` before doing anything else. If the file is missing, or if either "The Formula: 5 Slots + a Finish Line" or "10-Second Pre-Send Checklist" can't be found in it, stop and report the problem. Never improvise the formula from memory.

Take the draft prompt from the invocation arguments. If none is supplied, ask for it — that's the one permitted question by default, and it does not count toward the 1–2 clarifying-question cap below.

This is a single-pass review, not an interview:

1. Diagnose the sheet's formula against the draft: the 5 slots plus the "Done when" finish line, one line each, with a verdict of ✓ present, ⚠ weak, or ✗ missing.
2. Run the sheet's 10-Second Pre-Send Checklist against the draft. Checklist findings fold into the slot diagnosis table by annotating the relevant slot line; where a finding doesn't map to a slot, let it inform the rewrite only. Either way, the checklist never adds a fourth output section.
3. Rewrite the prompt in the Fill-in-the-Blank Template's order.

Rewrite rules:

- Preserve the user's own wording wherever a slot is already filled. Fill gaps and tighten; never restyle what's already there.
- Use `[bracketed placeholders]` for facts only the user can supply — metrics, dates, file paths.
- Keep the user's language throughout.

Output exactly three parts, around 25 lines total:

1. The slot diagnosis table.
2. The improved prompt, in a blockquote, ready to re-send as-is.
3. One line starting "Biggest gap:" naming the single highest-impact fix.

Ask at most one or two clarifying questions, and only when a slot is so absent that the rewrite would be meaningless even with placeholders. Otherwise, don't interview — rewrite with placeholders and move on.

## Governance

This is an inline pre-routing utility, in the same class as grill-me: output is conversational only, never a Deliverable, and QA-exempt. It does not replace or suppress grill-me or Default Mode — a prompt reviewed here still goes through normal routing once the user re-sends it.
