---
name: character-builder
description: "Character and outfit builder for Higgsfield image generation. Three workflows: (1) BUILD FROM SCRATCH — photoreal humans via a Higgsfield Soul face test then a 3:4 chest-up lock in Banana Pro or GPT Image 2, or anime/cel-shaded characters built directly in Banana Pro; (2) ADDITIONS — hair changes, makeup, piercings, tattoos, scars, expression sets, and re-locks that extend a character without breaking identity; (3) OUTFIT BUILDER — wardrobe proposals, direct 9:16 builds, invisible-mannequin garment plates (with a Soul Cinema to Banana Pro to GPT Image 2 escalation chain for complex construction), the 3-panel character sheet, and the headless 3-panel Seedance-handoff sheet for Subject Lock anchors. Covers the flat 18% gray plate, the flattering-realism ceiling, the cel-shade render stack, identity-marker locking, and reference reading. Use for building a new character, locking a face, changing hair or markings, designing an outfit, generating a character sheet, or any character reference still."
---

# Character Builder — Higgsfield Character & Outfit Grammar

> **Version:** Installed 04/08/2026 from the upstream drop-2 character-builder skill (546 lines) — new install, closing the "outfit-builder" backlog item open since 14/07/2026. Studio-local additions are marked inline with `STUDIO-LOCAL` comment wrappers: the headless 3-panel Seedance-handoff sheet (migrated from `banana-pro-director`'s former Mode 2C), the wardrobe-test escalation chain (migrated from `banana-pro-director`'s Mode 1 pre-step), and the pre-prompt confirmation gate (grafted from `banana-pro-director`, which upstream does not ship here).
>
> **Cross-refs:** element tags and reference-library indexing live with `cinema-world-bible`; cinematic scene and environment plates route to `banana-pro-director`; Seedance video prompts route to `cinema-director`.

The locked grammar for building characters and their wardrobes as reusable image assets. A character is not one picture — it is a canonical face lock, a set of identity markers, and a growing library of outfits, all anchored so that every downstream image and video prompt renders the same person.

Three workflows:

| Workflow | Use when |
|---|---|
| **Part 1 — BUILD FROM SCRATCH** | No reference exists. The character is being invented. |
| **Part 2 — ADDITIONS** | The character is locked. Something is being changed or added to them permanently. |
| **Part 3 — OUTFIT BUILDER** | The character is locked. A new fit is being designed and put on them. |

Never skip forward. An outfit cannot be built on a character whose face isn't locked. An addition cannot be made to a character who doesn't exist yet.

---

## CORE PHILOSOPHY

No plastic. No CGI sheen. No 3D-render look. No commercial gloss. No AI-generic skin or hair.

### The two axes — separate these, always

Photoreal character work runs two things that sound like one thing and are not:

**Axis 1 — BIOLOGICAL REALISM: fully on.** The subject must read as a real living person. Real pore texture, real peach fuzz at the jaw and hairline, real subsurface scattering, hair rendered strand by strand with flyaways and baby hairs, real fabric weave and weight and drape, real metal surface on jewelry, real eyes with depth and moisture. This never comes off.

**Axis 2 — PHOTOGRAPHIC CAPTURE BEHAVIOR: off on every character plate.** A character plate is not a photograph. It carries no lighting, no shadow, no lens character, no atmosphere, and no capture artifacts. No key direction, no shadow side, no cast shadow, no contact shadow, no falloff on the background, no light spill, no bokeh, no depth-of-field falloff, no vignette, no flare, no film grain.

The two get tangled constantly because "photorealistic" sounds like it means both. It doesn't. Writing *"photographed on a real camera by a real photographer"* into a character plate switches on Axis 2 along with Axis 1 — and Axis 2 is exactly what poisons a reference. The subject should look like a real person, rendered flat, against nothing.

**Why Axis 2 is off.** These are references, not finished frames. Any lighting information baked into a plate — a cheek triangle, a nose shadow, a contact shadow under the feet, a soft falloff behind the shoulder, a warm bleed on the backdrop — is inherited and amplified by every downstream generation that reads it, and it fights whatever lighting the actual scene wants. The plate carries zero lighting. The scene prompt or the video prompt does all the lighting later.

### The flattering-realism ceiling — LOCKED, every face, every mode

Full skin realism is always on: visible pore texture, peach fuzz, subsurface scattering, hair flyaways, the matte finish that carries the anti-plastic look. But realism never means unflattering. No acne, no blemishes, no prominent spots, no scarring the user didn't ask for, no enlarged or cratered pores, no rough bumpy texture, no aggressive detail that reads clinical. The texture is fine, soft, even, and natural. Matte is the anti-plastic lever; fine-and-even is the flattering lever. Both run together. Where they conflict, resolve toward flattering — a face should always look good.

### Cel-shaded characters

The philosophy inverts. Every image reads as hand-drawn animation production art. Clean deliberate line weight, hard-edged tonal separation, flat color fills, no photographic grain, no lens blur, no airbrush gradients. Axis 1 is off along with Axis 2 — no pore texture, no subsurface scattering, no strand-level hair.

---

## THE FLAT GRAY PLATE (LOCKED DEFAULT FOR ALL CHARACTER WORK)

**18% neutral gray seamless with a completely flat shadowless grade is the locked default** for face locks, character references, outfit plates, character sheets, and prop references. Pure white is the explicit-request exception, used only for a finished standalone still meant to be posted or handed off.

**Why gray.** Pure white and pure black create maximum subject-to-background contrast. Image and video models amplify errors most at high-contrast edges — that's where halo, edge breathing, and contour instability get baked in. A neutral mid-gray ground lowers subject-to-background contrast, giving cleaner edge extraction and far less inherited contrast when the still is read as a reference frame downstream.

**The background stays neutral; the subject does not.** The ground is an even neutral mid-gray, never warm-shifted. But the gray must never cool or neutralize the subject — skin renders at its true natural tone and wardrobe at its true natural color, exactly as under neutral daylight. The relight-from-scratch language and the explicit "warmth preserved and natural, never pale or washed-out or cool-shifted" clause hold this.

**Why flat.** See Axis 2 above. The plate carries zero lighting information so nothing downstream inherits it.

**The background is a field, not a room.** This is the distinction that matters most and the one most often lost. A photographed seamless is a *physical surface* — it takes light, it falls off, it catches spill, it holds the subject's shadow, it has a floor the subject stands on. A character plate background is none of that. It is a flat uniform color field with nothing behind the subject at all: no surface, no floor, no wall, no corner, no seam, no horizon, no plane the subject makes contact with. The subject does not stand on anything and does not stand in front of anything. Nothing the subject does affects the field.

