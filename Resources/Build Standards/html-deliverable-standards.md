# HTML Deliverable Standards

**Purpose:** Authoritative technical standards for all HTML deliverables shipped alongside Markdown per the html-deliverable skill.

**Authoritative for all html-deliverable builds.**

*Last updated: 2026-05-23*

---

## Purpose & Scope

This document governs the construction of interactive HTML companions produced by the html-deliverable skill. It applies to the six in-scope deliverable types — audit reports, status reports, implementation plans, comparisons, research/concept explainers, and incident post-mortems — and to no other file type. It defines the rules a builder must follow when rendering approved Markdown content into a single HTML file. It does not govern the Markdown itself, the QA workflow, or the drift-detection logic — those live in `SKILL.md`.

---

## The Single-File Rule

Every HTML deliverable is **one file**. It must open and render correctly with no network connection, on any machine, three years from now. This is a hard archive-safety constraint, not a preference.

**Do:**
- Inline all styles in `<head><style>` — paste the `studio-shell.css` contents directly.
- Inline all scripts in `<script>` tags within the document.
- Inline all SVG in the document body.
- Embed images as base64 data URIs (`<img src="data:image/...;base64,...">`).

**Don't:**
- `<link rel="stylesheet" href="...">` — any form, local or remote.
- `<script src="https://...">` — no CDN script tags.
- `@import url(...)` — including Google Fonts `@import`.
- `<img src="https://...">` — no remote image references.
- `<link rel="preconnect">`, `<link rel="preload">` pointing to remote origins.

If an image cannot be reasonably base64-encoded (oversized binary), omit it and substitute a descriptive caption or SVG placeholder. Do not link to it.

---

## The Studio-Shell Embed Rule

Every HTML deliverable embeds the contents of `.claude/skills/html-deliverable/studio-shell.css` verbatim in `<head><style>`. The CSS variables, resets, component classes, dark-mode rules, reduced-motion rules, and print styles it provides are the baseline for all deliverables.

**Rules:**
- Paste the full CSS text. Do not link the file. Do not `@import` it.
- Do not minify it. The ~10KB cost buys readability when someone inspects the source. This is an intentional tradeoff.
- Do not bundle or concatenate other stylesheets on top of it without a clear separation comment.
- Additional page-specific styles go in a second `<style>` block after the shell embed, or in a clearly delimited section labelled `/* === Page-specific === */`.
- Do not override shell CSS variables without a documented reason. The variable values are tuned for WCAG AA contrast; overriding them casually breaks the accessibility guarantee.

---

## Theme Toggle and Dark Mode

Every HTML deliverable must implement the JS-toggled light/dark theme system. These requirements are enforced at QA.

### What the builder must do

- `<html>` element carries `data-theme="light"` as the default attribute.
- Dark mode variables are set via `[data-theme="dark"]` CSS selector — not `@media (prefers-color-scheme: dark)`. The studio-shell provides this selector; do not use the media query variant.
- A `<button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">` is present in the document, containing inline SVG sun and moon icons.
- The JS bootstrap (inline `<script>` before `</body>`) reads `localStorage.getItem('html-deliverable-theme')`, falls back to `window.matchMedia('(prefers-color-scheme: dark)')`, and persists toggles to localStorage under key `html-deliverable-theme`.
- The toggle button is hidden in print via `.theme-toggle { display: none; }` in the print block.

### BLOCK rules (Quinn blocks the file if any apply)

| Rule | Check |
|---|---|
| Missing `data-theme` attribute on `<html>` | `<html>` must have `data-theme="light"` or `data-theme="dark"` |
| Missing `.theme-toggle` button | `<button class="theme-toggle">` must be present |
| Missing toggle JS bootstrap | Inline script must read localStorage and set `data-theme` on `<html>` |
| Missing dark-mode CSS via `[data-theme="dark"]` | `[data-theme="dark"]` selector must define dark variable overrides; `@media (prefers-color-scheme: dark)` must not be used as the sole dark-mode mechanism |

### FLAG rules (Quinn flags for review)

| Rule | Detection | Severity |
|---|---|---|
| Toggle button visible in print preview | Open file, browser print-preview, confirm `.theme-toggle` is hidden | FLAG |
| Missing `<noscript>` hide of `.theme-toggle` | `<head>` must contain `<noscript><style>.theme-toggle{display:none}</style></noscript>` so the button is hidden when JS is disabled (it cannot function without JS) | FLAG |

