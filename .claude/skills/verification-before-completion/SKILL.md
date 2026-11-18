---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

<!-- Upstream provenance and vault adaptations: see UPSTREAM.md in this folder. Read it before any resync. -->

# Verification Before Completion

## Overview

**Core principle:** Evidence before claims, always.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim
```

## Trigger table

| Claim / trigger | Requires | Not sufficient |
|-----------------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check — partial proves nothing |
| Build succeeds | Build command: exit 0 | "Linter passed" — linter ≠ compiler |
| Bug fixed | Original symptom re-tested: passes | Code changed; "I'm confident" — confidence ≠ evidence |
| Regression test works | Red-green cycle verified (fails on revert, passes on restore) | Test passes once |
| Agent completed | VCS diff shows the changes | Agent reports "success" — verify independently |
| Requirements met | Line-by-line checklist against the plan | Tests passing |
| Hedged wording ("should", "probably", "seems to") or satisfaction ("Great!", "Done!") | Fresh verification before any success wording | "Different words so rule doesn't apply" — spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```
(In this vault, agent dispatch is Orchestrator-only — for a routed persona, "check the diff" applies to work returned to you.)

## When To Apply

**Apply before:** any variation of a success/completion claim or expression of satisfaction; any positive statement about work state; committing, PR creation, task completion; moving to the next task; delegating to agents.

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- any communication suggesting completion or correctness