**Zero shadow outside the subject — absolute.** No cast shadow of any kind anywhere in the frame. No contact shadow, no floor shadow, no drop shadow, no ambient occlusion where the body meets the field, no soft darkening behind the shoulders or under the hem, no halo, no edge darkening, no rim of any kind separating the figure from the field. Shading exists only *on* the subject and stops at the subject's silhouette.

**Zero light bleed outside the subject.** No spill, no glow, no bounce, no color cast thrown from the subject or the wardrobe onto the field. No brightening behind the head, no warm bleed off the skin, no reflected color from a bright garment. The field's value is identical at every pixel whether it is beside the subject or in the far corner.

**LOCKED FLAT CLOSE — use verbatim on every photoreal character plate:**

```
The background is a single flat 18% neutral gray field — one uniform value at every pixel corner to corner, identical directly beside the subject and in the far corners, with no seam line, no gradient, no hotspot, no vignette, and no falloff to lighter or darker anywhere in the frame. It is a flat color field, not a photographed backdrop — no surface, no floor, no wall, no corner, no horizon, and no plane the figure stands on or in front of.

Relight from scratch overriding any reference lighting: completely flat shadowless illumination — one enormous soft frontal source at camera position wrapping the subject evenly, matched equal fill from camera-left and camera-right at identical intensity, matched fill from above and below, so both sides of the face read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no cheek triangle, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Extremely low contrast, even, milky, catalogue-flat. Form is described by bone structure, hair strands, and fabric folds alone, not by light and shadow.

Absolutely zero shadow anywhere outside the subject. No cast shadow, no contact shadow, no floor shadow, no drop shadow, no ambient occlusion where the body meets the background, no soft darkening behind the shoulders or beneath the hem, no halo, no edge darkening, and no rim separating the figure from the field. Shading exists only on the subject and stops cleanly at the silhouette. Absolutely zero light bleed outside the subject — no spill, no glow, no bounce, no reflected color cast thrown from the skin or the wardrobe onto the background, and no brightening anywhere behind the figure.

Skin reads matte and velvety — zero shine on forehead, nose bridge, cheekbones, temples, and chin, no oily T-zone. Skin renders at its true natural skin tone and wardrobe at its true natural color, warmth preserved and natural against the neutral gray, never pale or washed-out or cool-shifted by the background. Real peach fuzz at the jaw and hairline, real soft fine even pore texture, subsurface scattering reading as semi-translucent biology, real hair rendered strand by strand with fine flyaways at the hairline, real fabric weave and drape, never plastic, never waxy, never glass-skin, never harsh — fine flattering texture that keeps the face looking good, no acne, no blemishes, no rough pores.

Even sharpness edge to edge across the entire frame. No depth-of-field falloff, no bokeh, no background blur, no lens vignette, no lens distortion, no flare, no bloom, no chromatic aberration, no film grain, no atmospheric haze, no air between the subject and the background.
```

**Four things must appear in every flat close, always:**
1. **Flat field** — one uniform value at every pixel, explicitly a color field rather than a photographed surface
2. **Shadowless illumination on the subject** — huge frontal source, matched fill on all four sides, no key ratio, no rim, no hair light, no kicker
3. **Zero shadow outside the subject** — no cast, contact, drop, occlusion, halo, or edge darkening
4. **Zero light bleed outside the subject** — no spill, glow, bounce, or reflected color onto the field

Miss any one and the plate comes back with lighting information baked into it.

**For sheets:** the flatness must be stated as applying *uniformly across all panels* — same gray value, same shadowless light, no cast shadow in any panel.

---

# PART 1 — BUILD FROM SCRATCH

For any character with no existing reference. Three stages, in order: text spec → style fork → build.

## Stage 1 — The text spec

Let the user describe the character in their own words. Listen, then mirror back a locked spec in plain language covering:

- **Apparent age register** — described by build and bearing, never a number
- **Face** — head shape, bone structure, jaw, chin, cheekbones, brow shape, eye shape and color, nose, lip shape
- **Skin** — tone and finish
- **Hair** — color with every nuance, length, texture, part, styling
- **Body** — build, proportions, posture
- **Default makeup register** — if any
- **Default expression and energy**
- **Identity markers** — piercings with position and metal, scars with placement and size, beauty marks, tattoos, signature jewelry

Iterate the text spec freely until the user says it's locked. Nothing gets generated until they do. Fixing a face in text costs nothing; fixing it after twelve outfits have been built on it costs everything.

## Stage 2 — The style fork

Ask once, before any prompt:

> Photoreal human, or anime / cel-shaded?

The two paths do not share a render register, a tool routing, or a build sequence. Pick one before writing anything.

---

## PATH A — PHOTOREAL HUMAN

Three tools. Ask which before writing anything.

| Tool | Role | When |
|---|---|---|
| **Higgsfield Soul** | Face test pass | Cheap and fast. Throws variations so the user can see the face several ways before committing. |
| **Banana Pro** | Canonical lock — default | Balanced fidelity, reasonable cost, handles any framing. The standard lock tool. |
| **Higgsfield GPT Image 2** | Canonical lock — maximum fidelity | Sharpest read on micro-detail at face-and-shoulders range. Chest-up only. Higher credit cost. |

**The standard sequence is Soul → Banana Pro.** Run Soul first for the test pass, then lock in Banana Pro. Skip Soul only if the user already knows exactly what the face is.

**GPT Image 2 substitutes for Banana Pro at the lock step**, not for Soul. It reads pores, lash separation, iris pattern, lip surface, and hair-strand definition at the hairline noticeably sharper than Banana Pro — worth the credits when the face is the entire point of the image, which on a canonical lock it always is.

**Offer GPT Image 2 whenever a photoreal lock is about to be written**, and whenever the user asks for a highly detailed portrait or headshot on a plain gray field:

> Want the lock on Banana Pro or GPT Image 2? GPT Image 2 reads micro-detail sharper — pores, lash separation, iris pattern — but it's chest-up only and costs more credits.

Mention the credit cost **once per conversation**, then drop it.

**GPT Image 2 constraints:**
- Chest-up framing only. Anything wider loses the fidelity advantage and wastes the credit hit.
- Everything else is identical to the Banana Pro lock — same 3:4 framing, same 17-item description order, same flat plate, same locked close. The tool changes; the grammar does not.
- GPT Image 2 responds especially well to explicit micro-detail language, so a GPT Image 2 lock adds one dedicated fidelity paragraph before the flat close (see below).

