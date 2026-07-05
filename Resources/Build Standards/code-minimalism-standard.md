# Code Minimalism Standard

**Purpose:** Authoritative standard for avoiding over-engineered, speculative, or bloated code across every code deliverable the team produces.

**Authoritative for all code produced by the five code personas: Webflow Developer, Email Developer, Mobile Developer, Automation Architect, Creative Technologist.**

*Last updated: 2026-07-05*

---

## Enforcement

**Primary enforcement surface is the `code-minimalism-review` skill run on diffs.** Each code persona runs the skill inline against their own diff before considering work done — it is not a sub-agent dispatch, and it is not gated behind any other process step.

The QA Gate (`@{QAComplianceReviewer}`) is narrow-scope by design — it fires only on moves to `03 Deliverables/`. Most code this team writes (working files, iteration, internal tooling, `02 Working/` output) never crosses that boundary. Treating the QA Gate as the enforcement point for this standard would leave the majority of code unreviewed. The skill is the enforcement point; the QA Gate is a second pass on the narrow slice of code that ships as a client Deliverable.

---

## The Ladder

Climb this before writing a line, and again before calling a diff finished. Two rungs work → take the higher one and move on. The ladder is a reflex, not a research project — but it runs *after* you understand the problem, not instead of it. Read the task and the code it touches first, trace the real flow end to end, then climb.

1. **Does this need to exist at all?** Speculative need = skip it, say so in one line. (YAGNI)
2. **Already in this codebase?** A helper, util, type, or pattern that already lives here → reuse it. Look before you write; re-implementing what's a few files over is the most common slop.
3. **Stdlib does it?** Use it.
4. **Native platform feature covers it?** `<input type="date">` over a picker library, CSS over JS, a database constraint over application code.
5. **Already-installed dependency solves it?** Use it. Never add a new one for what a few lines can do.
6. **Can it be one line?** One line.
7. **Only then:** the minimum code that works.

**Bug fix = root cause, not symptom.** A report names a symptom. Before you edit, grep every caller of the function you're about to touch. The lazy fix IS the root-cause fix: one guard in the shared function is a smaller diff than a guard in every caller.

---

## When Not to Be Lazy

Never simplify away: input validation at trust boundaries, error handling that prevents data loss, security measures, accessibility basics, or anything explicitly requested. If a user insists on the full version, build it — do not re-argue the point.

Never be lazy about understanding the problem. The ladder shortens the solution, never the reading. Trace the whole thing first — every file the change touches, the actual flow — before picking a rung. Laziness that skips comprehension ships a confident wrong fix. Read fully, then be lazy.

Hardware is never the ideal on paper: a real clock drifts, a real sensor reads off. Leave the calibration knob — the physical world needs tuning a minimal model can't see. (Applies by analogy to any integration with an unreliable external system — a flaky third-party API, a CMS webhook, a rate-limited model endpoint: leave the retry or backoff knob, don't minimise it away.)

Lazy code without its check is unfinished. Non-trivial logic (a branch, a loop, a parser, a money or security path) leaves ONE runnable check behind — the smallest thing that fails if the logic breaks. No frameworks, no fixtures, no per-function suites unless asked. Trivial one-liners need no test — YAGNI applies to tests too.

---

## Debt-Comment Convention

Deliberate shortcuts are allowed when the ladder says so — but they must be marked, not silent. Mark them with a `debt:` code comment naming the ceiling (when this breaks) and the upgrade path (what to do about it).

```js
// debt: linear scan, fine under ~500 rows. Switch to indexed lookup if this table grows past that.
const match = rows.find(r => r.id === targetId);
```

A `debt:` comment is not an apology — it is a load-bearing note for whoever hits the ceiling next. No ceiling, no upgrade path, no `debt:` comment: rewrite the comment or rewrite the code.

---

## Attribution

Adapted from [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail), upstream commit `40e50d9e03242aa5dd53ac771950f9127362b25f`, MIT License. The ladder, the "when not to be lazy" guards, and the debt-marker convention (renamed here from upstream's `ponytail:` marker to `debt:`) are adapted from that project's review methodology.

Full licence text, reproduced verbatim per MIT terms:

```
MIT License

Copyright (c) 2026 DietrichGebert

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
