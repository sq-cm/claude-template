# Research Brief — Email Developer

**Prepared by:** Ryan  
**Date:** 2026-04-28  
**For:** Harper (HR Lead) — persona creation  
**Role being hired:** Email Developer

---

## What This Role Actually Does

An Email Developer is a front-end specialist who works inside one of the most constrained rendering environments in all of web development. Every browser follows the same standards body. Every email client does not. Outlook on Windows still renders HTML through Microsoft Word's layout engine. Gmail strips `<style>` blocks in certain contexts. Apple Mail on iOS supports dark mode inversion in ways that can break carefully chosen brand colours. A good email developer knows this landscape intimately and writes code that survives it.

In practice, their day-to-day falls into three categories:

1. **Design-to-code production** — taking a Figma file, visual spec, or comp and translating it into hand-coded HTML that renders correctly across 20+ client/OS/app combinations. This is not exporting from a template builder; it is writing structural markup from scratch or from a controlled base template.
2. **Client and ESP integration** — wiring the built template into an email service provider (Mailchimp, Klaviyo, Campaign Monitor, HubSpot, etc.), inserting merge tags, conditional blocks, and dynamic content tokens in the correct syntax for that platform.
3. **QA, testing, and iteration** — running the built email through Litmus or Email on Acid, diagnosing rendering failures client-by-client, fixing them, and repeating until the send is clean. This also covers pre-send preflight: file weight checks, spam-indicator markup review, image hosting verification.

---

## Core Knowledge Areas

### HTML Email Structure
- Table-based layout — the foundation. CSS float/grid/flexbox cannot be relied upon across all clients; structural layout must be built with nested `<table>`, `<tr>`, `<td>` elements
- Inline CSS — many clients strip `<style>` blocks from the `<head>` or shadow DOM them into irrelevance; the developer must know which properties to inline and which can safely live in a `<style>` block (and for which clients)
- MSO conditional comments — `<!--[if mso]>...<![endif]-->` targeting Outlook's Word-rendering engine for layout fixes, VML-based rounded buttons, ghost table wrappers
- VML (Vector Markup Language) — the only way to render certain visual elements (backgrounds, rounded corners, vector graphics) in Outlook; not a nice-to-have
- Email-safe CSS properties — which CSS properties are universally supported, which are partially supported, and which will silently fail
- Image handling — hosted image URLs (not inline base64 for deliverability reasons), `width`/`height` attributes on `<img>` elements, `display:block` to kill phantom image-bottom gaps

### Multi-Client Rendering Knowledge
- **Outlook (Windows, 2016–2023+):** Word rendering engine, ghost tables, VML, no CSS `border-radius`, no `background-image` in `<div>`, MSO line-height quirks
- **Gmail (web, iOS, Android):** `<style>` block stripping in certain delivery modes, class specificity behaviour post-delivery, Promotions tab tab triggering, Gmail clipping at 102KB message size
- **Apple Mail / iOS Mail:** the most capable renderer (WebKit), but dark mode inversion can recolour elements unexpectedly; `-apple-mail-implicit-dark-scheme` handling
- **Outlook on Mac:** WebKit-based (very different from Windows Outlook), but still has quirks with certain font stacks
- **Samsung Mail, Yahoo Mail, Outlook.com:** each has its own subset of supported properties and stripping behaviours

### Responsive and Fluid Layout Patterns
- **Fluid layout:** percentage-width columns that scale naturally without media queries — the baseline for clients that do not support `@media`
- **Hybrid/spongy layout:** combines max-width constraints with fluid percentages using `mso-table-lspace`/`mso-table-rspace` ghost tables — allows multi-column layouts to stack on mobile without `@media` support
- **Responsive (media query-based):** full stack/reflow using `@media` — works in Apple Mail, Android native, modern webmail; must be coded defensively so it degrades to fluid on non-supporting clients
- Knowing which pattern to reach for based on the client mix the sender's audience uses

### ESP Integration
- **Mailchimp:** merge tag syntax (`*|FNAME|*`), editable regions, template language, drag-drop vs. coded template distinction
- **Klaviyo:** Jinja2-based templating (`{{ first_name }}`), conditional blocks (`{% if %}`), dynamic blocks, flow-level vs. campaign-level template management
- **Campaign Monitor:** Editable region markup, personalisation syntax
- **HubSpot / Salesforce Marketing Cloud (Pardot/SFMC):** AMPscript or HubL where relevant; awareness of what changes when deploying to enterprise platforms
- Understanding the difference between a reusable master template and a one-off send — and coding for the right scenario

### Accessibility in Email
- `alt` text on every `<img>` element — not optional; screen readers and image-blocked clients both depend on it
- `role="presentation"` on layout tables (so screen readers skip structural scaffolding)
- `lang` attribute on the `<html>` element
- Semantic text hierarchy using real heading tags where supported, not just large bold text
- Dark mode handling: using `prefers-color-scheme` media query, `[data-ogsc]`/`[data-ogsb]` selectors for Outlook.com dark mode, and `color-scheme` meta tag
- Sufficient colour contrast — not assuming images will load

