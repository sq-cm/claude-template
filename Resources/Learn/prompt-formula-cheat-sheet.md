# Prompt Formula Cheat Sheet

One formula. Five slots and a finish line. Get useful output the first time.

---

## The Formula: 5 Slots + a Finish Line

Fill these in order. Each slot feeds the next.

| # | Slot | What goes here |
|---|------|----------------|
| 1 | **Context** | What you're working on and where it fits: the project, the product, the situation |
| 2 | **Goal** | The measurable outcome — what changes, and by how much |
| 3 | **Insight** | The problem or observation driving the ask: what's broken, missing, or what you've noticed about how people behave |
| 4 | **Output spec** | How many, what format, who it's for. A number here is a requirement (180-word emails, five slides, three directions); a number added only to stop the model rambling is not — say "cover the substance, don't pad" instead and let the content find its length |
| 5 | **Constraints & anti-goals** | Hard limits, each with the reason it exists. Name something to avoid only when it's a real constraint or a failure you've actually seen — and say what you want instead |
| 6 | **Done when** | A verifiable completion check — an observable result, passing test, or measurable state |

---

## Fill-in-the-Blank Template

> I'm **[task]** for **[context]** to achieve **[measurable goal]**, where **[insight/problem]**.
> Generate **[N]** **[output type]** in **[format]** that **[success criteria]**.
> Constraints: **[limits — and why each one exists]**. Avoid: **[anti-goals worth naming]**.
> Done when: **[verifiable completion check]**.

---

## Three Examples

### Design

> I'm designing a Weekly Insights screen for a budgeting app to **increase 2-week retention by 15%**, where most users drop off because they don't feel a sense of progress.
> Generate **3** distinct design directions in **annotated wireframe descriptions** that make progress clear and motivate users to return week over week.
> Constraints: must work within the existing 4-tab nav; no new onboarding steps. Avoid: gamification patterns (badges, streaks) — we tested these and they backfire with our audience.
> Done when: each of the 3 directions includes an annotated wireframe description that names the specific progress signal used and explains how it fits within the existing nav structure.

### Content

> I'm writing a **5-email welcome sequence** for a B2B SaaS product to **lift trial-to-paid conversion from 18% to 25% within 14 days**, where new users activate the core feature but then stall because they don't see a path to their first result.
> Generate **5** email subjects + body outlines in **plain text with send-day labels** that walk a first-time user from signup to their first exported report.
> Constraints: each email under 180 words; no discounts. Avoid: generic "here's what you can do" feature lists — every email must reference one user job, not a product capability.
> Done when: all 5 emails have a subject line, send-day label, and body outline; each body references a single user job; no email exceeds the 180-word constraint.

### Code

> I'm fixing a **broken date filter** in `src/components/ReportTable.tsx` to **eliminate the "Invalid Date" console error** that blocks 100% of Safari users from viewing reports, where `Date.parse()` fails on the `YYYY-MM-DD` strings returned by `/api/reports`.
> Generate **1** corrected function in **TypeScript**, and explain the change in your reply rather than in a committed code comment.
> Constraints: do not change the component's prop interface. Avoid: third-party date libraries — this codebase has a policy against adding dependencies for single-use parsing.
> Done when: the ReportTable renders in Safari 17 without a console error and the existing `report-table.test.ts` suite passes.

---

## Effort and Length

The formula covers what to ask for. How hard the model works is a setting; how much it writes is something you have to ask for.

- **Effort is the main cost and speed control.** Set it with `/model` or `--effort`. `high` is the default and the right place to start; `xhigh` is for the hardest coding and agentic work. The vault's own dial runs high or xhigh for plan mode, checkpoints, and architecture, and medium or low once a plan is approved (root `CLAUDE.md` § Default Mode). On your own one-off asks, drop to `medium` or `low` for routine work — they hold quality there at a fraction of the tokens and latency.
- **Don't reach for `xhigh` on a long deliverable.** At the top settings the model can draft the whole thing in its thinking and then write it out again: twice the wait, twice the tokens, no better result. Run long documents at `high`.
- **Effort doesn't shorten the answer.** It changes how much the model thinks, not how much it says. If a reply or a written file runs longer than you want, say so in the prompt: "cover the substance; don't pad with filler sections, redundant summaries, or boilerplate."
- **At low effort, ask for the search.** Current models look things up less often at `low` and answer from memory more. If the answer depends on something current, name that thing and say "search before answering."

