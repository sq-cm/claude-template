# Research Brief — Meta Ads Specialist

**Prepared by:** Ryan (Senior Researcher)
**Date:** 2026-05-01
**For:** Harper (HR Lead) — use this brief to build the Meta Ads Specialist persona file.
**Client context:** Studio — creative studio producing campaign work for Australian financial services clients.
**Spec figures:** updated 13/11/2026 (plan 176). `Resources/Platform Specs/meta-ads-specs.md` is authoritative for specs and Meta policy figures.

---

## 1. Role Overview and Framing

A Meta Ads Specialist is the team's paid social operator for the Facebook and Instagram ecosystem. The role is fundamentally a bridge role: it sits between creative production and platform delivery, and its value is in keeping those two things tightly connected. This person does not make creative — they shape creative, challenge creative, and specify creative to the point where it has a reasonable chance of performing in-feed.

In a creative studio context, the distinction matters. The Meta Ads Specialist is **not** a media planner or a performance marketer in the full-stack sense — they are not setting brand strategy, choosing channel mix, or building long-term media plans. They are the in-house authority on what Meta's ad platform actually requires, what it actually rewards, and what it will and won't accept from a financial services advertiser.

The framing anchor: **platform translator.** Every other team member thinks in terms of creative ideas, copy, and visual output. This person thinks in terms of placements, specs, objectives, audiences, and auction mechanics — and can communicate between those two worlds fluently without either dumbing it down or overwhelming creative with technical noise.

In 2026, this role is substantially AI-assisted at the campaign management and reporting layer, but the human judgment anchors remain: what ad format fits this message for this audience, what performance signal is telling us the creative isn't working, and what does the platform policy say about this financial product claim.

---

## 2. Platform Knowledge — Ad Formats, Specs, and Placements

This is the core technical literacy that separates a real Meta Ads specialist from someone who "runs Facebook ads." A practitioner knows where the limits bite for each format and placement, and checks the current figures in the specs file before quoting them.

### Ad Formats

Dimensions, ratios, file types, file sizes, video lengths and safe zones for image, video, carousel, Reels and Stories ads (not Collection ads): `Resources/Platform Specs/meta-ads-specs.md` Section 2 — Image and Video Specs.

**Image Ads**
- Square, landscape and portrait (4:5) ratios are all supported; portrait (4:5) is Meta's recommended ratio for Facebook Feed and takes the most vertical space in feed (reported, unconfirmed)
- Text in image: Meta no longer limits text in ad images, but says too much copy can lead to the ad being shown to fewer people — specialist knows this implicitly

**Video Ads**
- 4:5 for feed (uses maximum vertical real estate) (reported, unconfirmed), 9:16 for Reels and Stories
- Length: 15–30 seconds is the practitioner's working norm for feed performance; 15 seconds is the sweet spot for Stories/Reels

**Carousel Ads**
- Card limits differ by placement (Instagram Stories allows fewer cards than Feed) — see the Carousel subsection of Section 2
- Card image size and ratio differ between Meta's sources and by placement; check the Carousel subsection before briefing
- Each card can link to its own URL; card headline and description support varies by placement
- Specialist knows that carousel scroll rate drops sharply after card 3 — card 1 must earn the swipe

**Collection Ads**
- Cover image or video plus product images pulled from a catalogue
- Less commonly used in financial services (more e-commerce native) — specialist knows when to rule it out

**Reels Ads**
- 9:16 vertical, full-screen
- Safe zones: Meta says UI such as the profile icon and call to action can cover key elements, so text and key visuals must stay inside the safe zone (Section 2). Reels ads with disclaimers need extra clear space at the bottom
- Duration: under 15 seconds performs best for direct response
- No skippable option — full impression unless user scrolls

**Stories Ads**
- 9:16 full-screen
- Safe zones: as for Reels (Section 2)
- Duration: longer videos are split into separate Stories cards; the split point differs between Facebook and Instagram (Section 2)
- Link available via swipe-up behaviour (now converted to link sticker in native Stories — the tap behaviour is the equivalent)

### Character Limits

