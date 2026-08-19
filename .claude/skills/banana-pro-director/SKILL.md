---
name: banana-pro-director
description: "Higgsfield image prompt director for cinematic scene plates, environment plates, GPT Image 2 detail stills, and scene-staged outfit replacement. Primary lane: (3) cinematic scene plates with or without characters, (4) GPT Image 2 detail face/chest-up, (5) outfit replacement when the swap is staged straight into a scene — swap a face onto an outfit using two user-tagged refs; a swap banked as a character reference asset default-routes to `character-builder` Mode 3. Character identity work — (0) face locks, (1) single-image outfits, (2A) 3-panel and (2B) 6-panel character sheets — routes to `character-builder` by default; this skill retains full legacy capability for those modes on explicit request. Reads references for hair, makeup, wardrobe, jewelry, identity; outputs photorealistic prompts. Use for scene plates, environment plates, detail shots, scene-staged outfit replacement, or any photorealistic still not routed to character-builder."
---

# Banana Pro Director — Image Asset Builder

<!-- STUDIO-LOCAL BEGIN: upstream ships a bare H1 with no version block; this note records the studio's drop-2 fold, the routing split that narrows this skill's primary lane to scene and environment work, and the STUDIO-LOCAL marking convention used throughout this file. -->
> **Version:** Upstream drop 2 adopted 04/08/2026 onto the 3.0-merged base (diff-and-fold merge). This drop is routing-level only: character work (face locks, outfit refs, character sheets) now routes to the `character-builder` skill by default — this skill's primary lane narrows to scene/environment plates, GPT Image 2 detail stills, and outfit replacement. Modes 0–5 are all retained in full for legacy/explicit-request use. The studio-local headless 3-panel Seedance-handoff sheet (formerly a character-sheet variant here) and the wardrobe-test escalation chain have migrated to `character-builder` — see that skill for both. See the Mode 2 section below for what's retained here. **Marking convention:** every studio divergence from the upstream base is wrapped in a paired `STUDIO-LOCAL` begin/end HTML comment carrying a one-line justification, so a future upstream drop can be diffed mechanically; file-wide label and renumber sweeps are declared collectively in the `STUDIO-LOCAL SWEEPS` block immediately below rather than wrapped at every occurrence.
<!-- STUDIO-LOCAL END -->

<!-- STUDIO-LOCAL SWEEPS: file-wide studio deltas marked collectively here, because an inline wrapper on every occurrence would be unreadable. (a) Frontmatter — `name:` is `banana-pro-director`, not upstream's `banana-pro-director-30`, and `description:` is rewritten to the narrowed primary lane with character work routed to `character-builder`; YAML cannot carry HTML comments, so the divergence is declared here. The H1 title drops upstream's "3.0" version suffix for the same reason. (b) Tool labels — `GPT-2` → `GPT Image 2` and `Nano Banana` → `Nano Banana 2` at every site, matching Higgsfield's current product naming. (c) Character-sheet renumber — upstream already ships the 2A (3-panel) / 2B (6-panel) split natively, so no file-wide renumber applies; the studio corrects only the two residual sites where upstream still reads `Mode 2` for the 6-panel sheet — the **Canonical Mode 2B prompt structure** heading in the MODE 2B — 6-PANEL CHARACTER SHEET section, and the `Mode selected` row of the INVENTORY EXTRACTION CHECKLIST, where upstream's single `2 six-panel` entry is split into `2A three-panel sheet / 2B six-panel sheet`. (d) Flat-grade terminology aligned to this file's LOCKED FLAT GRADE heading in place of upstream's "lighting close". No upstream drop-3 content is adopted anywhere in this file — its sole change is the brand-policy inversion rejected in PR #261, marked at every site below. -->

<!-- STUDIO-LOCAL: FLAT-CLOSE DIVERGENCE FROM character-builder — UPSTREAM PARITY BY DESIGN, NOT DRIFT.
     Recorded 19/08/2026 at the close of the drop-3 adoption, so a future maintainer does not "align" the two files and silently import drop-3 content into this one.

     What is NOT divergent: film grain. This file's LOCKED FLAT GRADE has always closed on
     "Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated."
     at every character-mode site, and this file carries no grain prohibition anywhere. The drop-2
     `character-builder` install *did* ban grain on its flat plate while simultaneously requiring
     "matched grain" on its sheets — a live self-contradiction. Drop 3 resolved it by adopting
     upstream's close verbatim, grain included. So the drop-3 flip CLOSED a real grain divergence
     between the two skills rather than opening one; they now agree. Verified by inspection at
     adoption time. Do not re-open this question on drop 4.

     What IS divergent, and deliberately so: the wording of the flat close itself.
       - `character-builder` (drop-3 base) describes the background as a flat COLOUR FIELD — explicitly
         not a photographed backdrop, with no surface, no floor, no wall, no corner, no horizon and no
         plane the figure stands on or in front of — and adds a standalone zero-light-bleed clause.
       - This file describes an 18% neutral gray SEAMLESS and retains floor-referencing language
         ("no ambient occlusion on the floor beneath the feet").
     Both enforce the same policy: one uniform value corner to corner, shadowless illumination, zero
     shadow on the backdrop, matte skin, true colour, the 50mm/grain close. The wording differs only
     because this file deliberately adopted no drop-3 content and holds parity with its own upstream
     base for mechanical diffability, which is the entire reason its legacy character modes 0/1/2
     still exist. Do NOT reconcile the two texts. Each skill emits its own close verbatim; a future
     drop diffs this file against upstream banana, and `character-builder` against upstream
     character-builder, and both stay clean.
-->

The locked image prompt grammar for great Higgsfield image assets. Six modes, in strict order:

0. <!-- STUDIO-LOCAL BEGIN: upstream restates the Mode 0 tool fork and locked defaults here; the studio consolidates the specification into the MODE 0 section so the two copies cannot drift apart. --> **Face lock (new characters only)** — for any character being developed from scratch. Identity only — no outfit styling, no environment, no in-depth prompting at this stage. Tool fork (Banana Pro single-pass default / GPT Image 2 single-pass / Soul Cinema two-pass), locked backdrop, lighting, and baseline wardrobe are specified once in the MODE 0 section. <!-- STUDIO-LOCAL END -->
1. **Single-image character outfit** — mid-gray seamless studio (locked default — white only on explicit request), full styling readable, locked as the base reference for that character/outfit. Two paths: **Banana Pro** (full custom styling written from prompt — best for simpler outfits) or **Soul Cinema** (outfit built on a bland slim model first, then composited onto the locked character — best for custom fits where wardrobe should be designed separately from casting). User picks based on outfit complexity.
2. <!-- STUDIO-LOCAL BEGIN: character sheets route to the studio's `character-builder` skill by default (which also owns the studio-local headless Seedance-handoff variant); upstream has no such skill and builds them only here. --> **Character sheet** — built ONLY after a single-image base exists. Character sheets are primarily built in the `character-builder` skill now (which also owns the studio-local headless Seedance-handoff variant); this skill retains the format for upstream parity and explicit requests made here. **The 3-panel sheet (Mode 2A) is the default and primary format:** full body front with the head cleanly removed, full body rear with the head attached, and a tight chest-up face lock. **The 6-panel sheet (Mode 2B) is legacy** — available on explicit request only, never proposed proactively, because splitting the frame six ways starves the face panels of resolution. <!-- STUDIO-LOCAL END -->
3. **Scene plates** — character(s) in a fully realized cinematic environment, OR pure environment plates with no characters. Always available, but never proposed proactively — only built when the user asks.

Plus two optional capabilities:

4. **GPT Image 2 detail mode** — Higgsfield's higher-fidelity image model, used only for detail face shots and chest-up portraits when the user explicitly asks for that level of close-up. Never suggested otherwise.
5. **Outfit replacement** — two-reference swap that puts the character from one image into the outfit and pose from another image. Single locked prompt, character/IP-agnostic. Used only when the user explicitly asks to swap a face onto an outfit reference, or any equivalent phrasing.

Photoreal is the universal default. Every prompt this skill produces describes a real human (or real environment) in a real frame, never plastic, never rendered, never CGI.

---

## THE WORKFLOW — STRICT ORDER

The skill enforces this order. Don't skip steps. Don't combine steps.

### Step 0 — Is the character already built?

Before anything else, ask the user: **does the character already exist, or are we developing them?**

**If the character exists:** ask the user to drop the reference image(s). Then study and lock — face, bone structure, skin tone, hair color and texture, identity markers, body proportions. Mirror back the locked spec in plain language so the user can confirm or correct before any prompt is built. Wait for confirmation, then proceed to Mode 1 (outfit work) or whichever mode the user asked for.

**If the character is new:** development happens in two stages — first a text spec, then a face-lock build via Mode 0. Do NOT jump straight to outfit prompts. The face has to be locked as a visual reference before any outfit work can happen.

Stage 1 — text spec: let the user describe the character in their own words. Listen. Then mirror back a locked spec in plain language covering:

- Approximate apparent age register (described by build, not number)
- Face: bone structure, eye shape and color, brow shape, nose, lip shape, skin tone and finish
- Hair: color (every nuance), length, texture, style
- Body: build, proportions, posture, distinguishing markers
- Default makeup register (if any)
- Default expression and energy
- Any key identity markers — piercings, scars, beauty marks, tattoos, signature jewelry

Wait for confirmation or correction. Iterate on the text spec freely until the user says it's locked. Then move to Stage 2.

<!-- STUDIO-LOCAL BEGIN: upstream repeats the Mode 0 tool fork here; the studio points at the MODE 0 section instead. --> Stage 2 — Mode 0 face lock build (tool fork and locked defaults: see the MODE 0 section below). Produces the canonical character reference image used as the identity anchor for every future outfit/scene/sheet prompt. Always run this before any outfit work for a new character. No exceptions. <!-- STUDIO-LOCAL END -->

### Mode 0 — Face lock (new characters only)

<!-- STUDIO-LOCAL BEGIN: upstream repeats the full Mode 0 specification here; the studio keeps a single canonical copy in the MODE 0 section. --> All specification — tool fork, locked backdrop and lighting, baseline wardrobe — lives in the MODE 0 section below. Produces the canonical reference image. Run once per new character. <!-- STUDIO-LOCAL END -->

### Mode 1 — Single-image character outfit (the base outfit reference)

Once the character is locked (either confirmed from existing reference upload, or built via Mode 0), the FIRST image generated for any new outfit is a single-image character outfit on a mid-gray seamless studio backdrop (the locked default — white only on explicit request). No 6-panel sheet ever gets built before a base outfit reference exists.

Ask the user to describe the outfit they want — every garment, every accessory, every styling choice. If they upload a wardrobe reference image, study it visual-only. Mirror back the wardrobe spec for confirmation.

<!-- STUDIO-LOCAL BEGIN: the invisible-mannequin wardrobe-test pass and its escalation chain have migrated to `character-builder` § MODE 2 — OUTFIT BUILDER, Path B — INVISIBLE MANNEQUIN GARMENT PLATE (repair only), where the ladder is re-scoped as a repair-time tool; upstream keeps them here as a Mode 1 pre-step. -->
> The invisible-mannequin wardrobe test pass (proving a complex/custom garment on a headless display before compositing onto the canonical character) now lives in `character-builder` § MODE 2 — OUTFIT BUILDER, under Path B — INVISIBLE MANNEQUIN GARMENT PLATE (repair only) — see the STUDIO-LOCAL escalation ladder there ("Escalation ladder if the plate still will not hold") for the chain.
<!-- STUDIO-LOCAL END -->

**Then — before writing the prompt — ask which tool to build the base in:**

> Want to build this in Banana Pro (Nano Banana 2) or Soul Cinema?
> — **Banana Pro:** writes styling from scratch via prompt, single locked output. Best when the outfit is relatively simple and full prompt control gets us there cleanly in one shot.
> — **Soul Cinema (two-step flow):** Step 1 builds the outfit on a bland slim fit model on mid-gray seamless. Step 2 takes that outfit reference + the locked character reference and composites them. Best for custom/complex fits where wardrobe should be designed separately from casting.

Wait for the user to pick. Different tools use different prompt structures — see Mode 1A (Banana Pro) and Mode 1B (Soul Cinema, two-step) below.

Then run the standard pre-prompt check, wait for the green light, then deliver the prompt in a single fenced code block.

### Mode 2 — Character sheet

Only after a single-image base reference has been generated (and the user is happy with it) can a character sheet be built.

<!-- STUDIO-LOCAL BEGIN: upstream restates the Variant A/B headless treatment here; the studio carries it once, in the extraction checklist. --> **Default to the 3-panel (Mode 2A).** When the user asks for "a character sheet" without naming a format, build the 3-panel: full body front with the head cleanly removed, full body rear with the head attached, and a tight chest-up face lock. Do not ask which format, do not offer the 6-panel. <!-- STUDIO-LOCAL END -->

**6-panel (Mode 2B) is legacy and explicit-request only.** If the user names it, flag once that six cells starve the face panels of resolution, then proceed on their go-ahead.

Same pre-prompt confirmation rule: bulleted summary, get the nod, then deliver the prompt in a code block.

### Mode 3 — Scene plates (with or without characters)

Always available. Never proposed proactively. Only built when the user asks for a scene, an environment, a plate, a moment, or describes a setting.

Same pre-prompt confirmation rule applies.

### Mode 4 — GPT Image 2 detail mode (optional, gated)

<!-- STUDIO-LOCAL BEGIN: upstream writes the GPT Image 2 credit-cost gating question out in full here; the studio points at the MODE 4 gating rules so there is one canonical wording. --> Only used for chest-up portraits or detail face shots, and only when the user explicitly asks for that level of close-up. Even then, confirm the GPT Image 2 run and flag the higher credit cost per the gating rules in the MODE 4 section below. Wait for confirmation, then deliver the prompt. <!-- STUDIO-LOCAL END -->

GPT Image 2 prompt structure differs slightly — see the GPT Image 2 section below.

---

## THE PRE-PROMPT CONFIRMATION RULE (UNIVERSAL)

Every prompt — single image, 6-panel, scene plate, GPT Image 2 — gets a short "here's what I'm about to prompt, sound good?" check before the full prompt is written. This is not optional. Long prompts are expensive in attention and copy-paste effort, and the user shouldn't have to wait on a wall of text only to discover it missed the mark.

**Exception — minor iteration on a just-delivered prompt.** When the user requests a small adjustment to a prompt that was already approved and delivered in this same conversation thread (composition tweak, framing shift, pose change, lighting nudge, swap one wardrobe element, repositioning subjects, etc.), skip the pre-prompt check and deliver the revised full prompt directly in a fenced code block. The character is locked, the wardrobe is locked, the world is locked — only the variable being tweaked is changing, and the user has already seen the spec. Re-confirming on tiny deltas creates friction.

