# SOP — Folder-Tier CLAUDE.md

**Purpose:** Define when a rule belongs in a folder-level `CLAUDE.md` rather than the root file, how these files load, and how they're governed.
**Audience:** The Orchestrator (owns all folder-tier files), all working personas (read-path recipients).
**Status:** Active. Owned by the Orchestrator.

---

## Purpose

A folder-tier `CLAUDE.md` is a lazy-loaded enforcement backstop scoped to one folder. It costs nothing in a session that never touches the folder, and attaches automatically the moment a file inside it is read — no manual lookup, no reliance on memory.

## Placement test

Ask where the rule is true, then place it at the narrowest tier that still covers every case:

- True everywhere → user-level `CLAUDE.md` (`~/.claude/CLAUDE.md`)
- True for this project, not universally → root `CLAUDE.md`
- True for one folder only → folder-tier `CLAUDE.md` in that folder

## Load semantics

Empirically verified 06/07/2026 (findings summarised in full below):

- **Not injected at session start.** Zero per-session cost while the folder is untouched.
- **Injected on Read.** The first Read of any file in the folder attaches the folder's `CLAUDE.md` to that tool result — in the main session and identically for a dispatched sub-agent on its own Read.
- **Write of a new file and Edit do not trigger injection directly.** But Edit requires a prior Read in the same conversation, and that Read fires the injection — so the normal edit path is still covered.
- **`.claude/` does not inject.** Verified 06/07/2026 via two separate Reads of files in `.claude/agents/` in the same session: no injection occurred at either Read. Confirmed for `.claude/`; other dotfolders are untested.

**Consequence:** folder-tier files are read-path backstops. A rule that gates a decision made *before* the folder is touched (routing, QA Gate trigger, Fast-Path eligibility) or that must hold on a blind write-only path stays in root `CLAUDE.md`. Folder-tier files carry rules the acting persona needs at the point they're already looking at a file in that folder.

## Canonical list

Folders shipping a `CLAUDE.md` today:

- `Resources/SOPs/`
- `.claude/agents/` — **documentation-only.** Dotfolders don't lazily inject, so this file never loads as an enforcement backstop; it ships as a convention marker only. The persona-governance rules it restates are actually carried by root `CLAUDE.md` and the Persona Template SOP.
- `Vault/Memory/`
- `03 Deliverables/` in every project folder (ships with `Projects/Template/`)

## Governance

Folder-tier `CLAUDE.md` files are **Orchestrator-only edit surfaces**, identical protection to root `CLAUDE.md`. No persona edits one directly — a persona that spots a needed change surfaces it to @{Orchestrator}.

## Content rules

- Keep each file to roughly **15 lines**.
- Every folder file cites its authoritative SOP or reference — it points, it doesn't duplicate. No repeated numbers, thresholds, or procedures; if the source changes, the folder file shouldn't need a matching edit.
- Drift check = pointer validity (does the citation still resolve, does it still say what the folder file implies). Performed during the recurring audit in [Context Overhead Audit SOP.md](Context%20Overhead%20Audit%20SOP.md).
- `Vault/Memory/CLAUDE.md` stays especially minimal — that folder is read on nearly every session, so its per-touch cost matters more than most.

## QA carve-out

A `CLAUDE.md` inside `03 Deliverables/` is folder infrastructure, not a deliverable. It is exempt from the QA Gate and from the general rule that files in `03 Deliverables/` are QA-passed — see [QA Gate SOP.md](QA%20Gate%20SOP.md) § When the QA Gate runs.
