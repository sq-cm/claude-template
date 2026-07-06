# SOP — Odin Fallback (Adviser Unavailable)

**Purpose:** Define team behaviour when an Advisor Checkpoint cannot complete — model unavailable, timeout, or empty response.
**Audience:** The Orchestrator, who dispatches @{SeniorAdviser} on a persona's behalf and owns the retry. The consulting persona still performs the self-review substitute when the adviser is unavailable.
**Status:** Active. Owned by the Orchestrator.

---

## When this SOP applies

Invoke this fallback when an Advisor Checkpoint call:
- Returns an error (model overloaded, API timeout, invalid response)
- Returns a blank or clearly truncated response (< 3 enumerated items)
- Does not complete within a reasonable session window

> **Not this fallback:** a deterministic `cannot be used as an advisor when the request model is '<model>'` error is a *config* failure, not a transient outage — retrying will fail identically. It means the `advisorModel` setting (user-level) is weaker than the gatekeeper's request model. Odin and Quinn run on `claude-opus-4-8` (gatekeeper tier), which pairs with the default advisor — at shipped defaults this error cannot occur. It appears only when a clone has promoted the gatekeepers above the advisor tier without raising `advisorModel` to match (see Advisor Checkpoints SOP § pairing). Do not substitute self-review for it — correct the setting and re-dispatch.

---

## Fallback Procedure

### Step 1 — Retry once

The Orchestrator re-invokes the @{SeniorAdviser} agent call with identical prompt. If it succeeds, continue normal workflow. Log nothing.

### Step 2 — Self-review if retry fails

If the Orchestrator's second call also fails, the Orchestrator reports the adviser unavailable to the consulting persona, which then performs a structured self-review in place of @{SeniorAdviser}:

1. Re-read the plan or deliverable as if seeing it for the first time
2. Answer these three questions explicitly in their response:
   - *What is the highest-risk assumption in this work?*
   - *What would break if that assumption is wrong?*
   - *Is there a simpler approach I haven't considered?*
3. If the answer to any question surfaces a real concern, address it before proceeding

### Step 3 — Flag the miss

After completing the self-review, the persona notes the fallback inline:

```
⚠️ Advisor Checkpoint [A|B] — adviser unavailable. Self-review substituted. Risk: [one-line summary].
```

### Step 4 — Log to memory

Append an entry to `Vault/Memory/odin-misses.md` (create if absent):

```
| Date | Persona | Checkpoint | Reason | Self-review risk noted |
```

---

## What does NOT change

- The task still proceeds — fallback is not a blocker
- Checkpoint B (before declaring done) still requires the self-review even if Checkpoint A was also a miss
- @{ProjectManager}'s tracking obligations are unchanged

---

## Escalation

If @{SeniorAdviser} is unavailable for 3+ consecutive checkpoints across a session, surface this to the user before continuing further work. Model availability may be a broader issue requiring a session restart.
