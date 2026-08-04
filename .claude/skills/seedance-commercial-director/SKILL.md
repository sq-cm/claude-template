---
name: seedance-commercial-director
description: "Commercial-ad Seedance video-prompt director for product, brand, and advertising briefs — photoreal EN prompts. Sibling to cinema-director — NOT an alternative mode of it. Use whenever the brief is a product ad, brand film, hero commercial, TVC, social ad cut, beauty campaign, fragrance spot, automotive ad, or any shoot whose primary purpose is selling or showcasing a product or brand. Route on INTENT: if the goal is to sell, showcase, or brand → this skill. Narrative/editorial cinema → cinema-director. Stylized/animated/bilingual → seedance-bilingual-director."
---

# Seedance Commercial Director — Commercial Ad Lane

> **COMMERCIAL LANE — ROUTING GUARDRAILS (READ FIRST)**
>
> This skill is the commercial-ad lane. It is a sibling to `cinema-director`, not a mode of it.
>
> **Route on INTENT before anything else:**
> - Ad / product / brand / commercial / TVC / hero video / beauty campaign / fragrance spot / automotive ad → **this skill**
> - Photoreal narrative cinema / editorial / music video / dramatic scene / fashion film → **cinema-director**
> - Stylized / animated / cartoon / manga / claymation / bilingual EN+ZH / JSON output → **seedance-bilingual-director**
>
> **Commercial intent must NOT be served by cinema-director's M2 Studio mode.** M2 is an editorial/crafted mode — its grade is intentionally not commercial. A product ad written in M2 will produce the wrong register. If a brief is commercial, route here regardless of whether the environment is a studio, a white void, or a location shoot.
>
> If routing is ambiguous, ask one question: "Is the primary purpose of this video to sell or showcase a product or brand?" Yes → this skill. No → cinema-director.

**Version.** Ripple fold from upstream drop 2 (cinema-director rebuild), applied 04/08/2026: retired the old two-letter acronym and the skill's former name for its sibling, replaced throughout with `cinema-director`; reconciled every "shared with the sibling skill" / "same as the sibling skill" claim against cinema-director's new thirteen-block locked house format. Where cinema-director still carries an identically-named block (Subject Lock, Cross-Frame Rules, Last Frame, World Plate, Sound Bed, Element Tags, FOV Degree Table, Write The Visible, House Rules), the inheritance claim stands with an updated section pointer. Where a block no longer exists standalone upstream (Scene & Mood, Frame Map, Movement, the old separate Capture Realism / Camera Capture, the pre-prompt-confirmation workflow, the Distributed Style heading, the Cuts & Timing Precision Scale, the four-mechanic Capture Realism structure), this skill now marks that content as its own retained legacy grammar and points to the closest analogous new section rather than claiming direct inheritance. See § SHARED GRAMMAR — ELEMENT TAGS and § CAPTURE REALISM BLOCK — COMMERCIAL TUNING for the split.

---

## CORE PHILOSOPHY — COMMERCIAL CAPTURE

This skill is openly commercial. The goal is product desire, brand confidence, and purchase intent — communicated through a frame that looks controlled, polished, and intentional.

Where cinema-director pursues the captured-on-a-camera-that-has-lived-a-little aesthetic — film grain, editorial imperfection, analogue warmth — this skill pursues the opposite: a clean, high-fidelity image that makes the product read as clean, true, and premium on screen. The grade is commercial, not editorial. Highlights are lifted and clean. Colour is precise and controlled. Specular on product surfaces is an asset, not a failure mode.

That said, "commercial" does not mean plastic. The anti-plastic discipline from cinema-director still applies to skin — no doll skin, no AI-rendered gloss on faces — because a shot where the talent looks synthetic undermines the product. The seam is clean: product surfaces can carry controlled, intentional specular; human skin cannot, except at named opt-in zones.

Five commercial registers replace cinema-director's five cinema modes. The differences across registers are in **light quality, product presentation, movement grammar, grade, and surface treatment** — not in the element-tag grammar, which is shared with cinema-director and operates identically here (cinema-director § ELEMENT TAGS). This skill's twelve-block locked structure is its own independently-maintained format, descended from cinema-director's prior ten-block grammar; cinema-director has since moved to a thirteen-block locked house format with a different block set, so the two skills no longer share an identical block list — only the tag-reference mechanics and the core anti-plastic philosophy.

**Density rule.** This skill's own established target — no longer numerically aligned with cinema-director, whose length discipline now targets roughly 1,000–1,600 words for a four-shot sequence with four Subject Locks: 280–400 words for single-shot scenes, up to 600 for multi-shot. Keep every prompt tight — cut filler. Trust the reference image.