**Step A1 — Higgsfield Soul face test.** Cheap, fast, loose. Identity essentials only — no fine markers, no makeup detail, no granular anatomy. Soul can't hold those, and asking it to wastes the pass.

**Step A2 — Canonical lock, 3:4 chest-up, in Banana Pro or GPT Image 2.** Takes the approved Soul plate as the character reference and writes the face out in full detail. This is the image every future prompt anchors to, so it gets the longest, most specific description in the entire skill.

### Step A1 — Soul face test

**Wardrobe lock:** plain black thin-strap camisole for women, plain black ribbed tank for men. No jewelry, no logos, no graphics. Identity-pure.

**Prompt structure — lean, essentials only:**

```
A [heritage] [woman / man] with a [build], [skin tone and finish], [hair color, length, texture]. [Eye shape and color]. [Only large, visually dominant markers — hold fine markers for the lock pass]. [She wears a plain black thin-strap camisole / He wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes to camera, lips closed and relaxed.

The background is a single flat 18% neutral gray field — one uniform value at every pixel corner to corner, no seam line, no gradient, no hotspot, no vignette. It is a flat color field, not a photographed backdrop — no surface, no floor, no wall, no plane the figure stands in front of. Completely flat shadowless illumination — a huge soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the face read at exactly the same brightness. No shadow side, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker. Absolutely zero shadow outside the subject — no cast shadow, no contact shadow, no drop shadow, no ambient occlusion, no halo, no edge darkening. Absolutely zero light bleed onto the background — no spill, no glow, no bounce, no reflected color cast. Extremely low contrast, even, milky, catalogue-flat. Skin renders at its true natural skin tone, warmth preserved and natural against the neutral gray, never cool-shifted or washed-out by the background. Skin reads matte and slightly diffused, clean and even. Chest-up framing.

Real human skin with visible natural pore texture, fine peach fuzz along the jawline, subtle subsurface scattering on the cheeks and ear edges. Hair rendered strand by strand with realistic natural texture and individual flyaways at the hairline. Even sharpness edge to edge, no depth-of-field falloff, no background blur, no vignette, no flare, no grain.
```

Deliberately lean. No full detail stack, no granular anatomy, no makeup paragraph. Let Soul interpret the face from the essentials so the variations are actually different from each other. The user runs several, picks one, and that becomes the reference for Step A2.

### Step A2 — Canonical 3:4 chest-up lock (Banana Pro or GPT Image 2)

**This is the most important image in the character's life.** Everything downstream anchors here. Write it long and write it specific.

**Framing:** 3:4 vertical, forehead to upper chest, the face filling most of the frame. A true close-up headshot, not a portrait with air around it. Chest-up, never waist-up — the whole point is resolution on the face.

**What gets written out in full, in this order:**

1. **Framing declaration** — 3:4 chest-up, forehead to upper chest, face filling the frame
2. **Reference anchor** — "the same character as the attached face plate"
3. **Build and heritage** — one clause
4. **Skin** — tone, undertone, finish
5. **Head and face structure** — head shape, forehead, temples, cheekbone height and projection, cheek hollow, jaw angle and definition, chin shape and projection, the line from ear to chin
6. **Eyes** — shape, set, spacing, tilt at the outer corner, lid crease depth and visibility, iris color with its variation across the iris, limbal ring, pupil, the wet line at the inner corner, under-eye structure
7. **Brows** — shape, arch position, thickness, density, hair direction, color relative to the hair
8. **Lashes** — length, density, curl, separation, upper and lower
9. **Nose** — bridge width and straightness, tip shape and projection, nostril shape and visibility, the shadow-free plane transitions
10. **Lips** — fullness upper versus lower, cupid's bow definition, philtrum length and depth, mouth width, corner shape, natural lip color and surface texture
11. **Ears** — shape and set, whether visible under the hair
12. **Hair** — color with every nuance and any tonal variation root to tip, length, texture, part, how it falls, hairline shape, baby hairs
13. **Makeup register** — if any, as a default that swaps freely later
14. **Identity markers** — each with exact placement: piercings by position and metal, beauty marks by location, scars by placement and size, visible tattoos
15. **Wardrobe** — plain black camisole or ribbed tank, no jewelry, no logos
16. **Pose and expression** — squared to camera, head level, neutral relaxed, eyes to camera, lips closed
17. **The LOCKED FLAT CLOSE** — verbatim

**Prompt structure:**

```
A clean cinema-character-reference 3:4 headshot of the same character as the attached face plate, framed from the forehead down to the upper chest with the face filling most of the frame — a true close-up, not a portrait with space around it.

[Build and heritage.] [Skin tone, undertone, and finish.] [Head and face structure — head shape, forehead, temples, cheekbone height and projection, cheek hollow, jaw angle, chin shape, the line from ear to chin.] [Eyes — shape, set, spacing, outer-corner tilt, lid crease, iris color and its variation across the iris, limbal ring, under-eye structure.] [Brows — shape, arch position, thickness, density, direction, color.] [Lashes — length, density, curl, separation, upper and lower.] [Nose — bridge, tip, nostrils.] [Lips — upper versus lower fullness, cupid's bow, philtrum, mouth width, corner shape, natural color and surface texture.] [Ears — shape, set, visibility under the hair.] [Hair — color with every nuance and tonal variation root to tip, length, texture, part, fall, hairline shape, baby hairs.] [Default makeup register, if any.] [Every identity marker with exact placement — piercings by position and metal, beauty marks by location, scars by placement and size, visible tattoos.]

[She wears a plain black thin-strap camisole / He wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes directly to camera, lips closed and relaxed, subtle controlled energy.

[LOCKED FLAT CLOSE — verbatim]
```

The output is the canonical character reference. Every future prompt for this character attaches it.

**GPT Image 2 addition.** When the lock runs on GPT Image 2, insert one dedicated fidelity paragraph between the pose line and the flat close. GPT Image 2 rewards explicit micro-detail language in a way Banana Pro does not:

```
Extreme face fidelity. Real skin texture with visible individual pores, fine peach fuzz catching light along the jawline and upper lip, subtle subsurface scattering across the nose bridge, cheeks, and ear edges reading as semi-translucent biology. Individual lash separation, upper and lower. Real moisture and reflection in the iris with a visible fibrous iris pattern radiating from the pupil and a soft limbal ring at the outer edge. Real lip surface texture with fine natural vertical lip lines. Hair rendered strand by strand at the hairline with visible baby hairs and individual flyaways. Visible fabric weave at the collar and shoulder. Micro-expression detail held in the eye corners and the mouth corners.
```

