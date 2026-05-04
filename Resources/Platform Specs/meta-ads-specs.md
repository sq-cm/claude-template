# Meta Ads Platform Specs

**Owner:** Luca — Meta Ads Specialist
**Last full review:** 2026-05-02
**Verify against:** [Meta Business Help Center](https://www.facebook.com/business/help) before every new campaign goes into production. Specs change without notice.

---

## Section 1 — Character Limits by Placement

Last verified: 2026-05-02

Meta truncates text differently per placement and device. The limits below are the recommended maximums — not hard character caps. Exceeding them does not prevent delivery, but text will be truncated with a "See more" prompt, reducing scannability.

| Placement | Primary Text (recommended) | Headline | Description | Notes |
|---|---|---|---|---|
| Facebook Feed | 125 chars | 27 chars | 25 chars | Headline limit tighter here than other placements. Description rarely shown on mobile. |
| Instagram Feed | 125 chars | 40 chars | 25 chars | Description not displayed. Headline shows below image/video. |
| Instagram Reels | 125 chars | 10 chars (overlay) | — | Overlay headline sits over creative. Keep it to a single short phrase. |
| Facebook Reels | 125 chars | 10 chars (overlay) | — | Same overlay constraint as Instagram Reels. |
| Facebook Stories | 125 chars | 40 chars | — | Text overlaid on creative. Safe zone critical — see Section 2. |
| Instagram Stories | 125 chars | 40 chars | — | Text overlaid on creative. Safe zone critical — see Section 2. |
| Marketplace | 125 chars | 40 chars | 25 chars | Description is reliably displayed here. Use it. |
| Audience Network | 125 chars | 40 chars | 25 chars | Description shown in interstitial and banner formats. |
| Search Results | 125 chars | 40 chars | 25 chars | Description shown. Treat as a standalone unit — copy must work without visual context. |
| In-Stream Video | 125 chars | 40 chars | 25 chars | Description shown. Pre-roll placement — viewer is about to watch something else. |

**Key rules:**
- Primary text truncates after ~125 characters on mobile with a "See more" prompt. Lead with the most critical information.
- Facebook Feed headline cap is 27 characters — this is tighter than every other placement. Build headlines to 27 first, then extend for other placements if needed.
- Reels overlay headlines are 10 characters maximum. These are badges, not sentences.
- Description (25 chars) is only reliably displayed in: Marketplace, Search Results, In-Stream Video, Audience Network. Do not rely on description for message delivery in Feed or Stories.

---

## Section 2 — Image and Video Specs

Last verified: 2026-05-02

### Feed — Static Image

| Format | Dimensions | Aspect Ratio | File Type | Max File Size |
|---|---|---|---|---|
| Square (recommended) | 1080 x 1080 px | 1:1 | JPG, PNG | 30 MB |
| Landscape | 1200 x 628 px | 1.91:1 | JPG, PNG | 30 MB |
| Portrait | 1080 x 1350 px | 4:5 | JPG, PNG | 30 MB |

Portrait (4:5) takes up the most vertical real estate in Feed and is the recommended default for mobile-first campaigns.

### Feed — Video

| Format | Dimensions | Aspect Ratio | File Type | Max File Size | Min Length | Max Length |
|---|---|---|---|---|---|---|
| Square | 1080 x 1080 px | 1:1 | MP4, MOV | 4 GB | 1 sec | 241 min |
| Portrait | 1080 x 1350 px | 4:5 | MP4, MOV | 4 GB | 1 sec | 241 min |
| Landscape | 1280 x 720 px | 16:9 | MP4, MOV | 4 GB | 1 sec | 241 min |

Recommended video bitrate: 4 Mbps+. H.264 codec. Stereo AAC audio at 128 kbps+.

### Stories and Reels — Image and Video

| Spec | Value |
|---|---|
| Dimensions | 1080 x 1920 px |
| Aspect ratio | 9:16 |
| File type | JPG, PNG (image) / MP4, MOV (video) |
| Max image file size | 30 MB |
| Max video file size | 4 GB |
| Video length (Stories) | 1–15 sec per card |
| Video length (Reels) | 3 sec–15 min |

**Safe zones — critical for Stories and Reels:**
- Keep all text and key visual elements within the safe zone: no closer than 14% from the top edge and no closer than 14% from the bottom edge.
- Top 14% is occupied by the profile name/CTA bar. Bottom 14% is occupied by the CTA button.
- In practice: on a 1920px tall canvas, the safe zone runs from approximately 269 px from top to 269 px from bottom (leaving a safe area of roughly 1382 px).
- Do not place logos, product names, disclaimers, or calls to action outside this zone — they will be clipped or obscured by UI chrome.

### Carousel

| Spec | Value |
|---|---|
| Min cards | 2 |
| Max cards | 10 |
| Image dimensions per card | 1080 x 1080 px (1:1) |
| File type | JPG, PNG, MP4, MOV |
| Max image file size per card | 30 MB |
| Max video file size per card | 4 GB |
| Headline per card | 40 chars |
| Description per card | 20 chars |
| URL per card | Required — each card can link independently |

Cards are swiped left to right. The first card carries the most weight — treat it as the hero. Each subsequent card can deepen the story or showcase individual products/features.

### Text on Creative — 20% Rule

The 20% image text rule is no longer enforced by Meta. Ads with heavy text will not be rejected outright. However, Meta's delivery algorithm still penalises creative with excessive text overlay — reach and frequency will be suppressed. Keep text on creative minimal; rely on the copy fields for messaging.

---

## Section 3 — Creative Best Practices

Last verified: 2026-05-02

### Sound-Off Default

Approximately 85% of Facebook and Instagram video plays muted by default. For Reels and Stories, assume no audio is heard on first impression.

- Subtitle all spoken dialogue. Use Meta's auto-caption tool as a starting point but always review the output.
- Do not rely on a voiceover to deliver a key message. The visual and text overlay must carry the full story independently.
- Use music as atmosphere only — the ad must work completely without it.

### Thumb-Stop: First 2 Seconds

The first 2 seconds determine whether a viewer keeps scrolling. These principles apply across all video placements:

- Lead with motion, contrast, or a face — not a logo card.
- Put the brand or product visible within the first second, not at the end.
- Avoid slow fades or intros. Cut straight to the hook.
- On Reels, consider starting mid-action rather than at the setup — viewers are trained to swipe fast.
- Text overlays in the first 2 seconds should be minimal (one short phrase), high contrast, and large enough to read at a glance.

### Safe Zones

Detailed dimensions in Section 2. General principle: any element that must be read (headline, disclaimer, CTA, price, product name) must sit within the safe zone. Design templates should bake the safe zone boundaries in as guides, not apply them as an afterthought.

### Carousel Card Logic

- Card 1: Hook. Product hero or lead value proposition. This is what users see before swiping.
- Cards 2–8: Supporting proof. Features, benefits, testimonials, or individual products.
- Last card: CTA. Reinforce the offer and drive action. Meta will display a "See all" card at the end automatically — do not design a separate end card for this.
- Each card should make sense in isolation. Users do not always swipe through in order.
- Consistent visual treatment across cards improves brand recall and perceived quality.

---

## Section 4 — Financial Services Constraints on Meta

Last verified: 2026-05-02

### Special Ad Category: Credit

Any ad for credit products — including home loans, personal loans, car finance, credit cards, buy-now-pay-later, and debt management services — must be declared under the **Credit** Special Ad Category in Ads Manager.

Failure to declare results in: ad rejection, account flag, potential account restriction.

**What the Credit Special Ad Category restricts:**

| Targeting capability | Status under Credit category |
|---|---|
| Age targeting | Removed. Ads deliver to all eligible adults (18+). |
| Gender targeting | Removed. Ads deliver to all genders. |
| Postcode / zip code exclusions | Removed. Geographic targeting is limited to radius-based only. |
| Lookalike audiences | Restricted to Special Ad Audiences — a modified lookalike that strips restricted signals. |
| Detailed interest targeting | Many financial behaviour and demographic interests are unavailable. |
| Custom audiences from data | Allowed, but cannot be used to exclude based on prohibited criteria. |

**Practical implications:**
- Do not build audience strategy assuming fine-grained demographic targeting. The Credit category will override it.
- Special Ad Audiences replace standard Lookalikes. Build these from your best-performing customer lists and allow for a broader reach profile.
- Geographic targeting must use radius targeting (e.g., 50 km around a city), not postcode lists or exclusion zones.

### What Financial Product Ads Cannot Do on Meta

- Cannot target or exclude based on age, gender, or postcode for credit products.
- Cannot use Detailed Targeting options that infer financial vulnerability or demographic characteristics that act as proxies for protected attributes.
- Cannot run without a Special Ad Category declaration if the product is a credit product. Attempting to run without it is a policy violation, not just a risk.
- Cannot suppress delivery to users based on protected characteristics via audience exclusions.

### AFSL Compliance Overlay

All ads for financial products regulated under an Australian Financial Services Licence must carry the required disclaimer in the ad creative. Meta's character limits do not exempt an ad from compliance requirements.

**Key considerations for layout:**

- The AFSL disclaimer (e.g., "General advice only. Consider your circumstances before acting.") must appear in the visible text area — not buried in landing page copy.
- For static image and carousel ads, the disclaimer typically sits in the Primary Text field. Plan the character budget: 125-char recommended limit means a 60-character disclaimer leaves 65 characters for the message.
- For video ads, the disclaimer must be visible on-screen. Overlay text in the safe zone, held for long enough to be readable (minimum 3 seconds).
- For Stories and Reels, the disclaimer must sit within the safe zone. This is a layout constraint — design it in from the start.
- The disclaimer must not be obscured by UI chrome, CTA buttons, or profile elements.

**Budget the disclaimer first.** In all copy-writing for financial products, write the disclaimer before the headline. What remains is the copy budget. This avoids layouts that technically include the disclaimer but render it illegible.

---

## Section 5 — Update Log

Append new entries at the bottom. Do not edit previous entries.

| Date | What changed | Source |
|---|---|---|
| 2026-05-02 | Document created. Initial spec set covering character limits, image/video specs, creative best practices, financial services constraints. | Meta Business Help Center + Luca review |

---

*Meta Ads Specialist — Luca / Studio internal use only / Last full review: 2026-05-02*
