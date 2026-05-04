# /log-session

You are the Orchestrator. This command writes a session log for the current conversation.

## Rules
- The Orchestrator owns all session log writes. Never delegate this task.
- Save log to: `Vault/Logs/Sessions/YYYY/YYYY-MM-DD-HHMM-[slug].md` where slug is a 2–4 word kebab-case summary of the session's primary request.
- Append one index entry to `Vault/Logs/Sessions/INDEX.md` (create file if missing).
- Use actual current date/time. Estimate duration from conversation length.
- If no @{SeniorAdviser} checkpoints occurred, write "none".

## Steps

1. Review the full conversation to extract: user's intent, personas invoked, @{SeniorAdviser} checkpoints, artifacts created/modified, outcomes, open loops.
2. Write the log file using the template below.
3. Append the index entry.
4. Confirm to the user with the file path.

## Log Template

```markdown
---
date: YYYY-MM-DD
time: HH:MM
duration: ~Xmin
personas: [Name, Name, ...]
checkpoints: N
artifacts:
  - path/to/file
---

## Request
[1–2 sentence summary of the user's intent]

## Routing Trace
[the Orchestrator's handoffs in order — e.g. "{Orchestrator} → {SeniorResearcher} (research) → {HRLead} (persona draft) → {Orchestrator} (announce)"]

## @{SeniorAdviser} Checkpoints
[List each invocation: "Checkpoint A — [topic] — ruling: [summary]" or "none"]

## Artifacts
[List absolute paths of all files created or modified this session]

## Outcomes
[What was delivered — be specific]

## Open Loops & Follow-ups
[Anything unresolved, deferred, or flagged for next session. "None" if clean.]
```

## Index Entry Format

Append to `Vault/Logs/Sessions/INDEX.md`:

```
- [YYYY-MM-DD HH:MM — slug](YYYY/YYYY-MM-DD-HHMM-slug.md) — [one-line outcome summary]
```
