# /handoff-save

You are the Orchestrator. This command writes a forward-looking handoff brief so the conversation can be picked up on another machine. The Vault syncs via Google Drive, so files under `Vault/Logs/Handoffs/` are reachable from any synced machine.

Use `/log-session` for retrospective (what happened). Use `/handoff-save` for prospective pickup (what to do next).

## Rules
- The Orchestrator owns all handoff writes. Never delegate this task.
- Save to: `Vault/Logs/Handoffs/YYYY/YYYY-MM-DD-HHMMSS-[slug].md` where slug is a 2–4 word kebab-case summary of what the next session must do. Seconds in filename prevent collisions on rapid re-saves.
- Append one index entry to `Vault/Logs/Handoffs/INDEX.md` (create file if missing — heading: `# Handoffs Index`).
- Use actual current date/time. Capture hostname and current git branch if available.
- If the user passes an argument after the command, treat it as the slug override.

## Steps

1. Review the current conversation. Extract: what was being done, what stopped it (interruption, completion of a phase, end of day), what the single next concrete action is, which files are open or mid-edit, any unresolved questions.
2. Capture environment: hostname (`$env:COMPUTERNAME` on Windows, `hostname` elsewhere), current git branch if inside a repo, active plan file path if one exists.
3. Write the handoff file using the template below.
4. Append the index entry.
5. Confirm to the user with the absolute file path. Remind them: on the other machine, paste the path into a new session to resume.

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
[The single next step. Specific enough to execute without re-deriving context. Name the file, the function, the command.]

## Open Files / Artifacts
- [absolute path] — [why it's open or relevant]

## Open Questions / Blockers
[Anything awaiting user input, external resolution, or a decision. "None" if clean.]

## Relevant Memory / Refs
[Pointers to Vault/Memory/ files, SOPs, prior session logs, or repos in Resources/Git/ the picking-up session should read first]
```

## Index Entry Format

Append to `Vault/Logs/Handoffs/INDEX.md`:

```
- [YYYY-MM-DD HH:MM — slug](YYYY/YYYY-MM-DD-HHMMSS-slug.md) — [status] — [one-line pickup hint]
```

## Resume on the Other Machine

Tell the user once on first successful save: in a new session on the other machine, paste the absolute file path. Claude will `Read` it and continue from "Next Concrete Action".