**Distributed style.** Same discipline cinema-director still follows — no style header at the top of the prompt. Lighting, colour/grade, lens character, skin treatment, product surface treatment, composition, and continuity each live in their home block rather than a top prefix. The prompt opens on Scene & Mood and Frame Map. Cinema-director's old § DISTRIBUTED STYLE heading is gone; the discipline now lives in cinema-director § BLOCK ORDER (LOCKED) and its anti-redundancy rule (§ BLOCK 3 — ALL-CAPS CRITICAL DIRECTIVE BLOCKS, "Anti-redundancy, universal") — this skill's product-specific aspects route to Product Surface and Brand Grade instead of cinema-director's merged Camera & Capture Realism closer (§ BLOCK 13).

---

## HOW TO USE THIS SKILL

The workflow follows this skill's own established steps, with a commercial-brief intake step added:

**Step 1 — Confirm the brief type.** Before anything else, confirm this is a commercial/ad brief (product, brand, TVC, hero video, beauty, automotive, fragrance, food, drink, jewellery, fashion ad). If it is narrative cinema or stylized, redirect to the correct skill.

**Step 2 — Upload reference material.** Drop in product shots, talent references, environment plates, mood boards, and brand colour references. Product references are mandatory — the PRODUCT SURFACE block cannot be written without them.

**Step 3 — Describe the scene.** Who is in the frame, what the product is, what the moment is, and how long the shot runs. Name the commercial register explicitly or let the skill select it.

**Step 4 — Name the element tags and confirm the pre-prompt summary.** This skill's own tag-first format — tags first, register, scene, characters, frame map, camera (FOV° + mm), runtime. Confirm before the full prompt ships.

**Step 5 — Receive the two-part delivery.** This skill's own locked format: (a) bolded English title with runtime, (b) English code block with twelve discrete labelled blocks in locked order and inline `@tag` references.

**Step 6 — Run in Higgsfield.** Upload the reference files under the same tag names used in the prompt, then paste the code block into the prompt field.

---

## SESSION OPENER — CHARACTER AND PRODUCT GATE

The first time the user asks for a commercial Seedance prompt in a session, ask once:

> "Two quick checks before I start: (1) Is there talent in this shot with locked reference images, or is it product-only? (2) What is the hero product — do you have a product reference image to attach? And what tag names do you want to use for each reference (e.g., `@talent_ref`, `@perfume_ref`, `@bottle_cap_ref`)?"

Branch on the answers:

- **Talent with references →** lock face, hair, wardrobe, skin tone, and identity markers from the image. Confirm the tag name for that reference. Mirror back the spec for confirmation.
- **Talent without references →** flag the gap. Offer to describe the talent from text, with the caveat that identity fidelity will be lower without a locked reference.
- **Product reference attached →** extract product name (descriptive, no real brand names unless authorised — see the override under rule 11), surface finish (matte, gloss, chrome, frosted glass, metallic, fabric, ceramic), key reflective surfaces, and colour. Confirm its tag name (e.g., `@perfume_ref`). Carry this through the PRODUCT SURFACE block.
- **No product reference →** request one. A PRODUCT SURFACE block cannot be written without knowing the surface finish and reflection profile of the hero product.

**Never invent tag names on the user's behalf.** Writing a Subject Lock or Product Surface block without a named tag and an attached reference is a category error. Once tags are locked for a session, carry them forward — the user won't re-name the same reference on every prompt.

Once asked, do not ask again in the same session.

---

## PRE-PROMPT CONFIRMATION RULE

Every new scene gets a pre-prompt summary before the full prompt is written, in this skill's own locked format — tags first, register last on the details, runtime as the final bullet. (Cinema-director's own grammar no longer documents an equivalent pre-prompt-confirmation workflow; this stays a commercial-lane-specific step.)

```
Pre-prompt check:
- **Tags:** [list every element tag being used — talent refs, product refs, environment plates — by name and short visual descriptor. If tags aren't yet named for this scene, ask here instead of proceeding.]
- **Register:** [C1 Hero / C2 Beauty / C3 Automotive / C4 Lifestyle / C5 Pack Shot]
- **Scene:** [one-line scene description]
- **Hero product:** [descriptive product name — no real brand names unless authorised, see the override under rule 11]
- **Characters:** [who's in frame, referred to by tag; or "none / product-only"]
- **Frame Map:** [one-line compositional read]
- **Camera:** [FOV degree + mm equivalent + key movement]
- **Runtime:** [Xs, single shot, OR Xs, [N]-shot sequence with per-shot beats]

Sound good?
```

Wait for the green light. Then deliver the two-part output.

**Skip the confirmation only when:**
- The user is iterating on a prompt just delivered (camera tweak, lighting nudge, position shift)
- The user requested a batch and pre-confirmed it as a whole
- The user explicitly said "skip the confirm, just give me the prompt"

For all new scenes: confirmation is not optional.

---

## TWO-PART DELIVERY FORMAT (LOCKED)

This skill's own locked format. (Cinema-director's own delivery format has since expanded to three parts — title, tag list, code block, per cinema-director § DELIVERY FORMAT; this skill keeps its tag list folded into the pre-prompt check rather than repeating it as a separate delivery step.)

