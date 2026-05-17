# UX Audit Draft — Meridian Law Homepage
**Status:** IN PROGRESS
**Lead:** the UX/UI Designer
**Supporting:** the Copywriter (copy review), the QA Compliance Reviewer (WCAG — see separate checklist)
**Last updated:** 2026-01-04

---

## Audit Summary

| Section | Status | Priority |
|---|---|---|
| 1. Navigation | ✓ Done | High |
| 2. Hero Section | ✓ Done | High |
| 3. Call to Action | ✓ Done | Critical |
| 4. Trust Signals | — | High |
| 5. Mobile Experience | — | Critical |
| 6. Page Speed Perception | — | Medium |
| 7. Conversion Flow | — | Critical |

---

## 1. Navigation — ✓ Complete

### Findings
- Top nav has 7 items — exceeds the 5-item cognitive load threshold
- "Our Team" and "About" are redundant; content overlaps significantly
- No sticky navigation on scroll — users lose wayfinding context on long pages
- Mobile hamburger menu works but takes 2 taps to reach key pages ("Contact")

### Recommendations
| Priority | Action |
|---|---|
| High | Merge "Our Team" into "About" — reduce nav to 5 items |
| High | Make nav sticky on scroll |
| Medium | Promote "Contact" to top-level in mobile nav |

---

## 2. Hero Section — ✓ Complete

### Findings
- Headline: "Trusted Legal Advice for Growing Businesses" — functional but generic
- No subheadline — value proposition requires user to scroll to understand service scope
- Hero image: stock photo of handshake — low trust signal, visually clichéd
- Primary CTA in hero: "Learn More" — non-specific, low intent

**Copywriter's copy note:** The headline could do more work. Suggest: "Commercial Law for Startups That Move Fast." Tests the client's actual differentiator (speed + startup focus) rather than generic trust language.

### Recommendations
| Priority | Action |
|---|---|
| Critical | Replace "Learn More" CTA with "Book a Free 30-Min Call" |
| High | Add subheadline: 1 sentence naming 3 service areas |
| Medium | Replace handshake stock photo with real team photo or abstract legal mark |

---

## 3. Call to Action — ✓ Complete

### Findings
- 3 different CTA labels used across the page: "Learn More", "Get in Touch", "Book a Consultation" — inconsistent intent signalling
- Primary CTA button colour (#2C4A8B navy) has 2.8:1 contrast ratio against white — fails WCAG AA (minimum 4.5:1 for normal text)
- No CTA above the fold on mobile

### Recommendations
| Priority | Action |
|---|---|
| Critical | Standardise all CTAs to "Book a Free Call" or "Book a Consultation" — pick one |
| Critical | Change CTA button to #1A3A7A (contrast 5.1:1) — flagged for the QA Compliance Reviewer's WCAG review |
| High | Add CTA button to mobile hero (above fold) |

---

## 4. Trust Signals — ⬜ TODO

<!-- Complete this section -->
<!-- Assess: client logos, testimonials, credentials/memberships, case study references, awards -->
<!-- Question to answer: does a first-time visitor (startup founder) have enough reasons to trust this firm within 10 seconds? -->

### Findings

*(Complete this section. Look at: are there client logos? Are testimonials specific or generic? Are legal credentials visible? Is there a "featured in" press section?)*

### Recommendations

*(List 3–4 prioritised actions)*

---

## 5. Mobile Experience — ⬜ TODO

<!-- Complete this section -->
<!-- Assess: layout reflow, tap target sizes (minimum 44x44px), font sizes, scroll behaviour, form usability -->
<!-- Context: 68% of their traffic is mobile (from brief) — this is high priority -->

### Findings

*(Complete this section. Key questions: does the page reflow gracefully at 375px? Are any elements clipped? Is the enquiry form usable on mobile?)*

### Recommendations

*(List 3–5 prioritised actions — given 68% mobile traffic, this section should have Critical-priority items)*

---

## 6. Page Speed Perception — ⬜ TODO

<!-- Complete this section -->
<!-- Assess: loading states, skeleton screens, above-the-fold content priority, font loading (FOUT/FOIT) -->
<!-- Note: this is about perceived speed (UX), not actual Core Web Vitals (that's Alex's domain) -->

### Findings

*(Complete this section. Does the page feel fast? Is there a loading spinner? Does text appear before images? Any layout shift on load?)*

### Recommendations

*(List 2–3 actions)*

---

## 7. Conversion Flow — ⬜ TODO

<!-- Complete this section -->
<!-- Trace the full user journey: land → understand → trust → act -->
<!-- Assess: friction points in the enquiry form, number of fields, confirmation flow, follow-up expectation setting -->

### Findings

*(Complete this section. Walk through the enquiry form as a user. How many fields? Is there a progress indicator? What happens after submission?)*

### Recommendations

*(List 3–4 prioritised actions)*

---

## Compile Instructions

Once all sections are complete:
1. Ask the QA Compliance Reviewer to confirm WCAG checklist is done
2. Merge this document + the QA Compliance Reviewer's checklist into `03 Deliverables/UX Review Report — Meridian Law.md`
3. Add an **Executive Summary** (3–5 bullets, non-technical) at the top for the partner
4. Add a **Developer Handoff** section at the bottom for the Webflow dev