What still triggers a full pre-prompt check even mid-thread:
- New character entering the frame
- New wardrobe (not a tweak — a full outfit swap)
- New mode (going from single-image to a character sheet, or from base to scene plate)
- New environment / scene type
- The user explicitly asking for a check ("walk me through it first")

Default to delivering when in doubt on a clear minor delta. Default to checking when the change touches anything load-bearing.

**Format: clean bullet points only.** No quote blocks, no em-dash prose lines, no narrative wrapper. One short opening line ("Pre-prompt check:" or similar), then bullets. **References listed first, always** — this confirms back to the user that every reference image they uploaded is being read and accounted for in the composition. If a reference is uploaded but missing from the list, the prompt is being composed wrong and the user catches it before the full prompt ships.

The pre-prompt check is short, plain-language, and lists in this order:
- **References attached** (one bullet, always first — list every uploaded reference image by short visual descriptor)
- **Character** (one bullet — hair, skin, identity markers, expression)
- **Outfit / styling** (one bullet — wardrobe head-to-toe, jewelry, body markers)
- **Backdrop or environment** (one bullet)
- **Framing** (one bullet, only if non-default)

Close with a single short question line ("Sound good?" / "Lock it?" / "Run it?").

Format example:

Pre-prompt check:
- **References attached:** locked character reference sheet, outfit wardrobe reference plate
- **Character:** platinum-blonde ponytail, warm fair skin, sharp almond eyes, neutral expression
- **Outfit:** ivory zip-V corset, ivory parachute pants, cream platforms, clear acrylic accessories
- **Backdrop:** mid-gray seamless studio (locked default)
- **Framing:** full body

Sound good?

If no references are attached, the first bullet reads: **References attached:** none — pure text composition.

Wait for the green light. Then drop the full prompt in a single fenced code block.

---

## CORE PHILOSOPHY

No plastic. No CGI sheen. No 3D-render look. No commercial gloss. No AI-generic skin or hair.

Every image this skill produces should read as a photograph — taken on a real camera, by a real person, of a real subject. The character should look lived-in: real pore texture, peach fuzz, hair with flyaways and individual strands catching light, fabric with weight and weave and wear, jewelry with surface detail, eyes with reflection and depth.

**The flattering-realism ceiling (LOCKED — applies to every face, every mode).** Full skin realism is always on — visible pore texture, peach fuzz at the jaw and hairline, subsurface scattering, hair flyaways, the matte finish that carries the anti-plastic look. But realism never means *unflattering*. Faces are never rendered with harsh, severe, or distracting imperfections: no acne, no blemishes, no prominent spots, no scarring, no enlarged or cratered pores, no rough or bumpy texture, no aggressive skin detail that reads as ugly or clinical. The texture is fine, soft, even, and natural — the lived-in realism of good cinema skin under a flattering key, not the brutal macro-detail of a dermatology photo. Matte (never plastic) is the anti-plastic lever; *fine and even* (never harsh) is the flattering lever. Both are always on together. When the two ever seem to pull against each other, resolve toward fine-even-flattering — a face should always look good.

Photorealism is not a tier you opt into — it's the universal default, baked into every prompt. The skill never produces a "stylized," "illustration," "anime," "painterly," "comic," or "rendered" prompt unless the user specifically requests a stylization override (rare, and then noted explicitly).

---

## UNIVERSAL RENDER RULES — FIGHTING THE AI AESTHETIC

These rules are baked into every Banana Pro, Soul Cinema, and GPT Image 2 prompt this skill produces. They're how the skill fights the AI render aesthetic — digital sharpness, dewy faces, plastic skin, glossy beauty register, AI-render flatness — and forces a real photographic register.

**1. Real human skin.**
- Real natural pore texture visible at close range — soft, fine, and even, never as blemishes or acne or marks, never enlarged/cratered/rough, never harsh clinical macro-detail
- Real peach fuzz catching light along the jawline, hairline, temples, and upper lip — fine, photographic, never plastic
- Real subsurface scattering present, warm and real — semi-translucent biology, not opaque plastic
- Skin tone held at the character's natural register — preserved through the grade, never washed out, never cool-shifted ghostly
- No retouching, no skin smoothing, no digital cleanup, no porcelain plastic look, no waxy AI render, no beauty bloom
- <!-- STUDIO-LOCAL BEGIN: upstream restates the flattering-realism ceiling in full here; the studio points at the locked definition in CORE PHILOSOPHY so there is one canonical copy. --> **Flattering ceiling** (locked definition in CORE PHILOSOPHY): fine, soft, even texture under the key, never severe or unflattering imperfection — resolve any tension toward flattering. <!-- STUDIO-LOCAL END -->
- Doll-coded characters (when explicitly requested): smooth matte register without visible pores or peach fuzz but still real and natural, never plastic, never AI-render, never waxen

**2. Real hair physics — strand-by-strand, context-aware.**
- All hair rendered strand by strand with realistic flyaways, baby hairs at the hairline, separation between strands, light transmission through hair ends — never block-of-hair animation
- Hair responds to the actual environment of the scene: still interior = settled hair, moving vehicle = wild hair in active motion, wind = drift, action = kinetic lift and fall, wet = damp matte clumping never glossy oil-slick
- Hair register defaults matte — fine diffuse fiber with soft natural shape, never glossy shine, never reflective sheen unless the user specifies a high-gloss styling

**3. Real lens character.**
- Wide-latitude digital cinema capture as the default register — broad dynamic range, gentle filmic highlight roll-off, never a flat video look
- For character canonicals and seamless studio stills (gray or white): a clean fast normal prime around a 50mm full-frame field of view at a wide aperture — natural round bokeh, even sharpness, gentle background separation, no anamorphic stretch on portraits unless requested
- For scene plates with characters or environments: vintage 2x anamorphic optical character — oval bokeh, a gentle horizontal squeeze on out-of-focus highlights, soft frame-edge falloff, mild organic optical imperfection toward the edges, plus a light diffusion bloom that lifts highlights into a soft halation and takes the hard digital edge off
- Real anamorphic-style horizontal streak flares on point light sources when called for, never on portraits

**4. Real light physics.**
- **Atmospheric depth is default-on across every mode, scaled to fit the shot.** Visible haze and air density between planes — distant elements rendered softer, desaturated, lower contrast than foreground, never a flat backdrop. This is the primary lever against the flat, over-contrasted, plastic look: real air between camera, subject, and background is what makes a frame read as photographed depth rather than a pasted-on plane. Scale the density to the scene (thin for a clean interior, light for most exteriors, heavy for moody/night/destroyed environments) and apply it wherever the shot has planes to separate. The one place it reduces toward zero is a deliberately flat white-seamless still — and even there the mid-gray plate option carries the same low-contrast intent.
- Shadow falloff with physically accurate wrap on real anatomy — soft transitions, never hard edges, real human anatomy under real cinema light
- Subsurface scattering at ear edges, nostrils, eye sockets with warm undertone bleed
- Highlights rolled off gently in a filmic curve, never clipping to pure white — light blooms softly into haze rather than punching as hard white discs
- Lifted blacks that stay open and never crush to pure black, highlights that roll off and never clip — wide dynamic range, full detail held in both shadows and highlights

**5. Real grain.**
- Color-negative motion-picture film look — daylight-balanced for day registers, tungsten-balanced and pushed for night work, the organic color rendition of real film stock baked in
- Fine theatrical 35mm film grain across the entire frame including skin, fabric, atmosphere, backdrop — never the silent clinical fine-grain register of editorial photography
- The grain is what ties everything to real cinema photographic capture

**These five rules are the lock. Every prompt this skill produces invokes them through the merged cinema stack documented below.**

## NIGHT CINEMA REGISTER (FOR NIGHT SCENES)

When the user asks for a night scene, the night work has a specific theatrical action cinema target — **Justin Lin / James Wan / Greig Fraser night work**. This is the dark, practical-driven theatrical action night register seen in Tokyo Drift canyon scenes, Fast 5 night work, Furious 7 night chases, The Batman, John Wick. Critical principle: theatrical night cinema is **mostly dark, with hard punchy practicals cutting through**. NOT saturated-teal-everywhere. NOT bright-night.

**Two modes of night cinema:**

**A. EXTERIOR CANYON / OPEN NIGHT (cliff overlooks, canyon roads, remote night):**
- Light comes EXCLUSIVELY from practical sources in the scene (headlights, brake lights, dash glow leaking out doors, distant city glow). No ambient moonlight, no ambient sky lift.
- The sky and surroundings are committed to deep crushed near-black darkness
- A faint horizon glow may be visible at very deep distance — small, contained, abstract neon color (magenta, cyan, warm amber, hot pink) barely readable as far-off civilization, NOT bright enough to illuminate anything in foreground or midground
- Atmospheric haze suspended in air catches headlight beams as visible warm white volumetric god rays
- Headlight backscatter lights only the immediate front of each vehicle and the rocks/ground directly in front
- Everything outside the headlight throws and their immediate backscatter falls into deep crushed near-black shadow
- The cars themselves read primarily as silhouettes against the night sky with their headlight glow defining their forward edges
- This is the Tokyo Drift canyon night register — DARK, with hard warm headlight punch as the only light

**B. INTERIOR / URBAN / LIT NIGHT (parking garages, warehouses, city streets, interior cabins):**
- Practical sources in the scene drive the look — sodium-vapor street lamps, fluorescent garage lights, neon signs, dash glow, brake lights, interior lighting
- Teal-amber color split can read here because practical sources motivate it (cool sodium / fluorescent / neon vs warm dash / brake / amber lights)
- Atmospheric haze gives light volumetric body
- Background subjects readable through the lit zones
- This is the Tokyo Drift parking garage register, Furious 7 night chase register — practical-driven, deep contrast, real teal-amber color split where motivated

**Universal night cinema rules across both modes:**

**Contrast:** Deep cinematic contrast — shadows are deep but hold information, highlights are hot but don't clip into mush. Wide dynamic range that reads on a real cinema screen.

**Practicals punch hard:** Headlights cut through darkness with real intensity and volumetric throw. Brake lights saturate hot red. Dash glow saturates cabin interiors. Light HITS the scene with purpose, not softly diffused into mush.

**Atmospheric haze:** Light volumetric haze suspended in air (canyon dust, urban smog, breath, ground moisture). The haze catches practical light beams as visible volumetric cones. This is what makes light feel real on screen.

**Rim and edge light:** Subjects in night scenes defined against dark backgrounds by rim and edge light from practical sources. Never silhouettes that disappear, never flat-lit faces with no edge definition.

**Skin in night:** Skin reads warm against cool ambient when there's any cool ambient to read against. Real human skin tone preserved through the grade. Practical light sources warm one side of the face — natural face-side-lighting from real cinema gaffer work.

**The reference is unambiguous:** Real theatrical action movie nights projected onto real IMAX screens. Tokyo Drift, Fast 5, Furious 7, The Batman, John Wick. Theatrical, punchy, **mostly dark, with practical light cutting through**. Never bright-night, never saturated-teal-everywhere, never AI fantasy render.

---

## 18% GRAY SEAMLESS + FLAT GRADE (LOCKED DEFAULT FOR ALL CHARACTER WORK)

**18% neutral gray seamless with a completely flat, shadowless grade is the locked default** for all character work — face locks, character references, outfit plates, 2A/2B sheets, and prop references. **Pure white seamless is now the explicit-request exception**, used only when the user specifically asks for a clean white card (e.g. a finished standalone still meant to be posted or handed off as a polished deliverable). When in doubt, default to gray.

**Why gray as the standing default.** Pure white (and pure black) seamless creates maximum subject-to-background contrast. Video models amplify small mistakes most at high-contrast edges — that's where halo, edge "breathing," and contour instability get baked in during motion. A neutral mid-gray ground lowers the subject-to-background contrast, which means cleaner edge extraction and far less inherited contrast and plastic when the still is read as a reference frame. The same principle that makes a hazy scene plate read as real depth — lower contrast between planes — applies here: gray is the flat-plate version of the fix. Because virtually all character plates eventually seed downstream video work, gray is the correct standing default; white is reserved for the occasional finished standalone still.

**The background stays neutral; the character does not.** The gray ground is an **even neutral mid-gray** — do NOT warm-shift it toward warm-gray. The neutral ground is the locked look. But the gray must never be allowed to cool or neutralize the subject: skin renders at its **true natural skin tone**, and body and wardrobe render at their **true natural color values**, exactly as they'd read under neutral daylight — never cooled, never washed-out, never color-shifted by the background. The relight-from-scratch language and the explicit "warmth preserved and natural, never pale or washed-out or cool-shifted" clause in the flat grade below are what hold this. Keep the background neutral and the subject true.

**The white exception:** only when the user explicitly asks for white. In that case, swap the gray backdrop line for "Pure white seamless studio background, no gradient, no seam line, perfectly even" — but **keep the flat shadowless grade**. Flatness survives the backdrop swap; it is not a property of the gray, it is the locked look for all character work.

**Lighting close for a gray plate (LOCKED FLAT GRADE — use this, NOT the full cinema stack):**

```
Background is an even 18% neutral gray seamless, completely flat — one single uniform value corner to corner, no seam line, no gradient, no hotspot, no vignette, no falloff to lighter or darker anywhere in the frame. Relight from scratch overriding any reference lighting: completely flat shadowless illumination — one enormous soft frontal source at camera position wrapping the subject evenly, matched equal fill from camera-left and camera-right at identical intensity, matched fill from above and below, so both sides of the face read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no cheek triangle, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Zero shadow cast onto the background — the backdrop stays clean flat gray behind the entire figure. No contact shadow, no drop shadow, no ambient occlusion anywhere in the frame. Extremely low contrast, even, milky, catalogue-flat. Form is described by bone structure, hair strands, and fabric folds alone, not by light and shadow. Skin reads matte and velvety — zero shine on forehead, nose bridge, cheekbones, temples, and chin, no oily T-zone. Skin renders at its true natural skin tone and wardrobe at its true natural color, warmth preserved and natural against the neutral gray, never pale or washed-out or cool-shifted by the background. Real peach fuzz at the jaw and hairline, real soft fine even pore texture, subsurface scattering reading as semi-translucent biology, never plastic, never waxy AI render, never glass-skin, never harsh — fine flattering texture that keeps the face looking good, no acne, no blemishes, no rough pores. Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated.
```

**Why flat, and why the lean close instead of the full cinema stack.** These plates are references, not finished frames. Any shadow baked into a reference — a cheek triangle, a nose shadow, a contact shadow under the feet, a falloff on the backdrop — gets inherited and amplified by every downstream generation that reads the plate, and it fights whatever lighting the actual scene wants. So the character plate carries **zero lighting information**: no key direction, no shadow side, no cast shadow, no backdrop falloff. The gray stays one flat value, the subject is described entirely by bone structure, hair, and fabric folds, and the scene plate or video prompt does all the lighting later. The full texture-and-grade stack would push contrast back up, which is exactly what this grade is killing; the lean flat close does the matte/specular/true-color work without re-introducing any of it.