**1. Title line with runtime.** Bolded English. Example: `**Seedance commercial prompt — 10s**`

**2. English code block with twelve discrete labelled blocks and inline `@tag` references.** Product tags get their own inline mentions — they anchor the PRODUCT SURFACE block. Seedance hard cap: roughly 9 references per prompt. The old numbered bullet reference list is gone — the user's element tags carry the reference mapping directly.

**Block order inside the code block (every prompt, no exceptions — HARD LOCK):**

```
Scene & Mood
Frame Map
Subject Lock(s)
Cross-Frame Rules
Movement
Last Frame
World Plate
Sound Bed
Capture Realism
Product Surface
Brand Grade
Camera Capture
```

Twelve blocks. This order never changes. No block may be omitted, reordered, merged, renamed, or replaced with flowing prose. Every block ships with its label prefix. If a block has nothing to say for the scene, it is still present and its content is shortened — never omitted. Product-only scenes (no talent) drop the per-zone skin sentence from Capture Realism but keep all twelve blocks.

---

## OUTPUT LANGUAGE (LOCKED)

**English only — locked.** All Seedance commercial prompts are output in English inside the code block. No bilingual mode.

---

## UNIVERSAL PROMPT RULES (ALL REGISTERS)

These rules descend from cinema-director's grammar and apply identically here where cinema-director still carries the same rule; where cinema-director's version of a rule no longer exists in the same form, this skill retains its own version (noted inline). Extended with commercial-specific additions:

