# Chats

Lightweight per-conversation workspaces — one folder per intentional conversation, sitting between a full project and a loose note.

## What goes here

- One folder per conversation you decided was worth keeping
- `CHAT.md` — frontmatter (`date`, `status`), `## Projects spawned` pointers, `## Pickup` (rewritten each save), `## Log` (append-only)
- `outputs/` — created on the first file that needs somewhere to live, not before

## Naming convention

```
[YYMMDD] [Chat Name]/
```

Example: `260901 Chat Workspaces Idea/` — folder creation date, then a short human name.

## Structure

Flat. Chat folders are siblings; there are no subfolders beyond each chat's own `outputs/`.

## Notes

- Chat folders are created only via `/chat` — never by hand, never automatically
- Git-ignored and local to your clone, like `Projects/`; this README is the only tracked file here
- Chats never become projects — they spawn them through the normal approval flow and keep a pointer line
- Full rules: [Chats SOP](../Resources/SOPs/Chats%20SOP.md)
