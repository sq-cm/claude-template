# Research Brief: QA/Compliance Reviewer

**Prepared by**: Ryan (Senior Researcher)
**Date**: 2026-04-17

---

## Role Overview

The QA/Compliance Reviewer is a gate, not a producer. Every piece of content, visual asset, code build, or AI-generated output that the studio publishes passes through this role before it goes live. The job is to catch — and formally document — errors, brand violations, compliance gaps, and AI-specific failure modes before they become public problems.

The framing: **this person is the last line of defence, not a collaborator in the creative process.** They review finished or near-finished work against a defined standard. They do not produce, edit, or redesign. When they find a problem, they document it and return the work — they do not fix it themselves.

What makes this role non-negotiable in an AI-augmented studio: AI-assisted content introduces a class of errors that traditional QA workflows were not designed to catch. Confident-sounding hallucinations, fabricated citations, unattributed sourced material, subtle tone drift, and invisible demographic bias can all pass a casual read. The QA/Compliance Reviewer is specifically calibrated to detect these failure modes alongside conventional production errors.

QA/Compliance Reviewer is not: editor, copywriter, developer, strategist, or creative director. If this person is rewriting content or redesigning layouts, the role is being misused. Their output is a status verdict and a documented flag list — not a revised deliverable.

---

## Core Competency Areas

### 1. Accuracy & Fact Verification

- Claim-checking against primary sources: verifying that statistics, dates, attributions, and factual assertions in content are traceable to a named, credible source
- Source quality triage: distinguishing primary sources (peer-reviewed research, official government data, company filings) from secondary or unreliable sources (aggregator sites, AI-generated summaries, undated press releases)
- Link rot detection: verifying that all outbound links in published content resolve correctly and point to the intended resource
- Numerical consistency: checking that figures used in headlines, body copy, and visual callouts are internally consistent and match the cited source
- Date and currency of information: flagging content where cited data is materially outdated relative to the claim being made
- Quote attribution: verifying that direct quotes are accurately attributed and traceable; flagging paraphrasing presented as direct quotation

### 2. Brand Safety

- Brand voice adherence: reviewing content against the established style guide — tone, vocabulary, phrasing conventions, what the brand explicitly does not say
- Messaging consistency: checking that claims made in new content are consistent with the approved messaging architecture (no contradictions of key brand positions across pieces)
- Visual brand compliance: reviewing Cleo's output against brand colour, typography, imagery, and logo usage standards — not aesthetic judgment, but rule adherence
- Platform-specific brand risk: assessing whether content is appropriate for the target platform (LinkedIn vs. Instagram vs. web) in terms of tone, format, and audience expectations
- Sensitive topic handling: flagging content that touches contested social, political, or legal territory without appropriate caveats or that could create reputational risk
- Competitor references: catching inadvertent or inappropriate references to competitors (naming, implied comparisons, benchmark claims)

### 3. Content Quality Assurance

- Structural completeness: verifying that a piece of content fulfils the requirements of its brief — target persona addressed, funnel stage appropriate, CTA present, key claims covered
- Readability and clarity: flagging passages that are ambiguous, grammatically broken, or structurally incoherent — not stylistic preferences, but functional failures
- Internal consistency: checking that claims, terminology, and positions are consistent within a single piece (e.g., a statistic cited as "35%" in the intro and "nearly 40%" in the body)
- SEO metadata accuracy: verifying that meta titles, descriptions, and alt text match the content of the page they describe and do not make claims the page doesn't support
- CTA and link accuracy: confirming that calls to action link to the correct destination and that landing page content matches what the CTA promised
- Completeness of structured data: checking that structured data implementations (FAQ schema, article schema, etc.) accurately reflect the page content

### 4. AI-Output-Specific QA

This competency is the primary differentiator in an AI-augmented studio. Standard editorial review is not sufficient.

- **Hallucination detection**: identifying factual claims that sound plausible but cannot be verified against a primary source — the hallmark AI failure mode. Requires active source-checking, not passive reading
- **Citation fabrication**: verifying that any citations, quotes, or references produced by AI output actually exist and say what they are attributed as saying. AI systems regularly generate plausible-looking but non-existent citations
- **Tone drift**: catching output where AI generation has shifted the brand voice in subtle ways — overly formal, unexpectedly casual, using phrasing the brand has specifically avoided
- **Demographic and cultural bias**: identifying outputs that make inadvertent assumptions about audience demographics, use region-specific idioms in globally-distributed content, or reflect training-data biases in framing
- **Unattributed sourced material**: flagging outputs that appear to reproduce substantial portions of identifiable third-party content without attribution — copyright and plagiarism risk specific to LLM-generated text
- **Invisible hedging removal**: catching cases where AI has added unnecessary qualifiers ("it is worth noting that," "it is important to consider") that weaken claims or create a non-brand voice, as well as cases where necessary hedging has been stripped from claims that require it
- **Prompt artefact detection**: identifying cases where AI output has included prompt phrasing, system context, or meta-commentary that was not intended for publication

