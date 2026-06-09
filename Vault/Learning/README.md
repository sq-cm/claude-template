# Learning

Personal learning workspaces produced by the **`/teach`** skill (`.claude/skills/teach/`).

## What lives here

One subfolder per topic — `Vault/Learning/<topic-slug>/` — each a self-contained teaching
workspace holding:

- `MISSION.md` — why you're learning this; grounds every lesson
- `lessons/*.html` — the lessons themselves (beautiful, self-contained, one idea each)
- `learning-records/*.md` — what you've demonstrably learned (ADR-style, steers future sessions)
- `reference/*.html` — cheat sheets and quick-reference docs distilled from lessons
- `RESOURCES.md` — curated trusted sources + communities
- `GLOSSARY.md` — canonical terms for the topic
- `NOTES.md` — your teaching preferences and working notes

## Git status

Everything under `Vault/Learning/` **except this README is git-ignored** — your learning data is
personal, stays on this clone, and is backed by your Google Drive sync. It is never pushed to the
template repo. (Ignore rule: `Vault/Learning/*` + `!Vault/Learning/README.md` in `.gitignore`.)

## Start learning

```
/teach <what you want to learn>
```

`/teach` runs inline as a personal tutor — it asks for your mission first, then builds lessons in
your zone of proximal development. It is exempt from the usual orchestrator routing, QA gate, and
PM tracking; its output is personal learning, not a client deliverable.