Everything else in the GPT Image 2 lock is identical to the Banana Pro lock — same framing, same description order, same flat close, chest-up only.

---

## PATH B — ANIME / CEL-SHADED (single-step, Banana Pro)

Built directly in Banana Pro. No test pass — cel-shaded output is deterministic enough that the detailed prompt gets there in one shot, and a Soul test pass would return a photoreal face that fights the style.

**Go full detail.** Cel-shaded characters live or die on specificity, because the style strips away the incidental realism that would otherwise carry identity. Every simplification is a decision that must be made explicitly.

### The sub-style fork

Ask which register before writing:

| Register | Line | Shading | Eyes | Palette |
|---|---|---|---|---|
| **Modern TV anime** | Clean thin uniform, dark brown-black | 2-tone cel, soft-edged shadow | Large, multi-layer iris, 1–2 highlights | Bright, moderately saturated |
| **90s cel / retro** | Thicker, slight variation, hard black | 2-tone cel, hard-edged shadow | Rounder, simpler iris, single highlight | Muted, film-print warmth |
| **Manhwa / webtoon** | Very fine, tapering, often colored | 3-tone with soft gradient in hair | Detailed, glossy, heavy lower lash | High-key, pastel, airy |
| **Shonen action** | Bold varying weight, heavy black | 2-tone, hard shadow, strong rim | Sharp, angular, small highlight | Saturated, high contrast |
| **Shojo** | Delicate, tapering, brown-toned | Soft 2-tone, blush-heavy | Very large, deep multi-layer iris, many highlights | Soft, warm, pale |

### What must be specified explicitly

**Line art:** weight and whether it varies · color (pure black, dark brown, or color-matched to the fill it borders) · whether lines close fully or break · line weight on the face versus the body versus the hair.

**Cel shading:** the tone count — two-tone (base plus shadow) is the default; three-tone adds a highlight band · whether shadow edges are hard or slightly softened · where the light comes from, since cel shadows are drawn shapes and need a stated direction even on a flat plate · whether there is any bounce or rim tone at all.

**Color fill:** flat and uniform within each shape · no airbrush gradients · no photographic texture · no noise.

**Eyes — the single most important identity element in cel work.** Specify: overall shape and tilt · iris size relative to the eye opening · the number of iris layers and their colors from outer ring inward · the pupil size and shape · the highlight count, size, and position · whether there is a lower-lid light reflection · upper lash line weight and how far it extends past the outer corner · lower lash presence · the gap between the lash line and the iris top.

**Hair:** rendered in clumped wedges and locks, never individual strands · the number and shape of the front pieces framing the face · the crown shape and how the part reads · the highlight band — its shape, whether it is a single sweep or broken segments, and its color · how the hair overlaps the eyes and brows.

**Face simplification:** how the nose is drawn — a single line, a small wedge, a dot, or a full shape · how the mouth is drawn at rest · whether the ears are drawn in detail or simplified · whether there is a blush and how it is rendered.

**Anti-tells — mandatory negation battery:**

```
No 3D render, no CGI, no photographic texture, no photorealistic skin, no airbrush gradient shading, no soft blurred rendering, no digital painting blend, no lens blur, no depth-of-field falloff, no film grain, no photographic noise, no bloom, no chromatic aberration, no realistic subsurface scattering, no rendered specular highlights on skin.
```

Without that battery the model drifts toward a smooth semi-realistic digital painting that reads as neither anime nor photo.

### Prompt structure — Path B

```
A clean anime character reference illustration, [sub-style register], framed 3:4 from the forehead down to the upper chest with the face filling most of the frame.

[Build and apparent register.] [Skin — flat fill color and undertone.] [Face shape — head silhouette, jaw, chin, cheek line.] [Eyes — shape, tilt, iris size relative to the opening, the iris layers from outer ring inward with their colors, pupil size and shape, highlight count and position, lower-lid reflection, upper lash line weight and extension, lower lash treatment.] [Brows — shape, weight, position relative to the eye, color.] [Nose — exactly how it is drawn.] [Mouth — exactly how it is drawn at rest, width, corner shape.] [Ears — drawn or simplified.] [Blush — present or absent, and how rendered.] [Hair — color as a flat fill plus its shadow tone, the clump and wedge structure, the number and shape of the front framing pieces, the crown and part, the highlight band shape and color, how it overlaps the eyes and brows.] [Identity markers — drawn as deliberate marks with exact placement.]

[Wardrobe — plain black camisole or ribbed tank for an identity-pure plate.] Body squared to camera, head level, neutral expression, eyes to viewer, mouth closed.

Line art: [weight and variation], [color], [closure behavior], [any weight differences between face, body, and hair]. Cel shading: [tone count], [hard or slightly softened edges], light reading from [direction], [rim or bounce tone or none]. All color fills flat and uniform within each shape, no gradients inside a fill.

Background is a single flat [neutral mid-gray / specified color] field, one uniform value at every pixel corner to corner, no gradient, no texture, no vignette. Absolutely zero shadow outside the figure — no cast shadow, no contact shadow, no drop shadow, no ambient occlusion, no halo, no edge darkening — and zero light bleed onto the field.

Hand-drawn animation production art. Clean deliberate line work, hard-edged tonal separation, flat color fills. No 3D render, no CGI, no photographic texture, no photorealistic skin, no airbrush gradient shading, no soft blurred rendering, no digital painting blend, no lens blur, no depth-of-field falloff, no film grain, no photographic noise, no bloom, no chromatic aberration, no realistic subsurface scattering, no rendered specular highlights on skin.
```

---

# PART 2 — ADDITIONS TO AN EXISTING CHARACTER

For a character who already has a canonical reference. Something is being changed or added **permanently** — this is not an outfit, and it is not a one-off scene styling.

## What counts as an addition

| Addition | Notes |
|---|---|
| **Hair color change** | The most common. Full re-lock required. |
| **Hair length or cut change** | Full re-lock required. |
| **New permanent piercing** | Position and metal specified exactly. |
| **New tattoo** | Placement, size, orientation, line weight, and content described in full. |
| **Scar** | Placement, size, age of the scar, raised or flat, color relative to surrounding skin. |
| **Default makeup register change** | Re-lock only if it changes how the face reads at rest. |
| **Expression set** | Adding a second canonical expression to the character's library. |
| **Aging up or down** | Full rebuild, not an addition — go back to Part 1. |
| **Body change** | Full re-lock required. |

## The identity firewall