---

## Table of Contents

TOC is required on three deliverable types: audit reports, research/concept explainers, and incident post-mortems. It is opt-in for the other three types (status reports, comparisons, implementation plans) when section count is 5 or more.

### What the builder must do

- Wrap page content in `<div class="toc-layout">` with `<main>` and `<aside class="toc">` as children.
- Section headings linked from the TOC carry `id="s-[slug]"` attributes.
- TOC links use class `toc__link`. Active state is driven by IntersectionObserver-based scroll-spy, not a scroll event listener.
- At `<900px` the TOC collapses to a top-stacked block via the shell's responsive rules.
- TOC is suppressed in print (`display: none`) — the shell print block handles this.

### FLAG rules (Quinn flags for review)

| Rule | Check |
|---|---|
| Missing TOC on audit report | `<aside class="toc">` must be present |
| Missing TOC on research/concept explainer | `<aside class="toc">` must be present |
| Missing TOC on incident post-mortem | `<aside class="toc">` must be present |
| TOC scroll-spy not updating active link | `.toc__link--active` class must toggle as user scrolls through sections |

### BLOCK rules

| Rule | Check |
|---|---|
| Broken `<900px` reflow on TOC-bearing types | TOC must collapse to top-stack at `<900px`; it must not overlap content or remain hidden without collapsing |

---

## Responsive Layout

The studio shell handles body-level reflow. Individual components own their own breakpoints.

### Convention

- The shell's single global breakpoint at `@680px` governs body padding and typography. Page-specific CSS does not redeclare body-level reflow.
- Component breakpoints (TOC reflow, multi-column grids, KPI rows, comparison cards, side-by-side panels) are declared inline with each component's rules — not consolidated at the end of the file.
- No CSS custom property tier system for breakpoints. Values are literal pixel values.
- TOC reflow breakpoint is `@900px` — defined in the shell and (for examples) inline with the `.toc-layout` rules.

### BLOCK rules

| Rule | Check |
|---|---|
| `<900px` reflow broken on TOC-bearing examples | TOC may not overlap main content at any viewport width below 900px. Content may not be hidden under a stuck/fixed TOC. |

---

## Accessibility Floor

Checkpoint A required these standards explicitly. All items are mandatory; none are advisory.

### Progressive disclosure

Use `<details>`/`<summary>` as the default collapsible primitive for all collapsible sections, findings, and expandable content. The shell already styles it. Do not substitute a `<div>` + JS click handler unless `<details>` genuinely cannot meet the requirement (e.g., a collapsible with an animated height transition that is functionally required and approved by QA).

### Keyboard navigation

- Every interactive element — tab buttons, collapsibles, expand-all controls, filter inputs — must be reachable and operable via keyboard alone.
- Tab order must be logical and follow the visual reading order.
- Visible `:focus-visible` focus rings are mandatory. The shell's `:focus-visible` rule covers standard elements; custom components must not suppress it.
- Do not use `tabindex` values greater than 0.

### Motion

`prefers-reduced-motion: reduce` is handled by the shell — it sets all animation and transition durations to `0.01ms`. **Do not add animations or transitions in page-specific CSS without testing under reduced-motion.** Do not override the shell's reduced-motion block.

### Colour scheme

Dark mode is handled by the shell via `[data-theme="dark"]` CSS variable overrides — toggled by the JS theme bootstrap, not `@media (prefers-color-scheme: dark)`. OS preference is used only as the bootstrap default when no localStorage value is stored. Do not introduce hardcoded `#hex` colour values in page-specific CSS unless they are wrapped in their own `[data-theme="dark"]` selector counterpart. Do not use `@media (prefers-color-scheme: dark)` in page-specific CSS — the JS-toggled approach owns dark mode state.

### Document language

The `<html>` element carries a `lang` attribute set from the deliverable's declared BCP-47 locale — `en-AU` when nothing declares one (the skill's required shell line in `.claude/skills/html-deliverable/SKILL.md` § Theme toggle › HTML attribute already makes the attribute mandatory). The declaration and the mismatch rule live in `Resources/SOPs/Output Locale SOP.md` § HTML deliverables; the severity row lives here so Quinn's HTML checklist has one home. `lang` is markup, not prose: it is set from the declaration, and a locale pass never 'corrects' it.

| Rule | Detection | Severity |
|---|---|---|
| `lang` missing, or not the declared locale | `<html lang="…">` present and equal to the locale named in the QA dispatch brief (`en-AU` when none is named) | FLAG |

