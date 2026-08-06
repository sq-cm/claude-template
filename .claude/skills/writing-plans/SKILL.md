---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

<!--
Source: https://github.com/obra/superpowers (superpowers plugin). Synced at upstream
v6.1.1 on 2026-07-06 (PR #133, straight replace). Vault adaptation (plan 025):
plan save path repointed to Vault/Plans/ (git-ignored), dead superpowers:* sub-skill
dependencies (using-git-worktrees, subagent-driven-development, executing-plans)
remapped to Orchestrator-dispatch language, depth-1 guard added directing routed
personas to return reviewer dispatch to the Orchestrator instead of dispatching it
themselves. Band-1 trim (F11, 06/08/2026): one prose length-calibration line added
after the Overview's second paragraph ("Length calibration (vault adaptation): …");
it calibrates prose only and must never weaken the No Placeholders repeat-the-code
rule. Re-sync rule: carry these adaptations over any future upstream replace.
-->

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Length calibration (vault adaptation):** comprehensive means complete, not long — cover what the engineer needs and stop; keep the connecting prose lean. This calibrates prose only, never code blocks: repeat code wherever a task needs it, exactly as the No Placeholders section requires.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

> **Vault depth rule:** Only the Orchestrator dispatches sub-agents. If you are a routed persona, do not dispatch the reviewer sub-agents this skill mentions — return the reviewer prompt as a fan-out spec to the Orchestrator (CLAUDE.md § Sub-Agent Depth).

**Context:** If working in an isolated worktree, it should have been created by the Orchestrator at execution time.

**Save plans to:** `Vault/Plans/YYYY-MM-DD-<feature-name>.md`
- Create the folder if absent; it is git-ignored by design.
- (User preferences for plan location override this default)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a
fresh reviewer's gate. When drawing task boundaries: fold setup,
configuration, scaffolding, and documentation steps into the task whose
deliverable needs them; split only where a reviewer could meaningfully
reject one task while approving its neighbor. Each task ends with an
independently testable deliverable.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Execute this plan task-by-task. In this vault, per-task sub-agent dispatch is the Orchestrator's job — a routed persona executes inline and returns to the Orchestrator between tasks. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `Vault/Plans/<filename>.md`. Two execution options:**

**1. Orchestrator-dispatched (recommended)** - return this plan to the Orchestrator, who dispatches a fresh sub-agent per task with review between tasks

**2. Inline execution** - execute tasks in this session, batch execution with checkpoints

**Which approach?"**

**If Orchestrator-dispatched chosen:**
- Return the plan to the Orchestrator
- Fresh sub-agent per task + two-stage review

**If Inline execution chosen:**
- Execute tasks in this session task-by-task
- Batch execution with checkpoints for review