Every addition prompt must state what is changing **and** state that everything else is held. Without the hold clause, changing hair color drifts the jaw, the eye shape, and the skin tone along with it.

**The hold clause — use verbatim, adjusted for what's changing:**

```
Everything about the character other than [the specific change] is identical to the attached reference and unchanged — the same head shape, the same bone structure, the same jaw and chin, the same cheekbones, the same eye shape and spacing and tilt, the same iris color, the same brow shape, the same nose, the same lips and mouth width, the same ears, the same skin tone and finish, the same build and proportions, and every existing identity marker in the same position. Only [the specific change] is different.
```

## The re-lock rule

**Any addition that changes how the face reads at rest requires a new canonical plate.** Hair color, hair cut, facial piercings, facial scars, and permanent makeup all cross this line. Generate the addition as a fresh 3:4 chest-up lock in the same framing, same wardrobe, same flat plate, and the same style path as the original — and the new plate becomes the character's canonical reference from that point forward.

Additions that don't touch the face at rest — a body tattoo under clothing, a hand tattoo, an ear piercing hidden by hair — can be documented in the character's written spec and written into outfit prompts as needed, without a new face plate.

**Version the plates.** When a character gets a re-lock, both plates continue to exist and refer to different states of the character. Name them so the distinction survives — `[character]-lock-01`, `[character]-lock-02-red-hair`. Always confirm which lock is being anchored to before building an outfit on it.

## Prompt structure — additions

```
A clean [cinema-character-reference / anime character reference] 3:4 headshot of the same character as the attached reference, framed from the forehead down to the upper chest with the face filling most of the frame.

[The change, described in full detail. If it is hair: the new color with every nuance and any tonal variation root to tip, the new length, the new texture, the new part, how it falls, the hairline, baby hairs. If it is a marking: exact placement described relative to a fixed anatomical landmark, exact size, exact orientation, exact color and finish, whether raised or flat, line weight if it is a tattoo.]

[The hold clause — verbatim.]

[Wardrobe — the same plain black camisole or ribbed tank as the original lock], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes directly to camera, lips closed and relaxed.

[LOCKED FLAT CLOSE for photoreal, or the cel render close for anime — matching the original build path.]
```

## Expression sets

A character can carry more than one canonical expression. Useful for characters who appear across a lot of material with a consistent emotional register.

Build them as a 3-panel sheet in one image so the identity holds across all three: neutral at rest, the character's signature expression, and one extreme. Each panel is the same framing, the same lighting, the same wardrobe — only the face changes.

State per panel exactly which muscles move: brow position, lid aperture, mouth corner direction, jaw, whether teeth show, where the eyes look. Never name the emotion alone. *"Brows drawn slightly together and down at the inner ends, upper lids lowered a fraction, mouth corners level and pressed, jaw set"* renders. *"Angry"* does not.

---

# PART 3 — OUTFIT BUILDER

For a character with a locked face. Three steps. Skipping step 2 is the single most common cause of an outfit rendering wrong.

## Step 1 — The wardrobe proposal (text only)

Before any image, write the outfit out in plain text and wait for approval. Never combine a wardrobe proposal with an image prompt in the same message.

Cover, head to toe:
- **Every garment** — color, fabric, weave or finish, cut, fit, neckline, sleeve, hem position, closures, how it sits on the body
- **Layering** — what goes over what, what's open, what's tucked
- **Structural detail** — cutouts, panels, boning, ruching, pleats, distressing, hardware
- **Footwear** — style, material, heel height and shape, how it interacts with the hem
- **Jewelry** — every piece, metal, scale
- **Accessories** — bags, belts, gloves, eyewear, headwear
- **Nails** — length, shape, finish
- **Hair styling for this outfit** — if it differs from the character's default
- **Makeup for this outfit** — if it differs from the default

Iterate on text until locked. Text iteration is free.

## Step 2 — Build the outfit

Two paths. **Default to the direct build and encourage it.** Only route to the mannequin path when the outfit genuinely earns it.

### Path 1 — DIRECT ON THE MODEL (default, encouraged)

Build the outfit straight onto the locked character in one generation, **9:16 vertical, full body**. The character reference is attached; the prompt writes the wardrobe.

This is the right call for most outfits. It's one generation instead of several, the fit reads on the character's actual proportions from the start, and there's no compositing step to degrade identity.

**Why 9:16.** A full-body outfit reference needs the frame to be taller than it is wide. 9:16 gives the garment the vertical pixel budget — hem lengths, break at the ankle, footwear, and drape all read at usable resolution instead of getting squeezed into the middle of a square.

**Prompt structure — Path 1:**

```
A full-body character reference of the same man as the attached character reference, standing [pose], framed head to toe in a tall vertical 9:16 frame with the full figure and the footwear entirely within the frame.

[Identity restated briefly — build, skin, hair, face register. Two or three clauses only; the reference carries the rest.]

He wears [the full outfit head to toe — every garment with color, fabric, weave or finish, cut, fit, collar or neckline, sleeve, hem position, closures, structural detail, how it sits and moves on the body, layering, footwear, jewelry, accessories, nails].

[Pose and expression.]

[LOCKED FLAT CLOSE — verbatim, adjusted to full-body framing.]
```

### Path 2 — INVISIBLE MANNEQUIN GARMENT PLATES (complex outfits only)

For outfits with multiple custom pieces, unusual construction, heavy hardware, or a specific designed cut that a direct build would round off toward something generic.

**Step 2A — Build each piece in Banana Pro on an invisible mannequin.** One plate per garment, or grouped when pieces read together. The garment holds its full three-dimensional worn shape with no body inside it — collar and cuffs holding their own volume, the opening reading as an empty dark hollow looking down into the inside of the garment, real fabric tension across the chest and shoulders, natural drape and weight, but nothing emerging from any opening.

Because there's no face and no body competing for attention, the entire prompt can be about the garment. This is what makes it hold custom construction that a direct build loses.

**Prompt structure — Step 2A:**

```
A garment reference of a single [garment type] worn on an invisible body, floating in frame and holding its full three-dimensional worn shape.

[The garment in complete detail — color, fabric, weave or finish, cut, fit, collar or neckline construction, sleeve, hem, closures, seams, panels, hardware, pockets, print or pattern with its scale and layout, lining if visible.]

There is no head, no neck, no hands, and no body anywhere in the frame — the garment reads as worn by an invisible figure with full volume, natural drape, and real fabric tension across the chest and shoulders, the collar and cuffs holding their own three-dimensional shape, every opening reading as an empty dark hollow looking down into the inside of the garment with the inner back of the fabric faintly visible. No stump, no skin, no cut edge, no anatomy, no mannequin form, no hanger, no stand, not blurred, not faded, no ghosting, no transparency.

[LOCKED FLAT CLOSE — verbatim.]
```