### Semantic HTML

Use structural elements correctly:

| Purpose | Element |
|---|---|
| Page-level wrapper | `<main>` |
| Self-contained content unit | `<article>` |
| Thematic grouping | `<section>` |
| Navigation block | `<nav>` |
| Page or section header | `<header>` |
| Page or section footer | `<footer>` |

- Do not skip heading levels. `<h3>` must not appear without a preceding `<h2>` in the same section.
- Do not use headings for visual sizing — use them for document structure.

### ARIA

Use ARIA only when semantic HTML cannot express the interaction. Required cases for the tab pattern:

```html
role="tablist"   on the tab container
role="tab"       on each tab button
role="tabpanel"  on each panel
aria-selected    on the active tab
aria-controls    linking tab to panel
aria-labelledby  linking panel back to tab
```

Do not add `role="button"` to a `<button>`. Do not add `aria-label` to elements that already have visible text.

### Contrast

WCAG AA is the floor:

- Body text: 4.5:1 minimum contrast against background.
- Large text (≥ 18pt or ≥ 14pt bold): 3:1 minimum.
- UI components and focus indicators: 3:1 minimum.

The shell's variable set is tuned to meet these ratios in both light and dark modes. Do not override `--ink`, `--paper`, `--ink-muted`, or `--accent` without verifying the new values still pass.

---

## Print Rules

Checkpoint A required these standards explicitly. All items are mandatory.

### Break avoidance

The following elements must not break across printed pages. The shell already enforces these with `break-inside: avoid`:

- `.timeline__row`
- `.kpi`
- `.callout`
- `.risk-table tr`
- `.diff-table tr`
- `table tr` (general)
- `details`

Do not override `break-inside` on these classes.

### URL expansion

The shell prints full URLs after external links via `a[href^="http"]::after { content: " (" attr(href) ")"; }`. Do not suppress this in page-specific print CSS.

### Collapsed details

The shell forces all `<details>` open for print. Do not override the print `details:not([open])` rule. Collapsed content that is invisible on screen must be visible on the printed page.

### Background fills

The shell sets `--surface: #f5f5f5` and `--surface-strong: #ebebeb` for print, stripping colour fills. Do not add print-specific `background-color` values that waste ink unless the fill carries semantic meaning (e.g., diff-table added/removed row colours).

### QA verification

At QA, every example type must print cleanly to single-sided A4. Quinn's HTML checklist covers this. Do not ship a file that has not been print-previewed.

---

## Footer-Meta Spec

Every rendered HTML deliverable carries a `<footer class="footer-meta">` immediately before `</body>`. It must contain exactly three elements:

```html
<footer class="footer-meta">
  <span class="footer-meta__item">Rendered: 2026-05-23T14:35:00+10:00</span>
  <span class="footer-meta__item">Source hash: a3f9d12b</span>
  <span class="footer-meta__item">Produced by {{Studio}} · <date></span>
</footer>
```

**Label punctuation is canonical** — `Rendered:` and `Source hash:` with colon and single space. QA blocks footers that omit either label or use a different prefix form.

**Render timestamp:** ISO 8601, full precision, local timezone offset. Example: `2026-05-23T14:35:00+10:00`. Not UTC. Not a date-only string.

**Content hash:** First 8 characters of the SHA-1 hash of the source MD file. Before hashing, apply these normalisation steps in order:
1. Convert all line endings to LF (`\r\n` → `\n`).
2. Strip trailing whitespace from every line.

This normalisation is mandatory. Without it, Windows checkouts and git line-ending conversions produce false hash drift. Pinning the normalisation ensures the hash is deterministic across environments.

**Attribution:** Plain text exactly as shown — `Produced by {{Studio}} · <date>`. No logo. No inline colour. No CSS beyond what the shell's `.footer-meta` class already provides.

The hash is the drift indicator: if the hash in the footer does not match a fresh hash of the current MD file (with normalisation applied), the HTML is stale and requires rebuild per the drift policy in `SKILL.md`.

---

## JS Budget

Most deliverables need zero JavaScript. `<details>` handles collapsibles without JS. The radio-input tab pattern in the shell handles tab state without JS. Use JS only when these CSS-native patterns genuinely cannot cover the requirement.

**Permitted JS uses:**
- Tabs with programmatic state (e.g., deep-linking to a tab via URL hash).
- Filterable tables (filter input driving row visibility).
- Expand-all / collapse-all buttons for `<details>` groups.