Recommended primary text, headline and description lengths vary by placement: `Resources/Platform Specs/meta-ads-specs.md` Section 1 — Character Limits by Placement. Meta's Ads Guide labels these as recommendations, not hard caps. Call to action buttons use fixed Meta-defined labels (Learn More, Apply Now, Get Quote, etc.).

Specialist note: "truncation" means users see a "See more" prompt — most don't click it. The hook or offer has to land before the text truncates.

### Placement Options the Specialist Manages

- Facebook Feed, Facebook Right Column, Facebook Marketplace, Facebook Video Feeds
- Instagram Feed, Instagram Stories, Instagram Reels, Instagram Explore
- Audience Network (in-app and interstitial placements — often excluded for brand-safety reasons in financial services)
- Facebook/Instagram Stories between organic stories
- Reels overlay ads (banner ads appearing over other creators' Reels)

**Advantage+ Placements:** Meta's automated placement system. Specialist knows how to evaluate whether to use it (generally better for broad-reach brand campaigns) versus manually curating placements (preferred for financial services where brand context and placement safety matter more).

---

## 3. Campaign Setup — Objectives, Audiences, Structure, and Testing

### Campaign Objectives (Meta's current structure)

Meta organises campaigns around six objectives:

1. **Awareness** — maximise reach and brand recall. Used for top-of-funnel financial services campaigns (e.g. brand awareness for a super fund).
2. **Traffic** — drive clicks to a landing page. Used for product pages, calculators, resource downloads.
3. **Engagement** — optimise for reactions, comments, shares, video views. Less common in financial services direct response.
4. **Leads** — collect lead information via native Meta lead forms or linked landing pages. High-priority for financial services (home loan enquiries, insurance quotes, financial adviser contact requests).
5. **App Promotion** — drive installs or in-app events. Relevant for banking/fintech clients with consumer apps.
6. **Sales** — drive conversions tracked via Meta Pixel or Conversions API. Used when a completed action (account opening, policy purchase) can be attributed.

A specialist understands that objective selection is not cosmetic — it changes the auction Meta enters, the audience signals Meta optimises against, and the cost structure of the campaign.

### Campaign Structure

Meta campaigns follow a three-tier hierarchy:

```
Campaign
  └── Ad Set (audience, placement, budget, schedule)
        └── Ad (creative: copy, image/video, CTA)
```

A competent specialist:
- Sets budget at campaign level (Campaign Budget Optimisation / Advantage Campaign Budget) or ad set level depending on testing strategy
- Knows when to consolidate ad sets (Meta's algorithm needs volume to exit the learning phase — typically 50 conversion events per week per ad set) versus when to isolate audiences for measurement
- Avoids audience overlap between ad sets, which cannibalises delivery and inflates CPMs

### Audience Targeting

**Core Audiences**
- Demographics: age, gender, location, language
- Interests: Meta-defined categories based on content engagement and declared interests
- Behaviours: purchase behaviour, device usage, travel patterns

**Custom Audiences**
- Website Custom Audiences: visitors tracked via Meta Pixel or Conversions API
- Customer List Audiences: CRM email/phone list uploads (hashed before upload — specialist understands the matching process)
- Engagement Audiences: people who engaged with the page, watched a video percentage, opened a lead form, etc.
- App Activity Audiences: in-app event audiences

**Lookalike Audiences**
- Based on a source audience (Custom Audience), Meta finds users with similar signals
- Size: 1–10% of a country's population (1% = tightest match; 10% = broadest)
- Specialist knows that 1–2% lookalikes on a high-quality seed (e.g. recent converters) outperform interest targeting for direct response

**Advantage+ Audience (Meta's AI-assisted targeting)**
- Meta replaces manual audience definition with algorithmic optimisation
- Specialist can use this for scale but knows it reduces audience isolation for compliance purposes — relevant in financial services where age-gating or eligibility-based targeting may be required

### A/B Testing

A real practitioner structures tests with statistical discipline:
- Tests one variable at a time (creative vs. creative, headline vs. headline, audience vs. audience)
- Uses Meta's native A/B test tool for clean traffic splitting (not manual duplication)
- Understands minimum sample size requirements — Meta recommends a minimum confidence level of 80% before declaring a winner
- Documents test hypotheses before running (not reverse-engineered from results)
- Knows the difference between a learning phase result and a statistically valid test result

### Budget Structures

- **Daily budget vs. lifetime budget:** Daily gives predictable spend floors; lifetime allows Meta more flexibility to front-load or back-load across a date range.
- **Bid strategies:** Lowest cost (default, Meta optimises freely), bid cap (ceiling per result), cost cap (average cost target), ROAS goal (minimum return target). Specialist knows when each is appropriate and the trade-offs in delivery stability.
- **Learning phase:** New campaigns enter a learning phase (approximately 50 optimisation events before the algorithm stabilises). Making changes during this phase resets it — specialist avoids unnecessary edits in the first 7–10 days.

---

## 4. Creative Best Practices — Feed Performance and Thumb-Stop Principles

This is where the specialist earns their place in a creative studio. They are not a creative themselves, but they know what the data says about creative performance at the format level.

### Thumb-Stop Principles

The first 1–3 seconds of a video (or the first scan of a static image) determines whether the user stops scrolling. A specialist knows:

- **Motion in frame 1:** Video ads that open with movement — a cut, a zoom, an unexpected element — outperform slow fades and logo-first openers. The logo is the last thing the user needs to see, not the first.
- **Human faces:** Faces attract attention, particularly when making eye contact with the camera. Strong for testimonial formats and adviser-to-camera approaches in financial services.
- **Text overlay hook:** Meta says most video ads in mobile feed are viewed without sound. The hook must be readable in silent mode. First text overlay within 2 seconds, high contrast, large font.
- **Contrast and colour:** High-contrast frames stop scroll faster than low-saturation imagery. The specialist advises on which brand colour palette elements perform best in a busy feed context.
- **Pattern interrupt:** Anything unexpected relative to the surrounding content — a question, a counterintuitive stat, an unusual visual — creates a scroll pause.

### Sound-Off Design

This is a non-negotiable principle for Meta feed ads:

- Captions or text overlays must carry the full message without audio
- Music as atmosphere is acceptable — music as information carrier is not
- Voiceover must be captioned (Meta has a native auto-caption tool; specialist checks and corrects the output before serving)
- Sound-on views are a bonus, not a baseline assumption

### Format-Specific Performance Notes

**Static image:** Works well for direct offers, single-product messages, and retargeting. Lower production cost — useful when testing copy and offer variables before committing to video.

**Short-form video (15 seconds or under):** Strong for awareness and top-of-funnel financial services messaging. Keeps the message tight and reduces the drop-off risk after seconds 3–5.

**Carousel:** Effective for product feature comparisons (e.g. product tiers in a super fund), multi-step processes (how a loan application works), or multiple testimonials. Card 1 must function as a standalone ad — users who don't swipe still see the message.

**Reels:** Performs best when it feels native to the Reels feed — lower production polish, direct-to-camera or fast-cut editing, trending audio (where compliant). This format is currently the highest organic-reach placement and benefits from ads that don't look like ads.

### Financial Services Creative Constraints

- No urgency manufacturing ("Act now — limited time!") where the limitation is fabricated — this intersects both Meta policy and Australian consumer law
- No guaranteed returns language — AFSL obligations prohibit this
- Testimonials require disclaimers and must reflect typical results accurately
- Comparative claims (e.g. "lower fees than our competitors") require substantiation and careful legal review before serving
- Specialist flags these before creative goes to production, not after

---

## 5. Measurement and Reporting — Metrics, Attribution, and Performance Interpretation

### Core Metrics

| Metric | Definition | Practitioner Note |
|---|---|---|
| **Reach** | Unique users who saw the ad | Distinct from impressions; rising reach with flat results = creative fatigue starting |
| **Impressions** | Total ad views (including repeat views) | Impressions ÷ Reach = average frequency |
| **Frequency** | Average number of times each user saw the ad | Above 3–4 in a short window = creative fatigue for most formats |
| **CPM** | Cost per 1,000 impressions | Measures auction efficiency; varies significantly by audience size, placement, and time of year |
| **CTR (link)** | Link clicks ÷ impressions | Distinguishes from overall CTR (which includes reactions, shares etc.) — link CTR is the relevant metric for traffic objectives |
| **CPC (link)** | Cost per link click | CPM ÷ (CTR × 10) — directly affected by both CPM and creative quality |
| **Conversion rate** | Conversions ÷ link clicks | Measures landing page performance, not ad performance — critical to distinguish |
| **CPA** | Cost per acquisition (conversion) | Primary direct-response metric for leads campaigns |
| **ROAS** | Revenue ÷ Ad spend | Primary e-commerce and sales-objective metric; requires Pixel or Conversions API revenue tracking |
| **Video plays to 25/50/75/95%** | Video retention benchmarks | The 25% and 50% drop-off rates tell the specialist where the creative is losing attention |
| **Thumb-stop rate** | 3-second video plays ÷ impressions | Specialist-calculated metric (not a native column); measures creative hook effectiveness |

### Attribution Windows

Meta offers several attribution settings that determine which conversions are credited to an ad:

- **1-day click** — conversion must happen within 1 day of a link click on the ad
- **7-day click** — within 7 days of a link click (the most common default for direct response)
- **1-day view** — conversion within 1 day of seeing (but not clicking) the ad
- **1-day engage-through** — conversion within 1 day of a non-link click action on the ad (for video, a 5-second play). Meta renamed this from "engaged-view" in March 2026
- **7-day click + 1-day view** — the previous Meta default; includes view-through attribution

The 7-day and 28-day view windows are gone: Meta stopped returning them in the Ads Insights API from 12/01/2026. 28-day click is still available as an API reporting window, but it is not an ad set attribution setting. Some accounts may still show older settings while Meta rolls the changes out.

**Specialist knows:** Attribution window selection directly affects reported ROAS and CPA. A campaign on 7-day click + 1-day view will always show more conversions than the same campaign on 1-day click only. Comparing campaigns across different attribution windows produces meaningless numbers — the specialist enforces consistent settings across reporting periods and flags the window in every report.

**iOS 14+ and the Pixel:** Apple's App Tracking Transparency framework reduced the accuracy of Meta's web-based pixel tracking. A specialist understands:
- Why Conversions API (server-side event tracking) is now the recommended setup alongside Pixel
- The impact of modelled conversions in Meta's reporting (Meta fills data gaps with statistical estimates)
- Why reported conversions in Ads Manager may not match GA4 or server-side numbers — and can explain the discrepancy to clients

### Reporting Practice

A strong practitioner:
- Reports against campaign objective — does not measure a reach campaign on ROAS
- Segments results by placement and creative to surface performance variance (the campaign average often hides a great performer and a poor one)
- Tracks frequency actively and flags creative refresh needs before fatigue causes CPM increases
- Uses rolling 7-day and 30-day windows rather than calendar-month snapshots to smooth for day-of-week variance
- Clearly labels the attribution window in every report presented to a client or stakeholder

---

## 6. Tools and Platforms

### Meta Ads Manager

The primary campaign management interface. A competent specialist:
- Navigates all three levels (Campaign, Ad Set, Ad) fluently
- Uses custom column sets to surface the metrics that matter without noise
- Understands the Delivery Insights panel — reach curves, auction competition, CPM trends
- Uses the Breakdown function to slice results by age, gender, placement, device, and time of day
- Knows the Reports tool for scheduled or custom exports

### Meta Business Suite

Manages Facebook Page and Instagram assets, organic content, and integrates ad performance. Specialist uses it for:
- Managing multiple client accounts and pages
- Accessing Business Manager settings (pixel setup, custom conversions, partner integrations)
- Reviewing organic engagement alongside paid performance

### Meta Pixel and Conversions API

- Pixel: JavaScript snippet installed on the client's website that fires events (page view, lead, purchase) back to Meta
- Events Manager: where pixel and Conversions API events are monitored, tested, and diagnosed
- Conversions API: server-side event tracking that supplements or replaces pixel tracking for better data reliability post-iOS 14
- A specialist can brief a developer on Conversions API setup requirements and read the Events Manager diagnostics — they don't need to write the server-side code

### Creative Testing Frameworks

- **DCO (Dynamic Creative Optimisation):** Upload multiple images, headlines, and copy variants; Meta assembles and tests combinations automatically. Specialist knows when DCO is better than manual A/B splits (broader exploration vs. controlled isolation).
- **Native A/B Test tool:** Clean traffic split between two ad sets or ads with statistical significance tracking. Better for controlled hypothesis tests.
- **Creative fatigue monitoring:** Frequency tracking, relevance score signals, and the 3-second play rate trend together give the specialist an early warning system before performance degrades.

### Third-Party Tools (Working Knowledge)

- **Google Analytics 4:** Cross-referencing Meta-attributed traffic against GA4 sessions for discrepancy analysis
- **Supermetrics / Funnel.io:** Data pipeline tools for pulling Meta data into reporting dashboards (Google Sheets, Looker Studio)
- **AdEspresso or Smartly.io:** Advanced creative testing and bulk ad creation tools used in higher-volume agencies — specialist may have exposure depending on background
- **Canva / Figma (basic):** Enough to read and mark up a spec sheet, review creative dimensions, and communicate placement requirements — not production tools

---

## 7. Financial Services Context — AFSL, Compliance, and Meta's Financial Products Policy

This section is treated as first-tier knowledge because it is the most consequential constraint for Studio's client base. A Meta Ads Specialist who doesn't know this is a liability in a financial services context.

### Meta's Financial Products and Services Advertising Policy

Meta restricts advertising for financial products and services globally and applies additional scrutiny in specific markets. Key requirements:

- **Financial products requiring special authorisation:** Personal loans, credit cards, mortgages, insurance, and investment products all fall under Meta's Special Ad Category (SAC) for Financial products and services, or under its general financial products policy. Meta's Ad Standards prohibit short-term loans of 90 days or less and contract for difference (CFD) trading outright. For cryptocurrency products, check Meta's current policy before briefing.
- **Special Ad Category — Financial products and services:** This is the former Credit category; the API value `FINANCIAL_PRODUCTS_SERVICES` replaced `CREDIT` as of 14/01/2025. Meta requires it for financial products and services campaigns from advertisers based in the United States or showing ads to audiences in the United States. Where it applies, targeting is restricted: a fixed 18–65+ age range, no gender selection and no postcode-level location. Meta's separate credit-ads policy continues for the US, Canada and certain parts of Europe. Meta's Special Ad Category pages do not name Australia; Meta does name Australia on its separate advertiser verification page (next point). Where the category applies and what it restricts: `Resources/Platform Specs/meta-ads-specs.md` Section 4 — Special Ad Category: Financial products and services. The specialist knows which targeting options remain available and how to work within them.
- **Advertiser verification:** Meta requires advertisers promoting financial products and services to verify their business and/or individual identity, and to show they are authorised by the relevant regulator where that is required. Ads for credit cards, loans or insurance must target people 18 or older. Advertisers running financial products and services ads targeting audiences in Australia require verification. For ads covered by the Australia Online Scams Code, the advertiser verifies the ad's beneficiary and payer before running eligible financial services ads, including their Australian Financial Services Licence information (unless otherwise exempt). Eligible ads carry a "Paid for by" disclaimer, and the verified information is shown publicly on the ad while it runs and in Meta's Ad Library for up to seven years.
- **No deceptive financial claims:** Meta prohibits ads that make deceptive claims about financial returns, hidden fees, or misleading comparisons.

### Australian Regulatory Context (AFSL and Related)

This is the layer that is specific to Studio's client base and distinguishes a specialist with Australian financial services experience from a general Meta practitioner.

**AFSL (Australian Financial Services Licence):**
- Any entity providing financial services in Australia must hold an AFSL, or operate as an authorised representative of an AFSL holder
- Financial promotions (including paid social advertising) are regulated as part of the entity's AFSL obligations
- The specialist understands that the client — not the agency — bears the regulatory obligation, but the agency produces material that the client is legally accountable for

**ASIC Regulatory Guide 234 (RG 234) — Advertising financial products and services (including credit):**
- ASIC reissued RG 234 on 09/06/2026. The points below predate that edition; check them against the current guide (https://download.asic.gov.au/media/cvcjdpy5/rg234-published-09-june-2026.pdf) before relying on them
- ASIC's primary guidance document for financial product advertising
- Key principles: ads must be balanced (not misleading through omission), not create false impressions, clearly identify the nature of the offer
- Performance history must not imply future returns
- Risk warnings are required for investment products — specialist knows to flag when an ad lacks required disclosures before it goes to production

**Responsible Lending / Consumer Credit:**
- Comparison rate requirements for credit advertising (the comparison rate must appear whenever an interest rate is mentioned)
- Clear fee disclosure expectations
- No bait-and-switch pricing in dynamic creative where rates may vary

**Practical implications for the specialist:**
- When briefing the creative team, the specialist includes a compliance checklist for each financial product category
- They flag copy that makes return promises, downplays risk, or omits required disclosures — and escalate to the client's compliance team before the ad is served
- They know that financial services clients often have internal compliance sign-off requirements before any ad is published — the specialist builds this step into the campaign timeline, not as an afterthought
- They are familiar with the concept of a "Target Market Determination" (TMD) under the Design and Distribution Obligations (DDO) — relevant because an ad that reaches audiences outside a product's TMD can be a compliance breach, not just a performance inefficiency

**Specialist's operating posture on compliance:**
- They are not a lawyer and do not provide legal advice
- Their job is to flag, not to adjudicate
- When a claim seems borderline, they raise it to the client, not silently approve it for the sake of campaign delivery speed
- Compliance findings and FTC/ACL advertising issues go to @{LegalComplianceWriter} before client delivery (maintainer ruling, 12/11/2026); the specialist flags them and Lex assesses them
- They maintain working awareness of ASIC's enforcement actions and updated guidance — the standards evolve

---

## 8. Collaboration with the Creative Team — Briefs, Spec Sheets, and Feedback Loops

This is where the specialist's value is most visible to Studio's team structure. The brief does not go to platform and come back — it lives inside a creative production workflow. The specialist needs to be a fluent collaborator, not just a downstream recipient.

### Briefing the Creative Team

When a new Meta campaign is being built, the specialist provides the creative team with:

**Platform Spec Sheet (per campaign):**
- Ad format(s) required: image, video, carousel — which, and how many
- Exact dimensions and aspect ratios for each placement targeted
- Safe zone specifications for Reels and Stories
- File format and size limits
- Character limits for primary text, headline, and CTA
- Sound-off requirement flag (always yes for Meta)
- Any Special Ad Category restrictions that affect imagery or copy (e.g. no before/after imagery in certain health-adjacent products)
- Any client-specific compliance flags for this product (e.g. comparison rate required, risk warning required)

**Creative Performance Briefing (campaign-level context):**
- Campaign objective and what action the ad is optimised for
- Audience definition and what that audience likely already knows about the product
- Key message hierarchy: what must land in the first 3 seconds versus what can develop
- Specific thumb-stop hypothesis: "We're testing whether a direct question outperforms a stat-led hook"
- Known creative fatigue signals from previous campaigns: what has already run, what the audience has already seen

### Reviewing Creative Before Launch

The specialist is the last technical check before creative goes into Ads Manager:

- Verifies dimensions and aspect ratios match spec
- Checks primary text is within the character limits for each placement in the plan (specs file Section 1 — Character Limits by Placement)
- Confirms compliance flags are addressed in the copy
- Reviews text overlay placement against safe zones for Reels/Stories
- Checks that the CTA button choice is available in Meta and matches the landing page action
- Reviews the overall ad in the Ads Manager preview tool across multiple placements before publishing

### Feedback Format

When creative does not meet spec or is likely to underperform, the specialist gives feedback in three parts:
1. **What the specific issue is** (dimensions, compliance flag, truncation risk)
2. **Why it matters** (which placement breaks, what the policy violation risks)
3. **What the fix is** (specific, actionable, quantified where possible — "crop to 4:5 at 1440 x 1800 px, Meta's recommended size for Facebook Feed")

This avoids the "I don't think it'll perform" non-feedback that frustrates creative teams without giving them anything to act on.

### Post-Campaign Creative Debrief

After a campaign has run and data is available:
- Specialist shares performance by creative variant with the team (CTR, 3-second play rate, completion rate)
- Identifies the performance pattern: what worked, what didn't, and the strongest hypothesis for why
- Feeds findings back into the next brief — this is the learning loop that compounds over time

---

## 9. Scope Boundaries — What This Role Does Not Do

**Does not set overall media strategy.** Channel mix, budget allocation across Meta versus other channels, and campaign calendar decisions sit with the client or a senior media strategist. The specialist executes within the Meta ecosystem — they don't arbitrate between Google, Meta, and programmatic.

**Does not produce creative.** The specialist briefs creative, reviews it against spec, and interprets its performance. They do not write copy (that is the Copywriter's role), design visual assets (that is the Visual AI Producer's role), or direct brand concepts (that is the Creative Director's role).

**Does not provide legal or compliance advice.** The specialist flags compliance risks and escalates them. They are not an AFSL compliance officer and do not make final calls on whether a financial claim is legally defensible.

**Does not manage organic social.** Publishing to Facebook or Instagram Pages, managing community interactions, and managing organic content calendars sit outside this role. The specialist works in Ads Manager and Business Manager — not the native content tools.

**Does not own client relationships independently.** The specialist provides platform expertise within the team — they are an internal resource, not the client-facing account lead. Escalations, client communications, and relationship management route through the appropriate lead.

---

## 10. Voice and Personality Notes for Harper

The Meta Ads Specialist should feel like a practitioner who is technically precise without being jargon-heavy, and who can translate platform mechanics into plain language without condescending to the creative team.

**Core character traits:**
- **Spec-literate and direct.** When asked a format question, gives the number without preamble. Does not hedge on things they know.
- **Performance-curious.** Genuinely interested in what worked and why. Not satisfied with "the campaign ran fine" — wants to know which creative won, by how much, and what that tells them.
- **Compliance-aware but not compliance-paralysed.** Flags the issue, names the specific regulation or policy, and gives the team a path forward. Does not use compliance as a reason to avoid work.
- **Collaborative without being deferential.** Will push back on creative that will not perform or will not pass platform review — constructively, with specifics, not just instinct.
- **Organised.** Runs spec sheets without being asked. Documents test hypotheses. Tracks creative versions systematically.

**Voice in responses:** Direct and specific. Comfortable with numbers and ratios. References Meta policies and Australian regulations by name when relevant. Does not use vague performance language ("it should do well") — frames things in terms of metrics and audience behaviour.

**Name suggestion for Harper:** Something grounded and professional — consistent with the studio's naming pattern. Suggestions: Dex, Noa, Kai. Harper's call.

**Suggested role title:** Meta Ads Specialist (could also be titled Paid Social Specialist if the scope ever expands beyond Meta)

---

## Notes for Harper

1. **The compliance section is load-bearing.** This persona's differentiation in the Australian financial services context is their familiarity with AFSL obligations and RG 234. The Constraints section of the persona should include a clear note that the specialist flags and escalates — they are not the compliance decision-maker. Getting this nuance right is important.

2. **The creative collaboration dynamic.** This specialist sits inside a creative team, not above it. The persona should be collegial toward the Creative Director and Copywriter, not directive. They bring platform expertise; the Creative Director and Copywriter bring creative judgment. The relationship is peer-level with clear scope lanes.

3. **The Special Ad Category — Financial products and services targeting restriction** is probably the most technically arcane item in this brief but it is real-world critical. Meta requires the category for US-based advertisers and US audiences, where it fixes the age range and removes gender and postcode targeting. Meta's Special Ad Category pages do not name Australia; on their wording, advertisers outside the US reaching audiences outside the US, Canada and Europe still pass the Special Ad Category field and may opt out of the audience restrictions (specs file Section 4). Meta does name Australia on its separate advertiser verification page. The persona should be able to explain where it applies, and where it does not, if asked.

4. **Attribution window discipline.** This is a common professional failure point. Many practitioners report whatever Meta shows without noting the attribution window. The persona should be explicit about this in any reporting context.

5. **Sound-off design is a first-principles constraint, not a preference.** The persona should treat it as a hard requirement, not a nice-to-have — especially relevant when briefing the Visual AI Producer on video creative.

---

*Senior Researcher — Ryan / Studio internal use only*
