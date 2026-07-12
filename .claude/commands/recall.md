# /recall

You are the running assistant. This command recalls prior conversation content from `Vault/Logs/Sessions/` — both the raw per-turn capture logs and the curated `/log-session` summaries that live in the same directory.

## Rules
- The query comes from the command arguments (`$ARGUMENTS`). If empty, ask the user in one line what to recall — do not guess.
- Recall is keyword-fuzzy (BM25 + stemming + trigram fusion via `ctx_search`), not true semantic search. Say so if a plainly-relevant memory seems to be missing, and suggest the user retry with literal terms likely to appear in the original wording.
- Never `Read` or `cat` the raw log files into context. Rely only on `ctx_search` snippets.
- Do not fabricate a recall. If nothing relevant returns, say so plainly.
- `ctx_search`'s `project` param defaults to the current project (auto-resolved) — a second clone in a different directory is naturally scoped apart. Do not pass `project: "global"`; that would bleed other projects' logs into recall.

## Steps

0. **Empty-state check.** If `Vault/Logs/Sessions/` doesn't exist, or exists but contains no `.md` files, respond "no session logs captured yet — nothing to recall" and stop. Don't call `ctx_index`/`ctx_search` against an empty directory.
1. **Index-on-demand.** Call `ctx_index` with `path` = the absolute path to `Vault/Logs/Sessions` under `CLAUDE_PROJECT_DIR` (recursive walk, default), `source: "session-logs"`, `exclude: ["INDEX.md"]` (keeps the link-list index out of results), and `maxFiles: 2000` set explicitly (the walk's default cap is 200 — this raises it to avoid silent truncation on a growing corpus). This is idempotent — files unchanged since the last index are skipped via content hash — so it's safe to run on every `/recall` call. If the corpus approaches the 2000-file cap, switch to per-year indexing instead — `path` = the specific `<YYYY>` subdir.
2. **Search.** Call `ctx_search` with `queries: [<the user's query>]`, `source: "session-logs"`, `limit: 5`, `sort: relevance`. If the user's phrasing suggests they want a chronological span across past sessions ("when did we...", "over time", "history of...") instead use `sort: timeline`.
3. **Present cited results.** For each hit, surface the citation as follows:
   - If the snippet carries a `<!-- capture: turn=<N> ... session=<session-id> -->` marker (raw capture blocks only), cite session ID, turn number, and timestamp.
   - If the marker is absent (curated `/log-session` entries, or any block without it), cite the source file path and heading from `ctx_search`'s own result metadata instead. Never fabricate a turn number or session ID when the marker isn't there.
   Format each result so the user can see what was said, when, and where it came from.
4. **No hits.** If `ctx_search` returns nothing relevant, state plainly that recall found nothing for this query — do not invent an answer from general knowledge.
5. **Honesty note.** Close with a one-line reminder that this is keyword-fuzzy recall, not semantic search, if the result set looks thin or off-target.

## Result Format

```
Recall: "<query>"

1. [session <id>, turn <N>, <timestamp>]  — raw capture
   "<snippet>"

2. [Vault/Logs/Sessions/2026/2026-07-10-1420-slug.md — Outcomes]  — curated log
   "<snippet>"

...
```
