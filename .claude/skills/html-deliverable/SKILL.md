---
name: html-deliverable
description: |
  Render an interactive HTML companion alongside a QA-passed Markdown deliverable.
  Use when the user or a collaborator requests: "audit report", "status report",
  "implementation plan", "comparison", "research explainer", "incident post-mortem",
  "make it HTML", "interactive HTML version", or "HTML companion". Produces a
  sibling-pair — <name>.md (canonical) + <name>.html (render) — in the same folder.
  For shotlists or Seedance prompt sets, use shotlist-html-companion instead.
---

# HTML-as-deliverable workflow

## When to use

Six deliverable types are in scope:

1. Audit reports
2. Status reports
3. Implementation plans
4. Comparisons
5. Research / concept explainers
6. Incident post-mortems

These types benefit from HTML because spatial structure carries meaning that Markdown flattens: timelines, side-by-side comparisons, tabbed sections, annotated diffs, collapsible findings.

If a deliverable falls outside this list, the Orchestrator asks the user before proceeding.

## When NOT to use

- Copy decks
- Creative briefs
- Raw transcripts
- Prose-only documents where Markdown already renders cleanly
- Any deliverable where the reader will edit the content (MD is canonical; HTML is read-only)

## Post-MD nudge

After MD is QA-passed, deliver this line exactly:

> "Want this as an interactive HTML companion? Say the word."

Do not offer HTML before QA sign-off on MD.

## Sibling-pair rule

Deliverables ship as a matched pair in the same folder, same stem:

```
03 Deliverables/
  <name>.md       ← canonical source of truth
  <name>.html     ← render of approved MD content
```

MD is canonical. HTML is a render — it is never edited directly. When MD changes, HTML is rebuilt from the updated MD.

When handing off, the Producer or Orchestrator announces both paths in chat:

> "Markdown at [path], interactive HTML companion at [path]."

## Build constraints

- Vanilla HTML, single file only.
- Inline `<style>` and `<script>` only — no `<link>` to external stylesheets, no external script tags.
- No CDN. No network requests. No framework. No package dependencies.
- Archive-safe: the file must open and render correctly with no internet connection, three years from now.
- Charts: inline SVG only.
- Diagrams: inline SVG or CSS grid only.
- Use the `studio-shell.css` scaffold for base styles and CSS variables (`--accent`, `--ink`, `--paper`, `--rule`). Embed it inline at render time — do not link it. Path for reference: `./studio-shell.css`.
- See `./examples/` for six reference HTMLs (one per deliverable type). Match their structural patterns. Do not treat them as rigid templates.

## Theme toggle (mandatory — all 6 deliverable types)

Every rendered HTML file must implement a light/dark theme toggle. This is a BLOCK-level requirement in Quinn's QA checklist.

### HTML attribute

The `<html>` element must carry `data-theme="light"` as its default:

```html
<html lang="en" data-theme="light">
```

### No-JS fallback

The toggle button depends on JS to function. With JS disabled, hide the button so it does not present as a broken control. Include in `<head>`:

```html
<noscript><style>.theme-toggle{display:none}</style></noscript>
```

The page renders in light mode by default (per `data-theme="light"` on `<html>`); OS dark preference is not honoured without JS — acceptable tradeoff per locked decision.

### Dark mode CSS

Dark mode is implemented via `[data-theme="dark"]` selector on `:root` variables — not `@media (prefers-color-scheme: dark)`. The studio-shell already defines this selector. Do not use the media query pattern.

### JS bootstrap (inline, before `</body>`)

```html
<script>
  (function () {
    var KEY = 'html-deliverable-theme';
    var html = document.documentElement;
    var btn  = document.getElementById('theme-toggle');
    var sun  = document.getElementById('icon-sun');
    var moon = document.getElementById('icon-moon');

    function applyTheme(theme) {
      html.setAttribute('data-theme', theme);
      if (theme === 'dark') {
        sun.style.display  = 'none';
        moon.style.display = '';
      } else {
        sun.style.display  = '';
        moon.style.display = 'none';
      }
    }

    var stored = localStorage.getItem(KEY);
    if (stored) {
      applyTheme(stored);
    } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      applyTheme('dark');
    }

    btn.addEventListener('click', function () {
      var current = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      applyTheme(current);
      localStorage.setItem(KEY, current);
    });
  }());
</script>
```

Bootstrap logic: read `localStorage.getItem('html-deliverable-theme')`. If a stored value exists, apply it. If not, check `window.matchMedia('(prefers-color-scheme: dark)').matches` — if true, apply dark. Otherwise stay light. Persist every toggle to localStorage under key `html-deliverable-theme`. Values: `light` / `dark`.

### Button markup

```html
<button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">
  <svg id="icon-sun" ...><!-- sun SVG --></svg>
  <svg id="icon-moon" ... style="display:none"><!-- moon SVG --></svg>
</button>
```

Button placement: outside `<main>`, immediately before `</body>`. Position: `fixed; top: 12px; right: 12px`. Size: 36×36px. Inline SVG sun/moon icons — no font dependencies. `aria-label="Toggle theme"` is required. Button must be keyboard-focusable with visible `:focus-visible` ring.

### Print hide

The shell's print block includes `.theme-toggle { display: none; }`. Do not override this.

---

## Table of contents (required for audit, research, post-mortem)

TOC is **required** on: audit reports, research/concept explainers, incident post-mortems. It is a FLAG-level requirement in Quinn's checklist for those three types. For the other three types (status report, comparison, implementation plan) it is opt-in — use it when section count is 5 or more.