**The three things that must appear in every flat close, always:**
1. **Flat backdrop** — one uniform 18% gray value corner to corner, no seam, no gradient, no hotspot, no vignette, no falloff.
2. **Shadowless illumination** — huge frontal source at camera position, matched equal fill left/right/above/below, no key-and-fill ratio, no shadow side, no rim, no hair light, no kicker, no specular hotspot.
3. **Zero cast shadow** — nothing thrown onto the background, no contact shadow, no drop shadow, no ambient occlusion under the feet or the hem.

If any one of the three is missing, the plate will come back with modelling in it.

**2A (3-panel) and 2B (6-panel) sheets:** the flat default applies the same way, stated as applying **uniformly across all panels** — same flat gray value, same shadowless light, no cast shadow in any panel. Close with the flat grade above instead of the full cinema stack. Only swap to white if the user explicitly asks, and keep the flatness when you do.

---

When the user attaches reference images (character canonical sheets, wardrobe references, environment plates, car interior plates), those references carry the visual identity load. The prompt does NOT need to re-describe what the references already show. Heavy visual description on top of strong references creates double-weight prompts that dilute the photographic direction Banana Pro / Soul Cinema / GPT Image 2 actually need from the text.

**The new structure for every prompt this skill produces:**

**1. Identify subjects by short, distinguishing visual descriptors only.**
- "the woman with platinum-blonde hair in the white unitard" — not a paragraph describing her face structure, skin texture, hair waves, lash length, lip shape, brow arch, body type, posture, makeup
- "the cream pearl coupe interior" — not a paragraph describing every dash gauge, knob, charm, harness, switch
- One distinguishing visual handle per subject is enough — the reference image carries the rest