<!-- STUDIO-LOCAL BEGIN -->
**Escalation chain if the silhouette or fabric doesn't hold (studio addition):** Soul Cinema first (cheapest, fastest test) → Banana Pro if Soul Cinema can't hold the shape → GPT Image 2 if Banana Pro still can't resolve fine construction detail (boning, structured seams, complex draping) — using the same headless framing discipline as Step 2A above (see also *The headless 3-panel sheet — Seedance handoff* below for the sheet-level equivalent). Once the garment plate holds visually, proceed to Step 2B as normal.
<!-- STUDIO-LOCAL END -->

**Step 2B — Bring the garment plates to Banana Pro with the character.** Attach the character reference plus every garment plate, and compose the full look on the character in one generation.

```
A full-body character reference of the same man as the character reference, wearing the garments from the attached garment references, framed head to toe in a tall vertical 9:16 frame.

Keep every garment exactly as shown in its reference — the same color, the same fabric, the same cut and fit, the same collar and cuffs, the same hem position, the same closures, the same hardware, and the same print or pattern at the same scale. Keep the character's identity exactly as shown — the same face, the same bone structure, the same eye shape and color, the same skin tone, the same hair, and every identity marker in the same position.

[Layering — what goes over what, what is open or closed, what is tucked.] [Footwear, jewelry, and accessories not covered by a garment plate.] [Pose and expression.]

[LOCKED FLAT CLOSE — verbatim, adjusted to full-body framing.]
```

### Choosing the path

**Direct (Path 1)** — a shirt and trousers, a dress, a suit, a jacket over a tee, a matching set, anything the model already understands as a category. Most outfits.

**Mannequin plates (Path 2)** — heavily constructed pieces, unusual silhouettes, custom hardware, garments whose whole point is a specific detail that would get averaged away, or a look where the user wants each piece designed and approved independently before it's committed to the character.

**When in doubt, run Path 1 first.** It's one generation. If the garment comes back rounded off toward generic, that's the signal to fall back to Path 2 for the piece that failed — and only that piece.

## The 3-panel character sheet

Built only after an outfit plate exists on the locked character and the user is happy with it. One image, three vertical panels, one prompt.

### Attach the outfit render alone — not the face lock

**Default: the approved full-look outfit render is the only reference.** It already carries the face, the hair, the skin, the build, the wardrobe, and every accessory in one image, all of them already agreeing with each other. It is a strictly better reference for a sheet than the outfit render plus the face lock, because it needs no reconciliation.

**Adding the canonical face lock alongside it is usually a downgrade.** Two references means two sources for the same face, and the model has to reconcile them — different framing, different crop, different neutral wardrobe, different hair state. That reconciliation costs attention that should be going to the panel geometry and the garment, and on a three-panel sheet the attention budget is already split three ways. Overloading references is one of the most reliable ways to get a mushy sheet.

**Attach the face lock as a second reference only when there's a specific reason:**
- Identity has visibly drifted in the outfit render and needs pulling back toward canon
- The outfit render obscures the face — heavy eyewear, a mask, a hood, deep shadow, a turned head
- The outfit render came out soft or low-detail in the face
- A previous sheet attempt returned a face that doesn't match
- The user explicitly wants the sheet re-anchored to the original lock

When it is attached, say what each reference is for in the prompt body so the model doesn't average them: *"the face, bone structure, and skin tone come from the face reference; the wardrobe, hair styling, and accessories come from the look reference."*

**The same economy applies everywhere in this skill.** More references is not more control past the point where they start disagreeing. Attach the fewest images that carry everything the prompt needs, and prefer one image that already resolves a combination over two that have to be merged.

### Layout
1. **LEFT — full body front, headless.** Full headroom preserved — the head is *removed from the body*, not cropped by the frame edge. Isolates the garment, the silhouette, and the proportions with no facial data competing.
2. **CENTER — full body rear, head attached.** Hair fall, back construction, hem, footwear all readable from behind.
3. **RIGHT — tight chest-up face lock.** Just above the crown down to the collarbones. The face fills the panel. This is the identity anchor and it must be tight.

> The head-attached CENTER panel above is the general-purpose default. For a Seedance Subject Lock anchor — where every panel should carry no more than one face — see *The headless 3-panel sheet — Seedance handoff* below.

**The headless cut — pick by garment:**

*Variant A — ghost mannequin.* For structured or closed necklines sitting at or above the collarbone — collars, crew necks, ribbed tanks, turtlenecks, hoods, jacket collars, keyholes. No head and no neck at all; nothing rises above the shoulder line. The collar holds its own three-dimensional shape and the opening reads as an empty dark hollow looking down into the inside of the garment, the inner back of the fabric faintly visible.

*Variant B — clean neck cut.* For garments with no neckline to hollow — strapless, halter, spaghetti strap, deep cowl, scooped or plunging. The neck rises a short way from the shoulders and terminates in a clean flat sharply defined horizontal edge at the base of the throat, like a headless dress-form mannequin.

**Both variants ship the same suppression stack:** not blurred, not faded, not dissolving, no wisps, no smoke, no ghosting, no transparency in the body, no stump, no anatomy detail at the cut, no blood. And the hair goes with the head — no hair falling across the chest or shoulders in the left panel.

**Critical rules:**
- One prompt, one code block, one image. Never three separate prompts.
- **The approved outfit render is normally the only reference.** Add the face lock only for a stated reason, and say what each reference carries when you do.
- Identity and wardrobe described **once** in opening paragraphs, applying to all three panels.
- Each panel describes only what differs — angle, framing, head state.
- **Skin-tone consistency clause is mandatory.** Rear panels drift darker without it: *"skin renders at its true natural skin tone, identical in value and hue across the face, arms, and body in every panel, never darkened, never tanned, never pale or washed-out."*
- Backdrop and lighting uniform across all three cells, stated explicitly as uniform.
- Every panel carries its position label so the grid composes correctly.

<!-- STUDIO-LOCAL BEGIN -->
## The headless 3-panel sheet — Seedance handoff

> Studio addition — not part of the upstream character-builder grammar. Built as a Seedance Subject Lock anchor: both flanking panels are headless (front AND back), and the face lives in exactly one panel, so Seedance locks identity from a single clean portrait and pulls silhouette, wardrobe, and posture from the panels that carry no face at all. Keep this section self-contained so upstream skill updates diff cleanly against it.

