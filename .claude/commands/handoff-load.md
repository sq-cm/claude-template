# /handoff-load

> **DRAFT — REVIEW-PENDING.** Written by Plan 038 (`Vault/Plans/038-handoff-load-design.md`) as a design deliverable, not yet wired into the shipped command set. The Orchestrator (or maintainer) decides whether this ships as-is, ships amended, or stays parked. Do not treat this file's presence as an endorsement to route `/handoff-load` traffic until that review happens.

You are the running assistant. This command resumes a session from a handoff saved by `/handoff-save`, either on this machine or on another one synced via Google Drive. It is the read-side counterpart to `/handoff-save`.

## Rules
- The query comes from the command arguments (`$ARGUMENTS`). Empty is valid — it means "resume the newest handoff."
- Resolution always prefers precision over guessing: an explicit arg beats recency, `INDEX.md` beats a raw directory listing, and more than one slug match means asking the user to disambiguate rather than silently picking one.
- Never fabricate a resolution. If nothing is found, say so and fall back to the manual path-paste instruction.
- Read the resolved handoff file directly into context (`Read` tool) — do not summarise it first. Handoff files are written by `/handoff-save` to be self-contained and consumed whole.
- This command only looks at `Vault/Logs/Handoffs/` (the vault-synced index). It does not look at the vendored upstream `handoff` skill's OS temp-dir saves — those are local-machine-only by design and are not cross-machine reachable, which is the exact problem this command exists to solve. If the user is looking for a temp-dir save, say that's out of scope for this command.

## Steps

1. **Check for the index.** Does `Vault/Logs/Handoffs/INDEX.md` exist?
   - **Yes** → go to step 2.
   - **No** → go to step 3 (fallback).

2. **Index-driven resolution.**
   - **`$ARGUMENTS` is non-empty**: treat it as a slug-fragment query. Parse each `INDEX.md` line for its slug (the text between the last `-HHMMSS-` and `.md)` in the link target). Match `$ARGUMENTS` against slugs case-insensitively: first try substring match, then fall back to word-boundary token match if no substring hit.
     - **Zero matches** → state plainly that nothing matched, list the 5 most recent index entries (date, slug, status, pickup hint) as alternatives, and stop. Do not guess.
     - **One match** → go to step 4 with that entry's file path.
     - **Multiple matches** → list all matches (date, slug, status, pickup hint) and ask the user which one they mean. Do not auto-pick "newest" — ambiguity gets a question, not a guess.
   - **`$ARGUMENTS` is empty**: resolve to the last line of `INDEX.md` (entries are append-only, so newest = last). Go to step 4 with that entry's file path.

3. **Fallback — no index (fresh machine, or Drive sync hasn't caught up yet).**
   - Run something equivalent to `ls -t Vault/Logs/Handoffs/*/*.md` and exclude `INDEX.md` itself from the results.
   - **Directory missing, or no dated handoff files found** → tell the user: "No handoffs found on this machine. If you saved one on another machine, paste the absolute file path here and I'll read it." Stop.
   - **Files found** → apply the same arg/no-arg logic as step 2, but matching against filenames (which carry the same `YYYY-MM-DD-HHMMSS-slug.md` shape) instead of index lines — you won't have `status`/pickup-hint metadata in this path, only date and slug. Go to step 4.

4. **Read and resume.** `Read` the resolved handoff file's full contents. Confirm to the user: the absolute file path you loaded, its `status`, and its `## Next Concrete Action` section verbatim. Then continue the session from that action.

## Result Format

```
Resumed handoff: [absolute file path]
Status: [status from frontmatter]

Next Concrete Action:
[verbatim contents of that section]
```

If disambiguating (multiple matches) or reporting nothing found, use plain prose instead — no fixed template needed for those cases.
