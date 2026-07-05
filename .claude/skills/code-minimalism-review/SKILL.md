---
name: code-minimalism-review
description: Review a diff or file for over-engineering — speculative flexibility, unused abstraction layers, hand-rolled logic the standard library or platform already covers, and code that could be shorter without losing meaning. Trigger phrases include "minimalism review", "over-engineering check", "what can be deleted", "code-minimalism-review". Scope is over-engineering ONLY — correctness bugs, security holes, and performance are out of scope. Use before considering any code diff finished, per the Code Minimalism Standard.
license: MIT
metadata:
  author: Ellis (Creative Technologist)
  adapted_from: https://github.com/DietrichGebert/ponytail
  upstream_commit: 40e50d9e03242aa5dd53ac771950f9127362b25f
  version: "1.0.0"
---

# Code Minimalism Review

Reviews a diff or file for over-engineering against the [Code Minimalism Standard](../../../Resources/Build%20Standards/code-minimalism-standard.md). **Runs inline in the invoking persona's session** — it is a skill, not a sub-agent dispatch. There is no depth-2 concern here: the persona invokes this skill directly against their own diff, the same way they'd run a linter, and reads the findings themselves.

## When to run it

Any of the five code personas (Webflow Developer, Email Developer, Mobile Developer, Automation Architect, Creative Technologist) runs this skill against their own diff before calling a piece of work done. This is the primary enforcement surface for the Code Minimalism Standard — most code never reaches the QA Gate, so this is where over-engineering actually gets caught.

## What it does

Reads the diff or file, applies the ladder from the Code Minimalism Standard, and lists findings. **It lists — it does not apply anything.** No edits, no refactors, no auto-fixes. The persona decides what to act on.

## Finding format

```
L<line>: <tag> <what>. <replacement>.
```

For a multi-file diff, prefix with the file path:

```
<file>:L<line>: <tag> <what>. <replacement>.
```

## Tags

- **`delete:`** — dead code, unused flexibility, a speculative feature nobody asked for. Replacement is nothing — remove it.
- **`stdlib:`** — hand-rolled logic that the standard library already ships. Name the function.
- **`native:`** — a dependency or block of code doing what the platform already does natively. Name the platform feature.
- **`yagni:`** — an abstraction with exactly one implementation, a config option nobody sets, a layer with exactly one caller.
- **`shrink:`** — same logic, expressible in fewer lines. Show the shorter form.

## Examples

- `L14: delete: 27-line hand-rolled email regex validator, unused edge cases nobody hit. "@" in email is sufficient for this form's trust boundary.`
- `L3: native: moment.js imported for a single date format call. Intl.DateTimeFormat covers it, drop the dependency.`
- `L40: yagni: AbstractRepository base class with one concrete implementation and one caller. Inline the implementation, delete the abstraction.`
- `L58: delete: retry wrapper around a local, idempotent function call that cannot fail transiently. Delete the wrapper.`
- `L22: shrink: manual loop builds a dict from two parallel lists. dict(zip(keys, values)).`

## Boundaries

- **In scope:** over-engineering and complexity only — the ladder, the tags above, nothing else.
- **Out of scope:** correctness bugs, security holes, performance. Route those to normal review; do not fold them into this skill's findings.
- **Tests are not bloat.** A single smoke test or assert-based self-check on non-trivial logic is the minimum bar set by the Code Minimalism Standard, not a target for deletion. Never flag a lone, proportionate test for removal.
- **Lists findings, applies nothing.** This skill never edits the file it reviews.

## Relationship to the QA Gate

At the QA Gate, `@{QAComplianceReviewer}` applies this same lens to code deliverables moving to `03 Deliverables/`. Findings surfaced there are **FLAG severity, never BLOCK** — over-engineering is a quality note, not a shipping blocker.

---

## Attribution

Adapted from `ponytail-review` in [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail), MIT License, upstream commit `40e50d9e03242aa5dd53ac771950f9127362b25f`.
