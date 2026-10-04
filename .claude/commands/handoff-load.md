---
description: "Resumes a session from a handoff saved by /handoff-save."
argument-hint: "[handoff file path | slug fragment] (empty = newest)"
---

# /handoff-load

You are the running assistant. This command resumes a session from a handoff saved by `/handoff-save`, either on this machine or on another one synced via Google Drive. It is the read-side counterpart to `/handoff-save`.

## Rules
- The query comes from the command arguments (`$ARGUMENTS`). Empty is valid — it means "resume the newest handoff."
- Resolution always prefers precision over guessing: an explicit arg beats recency, `INDEX.md` beats a raw directory listing, and more than one live slug match means asking the user to disambiguate rather than silently picking one.
- **Superseded entries.** An index entry is superseded when a later (lower) line in `INDEX.md` ends with a `[supersedes: <stem>(, <stem>)*]` marker naming its file stem (link target minus `YYYY/` and `.md`, e.g. `2026-10-04-193822-test-pickup`). Only that exact bracketed marker, as the last text on the line, counts; free-text "supersedes" wording is ignored. A marker naming its own line's stem, or a stem not in the index, is ignored. An entry that is not superseded is *live*. To name an entry's replacer, follow the chain to the newest live entry ("replaced by B, itself replaced by C").
- Never fabricate a resolution. If nothing is found, say so and fall back to the manual path-paste instruction.
- Read the resolved handoff file directly into context (`Read` tool) — do not summarise it first. Handoff files are written by `/handoff-save` to be self-contained and consumed whole.
- This command only looks at `Vault/Logs/Handoffs/` (the vault-synced index). It does not look at the vendored upstream `handoff` skill's OS temp-dir saves — those are local-machine-only by design and are not cross-machine reachable, which is the exact problem this command exists to solve. If the user is looking for a temp-dir save, say that's out of scope for this command.
- A handoff records what was true at save time, not what is true now. Factual premises go stale while a handoff sits — version numbers, PR/merge state, file contents, "pending" actions. See step 5's re-test requirement before acting on any of them.

## Steps

1. **Path argument.** First strip one pair of surrounding quotes (`"` or `'`) from `$ARGUMENTS`, if present. Unquoted paths with spaces work as-is, because `$ARGUMENTS` is the raw remainder. Does it look like a path (ends in `.md`, or contains `/` or `\`)?
   - **No** → go to step 2.
   - **Yes** → normalise separators (`\` ↔ `/`). Resolve a relative path against the vault root; accept an absolute path as given. This step needs no index, so it works on any machine.
     - **File exists under `Vault/Logs/Handoffs/`** → go to step 5 with that path. If `INDEX.md` exists and marks this file's stem as superseded (see Rules), add a `Superseded by:` line to the result naming the replacer; it still loads. No `INDEX.md` → skip this check silently.
     - **File exists outside `Vault/Logs/Handoffs/`** → refuse plainly: this command only reads that folder (see Rules). Stop.
     - **File missing** → say so plainly: likely Drive sync lag, so wait and paste the path again later. Stop. Do not fall through to slug matching.

2. **Check for the index.** Does `Vault/Logs/Handoffs/INDEX.md` exist?
   - **Yes** → go to step 3.
   - **No** → go to step 4 (fallback).

3. **Index-driven resolution.**
   - **`$ARGUMENTS` is non-empty**: treat it as a slug-fragment query. Parse each `INDEX.md` line for its slug (the text between the last `-HHMMSS-` and `.md)` in the link target). Match `$ARGUMENTS` against slugs case-insensitively: first try substring match, then fall back to word-boundary token match if no substring hit. Then drop superseded entries from the matches (see Rules).
     - **All matches were superseded** → name each one and the live entry that replaced it, and ask the user which to load. Stop until they answer.
     - **Some matches were superseded** → print one line listing the skipped entries, then apply the one-match or multiple-match case below to the live matches.
     - **No entry matched at all** (before the superseded drop) → state plainly that nothing matched, list the 5 most recent live index entries (date, slug, status, pickup hint) as alternatives, and stop. Do not guess.
     - **One match** → go to step 5 with that entry's file path.
     - **Multiple matches** → list all matches (date, slug, status, pickup hint) and ask the user which one they mean. Do not auto-pick "newest" — ambiguity gets a question, not a guess.
   - **`$ARGUMENTS` is empty**: resolve to the last line of `INDEX.md` (entries are append-only, so newest = last — corrections are appended as new lines with a `[supersedes: …]` marker rather than edited in place, so this holds even after a correction). Go to step 5 with that entry's file path.

4. **Fallback — no index (fresh machine, or Drive sync hasn't caught up yet).**
   - Run something equivalent to `ls -t Vault/Logs/Handoffs/*/*.md` and exclude `INDEX.md` itself from the results.
   - **Directory missing, or no dated handoff files found** → tell the user: "No handoffs found on this machine. If you saved one on another machine, paste the absolute file path here and I'll read it." Stop.
   - **Files found** → apply the same arg/no-arg logic as step 3, but matching against filenames (which carry the same `YYYY-MM-DD-HHMMSS-slug.md` shape) instead of index lines — you won't have `status`/pickup-hint metadata in this path, only date and slug, and no supersedes markers, so nothing is skipped. Go to step 5.

5. **Read and resume.** `Read` the resolved handoff file's full contents. Confirm to the user: the absolute file path you loaded, its `status`, and its `## Next Concrete Action` section verbatim. Before acting on any carried backlog item or the Next Concrete Action itself, re-test its factual premise against the live tree/system — a version check, a PR-state lookup, a file read; whatever one command settles it. A premise that fails re-test closes or reshapes the item: report the discrepancy and the live state instead of acting on the stale claim. (Pattern precedent: two items carried across handoffs in 08/2026 were stale at pickup — one superseded ~30 days earlier, one already satisfied.) Then continue the session from that action.

## Result Format

```
Resumed handoff: [absolute file path]
Status: [status from frontmatter]
Superseded by: [newest live replacer — only when loaded by path and the index marks this file superseded]

Next Concrete Action:
[verbatim contents of that section]
```

If disambiguating (multiple matches, or all matches superseded) or reporting nothing found, use plain prose instead — no fixed template needed for those cases.
