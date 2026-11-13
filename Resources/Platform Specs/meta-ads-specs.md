# Meta Ads Platform Specs

**Owner:** Luca — Meta Ads Specialist
**Last full review:** 2026-11-13 (AFSL overlay excluded)
**Verify against:** [Meta Ads Guide (Facebook Feed image page)](https://www.facebook.com/business/ads-guide/update/image/facebook-feed) (placement-level specs) and [Meta Business Help Centre](https://www.facebook.com/business/help) before every new campaign goes into production. Specs change without notice.

---

## Section 1 — Character Limits by Placement

Last verified: 2026-11-13

Sources:
- https://www.facebook.com/business/ads-guide/update/image/facebook-feed
- https://www.facebook.com/business/ads-guide/update/video/facebook-feed
- https://www.facebook.com/business/ads-guide/update/image/facebook-feed/traffic
- https://www.facebook.com/business/ads-guide/update/image/facebook-feed/outcome-sales
- https://www.facebook.com/business/ads-guide/update/image/facebook-feed/outcome-leads
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-feed
- https://www.facebook.com/business/ads-guide/update/image/instagram-feed
- https://www.facebook.com/business/ads-guide/update/video/instagram-feed
- https://www.facebook.com/business/ads-guide/update/carousel/instagram-feed
- https://www.facebook.com/business/ads-guide/update/image/instagram-reels
- https://www.facebook.com/business/ads-guide/update/video/instagram-reels
- https://www.facebook.com/business/ads-guide/update/image/facebook-facebook-reels
- https://www.facebook.com/business/ads-guide/update/video/facebook-facebook-reels
- https://www.facebook.com/business/ads-guide/update/image/facebook-facebook-reels-overlay
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-facebook-reels-overlay
- https://www.facebook.com/business/ads-guide/update/image/facebook-story
- https://www.facebook.com/business/ads-guide/update/video/facebook-story
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-story
- https://www.facebook.com/business/ads-guide/update/image/instagram-story
- https://www.facebook.com/business/ads-guide/update/video/instagram-story
- https://www.facebook.com/business/ads-guide/update/carousel/instagram-story
- https://www.facebook.com/business/ads-guide/update/image/facebook-marketplace
- https://www.facebook.com/business/ads-guide/update/video/facebook-marketplace
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-marketplace
- https://www.facebook.com/business/ads-guide/update/image/audience-network-native
- https://www.facebook.com/business/ads-guide/update/video/audience-network-native
- https://www.facebook.com/business/ads-guide/update/carousel/audience-network-native
- https://www.facebook.com/business/ads-guide/update/image/facebook-search
- https://www.facebook.com/business/ads-guide/update/video/facebook-search
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-search
- https://www.facebook.com/business/ads-guide/update/image/facebook-instream-video
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-instream-video
- https://developers.facebook.com/docs/marketing-api/ad-creative/asset-feed-spec/options/

The Ads Guide labels these figures "Text recommendations". They are not hard character caps. Meta truncates text differently per placement and device; exceeding the figures does not prevent delivery, but text is truncated with a "See more" prompt, reducing scannability (this sentence: reported, unconfirmed). The Marketing API does set hard maximums for asset feed creatives: 255 characters for title and description text, 1,024 for body text.

Where the Ads Guide lists no value for a field, the earlier figure is kept and marked "(reported, unconfirmed)".

| Placement | Primary Text (recommended) | Headline | Description | Notes |
|---|---|---|---|---|
| Facebook Feed | 50–150 chars (image, video) | 27 chars (image, video; carousel: see Section 2) | 25 chars (reported, unconfirmed) | Meta gives a range, not a single figure. Description rarely shown on mobile (reported, unconfirmed). |
| Instagram Feed | 125 chars | 40 chars (image; none listed for video or carousel) | 25 chars (reported, unconfirmed) | Description not displayed (reported, unconfirmed). Headline shows below image/video (reported, unconfirmed). |
| Instagram Reels | 44 chars | 10 chars (overlay) (reported, unconfirmed; the Ads Guide lists no headline and no Instagram overlay placement) | — | Overlay headline sits over creative (reported, unconfirmed). Keep it to a single short phrase. |
| Facebook Reels | 40 chars (Reels placement); 60 chars ("Ads on Facebook Reels" overlay) | 55 chars (Reels placement); 10 chars (overlay, image and carousel) | — | Meta describes overlay ads as single static image ads on Reels content; the Ads Guide also lists a carousel overlay. Same overlay constraint as Instagram Reels (reported, unconfirmed). |
| Facebook Stories | 125 chars | 40 chars | — | Text overlaid on creative (reported, unconfirmed). Safe zone critical — see Section 2. |
| Instagram Stories | 125 chars | 40 chars (carousel; reported, unconfirmed for image and video) | — | Text overlaid on creative (reported, unconfirmed). Safe zone critical — see Section 2. |
| Marketplace | 125 chars | 40 chars (image, carousel); 25 chars (video) | 30 chars (image); 20 chars (carousel) | Description is reliably displayed here. Use it. |
| Audience Network | 125 chars | 40 chars | 30 chars (image, video); 20 chars (carousel) | Description shown in interstitial and banner formats (reported, unconfirmed). |
| Search Results | 125 chars | 40 chars | 30 chars (image, video); 20 chars (carousel) | Description shown. Treat as a standalone unit — copy must work without visual context. |
| In-Stream Video | 125 chars | 40 chars | 30 chars (image, carousel); none listed for video | Description listed for image and carousel ads. Pre-roll placement, so the viewer is about to watch something else (reported, unconfirmed). |

**Key rules:**
- Primary text truncates after ~125 characters on mobile with a "See more" prompt (reported, unconfirmed; Meta gives no truncation point, and Facebook Feed now recommends 50–150). Lead with the most critical information.
- Facebook Feed headline recommendation is 27 characters (image and video). It is not the tightest placement: the Ads Guide lists 10 for the "Ads on Facebook Reels" overlay, 20 for Facebook Feed carousel cards and 25 for Marketplace video. Build headlines to the tightest placement in the plan first, then extend.
- The "Ads on Facebook Reels" overlay headline recommendation is 10 characters (image and carousel). The Ads Guide lists no Instagram Reels headline. These are badges, not sentences.
- Description (Ads Guide: 30 characters for single image and video, 20 or 18 for carousel cards) is listed by the Ads Guide for single-image ads only on: Marketplace, Search Results, In-Stream Video, Audience Network. Do not rely on description for message delivery in Feed or Stories.

---

## Section 2 — Image and Video Specs

Last verified: 2026-11-13

Sources:
- https://www.facebook.com/business/ads-guide/update/image/facebook-feed
- https://www.facebook.com/business/ads-guide/update/video/facebook-feed
- https://www.facebook.com/business/ads-guide/update/image/instagram-feed
- https://www.facebook.com/business/ads-guide/update/image/instagram-story
- https://www.facebook.com/business/ads-guide/update/video/instagram-story
- https://www.facebook.com/business/ads-guide/update/video/facebook-story
- https://www.facebook.com/business/ads-guide/update/video/instagram-reels
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-feed
- https://www.facebook.com/business/ads-guide/update/carousel/instagram-feed
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-marketplace
- https://www.facebook.com/business/help/103816146375741
- https://www.facebook.com/business/help/980593475366490
- https://www.facebook.com/business/help/1114358518575630
- https://www.facebook.com/business/help/1673124359666694
- https://www.facebook.com/business/ads/photo-ad-format

### Feed — Static Image

| Format | Dimensions | Aspect Ratio | File Type | Max File Size |
|---|---|---|---|---|
| Square | 1080 x 1080 px (reported, unconfirmed) | 1:1 | JPG, PNG | 30 MB |
| Landscape | 1200 x 628 px (reported, unconfirmed) | 1.91:1 | JPG, PNG | 30 MB |
| Portrait (recommended for Facebook Feed) | 1440 x 1800 px recommended (minimum 600 x 750 px) | 4:5 | JPG, PNG | 30 MB |

Portrait (4:5) takes up the most vertical real estate in Feed (reported, unconfirmed) and is Meta's recommended ratio for Facebook Feed single-image ads. For Instagram Feed single-image ads, Meta's sources disagree: Help Centre: 1:1 recommended; Ads Guide (Instagram Feed image): 4:5.

### Feed — Video

| Format | Dimensions | Aspect Ratio | File Type | Max File Size | Min Length | Max Length |
|---|---|---|---|---|---|---|
| Square | 1080 x 1080 px (reported, unconfirmed) | 1:1 | MP4, MOV, GIF | 4 GB | 1 sec | 241 min |
| Portrait | 1440 x 1800 px (recommended) | 4:5 | MP4, MOV, GIF | 4 GB | 1 sec | 241 min |
| Landscape | 1280 x 720 px (reported, unconfirmed) | 16:9 (reported, unconfirmed for Feed) | MP4, MOV, GIF | 4 GB | 1 sec | 241 min |

Recommended video bitrate: 4 Mbps+ (reported, unconfirmed). H.264 codec. Stereo AAC audio at 128 kbps+.

### Stories and Reels — Image and Video

| Spec | Value |
|---|---|
| Dimensions | 1440 x 2560 px (recommended) |
| Aspect ratio | 9:16 |
| File type | JPG, PNG (image) / MP4, MOV, GIF (Stories video) / MP4, MOV (Reels video) |
| Max image file size | 30 MB |
| Max video file size | 4 GB |
| Video length (Facebook Stories) | 1 sec–3 min. Videos longer than 15 sec are split into separate Stories cards. |
| Video length (Instagram Stories) | 1 sec–60 min. Videos under 16 sec play in full; 16 sec or longer may be split into separate Stories cards. |
| Video length (Instagram Reels) | 0 sec–15 min |

**Safe zones — critical for Stories and Reels:**
- Keep all text and key visual elements within the safe zone: leave roughly 14% of the top, 35% of the bottom and 6% on each side free from text, logos or other key creative elements.
- The top margin is occupied by the profile name/CTA bar and the bottom margin by the CTA button (reported, unconfirmed). Meta names the profile icon and call to action as the UI that can cover key elements, without assigning them to an edge.
- In practice: on a 1440 x 2560 px canvas, the safe zone starts about 358 px from the top, ends 896 px from the bottom and sits about 86 px in from each side, leaving a safe area of roughly 1267 x 1306 px.
- Do not place logos, product names, disclaimers, or calls to action outside this zone — they will be clipped or obscured by UI chrome.
- For Reels ads that include disclaimers, Meta says to leave the bottom 40% free from text, logos and other key creative elements.

### Carousel

| Spec | Value |
|---|---|
| Min cards | 2 |
| Max cards | 10 (Facebook and Instagram Feed). Help Centre: 3 for Instagram Stories. |
| Image dimensions per card | Meta sources disagree. Ads Guide (Facebook Feed): at least 1080 x 1080 px, 1:1. Help Centre: 1,024 x 1,024 px recommended, 500 x 500 px minimum (1:1); Facebook also accepts 4:5 or 9:16. Instagram Feed (Ads Guide): 4:5 for image-only carousels, 1:1 for carousels containing video. |
| File type | JPG, PNG, MP4, MOV, GIF |
| Max image file size per card | 30 MB |
| Max video file size per card | 4 GB |
| Headline per card | Meta sources disagree. Help Centre: 40 chars (Facebook, Messenger, Audience Network). Ads Guide varies by placement: 40 (Marketplace, Search, Audience Network native, Facebook and Instagram Stories, In-stream); 20 (Facebook Feed); 10 ("Ads on Facebook Reels" overlay); none listed (Instagram Feed, Facebook Reels, Instagram Reels). |
| Description per card | Meta sources disagree. Help Centre: 25 chars link description (Facebook, Messenger, Audience Network). Ads Guide varies by placement: 20 (Marketplace, Search, Audience Network native); 18 (Facebook Feed); 30 (In-stream); none listed (Stories, Instagram Feed, Reels). |
| URL per card | Required — each card can link independently |

Cards are swiped left to right. The first card carries the most weight — treat it as the hero. Each subsequent card can deepen the story or showcase individual products/features.

### Text on Creative — 20% Rule

The 20% image text rule is no longer enforced by Meta: there is no longer a limit on the amount of text in an ad image, and the text overlay tool is no longer available. Ads with heavy text will not be rejected outright. However, Meta says too much copy is distracting and can lead to the ad being shown to fewer people. Suppressed frequency is reported, unconfirmed. Keep text on creative minimal; rely on the copy fields for messaging.

---

## Section 3 — Creative Best Practices

Last verified: 2026-11-13 (Meta figures and policy only; advice and AFSL overlay not re-checked)

Sources:
- https://www.facebook.com/business/news/updated-features-for-video-ads
- https://www.facebook.com/business/help/1114358518575630
- https://www.facebook.com/business/ads/carousel-ad-format
- https://www.facebook.com/business/ads-guide/update/carousel/facebook-feed
- https://www.facebook.com/business/help/773889936018967

### Sound-Off Default

Approximately 85% of Facebook and Instagram video plays muted by default (reported, unconfirmed). Meta says most video ads in mobile feed are viewed without sound, and carousel videos play without sound by default. For Reels and Stories, assume no audio is heard on first impression.

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
- Last card: CTA. Reinforce the offer and drive action. Meta will display a "See all" card at the end automatically (reported, unconfirmed; the Meta carousel pages checked do not mention it) — do not design a separate end card for this.
- Each card should make sense in isolation. Users do not always swipe through in order.
- Consistent visual treatment across cards improves brand recall and perceived quality.

---

## Section 4 — Financial Services Constraints on Meta

Last verified: 2026-11-13 (Meta figures and policy only; advice and AFSL overlay not re-checked)

Sources:
- https://developers.facebook.com/docs/marketing-api/audiences/special-ad-category/
- https://www.facebook.com/business/help/298000447747885
- https://www.facebook.com/business/help/510724041294968
- https://www.facebook.com/business/help/2220749868045706
- https://transparency.meta.com/en-gb/policies/ad-standards/restricted-goods-services/financial-services/
- https://www.facebook.com/business/help/719892839342050

### Special Ad Category: Financial products and services

In October 2024 Meta replaced the Credit Special Ad Category with **Financial products and services**. Credit ads are now a subset of the category. Meta's examples of financial products and services ads include insurance, bank accounts, investment services and payment services. In the Marketing API, the `FINANCIAL_PRODUCTS_SERVICES` input replaced `CREDIT` as of 2025-01-14.

**When the category is required:**
- Financial products and services campaigns: required from 2025-01-21 for advertisers based in the United States or showing ads to audiences in the United States.
- Credit ads: Meta's credit policy and enforcement apply to advertisers based in the US or reaching audiences in the US, Canada or certain parts of Europe.
- Elsewhere: businesses outside the US reaching audiences outside the US, Canada and Europe must still pass the Special Ad Category field, but can opt in or opt out of the audience restrictions (opt out by passing `NONE`).
- Australia is not named on the Special Ad Category pages cited above (Marketing API docs and Help Centre articles 298000447747885, 510724041294968 and 2220749868045706). On their wording, an advertiser based outside the US whose campaign reaches only Australia must still pass the Special Ad Category field but can opt out (`NONE`). This is a reading of that wording; those pages make no statement about Australia. Meta does name Australia on a separate page, for financial services advertiser verification; see the Australia item under Meta's Ad Standards rules below.

Ads may be rejected if the advertiser does not choose an appropriate Special Ad Category, and an incorrect category risks the ads being paused until the campaign is adjusted. An account flag or account restriction for a missing declaration is reported, unconfirmed.

**What the Financial products and services category restricts:**

These restrictions apply whenever the category is used, including when an Australia-only campaign opts in.

| Targeting capability | Status under the category |
|---|---|
| Age targeting | Fixed at 18–65+. Exception: credit ads in Europe can select a different age range. |
| Gender targeting | Removed. Ads deliver to all genders. |
| Postcode / zip code and location exclusions | Not supported. Subcity, neighbourhood, metro area, small geo area and electoral district targeting are also unsupported. Any selected city, address or dropped pin must include at least a 25 km radius (US and Canada) or 15 km radius (Europe); Meta gives no Australian figure. City and pin-drop audiences include an expanded radius. |
| Lookalike audiences | Unavailable per the Marketing API docs, including lookalike exclusion; the Help Centre lists "Advantage+ lookalike" among limited options. Meta lists Custom Audience Expansion and Advantage+ Audience as supported features. Special Ad Audiences (reported, unconfirmed: a modified lookalike that strips restricted signals) are not mentioned on the Meta pages checked. |
| Saved audiences | Unavailable. |
| Detailed interest targeting | All behaviour and demographic targeting is unavailable, as are interest exclusion and detailed targeting exclusion. Interests must come from Meta's previously approved list. |
| Custom audiences from data | Allowed. Custom Audience inclusion and exclusion are both supported, and customer-list audiences can be checked for eligibility (`is_eligible_for_sac_campaigns`). Cannot be used to exclude based on prohibited criteria (reported, unconfirmed). |

**Practical implications:**
- Do not build audience strategy assuming fine-grained demographic targeting. The Financial products and services category will override it.
- Lookalikes are unavailable per the Marketing API docs; the Help Centre lists "Advantage+ lookalike" among limited options. Meta's documented options are Custom Audience Expansion and Advantage+ Audience. Build seed audiences from your best-performing customer lists and allow for a broader reach profile.
- Geographic targeting must include at least Meta's minimum radius around any selected city, address or dropped pin, not postcode lists or exclusion zones. A 50 km radius around a city is an example only, not a Meta figure.

### What Financial Product Ads Cannot Do on Meta

- Cannot target or exclude based on age (fixed at 18–65+, except credit ads in Europe), gender, or postcode when the category is used.
- Cannot use behaviour or demographic targeting, interest exclusion or detailed targeting exclusion when the category is used. Interests must come from Meta's approved list.
- Cannot run without a Special Ad Category declaration where Meta requires one: financial products and services ads from advertisers based in or reaching the US, and credit ads reaching the US, Canada or certain parts of Europe.
- Cannot suppress delivery to users based on protected characteristics via audience exclusions.

### Meta Ad Standards for Financial Services (all campaigns)

These rules come from Meta's global Ad Standards and the verification page it links to, and apply whether or not the Special Ad Category is used.

- Ads promoting credit cards, loans or insurance services must be targeted to people aged 18 or older.
- Advertisers promoting financial products and services must verify their business and/or individual identity, and show they are authorised by the relevant regulatory authorities where this is a requirement.
- Prohibited products include short-term loans of 90 days or less and contract for difference (CFD) trading.
- Australia: advertiser verification. Advertisers running financial products and services ads targeting audiences in Australia require verification. For ads covered by the Australia Online Scams Code, the advertiser verifies the ad's beneficiary and payer before running eligible financial services ads, including their Australian Financial Services Licence information (unless otherwise exempt). Eligible ads carry a "Paid for by" disclaimer naming the individual or organisation paying for and/or benefiting from the ad. The verified information is shown publicly on the ad while it runs and in Meta's Ad Library for up to seven years. Meta sets this out on its verification page, not on the Special Ad Category pages.

### AFSL Compliance Overlay

All ads for financial products regulated under an Australian Financial Services Licence must carry the required disclaimer in the ad creative. Meta's character limits do not exempt an ad from compliance requirements.

**Key considerations for layout:**

- The AFSL disclaimer (e.g., "General advice only. Consider your circumstances before acting.") must appear in the visible text area — not buried in landing page copy.
- For static image and carousel ads, the disclaimer typically sits in the Primary Text field. Plan the character budget against the placement's primary text recommendation in Section 1: the disclaimer's length comes off that figure, and what remains is the message.
- For video ads, the disclaimer must be visible on-screen. Overlay text in the safe zone, held for long enough to be readable (minimum 3 seconds).
- For Stories and Reels, the disclaimer must sit within the safe zone. This is a layout constraint — design it in from the start. For Reels, also follow Meta's rule to keep the bottom 40% clear when the ad carries a disclaimer (Section 2).
- The disclaimer must not be obscured by UI chrome, CTA buttons, or profile elements.

**Budget the disclaimer first.** In all copy-writing for financial products, write the disclaimer before the headline. What remains is the copy budget. This avoids layouts that technically include the disclaimer but render it illegible.

---

## Section 5 — Update Log

Append new entries at the bottom. Do not edit previous entries.

| Date | What changed | Source |
|---|---|---|
| 2026-05-02 | Document created. Initial spec set covering character limits, image/video specs, creative best practices, financial services constraints. | Meta Business Help Center + Luca review |
| 2026-11-13 | Re-checked every Meta figure and policy claim; added "Sources:" lines. Section 1: primary text changed for Facebook Feed (50–150), Instagram Reels (44) and Facebook Reels (40; overlay 60); Facebook Reels headline 55 (overlay 10); descriptions now 30 (single image) and 18–30 for carousel cards by placement (Help Centre: 25); Marketing API hard maximums added. Section 2: recommended Feed portrait 1440 x 1800 px and Stories/Reels 1440 x 2560 px; 4:5 now recommended for Facebook Feed; GIF added to video file types; Stories and Reels video lengths updated; safe zone now 14% top, 35% bottom, 6% sides, plus 40% bottom for Reels disclaimers; Instagram Stories carousels capped at 3 cards; carousel card size, headline and description given with both Ads Guide and Help Centre values where they disagree. Section 4: Credit category replaced by Financial products and services; required for US-based or US-reaching advertisers; the Special Ad Category pages name no Australian rule, and on their wording non-US advertisers reaching audiences outside the US, Canada and Europe must still pass the field but can opt out (`NONE`); targeting table updated (lookalikes and saved audiences unavailable, minimum radius rule); Meta Ad Standards finance rules added; Australian financial services advertiser verification (Online Scams Code) added. AFSL overlay: character-budget example now points to Section 1. Values Meta no longer states are marked "(reported, unconfirmed)". | Meta Ads Guide + Business Help Centre + Transparency Centre + Marketing API docs, retrieved 2026-11-13 (plan 175) |

---

*Meta Ads Specialist — Luca / Studio internal use only / Last full review: 2026-11-13 (AFSL overlay excluded)*
