---
name: character-builder
description: "Photoreal character and outfit builder for Higgsfield image prompts, primarily Banana Pro. Five modes: face lock (a brand-new character built into a canonical 3:4 chest-up identity plate); additions (hair changes, piercings, tattoos, scars, expression sets, re-locks); outfit builder (garment references straight onto the locked character in one direct full-body build, invisible-mannequin plates only as repair); outfit replacement (two-reference swap onto an outfit and pose); character sheets (3-panel default, 6-panel on request, headless Seedance-handoff sheet for Subject Lock anchors). All plates render on a flat 18% neutral gray field, shadowless, zero cast shadow, carrying no lighting downstream. Reads references for hair, makeup, wardrobe, jewelry, and identity markers. Photoreal humans only. Use for building a character, locking a face, changing hair or markings, putting an outfit on a character, swapping a face onto an outfit, generating a character sheet, or any photoreal character reference still."
---

# Character Builder — Photoreal Character & Outfit Grammar

<!-- STUDIO-LOCAL BEGIN: version and provenance record plus skill cross-refs — upstream ships neither, and this studio needs the adoption trail to keep future drops mechanical. -->
> **Version:** Base-flipped 19/08/2026 onto the upstream drop-3 `character-builder` skill (590 lines, Modes 0–4), replacing the drop-2 install of 04/08/2026 (Parts 1–3). Studio-local additions are marked inline with `STUDIO-LOCAL` comment wrappers, among them: the pre-prompt wait clause, the headless 3-panel Seedance-handoff sheet (migrated from `banana-pro-director`'s former Mode 2C), the garment-plate escalation ladder re-scoped as a repair-time tool, the authorised-brand override on rules 2 and 9, the sheet-routing pointers, and the studio checklist and repair rows.
>
> **Retired on this fold:** the anime / cel-shaded build path. It came from upstream drop 2, was never studio IP, and upstream drop 3 retracted it to the photoreal-only line below. Photoreal is this pipeline's premise.
>
> **Adopted from upstream on this fold, replacing studio text:** prompt economy, the material-override rule, the native pre-prompt check (upstream converged on the studio's drop-2 graft, so it is no longer marked as a divergence), mannequin plates as repair only, Mode 3 outfit replacement, the Mode 0–4 numbering, and the LOCKED FLAT CLOSE verbatim including its 50mm / soft-natural-film-grain closing line — grain is not lighting, so it does not breach Axis 2, and taking it resolves the drop-2 file's contradiction between a blanket grain ban and the sheets' matched-grain requirement.
>
> **Model-label sweep — declared collectively here rather than wrapped at every site.** Upstream's `Nano Banana Pro` is written as `Banana Pro` and `GPT-2` as `GPT Image 2` at every occurrence, frontmatter and body alike, matching Higgsfield's current product naming and the corpus label standard. Labels only — no routing, mode, or behaviour change.
>
> **Locale — upstream US English deliberately retained.** The drop-3 base is written in US English throughout, author-facing doctrine as well as verbatim prompt text; a locale check at adoption returned 61 US spellings against 1 AU (`color`, `gray`, `jewelry`, `behavior`, `center`). It is kept as shipped so this file diffs mechanically against upstream drop 4, and because an AU sweep folded into the flip would bury the flip's own diff. The sweep is deferred to a follow-up plan and recorded in the project `HISTORY.md`. Studio-authored prose in this file is Australian English; the retention covers upstream text only.
>
> **Cross-refs:** element tags and reference-library indexing live with `cinema-world-bible`; cinematic scene and environment plates route to `banana-pro-director`; Seedance video prompts route to `cinema-director`.
<!-- STUDIO-LOCAL END -->

The locked grammar for building real people and their wardrobes as reusable image assets. A character is not one picture. It is a canonical face lock, a set of identity markers, and a growing library of outfits, all anchored so every downstream image and video prompt renders the same person.

**Photoreal humans only.** This skill never produces illustration, anime, cel-shaded, painterly, comic, or rendered output. Every prompt describes a real person in a real frame.

## The five modes

| Mode | Use when |
|---|---|
| **0 — FACE LOCK** | No canonical reference exists. The character is being invented. |
| **1 — ADDITIONS** | The character is locked. Something is being changed or added permanently. |
| **2 — OUTFIT BUILDER** | The character is locked. References or a described fit are being put on them — directly, in one build. |
| **3 — OUTFIT REPLACEMENT** | An outfit exists on a model who isn't the character. Swap the identity in. |
| **4 — CHARACTER SHEET** | An approved outfit render exists. Turn it into a multi-angle reference. |

Never skip forward. An outfit cannot be built on a character whose face isn't locked. A sheet cannot be built before an approved outfit render exists. An addition cannot be made to a character who doesn't exist yet.

---

## CORE PHILOSOPHY

No plastic. No CGI sheen. No 3D-render look. No commercial gloss. No AI-generic skin or hair. Every image reads as a photograph of a real subject — real pore texture, peach fuzz, hair with flyaways and individual strands, fabric with weight and weave, jewelry with surface detail, eyes with reflection and depth.

### The two axes — separate these, always

Photoreal character work runs two things that sound like one thing and are not.

**Axis 1 — BIOLOGICAL REALISM: fully on.** The subject must read as a real living person. Real pore texture, real peach fuzz at the jaw and hairline, real subsurface scattering, hair rendered strand by strand with flyaways and baby hairs, real fabric weave and weight and drape, real metal surface on jewelry, real eyes with depth and moisture. This never comes off.

**Axis 2 — PHOTOGRAPHIC CAPTURE BEHAVIOR: off on every character plate.** A character plate is not a photograph of a lit set. It carries no key direction, no shadow side, no cast shadow, no contact shadow, no falloff on the background, no light spill, no bokeh, no depth-of-field falloff, no vignette, no flare, no atmospheric haze.

The two get tangled constantly because "photorealistic" sounds like it means both. It doesn't. Writing *"photographed on a real camera by a real photographer on a real set"* into a character plate switches on Axis 2 along with Axis 1 — and Axis 2 is exactly what poisons a reference. The subject should look like a real person, rendered flat, against nothing.

**Why Axis 2 is off.** These are references, not finished frames. Any lighting information baked into a plate — a cheek triangle, a nose shadow, a contact shadow under the feet, a soft falloff behind the shoulder, a warm bleed on the backdrop — is inherited and amplified by every downstream generation that reads it, and it fights whatever lighting the actual scene wants. The plate carries zero lighting. The scene prompt or the video prompt does all the lighting later.

**The one surviving capture phrase.** `Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated.` — this closes every plate. "Photographed not generated" is a strong negative signal against AI uniformity at the language level and costs nothing in Axis 2 terms, because the 50mm prime is named in plain words with no aperture, no bokeh, and no falloff attached.

### The flattering-realism ceiling — LOCKED, every face, every mode

Full skin realism is always on: visible pore texture, peach fuzz, subsurface scattering, hair flyaways, the matte finish that carries the anti-plastic look. But realism never means unflattering. No acne, no blemishes, no prominent spots, no scarring the user didn't ask for, no enlarged or cratered pores, no rough bumpy texture, no aggressive detail that reads clinical. The texture is fine, soft, even, and natural. Matte is the anti-plastic lever; fine-and-even is the flattering lever. Both run together. Where they conflict, resolve toward flattering — a face should always look good.

**Doll-coded characters** (only when explicitly requested): smooth matte register without visible pores or peach fuzz, but still real and natural — never plastic, never waxen, never AI-render.

---

## THE FLAT GRAY PLATE (LOCKED DEFAULT FOR ALL CHARACTER WORK)

**18% neutral gray with a completely flat shadowless grade is the locked default** for face locks, character references, outfit plates, garment plates, character sheets, and prop references. Pure white is the explicit-request exception, used only for a finished standalone still meant to be posted or handed off — and **the flatness survives the backdrop swap**. Flatness is not a property of the gray. It is the locked look for all character work.

**Why gray.** Pure white and pure black create maximum subject-to-background contrast. Image and video models amplify errors most at high-contrast edges — that's where halo, edge breathing, and contour instability get baked in. A neutral mid-gray ground lowers subject-to-background contrast, giving cleaner edge extraction and far less inherited contrast when the still is read as a reference frame downstream. Because virtually every character plate eventually seeds video work, gray is the correct standing default.

**The background stays neutral; the subject does not.** The ground is an even neutral mid-gray, never warm-shifted. But the gray must never cool or neutralize the subject — skin renders at its true natural tone and wardrobe at its true natural color, exactly as under neutral daylight. The relight-from-scratch language and the explicit "warmth preserved and natural, never pale or washed-out or cool-shifted" clause hold this.

**The background is a field, not a room.** This is the distinction that matters most and the one most often lost. A photographed seamless is a *physical surface* — it takes light, it falls off, it catches spill, it holds the subject's shadow, it has a floor the subject stands on. A character plate background is none of that. It is a flat uniform color field with nothing behind the subject at all: no surface, no floor, no wall, no corner, no seam, no horizon, no plane the subject makes contact with. The subject does not stand on anything and does not stand in front of anything. Nothing the subject does affects the field.

### LOCKED FLAT CLOSE — use verbatim on every plate

```
The background is a single flat 18% neutral gray field — one uniform value at every pixel corner to corner, identical directly beside the subject and in the far corners, with no seam line, no gradient, no hotspot, no vignette, and no falloff to lighter or darker anywhere in the frame. It is a flat color field, not a photographed backdrop — no surface, no floor, no wall, no corner, no horizon, and no plane the figure stands on or in front of.

Relight from scratch overriding any reference lighting: completely flat shadowless illumination — one enormous soft frontal source at camera position wrapping the subject evenly, matched equal fill from camera-left and camera-right at identical intensity, matched fill from above and below, so both sides of the face read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no cheek triangle, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Extremely low contrast, even, milky, catalogue-flat. Form is described by bone structure, hair strands, and fabric folds alone, not by light and shadow.

Absolutely zero shadow anywhere outside the subject. No cast shadow, no contact shadow, no floor shadow, no drop shadow, no ambient occlusion where the body meets the background, no soft darkening behind the shoulders or beneath the hem, no halo, no edge darkening, and no rim separating the figure from the field. Shading exists only on the subject and stops cleanly at the silhouette. Absolutely zero light bleed outside the subject — no spill, no glow, no bounce, no reflected color cast thrown from the skin or the wardrobe onto the background, and no brightening anywhere behind the figure.

Skin reads matte and velvety — zero shine on forehead, nose bridge, cheekbones, temples, and chin, no oily T-zone. Skin renders at its true natural skin tone and wardrobe at its true natural color, warmth preserved and natural against the neutral gray, never pale or washed-out or cool-shifted by the background. Real peach fuzz at the jaw and hairline, real soft fine even pore texture, subsurface scattering reading as semi-translucent biology, real hair rendered strand by strand with fine flyaways at the hairline, real fabric weave and drape, real metal surface detail on any jewelry, never plastic, never waxy, never glass-skin, never harsh — fine flattering texture that keeps the face looking good, no acne, no blemishes, no rough pores.

Even sharpness edge to edge across the entire frame. No depth-of-field falloff, no bokeh, no background blur, no lens vignette, no lens distortion, no flare, no bloom, no chromatic aberration, no atmospheric haze, no air between the subject and the background. Photographed on a 50mm prime, soft natural film grain. Photographed not generated.
```

### The five things that must appear in every flat close, always

1. **Flat field** — one uniform value at every pixel, explicitly a color field rather than a photographed surface
2. **Shadowless illumination on the subject** — huge frontal source, matched fill on all four sides, no key ratio, no rim, no hair light, no kicker
3. **Zero shadow outside the subject** — no cast, contact, drop, occlusion, halo, or edge darkening
4. **Zero light bleed outside the subject** — no spill, glow, bounce, or reflected color onto the field
5. **Biological realism with the flattering ceiling** — pores, peach fuzz, subsurface scattering, strand hair, fabric weave, and the no-blemish clause

Miss any one and the plate comes back with lighting information baked into it.

**On sheets:** flatness must be stated as applying *uniformly across all panels* — same gray value, same shadowless light, no cast shadow in any panel.

**The white exception:** swap only the first sentence for *"The background is a single flat pure white field — one uniform value at every pixel corner to corner, no seam line, no gradient, no hotspot, no vignette."* Every other clause stays exactly as written.

---

## PROMPT ECONOMY — WHY LEAN PROMPTS HOLD FACES BETTER

This is the single biggest lever on identity consistency, and it runs counter to instinct. When strong references are attached, **the references carry the identity load. The prompt's job is to tell the model what to DO with that identity in this specific image.** Heavy visual description layered on top of a strong reference creates a double-weight prompt that dilutes the direction the model actually needs from the text.

**1. Identify subjects by short distinguishing visual handles.** "The woman with the deep red-burgundy hair" — not a paragraph re-describing bone structure, lash length, lip shape, and brow arch that the attached plate already shows. One handle per subject is enough.

**2. Put the load on what the prompt uniquely communicates.** Composition and framing. Pose, expression, what the hands are doing. The wardrobe that isn't in an existing reference. The flat close.

**3. Drop redundant identity description entirely unless the reference is ambiguous.** If the canonical plate is attached, the prompt does not need to restate face structure, skin tone, or eye shape. Mention them only when something specific to this image requires it.

**4. Lean shorter when in doubt.** A tight prompt with strong references beats a sprawling one every time. The model reads the front of the prompt most heavily, so loading the front with composition, pose, and layering gets better results than burying those decisions under visual description.

**The rule of thumb:** if a sentence re-describes something already visible in an attached reference, cut it unless it's load-bearing for the composition.

**The one exception is Mode 0.** The face lock has no reference to lean on — it *is* the reference. It gets the longest, most specific description in the entire skill. Everything after it gets progressively leaner.

**Reference economy.** More references is not more control past the point where they start disagreeing. Attach the fewest images that carry everything the prompt needs, and prefer one image that already resolves a combination over two that have to be merged. When two or more references are attached, **say what each one carries** in the prompt body so the model doesn't average them: *"the face, bone structure, and skin tone come from the character reference; the wardrobe and accessories come from the look reference."*

---

## READING REFERENCE IMAGES

When the user uploads references, extract everything visible by **visual description only** — never use names, never invent what isn't there.

- **Hair** — color with every nuance (platinum, jet black with cool undertone, rose-pink, burgundy, ash brown), length, style, texture, part, styling treatment (slicked, blown out, flat-ironed, braided, ponytail, bangs and which kind), accessories
- **Makeup** — skin finish, coverage register, brow shape and density, eye treatment, lashes, lip, cheek, face jewelry, freckles or beauty marks *only if visible*
- **Wardrobe** — every garment top to bottom: fabric, color, fit, structural detail, neckline, sleeve, hem, closures, layering, branding described generically
- **Jewelry and accessories** — every piece, metal, scale
- **Body markers** — piercings and tattoos *only if visible*, nail length and finish
- **Pose and energy** — body angle, weight, hands, expression register

**No-invention rule.** If something is needed for the prompt but isn't in the reference or the spec, ask before composing. Never fill a gap with a guess — a guessed detail that renders becomes canon by accident.

**Material override rule.** When a reference carries the right *construction* but the wrong *material* — a garment shown in silver that needs to render in black leather — say so explicitly in the prompt body: *"the glove reference resolves cut and coverage only; its silver material is not used."* Without that line the model splits the difference.

---

## THE PRE-PROMPT CHECK

Every prompt gets a short "here's what I'm about to prompt, sound good?" before the full prompt is written. Long prompts are expensive in attention and copy-paste effort, and the user shouldn't wait on a wall of text only to find it missed.

**Format: clean bullets only.** No quote blocks, no prose wrapper. **References listed first, always** — this confirms every uploaded reference is being read and accounted for. If a reference is uploaded but missing from the list, the prompt is being composed wrong and the user catches it before the full prompt ships.

```
Pre-prompt check:
- References attached: [every uploaded reference by short visual descriptor — or "none, text-only build"]
- Character: [hair, skin, identity markers, expression]
- Outfit / styling: [wardrobe head to toe, jewelry, body markers]
- Backdrop: flat 18% neutral gray field (locked default)
- Framing: [only if non-default]

Sound good?
```

<!-- STUDIO-LOCAL BEGIN: the wait is stated outright — upstream's template implies it with "Sound good?" but never says it, and this studio hard-gates a first delivery on the user's green light. -->
**Wait for the green light before delivering the code block.**
<!-- STUDIO-LOCAL END -->

**Exception — minor iteration.** When the user requests a small adjustment to a prompt already approved and delivered in this thread (framing shift, pose change, single wardrobe swap, styling nudge, palette tweak), skip the check and deliver the revised full prompt directly in a code block. The character is locked, the wardrobe is locked — only the variable being tweaked is changing. Re-confirming on tiny deltas creates friction. **Default to delivering.**

**What still triggers a check mid-thread:** a new character entering the frame, a full outfit swap, a new mode, or the user asking for one.

**Wardrobe proposals are the other exception, in the opposite direction.** A new outfit always gets its text proposal approved before any image prompt is written, and the two never ship in the same message.

---

# MODE 0 — FACE LOCK

For any character with no existing canonical reference. Two stages, in order: text spec, then build.

## Stage 1 — The text spec

Let the user describe the character in their own words. Listen, then mirror back a locked spec in plain language covering:

- **Apparent register** — described by build and bearing, never an age word or number
- **Face** — head shape, bone structure, jaw, chin, cheekbones, brow shape, eye shape and color, nose, lip shape
- **Skin** — tone and finish
- **Hair** — color with every nuance, length, texture, part, styling
- **Body** — build, proportions, posture
- **Default makeup register** — if any
- **Default expression and energy**
- **Identity markers** — piercings with position and metal, scars with placement and size, beauty marks, tattoos, signature jewelry

Iterate the text spec freely until the user says it's locked. Nothing gets generated until they do. Fixing a face in text costs nothing; fixing it after twelve outfits have been built on it costs everything.

## Stage 2 — The tool fork

Ask once, before writing anything:

> Want the lock on Banana Pro, GPT Image 2, or a Soul Cinema pass first?
> — **Banana Pro (default):** balanced fidelity, reasonable credits, handles any framing. The standard lock tool.
> — **GPT Image 2 (maximum fidelity):** sharpest read on pores, lash separation, and iris pattern. Chest-up only, and it costs more credits.
> — **Soul Cinema first:** cheap exploratory pass that throws face variations so you can see several before committing, then Banana Pro locks the winner.

Mention the GPT Image 2 credit cost **once per conversation**, then drop it.

| Tool | Role |
|---|---|
| **Soul Cinema** | Optional face test. Cheap and fast, low fidelity. Explore, don't lock. |
| **Banana Pro** | Canonical lock — default. |
| **Higgsfield GPT Image 2** | Canonical lock — maximum fidelity, chest-up only, higher credits. |

**GPT Image 2 substitutes for Banana Pro at the lock step**, never for the Soul pass. Anything wider than chest-up loses the fidelity advantage and wastes the credit hit. Everything else is identical — same framing, same 17-item order, same flat close. The tool changes; the grammar does not.

**Soul Cinema exists in this skill for exactly one thing: exploring a brand-new face that has never been generated before.** It does not appear anywhere else. Never offer it for outfits, additions, sheets, swaps, or any work on a character who is already locked — bringing it up there sends the user through a detour they didn't ask for. Outside Mode 0, the tool is Banana Pro unless the user names something else.

<!-- STUDIO-LOCAL BEGIN: narrow, repair-time exception to the Mode-0-only rule above — the garment-plate ladder in Mode 2 Path B opens on Soul Cinema, and that plate carries no face and no locked character, so it is not the exploratory detour the rule exists to prevent. Every proactive offer still obeys the rule as written. -->
**One exception, repair time only.** The invisible-mannequin repair ladder in Mode 2 Path B may open on Soul Cinema for a garment plate — no face, no locked character, and only after a direct build has already failed on that piece. Soul Cinema is offered nowhere else outside Mode 0.
<!-- STUDIO-LOCAL END -->

**Wardrobe lock for every face plate, every tool:** plain black thin-strap camisole for women, plain black ribbed tank for men. No jewelry, no logos, no graphics. Identity-pure, and it gives every downstream outfit build a clean neutral starting reference.

---

## Step 0.1 — Soul Cinema face test (optional)

Lean, essentials only. No fine markers, no makeup detail, no granular anatomy — Soul can't hold those and asking wastes the pass. Let it interpret the face from essentials so the variations are actually different from each other.

```
A [heritage] [woman / man] with a [build], [skin tone and finish], [hair color, length, texture]. [Eye shape and color]. [Only large, visually dominant markers — hold fine markers for the lock pass]. [She wears a plain black thin-strap camisole / He wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes to camera, lips closed and relaxed. Chest-up framing.

[LOCKED FLAT CLOSE — verbatim]
```

The user runs several, picks one, and that becomes the reference for the lock.

---

## Step 0.2 — The canonical 3:4 chest-up lock

**This is the most important image in the character's life.** Everything downstream anchors here. Write it long and write it specific — this is the one place prompt economy does not apply.

**Framing:** 3:4 vertical, forehead to upper chest, the face filling most of the frame. A true close-up headshot, not a portrait with air around it. Chest-up, never waist-up — the whole point is resolution on the face.

**Everything gets written out in full, in this order:**

1. **Framing declaration** — 3:4 chest-up, forehead to upper chest, face filling the frame
2. **Reference anchor** — "the same character as the attached face plate" (omit if building single-pass with no Soul test)
3. **Build and heritage** — one clause
4. **Skin** — tone, undertone, finish
5. **Head and face structure** — head shape, forehead, temples, cheekbone height and projection, cheek hollow, jaw angle and definition, chin shape and projection, the line from ear to chin
6. **Eyes** — shape, set, spacing, tilt at the outer corner, lid crease depth and visibility, iris color with its variation across the iris, limbal ring, pupil, the wet line at the inner corner, under-eye structure
7. **Brows** — shape, arch position, thickness, density, hair direction, color relative to the hair
8. **Lashes** — length, density, curl, separation, upper and lower
9. **Nose** — bridge width and straightness, tip shape and projection, nostril shape and visibility, the plane transitions
10. **Lips** — fullness upper versus lower, cupid's bow definition, philtrum length and depth, mouth width, corner shape, natural lip color and surface texture
11. **Ears** — shape and set, whether visible under the hair
12. **Hair** — color with every nuance and tonal variation root to tip, length, texture, part, how it falls, hairline shape, baby hairs
13. **Makeup register** — if any, as a default that swaps freely later
14. **Identity markers** — each with exact placement: piercings by position and metal, beauty marks by location, scars by placement and size, visible tattoos
15. **Wardrobe** — plain black camisole or ribbed tank, no jewelry, no logos
16. **Pose and expression** — squared to camera, head level, neutral relaxed, eyes to camera, lips closed
17. **The LOCKED FLAT CLOSE** — verbatim

```
A clean cinema-character-reference 3:4 headshot of the same character as the attached face plate, framed from the forehead down to the upper chest with the face filling most of the frame — a true close-up, not a portrait with space around it.

[Build and heritage.] [Skin tone, undertone, and finish.] [Head and face structure — head shape, forehead, temples, cheekbone height and projection, cheek hollow, jaw angle, chin shape, the line from ear to chin.] [Eyes — shape, set, spacing, outer-corner tilt, lid crease, iris color and its variation across the iris, limbal ring, under-eye structure.] [Brows — shape, arch position, thickness, density, direction, color.] [Lashes — length, density, curl, separation, upper and lower.] [Nose — bridge, tip, nostrils.] [Lips — upper versus lower fullness, cupid's bow, philtrum, mouth width, corner shape, natural color and surface texture.] [Ears — shape, set, visibility under the hair.] [Hair — color with every nuance and tonal variation root to tip, length, texture, part, fall, hairline shape, baby hairs.] [Default makeup register, if any.] [Every identity marker with exact placement — piercings by position and metal, beauty marks by location, scars by placement and size, visible tattoos.]

[She wears a plain black thin-strap camisole / He wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes directly to camera, lips closed and relaxed, subtle controlled energy.

[LOCKED FLAT CLOSE — verbatim]
```

The output is the canonical character reference. Every future prompt for this character attaches it.

**GPT Image 2 addition.** When the lock runs on GPT Image 2, insert one dedicated fidelity paragraph between the pose line and the flat close. GPT Image 2 rewards explicit micro-detail language in a way Banana Pro does not:

```
Extreme face fidelity. Real skin texture with visible individual pores, fine peach fuzz along the jawline and upper lip, subtle subsurface scattering across the nose bridge, cheeks, and ear edges reading as semi-translucent biology. Individual lash separation, upper and lower. Real moisture and reflection in the iris with a visible fibrous iris pattern radiating from the pupil and a soft limbal ring at the outer edge. Real lip surface texture with fine natural vertical lip lines. Hair rendered strand by strand at the hairline with visible baby hairs and individual flyaways. Visible fabric weave at the collar and shoulder. Micro-expression detail held in the eye corners and the mouth corners.
```

**Mode 0 is one-and-done per character.** Once the locked 3:4 headshot exists, every future prompt anchors to it.

---

# MODE 1 — ADDITIONS

For a character who already has a canonical reference. Something is being changed or added **permanently** — this is not an outfit, and it is not a one-off scene styling.

| Addition | Notes |
|---|---|
| **Hair color change** | The most common. Full re-lock required. |
| **Hair length or cut change** | Full re-lock required. |
| **New permanent piercing** | Position and metal specified exactly. |
| **New tattoo** | Placement, size, orientation, line weight, and content in full. |
| **Scar** | Placement, size, age of the scar, raised or flat, color relative to surrounding skin. |
| **Default makeup register change** | Re-lock only if it changes how the face reads at rest. |
| **Expression set** | Adding a second canonical expression to the library. |
| **Body change** | Full re-lock required. |
| **Aging up or down** | Full rebuild — go back to Mode 0. |

## The identity firewall

Every addition prompt must state what is changing **and** state that everything else is held. Without the hold clause, changing hair color drifts the jaw, the eye shape, and the skin tone along with it.

**The hold clause — use verbatim, adjusted for what's changing:**

```
Everything about the character other than [the specific change] is identical to the attached reference and unchanged — the same head shape, the same bone structure, the same jaw and chin, the same cheekbones, the same eye shape and spacing and tilt, the same iris color, the same brow shape, the same nose, the same lips and mouth width, the same ears, the same skin tone and finish, the same build and proportions, and every existing identity marker in the same position. Only [the specific change] is different.
```

## The re-lock rule

**Any addition that changes how the face reads at rest requires a new canonical plate.** Hair color, hair cut, facial piercings, facial scars, and permanent makeup all cross this line. Generate the addition as a fresh 3:4 chest-up lock in the same framing, same wardrobe, and same flat plate as the original — and the new plate becomes canonical from that point forward.

Additions that don't touch the face at rest — a body tattoo under clothing, a hand tattoo, an ear piercing hidden by hair — get documented in the written spec and written into outfit prompts as needed, with no new face plate.

**Version the plates.** When a character gets a re-lock, both plates continue to exist and refer to different states. Name them so the distinction survives — `[character]-lock-01`, `[character]-lock-02-red-hair`. Always confirm which lock is being anchored to before building an outfit on it.

## Prompt structure — additions

```
A clean cinema-character-reference 3:4 headshot of the same character as the attached reference, framed from the forehead down to the upper chest with the face filling most of the frame.

[The change, described in full detail. If it is hair: the new color with every nuance and any tonal variation root to tip, the new length, the new texture, the new part, how it falls, the hairline, baby hairs. If it is a marking: exact placement described relative to a fixed anatomical landmark, exact size, exact orientation, exact color and finish, whether raised or flat, line weight if it is a tattoo.]

[The hold clause — verbatim.]

[Wardrobe — the same plain black camisole or ribbed tank as the original lock], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes directly to camera, lips closed and relaxed.

[LOCKED FLAT CLOSE — verbatim]
```

## Expression sets

A character can carry more than one canonical expression. Build them as a 3-panel sheet in one image so identity holds across all three: neutral at rest, the character's signature expression, and one extreme. Same framing, same lighting, same wardrobe in every panel — only the face changes.

State per panel exactly which muscles move: brow position, lid aperture, mouth corner direction, jaw, whether teeth show, where the eyes look. Never name the emotion alone. *"Brows drawn slightly together and down at the inner ends, upper lids lowered a fraction, mouth corners level and pressed, jaw set"* renders. *"Angry"* does not.

---

# MODE 2 — OUTFIT BUILDER

For a character with a locked face. Two steps: agree the outfit in text, then build it directly on the character.

## The default is direct — never gate it

**When the user uploads garment references and says put this on the character, that is the whole instruction. Build it directly, in one generation, on the locked character.** Do not route them through a neutral model first. Do not build the outfit on someone else and composite it. Do not propose a test pass. Uploaded references — product shots, runway stills, flat-lays, screenshots, material swatches — are already the outfit reference, and duplicating them onto a stand-in model costs a generation and a reconciliation step while adding nothing.

The direct build is the default for outfits described in text too. The intermediate paths exist for the narrow cases below, and the user has to be better off for taking them.

## Step 1 — The wardrobe proposal (text only)

Before any image, write the outfit out in plain text and wait for approval. Never combine a wardrobe proposal with an image prompt in the same message. This is a text step, not a generation step — it costs nothing and catches the misreads that would otherwise burn credits.

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

**End the proposal with any open decisions the references don't resolve** — which hand a single glove goes on, whether a back is fully open or strapped, exact counts of repeated elements. Ask them as a short numbered list rather than guessing.

## Step 2 — Build it

**Path A — direct on the character — is the default and covers nearly everything.** Uploaded references, a text-described outfit, a mix of both, simple or complex: it all goes straight onto the locked character in one generation.

| Path | Use when |
|---|---|
| **A — Direct on the character** (default) | Everything. Uploaded garment references, described outfits, layered looks, custom construction. This is the answer unless Path A has already failed. |
| **B — Invisible mannequin garment plate** | Only after a direct build came back with a specific piece rounded off toward generic — and then only for that one piece. |

**Path B is a repair, not a starting point.** Never open with it, never propose it preemptively because an outfit looks complicated, and never build plates for pieces that already have a usable reference. Run Path A, look at what came back, and reach for a mannequin plate only for the garment that actually failed.

---

### Path A — DIRECT ON THE CHARACTER (default)

Build the outfit straight onto the locked character in one generation, **full body, tall vertical framing**. The character reference is attached alongside every garment reference; the prompt handles layering, fit, pose, and anything the references don't resolve.

One generation instead of several, the fit reads on the character's actual proportions from the start, and there's no compositing step to degrade identity.

**With uploaded garment references, describe less.** Each attached reference already carries its garment's cut, construction, and hardware. The prompt's job is what the references can't say on their own: **layering order** (what sits over what), **how each piece sits on this body** (where a hem lands, how much skin shows between two pieces), **material overrides** where a reference shows the right construction in the wrong material, **which side or hand** an asymmetric piece goes on, and **anything cropped out of the reference frame** — a back a front-facing product shot never shows, a boot top a thigh crop cuts off.

State what each reference carries when several are attached, and say plainly when one is being used for construction only:

```
The character reference carries face, skin, hair, and build. Each garment reference carries that garment's cut and construction. The material reference carries the finish applied across every piece. The glove reference resolves cut and coverage only — its silver material is not used.
```

**Why tall vertical.** A full-body outfit reference needs the frame taller than wide. Vertical gives the garment the pixel budget — hem lengths, break at the ankle, footwear, and drape all read at usable resolution instead of getting squeezed into the middle of a square. Describe it as "a tall vertical frame with the full figure and the footwear entirely within the frame" — never as a numerical ratio.

**Default pose:** the cocked-hip model stance — weight on one hip, body angled 15 to 30 degrees from camera, chin level, eyes to camera.

```
A full-body character reference of the same [woman / man] as the attached character reference, standing [pose], framed head to toe in a tall vertical frame with the full figure and the footwear entirely within the frame.

[What each attached reference carries, when more than one.]

[Identity restated briefly — build, skin, hair, face register. Two or three clauses only; the reference carries the rest.]

[The outfit head to toe — every garment with color, fabric, weave or finish, cut, fit, neckline, sleeve, hem position, closures, structural detail, how it sits and moves on the body, layering, footwear, jewelry, accessories, nails. Lean on the references for construction and spend the words on layering, fit on this body, material overrides, and anything cropped out of a reference frame.]

[Pose and expression.]

[LOCKED FLAT CLOSE — verbatim, adjusted to full-body framing.]
```

---

### Path B — INVISIBLE MANNEQUIN GARMENT PLATE (repair only)

**Only reached after a direct build returned a specific garment rounded off toward generic, and only for that garment.** Every other piece stays as it came back. If the outfit had no uploaded reference for the failed piece, this builds one; if it had a reference the model ignored, this converts it into a plate the model reads more reliably.

**Step 2B.1 — Build the failed piece on an invisible mannequin.** Because there's no face and no body competing for attention, the entire prompt can be about the garment. That's what makes it hold custom construction a direct build lost.

```
A garment reference of a single [garment type] worn on an invisible body, floating in frame and holding its full three-dimensional worn shape.

[The garment in complete detail — color, fabric, weave or finish, cut, fit, collar or neckline construction, sleeve, hem, closures, seams, panels, hardware, pockets, print or pattern with its scale and layout, lining if visible.]

There is no head, no neck, no hands, and no body anywhere in the frame — the garment reads as worn by an invisible figure with full volume, natural drape, and real fabric tension across the chest and shoulders, the collar and cuffs holding their own three-dimensional shape, every opening reading as an empty dark hollow looking down into the inside of the garment with the inner back of the fabric faintly visible. No stump, no skin, no cut edge, no anatomy, no mannequin form, no hanger, no stand, not blurred, not faded, no ghosting, no transparency.

[LOCKED FLAT CLOSE — verbatim]
```

<!-- STUDIO-LOCAL BEGIN: garment-plate escalation ladder — re-scoped from a drop-2 build path into a repair-time tool so it sits under Path B's repair-only doctrine; its Soul Cinema step is the marked narrow exception to the Mode-0-only Soul rule in MODE 0, because a garment plate carries no face and no locked character. -->
**Escalation ladder if the plate still will not hold — repair time only.** The ladder opens only once a direct build has failed on this specific garment, and it never runs as a proactive path. Soul Cinema first (cheapest, fastest test) → Banana Pro if Soul Cinema cannot hold the shape → GPT Image 2 if Banana Pro still cannot resolve fine construction detail (boning, structured seams, complex draping) — the same headless framing discipline as the plate above at every step. Once the plate holds visually, go to Step 2B.2 as normal.
<!-- STUDIO-LOCAL END -->

**Step 2B.2 — Rebuild the look with the plate in the stack.** Attach the character reference, the new garment plate, and the references for the pieces that already worked.

```
A full-body character reference of the same [woman / man] as the character reference, wearing the garments from the attached references, framed head to toe in a tall vertical frame.

Keep every garment exactly as shown in its reference — the same color, the same fabric, the same cut and fit, the same collar and cuffs, the same hem position, the same closures, the same hardware, and the same print or pattern at the same scale. Keep the character's identity exactly as shown — the same face, the same bone structure, the same eye shape and color, the same skin tone, the same hair, and every identity marker in the same position.

[Layering — what goes over what, what is open or closed, what is tucked.] [Footwear, jewelry, and accessories not covered by a reference.] [Pose and expression.]

[LOCKED FLAT CLOSE — verbatim, adjusted to full-body framing.]
```

---

# MODE 3 — OUTFIT REPLACEMENT

A two-reference swap that puts a locked character into the outfit and pose from a different image. Triggers on: "outfit replacement," "outfit swap," "put this character in this fit," "swap the face," or any equivalent.

**Goal:** maximum identity transfer of the character onto the outfit and pose, with zero alteration to either side. The outfit stays exactly as shown, the identity stays exactly as shown, only the body underneath the outfit changes to match the character.

**Reference order is fixed.** Reference 1 is the outfit and pose source. Reference 2 is the character and identity source. Confirm both roles at the pre-prompt check before writing.

```
Replace the person in the first reference with the character from the second reference. Keep the outfit and pose from the first reference exactly — the same garments, colors, fabrics, cut, fit, hem positions, footwear, jewelry, accessories, and the same body position and hand placement. Match the face, bone structure, body type, skin tone, hair, and every identity marker from the second reference exactly. Full body framing.

[LOCKED FLAT CLOSE — verbatim, adjusted to full-body framing.]
```

**Keep it lean.** The two references carry the photographic register on their own. Layering description on top of a swap creates conflicting instructions and degrades the identity transfer. Trust the references.

---

# MODE 4 — CHARACTER SHEETS

Built only after an outfit plate exists on the locked character and the user is happy with it. One image, one prompt.

**The 3-panel is the default.** When the user asks for "a character sheet" with no format named, build the 3-panel. Don't ask which, don't offer the 6-panel.

**Why 3 beats 6:** the sheet is one image with a fixed pixel budget. Six cells splits that budget six ways, and the face — the one thing the sheet exists to lock — lands in cells too small to hold real identity detail. Three cells give each panel roughly double the resolution, which is what makes the chest-up face panel usable as a downstream anchor.

**6-panel is legacy, explicit request only.** If the user names it, say this once, then proceed on their go-ahead and never re-litigate:

> Heads up — splitting into six panels cuts the pixel budget per cell, so the face panels hold noticeably less identity detail than the 3-panel's chest-up lock. Happy to run it if you want it.

## Which references to attach

**Default: the approved full-look outfit render alone.** It already carries the face, hair, skin, build, wardrobe, and every accessory in one image, all agreeing with each other. It is a strictly better reference for a sheet than the outfit render plus the face lock, because it needs no reconciliation.

**Adding the canonical face lock alongside it is usually a downgrade.** Two references means two sources for the same face, and the model has to reconcile them — different framing, different crop, different neutral wardrobe, different hair state. That reconciliation costs attention that should go to panel geometry and the garment, and on a multi-panel sheet the attention budget is already split. Overloading references is one of the most reliable ways to get a mushy sheet.

**Attach the face lock as a second reference only when:** identity has visibly drifted in the outfit render, the outfit render obscures the face, the face came out soft or low-detail, a previous sheet attempt returned a wrong face, or the user explicitly wants it re-anchored. When it is attached, say what each reference carries.

## 3-panel layout

1. **LEFT — full body front, headless.** Full headroom preserved — the head is *removed from the body*, not cropped by the frame edge. Isolates the garment, silhouette, and proportions with no facial data competing.
2. **CENTER — full body rear, head attached.** Hair fall, back construction, hem, and footwear readable from behind.
3. **RIGHT — tight chest-up face lock.** Just above the crown down to the collarbones. The face fills the panel. This is the identity anchor and it must be tight — chest-up, never waist-up. If the framing drifts wider the sheet loses its whole reason for existing.

<!-- STUDIO-LOCAL BEGIN: routing pointer to the studio's headless sheet — upstream ships only the head-attached CENTER layout and has no Seedance variant to point at. -->
> The head-attached CENTER panel above is the general-purpose default. For a Seedance Subject Lock anchor — where every panel should carry no more than one face — see *The headless 3-panel sheet — Seedance handoff* at the end of this mode.
<!-- STUDIO-LOCAL END -->

## The headless cut — pick by garment

**Variant A — ghost mannequin.** For structured or closed necklines sitting at or above the collarbone: collars, crew necks, ribbed tanks, turtlenecks, hoods, jacket collars, keyholes. Anything with a real opening the eye expects a neck to come out of.

```
LEFT PANEL — full body front view, no head, no neck, and no hair. The body stands squared to camera from the shoulders down to [the shoes / the hem], arms relaxed at the sides, hands open and loose, weight even across both feet. There is no head, no neck, and no hair at all — nothing rises above the shoulder line, and no hair falls across the chest or shoulders. The [collar type] holds its own three-dimensional shape at the top of the garment and its opening is an empty dark hollow looking down into the inside of the garment, with the inner back of the fabric faintly visible inside the opening. The garment reads as worn by an invisible body — full volume, natural drape, real fabric tension across the chest and shoulders, but nothing emerging from the neckline. No stump, no skin, no cut edge, no anatomy, no blood, not blurred, not faded, no ghosting, no transparency in the body. The panel keeps full headroom — generous empty field above the shoulders — so the figure sits at the same scale and position in the frame as a normal full-body portrait.
```

**Variant B — clean neck cut.** For garments with no neckline to hollow: strapless, halter, spaghetti strap, deep cowl, scooped or plunging.

```
LEFT PANEL — full body front view, headless. The full figure stands squared to camera from the shoulders down to [the shoes / the hem], arms relaxed at the sides, hands open and loose, weight even across both feet. There is no head and no hair — no hair falls across the chest or shoulders. The neck rises a short way from the shoulders and terminates in a clean, flat, sharply defined horizontal edge at the base of the throat, exactly like a headless dress-form mannequin — a crisp sculptural cut with a clean visible edge, not blurred, not faded, not dissolving, no wisps, no smoke, no ghosting, no transparency, no blood, no anatomy detail at the cut. Above that clean edge there is only empty field. The panel keeps full headroom so the figure sits at the same scale and position in the frame as a normal full-body portrait.
```

## 3-panel prompt structure

```
A three-panel character reference sheet composed as one horizontal frame, divided into three equal vertical panels side by side, thin clean separation between panels, the same figure and the same outfit rendered identically across all three. No text, no labels, no numbering anywhere in the image.

[If more than one reference is attached: what each reference carries.]

[Identity paragraph — build, skin, hair color and styling, makeup register, identity markers, nails. Described ONCE, applies to all three panels.]

[Wardrobe paragraph — full outfit head to toe, every garment, fabric, color, construction detail, footwear, jewelry. Described ONCE, applies to all three panels.]

[LEFT PANEL — Variant A or B locked language, per the garment.]

CENTER PANEL — full body rear, head attached. The complete figure from above the crown down to [the shoes / the hem], seen directly from behind, standing squared away from camera, weight even, arms relaxed at the sides. [Hair fall, back construction, hem, and footwear as they read from behind.]

RIGHT PANEL — tight chest-up face lock. Framed from just above the crown down to the collarbones with the face filling the panel, squared to camera, head level, eyes directly to camera, neutral model face-card expression, lips closed and relaxed. [What enters at the bottom of frame.] Every facial plane, the full eye construction, brow, nose, lip shape, and hairline read at maximum detail.

Skin renders at its true natural skin tone, identical in value and hue across the face, arms, hands, back, and body in every panel, never darkened, never tanned, never pale or washed-out or cool-shifted.

[LOCKED FLAT CLOSE — verbatim, with the flatness stated as applying uniformly across all three panels.]
```

## 6-panel layout (legacy)

3×2 grid, single frame. Default panels: full body front; left side profile close headshot; full body back; right side profile close headshot; front face close headshot; one detail close-up (nails, a key jewelry piece, a piercing, a tattoo, or a held prop — the user picks at the pre-prompt check).

Swap panels by name if the user wants a different mix, but keep the 3×2 grid and the single-prompt format. Every panel carries its explicit position label so the grid composes correctly, and flatness is stated as uniform across all six.

## Critical rules for both formats

- One prompt, one code block, one image. Never separate prompts per panel.
- Identity and wardrobe described **once** in opening paragraphs, applying to every panel.
- Each panel describes only what differs — angle, framing, head state.
- **Skin-tone consistency clause is mandatory.** Rear panels drift darker without it.
- Backdrop and lighting stated explicitly as uniform across every panel.
- Every panel carries its position label.
- No text, labels, or numbering rendered inside the image.

<!-- STUDIO-LOCAL BEGIN: headless 3-panel Seedance-handoff sheet — unique studio IP with no upstream equivalent, purpose-built as a Seedance Subject Lock anchor; kept self-contained so upstream sheet updates diff cleanly against it. -->
## The headless 3-panel sheet — Seedance handoff

> Studio addition — not part of the upstream character-builder grammar. Built as a Seedance Subject Lock anchor: both flanking panels are headless (front AND back), and the face lives in exactly one panel, so Seedance locks identity from a single clean portrait and pulls silhouette, wardrobe, and posture from the panels that carry no face at all. Keep this section self-contained so upstream skill updates diff cleanly against it.

**When to use:** A Seedance-handoff reference sheet, built to anchor Subject Locks for downstream video generation — not a general-purpose character reference. Same gate as the standard 3-panel sheet: only built after an outfit plate exists on the locked character and the user is happy with it.

**Why this exists, vs the standard 3-panel sheet:** Seedance locks identity most reliably from a single clean face and pulls silhouette, wardrobe, and posture from panels that carry no face at all. If every panel on the sheet shows a face, Seedance averages across them and the character drifts or slips identity in motion. The standard sheet's CENTER panel keeps the head attached on the rear view — useful as a general-purpose reference, but not what Seedance wants. This variant puts the face in exactly ONE panel and keeps the other two panels headless (front AND back).

**Layout — one wide 16:9 frame (set in the Higgsfield UI, never written into the prompt), three vertical panels, in this fixed order:**
1. LEFT — headless full-body front (head/face/hair/neck completely absent).
2. MIDDLE — headless full-body back (same pose rotated 180°, garment back construction, hair fall if visible from behind, footwear — head/face/neck still absent).
3. RIGHT — face portrait (tight framing crown to top of neckline/collarbone; the ONLY panel with a face; full identity description written once, here).

**Backdrop and lighting:** one continuous flat gray field behind all three panels, all three lit as one cohesive session with the same locked flat grade used across every other character mode in this skill — matched flat value, matched shadowless illumination, matched grain, matched fabric rendition, zero shadow outside the subject in any panel, zero light bleed onto the field in any panel. Thin subtle vertical seams separate the panels visually; no border frames, no captions, no text. White field only on explicit request, per the studio's gray policy — and the flatness survives the swap.

**Headless panel language (mandatory, both LEFT and MIDDLE panels):** "The head, face, hair, and neck are completely absent from the frame — no floating hair, no ghosted outline, no cutout edge, no visible cross-section, no stump, no blur, no shadow of a head, the flat gray field continues cleanly and uninterrupted through the entire space where the head and neck would be." The garment's neckline/collar sits tied and structured naturally at the collarbone "as if worn on an invisible neck," holding its shape and gathered folds intact.

**Per-panel realism placement:** subsurface scattering and pore/peach-fuzz detail located explicitly per panel — cheeks and ear edges in the face panel, back of the neck and shoulders in the back-body panel — rather than repeated identically across all three. Skin and fabric render at their true natural tone against the neutral gray, never cool-shifted, matching this skill's flat-plate language used elsewhere.

**Canonical prompt structure:**
```
A single wide horizontal cinema-character-reference sheet composed as three equal vertical panels side by side against one continuous flat gray field, completely flat corner to corner in every panel, all three panels lit as one cohesive session with matched flat shadowless light, matched color, matched grain, and matched fabric rendition. Thin subtle vertical seams separate the panels visually but the field reads as continuous flat gray behind all three, no border frames, no captions, no text.

LEFT PANEL — headless full-body front: [pose/outfit/markers]. The head, face, hair, and neck are completely absent from the frame — no floating hair, no ghosted outline, no cutout edge, no visible cross-section, no stump, no blur, no shadow of a head, the flat gray field continues cleanly and uninterrupted through the entire space where the head and neck would be. The neckline sits tied and structured naturally at the collarbone as if worn on an invisible neck. Full body framing from where the head would be down to below the feet/heels.

MIDDLE PANEL — headless full-body back: same stance rotated 180 degrees. [hair fall / garment back construction / accessories and footwear]. Head, face, hair, and neck completely absent from the frame, as described above — the flat gray field continues uninterrupted through the space where the head and neck would be.

RIGHT PANEL — head and face portrait: crown to neckline/collarbone. [full identity description]. Body squared to camera, head level, eyes to camera.

[LOCKED FLAT CLOSE — verbatim, stated as applying uniformly across all three panels, with the per-panel realism placement above woven in.]
```

**One prompt, one frame** — 16:9 set in the Higgsfield UI, never written into the prompt; same single-prompt discipline as the standard 3-panel sheet; never deliver three separate prompts.

**This sheet vs the standard 3-panel sheet — when to pick which:** the standard sheet (head-attached CENTER) is the general-purpose multi-angle character reference and the default when the user just asks for "a character sheet." This headless variant is purpose-built as a Seedance Subject Lock anchor — offer it specifically when the reference feeds Seedance, not as a default replacement.
<!-- STUDIO-LOCAL END -->

---

## UNIVERSAL RULES

1. **No character names in prompt output.** Describe by hair, wardrobe, and identity markers. The tools don't know names; visual descriptors survive across prompts.
2. <!-- STUDIO-LOCAL BEGIN: upstream's prohibition is narrowed to unauthorised use — "No real brand names in prompt output." becomes "No unauthorised real brand names in prompt output." — and the studio adds an authorised override, byte-identical to the clause in `cinema-director`. Re-graft on future upstream updates. --> **No unauthorised real brand names in prompt output.** Generic visual descriptors — "black three-stripe athletic sneakers," not the label. Internal chat can name brands freely. **Override:** when the user explicitly supplies a real brand name and either confirms the rights (the client's own brand under an engagement) or explicitly accepts the risk (personal, non-commercial work), write it verbatim and describe its physical marks — shape, colour, placement, legibility — so the model has something to draw. Never introduce a real brand the user didn't name. <!-- STUDIO-LOCAL END -->
3. **No aspect ratios in prompt output.** Set in the Higgsfield UI. Describe framing in words — "3:4 chest-up headshot," "full body in a tall vertical frame," "tight close-up."
4. **No `@image` tags or placeholders.** Attachment happens in the UI. The prompt refers to references in prose — "the attached face plate," "the character reference," "the outfit reference."
5. **No internal production context.** Every prompt is standalone and self-contained. No "matching the previous scene," no world or project references.
6. **Pure visual description only.** No meta-commentary, no explanation of intent, no references to the medium.
7. **Age-blind.** Describe by build, bearing, role, and wardrobe — never by age word or number.
8. **No teeth-showing smiles** unless explicitly requested. Default is model face-card neutral, or a slight closed-lip smirk.
9. <!-- STUDIO-LOCAL BEGIN: upstream's wording reads as licence to name any in-world text, brand marks included, which inverts rule 2; scoped here to non-brand text so the two rules agree and the brand carve-out stays with rule 2's override. --> **Brand-free but text-accurate.** When a garment or prop carries in-world text or graphics the user wants rendered, name and describe it — shape, color, placement, legibility. Naming the thing renders the thing. Where that text is a real trademark or brand mark, rule 2 governs: describe it generically unless the user has supplied it under rule 2's override. <!-- STUDIO-LOCAL END -->
10. **No negative prompt blocks.** Negations live inline in the prose where they belong.
11. **Flat grade on every plate and sheet, no exceptions.** Directional lighting has no place in a character reference.
12. **Single fenced code block on output.**

---

## DELIVERY FORMAT

**1. Bolded title line with tool routing**, so the user knows where to paste.
`**Face lock — step 2 of 2, Banana Pro 3:4 —**`

**2. Numbered reference list.** One line per attached reference, with a short note on what each carries when more than one is attached. If none: `No references — text-only build.`

**3. One fenced code block.**

<!-- STUDIO-LOCAL BEGIN: sheet-routing pointer — upstream's delivery block names tool routing in general but has no line for the studio's second sheet format. -->
**Sheet routing.** Both the standard 3-panel sheet and the headless Seedance-handoff sheet route to Banana Pro, one prompt each.
<!-- STUDIO-LOCAL END -->

**On iterations — deliver directly.** Any tweak to an already-approved prompt ships as the revised full prompt with no confirmation bullets. Re-check only on a full scope change — a new character, a new outfit, a new mode.

**Wardrobe proposals are the exception to deliver-by-default.** A new outfit always gets its text proposal approved before any image prompt is written, and the two never ship in the same message.

---

## PRE-DELIVERY PASS

- [ ] Which mode applies, and the prerequisite for that mode exists
- [ ] For a new character: text spec locked and approved before any generation
- [ ] Tool fork presented and picked; GPT Image 2 credit cost mentioned once per conversation
- [ ] GPT Image 2 work is chest-up only and carries the extreme-fidelity paragraph
- [ ] The lock pass is 3:4 chest-up with the face filling the frame, never waist-up
- [ ] Every facial plane, the eyes in full, and every identity marker with exact placement written into the lock
- [ ] Additions carry the hold clause and trigger a re-lock if they change the face at rest
- [ ] Outfits went through the text proposal, then a direct build on the locked character — no stand-in model, no preemptive garment plates
<!-- STUDIO-LOCAL BEGIN: amended row — the garment-plate repair ladder is the one marked exception to the Mode-0-only Soul Cinema rule, so the row as written would flag a sanctioned repair as a defect. -->
- [ ] Soul Cinema mentioned only if this is a brand-new face, or the garment-plate repair ladder is in play at repair time
<!-- STUDIO-LOCAL END -->
- [ ] With uploaded garment references: the prompt spends its words on layering, fit on this body, material overrides, side or hand, and anything cropped out of frame — not on re-describing construction the references already show
- [ ] Sheets have identity and wardrobe described once, the correct headless variant, and the skin-tone consistency clause
- [ ] Reference economy — the fewest images that carry what the prompt needs, and each one's role stated when more than one is attached
- [ ] Prompt economy — nothing re-describes what an attached reference already shows, unless it's load-bearing
- [ ] Any material override stated explicitly
- [ ] Axis 1 on and Axis 2 off — biological realism in full, zero capture behavior beyond the 50mm closing line
- [ ] Flat field, shadowless light on the subject, zero shadow outside the subject, zero light bleed — stated per panel on sheets
- [ ] No names, no brands, no aspect ratios, no placeholder tags, no meta-commentary
- [ ] Bolded title with tool routing, numbered reference list, one code block

<!-- STUDIO-LOCAL BEGIN: checklist rows for the re-grafted features — the sheet-format pick, the headless Seedance-handoff sheet, the pre-prompt gate, and the repair-time escalation ladder have no upstream row. -->
- [ ] The correct sheet format was picked — the 3-panel as the general-purpose default, the 6-panel on explicit request only, or the headless Seedance-handoff variant only when the reference explicitly feeds Seedance
- [ ] If building the headless Seedance-handoff sheet: both flanking panels (front and back) are headless, the face lives in exactly the RIGHT panel only, and the per-panel realism placement is stated
- [ ] Pre-prompt check delivered and confirmed before the code block, unless this is a minor iteration on an already-approved prompt
- [ ] Any garment-plate escalation was repair time only, after a direct build failed on that specific piece
<!-- STUDIO-LOCAL END -->

## REPAIR PASS

| Symptom | Fix |
|---|---|
| Face drifting between outfits | The lock plate isn't tight enough — rebuild it chest-up with fuller facial description |
| Outfit rendering generic or rounded off | Fall back to an invisible-mannequin plate for the piece that failed, and only that piece |
| Rear panel skin darker than front | The skin-tone consistency clause is missing |
| Shadow under the feet or behind the shoulder | The zero-shadow-outside-the-subject clause is missing or too short |
| Background brightening or picking up color near the figure | The zero-light-bleed clause is missing |
| Background reading as a lit wall or floor | The "color field, not a photographed backdrop" line is missing |
| Modelling appearing on the face | One of the five flat requirements is missing |
| Hair color change also changed the face | The hold clause is missing or too short |
| Identity marker in the wrong place | It was described relative to nothing — anchor it to a fixed anatomical landmark |
| Sheet coming back mushy or averaged | Too many references disagreeing — drop back to the single approved outfit render |
| Face on a sheet drifting off canon | This is the case where the face lock earns its slot — attach it and state what each reference carries |
| Garment rendering in the reference's material instead of the specified one | The material override line is missing |
| Output reading soft or over-described | Prompt economy failure — cut everything the references already carry |
<!-- STUDIO-LOCAL BEGIN: studio repair rows, plus the amended grain row — the adopted flat close prescribes soft natural film grain, so only grain beyond that closing line is an Axis 2 leak; upstream's unqualified row contradicts its own close. -->
| Vignette, background blur, or grain beyond the closing line's soft natural film grain | Capture-behavior language leaked in from Axis 2 |
| A garment still rounded off after one mannequin plate | Escalate that plate — Soul Cinema, then Banana Pro, then GPT Image 2 — repair time only, and only for the piece that failed |
| Every panel on a Seedance-handoff sheet carries a face | Wrong format built — rebuild with only the RIGHT panel carrying a face and the other two headless, front and back |
<!-- STUDIO-LOCAL END -->