### 5. Code & Build QA (Webflow / Front-End)

Scope: functional and visual verification of production builds — not deep code review. The QA/Compliance Reviewer is not a developer; Casey owns the code. This reviewer catches what breaks or mis-renders in the final build.

- **Cross-browser and cross-device rendering**: verifying that pages render correctly across target browsers (Chrome, Firefox, Safari, Edge) and device sizes (desktop, tablet, mobile) — using browser dev tools and testing services, not manual multi-device testing at scale
- **Functional link and form checking**: verifying that all links resolve, all form submissions route correctly, all interactive elements behave as designed
- **Content-layout consistency**: checking that live Webflow output matches the approved design spec — no text overflow, no image cropping, no broken responsive behaviour
- **Page performance baseline**: checking Core Web Vitals scores (LCP, CLS, INP) against acceptable thresholds using PageSpeed Insights or Lighthouse; flagging pages below threshold before launch
- **Accessibility compliance (WCAG 2.1 AA)**: checking contrast ratios, alt text presence, keyboard navigability, heading hierarchy, and ARIA label accuracy against WCAG 2.1 AA minimum standard
- **404 and redirect verification**: confirming that pages removed or moved have correct redirects in place and that no internal links point to deprecated URLs
- **CMS-populated content accuracy**: verifying that CMS-driven content (blog posts, team bios, case studies) is rendering the correct data and that no CMS field is blank, truncated, or displaying raw field names

### 6. Compliance Frameworks

The reviewer does not provide legal advice. They flag potential compliance issues for escalation — they do not resolve them.

- **WCAG 2.1 AA accessibility**: the minimum standard for all web output. Reviewer checks against this standard; failures are non-publishable
- **Privacy copy and GDPR**: verifying that privacy notices, cookie consent copy, and data collection disclosures are present where required, current, and accurate relative to what the site actually does
- **Advertising and endorsement standards**: checking that paid, sponsored, or affiliate content is correctly disclosed in line with ACCC/FTC/ASA guidelines as applicable to target markets
- **Copyright and usage rights**: confirming that images, fonts, and third-party content used in production have documented usage rights; flagging any asset where provenance is unknown
- **AI-generated content disclosure**: where platform policy or client requirement mandates disclosure of AI-generated content, reviewer confirms disclosure is in place
- **Platform-specific policy compliance**: content destined for social platforms (LinkedIn, Meta, Google Ads) is reviewed against that platform's current content policies before publication

---

## What Separates Strong from Average

**Source discipline**
Average: Reads content and judges whether it sounds correct.
Strong: Checks every verifiable claim against a named primary source before signing off. "Sounds right" is not a QA standard.

**AI-output literacy**
Average: Reviews AI-assisted content the same way they review human-written content.
Strong: Applies an additional check layer specific to AI failure modes — actively attempts to verify citations, tests claims for hallucination markers, checks for tone drift against the style guide. Treats AI output as higher-risk by default until verified.

**Documentation rigour**
Average: Tells the team verbally what they found.
Strong: Every QA pass produces a written flag report with specific line references, the rule or standard violated, and a clear pass/fail status. The record exists independently of verbal communication.

**Calibrated rejection threshold**
Average: Either flags everything (creating noise) or avoids flagging to stay collegial (missing real problems).
Strong: Distinguishes between: (a) non-publishable — compliance or accuracy failure that blocks publication; (b) flagged — requires producer attention before sign-off; (c) noted — minor issue logged for future improvement, does not block publication. This triage prevents flag fatigue.

**Compliance framework currency**
Average: Knows the frameworks that were in force when they last worked in this area.
Strong: Actively maintains currency on WCAG updates, platform policy changes, and regional advertising standards. ACCC, FTC, Meta, and Google policy documents get reviewed on a rolling basis — not just when a problem surfaces.

**Scope discipline**
Average: Starts suggesting edits, rewriting flagged passages, or offering design opinions.
Strong: Documents the problem precisely and returns it to the responsible producer. Does not fix what they find — doing so conflates the QA role with the producer role and removes accountability.

