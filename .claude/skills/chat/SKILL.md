---
name: chat
description: Start, resume, list, or save a per-conversation chat workspace under Chats/ — a dated folder holding a CHAT.md running log, plus an outputs/ directory created lazily the first time a file is actually produced. Handles /chat (start new), /chat <name> (resume by name), /chat load (resume the most recent), /chat list (one line per chat), and /chat save (rewrite the pickup brief before clearing context). Use when the user invokes /chat. Explicit invocation tool — do not fire automatically on ordinary requests.
disable-model-invocation: true
argument-hint: "list | load | save | <chat name> | (empty = start new)"
---

A chat is a lightweight workspace for one line of thinking: a folder at `Chats/[YYMMDD] [Chat Name]/`
holding a `CHAT.md` and — created lazily, only once a file is genuinely produced — an `outputs/`
directory. A chat with no files yet has no `outputs/` folder, and that is correct. It is not a
project and never becomes one — a chat that grows into real work spawns a project through the normal
propose-and-approve flow and keeps a pointer line in `CHAT.md`.

The rules live in [Chats SOP](../../../Resources/SOPs/Chats%20SOP.md) — that document wins on any drift.

## 1. Resolve the argument

`list`, `load`, and `save` are subcommands **only when one of them is the entire argument**. Anything
longer is a name fragment — `/chat load testing` resumes a chat matching "load testing", it does not
run `load`. Empty argument means start a new chat. Any other argument is a resume-by-name.

## 2. Start new — `/chat`

If `Chats/` already holds chat folders, list them first, one line each (name + status), and ask once
whether to create a new chat or resume an existing one. This is an anti-duplicate reminder, not a
gate — ask once, then act on the answer.

On create: take a short chat name from the user, or derive one from the request and confirm it in the
same breath. Create `Chats/[YYMMDD] [Chat Name]/CHAT.md` from the template below. Do **not** create
`outputs/` — it is made lazily, the first time a file actually lands. Mark the chat active for this
session.

## 3. Resume by name — `/chat <name>`

Match the fragment case-insensitively against folder names: substring first, then word-boundary token
match if no substring hits.

- **Zero matches** → say so plainly, list the 5 most recent chats, stop. Do not guess.
- **Multiple matches** → list them (name, status, last modified) and ask which. Never auto-pick newest.
- **One match** → proceed.

`Read` the resolved `CHAT.md` **whole** into context — never summarise it first. Confirm back: the
absolute path, the `status`, and the `## Pickup` section verbatim. A pickup records what was true at
save time; re-test any stale factual premise in it (file state, PR state, version numbers) before
acting on it. Then mark the chat active.

## 4. Resume most recent — `/chat load`

Resolve to the chat whose `CHAT.md` has the newest modification time (`ls -t` equivalent). If `Chats/`
is missing or empty, say so and stop. Same read-whole, confirm, and re-test rules as step 3.

## 5. List — `/chat list`

One line per chat: name, status, last-modified date. Read frontmatter only — do not pull whole
`CHAT.md` files into context for a listing.

## 6. Save — `/chat save`

No active chat → say so, point the user at `/chat load` or `/chat <name>`, and stop. Do not guess a
target and do not create one.

Otherwise, rewrite the `## Pickup` section of the active chat's `CHAT.md` **in place**. Never append a second
Pickup — there is exactly one, and it is always current. Fields:

- **Summary** — 2–3 sentences on where things stand.
- **Next concrete action** — one specific, executable step.
- **Open questions** — what is still undecided.

Then append a one-line entry to `## Log` noting the save, and tell the user it is now safe to clear
context and that `/chat load` brings them back.

## While a chat is active

A chat stays active from invocation until the session ends. While it is:

- Standalone Fast-Path file output lands in the chat's `outputs/`, not `Notes/`, and the five-line
  eligibility verdict is appended to `CHAT.md § Log`. In-project work is unaffected — it still goes
  to that project's `02 Working/`.
- Log entries are appended as work happens: what was asked, what was decided, what was produced,
  with file paths.

Everything else is unchanged. This is a destination feature only — grill-me, plan mode, Fast-Path
eligibility, and the QA Gate all behave exactly as they do without a chat.

## CHAT.md template

Frontmatter `date` is ISO; dates in prose are DD/MM/YYYY per the vault's AU locale. `status` is one
of `active`, `dormant`, or `closed`.

```markdown
---
date: YYYY-MM-DD
status: active
---

# [Chat Name]

## Projects spawned
<!-- Pointer lines to Projects/ folders this chat spawned. "None yet." until one exists. -->
None yet.

## Pickup
<!-- Rewritten in place on every /chat save — never appended. -->
**Summary:** —
**Next concrete action:** —
**Open questions:** —

## Log
<!-- Append-only. One line per event: DD/MM/YYYY HH:MM — what was asked / decided / produced (file paths). -->
```
