---
name: prototype
description: Build a throwaway prototype to flesh out a design before committing to it. Routes between two branches — a shareable single-file HTML demo for state/business-logic questions, or several radically different UI variations toggleable from one route. Use when the user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options, or says "prototype this", "let me play with it", "try a few designs". Not for deciding what to build — that's brainstorming; not for production code — that's the normal pipeline.
adapted_from: https://github.com/mattpocock/skills
upstream_commit: c55ee46073ed923f86ce59a5eb3b6d895095d1b7
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/engineering/prototype (by Matt Pocock).
Synced with upstream @ c55ee46 on 24/09/2026 (plan 136), replacing the copy pinned at f304057
(12/05/2026). This resync adopts upstream's behaviour change (6bcbcb0, 17/07/2026): the LOGIC
branch builds a shareable single-file HTML demo instead of a TUI. `LOGIC.md` and `UI.md` are
byte-identical to upstream @ c55ee46. `SKILL.md` carries two vault adaptations, both to be carried
over any future upstream replace:
  1. Description: keeps the vault's trigger phrases and the plan 127 negative routing clauses
     (upstream shortened its description to neither); the logic-branch phrase names the HTML demo.
  2. Rule 6 (capture): upstream's throwaway-branch-plus-issue rule applies only in a code
     repository with its own git history. Vault projects keep the prototype in `02 Working/` and
     record the answer as a `project:` session note for /memory-reconcile; standalone work uses
     the chat `outputs/` or `Notes/` destinations. The rule also tells readers how to read
     "throwaway branch" in LOGIC.md and UI.md, so those two files need no edits.
The 13/08/2026 staleness warning is resolved by this resync. Upstream's `agents/openai.yaml`
(Codex config) is deliberately not vendored.
-->

# Prototype

A prototype is **throwaway code that answers a question**. The question decides the shape.

## Pick a branch

Identify which question is being answered, using the user's prompt, the surrounding code, or by asking if the user is around:

- **"Does this logic / state model feel right?"** → [LOGIC.md](LOGIC.md). Build a single shareable HTML file (free-play buttons plus tabbed guided walkthroughs) that pushes the state machine through cases that are hard to reason about on paper, and that a non-developer can drive.
- **"What should this look like?"** → [UI.md](UI.md). Generate several radically different UI variations on a single route, switchable via a URL search param and a floating bottom bar.

The two branches produce very different artifacts, so getting this wrong wastes the whole prototype. If the question is genuinely ambiguous and the user isn't reachable, default to whichever branch better matches the surrounding code (a backend module → logic; a page or component → UI) and state the assumption at the top of the prototype.

## Rules that apply to both

1. **Throwaway from day one, and clearly marked as such.** Locate the prototype code close to where it will actually be used (next to the module or page it's prototyping for) so context is obvious, but name it so a casual reader can see it's a prototype, not production. For throwaway UI routes, obey whatever routing convention the project already uses; don't invent a new top-level structure.
2. **Trivial to run.** A UI prototype starts from one command in the project's task runner: `pnpm <name>`, `python <path>`, `bun <path>`, etc. A logic demo is a single HTML file the user double-clicks. Either way, no thinking required to start it.
3. **No persistence by default.** State lives in memory. Persistence is the thing the prototype is _checking_, not something it should depend on. If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE, wipe me" name.
4. **Skip the polish.** No tests, no error handling beyond what makes the prototype _runnable_, no abstractions. The point is to learn something fast.
5. **Surface the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user can see what changed.
6. **Capture it when done.** Fold any validated decision into the real work, then keep the prototype itself as a **primary source** and capture the answer (the verdict and the question it settled). Where each goes depends on where you are working:
   - **In a vault project (`Projects/<name>/`):** the prototype file stays in that project's `02 Working/`, never `03 Deliverables/`. `Projects/` is git-ignored, so it is already out of the main branch. Record the answer in a session note in `Vault/Memory/Sessions/` with `project: <name>` set; `/memory-reconcile` folds it into the project's `HISTORY.md` decision log. Never hand-write `HISTORY.md`.
   - **No project:** the prototype goes in the active chat's `outputs/` if a chat is active, else `Notes/`. Record the answer in a session note without a `project:` field.
   - **In a code repository with its own git history** (for example a client build): commit the prototype to a throwaway branch, out of main, and leave a context pointer to that branch on the implementation issue. Capture the answer in the issue or a commit. The main branch keeps only the validated decision.

   Wherever [LOGIC.md](LOGIC.md) or [UI.md](UI.md) say "the throwaway branch" or "out of main", apply the destination above that matches where you are working.
