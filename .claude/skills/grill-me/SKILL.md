---
name: grill-me
description: Interview the user relentlessly about a plan, decision, or idea until reaching shared understanding, working the design tree in rounds. Use when the user wants to stress-test their thinking, get grilled on a design, or mentions "grill me".
adapted_from: https://github.com/mattpocock/skills
upstream_commit: bfdaef8e989a5c81160e74bc5043bd434da49cac
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling (by Matt Pocock).
Synced with upstream @ bfdaef8 on 13/08/2026 (plan 092), replacing the older copy pinned at
e5932a7, which asked one question at a time. Vault adaptations, all to be carried over any
future upstream replace:
  1. Kept as a single skill named `grill-me`, and model-invocable. Upstream splits the engine
     into `grilling` and makes `grill-me` a thin `disable-model-invocation` wrapper; that split
     would break CLAUDE.md § Default Mode, which auto-fires this skill at intake. Never add a
     `disable-model-invocation` key to this frontmatter.
  2. Description merges upstream's scope with this vault's explicit trigger phrase, which is a
     more reliable match target than upstream's "any 'grill' trigger phrases".
  3. Vault depth rule added below. Upstream's fact-finding paragraph tells the reader to
     dispatch a sub-agent; only the Orchestrator may do that here.
-->

> **Vault depth rule:** Only the Orchestrator dispatches sub-agents. If you are a routed persona,
> do not dispatch the fact-finding sub-agent this skill mentions — look the fact up inline with
> your own tools; if the exploration is too broad for that, or it needs a tool you do not hold
> (web fetch is Orchestrator-mediated), return it as a fan-out spec to the Orchestrator
> (CLAUDE.md § Sub-Agent Depth).

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