### Deliverability-Adjacent Development Concerns
- **Gmail 102KB clip:** if the raw HTML email exceeds 102KB, Gmail clips it with "View entire message" — the developer must audit file weight and compress or restructure accordingly
- **Image-to-text ratio:** heavily image-based emails with little live text are more likely to trigger spam filters; the developer makes structural choices that affect this ratio
- **Spam-trigger markup:** certain HTML patterns (e.g., `display:none` on large blocks, invisible text, excessive `!important` usage) flag spam filters; the email dev is responsible for avoiding them
- **Image hosting:** images must be externally hosted (not inline) at a reliable CDN; broken image links are a send-day failure
- **AMP for Email:** an awareness of what AMP for Email enables (interactive carousels, live data, form submissions inside the email) and its severe client support limitations — currently only Gmail, Yahoo, and Outlook.com web support it; most sends do not use it

### QA and Testing Workflow
- Litmus and/or Email on Acid — the industry-standard rendering preview tools; running a test matrix across 20–40 client/device combinations before send
- Reading a rendering diff — understanding why a specific client breaks a specific element and tracing it back to the markup
- Pre-send preflight: spell check, link check, merge tag variable fallback check, spam score check (tools like Mail-Tester), subject line/preview text audit
- Seed list testing — sending to real accounts across providers to catch issues that rendering previews miss

---

## What Distinguishes a Strong Email Developer

- They know the Outlook Word-rendering engine cold — they do not google MSO conditional comment syntax; they write it from memory or from a disciplined personal snippet library
- They reach for hybrid/spongy layout when `@media` cannot be guaranteed, rather than defaulting to a responsive pattern that will silently break on unsupported clients
- They inline CSS with discipline — they know which properties can stay in `<style>` (for the clients that support it) and which must be inlined for universal safety
- They are fluent in Litmus or Email on Acid and can read a rendering failure and diagnose its cause within minutes, not hours
- They keep file weight under control without being asked — they know the 102KB Gmail clip rule and check against it before handing off
- They write genuinely useful `alt` text — not `image1.jpg`, not empty, but copy that serves the message if images are blocked
- They know the ESP they're working in at a code level — they don't just paste HTML in; they understand how the platform transforms it at send time
- They maintain a personal base template or snippet library that reflects current best practices, updated as client support changes
- They track sources like Can I Email (caniemail.com), Email on Acid's blog, and the Email Geeks Slack community to stay current as client support evolves

---

## What This Person Will NOT Do

- **General web development** — table-based email layout is a distinct discipline; this is not the hire to build a landing page, a Webflow site, or a React component
- **List management and segmentation** — defining audience segments, suppression lists, and send frequency logic is an ESP/marketing ops function, not an email dev function
- **Email marketing strategy** — subject line strategy, send cadence, A/B test design, list growth tactics — these belong to a strategist or CRM manager, not the developer
- **Deliverability and domain authentication operations** — setting up SPF, DKIM, DMARC records, managing sender reputation, warming up a new IP — these are infrastructure/deliverability specialist concerns; the email dev is aware of them and codes defensively, but does not own them
- **Automation logic design** — defining when a flow triggers, what conditions branch it, how long delays should be — this is CRM/ops, not dev
- **Visual design origination** — this person implements designs, they do not originate them; if they are handed a vague brief and told to "make it look good," that is a different hire

---

## Relevant Signals in the Wild

Real email developers typically have:
- A portfolio of built HTML emails — ideally with rendered previews (Litmus screenshots or exported Litmus Builder links) showing multi-client output, not just a single screenshot
- Demonstrated Outlook fix fluency — MSO conditionals, VML buttons, ghost tables appearing in their code samples
- Familiarity with at least two major ESPs at a code-integration level, not just drag-and-drop template use
- Engagement with the Email Geeks Slack, the caniemail.com resource, or Litmus Community
- An awareness of the MJML framework (a React-style abstraction that compiles to email-safe HTML) — strong practitioners either use it deliberately or have a considered reason not to
- Experience with version control for email templates (Git) — a signal they treat email code as code, not as a one-off artefact
- Awareness of email accessibility standards (W3C email accessibility notes, Litmus accessibility guide)

---

## What Harper Should Prioritise for This Persona

The immediate need is converting design files into production-ready HTML emails compatible across Outlook (Windows), Gmail, and Apple Mail, and deploying them in at least one ESP (likely Klaviyo or Mailchimp based on the team's likely client profile).

Harper should build a persona that is:
- **Technically grounded** — this person speaks in markup and rendering terms, not in marketing terms. They say "MSO conditional ghost table" not "email layout fix."
- **Client-specific in diagnosis** — when something breaks, they name the client, the cause, and the fix. Vague "email doesn't look right" responses are not in their register.
- **Opinionated about quality** — they push back on design specs that cannot be built email-safely (e.g., CSS gradients without an Outlook fallback, very heavy image-only layouts) and propose workable alternatives.
- **ESP-literate at the code level** — they know how Klaviyo's Jinja2 templating differs from Mailchimp's merge tag syntax and adjust their output accordingly.

**Critical flag for Harper:** The persona file should specify which ESP(s) this persona is primarily fluent in. Klaviyo (Jinja2 templating, flow-level HTML) and Mailchimp (merge tags, coded template structure) require meaningfully different syntax knowledge. If the team's clients use multiple platforms, the persona may need to explicitly flag which is primary and which is "familiar but verify syntax." Do not leave this ambiguous — it will surface as a gap on the first real task.
