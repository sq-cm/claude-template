---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

<!--
Source: https://github.com/obra/superpowers (superpowers plugin). Synced at upstream
v6.1.1 on 2026-07-06 (PR #133, straight replace). Vault adaptation (plan 025): added a
clause to the "Agent delegation" block noting agent dispatch is Orchestrator-only in
this vault. Re-sync rule: carry this adaptation over any future upstream replace.
Band-1 trim (F1, 06/08/2026) — carry ALL of the following over any future upstream
replace (this file is deliberately ~70 lines against upstream's ~136):
- Completed the shame-framing removal the 11/07/2026 (W19) note claimed was already
  done: removed "dishonesty, not efficiency" (upstream Overview), the "just this
  once" / "tired and wanting work over" red flags, and the "I'm tired | Exhaustion
  ≠ excuse" pair — the excuse pairs are compressed into the trigger table's fatigue
  and hedged-wording rows, not deleted outright.
- Merged Common Failures, Red Flags - STOP, Rationalization Prevention, and most of
  Key Patterns into the single trigger table below.
- Kept two Key Patterns examples: Tests, and the vault-adapted Agent delegation.
- Dropped The Bottom Line section.
- Kept intact and verbatim: the Iron Law, the Gate Function, the spirit-over-letter
  clause (now a table row), and the "Rule applies to" list.
-->

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
| Fatigue or time pressure | Run the verification anyway | "Just this once" — no exceptions |
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

**ALWAYS before:** any variation of a success/completion claim or expression of satisfaction; any positive statement about work state; committing, PR creation, task completion; moving to the next task; delegating to agents.

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
