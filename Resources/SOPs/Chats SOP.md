# Chats SOP

The detail behind the [Chats](../../CLAUDE.md) section in CLAUDE.md. CLAUDE.md holds the operative rule (where chats live, how they are created, the commands, the Fast-Path destination change); this SOP holds the rationale, the `CHAT.md` anatomy, and the resolution rules. When the two disagree, **CLAUDE.md wins** — propose a fix here rather than diverging.

## Why chats exist

Between a project and a passing thought there was nothing. `Projects/` is heavy by design — propose-and-approve, README/CONTEXT/HISTORY, numbered subfolders, a QA Gate at the end. That weight is right for durable client work and absurd for an afternoon of poking at an idea. `Notes/` sits at the other extreme: flat, ungrouped, no log, nothing to resume from once the context is gone.

A chat is the middle. One folder per intentional conversation, one file that records where you got to, and somewhere for the files that fall out along the way. No project machinery, no approval step.

## Naming

```
Chats/[YYMMDD] [Chat Name]/
```

Example: `Chats/260901 Chat Workspaces Idea/` — folder creation date, then a short human name. Single format; no internal/client variants and no slug alternative.

`Chats/` is git-ignored the way `Projects/` is, with `Chats/README.md` as the one tracked file. Chat folders are local to a clone.

## CHAT.md anatomy

Each chat folder holds exactly one `CHAT.md`. `outputs/` is created lazily, on the first file that needs somewhere to live — no empty folders.

Frontmatter carries `date` and `status` (`active` | `dormant` | `closed`).

- `## Projects spawned` — one pointer line per project spawned from this chat. Often empty.
- `## Pickup` — Summary, Next concrete action, Open questions. **Rewritten in place** on every `/chat save`.
- `## Log` — one line per event, **append-only**.

Same overwrite-vs-append split as the project docs: Pickup is overwritten so it stays current, the Log is only added to so the sequence survives. Read Pickup to resume; read the Log when the "how did we get here" matters.

## Commands and resolution

One skill, `/chat` (`.claude/skills/chat/SKILL.md`):

- `/chat` — start a new chat. Lists existing chats first, as a reminder before you duplicate one.
- `/chat <name>` — resume by name fragment. An ambiguous fragment gets a question, never a guess.
- `/chat load` — resume the most recent chat.
- `/chat list` — list chats.
- `/chat save` — rewrite Pickup. Safe to clear the context afterwards.

**Keyword collision.** `list`, `load` and `save` are subcommands only when one of them is the entire argument. A chat named "Save The Date" still resumes via `/chat save the date`, because the argument is more than the bare keyword.

Chat folders are created only through `/chat` — never by hand, never automatically at session start, never as a side effect of other work.

## Active chat and the Fast-Path hookup

Any `/chat` invocation makes that chat active for the rest of the session. While one is active:

- Standalone Fast-Path file output lands in that chat's `outputs/` instead of `Notes/`.
- The lane's five-line eligibility verdict is appended to `CHAT.md § Log`, so the audit trail follows the work.

That is the entire hookup. It diverts chat-scoped standalone Fast-Path files while a chat is active and nothing else — in-project Fast-Path output still goes to `02 Working/`, and `Notes/` keeps every other staging role it has today. With no active chat, behaviour is unchanged.

## Spawning projects

A chat that turns into real work spawns a project through the normal [Project Folder SOP](Project%20Folder%20SOP.md) flow — propose, approve, create. There is no carve-out for ideas that started in a chat. The chat then keeps a pointer line under `## Projects spawned` and carries on; one chat can spawn several.

Chats never convert into projects and are never moved into `Projects/`. The chat is the conversation; the project is the work.

## Retention

Manual only. Set `status` to `dormant` or `closed` when a chat goes quiet, and archive the folder to `Vault/Archive/` when you want it out of the way. Nothing expires, nothing nags, nothing is removed on your behalf.

## What chats do not change

Destination only. `grill-me`, plan mode, Fast-Path eligibility and the QA Gate all fire exactly as they do today — a chat changes where a file lands, never whether the work was governed.

The memory protocol is untouched. `CHAT.md` is the chat's own history: chats write no session notes, are not folded by `/memory-reconcile`, and take no pointer line in `context.md`.