**Rules:**
- Vanilla JS only. No frameworks, no libraries, no polyfills loaded from CDN.
- Total inline `<script>` content must stay under approximately 2KB unminified. If you are approaching this limit, the page likely needs less interactivity, not more JS.
- No `eval()`. No `document.write()`. No inline `on*` event attributes (`onclick="..."`) — use `addEventListener` instead.
- Scripts go before `</body>`. Do not block rendering with scripts in `<head>`.

**Don't:**
- Load jQuery, Alpine.js, Vue, React, or any other framework.
- Pull a charting library from a CDN to avoid writing SVG.
- Add JS for anything `<details>` or a CSS-only pattern already handles.

---

## SVG Rules

All charts and diagrams are inline SVG. No external chart libraries. No `<img src="chart.svg">`.

**Requirements:**
- Every SVG must include a `<title>` element as its first child. This is the accessible name.
- Complex diagrams should also include a `<desc>` element with a plain-language description.
- Use CSS variables inside SVG fill and stroke attributes: `fill="var(--accent)"`, `stroke="var(--rule)"`. This ensures charts respond correctly to dark mode and print.
- SVGs representing data must include a text-based fallback or adjacent data table for screen readers where the visual encoding is the primary information carrier.

**Example accessible SVG head:**
```html
<svg viewBox="0 0 400 200" aria-labelledby="chart-title chart-desc" role="img">
  <title id="chart-title">Q1 findings by severity</title>
  <desc id="chart-desc">Bar chart: 12 critical, 8 high, 24 medium, 31 low findings.</desc>
  ...
</svg>
```

Do not export SVGs from Figma or Illustrator and paste them raw — they typically contain hardcoded hex values, `<defs>` clutter, and no accessibility attributes. Write SVG to spec for this context.

---

## File Size Guidance

Target: under 200KB per HTML file including all inlined CSS, scripts, and base64 images.

If you exceed 200KB:
1. Audit page-specific CSS for rules that duplicate the shell. Remove duplication.
2. Check for base64-encoded images — these are the most common source of size inflation. Replace oversized images with SVG illustrations or omit them.
3. Check inline script size. If JS is the problem, the feature scope is too broad.

Do not minify the shell CSS to recover size budget. The readability tradeoff is a stated decision (see studio-shell embed rule above). Minification targets page-specific additions only, and only as a last resort.

---

## Examples vs Custom Builds

The six files in `.claude/skills/html-deliverable/examples/` are pattern references — one per deliverable type. They demonstrate structure, component usage, and how to apply the shell correctly.

**Do:**
- Identify the closest example type and use its structure as the starting point.
- Adapt headings, section order, components, and data to fit the actual deliverable.
- Treat the examples as a component inventory: consult them to see correct markup for timelines, KPI rows, diff tables, risk tables, callouts, tabs, and collapsibles.

**Don't:**
- Copy an example file wholesale and replace placeholder text. Structure should be chosen for the content, not inherited from an example that happens to be nearby.
- Add components to a deliverable because an example uses them. Use only what the content requires.
- Modify the example files. They are reference artefacts. If an example is wrong, flag it — do not silently fix it in a production deliverable.

---

## Rollback

Before installing or modifying the html-deliverable skill in the template vault, create a git tag:

```
git tag html-deliverable-pre-install
```

The skill folder is self-contained at `.claude/skills/html-deliverable/`. To uninstall, delete the folder. The template vault state before installation is recoverable from the tag.

Rollback scope is the template vault only. Vaults already instantiated from a prior template release are out of v1 rollback scope.

---

## Cross-References

| Resource | Path |
|---|---|
| Skill principles, drift policy, QA flow | `.claude/skills/html-deliverable/SKILL.md` |
| Studio shell CSS scaffold | `.claude/skills/html-deliverable/studio-shell.css` |
| Example HTMLs (one per deliverable type) | `.claude/skills/html-deliverable/examples/` |
| QA Gate SOP (Quinn's HTML checklist addendum) | `Resources/SOPs/QA Gate SOP.md` |
| Locale declaration and the `lang` rule's origin | `Resources/SOPs/Output Locale SOP.md` § HTML deliverables |
| v2 follow-up — SQ brand pass (Remi, queued) | Tate (ProjectManager) tracks; triggers Odin Checkpoints A + B per skill decision 10 |
