---
name: mempalace-mine
description: Use when ingesting project files, conversation exports, or any data source into the MemPalace memory system.
---

# MemPalace Mine

## 1. Ask what to mine

Clarify:
- Is it a project directory (code, docs, notes)?
- Is it conversation exports (Claude, ChatGPT, Slack)?
- Do they want auto-classification (decisions, milestones, problems)?

## 2. Choose the mining mode

**Project mining:**

    PYTHONUTF8=1 python -m mempalace mine <dir>

**Conversation mining:**

    PYTHONUTF8=1 python -m mempalace mine <dir> --mode convos

**Auto-classify (decisions, milestones, problems):**

    PYTHONUTF8=1 python -m mempalace mine <dir> --mode convos --extract general

## 3. Optionally split mega-files first

If source directory contains very large files:

    PYTHONUTF8=1 python -m mempalace split <dir> --dry-run

Use `--dry-run` first to preview without changes.

## 4. Optionally tag with a wing

    PYTHONUTF8=1 python -m mempalace mine <dir> --wing <name>

## 5. Show progress and results

Summarize: items mined, classifications applied, warnings or skipped files.

## 6. Suggest next steps

- /mempalace:search — query newly mined content
- /mempalace:status — check palace state
- Mine more data from additional sources