1. **Pre-prompt confirmation on every new scene.** Tags first, runtime last. Skip only on iterations.
2. **Two-part delivery format, in order:** (a) bolded English title with runtime, (b) English code block with twelve labelled blocks and inline `@tag` references.
3. **Every element tag named in the pre-prompt check appears at least once inline in the code block.**
4. **Write the visible.** Every abstraction translated to a physical action, a measurable value, or a specific object — no mood-word abstraction ("looks premium," "feels luxurious"). Speeds in km/h, atmosphere in % and meters, scale via human-height stacking, emotion via muscle, product presence via named surface behaviour. See cinema-director § WRITE THE VISIBLE — the same discipline governs this skill's output.
5. **Runtime baked into the closing Camera Capture line.** Always ask runtime; never default.
6. **Per-shot timing inline in Movement** for any multi-cut sequence.
7. **Twelve discrete labelled blocks inside the code block, in the exact locked order defined in § Delivery format — every prompt, no exceptions.**
8. **One Subject Lock block per character.** Multiple characters each get their own discrete block.
9. **One Camera Capture line at the bottom — never doubled.**
10. **No character names in prompt output.** Describe by hair colour, wardrobe, identity markers.
11. **No real brand names in prompt output.** Generic visual descriptors only ("a tall frosted glass perfume bottle with a chrome atomiser cap," not the brand name). This is the commercial-lane version of cinema-director's brand-name rule (cinema-director § HOUSE RULES — "No real brand names in prompt output") — applies identically. Cinema-director's rules are no longer numbered, so the "Rule 11" citation is retired. **Override:** when the user explicitly supplies a real brand name and either confirms the rights (the client's own brand under an engagement) or explicitly accepts the risk (personal, non-commercial work), write it verbatim and describe its physical marks — shape, colour, placement, legibility — so the model has something to draw. Never introduce a real brand the user didn't name.
12. **No platform/tool names in prompt output.** Never reference "Higgsfield," "Seedance," "Banana Pro," etc. inside the prompt text.
13. **No internal production context.** Every prompt is standalone.
14. **Pure visual description only.** No meta-commentary.
15. **Diegetic audio only in the Sound Bed** — plus brand-safe stance (see Sound Bed section below).
16. **Energy over position** in Scene & Mood. Frame Map handles geometry.
17. **Cut triggers and timing precision.** "Hard cut to," "Smash cut to," "Match cut on" for edits inside multi-shot prompts. This skill keeps its own four-register cuts-and-timing scale (oner / sequential cuts / timed multishot / freestyle b-roll) and timecoded/sequential formats — cinema-director's own § CUTS & TIMING PRECISION SCALE heading is gone; its closest equivalent grammar is now the cut-count and shot-duration columns of § DYNAMIC REGISTER (ENERGY DIAL) plus the per-shot timecoding required in § BLOCK 1 — SHOT HEADER.
18. **Age-blind.** Never describe characters by age.
19. **No on-screen text by default.** Every Last Frame block closes with: "No on-screen text, no captions, no signage typography, no rendered text in the frame." Skip only when the user explicitly requested in-frame text.
20. **Positive locks over negative prohibitions.** Same principle as cinema-director (§ PHRASING: POSITIVE DEFAULT, SANCTIONED NEGATION BATTERIES).
21. **One main idea per shot.**
22. **Trust the reference image for wardrobe and product surface finish.** Subject Lock and Product Surface only restate what the reference cannot carry.
23. **Canonical reference always attached, never substituted by the plate.** Product canonical reference is separate from the environment plate, even when the product is visible in the plate.

---

## SHARED GRAMMAR — ELEMENT TAGS

Cinema-director's rebuild moved to a thirteen-block house format; two of the blocks below no longer have a standalone equivalent there (Frame Map folded into each shot's Position line, Movement folded into each shot's Subject-action and Camera-move lines). The remaining blocks are still **identical in grammar, logic, and rules to cinema-director**. This skill does not redefine them. Use the cinema-director conventions for:

- **Subject Lock** — identity anchor per `@tag`, body orientation, pose, state, gaze, contact points, state-change details the reference cannot carry, lock-down line. Identical to cinema-director § BLOCK 4 — SUBJECT LOCK.
- **Cross-Frame Rules** — no swap, no centre crossing, no depth change, distance consistency, screen sides held, eyelines, carry-across-the-cut. Identical to cinema-director § BLOCK 10 — CROSS-FRAME RULES.
- **Last Frame** — exact closing composition, on-screen text suppression line. Identical to cinema-director § BLOCK 11 — LAST FRAME.
- **World Plate** — location, time of day, weather, set dressing, colour palette, atmospheric quality, anchored to `@tag` if a plate is attached. Identical to cinema-director § BLOCK 7 — WORLD PLATE.
- **Element tags** — user-supplied semantic names (`@talent_ref`, `@perfume_ref`, `@bottle_cap_ref`, `@studio_plate`) replace `@imageN` numbering. Lowercase, underscore-separated, descriptive; character/talent refs use `_ref`, environment plates use `_plate`, product/prop tags use a descriptive noun. Ordering no longer matters — Seedance matches by tag name. Every tag named in the pre-prompt check must appear at least once inline in the code block. Reference-count ceiling still applies: roughly 9 uploaded references per prompt. Full tag-naming rules and the canonical-over-plate rule: cinema-director § ELEMENT TAGS.

Retained as this skill's own legacy blocks — no longer shared with cinema-director's current structure:

- **Frame Map** — 2D screen space, horizontal thirds, x/y% precision, depth layers, frame occupancy, negative space. Cinema-director no longer carries this as a standalone block; the closest analog is the per-shot Position line inside cinema-director § BLOCK 9 — SHOT BLOCKS.
- **Movement** — four layers (character motion / micro-motion / environmental motion / camera motion) in flowing paragraph form with per-beat timestamps. Cinema-director no longer carries this as a standalone block; the four-layer discipline survives as guidance in cinema-director § MOVEMENT AND CHOREOGRAPHY, folded into the Subject-action and Camera-move lines of each timecoded shot block there.

Any rule from cinema-director that still governs the five identical blocks above applies here unchanged. This skill's additions are in the two new blocks (PRODUCT SURFACE and BRAND GRADE) and in the rewritten CAPTURE REALISM and SOUND BED sections below.

---

## READING REFERENCE IMAGES

Same discipline as cinema-director for talent references. Add the following for **product references**:

**For each product in the reference, capture:**

- **Product form:** shape, silhouette, scale, structural features (cap, nozzle, label zone, handle, base)
- **Surface finish:** matte, gloss, chrome, brushed metal, frosted glass, clear glass, ceramic, fabric, mirrored, resin, lacquer
- **Reflective surfaces:** which specific surfaces carry specular (chrome cap, glass body, metallic label, polished base) — named precisely
- **Colour:** dominant body colour, accent colours, label zone colour
- **Material tells:** translucency, texture, any surface markings visible on the reference

The product surface read feeds directly into the PRODUCT SURFACE block. Without it, that block cannot be written.

---

## SOUND BED — DIEGETIC + BRAND-SAFE STANCE

The Sound Bed describes only what the scene physically produces — same discipline as cinema-director (§ BLOCK 12 — SOUND BED).

**Brand-safe stance (commercial addition):** the Sound Bed must never include sounds that would read as a competitor's sonic identity, a licensed audio trademark, or any sound that could constitute a brand claim. Generic diegetic sounds are always safe. If the user wants a specific sonic branding element (a signature chime, a product sound cue), describe it functionally — "a short ascending two-note chime, warm and mid-register" — never by brand name or product name. Exception: when the client's own registered sound mark is being used under an authorised engagement, it may be named and described as such; the ban on competitor or third-party sonic trademarks stays absolute.

**Audio modes:** this skill's own three modes (diegetic with ambient / silent capture / diegetic explicit no-music). Cinema-director's Sound Bed (§ BLOCK 12) no longer enumerates named modes, but the same diegetic-only default and lipsync sole-source hard lock apply. Mode 2 (silent capture) is common in commercial production when the music track is being added in post — flag this option if the user mentions a soundtrack.

**Sound Bed example (commercial):**

> Sound Bed: Diegetic only — glass bottle placed precisely on a polished marble surface, faint ambient room tone, soft fabric rustle on talent movement, controlled breath, distant city ambience filtered through glass, no music, no dialogue, no score.

---

## CAPTURE REALISM BLOCK — COMMERCIAL TUNING

The Capture Realism block in this skill serves the same structural purpose this skill has always used — separating the rendered-not-photographed failure modes — but is tuned for commercial production. Cinema-director has since merged its own Capture Realism content into a single closing block (§ BLOCK 13 — CAMERA & CAPTURE REALISM, MERGED CLOSER); this skill keeps Capture Realism as its own dedicated block, separate from Camera Capture, with Product Surface and Brand Grade inserted between them.

**Philosophy shift:** in cinema-director, the target is "feels captured, not rendered" (§ CORE PHILOSOPHY). Here, the target is "looks controlled, precise, and real — not AI-generated." The anti-plastic discipline holds for skin. The depth-via-atmosphere mechanic holds for any scene with planes to separate. The contrast curve holds. What changes is the **moisture and specular logic**: product surfaces are not subject to the matte-only rule. That is handled in the PRODUCT SURFACE block. Capture Realism applies the matte rule to skin and non-product surfaces only.

**The four mechanics — commercial tuning:**

**1. Depth via suspended atmosphere between planes.** Same substance as cinema-director's own atmosphere discipline, which cinema-director now writes as its own CRITICAL directive block (§ BLOCK 8 — THE ATMOSPHERE) rather than a Capture Realism sub-item; this skill keeps it folded inside Capture Realism instead of promoting it to a standalone block. Always on when there are planes to separate. State the density in % and the visibility depth in meters — e.g., "haze 15%, readable to 50 meters" for a clean product-forward frame, scaling up for lifestyle or automotive exteriors with more atmosphere to separate. Any vehicle or moving-subject speed in the frame (C3 Automotive, C4 Lifestyle) is stated in km/h — never "fast," "slow." See cinema-director § WRITE THE VISIBLE.

**2. Moisture without shine — skin and non-product surfaces only.** This skill's own matte-moisture logic — cinema-director's current grammar no longer carries a moisture mechanic in any form. If the scene has moisture on skin or fabric: damp but not beaded, saturated not glossy. This rule does not apply to the hero product — the product's surface treatment is governed by the PRODUCT SURFACE block, not Capture Realism.

**3. Per-zone specular kill on skin — with OPT-IN BEAUTY HIGHLIGHT exception.** Default: same core zones as cinema-director's Skin paragraph (§ BLOCK 13 — CAMERA & CAPTURE REALISM, part 5) — per-zone kill on forehead, nose bridge, cheekbones, temples, chin, and collarbones. Zero shine; real peach fuzz at jaw and hairline; real soft fine even pore texture; light absorbed like true subsurface scattering; warmth preserved. Flattering ceiling locked: no acne, no blemishes, no harsh pore detail.

**Beauty highlight opt-in (commercial exception):** for beauty, fragrance, jewellery, and fashion ad briefs where the creative intent requires it, specific named skin zones may carry a controlled highlight. This must be declared explicitly in the prompt — it is never a default. Permitted opt-in zones:

- **Lip gloss / lacquered lip:** a fine, even gloss on the lip surface only; no specular on surrounding skin
- **Dewy skin highlighter:** a soft luminous lift on one named zone only (cheekbone ridge OR Cupid's bow, never both simultaneously unless the brief specifically calls for it) — controlled, not blown
- **Jewellery reflection:** reflective catch-light on metal or stone surfaces that contact the face or neck (earring, necklace, ring) — the catch-light lives on the jewellery, not on the skin around it
- **Eyewear lens catch:** a clean lens reflection on sunglasses or eyeglass lenses — controlled, matched to the key light source
- **Wet hair gloss:** a single-direction specular streak on very wet hair, reading as water-soaked, not product-styled

To invoke any opt-in zone, state it explicitly in the Capture Realism block: "controlled dewy highlight on the left cheekbone ridge only, all other skin zones matte per default."

**4. Contrast curve stated three ways.** This skill's own established mechanic — cinema-director's Grade paragraph (§ BLOCK 13, part 4) covers grade broadly but no longer names a discrete "three ways" contrast-curve mechanic. Shadows lifted gently, highlights rolled off softly, nothing clipping or crushing; all specular surgically removed from skin (except declared opt-in zones) and non-product surfaces; grade low-contrast and slightly desaturated with warmth preserved.

**Canonical Capture Realism block — commercial (tune every bracket):**

```
Capture Realism: [Foreground subject] sits inside real depth — [thin/light/heavy] atmosphere suspended between camera, subject, and [far background element], background rendered softer, desaturated, and lower-contrast than the foreground. [IF WET — SKIN/FABRIC ONLY: Slight moisture on skin and fabric — damp matte, no beading, no wet sheen, moisture that mutes and deepens without a single specular hotspot. Product surface moisture is governed by the Product Surface block.] Skin reads true commercial matte — zero shine on forehead, nose bridge, cheekbones, temples, chin, and collarbones[IF BEAUTY OPT-IN: ; [named zone] carries a controlled [lip gloss / dewy highlight / jewellery catch / eyewear lens catch / wet hair gloss] — all other zones remain matte], real peach fuzz catching light at jaw and hairline, real soft fine even pore texture, light absorbed like true subsurface scattering, warmth preserved and natural, never plastic, never doll-skin, never AI-rendered, and never harsh — no acne, no blemishes, no enlarged or rough pores, fine flattering texture that keeps the face looking good. Low-contrast curve — shadows lifted gently, highlights rolled off softly, nothing clipping to white or crushing to black. All specular surgically removed from skin, hair, fabric, and non-product surfaces, every pixel reading matte and diffuse. Slightly desaturated grade with warmth preserved.
```

---

## PRODUCT SURFACE BLOCK (NEW — COMMERCIAL LANE ONLY)

This block governs how the hero product's surfaces behave under the key light. It is the commercial-specific block that does not exist in cinema-director. It sits between Capture Realism and Brand Grade.

**Purpose:** controlled specular and reflection are assets in commercial work. A glass perfume bottle should catch the key light cleanly. A chrome atomiser cap should hold a precise highlight. A lacquered product body should read its finish. This block tells Seedance exactly which product surfaces carry specular, what shape that specular takes, and where it is locked — so the product reads as professionally lit, not accidentally glossy.

**Locking discipline:** specular and reflection in this block are locked to **named product surfaces only**. They must never spill to skin, fabric, background surfaces, or any non-product surface in the frame. The seam between product surface treatment and skin treatment is clean and explicit.

**Properties to specify:**

- **Hero product reference:** anchored to `@tag` (e.g., `@perfume_ref`)
- **Surface finish per named zone:** for each distinct surface on the product, name the finish (glass body: clear gloss / frosted / smoked; cap: chrome / brushed metal / lacquered; label zone: matte / gloss / foil; base: mirrored / matte)
- **Specular profile:** shape (hard point / soft bloom / streak / wrap), size (pin / coin / palm), and single-direction lock (matching the scene's key light source)
- **Reflection profile:** what the product reflects (if the product has a mirror or glass surface) — locked to the practical lights in the scene, not the ambient environment
- **Spill prohibition:** explicit lock that specular and reflection stay on the named product surfaces and do not transfer to skin, fabric, or background

**Canonical Product Surface block:**

```
Product Surface: @tag — [descriptive product name] is the hero subject. [Surface zone 1, e.g., clear glass body] carries a [soft / hard] specular [bloom / point / streak], single-direction, aligned to the [key light position — e.g., camera-right overhead], [size descriptor]. [Surface zone 2, e.g., chrome atomiser cap] holds a [hard point / clean streak] highlight, [size], matched to the same key light. [Surface zone 3, e.g., frosted base] reads matte, no specular. Product specular and reflection stay locked to the named product surfaces — zero spill to skin, fabric, or background. The product reads as precisely lit, not accidentally glossy.
```

**Product-only scenes (no talent):** the Product Surface block is the primary realism carrier. Drop the skin sentence from Capture Realism. Keep all twelve blocks.

---

## BRAND GRADE BLOCK (NEW — COMMERCIAL LANE ONLY)

This block sits between Product Surface and Camera Capture. It declares the colour grade treatment for commercial output — separate from cinema-director's editorial grade and explicitly not inherited from any cinema-director mode.

**Purpose:** commercial spots often require a specific grade profile — a clean warm white-balanced look, a product-matched colour temperature, a brand colour cast, a specific highlight roll-off that matches the client's visual identity. This block carries that instruction explicitly so it does not contaminate the Capture Realism block (which handles anti-plastic physics) or the Camera Capture line (which handles hardware and runtime).

**What goes in the Brand Grade block:**

- **Colour temperature:** named and locked (e.g., "warm 4500K key, neutral-cool fill")
- **White balance:** product-matched (e.g., "white balance matched to the product body colour — white product reads true white, not shifted warm or cool")
- **Highlight treatment:** clean commercial roll-off (e.g., "highlights lift cleanly without clipping — skin tones hold detail at the top of the curve, product labels remain legible")
- **Shadow fill:** commercial shadow fill level (e.g., "shadows lifted to a commercial fill ratio — no crushed blacks, every shadow zone holds detail and brand legibility")
- **Brand colour cast (opt-in):** if the brief calls for a branded colour environment (e.g., a warm amber cast for a candle brand, a cool teal for a skincare brand), state it here. This is always an explicit opt-in; the default is clean, neutral commercial grade.
- **Grade register:** state explicitly — "clean commercial grade, not editorial" — to prevent model drift toward cinema-director's editorial register

**Canonical Brand Grade block:**

```
Brand Grade: Clean commercial grade — not editorial. Key light at [colour temperature, e.g., warm 4500K], fill neutral-cool. White balance matched to [product body / background surface], reading true to the reference. Highlights lift cleanly with a soft commercial roll-off — no clipping on skin or product surfaces, label zones legible throughout. Shadows lifted to a commercial fill ratio, every shadow zone holding detail. [IF BRAND CAST OPT-IN: A [descriptor, e.g., warm amber] cast from the [practical source — e.g., candlelight behind the product], integrated naturally — not a post grade overlay.] Colour palette: [dominant tone, accent, neutral — specific to the scene]. Grade is clean, controlled, and product-forward.
```

---

## COMMERCIAL REGISTERS — SELECT TABLE

| Register | Use when the brief is... | Light Quality | Lens | Movement | Grade |
|---|---|---|---|---|---|
| **C1 — Hero Product** | Single product as subject — beauty, fragrance, skincare, food, drink, tech device | Controlled single-source key, precision fill | 75–100mm, wide aperture, spherical character — clean round bokeh, even sharpness | Locked-off or micro-movement only — product must hold perfectly still | Clean warm commercial, product-matched white balance |
| **C2 — Beauty / Talent** | Face-forward talent in a beauty, skincare, hair, cosmetic, or jewellery ad | Soft beauty key (butterfly or loop), controlled fill, catch-light management | 75–100mm, spherical, wide aperture — even face sharpness | Minimal talent movement — held poses, slow turns, controlled eye movement | Warm commercial, skin-forward, clean highlights |
| **C3 — Automotive** | Vehicle as hero subject — exterior reveal, detail shots, interior close-ups, driving shots | Hard directional key for specular on paint and glass, graduated natural environment | 35–55mm anamorphic character (exterior) / 50–75mm spherical (interior detail) | Vehicle movement if driving; locked-off or tracking for static reveals | Bold commercial with precise specular on paintwork and glass |
| **C4 — Lifestyle / Aspirational** | Product in use by talent in a location — food consumption, drink pour, sportswear in motion, home product in situ | Mixed natural and practical motivated key, soft fill | 40–55mm, wide aperture — anamorphic character for environmental depth, spherical for product close-up | Talent movement and product-use choreography; camera follows the action | Warm lifestyle grade, slightly lifted shadows, natural skin |
| **C5 — Pack Shot / Still-Life** | Pure product presentation — packaging, label, bottle, box — with no talent | Precision table-top key, multiple controlled practicals for surface modelling | 85–100mm macro-capable spherical, wide aperture | Locked-off only; optional slow 360° rotation on product if brief calls for it | Clean neutral-warm commercial, product surface fidelity maximum |

---

## REGISTER CAMERA CAPTURE LINES

FOV degree is the lens anchor across all five registers — same discipline as cinema-director. Write `[FOV°] ([mm])` in the prompt body, never mm alone; pick from cinema-director's discrete anchor ladder rather than an off-ladder degree. Full table and rationale: cinema-director § FOV DEGREE TABLE (LENS ANCHOR).

**C1 — Hero Product:**
```
Camera Capture: wide-latitude commercial capture, clean spherical [FOV°] ([mm]) character at a wide aperture — natural round bokeh, even sharpness — mild controlled diffusion, locked-off with optional micro push-in no greater than 5% frame change, clean warm commercial grade, fine grain, 24fps 180° shutter, [XX] seconds.
```
Typical anchor: 18°–29° (75–100mm) — tight product isolation.

**C2 — Beauty / Talent:**
```
Camera Capture: wide-latitude commercial capture, clean spherical [FOV°] ([mm]) character at a wide aperture — soft even sharpness — beauty light diffusion bloom on the key side, locked tripod or minimal handheld sway, clean warm beauty commercial grade, fine grain, 24fps 180° shutter, [XX] seconds.
```
Typical anchor: 18°–29° (75–100mm) — face-forward beauty compression.

**C3 — Automotive:**
```
Camera Capture: wide-latitude commercial capture, vintage [FOV°] ([mm]) 2x anamorphic character at a wide aperture — oval bokeh, precise specular streak on paint and glass — light diffusion bloom on sky, [locked-off tracking / low dolly push / orbit], bold commercial grade with controlled specular on paint and chrome, fine grain, 24fps 180° shutter, [XX] seconds.
```
Typical anchor: 47°–63° (35–55mm) exterior reveal; 29°–47° (50–75mm) interior detail.

**C4 — Lifestyle:**
```
Camera Capture: wide-latitude commercial capture, [FOV°] ([mm]) [anamorphic character for wide shots / spherical for close-ups] at a wide aperture — [oval / round] bokeh — natural motivated key, light diffusion bloom, handheld with operator breath on wide shots, locked or minimal movement on close-ups, warm lifestyle commercial grade, fine grain, 24fps 180° shutter, [XX] seconds.
```
Typical anchor: 47°–63° (35–55mm) wide; 18°–29° (75–100mm) product close-ups.

**C5 — Pack Shot:**
```
Camera Capture: wide-latitude commercial capture, clean spherical [FOV°] ([mm]) macro-capable character at a wide aperture — precise even sharpness, controlled diffusion on specular zones — locked-off[, optional slow 360° product rotation if brief calls for it], clean neutral-warm commercial grade, fine grain, 24fps 180° shutter, [XX] seconds.
```
Typical anchor: 12°–18° (100–180mm) — macro-capable detail hold.

---

## PRE-DELIVERY PASS (SILENT QA — RUN BEFORE EVERY DELIVERY)

Before delivering the full prompt, silently run this pass. Fix anything that fails before the prompt ships. Do not narrate the pass.

- [ ] Commercial brief confirmed — not narrative cinema, not stylized/bilingual
- [ ] Character gate and product gate asked (if first prompt of session) and answers carried
- [ ] Every uploaded reference identified and named — talent refs, product refs, environment plates — tag names confirmed in the pre-prompt check, inline `@tag` references placed in the code block
- [ ] Product reference attached for hero product; PRODUCT SURFACE block cannot be written without it
- [ ] Canonical reference attached for every named subject (talent, vehicle, product) that appears in the scene — even if also visible in the plate
- [ ] Commercial register selected (C1 / C2 / C3 / C4 / C5) with rationale
- [ ] Frame Map written — every subject pinned to screen position, depth layer, frame occupancy
- [ ] Subject Lock written for every talent character — identity / orientation / pose / state / gaze / contact points / state-changes / lock-down line. Wardrobe not re-described from reference image.
- [ ] Cross-Frame Rules written if 2+ characters in frame; single-character scenes still ship the labelled block, shortened
- [ ] Movement written — four layers present (character / micro / environmental / camera), per-beat timestamps where action demands
- [ ] Last Frame written — exact closing composition, on-screen text suppression line included
- [ ] World Plate written — location, time, weather, set dressing, anchored to plate ref if attached
- [ ] Sound Bed written — diegetic mode chosen, specific sounds listed, brand-safe stance confirmed, no music referenced
- [ ] Capture Realism written and tuned — depth-via-atmosphere between actual planes; moisture-without-shine on skin/fabric ONLY if wet; per-zone specular kill on skin with any beauty opt-in zones declared explicitly; contrast curve stated three ways. No product surface specular in this block — that is in Product Surface. No gear/grade/frame-rate language from Camera Capture duplicated here.
- [ ] Product Surface written — hero product `@tag` anchored, named surfaces with finish and specular profile, spill prohibition stated
- [ ] Brand Grade written — colour temperature, white balance, highlight treatment, shadow fill, brand cast if declared, "clean commercial grade not editorial" stated
- [ ] Camera Capture line at the bottom — single trimmed paragraph, no double spec
- [ ] Commercial register Camera Capture line used — not a cinema-director cinema mode line
- [ ] Lens length chosen for the framing
- [ ] Runtime confirmed. Runtime in title matches runtime in Camera Capture.
- [ ] No character names in prompt output
- [ ] No unauthorised real brand names in prompt output
- [ ] No platform/tool names in prompt output
- [ ] No internal production context, no meta-commentary
- [ ] No music in Sound Bed; brand-safe stance confirmed
- [ ] Output locked to English
- [ ] Two-part delivery format: (1) bolded English title with runtime, (2) English code block with twelve labelled blocks and inline `@tag` references
- [ ] All twelve labelled blocks present in the code block, in the exact locked order (§ Delivery format). None missing, none reordered, none merged.
- [ ] Every element tag named in the pre-prompt check appears at least once inline in the code block
- [ ] Negative prohibitions translated to positive locks throughout
- [ ] Total prompt body word count within target range (280–400 single shot, up to 600 multi-shot)

**Repair pass — if any of these conditions are detected, fix before delivery:**

- **Wrong skill lane** → if brief is narrative or stylized, redirect to cinema-director or seedance-bilingual-director
- **Cinema-director editorial grade bleeding in** → rewrite Brand Grade as "clean commercial grade, not editorial"
- **Product specular in Capture Realism** → move to Product Surface block; Capture Realism handles skin only
- **Skin specular undeclared** → if any skin highlight exists without an explicit beauty opt-in declaration, remove it
- **Beauty opt-in applied to a non-permitted zone** → remove or move to a permitted zone
- **Product reference missing** → flag to user before delivering prompt; do not write a placeholder PRODUCT SURFACE block
- **Double camera spec** → collapse to single Camera Capture line at the bottom
- **Prompt word count over target** → trim Subject Lock and Movement first, then Cross-Frame Rules

---

## STUDIO CONVENTIONS

In this studio, written deliverables pass a QA gate and a humaniser pass before release. This applies to surrounding prose and structured documents — not to the prompt code-block output itself. The prompt grammar inside the fenced code block is verbatim copy-paste material and must never be humanised or reworded.
