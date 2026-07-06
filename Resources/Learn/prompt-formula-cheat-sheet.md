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
| 4 | **Output spec** | How many, what format, who it's for |
| 5 | **Constraints & anti-goals** | Hard limits + what you do not want to see in the response |
| 6 | **Done when** | A verifiable completion check — an observable result, passing test, or measurable state |

---

## Fill-in-the-Blank Template

> I'm **[task]** for **[context]** to achieve **[measurable goal]**, where **[insight/problem]**.
> Generate **[N]** **[output type]** in **[format]** that **[success criteria]**.
> Constraints: **[limits]**. Avoid: **[anti-goals]**.
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
> Generate **1** corrected function in **TypeScript** with an inline comment explaining the change.
> Constraints: do not change the component's prop interface. Avoid: third-party date libraries — this codebase has a policy against adding dependencies for single-use parsing.
> Done when: the ReportTable renders in Safari 17 without a console error and the existing `report-table.test.ts` suite passes.

---

## Claude Code Micro-Tips

- **Route and scope in one message.** Addressing a specialist directly with `@{RoleToken}` (e.g. `@{Copywriter}`) plus the formula gets the right team member a complete brief in one send. Open requests with no `@` go to Sam for routing.
- **Reference files by path.** "Fix the bug in `src/utils/auth.ts` line 42" beats "fix the auth bug."
- **Share relevant background up front.** Drip-feeding context mid-task causes course corrections that cost more than the original prompt.
- **Ask for a plan first on big work.** "Show me the approach before writing any code" catches wrong assumptions before they're baked in.
- **Describe the destination, not the driving.** On tricky problems, "think this through thoroughly" beats spelling out the steps you'd take yourself. The team member often finds a better route than the one you'd prescribe.
- **Correct course early.** If a direction feels off after the first response, redirect immediately rather than letting a wrong approach accumulate.
- **Paste errors verbatim.** The exact error string, stack trace included, is faster than a description of what went wrong.
- **Keep the tool reference handy.** Keyboard shortcuts, built-in slash commands, and MCP setup live in the community-maintained [Claude Code Cheat Sheet](https://cc.storyfox.cz/) — updated with each Claude Code release.
- **Show, don't just describe.** If you have a past output you liked (an email, a table, a paragraph in the right tone), paste it in as a sample. One good example steers format and tone better than three sentences of description.
- **Say why a constraint exists.** "No date libraries: codebase policy" gets honoured more reliably than "no date libraries", because the team member can apply the reasoning to edge cases you didn't anticipate.

---

## 10-Second Pre-Send Checklist

Before you hit send, check five things:

- [ ] Does my prompt include a number or metric in the goal? *(not "improve" — "increase by X%")*
- [ ] Have I said what format I want? *(bullet list, table, code block, annotated wireframe, etc.)*
- [ ] Have I named at least one thing to avoid? *(and paired it with what you want instead: "plain language, not marketing speak")*
- [ ] Is this a single task (not two or more asks bundled into one prompt)?
- [ ] Would a new colleague know what "done" looks like from this prompt alone? *(that's your "Done when:" line)*

If any answer is no, fix that slot before sending.

---

Part of the [AI Team Onboarding Guide](index.html).