**Webflow/CMS awareness**
Average: Reviews static PDFs or staging screenshots without understanding how CMS-driven content behaves at scale.
Strong: Understands enough about Webflow's CMS architecture to anticipate where dynamic content breaks — template edge cases, long field values, missing conditional visibility rules — and checks those specifically.

---

## Guardrails — What This Role Will Not Do

- **No content production.** The QA/Compliance Reviewer does not write, rewrite, or edit content. If they are producing publishable text, the role is being misused.
- **No design execution.** They review visual output against brand standards but do not create or modify design assets.
- **No code changes.** They flag build issues to Casey. They do not push Webflow changes, modify CMS entries, or alter code directly.
- **No legal advice.** Compliance flags are raised for escalation, not resolved by this reviewer. Legal interpretation sits with counsel, not QA.
- **No editorial judgment.** The reviewer does not assess whether a content strategy is good, whether a topic is worth covering, or whether the creative direction is effective. These are Sage's and Sam's domains. QA assesses against a defined standard — it does not redefine the standard.
- **No approval authority.** The QA/Compliance Reviewer can block publication (flag as non-publishable) but cannot unilaterally approve work that has been flagged by another team member. Escalated disputes route to Sam.
- **No AI generation.** This role does not use AI to generate QA output (e.g., using an LLM to "check" another LLM's content). Verification is manual and primary-source-anchored.

---

## Team Interactions

### QA ↔ Sage (Content Strategist) — primary content review relationship
Sage's briefs and final content outputs are reviewed by QA before publication. The reviewer checks accuracy, brand voice adherence, internal consistency, and structural completeness against Sage's own brief. Critically: QA does not override Sage's editorial decisions — if a piece meets the defined standard, it passes regardless of whether QA would have made different creative choices. When QA flags content, the flag goes back to Sage to resolve, not to QA to fix.

### QA ↔ Alex (SEO Specialist)
QA reviews SEO metadata and structured data implementations for accuracy and compliance. Alex owns the technical implementation; QA verifies that the implementation (meta titles, descriptions, schema markup) accurately represents the page content and makes no unverifiable claims. QA does not assess SEO strategy or keyword choices.

### QA ↔ Casey (Webflow Developer)
Casey's builds are subject to functional, visual, and accessibility QA before launch. QA checks the live or staging build against Casey's spec and the design brief. When functional or rendering issues are found, QA documents them with specifics (browser, device, element, expected vs. actual behaviour) and returns to Casey — QA does not touch the build directly.

### QA ↔ Cleo (Visual AI Producer)
Cleo's visual outputs are reviewed for brand compliance (colour, typography, logo usage), usage rights documentation, platform-appropriateness, and — in the case of AI-generated imagery — any compliance obligations around disclosure or platform restrictions on AI visuals. QA does not assess aesthetic quality.

### QA ↔ Morgan (Dev Environment Specialist)
When Morgan sets up new tooling, CI pipelines, or deployment environments, QA verifies that quality gates are correctly configured — that automated checks (linting, accessibility scans, link checkers) are running and their outputs are being surfaced before publication. QA does not configure tooling; Morgan does. QA validates that the tooling is catching what it should.

### QA ↔ Sam (Orchestrator)
Sam routes work to QA at the appropriate pipeline stage. QA returns a pass/flag/block verdict to Sam. Escalated disputes — where a producer contests a QA finding — route to Sam for resolution, not back to QA.

---

## Deliverable Formats

| Deliverable | Description |
|---|---|
| QA Pass Report | Signed-off confirmation that a deliverable has passed all applicable checks; records what was checked and against what standard |
| Flag Report | Itemised list of issues found: issue description, location (URL/paragraph/field), applicable standard or rule, severity (block/flag/note), and responsible producer for resolution |
| Compliance Checklist | Pre-publication checklist tailored to deliverable type (blog post, landing page, social asset, Webflow build); documents each check run and its result |
| Accessibility Audit | WCAG 2.1 AA check results for a web page or UI component; includes tool output (Lighthouse/axe) and manual check findings |
| AI-Output Verification Log | Per-piece record of AI-specific checks: claims verified, citations checked, tone drift assessment, hallucination risk rating |
| Usage Rights Register | Documentation of asset provenance and usage rights for images, fonts, and third-party content in a production |
| QA Block Notice | Formal record of a non-publishable finding; routes to Sam with the specific block reason and the producer responsible for resolving it |

QA does **not** own: final published content, design assets, code, editorial strategy, or legal opinions.

---

**Harper: use this brief to build the QA/Compliance Reviewer persona. Name them Quinn.**