**2. Put the load on what the prompt UNIQUELY needs to communicate:**
- Composition and framing (where the subject is in the frame, what's in foreground/background, what the camera angle is)
- Pose, expression, what bodies and hands are doing
- Light direction and quality (where the light is coming from, how it falls on the subject)
- Wardrobe or styling SPECIFIC TO THIS PLATE that's not in the existing references
- The cinema stack at the end

**3. Drop the redundant identity descriptions entirely UNLESS the reference is ambiguous.**
- If the user attached the character canonical, the prompt does not need to re-describe face structure, body proportions, skin tone, eye shape. Mention them only when something specific to this plate requires it
- Trust the references to carry identity. The prompt's job is to tell Banana Pro what to DO with the identity in this specific shot

**4. When in doubt, lean shorter.**
- A 2500-character Banana Pro prompt with strong references beats a 5000-character prompt every time
- Banana Pro reads the front of the prompt most heavily; loading the front with composition + pose + light gets better results than burying those decisions under visual description
- The references show the model what things LOOK like. The prompt tells the model how to FRAME them.

**Lean prompt rule of thumb:** if a sentence in the prompt re-describes something that's already visible in an attached reference, cut it unless it's load-bearing for the composition or action.

---

## THE CINEMA STACK (LOCKED — APPENDS TO MOST PROMPTS)

Every prompt this skill outputs ends with a version of this single merged cinema stack. It's the texture + light physics + lens character + grain foundation that fights every AI render tell at once. One block, one job — close the prompt with a real photographic register.

```
Real human skin captured on a real cinema camera — refined and real, peach fuzz catching light along the jawline and hairline, real natural pore texture soft fine and even, subsurface scattering at ear edges, nostrils, and around the eye sockets with warm undertone bleed reading as semi-translucent biology never opaque plastic. No retouching, no skin smoothing, no porcelain plastic look, no waxy AI render, no blemishes, no acne, no marks, no enlarged or rough pores, no harsh clinical texture — fine flattering even skin that always looks good, no dewy wet finish, no glass-skin, no highlighter glow. Hair rendered strand by strand with realistic flyaways and baby hairs at the hairline, hair physics responding to the actual environment of the scene — wind makes it fly, stillness lets it settle. Fabric with real weave detail, real weight, real drape. Captured with a wide-latitude cinema look, lens character matched to the shot — a clean fast normal prime around a 50mm full-frame field of view at a wide aperture for portraits and character canonicals giving natural round bokeh and even sharpness, OR a vintage 2x anamorphic character for scene plates giving oval bokeh, a gentle horizontal squeeze on out-of-focus highlights, soft frame-edge falloff, organic optical imperfection toward the edges, a light diffusion bloom lifting highlights into a soft halation, and subtle horizontal streak flares on point light sources. Shallow depth of field with strong foreground-to-background separation. True atmospheric perspective with visible haze and air density between planes — distant elements rendered softer, desaturated, and lower contrast than foreground, real volumetric atmosphere never a flat backdrop. Key light wrapping around subjects with physically accurate shadow falloff into the neck, jawline, ear shadow, nostril shadow, lip shadow, collarbone shadow — soft transitions never hard edges, real human anatomy under real cinema light. Highlights rolled off gently in a filmic curve, never clipping to pure white, light blooms softly into haze rather than punching as hard white discs. Lifted blacks that stay open and never crush to pure black, highlights that roll off and never clip — wide dynamic range with full detail held in both shadows and highlights. Color-negative motion-picture film look baked in — daylight-balanced rendition for day registers, tungsten-balanced and pushed for night work, fine theatrical 35mm film grain across the entire frame including skin, fabric, atmosphere, and backdrop. No HDR overprocessing, no digital oversharpening, no plastic skin rendering, no uniformly-lit flat-plane staging — photographed not generated, captured on a real camera by a real cinematographer on a real set.
```

**Modal application:**
- <!-- STUDIO-LOCAL BEGIN: the studio adds the explicit cross-reference to the canonical LOCKED FLAT GRADE section so the close is looked up in one place rather than restated. --> **Mode 0 (face lock), Mode 1 (single-image character outfit), Mode 2A/2B (character sheets), Mode 4 (GPT Image 2 detail), Mode 5 (outfit replacement) — i.e. all studio character work:** these close with the **LOCKED FLAT GRADE** (see "18% GRAY SEAMLESS + FLAT GRADE" above), not the full cinema stack. The full stack's key-wrap, anatomical shadow-falloff, and atmospheric-perspective language actively fights the flat plate — never append it to a character plate or sheet. It is documented here for Mode 3 and for the explicit white-card standalone-still exception only. <!-- STUDIO-LOCAL END -->
- **Mode 3A (character-in-scene plate) and Mode 3B (pure environment plate):** Mode 3 uses the cinema-prose register, which folds the cinema stack language INTO the closing camera-spec paragraph rather than appending it as a separate block. See Mode 3 documentation for the prose register and its closing realism clause.
- **Mode 1B Step 1 (bland model outfit reference, Soul Cinema two-step):** use the lighter outfit-reference close documented in the Mode 1B section — NOT the full cinema stack. The outfit reference image just needs to read clean and matte so the outfit is the only subject.

**The single most powerful phrases in this stack:**
- **"atmospheric perspective with visible haze and air density between planes"** — forces multi-plane depth instead of single-plane staging. Biggest fix for the "video game" look.
- **"shadow falloff into the neck, jawline, ear shadow, nostril shadow"** — fights the AI uniform-lit face. Forces real anatomical shadow geometry.
- **"subsurface scattering at ear edges, nostrils, and around the eye sockets with warm undertone bleed"** — fights plastic skin at the biological level. Forces the model to render skin as semi-translucent biology instead of opaque material.
- **"highlights rolled off gently in a filmic curve, never clipping to pure white"** — fights the blown-bright AI highlight that makes everything look digital. Forces the cinema highlight roll-off.
- **"photographed not generated, captured on a real camera by a real cinematographer on a real set"** — surprisingly strong negative signal against AI uniformity at the language level.

**For pure environment plates with no humans:** drop the human-skin and hair lines, drop the subsurface scattering line, drop the shadow-falloff-on-anatomy line. Keep the lens character, atmospheric perspective, light physics, log curve, grain, and closing realism clause.

---

## READING REFERENCE IMAGES

When the user uploads reference images, extract everything visible in the frame by **visual description only** — never use names, never invent details that aren't in the image.

**For each character in the reference, capture:**

- **Hair:** color (every nuance — platinum, jet black with cool undertone, rose-pink, burgundy, ash brown, dirty blonde, etc.), length, style, texture (straight, wavy, curly, coily), parting, any styling (slicked, blown out, flat-ironed, braided, bunned, ponytail, bangs — and which kind of bangs), accessories (clips, bows, ribbons, caps, bandanas, headbands)
- **Makeup:** skin finish (matte, dewy, glass-skin, bare), foundation/coverage register, brow shape and density, eye treatment (cat-eye liner, smoky, sharp graphic, soft bare, glitter, colored), lashes, lip (gloss, matte, gradient, color, fullness), cheek (flush, contour, highlight), any face jewelry, freckles or beauty marks **only if visible in the reference** (do not invent)
- <!-- STUDIO-LOCAL BEGIN: upstream drop 3 inverts this to "name the brand"; the studio holds the prohibition with an authorised override (PR #261) and points wardrobe reading at it. --> **Wardrobe:** every garment top to bottom — fabric, color, fit (cropped, oversized, fitted, baggy), structural details (cutouts, keyholes, ribbing, ribbed cotton, knit, denim wash, leather finish, mesh, latex, silk), neckline, sleeve length, hem position, layering, branding details (described generically — "three-stripe athletic sneakers" not the brand name; unless authorised — see the Brand name rule) <!-- STUDIO-LOCAL END -->
- **Jewelry & accessories:** every piece — earring style, necklace count and material, rings, bracelets, body chains, belts, bag, sunglasses, watch
- **Body markers:** piercings (only if visible), tattoos (only if visible), nail length and color, distinguishing features
- **Pose and energy:** body angle, weight distribution, hand position, expression register

**Naming rule (CRITICAL).** Never use proper names in the prompt output. Refer to characters by visual description: "the rose-pink haired woman in the cropped white ribbed tank," "the figure in the platinum mech suit," "the man in the long charcoal wool coat." Higgsfield does not know names. Visual descriptors survive across prompts; names do not.

<!-- STUDIO-LOCAL BEGIN: upstream drop 3 replaces this rule with its inversion (real brand names allowed by default) — formally rejected in PR #261; the studio keeps the prohibition plus an explicit authorised-brand override. Re-graft on every future upstream update. -->
**Brand name rule (CRITICAL).** Never use real brand names or protected IP in the prompt output. Use generic visual descriptors — "black three-stripe athletic sneakers" not specific brand names, "wide-angle action camera" not specific product names. Internal chat with the user can reference brands by name; the prompt output must be brand-neutral. **Override:** when the user explicitly supplies a real brand name and either confirms the rights (the client's own brand under an engagement) or explicitly accepts the risk (personal, non-commercial work), write it verbatim and describe its physical marks — shape, colour, placement, legibility — so the model has something to draw. Never introduce a real brand the user didn't name.
<!-- STUDIO-LOCAL END -->

**Age-blind rule.** Never describe characters by age. Avoid: *boy, girl, child, kid, young, teen, little, middle-aged, elderly, old.* Describe by role, build, and clothing — "the figure in the wool cloak," "the woman in the cropped tank."

**No-invention rule.** If the user gives you a reference image and asks for the same character in a new scene, do not invent wardrobe or styling details that aren't in the image or specified in the request. If something is needed but not specified (e.g., a new outfit for a new scene), ask before composing.

---

## MODE 0 — FACE LOCK (NEW CHARACTERS ONLY)

**When to use:** Any time a character is being developed from scratch and there is no existing canonical reference image of their face. Run this BEFORE any outfit work, any 6-panel sheet, any scene plate. The face has to be locked as a visual asset first — every downstream prompt anchors to it.

<!-- STUDIO-LOCAL BEGIN: upstream says "white background" here, contradicting its own mid-gray locked default; corrected to the studio gray policy. --> **Goal:** Produce the canonical face reference for the character. Identity only — no outfit considerations beyond a locked neutral baseline top, no environment, no posing direction. Just: a clean, locked face on mid-gray seamless background with soft soft lighting that makes the skin read matte and cinema-placement-ready. <!-- STUDIO-LOCAL END -->

**Universal wardrobe lock for Mode 0:** Every face lock prompt — regardless of tool — puts the character in a neutral baseline top:
- **Women:** plain black thin-strap camisole
- **Men:** plain black ribbed tank
No styling, no jewelry, no logos, no graphics. This keeps the face plate identity-pure and gives every downstream Mode 1 outfit build a clean neutral starting reference.

---

### Tool fork — pick one (ask the user first)

Before any prompt, ask the user which tool to use for the face lock. Three options:

> Want to build this in Banana Pro, GPT Image 2, or Soul Cinema?
> — **Banana Pro (recommended default):** balanced fidelity, reasonable credit cost. Works for most character builds straight up. Single-pass build, no Step 0.1 needed.
> — **GPT Image 2 (highest fidelity, highest credits):** chest-up only, sharpest detail, best for nailing tricky identity markers in one shot (intricate piercings, fine scars, beauty marks, specific eye color). Heads-up — uses considerably more Higgsfield credits than Banana Pro.
> — **Soul Cinema (looser, fast iteration):** good when the user isn't sure yet and wants to throw stuff at the wall to see variations on the face register. Lower fidelity than Banana Pro but faster to iterate. If used, run as Step 0.1 first to produce a face plate, then a Banana Pro 3:4 pass (Step 0.2) to lock the finer detail.

Mention the GPT Image 2 credit cost ONCE per conversation, then drop it for the rest of the session.

Wait for the user to pick. Then proceed to the matching step.

---

### Step 0.A — Banana Pro single-pass face lock (default)

**When:** User picks Banana Pro (or doesn't specify and goes with the default recommendation).

**How:** Single-pass Banana Pro generation, no Soul Cinema plate required. The prompt itself locks identity markers in one shot.

**Pre-prompt check:**

Pre-prompt check — Banana Pro face lock (single-pass):
- **Reference attached:** none — text-only build
- **Character spec:** [identity essentials only — heritage, build, skin, hair color + length + texture, eye shape + color, key identity markers like beauty marks/scars/piercings]
- **Wardrobe:** plain black [camisole / ribbed tank]
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft natural light from camera-[left/right]
- **Framing:** 3:4 headshot, forehead to upper chest, face filling most of the frame

Sound good?

<!-- STUDIO-LOCAL BEGIN: upstream inlines the full flat-grade paragraph into this prompt block; the studio points at the single canonical LOCKED FLAT GRADE section so the two copies cannot drift, and adds the gray-default / white-exception note. -->
**Canonical Step 0.A prompt structure:**

```
A clean cinema-character-reference 3:4 headshot, framed from forehead to upper chest with the face filling most of the frame. [Identity essentials — heritage, build, skin tone and finish, hair (color, length, texture), eye shape and color, any key identity markers being locked: piercings with exact position and metal, scars with placement and size, beauty marks with placement]. She wears [a plain black thin-strap camisole / he wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes to camera, lips closed and relaxed, subtle controlled energy.

[Close with the flat grade: paste the LOCKED FLAT GRADE block from § "18% GRAY SEAMLESS + FLAT GRADE (LOCKED DEFAULT FOR ALL CHARACTER WORK)" here, verbatim and byte-identical — it is emitted as prompt text, never summarised or reworded.]

[Gray is the locked default — use the flat close above. If the user explicitly asks for a white card instead, swap the backdrop line to "Pure white seamless studio background, no gradient, no seam line, perfectly even" and keep every flat/shadowless clause exactly as written. Flatness never comes off.]
```
<!-- STUDIO-LOCAL END -->

---

### Step 0.B — GPT Image 2 single-pass face lock (highest fidelity)

**When:** User explicitly picks GPT Image 2 and has confirmed the higher credit cost.

**How:** Single-pass GPT Image 2 generation, chest-up framing only (GPT Image 2's sweet spot — anything wider loses the fidelity advantage and isn't worth the credit hit).

**Pre-prompt check:**

Pre-prompt check — GPT Image 2 face lock (single-pass, chest-up only):
- **Reference attached:** none — text-only build
- **Character spec:** [identity essentials only — heritage, build, skin, hair color + length + texture, eye shape + color, key identity markers]
- **Wardrobe:** plain black [camisole / ribbed tank]
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft natural light from camera-[left/right]
- **Framing:** chest-up portrait, face dominant in the frame

Sound good?

<!-- STUDIO-LOCAL BEGIN: upstream says "white backdrop" here, contradicting its own mid-gray locked default and Step 0.A directly above; corrected to the studio gray policy with the explicit-request white carve-out preserved. --> **Canonical Step 0.B prompt structure:** Use the GPT Image 2 prompt structure documented in the GPT Image 2 section of this skill (Mode 4). Apply the same identity essentials, wardrobe lock, mid-gray seamless backdrop (locked default — white only on explicit request), and soft soft lighting as Step 0.A — just routed through the GPT Image 2 prompt grammar instead of the Banana Pro grammar. <!-- STUDIO-LOCAL END -->

---

### Step 0.1 + Step 0.2 — Soul Cinema two-pass face lock (iteration path)

**When:** User picks Soul Cinema. Use when the user wants to throw variations at the wall before committing to a final face. Soul Cinema is the lowest-fidelity option for face work, so it gets used only as a quick exploratory pass, then Banana Pro locks the result.

### Step 0.1 — Soul Cinema face plate

Run a lean Soul Cinema generation to produce a clean face plate on mid-gray seamless with soft soft lighting. The plate is exploratory — identity essentials only, no makeup detail, no granular facial anatomy, no fine identity markers (those go into Step 0.2 where Banana Pro can actually hold them).

**Pre-prompt check:**

Pre-prompt check — Step 0.1 of 2 (Soul Cinema face plate):
- **Reference attached:** none — text-only build
- **Character spec:** [identity essentials only — heritage, build, skin tone, hair (color, length, texture), eye shape and color, beauty marks / scars only if they're large/obvious — fine markers held for Step 0.2]
- **Wardrobe:** plain black [camisole / ribbed tank]
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft natural light from camera-[left/right]
- **Framing:** chest-up, face clearly readable, body squared to camera

Sound good?

**Canonical Step 0.1 prompt structure (lean — identity essentials only):**

```
A [heritage] [woman / man] with a [slim / specified] build, [skin tone and finish], [hair color, length, texture]. [Eye shape and color]. [Large/obvious identity markers only — beauty marks or scars that are visually dominant. Hold fine markers for Step 0.2]. [She wears a plain black thin-strap camisole / He wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes to camera, lips closed and relaxed.

Background is an even 18% neutral gray seamless, completely flat — one single uniform value corner to corner, no seam line, no gradient, no hotspot, no vignette. Completely flat shadowless illumination — a huge soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the face read at exactly the same brightness. No shadow side, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker. Zero shadow cast onto the background. Extremely low contrast, even, milky, catalogue-flat. Skin renders at its true natural skin tone, warmth preserved and natural against the neutral gray, never cool-shifted or washed-out by the background. Skin reads matte and slightly diffused, clean and even, ready for placement onto cinematic scene plates. Chest-up framing.

Real human skin with visible natural pore texture, fine peach fuzz catching light along the jawline, subtle subsurface scattering on the cheeks and ear edges. Hair rendered strand by strand with realistic natural texture, individual flyaways at the hairline. Fine cinema grain. Lived-in, not pristine. Photographic, not rendered.
```

This is intentionally lean — no full cinema stack at this stage, no granular face anatomy (jaw, chin, lips, cheekbones, brow detail), no makeup paragraph. Let Soul Cinema interpret the face from the essentials. Step 0.2 locks the rest.

After delivery, the user runs this in Soul Cinema, saves the result as the Step 0.1 face plate reference.

### Step 0.2 — Banana Pro 3:4 headshot to lock the full facial character

Once the Soul Cinema face plate exists, run a second-pass Banana Pro 3:4 headshot using that Soul Cinema plate as the character reference. This second pass locks finer facial detail (exact eye color, lip shape, facial structure, skin texture) and any fine identity markers (small scars, beauty marks, piercings) that need to be permanent across all future prompts.

**Pre-prompt check:**

Pre-prompt check — Step 0.2 of 2 (Banana Pro 3:4 headshot, identity lock):
- **Reference attached:** the Soul Cinema face plate from Step 0.1
- **Character spec:** [same essentials as Step 0.1, PLUS all fine identity markers — beauty marks with placement, scars with placement and size, piercings with exact position and metal, makeup register if relevant]
- **Wardrobe:** plain black [camisole / ribbed tank] (matching Step 0.1)
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft from camera-[left/right] (matching Step 0.1)
- **Framing:** 3:4 headshot, forehead to upper chest, face filling most of the frame

Sound good?

<!-- STUDIO-LOCAL BEGIN: upstream inlines the full flat-grade paragraph into this prompt block; the studio points at the single canonical LOCKED FLAT GRADE section so the two copies cannot drift, and adds the gray-default / white-exception note. -->
**Canonical Step 0.2 prompt structure:**

```
A clean cinema-character-reference 3:4 headshot of the same character as the attached Soul Cinema face plate, framed from forehead to upper chest with the face filling most of the frame. [Full character descriptor — heritage, build, skin tone and finish, hair (color, length, texture), face register (jaw, chin, lips, cheekbones, brow shape), eye shape and color, all identity markers being locked: piercings with exact position and metal, scars with placement and size, beauty marks with placement, default makeup register]. She wears [a plain black thin-strap camisole / he wears a plain black ribbed tank], no jewelry, no logos, no graphics. Body squared to camera, head level, neutral relaxed expression, eyes to camera, lips closed and relaxed, subtle controlled energy.

[Close with the flat grade: paste the LOCKED FLAT GRADE block from § "18% GRAY SEAMLESS + FLAT GRADE (LOCKED DEFAULT FOR ALL CHARACTER WORK)" here, verbatim and byte-identical — it is emitted as prompt text, never summarised or reworded.]

[Gray is the locked default — use the flat close above. If the user explicitly asks for a white card instead, swap the backdrop line only and keep every flat/shadowless clause exactly as written. Flatness never comes off.]
```
<!-- STUDIO-LOCAL END -->

After delivery, the user runs this in Banana Pro. The output becomes the canonical character reference image — the locked face card used as the identity anchor for every future outfit/scene/sheet prompt for this character.

**Why two steps for Soul Cinema:** Soul Cinema is faster and looser than Banana Pro on faces but holds less fidelity. The two-step flow uses Soul Cinema for exploration (cheap variations on the face register) and Banana Pro for the lock (fine markers, exact eye color, makeup, the canonical reference). This is the slowest path of the three options — only use it when iteration is more valuable than speed.

---

**What Mode 0 is NOT for:**
- Refining an existing character that already has a canonical reference → not needed, skip to Mode 1
- Outfit design → use Mode 1 (Mode 0's locked black camisole/tank is identity-baseline, not a styled outfit)
- Multi-angle sheets → use Mode 2A (3-panel, default), but only AFTER Mode 0 + Mode 1 are done

Mode 0 is one-and-done per character. Once the locked 3:4 headshot exists, every future prompt for that character anchors to it.

---

## MODE 1A — SINGLE-IMAGE CHARACTER OUTFIT, BANANA PRO PATH

**When to use:** First image of any character/outfit pairing **when the user picks Banana Pro** in the Mode 1 tool fork. Best for relatively simple outfits where full prompt control gets us there in one clean shot. Heavier on styling description, full control over every detail, single locked output.

**Goal:** Single character, face clearly readable, full styling locked head-to-toe, environment minimal so the character is the only subject. The prompt is identity-forward, environment-minimal, lighting-controlled.

**Frame and composition:**
- Framing: Subject centered, weight shifted onto one hip in the cocked-hip model stance, body angled 15–30° from camera, chin slightly tucked or level, eyes to camera or slightly off-camera. Default is full-body for an outfit reference because it shows the whole fit; waist-up or head-to-shoulders only when the user asks. Do not write aspect ratios into the prompt — the user sets aspect in the Higgsfield UI.
- Background: **18% neutral gray seamless studio, flat.** The locked default for all character/outfit work — one uniform gray value, no seam line, no gradient, no falloff. Lowers subject-to-background contrast for cleaner edges and less inherited plastic when the still seeds downstream video. **Exception:** if the user explicitly asks for a clean white card, swap to pure white seamless — but keep the flat shadowless grade.
- Lighting: **Flat and shadowless.** Huge frontal source at camera position, matched equal fill left, right, above, below. No key side, no shadow side, no rim light, no hair light, no kicker, no cast shadow on the background, no contact shadow under the feet. Skin reads matte and even, carrying zero lighting information into downstream work.

**Default expression:** Model face-card neutral, subtle controlled, slight closed-lip smirk at most. Never teeth-showing smile unless the user specifically requests it.

**Canonical Mode 1A prompt structure:**

```
[Visual descriptor of the character — hair, makeup, full wardrobe head-to-toe, jewelry, body markers, all extracted from references or locked from the development phase]. [Pose direction — body angle, weight distribution, hand position, expression].

Background is an even 18% neutral gray seamless, completely flat — one single uniform value corner to corner, no seam line, no gradient, no hotspot, no vignette, no falloff to lighter or darker anywhere in the frame. Relight from scratch overriding any reference lighting: completely flat shadowless illumination — one enormous soft frontal source at camera position wrapping the whole figure evenly, matched equal fill from camera-left and camera-right at identical intensity, matched fill from above and below, so both sides of the face and body read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Zero shadow cast onto the background — the backdrop stays clean flat gray behind and around the entire figure. No contact shadow, no drop shadow, no ambient occlusion on the floor beneath the feet. Extremely low contrast, even, milky, catalogue-flat. Form is described by fabric folds, garment structure, and bone structure alone, not by light and shadow. Skin and fabric read matte and velvety, no shine, no gloss, no oily T-zone. Skin renders at its true natural skin tone and the outfit at its true natural color, warmth preserved and natural against the neutral gray, never pale or washed-out or cool-shifted by the background. Real peach fuzz at the jaw and hairline, real fine even pore texture, subsurface scattering reading as semi-translucent biology, real fabric weave and drape, never plastic, never waxy, never harsh. Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated. [Framing — full body / waist-up / head-to-shoulders].

[Gray is the locked default — use the flat close above. If the user explicitly asks for a white card, swap the backdrop line only and keep every flat/shadowless clause exactly as written. Flatness never comes off.]
```

**Variation strategy when building multiple base references:** When generating a series of single-image base references for the same character (different outfits, different lighting moods, etc.), keep the mid-gray seamless backdrop locked and vary one parameter per shot:

- Pose (cocked-hip front → angled three-quarter → seated → side profile → back-to-camera over-shoulder)
- Framing (full body → waist-up → head-to-shoulders)
- Expression (neutral → smirk → eyes-closed → looking off-frame)
- Lighting direction (key from L → R → top → backlit)

Don't vary face, skin, or core identity markers. Those stay locked.

---

## MODE 1B — SINGLE-IMAGE CHARACTER OUTFIT, SOUL CINEMA PATH

**When to use:** First image of any character/outfit pairing **when the user picks Soul Cinema** in the Step 1 tool fork. Best when the user wants to design a custom fit and put it on the locked character without prompt-writing the styling from scratch onto the face. Faster iteration than Mode 1A, more variety per generation, lighter prompts.

**How it works — TWO-STEP FLOW (critical):**

Soul Cinema is a two-step process. Do not skip Step 1B.1 and jump straight to compositing.

### Step 1B.1 — Generate the outfit on a neutral model

First, build the outfit on a slim, normal-looking model (gender-matched to the outfit) so it exists as a clean visual reference. No locked character yet — just the fit on a generic model with normal hair and a normal model face on mid-gray seamless. The model is straight-on, not posed, neutral expression, so the focus stays on the clothes.

**Model spec (locked):**
- Slim model build, refined proportions
- Normal hair — simple natural style appropriate to the model's gender (medium-length straight or slight wave for women, short clean cut for men), neutral natural color (medium brown by default unless the outfit calls for something specific)
- Normal model face — clean even features, neutral natural makeup if a woman (skin-tint, soft brow, neutral lip), no styled makeup if a man, blank neutral model expression
- Straight-on stance, weight evenly distributed, arms relaxed at the sides, not posed, not cocked-hip
- Body squared to camera, eyes to camera
- Gender matched to the outfit — woman for women's wear, man for menswear, the figure that fits the outfit best for unisex

**Pre-prompt check (clean bullet format):**

Pre-prompt check — Step 1 of 2 (build the fit):
- **Subject:** slim [woman/man], normal hair, neutral model face, straight-on relaxed stance
- **Outfit:** [full outfit description — every garment, accessory, jewelry, footwear]
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft natural light from camera-[left/right] (user picks side)

Sound good?

**Canonical Step 1B.1 prompt structure:**

```
A slim [woman / man] standing straight-on to camera in a relaxed neutral stance, weight evenly distributed across both feet, arms hanging relaxed at the sides, shoulders level and relaxed, body squared to the camera, head level. Medium-length [natural medium brown hair, simple straight or slight natural wave, parted naturally / short clean haircut, natural medium brown color]. Clean even features, neutral natural skin tone, [light natural makeup with skin-tint finish, soft groomed brows, neutral lip / no makeup, naturally groomed brows], neutral blank model expression, eyes directly to camera, lips closed and relaxed. Slim model build with refined proportions. The figure wears [full outfit description here — every garment top to bottom with fabric, color, fit, structural details, layering, hem positions, footwear, jewelry, accessories].

Background is an even 18% neutral gray seamless, completely flat — one single uniform value corner to corner, no visible seam line, no gradient, no hotspot, no vignette, no falloff to black or white. Completely flat shadowless illumination — a huge soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the figure read at exactly the same brightness. No shadow side, no harsh shadows, no rim light, no kicker, no hair light. Zero shadow cast onto the background, no contact shadow on the floor beneath the feet. Extremely low contrast, even, milky, catalogue-flat. Skin and fabric read matte and slightly diffused, clean and even, the outfit fully readable and rendering at its true natural color against the neutral gray, never cool-shifted or washed-out by the background. Full body framing from head to just below the footwear.

Real fabric texture with visible weave detail, real weight, real drape, visible texture variation across the surface. Jewelry with real metal surface detail. Real human skin with natural pore texture. Fine cinema grain, soft lens vignette, natural color grade. Photographic, not rendered.
```

Note: Lighting is intentionally soft soft from a single side — no full theatrical cinema stack at this stage, no dramatic three-point lighting. The outfit is the only subject. The lighter close is deliberate — we want a clean, matte, slightly diffused outfit reference that composites cleanly onto the locked character in Step 1B.2 without dragging cinema register baggage along. Run this in Soul Cinema. The user saves the result — that's the outfit reference for Step 1B.2.

### Step 1B.2 — Composite the outfit onto the locked character

Once the outfit reference exists from Step 1B.1, run a second Soul Cinema generation that uses two reference images:
- **Reference Image 1:** the locked character — canonical face/body/identity reference sheet
- **Reference Image 2:** the outfit reference generated in Step 1B.1 — the neutral model in the locked fit

Both images are uploaded directly in the Higgsfield UI.

**Pre-prompt check (clean bullet format):**

Pre-prompt check — Step 2 of 2 (composite onto character):
- **Reference Image 1 (character):** the locked canonical character reference (from Mode 0 face lock or previously approved reference sheet)
- **Reference Image 2 (outfit):** the neutral model reference from Step 1B.1
- **Backdrop:** mid-gray seamless studio (locked default)
- **Lighting:** soft soft studio lighting

Sound good?

**Canonical Step 1B.2 prompt structure:**

```
Place the face and body from reference image 1 onto the outfit from reference image 2. Background is an even 18% neutral gray seamless, completely flat — one uniform value corner to corner, no seam line, no gradient, no vignette. Skin and outfit at their true natural tone. Completely flat shadowless studio illumination — soft frontal source at camera position with matched equal fill from both sides, above, and below. No shadow side, no rim light, no kicker, no contact shadow, no shadow cast onto the background. Extremely low contrast, even, catalogue-flat.
```

That's it. Do not add styling description (Soul Cinema reads it from Image 2). Do not add character description (Soul Cinema reads it from Image 1). Do not add the cinema stack (Soul Cinema preserves the reference image fidelity natively). Do not add framing instructions unless the user specifically requests something other than full-body.

**Universal prompt rules still apply (both steps):**
- No character names in prompt output
- <!-- STUDIO-LOCAL BEGIN: brand-rule wording follows the studio prohibition-plus-override, not upstream drop 3's "real brand names are allowed" (formally rejected in PR #261). --> No unauthorised real brand names in prompt output <!-- STUDIO-LOCAL END -->
- No `@image` tags or `<<<image_n>>>` placeholders — image attachment happens in the Higgsfield UI directly
- No aspect ratios in prompt output

**When to push the user back to Mode 1A:** If the user wants the outfit and character built in a single shot without the two-step process, or wants extreme stylistic control over how the outfit reads on the character's specific body — that's a Mode 1A job. Soul Cinema's strength is clean separation of outfit design from character casting.

---

## MODE 2 — CHARACTER SHEETS

<!-- STUDIO-LOCAL BEGIN: character sheets route to `character-builder` by default; this section is retained for upstream parity and explicit in-skill requests, and the headless Seedance-handoff variant formerly built here has migrated to that skill. -->
> Character sheets are primarily built in the `character-builder` skill, which also carries the studio-local headless 3-panel Seedance-handoff variant formerly built here. This section is retained for upstream parity and for explicit requests to build a sheet directly in this skill.
<!-- STUDIO-LOCAL END -->

Two formats. **2A (3-panel) is the default.** 2B (6-panel) is legacy and only runs on explicit request.

**When the user asks for "a character sheet" with no format named, build the 3-panel (2A). Do not ask which one, do not offer the 6-panel.** The 6-panel only enters the conversation if the user names it.

---

## MODE 2A — 3-PANEL CHARACTER SHEET (PRIMARY, LOCKED DEFAULT)

**When to use:** Any time a character sheet is requested, unless the user explicitly names the 6-panel. Only after a single-image base reference exists and is approved.

**Why 3 panels beat 6:** the sheet is one image with a fixed pixel budget. Six cells splits that budget six ways, and the face — the one thing the sheet exists to lock — lands in cells too small to hold real identity detail. Three cells give each panel roughly double the resolution, which is what makes the chest-up face panel actually usable as a downstream identity anchor.

**Canonical 3-panel layout (one horizontal frame, three equal vertical panels, thin clean separation between them):**

1. **LEFT — Full body front, headless.** The full figure squared to camera, arms relaxed at the sides, hands open and loose, weight even across both feet, framed head-to-hem with **full headroom preserved** — generous empty backdrop above the shoulders where the head would be, so the figure sits in the frame at the same scale and position as a normal full-body portrait. **This is not a crop.** The head is *removed from the body*, not cropped out by the frame edge. The panel exists to isolate the garment, the silhouette, and the body proportions with zero facial data competing for the model's attention.

2. **CENTER — Full body rear, head attached.** Photographed from directly behind, standing straight, arms relaxed, weight even. Hair fall, garment back construction, hem, train, and footwear all readable from behind.

3. **RIGHT — Tight chest-up face lock.** Framed from just above the top of the head down to the collarbones and the very top of the garment only. Face fills most of the panel — a true close-up. Body squared to camera, head level, eyes to camera, lips closed and relaxed, neutral controlled expression. Brows, lashes, lip texture, and skin detail readable at close range. **This panel is the identity anchor. It must be tight — chest-up, not waist-up.** If the framing drifts wider, the sheet loses its whole reason for existing.

---

### THE HEADLESS CUT — TWO VARIANTS (PICK BY GARMENT)

The left panel's headless treatment changes based on what the character is wearing. Read the neckline, then pick.

**Variant A — GHOST MANNEQUIN (hollow neckline).** Use when the garment has a **structured or closed neckline that sits at or above the collarbone** — a t-shirt collar, a crew neck, a ribbed tank, a turtleneck, a shirt, a hood, a jacket collar, a keyhole top. Anything with a real opening the eye expects a neck to come out of.

There is **no head and no neck at all** — nothing rises above the shoulder line. The collar holds its own three-dimensional shape and the opening reads as an **empty dark hollow looking down into the inside of the garment**, with the inner back of the fabric faintly visible inside the opening. The garment reads as if worn by an invisible body — full volume, natural drape, real fabric tension across the chest and shoulders — but nothing emerging from the neckline. Necklaces, if present, still sit around the empty collar opening, resting on the fabric.

**Variant B — CLEAN NECK CUT (mannequin termination).** Use when the garment has **no real neckline to hollow out** — a strapless gown, a halter, a spaghetti-strap slip, a deep cowl, a scooped or plunging dress, a bandeau. The chest and shoulders are largely bare, so there is no collar for the eye to look "into."

Here the **neck rises a short way from the shoulders and terminates in a clean, flat, sharply defined horizontal edge at the base of the throat** — exactly like a headless dress-form mannequin. A crisp sculptural cut with a clean visible edge. Above that edge there is only empty backdrop.

**Both variants ship with the same suppression stack, always:** not blurred, not faded, not dissolving, no wisps, no smoke, no ghosting, no transparency in the body, no stump, no anatomy detail at the cut, no blood, no gore. And in both variants, **the hair goes with the head** — no hair falling across the chest or shoulders in the left panel.

**Locked left-panel language, Variant A (ghost mannequin):**
```
LEFT PANEL — full body front view, no head, no neck, and no hair. The body stands squared to camera from the shoulders down to [the shoes / the hem], arms relaxed at the sides, hands open and loose, weight even across both feet. There is no head, no neck, and no hair at all — nothing rises above the shoulder line, and no hair falls across the chest or shoulders. The [collar type] of the [garment] holds its own shape at the top of the garment and its opening is an empty dark hollow looking down into the inside of the [garment], with the inner back of the fabric faintly visible inside the opening. The garment reads as if worn by an invisible body — full three-dimensional shape, natural drape, real fabric tension across the chest and shoulders, but nothing emerging from the neckline. No stump, no skin, no cut edge, no anatomy, no blood, no fade, no blur, no ghosting, no transparency in the body. The panel keeps full headroom, generous empty mid-gray backdrop above the shoulders, so the figure sits at the same scale and position in the frame as a normal full-body portrait.
```

**Locked left-panel language, Variant B (clean neck cut):**
```
LEFT PANEL — full body front view, headless. The full figure stands squared to camera from the shoulders down to [the shoes / the hem], arms relaxed at the sides, hands open and loose, weight even across both feet. There is no head and no hair — no hair falls across the chest or shoulders. The neck rises a short way from the shoulders and terminates in a clean, flat, sharply defined horizontal edge at the base of the throat, exactly like a headless dress-form mannequin — a crisp sculptural cut with a clean visible edge, not blurred, not faded, not dissolving, no wisps, no smoke, no ghosting, no transparency, no blood, no anatomy detail at the cut. Above that clean edge there is only empty mid-gray backdrop. The panel keeps full headroom — generous empty space above the shoulders where the head would be — so the figure sits in the frame at the same scale and position as a normal full-body portrait.
```

---

### Mode 2A pre-prompt check

```
Pre-prompt check — 3-panel character sheet:
- **References:** [list every reference being attached, in order]
- **Left:** full body front, headless — [ghost-mannequin hollow at the (collar type) / clean neck cut, per the garment]
- **Center:** full body rear, head attached
- **Right:** tight chest-up face lock
- **Outfit:** [locked outfit, identical across all three panels]
- **Backdrop:** mid-gray seamless (locked default), uniform across all panels

Sound good?
```

---

### Canonical Mode 2A prompt structure

```
A three-panel character reference sheet composed as one horizontal frame, divided into three equal vertical panels side by side, thin clean separation between panels, the same figure and the same outfit rendered identically across all three.

[Identity paragraph — build, skin, hair color/length/texture, makeup register, identity markers, nails. Described ONCE, applies to all three panels.]

[Wardrobe paragraph — full outfit head-to-toe, every garment, fabric, color, construction detail, footwear, jewelry. Described ONCE, applies to all three panels.]

[LEFT PANEL — headless front. Use Variant A or Variant B locked language above, per the garment.]

CENTER PANEL — full body rear view, head attached. The same figure photographed from directly behind, standing straight, [hair fall from behind], [garment back construction — open back, seams, hem, train], arms relaxed at the sides, hands loose, weight even across both feet, from the top of the head down to [the shoes / the end of the hem].

RIGHT PANEL — tight chest-up portrait, identity lock. The same figure framed from just above the top of the head down to the collarbones and the very top of the garment only, the face filling most of the panel, a true close-up. Body squared to camera, head level, eyes directly to camera, lips closed and relaxed, neutral controlled expression. [Hair, brows, lashes, lip texture, key identity markers] all clearly readable at close range.

18% neutral gray seamless studio backdrop applied uniformly across all three panels — one single flat uniform value corner to corner in every panel, no seam line, no gradient, no hotspot, no vignette, no falloff to black or white, and the identical gray value in all three panels. Relight from scratch overriding any reference lighting: completely flat shadowless illumination in every panel — one enormous soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the face and body read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Zero shadow cast onto the background in any panel — the backdrop stays clean flat gray behind and around the figure. No contact shadow, no drop shadow, no ambient occlusion on the floor beneath the feet. Extremely low contrast, even, milky, catalogue-flat, identical in every panel. Form is described by fabric folds, garment structure, and bone structure alone, not by light and shadow. Skin and fabric read matte and velvety, no shine, no gloss, no oily T-zone. Skin renders at its true natural skin tone, identical in value and hue across the face, arms, and body in every panel, never darkened, never tanned, never pale or washed-out or cool-shifted by the background. [Garment colors] render true and consistent across all three panels. Real peach fuzz at the jaw and hairline, real fine even pore texture, subsurface scattering reading as semi-translucent biology, real fabric weave and drape, visible fine metal surface detail on the jewelry, never plastic, never waxy, never harsh. Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated.
```

**Critical rules for the 3-panel format:**
- One prompt, one fenced code block, one image output. Never deliver three separate prompts.
- Identity and wardrobe live in the opening paragraphs — described once, applied to all three panels.
- Each panel only describes what's *different* — angle, framing, head state.
- **Skin-tone consistency clause is mandatory.** Rear panels drift darker/tanner without it. Always state that skin renders identical in value and hue across face, back, arms, and hands in every panel.
- Backdrop and lighting are uniform across all three cells.
- Every panel carries its explicit position label (LEFT / CENTER / RIGHT) so the model composes the grid correctly.
- No aspect ratio in the prompt — the user sets it in the Higgsfield UI.

---

## MODE 2B — 6-PANEL CHARACTER SHEET (LEGACY, EXPLICIT REQUEST ONLY)

**Never propose this format.** It only runs when the user names it.

**When the user asks for a 6-panel, say this once, then wait:**

> Heads up — splitting into six panels cuts the pixel budget per cell, so the face panels will hold noticeably less identity detail than the 3-panel sheet's chest-up lock. The face is usually the whole point of the sheet, so the 3-panel holds up better as a downstream anchor. Happy to run the 6-panel anyway if you want it — just say go.

If the user says go, build it. Don't re-litigate, don't repeat the warning later in the session.

**When to use:** Only after a single-image base reference has been generated and approved. The 6-panel uses the locked outfit from the base and shows the same character from multiple angles in one image.

**Critical:** Never deliver six separate prompts. Always one prompt → one 16:9 image → six panels in a 3×2 grid.

**Goal:** A single multi-angle reference asset showing the same character from multiple angles, framings, and detail focuses, all generated in one frame so identity is maximally consistent across the panels.

**Canonical 6-panel layout (3×2 grid, top row left-to-right, bottom row left-to-right):**

1. **Top-left — Full body front:** straight-on neutral stance, full styling readable head-to-boots
2. **Top-center — Side profile close headshot (left side):** tight crop from collarbone up, character's left profile facing screen-right, hair detail, ear and earring detail, jaw and chin geometry readable
3. **Top-right — Full body back:** straight back view, showing hair fall, garment drape, accessory details from behind, footwear from behind
4. **Bottom-left — Side profile close headshot (right side):** tight crop from collarbone up, character's right profile facing screen-left, mirror of Panel 2 from the opposite side
5. **Bottom-center — Front face close headshot:** tight crop from collarbone up, body squared to camera, face filling the frame, eyes to camera, skin texture and facial structure readable
6. **Bottom-right — Detail shot:** ONE locked detail close-up — nails (with ring stack if relevant), key jewelry piece (necklace clasp, earring detail, signature ring), a piercing close-up, a tattoo close-up, OR a held prop (the prop fills the frame with the hand). User picks which detail at the pre-prompt check.

**Variation rule:** If the user requests a different mix of panels (e.g., back of head showing hair clip, midriff close-up showing piercing, boot detail), swap them in by name but keep the 3×2 grid and the single-prompt format. The default layout above is what gets used if the user doesn't specify.

**Frame and composition:**
- Layout: 3×2 grid, equal cells, thin clean white gutters between panels, horizontal sheet orientation
- Each panel composed within its cell as if it were its own shot — no cell should feel like a crop of a wider frame
<!-- STUDIO-LOCAL BEGIN: upstream keys the 6-panel sheet with a three-point key/fill/rim setup; the studio applies the locked flat shadowless grade across all six cells, consistent with the 18% gray flat-plate policy for every character mode. -->
- Background: same studio backdrop across all six cells (default 18% neutral gray seamless, flat, matching the base reference) for consistency. Only swap to white-across-all-six-panels if the user explicitly asks for a white sheet (see the 18% GRAY SEAMLESS + FLAT GRADE section).
- Lighting: same flat shadowless grade across all six cells — identity stays locked when lighting is locked
<!-- STUDIO-LOCAL END -->
- Do not write aspect ratios into the prompt — the user sets aspect in the Higgsfield UI (typically 16:9 for sheets, but specified in UI not prompt)

**Canonical Mode 2B prompt structure:**

```
A 6-panel character reference sheet arranged as a 3-column by 2-row grid in a single horizontal frame, separated by thin clean white gutters between panels. Each panel shows the same single character — [full visual descriptor of the character including build, face, hair, makeup, full wardrobe head-to-toe, all accessories, jewelry, body markers, held props].

Panel 1 (top-left): Full body front — [stance description, framing, what's readable].
Panel 2 (top-center): Side profile close headshot, left side — [tight crop from collarbone up, character's left profile facing screen-right, hair and ear and jaw geometry visible].
Panel 3 (top-right): Full body back — [stance, what's visible from behind].
Panel 4 (bottom-left): Side profile close headshot, right side — [tight crop from collarbone up, character's right profile facing screen-left, mirror of Panel 2].
Panel 5 (bottom-center): Front face close headshot — [tight crop from collarbone up, body squared to camera, face filling the frame, eyes to camera].
Panel 6 (bottom-right): Detail shot — [the locked detail close-up: nails / specific jewelry piece / piercing / tattoo / held prop, filling the panel cleanly].

18% neutral gray seamless studio backdrop applied uniformly across all six panels — one single flat uniform value corner to corner in every panel, no seam line, no gradient, no hotspot, no vignette, and the identical gray value in all six panels. Relight from scratch overriding any reference lighting, applied uniformly across all six panels: completely flat shadowless illumination — one enormous soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the face and body read at exactly the same brightness. No modelling, no shadow side, no nose shadow, no under-chin shadow, no rim light, no hair light, no kicker, no specular hotspot. Zero shadow cast onto the background in any panel, no contact shadow beneath the feet. Extremely low contrast, even, milky, catalogue-flat, identical in every panel. Skin and fabric read matte and velvety, rendering at their true natural skin tone and color against the neutral gray, warmth preserved and natural, never cool-shifted or washed-out by the background. Sharp focus across every panel. Real fine even pore texture, peach fuzz at the hairline, subsurface scattering, real fabric weave, soft natural film grain, photographed not generated. Identical character identity locked across all six panels — same face, same skin, same hair, same wardrobe, same accessories, same proportions in every cell.

[Gray is the locked default — use the flat grade above. If the user explicitly asks for a white sheet, swap to "Pure white seamless studio backdrop applied uniformly across all six panels" and keep every flat/shadowless clause exactly as written. Flatness never comes off.]
```

**Critical rules for the 6-panel format:**
- One prompt, one fenced code block, one image output. Never deliver six separate prompts when the user asks for a character sheet.
- Identity description (build, face, hair, wardrobe, accessories) lives in the opening paragraph — described once, applies to all six panels.
- Each panel only describes what's *different* from the locked identity — stance, angle, framing, focus.
- Aspect ratio is set in the Higgsfield UI by the user, never written into the prompt.
- Lighting and backdrop are always uniform across all six cells.
- Every panel must include the explicit panel position label ("Panel 1 (top-left)", etc.) so Banana Pro can compose the grid correctly.

---

## MODE 3 — CINEMATIC SCENE PLATE

**When to use:** Only when the user asks for a scene, an environment, a plate, a moment, or describes a setting. Never proposed proactively.

Two flavors:

- **3A — Character-in-environment plate:** placing one or more locked characters into a fully realized environment. Output becomes a Higgsfield reference asset that can feed Seedance for video generation. Camera language matches the cinema mode the eventual video will use.
- **3B — Pure environment plate:** no characters in frame. Pure location, lighting, atmosphere, set dressing. Useful as an environment anchor for video generation, mood-setting, or world-building.

**Goal:** A single still that captures the world (and the character, when present) and the camera grammar — as if a cinematographer locked off and grabbed a photo on the same camera package mid-take.

**Camera grammar — five cinema modes paired to scene type.** Pick the cinema mode that matches the scene. The cinema mode register (M1, M2, M3, M4, M5) is woven into the camera spec paragraph at the end of the prompt as part of the named camera package — see "THE CINEMA-PROSE REGISTER" for the locked write-out format.

| If the scene is... | Cinema mode |
|---|---|
| Real-world dramatic (street, kitchen, car, bar, interior, exterior location) | M1 — Narrative |
| Studio / editorial / void / clean set / fashion film | M2 — Studio / Editorial |
| Action / combat / chase / high-energy physical | M3 — Action / Combat |
| Performance / concert / stage / pit | M4 — Performance / Concert |
| Atmospheric / empty / no-humans / weather plate | M5 — Atmospheric / Empty |

The cinema mode carries: lens character, filtration look, film-stock rendition, grain, grade, color cast — all described as the visual *look*, never as brand names or model numbers the tools don't recognize. In the cinema-prose register, this gets written out as plain-language aesthetic, e.g., "Captured with a wide-latitude cinema look and a vintage 55mm-equivalent 2x anamorphic character at a wide aperture — oval bokeh, gentle horizontal squeeze, soft frame-edge falloff, a light diffusion bloom lifting highlights into a soft halation, color-negative daylight film rendition with fine 35mm grain, in an M1 cinematic narrative register." The M-tag appears as a brief identifier woven into the prose, not as a standalone label.

---

### THE SILENT 6-BLOCK MENTAL CHECKLIST (PRE-COMPOSITION ONLY)

Before writing the cinema-prose prompt, the skill silently runs through this six-bucket mental checklist to make sure the composition is complete. The buckets are NEVER written as labeled blocks in the prompt — they get woven into continuous cinema prose per the locked register below. This checklist is a thinking tool, not an output structure.

**Bucket 1 — Shot DNA.** Camera position, what the camera is looking at, the framing register, and the mood. The spine of the shot.

**Bucket 2 — Subject behavior + spatial placement.** What the subject is doing in this frame, where they sit in the frame (translated to positional prose, not coordinate notation), direction of motion or gaze.

**Bucket 3 — Visible detail (resolution-aware).** Only the details a real camera at this distance, lens, and motion register would resolve. (Resolution-aware rule documented below.)

**Bucket 4 — World.** Environment as ambience, not architecture. The space's register matters more than counting structural elements. World plate references carry the geometry — the prompt narrates the moment on top.

**Bucket 5 — Light and atmosphere.** What the light is doing, where the haze is, where shadows fall, color temperature register, key vs fill vs rim relationships.

**Bucket 6 — Camera spec + finish.** Full cinema stack as continuous descriptive prose, ending with the closing realism clause.

These six buckets get composed into the five-paragraph prose structure below — they do NOT appear as labeled blocks in the output. See "THE CINEMA-PROSE REGISTER" for the actual write-out format.

---

### RESOLUTION-AWARE DETAIL RULE (LOCKED)

**Describe what the camera at this position can physically see, not what's "true" about the subject.**

Before writing any visual detail in Block 3, the skill silently runs three diagnostic questions:

1. **At this distance, would a real cinema lens resolve this detail?** If no, drop it.
2. **At this motion blur level, would this detail read?** If no, drop it.
3. **At this lighting register, would this detail be visible?** If no, drop it.

**Examples of what this rule kills:**

- A car shot from 200 feet up at 120 mph at dawn → side decals, windshield text, badge logos, wheel spoke count are NOT resolvable. Drop them. The car reads as silhouette + color blocks + headlights + motion blur trails.
- A person walking across a wide environmental plate at 50 yards → facial expression, jewelry, fabric weave are NOT resolvable. Drop them. The person reads as silhouette + hair color + wardrobe color blocks + posture.
- A character in a moody night scene lit by one practical → skin pore detail, peach fuzz, micro-expression are NOT visible at this lighting. Drop them. The character reads as face shape + eye glints + key wardrobe pieces catching light.

**Examples of what this rule preserves:**

- The same car in a tight static shot at 20 feet → decals readable, windshield text readable, badge legible, wheel detail visible. Describe them.
- The same person in a medium two-shot at 8 feet → facial expression readable, jewelry visible, wardrobe detail clear. Describe them.

**Detail is earned by camera proximity, lens length, motion stillness, and lighting intensity. The skill respects this physics.**

---

### X/Y COORDINATE SYSTEM (MENTAL COMPOSITION TOOL — NOT OUTPUT NOTATION)

<!-- STUDIO-LOCAL BEGIN: the studio folds upstream's separate coordinate-notation paragraph into this one line — same rule, one copy. --> **The X/Y coordinate system is the skill's internal composition tool. It is NEVER written into the prompt body.** The skill thinks in subject bounding-box ranges (`X: 30–55% / Y: 55–85%`; X 0% = left edge, Y 0% = top edge, thirds anchors at 33% / 67%) to plan rule-of-thirds placement, motion direction, lead room, and landmark anchoring — always leaving lead room in the direction of motion, never trail room — then translates the plan into positional prose for the prompt. The coordinate library below is documented for the skill's planning use only. It does not appear in the output. <!-- STUDIO-LOCAL END -->

**Frame grid:**
- **X axis:** 0% = left edge, 50% = center, 100% = right edge
- **Y axis:** 0% = top edge, 50% = center, 100% = bottom edge

**Coordinate notation (internal use only):** `X: 30–55% / Y: 55–85%` — the rectangle of frame real estate the subject occupies. Always expressed as a range that represents the subject's bounding box, never a single point.

**Rule-of-thirds anchor table (locked vocabulary):**

| Thirds position | X | Y |
|---|---|---|
| Upper-left third | 33% | 33% |
| Upper-right third | 67% | 33% |
| Lower-left third | 33% | 67% |
| Lower-right third | 67% | 67% |
| Center | 50% | 50% |
| Upper third line (horizon/eye line) | — | 33% |
| Lower third line (horizon/eye line) | — | 67% |
| Left third line (vertical anchor) | 33% | — |
| Right third line (vertical anchor) | 67% | — |

**Standard cinematographer placement library:**

- **Hero subject, strong vertical (left third):** subject `X: 28–38% / Y: 25–95%`
- **Hero subject, strong vertical (right third):** subject `X: 62–72% / Y: 25–95%`
- **Two-shot facing each other:** subject A `X: 15–40% / Y: 25–90%`, subject B `X: 60–85% / Y: 25–90%`
- **Wide environmental with hero subject on lower-right third:** subject `X: 60–75% / Y: 55–80%`, environment fills the rest
- **Close-up face with eye line on upper third:** subject `X: 25–75% / Y: 10–85%`, eyes at `Y: 33%`
- **Three-quarter body portrait:** subject `X: 30–70% / Y: 15–95%`
- **Horizon on upper third:** horizon line at `Y: 33%`, sky fills `Y: 0–33%`, ground fills `Y: 33–100%`
- **Horizon on lower third:** horizon line at `Y: 67%`, sky fills `Y: 0–67%`, ground fills `Y: 67–100%`
- **Vehicle in motion:** car positioned at `X: 30–55%` with motion direction pointing toward `X: 100%`, leaving lead room ahead of the car for the eye to follow movement (always leave lead room in the direction of motion — never trail room)
- **Aerial subject (overhead light source, helicopter, sun shaft):** light source enters frame at the top edge `Y: 0%`, cone widening as it falls, source itself off-frame, subject lit at the destination coordinates
- **Architectural symmetry (centered hallway, centered facade, centered car alignment):** subject `X: 35–65% / Y: variable`, symmetry preserved

<!-- STUDIO-LOCAL BEGIN: the positional-prose translation table is relocated here from upstream's deprecated OLD COORDINATE GRAMMAR section, which the studio removed; the table is still live doctrine and had to survive that removal. -->
**Coordinates are translated into positional prose for the prompt output.** Internally, the skill thinks of the primary subject in Paragraph 2 with a coordinate range, environmental landmarks in Paragraph 3, and load-bearing light sources in the light-and-atmosphere writing — then writes those positions as "centered in the room," "in the deeper background camera-left," "anchored on the lower-left third," etc.

| Old coordinate notation | New prose translation |
|---|---|
| `X: 38–62% / Y: 12–95%` | "centered in the frame" / "filling the centered vertical column" |
| `X: 18–55% / Y: 8–95%` | "in the left half of the frame" / "filling the foreground left" |
| `X: 60–85% / Y: 25–80%` | "in the right portion of the frame" |
| `X: 30–55% / Y: 55–85%` | "in the lower-left third" / "anchored to the lower-left third" |
| horizon at `Y: 33%` | "the horizon line sitting at the upper third" |
| subject in `X: 28–38%` (left third) | "anchored on the left third" / "weighted to the left of frame" |
| second subject `X: 60–85%` | "in the deeper right background" / "positioned camera-right" |
<!-- STUDIO-LOCAL END -->

---

### THE LOCKED TAG BLOCK (DEPRECATED FOR PROSE — KEPT AS FALLBACK)

<!-- STUDIO-LOCAL BEGIN: condensed from upstream's two-paragraph deprecation note plus its follow-on mutual-exclusivity paragraph, which the studio folds into this line. --> Deprecated — superseded by the cinema-prose closing paragraph (see THE CINEMA-PROSE REGISTER below). Used only when the user explicitly requests a stripped-down lean Mode 3 prompt; it then replaces the cinema-prose close. Modes 0, 1, 2, 4, and 5 are unaffected and keep the full cinema stack. <!-- STUDIO-LOCAL END -->

```
[Cinema mode tag — M1 Narrative / M2 Studio / M3 Action / M4 Performance / M5 Atmospheric]. Atmospheric volumetric haze. Real volumetric light physics. Gentle filmic highlight roll-off. Lifted blacks. Theatrical 35mm grain. Photographed not generated.
```

---

### THE CINEMA-PROSE REGISTER (LOCKED, NON-NEGOTIABLE)

**Mode 3 prompts are written like a DP describing a real frame, not like a spec sheet.** The 6-block spatial logic still applies — but it dissolves INTO the prose. No labeled headers, no `X: 30–55% / Y: 25–95%` coordinate notation in the body, no CRITICAL LIGHTING RULES blocks, no explicit negations, no architectural enumeration of room geometry.

The voice is **cinematic anamorphic prose** — confident, declarative, observational. The kind of language that appears in a treatment, a shot list narration, or a hero-still caption. Like a real photograph being described, not a frame being engineered.

**Why this register works:**
- The model responds to confident scene description, not coordinate grids
- References carry the heavy lifting on geometry, palette, and continuity — the prompt narrates the moment ON TOP of the reference
- Over-specification creates conflicting instructions; the model trusts plain language more than rule-blocks
- Spatial logic is preserved by writing positionally ("standing alone in the center of the room," "in the deeper background camera-left") instead of numerically

**What the register sounds like:**

> "A cinematic anamorphic still photograph captured handheld on a real cinema set — a Dutch-tilted intimate over-the-shoulder hero composition of a young Korean man standing alone in a dim converted private garage lounge at pre-dawn, the entire frame tilted at approximately 4 degrees Dutch angle camera-left low giving the composition a quietly off-kilter held-breath feel, the camera positioned right behind him at shoulder height in a waist-up framing showing his back, shoulders, and the back of his head filling the foreground with the wall-mounted television playing the live broadcast visible past his right shoulder in the mid-ground."

That opening sentence does the work of Blocks 1 and 2 in one continuous breath, with the camera position, the framing, the Dutch tilt, the subject placement, and the mood all woven together.

---

### THE FIVE-PARAGRAPH PROSE STRUCTURE (LOCKED)

Every Mode 3 prompt is composed as five paragraphs in this order. Paragraphs are not labeled in the output — they flow as continuous prose for the model.

**Paragraph 1 — Opening shot description.** One long sentence that establishes: the medium ("a cinematic anamorphic still photograph"), the framing register ("Dutch-tilted intimate hero composition"), the subject identification at high level ("a young Korean man standing in a dim converted private garage lounge at pre-dawn"), the camera position and angle in prose ("the camera positioned right behind him at shoulder height in a waist-up framing"), and the mood/intent ("quietly off-kilter held-breath feel"). This is the spine. Everything that follows hangs from this opening.

**Paragraph 2 — Character block.** Describes the character(s) in confident observational prose. Identity markers pulled from the attached reference written as visible facts in the frame ("dark layered mid-length tousled fringe falling across the back of his head, double small silver hoop earrings on each ear lobe catching faint warm spill, warm fair matte Korean skin"). Pose, attention, and held props woven in naturally ("a small black television remote held loosely in his right hand at his side... his head perfectly motionless, his eyes locked on the screen ahead of him").

**Paragraph 3 — World/environment block.** Describes the location as ambience and atmosphere, not architecture. The space's register — converted garage at pre-dawn, dawn cliffside, neon parking garage — matters more than counting structural elements. Anchor the world to the attached reference ("the converted garage lounge at pre-dawn carrying from the attached world reference"). Background subjects (a car silhouette in deep BG, a second character in the alcove) get positional language ("in the deeper background camera-left") not coordinates.

**Paragraph 4 — Subject anchor block.** Whatever the focal anchor of the shot is — the TV broadcast playing on the wall, the second car in BG, the dawn whisper on the horizon — gets its own paragraph. This is where any specific content (broadcast graphics, decals, signage, environmental detail) is described. If the shot has no focal anchor beyond the character, this paragraph folds into Paragraph 3.

**Paragraph 5 — Camera spec + finish.** Full cinema look in one continuous descriptive paragraph: capture register, lens character, diffusion/filtration look, film-stock rendition, grain register, grade, color cast, optical character (anamorphic oval bokeh, organic handheld breath, edge falloff, soft diffusion bloom if relevant) — all in plain-language look terms, never brand or model names — and the closing realism clause ("Real photographic frame captured on a real cinema camera, real anamorphic lens, real cotton tee, real human subject, real concrete and haze — no CGI, no rendered look, no digital cleanliness, no plastic surfaces, no AI smoothness, no skin smoothing, no glow, no halation bloom that reads as artificial, no glossy highlights").

The closing realism clause is mandatory. The list of "no X, no Y, no Z" at the very end is a load-bearing element — it tells the model what NOT to lean toward, and it does so AFTER all the positive description, where the model handles it as a quality filter rather than a conflicting instruction.

---

### KEY WRITING RULES FOR THE PROSE REGISTER

1. **No labeled blocks in output.** Never write "Block 1," "PARAGRAPH 2," "CRITICAL LIGHTING RULE," or any structural label in the prompt body. The structure is invisible — it lives in the writing order.

2. **No coordinate notation in the prompt body.** No `X: 38–62% / Y: 12–95%`. Replace with positional prose: "centered in the room," "in the deeper background camera-left," "filling the foreground," "anchored upper-left of the broadcast."

3. **No CRITICAL/IMPORTANT/MUST rules.** No "the cool wash MUST NOT catch the back wall." Replace with descriptive prose about what IS happening: "the cool broadcast wash catching only the immediate floor patch around his feet and a soft cool rim on his shoulders."

4. **No explicit negations as instructions.** Don't write "NO long sleeves, NOT factory tank-top construction." Write what IS there: "the sleeves cut off cleanly at the shoulder seam with raw unfinished armholes." The end-of-prompt realism clause is the ONLY place negations appear, and only as quality filters (no CGI, no plastic, no AI smoothness).

5. **References do the geometry work.** When the user attaches a world plate, write "carrying identically from the attached world reference" — don't re-enumerate the room geometry. The reference IS the geometry.

6. **References do the identity work.** When the user attaches a character reference sheet, write "carrying identically from the attached character reference" — don't re-describe every facial feature in the prompt. The reference IS the identity.

7. **The prompt narrates THE MOMENT.** What is the character doing right now? What is the camera doing right now? What is the light doing right now? That's the prompt's job. Continuity (room geometry, character identity, broadcast content) is reference work.

8. **The closing realism clause is non-negotiable.** Every Mode 3 prompt ends with the full cinema stack paragraph + the "Real photographic frame... no CGI, no plastic, no AI" close-out. This replaces the old locked tag block.

9. **The cinema mode register (M1/M2/M3/M4/M5) is invoked by DESCRIBING the actual look in plain language** in Paragraph 5 — not by writing "M1 Narrative" as a tag, and never by naming camera/lens/stock brands. Example: "Captured with a wide-latitude cinema look and a vintage 55mm-equivalent 2x anamorphic character at a wide aperture — oval bokeh, gentle horizontal squeeze, soft frame-edge falloff, a light diffusion bloom lifting highlights into a soft halation, color-negative daylight film rendition pushed slightly, with fine 35mm grain, in an M1 cinematic narrative register." The M-tag appears as a brief identifier at the end of the description, not as a standalone label.

10. **Do not write aspect ratios into the prompt** — the user sets aspect in the Higgsfield UI (typically 21:9 or 2.39:1 for cinematic plates).

---

### CANONICAL MODE 3 PROMPT — REFERENCE EXAMPLE

<!-- STUDIO-LOCAL BEGIN: upstream carries the canonical Mode 3 example and a deprecated OLD COORDINATE GRAMMAR section inline; the studio extracts the example verbatim to `references/mode3-example.md` and drops the deprecated section, keeping its still-live translation table above. --> The locked-register canonical example lives in `references/mode3-example.md` — read it before composing any Mode 3 prompt; every future Mode 3 prompt is written in that voice. <!-- STUDIO-LOCAL END -->

---

## MODE 4 — GPT Image 2 DETAIL FACE SHOT (HIGGSFIELD GPT Image 2)

**When to use:** Only when the user explicitly asks for a chest-up portrait, face detail shot, or close-up where face/skin/eye fidelity matters most. Never suggested proactively for any other shot type.

**Gating behavior:**
- Wait for the user to ask for a detail/face/chest-up shot.
- Then ask: "want to run this on Higgsfield GPT Image 2 for the higher-fidelity face read? heads-up — GPT Image 2 uses more Higgsfield credits than Banana Pro." (Mention the credit cost only the first time per conversation. After that, just confirm "want this on GPT Image 2?")
- Wait for the green light. Then run the standard pre-prompt confirmation. Then deliver the prompt.

**Goal:** Maximum face fidelity. Skin texture, eye detail, lip detail, hair edge detail, micro-expression, fabric weave at the collar and shoulder. The character stays locked from existing references — GPT Image 2 just reads it sharper.

**Frame and composition:**
- Framing: chest-up, shoulders-up, or face-only (forehead to collarbone)
<!-- STUDIO-LOCAL BEGIN: upstream lights Mode 4 with classical beauty lighting; the studio resolves it to the locked flat shadowless grade so every character-work mode closes the same way. -->
- Background: 18% neutral gray seamless studio, flat (locked default, matches base references) — white seamless only on explicit request, and flatness survives the swap
- Lighting: **Flat and shadowless** (locked flat grade, matching every other character-work mode) — huge frontal source at camera position, matched equal fill left/right/above/below, no key side, no shadow side, no rim light, no hair light, no kicker, no cast shadow
<!-- STUDIO-LOCAL END -->
- Do not write aspect ratios into the prompt — the user sets aspect in the Higgsfield UI (typically 4:5 or 1:1 for face/chest-up).

<!-- STUDIO-LOCAL BEGIN: same flat-grade resolution inside the prompt body — upstream's classical beauty-lighting and moody-backdrop language is replaced by the LOCKED FLAT GRADE, and a moodier register is routed to Mode 3 instead. The moody-backdrop alternative is struck from the composition bullet above as well, so the locked flat grade is the only in-mode background and the Mode 3 route below is the sole path to a moodier register. -->
**Canonical Mode 4 (GPT Image 2) prompt structure:**

```
[Visual descriptor of the character — hair, makeup, wardrobe visible in frame from the chest up, jewelry visible at collar and ears, eye color and detail, lip detail, skin finish]. [Pose direction — head angle, shoulder angle, expression register].

Background is an even 18% neutral gray seamless, completely flat — one single uniform value corner to corner, no seam line, no gradient, no hotspot, no vignette. Relight from scratch overriding any reference lighting: completely flat shadowless illumination — one enormous soft frontal source at camera position with matched equal fill from camera-left, camera-right, above, and below, so both sides of the face read at exactly the same brightness. No key-and-fill ratio, no modelling, no shadow side, no rim light, no hair light, no kicker, no specular hotspot. Zero shadow cast onto the background. [Framing — chest-up portrait / shoulders-up / face-only forehead-to-collarbone].

Extreme face fidelity. Real skin texture with visible pores, fine peach fuzz catching light along the jawline and upper lip, subtle subsurface scattering on the nose bridge cheeks and ears, micro-expression detail in the eyes and mouth corners, individual lash detail, real moisture and reflection in the iris with visible iris pattern, real lip texture with subtle natural lip lines, hair rendered strand by strand at the hairline with visible baby hairs and flyaways, fabric weave visible at the collar and shoulder. Skin renders at its true natural skin tone, warmth preserved and natural against the neutral gray, never pale or washed-out or cool-shifted by the background. Photographed on a 50mm prime, even sharpness, soft natural film grain. Photographed not generated.

[Gray is the locked default — use the flat close above. If the user explicitly asks for a moodier cinematic backdrop instead of the flat character-work default, that request moves the shot into Mode 3 territory — confirm which register the user wants before switching.]
```
<!-- STUDIO-LOCAL END -->

**Why GPT Image 2 for these shots:** Banana Pro is excellent for full-body, multi-panel, and scene work. GPT Image 2 has a stronger read on micro-detail at face-and-shoulders range — pores, lash separation, iris pattern, lip texture, hair strand definition at the hairline. For any shot where the face is the entire point of the image, GPT Image 2 earns the extra credits.

---

## MODE 5 — OUTFIT REPLACEMENT (BANANA PRO TWO-REFERENCE SWAP)

**When to use:** When the user wants to take an outfit and pose from one image and apply it to a different character. The outfit reference image has the wardrobe, styling, footwear, accessories, and body pose locked in. The character reference image has the face, bone structure, body type, skin tone, and hair locked in. The output combines them — the character from the second image now wears the outfit and holds the pose from the first image.

Trigger phrases include: "outfit replacement," "outfit swap," "put [character] in this outfit," "swap the face," "put this character in that fit," "replace the model with [character] wearing [outfit]," or any request that involves combining a wardrobe/pose reference with a separate character reference.

<!-- STUDIO-LOCAL BEGIN: upstream fixes Mode 5 to `@image1` / `@image2` numbering; the studio uses user-assigned semantic element tags (e.g. `@outfit_ref`, `@sol_ref`) to match the element-tag grammar shared with `cinema-director`. -->
**Goal:** Maximum identity transfer of the character (from the character-reference tag) onto the outfit and pose (from the outfit-reference tag) with zero alteration to either side — the outfit stays exactly as shown, the character's identity stays exactly as shown, only the body underneath the outfit changes to match the new character.

**Reference tagging (CRITICAL — element tags, not `@imageN` numbering):** Ask the user to give each uploaded reference a short semantic element tag of their own choosing — e.g. `@outfit_ref` and `@character_ref`, or project-specific tags like `@sol_ref`. This replaces the old fixed `@image1`/`@image2` numbering. Once tagged:
- **outfit/pose tag** — the image containing the outfit, styling, footwear, accessories, and pose to keep
- **character tag** — the image containing the face, bone structure, body type, skin tone, and hair to apply

Confirm the mapping with the user before writing the prompt. The prompt is written around whichever tags the user assigned — do not silently rename them, and do not swap which tag maps to which role.

**Pre-prompt confirmation rule applies.** Even though the prompt itself is short and locked, the user should confirm:
- Which reference is the outfit/pose source, and its element tag
- Which reference is the character/identity source, and its element tag
- That both references are uploaded and visible in chat

Use the standard pre-prompt check format — references first (with their tags), then the two roles, then run.
<!-- STUDIO-LOCAL END -->

<!-- STUDIO-LOCAL BEGIN: same element-tag substitution inside the locked prompt — the prompt structure is upstream's and stays locked; only the reference tags are variable, filled in from whatever the user named each upload. -->
**Canonical Mode 5 prompt (LOCKED structure — element tags are the only variable):**

```
Replace the character in [outfit-reference tag] with the character in [character-reference tag]. Keep the outfit and pose from [outfit-reference tag] exactly. Match the face, bone structure, body type, skin tone, and hair from [character-reference tag]. Clean mid-gray seamless studio background, even neutral mid-gray with no seam line, soft large-source studio lighting, skin and outfit rendering at their true natural tone against the neutral gray, natural film grain, full body framing.
```

**Why this prompt is locked:** Mode 5 does not use the cinema stack. The two reference images carry the photographic register on their own — adding texture stack language on top of a swap operation creates conflicting instructions and degrades the identity transfer. The lean prompt structure is the entire point of this mode — only the element tags themselves vary, filled in from whatever the user named each reference. Trust the references.

**Background and lighting language is also locked.** The locked prompt outputs to a clean mid-gray seamless studio with soft large-source lighting — this is the canonical neutral output for character/outfit reference assets (white seamless only if the user explicitly asks for a white card). If the user wants the swap output dropped into a different environment, that becomes a Mode 3 scene plate built on top of the Mode 5 output (run Mode 5 first to produce the locked base, then Mode 3 to place it in the scene).

**Per-character or per-IP modifiers:** None. Mode 5 is character-and-IP-agnostic. The prompt does not name characters, does not specify nationality, does not adjust language per group or project. The two reference images carry all of the identity load. The skill ships the locked prompt structure unchanged regardless of what the character or outfit is — only the element tags change.
<!-- STUDIO-LOCAL END -->

**What Mode 5 is NOT for:**
- Building a new outfit from scratch on a locked character → use Mode 1A (Banana Pro full styling) or Mode 1B (Soul Cinema two-step)
- Generating multiple angles of a locked character in a locked outfit → use Mode 2A (3-panel, default) or Mode 2B (6-panel, explicit request only)
- Placing a character in a cinematic environment → use Mode 3A
- Detail face shots → use Mode 4 (GPT Image 2)

Mode 5 is the single-purpose tool for: *here is an outfit on a model I don't care about, and here is the character I do care about, give me the character in that outfit.*

---

## UNIVERSAL PROMPT RULES (ALL MODES)

<!-- STUDIO-LOCAL BEGIN: flags the rule 3 carve-out the studio adds and upstream does not have (Mode 5's element tags). --> These apply to every prompt this skill produces — the sole carve-out is noted in rule 3: <!-- STUDIO-LOCAL END -->

1. **No character names in prompt output.** Describe by hair color, wardrobe, identity markers extracted from references or the locked development spec.
2. <!-- STUDIO-LOCAL BEGIN: upstream drop 3 inverts this rule to allow real brand names by default — formally rejected in PR #261; the studio holds the prohibition and points at the authorised override. --> **No unauthorised real brand names in prompt output.** Generic visual descriptors only. *Override:* see the Brand name rule under READING REFERENCE IMAGES for the authorised-brand exception and its conditions. <!-- STUDIO-LOCAL END -->
3. <!-- STUDIO-LOCAL BEGIN: upstream bans all `@image` tags outright; the studio narrows the ban to fixed `@imageN` numbering and carves out Mode 5's user-assigned semantic element tags. --> **No fixed `@image1`/`@image2` numbering or `<<<image_n>>>` placeholders.** Image attachment happens in the Higgsfield UI directly. The prompt is text-only. *Sole carve-out:* Mode 5's locked prompt structure is written around reference element tags by design (e.g. `@outfit_ref` / `@character_ref`, or whatever short semantic tag the user assigns each upload) and keeps them (see MODE 5 — the locked structure is not modified, only the tags are filled in). <!-- STUDIO-LOCAL END -->
4. **No internal production context.** No "carried through the world," no "matching the previous scene." Every prompt is standalone and self-contained.
5. **Pure visual description only.** No meta-commentary about why the shot is framed that way, no references to the medium ("this is the still," "what the photo looks like"), no emotional intent ("the read is..."). Every word describes a visible thing in the frame.
6. **No teeth-showing smiles** unless the user explicitly requests one. Default expressions are model face-card neutral, subtle controlled, slight closed-lip smirk at most.
7. **No negative prompts.** This skill does not output negative prompt blocks. Higgsfield workflow doesn't use them.
8. <!-- STUDIO-LOCAL BEGIN: upstream closes Modes 0/1/2/4/5 with the full cinema stack; the studio closes character work with the LOCKED FLAT GRADE instead — the stack's key-wrap and anatomical shadow-falloff language fights the flat plate. --> **LOCKED FLAT GRADE baked in for Modes 0, 1, 2A/2B, 4, 5.** The 18% gray flat, shadowless grade closes every Mode 0, 1, 2A/2B, and 4 prompt (with Step 1B.1 outfit reference using the lighter close documented in that section, and Mode 5 using its own locked lean prompt). The full cinema stack never closes a character plate or sheet — its key-wrap and anatomical shadow-falloff language fights the flat grade. Mode 3 is the exception — see rule 9. <!-- STUDIO-LOCAL END -->
9. **Mode 3 uses the cinema-prose closing paragraph in place of the cinema stack AND locked tag block.** Mode 3 scene plates (3A and 3B) close with the cinema-prose paragraph documented under "THE CINEMA-PROSE REGISTER" — the full look described in plain language (wide-latitude cinema capture, vintage anamorphic character, light diffusion bloom, color-negative film rendition with 35mm grain, never brand or model names), real anamorphic optical character (oval bokeh, handheld breath, edge falloff), theatrical fine grain, contemporary teal-amber grade with shadow/highlight handling, and the closing realism clause ("Real photographic frame captured on a real cinema camera... no CGI, no plastic, no AI smoothness, no skin smoothing"). This closing paragraph replaces the cinema stack AND the old locked tag block for Mode 3. The old tag block remains documented as a deprecated fallback only.
10. **Single fenced code block on output.** Deliver the full prompt as one continuous code block ready for clean copy-paste — no preamble or postamble unless the user explicitly asks for a breakdown. (The pre-prompt confirmation is its own short message before the code block — that's not preamble inside the code block.)
11. **Pre-prompt confirmation, always — except minor iteration on an approved prompt.** Every full prompt is preceded by a bulleted "here's what I'm about to prompt, sound good?" check. **References listed first**, then character, outfit, backdrop/environment, framing. Wait for the green light. Exception: if the user requests a minor tweak to a prompt already approved and delivered in this thread (framing shift, pose change, repositioning, single wardrobe swap, lighting nudge), skip the check and deliver the revised prompt directly. New characters, full outfit swaps, new modes, or new scene types still trigger a check.
12. **Flat grade on every character plate and sheet — no exceptions.** Every Mode 0, 1, 2A/2B, 4, and 5 prompt closes with the LOCKED FLAT GRADE: flat 18% gray backdrop (one uniform value, no gradient, no falloff), shadowless frontal illumination with matched fill on all sides (no key side, no shadow side, no rim, no hair light, no kicker), and zero cast shadow (none on the background, no contact shadow under the feet or hem). Never write a key direction, a shadow triangle, a nose or under-chin shadow, or a floor shadow into a character plate. Mode 3 scene plates are the ONLY place directional cinematic lighting lives.
13. **No aspect ratios in prompt output.** Never write "3:4 vertical aspect ratio," "16:9 horizontal," "21:9 cinematic," "4:5 portrait," "2.39:1," or any other ratio spec inside the prompt body. The user sets aspect ratio in the Higgsfield UI directly. The prompt describes framing in plain language only ("full body," "chest-up portrait," "wide establishing shot," "medium two-shot") — never with a numerical ratio.

---

## INVENTORY EXTRACTION CHECKLIST (run silently before composing)

Before writing the final prompt, silently catalog:

- [ ] Mode selected (0 face lock / 1 single-image outfit / 2A three-panel sheet / 2B six-panel sheet / 3A character scene / 3B environment plate / 4 GPT Image 2 / 5 outfit replacement) and rationale
- [ ] Every uploaded reference image identified and listed by short visual descriptor (this becomes the first bullet of the pre-prompt check)
- [ ] If Mode 0: text spec for the new character is locked and approved, tool fork has been presented (Banana Pro / GPT Image 2 / Soul Cinema), user has picked, and the locked baseline wardrobe (plain black camisole for women, plain black ribbed tank for men) is included in the prompt. If Soul Cinema picked, running Step 0.1 (Soul Cinema face plate) before Step 0.2 (Banana Pro 3:4 headshot).
- [ ] If Mode 1: a Mode 0 face lock exists for the character (if new), OR a locked character reference exists (if existing)
- [ ] If a character sheet was requested with no format named: defaulting to Mode 2A (3-panel), not offering the 6-panel
- [ ] If Mode 2A: left-panel headless variant picked correctly from the garment (Variant A ghost-mannequin hollow for structured necklines — tees, tanks, collars, hoods, keyholes; Variant B clean neck cut for dresses, halters, strapless, spaghetti straps, plunging or scooped necklines). Full headroom preserved — the head is removed from the body, not cropped by the frame. Hair removed with the head. Right panel is tight CHEST-UP, not waist-up. Skin-tone consistency clause present across all panels.
- [ ] If Mode 2B (6-panel): user explicitly asked for it, the resolution warning was given once, and the user said go
- [ ] If Mode 2A or 2B: a Mode 1 base outfit reference exists and is approved (if not, stop and build the base first)
- [ ] If Mode 4: user explicitly asked for face/chest-up and confirmed GPT Image 2
- [ ] <!-- STUDIO-LOCAL BEGIN: Mode 5 checklist row rewritten around user-assigned element tags in place of upstream's fixed `@image1`/`@image2` attachment order. --> If Mode 5: two reference images uploaded, each given a short semantic element tag by the user (e.g. `@outfit_ref` / `@character_ref`) — outfit/pose role and character/identity role confirmed against those tags, not against fixed `@image1`/`@image2` numbering <!-- STUDIO-LOCAL END -->
- [ ] Every character described by visual markers only (hair, makeup, wardrobe, jewelry, body markers, pose, expression)
- [ ] If Mode 3: environment described as ambience (not architectural enumeration) — world plate reference carries geometry
- [ ] If Mode 3: matching cinema mode identified (M1/M2/M3/M4/M5) and woven into Paragraph 5 camera spec
- [ ] If Mode 3: subject placed in frame with positional prose (not X/Y coordinate notation) — rule-of-thirds anchored, not dead-center unless explicitly motivated
- [ ] If Mode 3: resolution-aware detail check passed — every visible detail is something the camera at this distance, lens, motion, and lighting can physically resolve; anything the camera couldn't see is dropped
- [ ] If Mode 3: prompt follows the FIVE-PARAGRAPH PROSE STRUCTURE (Opening shot / Character / World / Subject anchor / Camera spec + finish) — no labeled blocks in output
- [ ] If Mode 3: closing realism clause is in place (full camera package + M-mode + "Real photographic frame... no CGI, no plastic, no AI" quality filter)
- [ ] Pose, body angle, expression register chosen
<!-- STUDIO-LOCAL BEGIN: brand row holds the studio prohibition (upstream drop 3 permits brand names by default — formally rejected in PR #261); flat-grade row is scoped to the studio 2A/2B renumber with Mode 5's locked lean prompt called out separately. -->
- [ ] No names, no brands, no internal context, no meta-commentary
- [ ] LOCKED FLAT GRADE will close the prompt (Modes 0, 1, 2A/2B, 4) — flat uniform 18% gray, shadowless matched-fill light, zero cast shadow, stated per-panel on sheets; Mode 5 using its own locked lean prompt; Mode 3 using the cinema-prose closing paragraph instead and is the only mode with directional light
<!-- STUDIO-LOCAL END -->
- [ ] Pre-prompt confirmation delivered and confirmed — references listed FIRST in the bullet list

If anything needed for composition is missing from the user input, ask before writing.

---

## WHEN THE USER ASKS FOR A PROMPT

The flow is always: **confirm character → confirm what's about to be prompted → deliver the prompt in a fenced code block**.

The user pastes the code block straight into Higgsfield. Tool routing: Banana Pro / Nano Banana 2 for Mode 0 Step 0.A (single-pass default), Mode 0 Step 0.2 (Soul Cinema path lock), Modes 1A, 2A, 2B, 3, 5; GPT Image 2 for Mode 0 Step 0.B (highest fidelity single-pass) and Mode 4; Soul Cinema for Mode 0 Step 0.1 (iteration path) and Mode 1B. The user attaches the same reference images (or selects them from their Higgsfield character/environment library) inside the Higgsfield UI. The skill's job ends at the code block.

If the user requests multiple shots in one ask, deliver each in its own code block, sequentially numbered or labeled — but still run the pre-prompt confirmation once before delivering the batch.

---

<!-- STUDIO-LOCAL BEGIN: net-new studio section — upstream has no world-bible skill and no handoff; this cross-links the `cinema-world-bible` skill owned by the Cinema Showrunner. -->
## OPTIONAL HANDOFF — CINEMA WORLD BIBLE

If the user is working within a larger production pipeline — building a character bible, indexing reference assets, or tracking shot-to-shot continuity across a sequence — that upstream work is owned by the `cinema-world-bible` skill (owned by the Cinema Showrunner). That skill produces the shot spec, character bible, and reference-library index that this skill executes against. When a shot spec is present, the reference list and wardrobe state should follow the world-bible's reference-library index exactly. When operating standalone (no shot spec provided), proceed as normal.
<!-- STUDIO-LOCAL END -->

---

<!-- STUDIO-LOCAL BEGIN: net-new studio section — upstream ships no equivalent; records the QA gate and humaniser pass that apply to surrounding prose but never to the prompt code block itself. -->
## STUDIO CONVENTIONS

In this studio, written deliverables (briefs, shot specs, world bibles, integration documents) pass a QA gate (QAComplianceReviewer) and a humaniser pass before release. This applies to surrounding prose and structured documents, not to the prompt code-block output itself — the prompt grammar inside the fenced code block is verbatim copy-paste material and must never be humanised or reworded.
<!-- STUDIO-LOCAL END -->