**When to use:** A Seedance-handoff reference sheet, built to anchor Subject Locks for downstream video generation — not a general-purpose character reference. Same gate as the standard 3-panel sheet: only built after an outfit plate exists on the locked character and the user is happy with it.

**Why this exists, vs the standard 3-panel sheet:** Seedance locks identity most reliably from a single clean face and pulls silhouette, wardrobe, and posture from panels that carry no face at all. If every panel on the sheet shows a face, Seedance averages across them and the character drifts or slips identity in motion. The standard sheet's CENTER panel keeps the head attached on the rear view — useful as a general-purpose reference, but not what Seedance wants. This variant puts the face in exactly ONE panel and keeps the other two panels headless (front AND back).

**Layout — one 16:9 frame, three vertical panels, in this fixed order:**
1. LEFT — headless full-body front (head/face/hair/neck completely absent).
2. MIDDLE — headless full-body back (same pose rotated 180°, garment back construction, hair fall if visible from behind, footwear — head/face/neck still absent).
3. RIGHT — face portrait (tight framing crown to top of neckline/collarbone; the ONLY panel with a face; full identity description written once, here).

**Backdrop and lighting:** one continuous flat gray field behind all three panels, all three lit as one cohesive session with the same locked flat grade used across every other character mode in this skill — matched flat value, matched shadowless illumination, matched grain, matched fabric rendition, zero shadow outside the subject in any panel, zero light bleed onto the field in any panel. Thin subtle vertical seams separate the panels visually; no border frames, no captions, no text. White field only on explicit request, per the studio's gray policy — and the flatness survives the swap.

**Headless panel language (mandatory, both LEFT and MIDDLE panels):** "The head, face, hair, and neck are completely absent from the frame — no floating hair, no ghosted outline, no cutout edge, no visible cross-section, no stump, no blur, no shadow of a head, the flat gray field continues cleanly and uninterrupted through the entire space where the head and neck would be." The garment's neckline/collar sits tied and structured naturally at the collarbone "as if worn on an invisible neck," holding its shape and gathered folds intact.

**Per-panel realism placement:** subsurface scattering and pore/peach-fuzz detail located explicitly per panel — cheeks and ear edges in the face panel, back of the neck and shoulders in the back-body panel — rather than repeated identically across all three. Skin and fabric render at their true natural tone against the neutral gray, never cool-shifted, matching this skill's flat-plate language used elsewhere.

**Canonical prompt structure:**
```
A single 16:9 cinema-character-reference sheet composed as three vertical panels side by side against one continuous flat gray field, completely flat corner to corner in every panel, all three panels lit as one cohesive session with matched flat shadowless light, matched color, matched grain, and matched fabric rendition. Thin subtle vertical seams separate the panels visually but the field reads as continuous flat gray behind all three, no border frames, no captions, no text.

LEFT PANEL — headless full-body front: [pose/outfit/markers]. The head, face, hair, and neck are completely absent from the frame — no floating hair, no ghosted outline, no cutout edge, no visible cross-section, no stump, no blur, no shadow of a head, the flat gray field continues cleanly and uninterrupted through the entire space where the head and neck would be. The neckline sits tied and structured naturally at the collarbone as if worn on an invisible neck. Full body framing from where the head would be down to below the feet/heels.

MIDDLE PANEL — headless full-body back: same stance rotated 180 degrees. [hair fall / garment back construction / accessories and footwear]. Head, face, hair, and neck completely absent from the frame, as described above — the flat gray field continues uninterrupted through the space where the head and neck would be.

RIGHT PANEL — head and face portrait: crown to neckline/collarbone. [full identity description]. Body squared to camera, head level, eyes to camera.

[LOCKED FLAT CLOSE — verbatim, stated as applying uniformly across all three panels, with the per-panel realism placement above woven in.]
```

**One prompt, one 16:9 frame** — same single-prompt discipline as the standard 3-panel sheet; never deliver three separate prompts.

**This sheet vs the standard 3-panel sheet — when to pick which:** the standard sheet (head-attached CENTER) is the general-purpose multi-angle character reference and the default when the user just asks for "a character sheet." This headless variant is purpose-built as a Seedance Subject Lock anchor — offer it specifically when the reference feeds Seedance, not as a default replacement.
<!-- STUDIO-LOCAL END -->

---

## READING REFERENCE IMAGES

When the user uploads references, extract everything visible by **visual description only** — never use names, never invent what isn't there.

- **Hair** — color with every nuance, length, style, texture, part, styling treatment, accessories
- **Makeup** — skin finish, coverage register, brow shape and density, eye treatment, lashes, lip, cheek, face jewelry, freckles or beauty marks *only if visible*
- **Wardrobe** — every garment top to bottom: fabric, color, fit, structural detail, neckline, sleeve, hem, layering
- **Jewelry and accessories** — every piece, metal, scale
- **Body markers** — piercings and tattoos *only if visible*, nail length and finish
- **Pose and energy** — body angle, weight, hands, expression register

**No-invention rule.** If something is needed for the prompt but isn't in the reference or the spec, ask before composing. Never fill a gap with a guess — a guessed detail that renders becomes canon by accident.

---

## UNIVERSAL RULES