### Layout wrapper

Wrap the page content in a two-column grid layout:

```html
<div class="toc-layout">
  <main>
    <!-- page content with section headings carrying id attributes -->
  </main>
  <aside class="toc" aria-label="Table of contents">
    <p class="toc__title">Contents</p>
    <ul class="toc__list">
      <li><a class="toc__link" href="#s-section-id">Section Name</a></li>
      ...
    </ul>
  </aside>
</div>
```

The `.toc-layout` class (defined in studio-shell) creates a `grid-template-columns: 1fr 220px` layout. The `<aside class="toc">` is the right rail. The `.toc-layout` div replaces the `max-width: var(--container)` constraint on `body` — `body` margin is still centred.

### Section heading IDs

Every section heading linked from the TOC must carry an `id` attribute. Convention: `id="s-[slug]"`. Example:

```html
<h2 id="s-findings">Findings</h2>
```

### Scroll-spy JS

Use `IntersectionObserver` — not a `scroll` event listener. This respects `prefers-reduced-motion` and is more performant.

```js
(function () {
  var links = document.querySelectorAll('.toc__link');
  if (!links.length || !('IntersectionObserver' in window)) return;

  var headings = Array.from(links).map(function (l) {
    return document.querySelector(l.getAttribute('href'));
  }).filter(Boolean);

  var observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        var id = '#' + entry.target.id;
        links.forEach(function (l) {
          l.classList.toggle('toc__link--active', l.getAttribute('href') === id);
        });
      }
    });
  }, { rootMargin: '0px 0px -60% 0px', threshold: 0 });

  headings.forEach(function (h) { observer.observe(h); });
}());
```

### Responsive reflow

At `<900px` the TOC collapses from the right rail to a top-stacked block above `<main>` (via `order: -1` on `.toc`). The shell handles this. Do not add a separate breakpoint for this in page-specific CSS.

### Print

The print block suppresses the TOC (`display: none`) and collapses the grid layout (`display: block`). TOC content does not appear in print. This is correct — section headings provide sufficient navigation for a printed document.

---

## Responsive — Tier A convention

The studio shell handles body-level reflow only: a single global breakpoint at `@680px` governs `body` padding and typography scale. That breakpoint lives in the shell and is not replicated in page-specific CSS.

Each component owns its own breakpoint, declared inline with its rules:

```css
/* Example: finding body grid in audit-report */
.finding__body {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: var(--space-3);
}

@media (max-width: 680px) {
  .finding__body {
    grid-template-columns: 1fr;
  }
}
```

**Rules:**
- Components that reflow (multi-column grids, side-by-side layouts) declare their breakpoint immediately after the component's rules — not in a consolidated media query block at the end of the file.
- No CSS custom property tier system for breakpoints. Breakpoint values are literal pixel values.
- The TOC's `<900px` reflow is defined in the shell (and in each example where TOC is used inline). Do not override it.
- Quinn BLOCKs files where the TOC right rail is broken at `<900px` (overlaps content or is hidden without collapsing).

---

## MD-HTML drift

### Rebuild HTML when:

- A section moves or is reordered.
- New findings are added or existing findings are removed.
- Data corrections are made.
- Numbers change.
- Recommendations change.

### Skip rebuild when:

- Typo fixes only.
- Humaniser tweaks with no semantic shift.
- Prose-only edits that do not alter meaning, structure, or data.

**PM (Tate) judges substantive vs cosmetic** when the call is ambiguous.

## Footer spec

Every rendered HTML file carries a `<footer class="footer-meta" role="contentinfo">` with three elements, each in its own `<span class="footer-meta__item">`, in this exact label format:

1. **Render timestamp** — `Rendered: <ISO 8601, local timezone>`. Example: `Rendered: 2026-05-23T15:32:00+10:00`.
2. **Content hash** — `Source hash: <8 chars>`. First 8 characters of the SHA-1 hash of the source MD file. Before hashing, normalise the MD content to LF line endings and strip trailing whitespace from each line. This normalisation prevents false drift on Windows checkouts or git line-ending conversions.
3. **Studio attribution** — `Produced by {{Studio}} · <date>`. No logo. No colour. No styling commitment beyond the base shell in v1.

Label punctuation is canonical — `Rendered:` and `Source hash:` (with colon and single space). QA blocks footers that omit either label or use a different prefix.

The hash gives deterministic drift detection: if the hash in the footer does not match a fresh hash of the current MD, the HTML is stale.

## QA flow

Steps must run in order:

1. MD produced by the generating persona.
2. Humaniser pass on MD.
3. Quinn (QA Compliance Reviewer) QA on MD — must PASS before HTML is rendered.
4. HTML rendered from approved MD.
5. Quinn second pass on HTML against the HTML checklist (see `Resources/SOPs/QA Gate SOP.md` — Quinn's HTML checklist addendum). Checks include: links resolve, no JS console errors, prints cleanly, accessibility floor met (`<details>`/`<summary>` for disclosure, keyboard nav for tabs, `prefers-reduced-motion` respected).

HTML is not shipped until both QA gates pass.

## Rollback scope

Git tag pre-install covers the template vault only. Vaults already instantiated from a prior template release are out of v1 rollback scope.

## References

- Build standards: `Resources/Build Standards/html-deliverable-standards.md`
- QA checklist (HTML addendum): `Resources/SOPs/QA Gate SOP.md`
- Example HTMLs (one per deliverable type): `./examples/`
