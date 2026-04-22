# SOP — Odin Fallback (Adviser Unavailable)

**Purpose:** Define team behaviour when an Odin checkpoint cannot complete — model unavailable, timeout, or empty response.  
**Audience:** All team members who invoke Odin at checkpoints.  
**Status:** Active. Owned by the Orchestrator.

---

## When this SOP applies

Invoke this fallback when an Odin checkpoint call:
- Returns an error (model overloaded, API timeout, invalid response)
- Returns a blank or clearly truncated response (< 3 enumerated items)
- Does not complete within a reasonable session window

---

## Fallback Procedure

### Step 1 — Retry once

Re-invoke the Odin agent call with identical prompt. If it succeeds, continue normal workflow. Log nothing.

### Step 2 — Self-review if retry fails

If the second call also fails, the calling persona performs a structured self-review in place of Odin:

1. Re-read the plan or deliverable as if seeing it for the first time
2. Answer these three questions explicitly in their response:
   - *What is the highest-risk assumption in this work?*
   - *What would break if that assumption is wrong?*
   - *Is there a simpler approach I haven't considered?*
3. If the answer to any question surfaces a real concern, address it before proceeding

### Step 3 — Flag the miss

After completing the self-review, the persona notes the fallback inline:

```
⚠️ Odin checkpoint [A|B] — adviser unavailable. Self-review substituted. Risk: [one-line summary].
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
- Tate's tracking obligations are unchanged

---

## Escalation

If Odin is unavailable for 3+ consecutive checkpoints across a session, surface this to the user before continuing further work. Model availability may be a broader issue requiring a session restart.