1. **No character names in prompt output.** Describe by hair, wardrobe, and identity markers. The tools don't know names; visual descriptors survive across prompts.
2. **No aspect ratios in prompt output.** Set in the Higgsfield UI. Describe framing in words — "3:4 chest-up headshot," "full body," "tight close-up."
3. **No `@image` tags or placeholders.** Attachment happens in the UI. The prompt is text-only and refers to references in prose — "the attached face plate," "the character reference," "the outfit reference."
4. **No internal production context.** Every prompt is standalone and self-contained.
5. **Pure visual description only.** No meta-commentary, no explanation of intent, no references to the medium.
6. **No teeth-showing smiles** unless explicitly requested. Default is model face-card neutral, or a slight closed-lip smirk.
7. **Default pose for outfit work is the cocked-hip model stance** — weight on one hip, body angled 15 to 30 degrees from camera. Not a straight-on catalogue stance, which is reserved for the neutral outfit model in Step 2.
8. **Age-blind.** Describe by build, bearing, role, and wardrobe — never by age word or number.
9. <!-- STUDIO-LOCAL BEGIN: upstream ships an inverted rule here (brand names, text, and graphics named and rendered on request) — studio default is prohibition with an authorised override; re-graft on future upstream updates. --> **No unauthorised real brand names in prompt output.** Use generic visual descriptors. **Override:** when the user explicitly supplies a real brand name and either confirms the rights (the client's own brand under an engagement) or explicitly accepts the risk (personal, non-commercial work), write it verbatim and describe its physical marks — shape, colour, placement, legibility — so the model has something to draw. Never introduce a real brand the user didn't name. <!-- STUDIO-LOCAL END -->
10. **Flat grade on every character plate and sheet.** Directional cinematic lighting belongs in scene plates, never in a character reference.
11. **Single fenced code block on output.**

---

<!-- STUDIO-LOCAL BEGIN -->
## PRE-PROMPT CONFIRMATION (STUDIO-LOCAL)

> Studio addition — grafted from `banana-pro-director`'s universal pre-prompt confirmation rule, adapted to character work. Upstream's DELIVERY FORMAT section below does not gate a first delivery on user confirmation; this studio adds that gate ahead of it.

Every **first** full prompt in a build — a new character's canonical lock, a permanent addition, an outfit build, or either character sheet format — is preceded by a short "here's what I'm about to prompt, sound good?" check before the fenced code block. Format: clean bullet points only, no quote blocks, no narrative wrapper. **References listed first, always**, then character/change/outfit, then backdrop, then framing where non-default. Close with a single short question ("Sound good?" / "Lock it?" / "Run it?"). Wait for the green light before delivering the code block.

**Exception — minor iteration on an already-approved prompt.** This lines up with the DELIVERY FORMAT section below: any tweak to an already-approved prompt (palette, framing, pose, lighting, a single garment swap, a styling nudge) ships as the revised full prompt directly, no confirmation bullets. Re-check only on a full scope change — a new character, a new outfit, a new mode, or a new style path.

**Wardrobe proposals still gate on text approval first**, per Part 3 Step 1 — that approval is separate from, and precedes, the pre-prompt check on the resulting image prompt.
<!-- STUDIO-LOCAL END -->

---

## DELIVERY FORMAT

Three parts:

**1. Bolded title line.** Names what's being built and which step it is.
`**Face lock — step 2 of 2, Banana Pro 3:4 —**`

**2. Numbered reference list.** One line per attached reference. If none: `No references — text-only build.`

**3. One fenced code block.**

**Tool routing goes in the title**, so the user knows where to paste: Soul, Banana Pro, or GPT Image 2. Both the standard 3-panel sheet and the headless Seedance-handoff sheet route to Banana Pro, one prompt each.

**On iterations — deliver directly.** Any tweak to an already-approved prompt (palette, framing, pose, lighting, a single garment swap, a styling nudge) ships as the revised full prompt with no confirmation bullets. Re-check only on a full scope change — a new character, a new outfit, a new mode, or a new style path.

**Wardrobe proposals are the exception to deliver-by-default.** A new outfit always gets its text proposal approved before any image prompt is written, and the two never ship in the same message.

---

## PRE-DELIVERY PASS

- [ ] Which part of the skill applies — build from scratch, addition, or outfit — and the prerequisite for that part exists
- [ ] For a new character: text spec locked and approved before any generation
- [ ] Style path forked and the render register matches it throughout
- [ ] Photoreal builds route Soul for the test pass, and Banana Pro or GPT Image 2 for the lock — with the GPT Image 2 option offered and its credit cost mentioned once per conversation
- [ ] GPT Image 2 locks are chest-up only and carry the extreme-fidelity paragraph
- [ ] The lock pass is 3:4 chest-up with the face filling the frame, never waist-up
- [ ] Every facial plane, the eyes in full, and every identity marker with exact placement are written into the lock
- [ ] Anime builds carry line spec, cel tone count, shading direction, full eye construction, hair clump structure, and the anti-tell negation battery
- [ ] Additions carry the hold clause and trigger a re-lock if they change the face at rest
- [ ] Outfits went through the text proposal, then a direct 9:16 build on the locked character — or invisible-mannequin garment plates first if the outfit was complex enough to earn it, escalating Soul Cinema → Banana Pro → GPT Image 2 if construction detail doesn't hold
- [ ] Character sheets have identity and wardrobe described once, the correct headless variant, and the skin-tone consistency clause
- [ ] The correct sheet format was picked — the standard head-attached-CENTER sheet as the general-purpose default, or the headless Seedance-handoff variant only when the reference explicitly feeds Seedance
- [ ] If building the headless Seedance-handoff sheet: both flanking panels (front and back) are headless, the face lives in exactly the RIGHT panel only, and the per-panel realism placement is stated
- [ ] Reference economy — the fewest images that carry what the prompt needs, and no canonical face lock stacked onto a sheet without a stated reason
- [ ] Axis 1 on and Axis 2 off — biological realism written in full, zero photographic capture behavior anywhere in the plate
- [ ] Flat gray field, shadowless light on the subject, zero shadow outside the subject, zero light bleed onto the field — stated per panel on sheets
- [ ] No names, no aspect ratios, no placeholder tags, no meta-commentary
- [ ] Pre-prompt confirmation delivered and confirmed on the first prompt of a build (see PRE-PROMPT CONFIRMATION above)
- [ ] Bolded title with tool routing, numbered reference list, one code block

**Repair pass:**
- Face drifting between outfits → the lock plate isn't tight enough; rebuild it chest-up with fuller facial description
- Outfit rendering generic or rounded off → fall back to an invisible-mannequin garment plate for the piece that failed, and only that piece (escalate Soul Cinema → Banana Pro → GPT Image 2 if it still won't hold)
- Rear panel skin darker than front → the skin-tone consistency clause is missing
- Shadow appearing under the feet or behind the shoulder → the zero-shadow-outside-the-subject clause is missing or too short
- Background brightening or picking up color near the figure → the zero-light-bleed clause is missing
- Background reading as a lit wall or floor rather than a flat field → the "color field, not a photographed backdrop" line is missing
- Modelling appearing on the face → one of the four flat requirements is missing
- Grain, vignette, or background blur appearing → capture-behavior language leaked in from Axis 2
- Anime output reading semi-realistic → the anti-tell negation battery is incomplete
- Hair color change also changed the face → the hold clause is missing or too short
- Identity marker in the wrong place → it was described relative to nothing; anchor it to a fixed anatomical landmark
- Sheet coming back mushy or averaged → too many references disagreeing; drop back to the single approved outfit render
- Face on a sheet drifting off canon → this is the case where the face lock earns its slot; attach it and state what each reference carries
- Every panel on a Seedance-handoff sheet carries a face → wrong format built; rebuild with only the RIGHT panel carrying a face and the other two headless front and back
