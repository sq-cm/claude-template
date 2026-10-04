---
description: "Saves a structured log of the current session: request, routing trace, artefacts, outcomes, open loops."
---

# /log-session

You are the Orchestrator. This command writes a session log for the current conversation.

## Rules
- The Orchestrator owns all session log writes. Never delegate this task.
- Save log to: `Vault/Logs/Sessions/YYYY/YYYY-MM-DD-HHMM-[slug].md` where slug is a 2–4 word kebab-case summary of the session's primary request.
- Append one index entry to `Vault/Logs/Sessions/INDEX.md` (create file if missing).
- Use actual current date/time. Session duration = now minus the session's first message timestamp (both in UTC). To find the session, take the newest-mtime capture file in `Vault/Logs/Sessions/Captures/<YYYY>/` (named `<date>-<session-id>.md`), read the session ID from its filename, and confirm its last `**User:**` block (read via `ctx_execute` with tail, never `Read`) matches this conversation; on a mismatch, estimate. Sources, in order:
  1. The transcript JSONL for that session ID: its first `timestamp` field. Read it with `ctx_execute` or jq, never `Read`. → `duration: Xmin`.
  2. The first `ts=` marker across that session's capture files (`.partN.md` included). It is written at Stop time (end of turn 1), so it undercounts. → `duration: ≥Xmin (capture span)`.
  3. Neither available → estimate from conversation length. → `duration: ~Xmin (estimate)`.
- If no @{SeniorAdviser} checkpoints occurred, write "none".

## Steps

1. Review the full conversation to extract: user's intent, personas invoked, @{SeniorAdviser} checkpoints, dispatch durations (each task result's usage `duration_ms`), artifacts created/modified, outcomes, open loops.
2. Write the log file using the template below.
3. Append the index entry.
4. Confirm to the user with the file path.

## Log Template

```markdown
---
date: YYYY-MM-DD
time: HH:MM
duration: Xmin
personas: [Name, Name, ...]
checkpoints: N
artifacts:
  - path/to/file
---

## Request
[1–2 sentence summary of the user's intent]

## Routing Trace
[the Orchestrator's handoffs in order — e.g. "{Orchestrator} → {SeniorResearcher} (research) → {HRLead} (persona draft) → {Orchestrator} (announce)"]

## Dispatch Durations
[One line per sub-agent dispatch: "Persona | task (a few words) | parallel group or — | N min", e.g. "Ellis | R12 print build | group A | 19 min". Run time = `duration_ms` from the task result's usage, rounded to whole minutes; under 30 seconds → "<1 min", not "0 min". Follow-up rounds to the same agent are separate lines. No reported duration → "n/a"; never guess. No dispatches → "none".]

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
