---
description: "Writes a forward-looking pickup brief to Vault/Logs/Handoffs/ for resuming work in a new session."
argument-hint: "[optional pickup note]"
---

# /handoff-save

You are the Orchestrator. Writes a forward-looking handoff brief so the conversation can be picked up in a new session, on this machine or another one. Same machine: in the desktop app, the save offers a resume card; one click opens a new session that loads this exact handoff. Other machine: vault syncs via Google Drive, so files under `Vault/Logs/Handoffs/` are reachable from any synced machine; paste the printed `/handoff-load` line there.

Use `/log-session` for retrospective (what happened). Use `/handoff-save` for prospective pickup (what to do next).

`handoff-save` is a command at `.claude/commands/handoff-save.md`, distinct from the vendored upstream `handoff` skill, which saves to the OS temp directory and is local-machine-only, not reachable from another synced machine. This command writes to `Vault/Logs/Handoffs/` instead, precisely to solve that limitation. See `handoff-load.md` for the read-side disambiguation.

## Rules
- Orchestrator owns all handoff writes. Never delegate.
- Save to: `Vault/Logs/Handoffs/YYYY/YYYY-MM-DD-HHMMSS-[slug].md` — slug is 2–4 word kebab-case summary of what the next session must do. Seconds prevent collisions on rapid re-saves.
- Append one index entry to `Vault/Logs/Handoffs/INDEX.md` (create file if missing — heading: `# Handoffs Index`). Corrections or supersessions are appended as a new line — never edited or inserted in place — with a "supersedes [prior entry]" note in the entry text, so newest-=-last stays true.
- Use actual current date/time. Capture hostname and current git branch if available.
- If the user passes an argument, treat it as a **description of what the next session will focus on** and tailor the doc accordingly. Derive slug from it.
- Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.
- Redact sensitive info: API keys, passwords, PII, tokens, secrets.
- Include a **Suggested Skills** section pointing the next agent at skills it should invoke on pickup.

## Steps

1. Review current conversation. Extract: what was being done, what stopped it, single next concrete action, files open or mid-edit, unresolved questions.
2. Capture environment: hostname (`$env:COMPUTERNAME` Windows, `hostname` elsewhere), current git branch if in a repo, active plan file path if one exists.
3. Write handoff file using template below. Redact secrets. Reference — don't restate — existing artifacts.
4. Append index entry.
5. Confirm to user with absolute file path. On first successful save, remind once how to pick up: click the resume card (same machine, desktop app), or paste the printed `/handoff-load` line in a new session on the other machine.
6. **Offer the resume card.** If `mcp__ccd_session__spawn_task` isn't loaded (it may be deferred, listed by name only), run one `ToolSearch` with `select:mcp__ccd_session__spawn_task`. Once loaded, call it once with:
   - `title`: `Resume handoff: <slug>` — keep under 60 characters; truncate the slug to fit.
   - `prompt`: `/handoff-load <absolute path to the saved handoff file>` (absolute, because the card only runs on this machine).
   - `tldr`: one or two plain sentences naming the handoff's Next Concrete Action.

   Still absent after the `ToolSearch` (terminal CLI, other hosts) → skip. Call fails → skip. Never retry, and never fail the save over it.

   Always, card or no card, print the paste line: `/handoff-load <path relative to the vault root>`. Cards get dismissed, and the relative form works on another synced machine.

## Handoff Template

```markdown
---
date: YYYY-MM-DD
time: HH:MM
machine: [hostname]
project: [vault or repo name]
branch: [git branch, or "n/a"]
status: [in-progress | blocked | awaiting-input | phase-complete]
plan_file: [absolute path to active plan file, or "none"]
---

## Pickup Summary
[2–3 sentences: what this session was doing, where it stopped, why it's being handed off]

## Current State
[Concrete: files mid-edit, sub-agents that ran, what was last verified, what is in-flight vs done]

## Next Concrete Action
[Single next step. Specific enough to execute without re-deriving context. Name file, function, command.]

## Open Files / Artifacts
- [absolute path] — [why relevant]

## Referenced Artifacts
[PRDs, plans, ADRs, issues, commits, diffs — by path or URL. Do not restate their contents.]

## Open Questions / Blockers
[Awaiting user input, external resolution, or a decision. "None" if clean.]

## Suggested Skills
[Skills the next agent should invoke — e.g. `writing-plans`, `verify`, `code-review`. One line each with why.]

## Relevant Memory / Refs
[Pointers to Vault/Memory/ files, SOPs, prior session logs, repos in Resources/Git/ the picking-up session should read first]
```

## Index Entry Format

Append to `Vault/Logs/Handoffs/INDEX.md`:

```
- [YYYY-MM-DD HH:MM — slug](YYYY/YYYY-MM-DD-HHMMSS-slug.md) — [status] — [one-line pickup hint]
```

## Resuming the Handoff

On first successful save, tell user once how to resume from "Next Concrete Action":
- **Same machine** — click the resume card (desktop app only).
- **Other machine** — paste the printed `/handoff-load <relative path>` line into a new session, or run `/handoff-load` for the newest (or `/handoff-load <slug-fragment>`).

If no index exists there yet (fresh machine, Drive sync hasn't caught up), `/handoff-load` falls back to a directory listing, and — as a last resort — paste the absolute file path into a new session and Claude will `Read` it directly.
