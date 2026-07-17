# /handoff-save

You are the Orchestrator. Writes a forward-looking handoff brief so the conversation can be picked up on another machine. Vault syncs via Google Drive, so files under `Vault/Logs/Handoffs/` are reachable from any synced machine.

Use `/log-session` for retrospective (what happened). Use `/handoff-save` for prospective pickup (what to do next).

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
5. Confirm to user with absolute file path. On first successful save, remind: run `/handoff-load` (or `/handoff-load <slug-fragment>`) in a new session on the other machine to resume.

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

## Resume on the Other Machine

On first successful save, tell user once: run `/handoff-load` (or `/handoff-load <slug-fragment>`) in a new session on the other machine to resume from "Next Concrete Action". If no index exists there yet (fresh machine, Drive sync hasn't caught up), `/handoff-load` falls back to a directory listing, and — as a last resort — paste the absolute file path into a new session and Claude will `Read` it directly.
