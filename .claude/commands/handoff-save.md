---
description: "Writes a forward-looking pickup brief to Vault/Logs/Handoffs/ for resuming work in a new session."
argument-hint: "[optional pickup note]"
---

# /handoff-save

You are the Orchestrator. Writes a forward-looking handoff brief so the conversation can be picked up in a new session, on this machine or another one. Same machine: in the desktop app, the save offers a resume card; one click opens a new session that loads this exact handoff. In Orca it asks whether to open that session for you in a new tab. Other machine: vault syncs via Google Drive, so files under `Vault/Logs/Handoffs/` are reachable from any synced machine; paste the printed `/handoff-load` line there.

Use `/log-session` for retrospective (what happened). Use `/handoff-save` for prospective pickup (what to do next).

`handoff-save` is a command at `.claude/commands/handoff-save.md`, distinct from the vendored upstream `handoff` skill, which saves to the OS temp directory and is local-machine-only, not reachable from another synced machine. This command writes to `Vault/Logs/Handoffs/` instead, precisely to solve that limitation. See `handoff-load.md` for the read-side disambiguation.

## Rules
- Orchestrator owns all handoff writes. Never delegate.
- Save to: `Vault/Logs/Handoffs/YYYY/YYYY-MM-DD-HHMMSS-[slug].md` — slug is 2–4 word kebab-case summary of what the next session must do. Seconds prevent collisions on rapid re-saves.
- Append one index entry to `Vault/Logs/Handoffs/INDEX.md` (create file if missing — heading: `# Handoffs Index`). Corrections or supersessions are appended as a new line — never edited or inserted in place — so newest-=-last stays true.
- **Supersedes marker.** When the new handoff fully replaces one or more earlier entries (nothing in the older entry still needs loading), end the index line with `[supersedes: <stem>]`, or `[supersedes: <stem>, <stem>]` for several. List every fully replaced entry. A stem is the older entry's link target minus `YYYY/` and `.md`, e.g. `2026-10-04-193822-test-pickup`. The marker must be the last text on the line. Partial replacement gets no marker: describe it in the pickup hint instead. `/handoff-load` reads only this exact marker and ignores free-text "supersedes" wording.
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
5. Confirm to user with absolute file path. On first successful save, remind once how to pick up: click the resume card's dropdown and choose "Start locally" (same machine, desktop app), answer yes to "Open a new session to continue?" (same machine, Orca), or paste the printed `/handoff-load` line in a new session on the other machine.
6. **Offer a resume session.** Always, card or no card, first print the paste line: `/handoff-load <path relative to the vault root>`. Cards get dismissed, and the relative form works on another synced machine. Then:

   **Desktop app — resume card.** If `mcp__ccd_session__spawn_task` isn't loaded (it may be deferred, listed by name only), run one `ToolSearch` with `select:mcp__ccd_session__spawn_task`. Once loaded, call it once with:
   - `title`: `Resume handoff: <slug>` — keep under 60 characters; truncate the slug to fit.
   - `prompt`: `/handoff-load <absolute path to the saved handoff file>` (absolute, because the card only runs on this machine).
   - `tldr`: two plain sentences: the first names the handoff's Next Concrete Action; the second is exactly "Pick Start locally from the dropdown."

   Why "Start locally": "Start with worktree" (the default) opens a fresh git worktree without the vault's git-ignored local memory and handoff logs.

   Card offered → stop here; no Orca launch. Call fails → skip. Never retry, and never fail the save over it.

   **Orca — ask, then open a tab.** Tool still absent after the `ToolSearch`, and `TERM_PROGRAM=Orca` with `ORCA_TERMINAL_HANDLE` set → ask one yes/no question (AskUserQuestion): "Open a new session to continue?" No or no answer → stop. Any other host → no question, no launch; the paste line is already printed.

   Yes → run the launch with the Bash tool. Fill in:
   - `<claude>`: absolute path from `command -v claude`; on Windows convert with `cygpath -m` (forward slashes; it returns the `.exe` path). Not found → say so in one line, skip. New tabs may not have `~/.local/bin` on PATH, so never launch a bare `claude`.
   - `<rel>`: the saved file's path relative to the vault root, forward slashes.
   - `<orca>`: `$ORCA_CLI_COMMAND` if set, else `orca`.
   - `<slug>`: the handoff's slug.

   Opens a new tab named `Resume: <slug>` and switches to it (`--focus`). `orca terminal create` opens the tab in the current worktree, so the new tab starts in the vault root (tested), there is no `cd`, and the relative path resolves. Quote `<claude>` inside `--command` only if it contains spaces. The `MSYS_NO_PATHCONV=1` prefix stops Git Bash on Windows rewriting the `/handoff-load …` argument into a file path; it is harmless elsewhere.
   ```bash
   MSYS_NO_PATHCONV=1 <orca> terminal create --title "Resume: <slug>" --focus --command '<claude> "/handoff-load <rel>"' --json
   ```

   Launch fails (non-zero exit, an error, or a JSON `"surface"` other than `"visible"`, meaning the session runs but no tab shows) → say so in one line, skip. Never retry, and never fail the save over it. The Bash permission prompt for the launch is expected.
7. **Stop.** Once step 6 is done, end the turn, whichever path it took: card, Orca launch, no launch, or failure. Don't carry on with the conversation's task, start the handoff's Next Concrete Action, or take any further action; the work continues in the resumed session or wherever the paste line is run.

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

With the optional supersedes marker (full replacement only):

```
- [2026-10-04 21:05 — marker-test](2026/2026-10-04-210512-marker-test.md) — awaiting-input — confirm the load skips both test-pickup entries [supersedes: 2026-10-04-193822-test-pickup, 2026-10-04-201030-test-pickup]
```

## Resuming the Handoff

On first successful save, tell user once how to resume from "Next Concrete Action":
- **Same machine** — click the resume card's dropdown and choose "Start locally" (desktop app). In Orca, answer yes to "Open a new session to continue?" and it opens in a new tab. Any other terminal: paste the printed `/handoff-load` line into a new session.
- **Other machine** — paste the printed `/handoff-load <relative path>` line into a new session, or run `/handoff-load` for the newest (or `/handoff-load <slug-fragment>`).

If no index exists there yet (fresh machine, Drive sync hasn't caught up), `/handoff-load` falls back to a directory listing, and — as a last resort — paste the absolute file path into a new session and Claude will `Read` it directly.
