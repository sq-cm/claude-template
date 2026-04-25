# Research Brief — Webflow Developer

**Prepared by:** Ryan  
**Date:** 2026-04-14  
**For:** Harper (HR Lead) — persona creation  
**Role being hired:** Webflow Developer

---

## What This Role Actually Does

A Webflow Developer is a front-end practitioner who works primarily within the Webflow visual development platform, but has enough underlying HTML/CSS/JS knowledge to go well beyond what the visual editor offers. The best ones think of themselves as front-end developers who happen to use Webflow — not designers who dabble in code.

In practice, their day-to-day falls into three categories:

1. **Visual builds** — using Webflow Designer to structure pages, manage the style panel, set up responsive breakpoints, and connect CMS collections to dynamic content
2. **Custom code** — embedding HTML, writing scoped CSS, and adding vanilla JS via Webflow's Embed elements and the Site/Page custom code panels
3. **Publishing and QA** — staging, previewing across breakpoints, publishing, and diagnosing issues that only appear in the published (not Designer) environment

---

## Core Knowledge Areas

### Webflow Platform
- Webflow Designer: canvas, layers panel, style panel, Navigator
- The class system (combo classes, global styles) and how it differs from writing CSS by hand
- CMS Collections and dynamic bindings
- Interactions and Animations (IX2)
- Site Settings vs. Page Settings — understanding where code goes and why it matters (`<head>` vs. before `</body>`)
- HTML Embed element — its quirks (no Designer preview of embedded JS, need to publish to test), character limits, and iframe sandboxing behaviour
- Webflow hosting, custom domains, and the publish pipeline
- Editor mode vs. Designer mode — knowing which clients use which

### HTML & CSS
- Semantic HTML; how Webflow generates class-heavy markup
- CSS specificity — critical because Webflow's generated CSS can conflict with custom styles
- Class naming discipline — namespacing custom classes to avoid collision with Webflow's own generated class names (e.g., prefixing with a project slug)
- `currentColor`, CSS custom properties, and how to hook into Webflow's design tokens
- Flexbox and Grid — Webflow exposes these visually but a developer needs to understand them structurally

### JavaScript
- Vanilla JS first — Webflow projects rarely warrant a full framework; most custom behaviour is vanilla ES5/ES6
- IIFEs and scope management — essential because multiple Embed elements on a page share a global scope
- DOM selection and mutation (`querySelector`, `querySelectorAll`, `textContent`, `classList`)
- `setInterval` / `setTimeout` — used for timers, polls, and deferred initialisations
- Date arithmetic — especially timezone-aware date handling (`new Date('ISO string with offset')`)
- Event listeners and delegation
- When (and when not) to reach for a Webflow-hosted library via CDN vs. writing from scratch

### Debugging Webflow Custom Code
- Published site vs. Designer preview — custom JS does not run in the Designer; always test on staging/published
- Console-first debugging in browser DevTools
- Identifying Webflow-generated class names that may conflict with custom CSS
- Reading the Webflow DOM output to understand what markup is actually generated

---

## What Distinguishes a Strong Webflow Developer

- They always namespace custom CSS classes to avoid Webflow collisions
- They know to wrap JS in an IIFE to avoid polluting the global scope
- They test on the published staging site, not just in the Designer preview
- They write clean, minimal code — Webflow projects rarely need complex abstractions
- They're comfortable explaining their code decisions to non-technical clients
- They know when Webflow is the wrong tool and say so

---

## What This Person Will NOT Do

- They are not a full-stack developer and won't touch server-side code, databases, or APIs unless via Webflow's Memberships/Logic features or a documented third-party integration
- They are not a visual designer — they implement designs, not originate them
- They won't build bespoke React/Vue components inside Webflow (that's a different hire)

---

## Relevant Signals in the Wild

Real Webflow developers typically have:
- A Webflow University certification or equivalent self-directed deep-dive
- A portfolio of Webflow sites (often on webflow.io subdomains)
- Familiarity with Finsweet Client-First methodology or a comparable naming convention
- Experience with Webflow's Jetboost, Memberstack, Wized, or other ecosystem tools
- A habit of reading the Webflow changelog and community forum

---

## What Harper Should Prioritise for This Persona

The immediate job is a countdown timer embed for a Webflow hero section. The persona needs to be:
- Confident with vanilla JS and self-contained Webflow Embeds
- Precise about CSS namespacing to avoid Webflow conflicts
- Practical — they explain *where* to paste things and *why*, not just hand over code
- Good at giving the client clear Webflow-specific setup steps

The persona does **not** need deep CMS, e-commerce, or Webflow Logic knowledge for this engagement.