---

## Claude Code Micro-Tips

- **Route and scope in one message.** Addressing a specialist directly with `@{RoleToken}` (e.g. `@{Copywriter}`) plus the formula gets the right team member a complete brief in one send. Open requests with no `@` go to Sam for routing.
- **Reference files by path.** "Fix the bug in `src/utils/auth.ts` line 42" beats "fix the auth bug."
- **Share relevant background up front.** Drip-feeding context mid-task causes course corrections that cost more than the original prompt.
- **Ask for a plan when you want a review gate.** On hard or ambiguous work, "show me the approach before writing any code" catches wrong assumptions before they're baked in. Skip it on work you'd approve unread — the extra turn is a cost, and asking for a plan on a task the model could just do encourages over-planning.
- **Describe the destination, not the driving.** State the goal, the guardrails, and how you'll know it's right, then leave the route alone. Step-by-step choreography written for older models often *lowers* output quality now — the team member's own plan usually beats a hand-written script. Keep numbered steps only where the order genuinely matters: destructive commands, auth flows, compliance steps.
- **Correct course early.** If a direction feels off after the first response, redirect immediately rather than letting a wrong approach accumulate.
- **Paste errors verbatim.** The exact error string, stack trace included, is faster than a description of what went wrong.
- **Keep the tool reference handy.** Keyboard shortcuts, built-in slash commands, and MCP setup live in the community-maintained [Claude Code Cheat Sheet](https://cc.storyfox.cz/) — updated with each Claude Code release.
- **Show, don't just describe.** If you have a past output you liked (an email, a table, a paragraph in the right tone), paste it in as a sample. One good example steers format and tone better than three sentences of description.
- **Say why a constraint exists.** "No date libraries: codebase policy" gets honoured more reliably than "no date libraries", because the team member can apply the reasoning to edge cases you didn't anticipate.
- **Say whether you're watching.** "I'm not sitting here — don't stop to ask permission for reversible steps this request already covers" gets you a long unattended run. If you *are* watching, ask for the opposite: "one-line update when you find something load-bearing or change direction."
- **Hold the scope to the ask.** "Don't fix or tidy anything I didn't ask about — list it at the end as a follow-up instead." Current models widen scope on their own.
- **Say when you want assessment, not action.** "Assess only, change nothing" stops a question being read as a work order.
- **Don't ask for a double-check.** "Verify your work", "use a sub-agent to check it" — that behaviour is already built in, and asking again burns tokens without improving the result. The exception is a long unattended build, where asking for a check at set points — tests, a build, a lint pass — does pay.
- **Sharpen the prompt before you send it.** The vault ships two tools for this: `grill-me` interviews you until the brief is complete, and `/prompt-review` scores a draft against this sheet and rewrites it in the same order. Time spent on the brief costs less than iterating on the output.

---

## 10-Second Pre-Send Checklist

Before you hit send, check five things:

- [ ] Does my prompt include a number or metric in the goal? *(not "improve" — "increase by X%")*
- [ ] Have I said what format I want? *(bullet list, table, code block, annotated wireframe, etc.)*
- [ ] If I named something to avoid, is it a real constraint or a failure I've seen — with its reason and what I want instead? *("plain language, not marketing speak — the audience is non-technical")*
- [ ] Is this one coherent job? *(a multi-step job belongs in one prompt; two unrelated jobs don't)*
- [ ] Would a new colleague know what "done" looks like from this prompt alone? *(that's your "Done when:" line)*

If any answer is no, fix that slot before sending.

---

Part of the [AI Team Onboarding Guide](index.html).
