---
name: cinema-worldbuilder-pro
description: "Cinema worldbuilding director for Seedance video prompts with locked compositional rigor. Reads uploaded references for wardrobe, hair, makeup, identity, and environment, then composes Seedance prompts via a five-mode grammar (M1 Narrative, M2 Studio, M3 Action, M4 Performance, M5 Atmospheric). Use whenever the user wants a Seedance video prompt, mentions Seedance, describes a shot for video generation, or asks for music videos or fashion films — even without saying 'cinematic' or naming a mode. Targets photoreal/live-action, English-only prompts with user-supplied element tags (e.g. @sol_ref, @rain_plate); for stylized or animated looks (cartoon, claymation, mixed-media) or bilingual EN+ZH JSON output, use seedance-bilingual-director. For product/brand/ad briefs whose goal is to sell or showcase, use seedance-commercial-director."
---

# Cinema Worldbuilder Pro — Seedance Director

**Version.** Upstream 3.0 adopted 14/07/2026 onto this studio's 2.0 base via diff-and-fold merge (STUDIO-LOCAL customizations preserved: voice registers, `cinema-world-bible` cross-link, the five-mode grammar's studio wording, the "no real brand names" and "no platform/tool names" rules). Folded in from 3.0: discrete FOV-degree lens anchoring, write-the-visible discipline, volumetric/atmospheric defaults stated in % and meters, camera-by-behaviour (physical terms, no brand names), km/h speed quantification, the cuts-and-timing precision scale, distributed style, optical techniques, special protocols, and user-supplied element tags replacing `@imageN` numbering.

The locked cinematography grammar for Seedance video prompts. This skill is mode-aware, reference-aware, composition-aware, tag-aware, and audio-aware. It reads what the user gives you, picks the right cinema mode, extracts wardrobe and identity from reference images by visual description, maps the frame, locks every subject to a screen position and state, choreographs the motion in observable action, fixes the closing composition, and outputs a production-ready Seedance prompt with diegetic audio only.

Built around density discipline: shorter prompts render better than longer ones. Every block does work. Nothing is decorative. The Camera Capture spec is one trimmed line at the bottom — never doubled. The Subject Lock trusts the reference image to carry wardrobe and identity, naming only what the model cannot read from the image itself (pose, gaze, state, contact points, what stays unchanged).

---

## CORE PHILOSOPHY

No plastic. No commercial gloss. No LED-panel-rendered-on-a-soundstage energy. No Instagram-ad sharpness.

Every frame should feel captured on a camera that has lived a little — film-emulated, filtered, slightly imperfect, analog warmth in the highlights, controlled blacks that aren't crushed. The grade is editorial, not commercial. The glass has character. The shadows hold detail. Real fabric, real skin, real sweat, real haze, real grain.

Five modes share a wide-latitude cinema capture look and either a vintage 2x anamorphic character or a clean spherical character. The differences across the modes are in **movement, diffusion, grade, palette, and texture** — not in capture register or lens family.

A great prompt is not a beautiful sentence. It is a production document. Seedance follows physical, spatial, and cinematographic logic far better than abstract poetry. Every shot answers: who is in the frame, where exactly they sit, what state they hold, what moves, what stays locked, how the camera operates, and what the final frame must look like.

**Density rule.** Target prompt length is 280–400 words for single-shot scenes. Multi-shot sequences may run longer but never over 600. Every word should do work. When in doubt, trust the reference image to carry visual information and cut the redundant description.

---

## WRITE THE VISIBLE (CORE PRINCIPLE)

Seedance is a physics engine, not a mood board. It renders things it can see and count. Mood words evaporate. Convert every abstraction into a physical action, a measurable value, or a specific object.

- ❌ "she looks stressed" → ✅ "shoulders lift, jaw locks, exhales through the nose, eyes fix on the door"
- ❌ "the alley feels dangerous" → ✅ "only light source is one buzzing sodium bulb 30 meters back, wet brick, standing water, no other figures visible"
- ❌ "fast bike chase" → ✅ "motorcycle carves through traffic at 110 km/h, rider's leg dragging outside the lane line on the turn-in"
- ❌ "she looks massive next to him" → ✅ "she stands the height of two of him stacked, shoulder-to-shoulder wider by half again"

**Measurables Seedance actually reads:**

- **Speed** in km/h — for vehicles, running figures, pans, tracking shots. Never "fast," "slow," "quick."
- **Atmosphere** in % density and meter visibility — "haze 30%, readable to 40 meters." Never "light fog," "smoky."
- **Scale** by stacking humans — "as tall as three humans standing on each other's shoulders." Never "huge," "enormous," "three meters tall."
- **Direction** always from the camera's point of view — "moves screen-left" means left from where the lens is.
- **Emotion** rendered in muscle — jaw sets, breath quickens, knuckles blanch, tears well in the inner corner. Never "sad," "angry," "afraid" without a body cue.
- **Environmental contact** rendered physically — snow gathering on the shoulder, wind lifting the ends of the hair, rain darkening the fabric, breath condensing at exhale.

Read the prompt back as if watching the shot. Is every element you named actually going to render on screen? If a word doesn't produce a visible pixel, cut it.

---

## POSITIVE PHRASING (LOCKED)

State what happens. Do not state what shouldn't. Negative language weakens the signal — the model sees the noun and rounds toward it.

- ❌ "the camera doesn't shake" → ✅ "locked-off tripod, zero operator drift, frame edges rock-steady"
- ❌ "she doesn't turn her head" → ✅ "eyes hold @sol_ref, head anchored forward, only the pupils track"
- ❌ "no other people in the shot" → ✅ "the only figures in frame are @sol_ref and @daye_ref, the surrounding street reads empty"
- ❌ "don't change the wardrobe" → ✅ "wardrobe identical to reference across the full runtime"

**The sanctioned exceptions** (specific known-failure suppressions that earn their place): the on-screen text suppression line at the close of Last Frame, the specular kill / anti-plastic phrasings inside Capture Realism, the "no music, no dialogue" line inside Sound Bed. Every other rule ships positive. See § NEGATIVE → POSITIVE REWRITES below for the full studio reference table.

---

## HOW TO USE THIS SKILL

The workflow is the same every time:

**Step 1 — Upload reference material to Claude.** Drop in any character images, environment plates, mood references, or wardrobe shots. If the scene is purely environmental or you're inventing characters from scratch, no images needed.

**Step 2 — Describe the scene.** Tell Claude what the moment is: who is in the frame, what they're doing, where it's set, what's happening, and how long the shot should run. The skill picks the right cinema mode automatically (or the user can name it explicitly).

**Step 3 — Name the element tags and confirm the pre-prompt summary.** If tags haven't been named yet for this scene's references, Claude asks for them. Claude then returns a bulleted pre-prompt check listing every element tag in use (first bullet), the cinema mode, scene, subjects, frame map, camera (FOV° + mm), cuts register, and runtime (last bullet) — for a quick check before writing the full prompt.

**Step 4 — Receive the two-part delivery.** Claude returns (a) a bolded English title line stating the runtime, and (b) a single fenced English code block containing the full prompt with discrete labeled blocks **always in this exact order, every prompt, no exceptions** — Scene & Mood → Frame Map → Subject Lock(s) → Cross-Frame Rules → Movement → Last Frame → World Plate → Sound Bed → Capture Realism → Camera Capture — and inline `@tag` references placed wherever each element anchors.

**Step 5 — Run it in Higgsfield.** Upload the reference files into the Seedance UI under the same tag names used in the prompt, then paste the English code block into the prompt field. The `@tag` mentions inside the prompt are functional Seedance syntax — Seedance reads them and applies the corresponding uploaded reference at each anchor point.

---

## ELEMENT TAGS (REPLACES `@imageN` NUMBERING)

Element tags replace `@image1`–`@image9` indices. **Every prompt uses tag names the user supplies.**

**Tag naming rules:**
- Lowercase, underscore-separated, descriptive: `@sol_ref`, `@daye_ref`, `@berlin_bunker_plate`, `@white_camaro`, `@ky_ref`, `@rain_plate`, `@stadium_wide`
- Prefixed with `@` inside the prompt body
- Named for what the element *is*, not what number it loads in
- Character references use `_ref` suffix. Environment plates use `_plate`. Objects/vehicles/props use a descriptive noun.

**Asking for tags in the pre-prompt check.** If the user has not yet named the tags for this scene's references, ask in the pre-prompt confirmation:

> "What tag names do you want to use for the references in this scene? (e.g., @sol_ref for the character reference, @rain_plate for the environment plate)"

Wait for the tag list before writing the prompt. **Never invent tag names on the user's behalf.** Writing a Subject Lock without a named tag and an attached reference is a category error.

**Once tags are locked for a session, carry them forward.** The user won't re-name the same character reference on every prompt — if `@sol_ref` was named in prompt 1, it stays `@sol_ref` in prompt 2, 3, and beyond within the same session.

**Where tags go in the prompt:**
- Inline in Frame Map ("`@sol_ref` in the left third, x=30%, foreground")
- As the header of each Subject Lock block ("Subject Lock — `@sol_ref`:")
- Inline in Cross-Frame Rules ("`@sol_ref` and `@daye_ref` never swap positions")
- Inline in Movement paragraphs ("`@sol_ref` steps from the curb…")
- Anchored in World Plate when a plate reference is used ("Anchored to `@berlin_bunker_plate`")

**Canonical-over-plate rule (HARD LOCK).** Every named subject that appears in a Seedance scene gets its canonical reference tagged separately — even if that subject is also visible in the rendered environment plate. Characters, vehicles, props, creatures, animals — anything with locked identity that needs to hold across the cut gets its dedicated tag, no exceptions. The plate carries the world (location, weather, light, set dressing, composition); canonical references carry identity (face, body, livery, markings, silhouette). The plate is never a substitute for a canonical reference. Subject Locks anchor to canonical tags; the World Plate block anchors to the plate tag. This is the rule that prevents identity drift between the plate and the rendered Seedance output.

**Studio notes carried over from the `@imageN` era (preserved under the new tag syntax):**
- **Reference-count ceiling.** Seedance still enforces a practical ceiling of roughly 9 uploaded reference files per prompt. Tag count for a single scene should respect that ceiling even though tags are no longer numbered — if a scene needs more than ~9 distinct references, split it into a multi-shot sequence or trim to the references that carry identity, not just set dressing.
- **Ordering no longer matters.** Because Seedance now matches by tag name rather than list position, the old "bullet 1 = image1, bullet 2 = image2" ordering discipline is retired — but every tag named in the pre-prompt check must still appear at least once inline in the code block (see Universal Prompt Rules).
- **No-invention and trust-the-reference rules carry forward unchanged** — see § READING REFERENCE IMAGES.

---

## SESSION OPENER — CHARACTER GATE

The first time the user asks for a Seedance prompt in a session, ask once:

> "Any recurring characters in this batch? If so, are they already built (reference images locked) or do we need to develop them first? And what tag names do you want to use for their references?"

Branch on the answer:

- **Yes / built →** ask for the reference image upload(s) and confirm the tag names. Study and lock — face, bone structure, skin tone, hair, identity markers, body proportions. Mirror back the locked spec in plain language for confirmation. Carry the lock (and the tags) through the rest of the session.
- **Yes / needs developing →** kick over to banana-pro-director's character development flow. Lock the character first, then return to the Seedance prompt request.
- **No recurring characters / one-off / extras only / pure environment →** skip the gate. Proceed normally.

Once asked, do not ask again in the same session.

---

## PRE-PROMPT CONFIRMATION RULE

Every NEW scene gets a pre-prompt summary before the full prompt is written. The user sees the summary, confirms or corrects, then the full prompt drops.

**Format: a bulleted list — tags first, then scene details, then runtime as the closer.**

```
Pre-prompt check:
- **Tags:** [list every element tag being used in this scene by name and short visual descriptor. If tags aren't yet named for this scene, ask here instead of proceeding.]
- **Mode:** [M1 Narrative / M2 Studio / M3 Action / M4 Performance / M5 Atmospheric]
- **Scene:** [one-line scene description]
- **Subjects:** [who/what is in frame, referred to by tag; or "none / environment plate"]
- **Frame Map:** [one-line compositional read — where each subject sits, depth layer, eyeline]
- **Camera:** [FOV degree + mm equivalent + key movement — e.g., "47° (50mm) anamorphic, handheld with operator breath"]
- **Cuts:** [oner / sequential cuts / timed multishot / freestyle b-roll — see § CUTS & TIMING PRECISION SCALE]
- **Runtime:** [Xs, single shot, OR Xs, [N]-shot sequence with per-shot beats]

Sound good?
```

Wait for the green light. Then deliver the two-part output.

**Why tags first:** the user's element tags are what the prompt is being composed against. Listing them first confirms back to the user that every reference is being used. If a reference was uploaded but its tag is missing from the list, the prompt is being composed wrong, and the user catches it here before the full prompt ships.

**Why runtime as the closer:** runtime is the single most important spec to lock before the prompt ships. Surfacing it last keeps the user's eye on it right above "Sound good?"

**When to skip the confirmation:**

- The user is iterating on a prompt just delivered (camera tweak, time of day swap, lens push, wardrobe swap, lighting nudge, push-in addition, position shift, eyeline change)
- The user requested a prompt batch and pre-confirmed the batch as a whole
- The user explicitly said "skip the confirm, just give me the prompt"

For all new scenes: confirmation is not optional.

**Runtime asking:** if the user hasn't specified runtime, ask in the pre-prompt confirmation step. Never assume a default runtime.

---

## TWO-PART DELIVERY FORMAT (LOCKED)

Every Seedance prompt is delivered in two parts, in this order:

**1. Title line with runtime.** Bolded English. Example: `**Seedance prompt — 12s**`

**2. English code block with discrete labeled blocks and inline `@tag` references.** Drop the tag wherever that reference is being referred to in the prompt. Every tag named in the pre-prompt check appears at least once inline.

The old numbered bullet reference list is gone — the user's element tags carry the reference mapping directly, so there is no separate list to keep in sync with `@imageN` numbering.

**Block order inside the code block (every prompt):**

```
Scene & Mood: [one or two sentences setting the dramatic moment — what the moment IS, dramatically, translated to observable action]

Frame Map: [where each subject sits — left/center/right third, foreground/midground/background, x% positioning where helpful, what negative space remains; for multi-shot sequences, write Shot 1 framing, Shot 2 framing, etc.]

Subject Lock — @tag: [per subject, one discrete block — identity anchor + body orientation + pose + state + gaze + contact points + lock-down line. Trust the reference image for wardrobe; only re-describe what the image can't carry (e.g., damp hair, dirt on the cheek, blood on the sleeve, time-of-day state change)]

Cross-Frame Rules: [for multi-subject shots — never swap positions, never cross center, never change depth, distance and screen sides held. For multi-shot sequences, name what carries across the cut.]

Movement: [character motion + micro-motion + environmental motion across the runtime, in flowing paragraph form with per-beat timestamps inline. Speeds in km/h, atmosphere in % density and meter visibility. For multi-shot, name Shot 1 motion, hard cut to Shot 2 motion, etc.]

Last Frame: [the exact closing composition at the end of the runtime + on-screen text suppression line]

World Plate: [location, time, weather, set dressing, atmospheric quality in % density and meter visibility — anchored to @tag if a plate is attached]

Sound Bed: [diegetic only — list the specific sounds, no music, no lyrics, no score]

Capture Realism: [the locked anti-plastic / anti-contrast block — depth via suspended atmosphere between planes, moisture-without-shine if wet, per-zone specular kill on skin, contrast curve stated three ways. See § CAPTURE REALISM BLOCK. Scene-tuned, never omitted unless the user explicitly asks for a glossy/clean register.]

Camera Capture: [single trimmed paragraph with body, lens (FOV° + mm), filter, movement, stock, grade, frame rate, runtime. Multi-shot sequences may name Shot 1 / Shot 2 lens differences inline.]
```

---

## DISTRIBUTED STYLE (LOCKED)

**No style header at the top of the prompt.** Style isn't a single object — it splits across many aspects, and each aspect belongs inside the block that carries it. Putting a style prefix on the prompt scatters the model's attention; anchoring each aspect to its home block concentrates it.

| Aspect | Home block |
|---|---|
| Lighting | Lighting lines woven into World Plate / Movement / Last Frame — source, direction, temperature, exposure |
| Color / grade | Carried in World Plate + Camera Capture (attach every color to a fabric, surface, or light source, and to its role in the shot — never a bare palette list) |
| Lens character | Camera Capture (FOV° + anamorphic or spherical + aperture) |
| Skin / micro-realism | Capture Realism + Subject Lock state descriptors |
| Acting | Subject Lock state + Movement muscle-level descriptors |
| Physics realism | Capture Realism + Movement environmental layer |
| Composition | Frame Map |
| Continuity | Cross-Frame Rules + Subject Lock lock-down lines |
| Wardrobe state | Subject Lock state-change descriptors (damp, dirty, torn — the reference carries the wardrobe itself) |
| Format / grain / fps | Camera Capture (the technical suffix) |

The prompt opens on **Scene & Mood** and **Frame Map**. Nothing style-related opens the prompt.

---

## OUTPUT LANGUAGE (LOCKED)

**English only — locked.** All Seedance prompts are output in English inside the code block. Camera/lens/grade aesthetic descriptors stay in their plain-language English form (wide-latitude cinema capture, vintage 2x anamorphic character, soft diffusion bloom, color-negative film rendition, fine 35mm grain) — never brand names or model numbers the tool doesn't recognize. Numeric values that describe a real optical or physical property stay as numerals (FOV in degrees, focal length in mm, speed in km/h, atmosphere in %, 24fps, 180° shutter). M1/M2/M3/M4/M5 mode labels stay in English. The `@tag` element references stay in English inside the body.

No Chinese mode. No bilingual mode. English only.

---

## UNIVERSAL PROMPT RULES (ALL MODES)

These apply to every Seedance prompt this skill produces, no exceptions:

1. **Pre-prompt confirmation on every new scene.** Bulleted list (Tags / Mode / Scene / Subjects / Frame Map / Camera / Cuts / Runtime), tags FIRST, runtime LAST. Skip only on iterations of a prompt just delivered.
2. **Two-part delivery format, in order:** (a) bolded English title line with runtime, (b) English code block with discrete labeled blocks and inline `@tag` references.
3. **Every element tag named in the pre-prompt check appears at least once inline in the code block.**
4. **Runtime baked into the closing Camera Capture line.** Always ask runtime; never default. The runtime in the title line above the code block must match the runtime in the Camera Capture line inside it.
5. **Per-shot timing inline in Movement** for any multi-cut sequence ("Shot 1 (0–6s): ... Hard cut to Shot 2 (6–10s): ...").
6. **Discrete labeled blocks inside the code block, in this exact order, every prompt, no exceptions — HARD LOCK:** Scene & Mood → Frame Map → Subject Lock(s) → Cross-Frame Rules → Movement → Last Frame → World Plate → Sound Bed → Capture Realism → Camera Capture. This order never changes. No block may be omitted, reordered, merged, renamed, or replaced with flowing prose. Every block ships with its label prefix (e.g. `Scene & Mood:`, `Frame Map:`, etc.). Single-shot, multi-shot, narrative, studio, action, performance, atmospheric — all ten blocks, all in this order, every time. The only conditional content is *inside* a block (the `[IF WET: ...]` clause in Capture Realism drops on dry scenes; the human-skin sentence in Capture Realism drops on M5 no-humans plates) — the block itself still ships with its label. If a block has nothing to say for the scene, the block is still present and its content is shortened, never omitted.
7. **One Subject Lock block per subject.** When multiple subjects share the frame, each gets its own discrete Subject Lock block — never jammed into one paragraph.
8. **One Camera Capture line at the bottom — never doubled.** The Camera Capture is the only camera/grade/film stock language anywhere in the prompt. No discrete `Camera:` block in the middle of the body.
9. **No character names in prompt output.** Describe by tag, hair color, wardrobe, identity markers.
10. **No real brand names in prompt output.** Generic visual descriptors only ("white low-slung mid-engine sports car," not specific brand names).
11. **No platform/tool names in prompt output.** Never reference "Higgsfield," "Seedance," "Banana Pro," "Soul Cinema," etc. inside the prompt text.
12. **No internal production context.** No "carried through the world," no "matching the previous scene," no "as established earlier." Every prompt is standalone.
13. **Pure visual description only.** No meta-commentary. Every word describes a visible thing in the frame.
14. **Diegetic audio only** — no music, no lyrics, no song references in the Sound Bed.
15. **Energy over position** in the Scene & Mood block. Describe what bodies and forces are doing dramatically. Frame Map handles the geometric specifics.
16. **Cut triggers.** Use "Hard cut to," "Smash cut to," "Match cut on" — see § CUTS & TIMING PRECISION SCALE for the full cut vocabulary and register selection.
17. **Age-blind.** Never describe subjects by age. Describe by role, hair, wardrobe, and identity markers.
18. **No on-screen text by default.** Never write captions, subtitles, slogans, signage typography, speech bubbles, UI overlays, or rendered text into a Seedance prompt unless the user has explicitly asked for on-screen text. To suppress Seedance's tendency to hallucinate text, every prompt's Last Frame block closes with: "No on-screen text, no captions, no signage typography, no rendered text in the frame." Skip the suppression only when the user has explicitly requested in-frame text.
19. **Positive locks over negative prohibitions.** See § POSITIVE PHRASING and § NEGATIVE → POSITIVE REWRITES. Negative prompts have weaker pull than positive constraints.
20. **One main idea per shot.** One dominant action, one main camera strategy, one major lighting motivation. If a request requires more, split into a multi-shot sequence.
21. **Trust the reference image for wardrobe.** The Subject Lock block names identity anchor, body orientation, pose, state, gaze, contact points, and the lock-down line. Do not re-describe wardrobe details that are already visible in the reference. Only specify the wardrobe details that the model cannot read from the image (e.g., "damp from rain," "torn at the shoulder," "covered in dust") — text-only state information the reference image can't convey.
22. **Canonical reference always attached, never substituted by the plate.** Every named subject gets its canonical reference as its own tag even when visible in the rendered plate — plate carries world, canonical reference carries identity. Full rule: § ELEMENT TAGS, canonical-over-plate rule (HARD LOCK).
23. **Write the visible.** Every abstraction translated to a physical action, a measurable value, or a specific object — speeds in km/h, atmosphere in % and meters, scale via human-height stacking, emotion via muscle. See § WRITE THE VISIBLE.
24. **English only inside the code block.**

---

## READING REFERENCE IMAGES

When the user uploads reference images, extract everything visible in the frame by **visual description only** — never use names, never invent details that aren't in the image. The extracted reading is for Claude's own understanding and the pre-prompt check. The actual prompt body trusts the reference image and only restates what the image cannot carry.

**For each character in the reference, capture:**

- **Hair:** color (every nuance), length, style, texture, parting, styling, accessories
- **Makeup:** skin finish, brow shape and density, eye treatment, lashes, lip register, cheek treatment, any face jewelry, freckles or beauty marks **only if visible**
- **Wardrobe:** every garment top to bottom — fabric, color, fit, structural details, neckline, sleeve length, hem position, layering
- **Jewelry & accessories:** every piece — earring style, necklace count and material, rings, bracelets, body chains, belts, bag, sunglasses, watch
- **Body markers:** piercings, tattoos, nail length and color (only if visible)
- **Pose and energy:** body angle, weight distribution, hand position, expression register

**For each environment in the reference, capture:**

- **Location:** interior or exterior, architecture, materials, scale
- **Time of day and weather:** lighting direction, quality, color temperature, sky, atmospheric conditions
- **Set dressing:** every visible object that shapes the world
- **Color palette:** dominant tones, accent colors, contrast structure

**Naming rule (absolute lock).** NEVER use proper names in the prompt output. Refer to every subject by tag and visual description only.

**No-invention rule.** If the user gives you a reference image and asks for the same character in a new scene, do not invent wardrobe or styling details that aren't in the image or specified in the request.

**Trust-the-reference rule.** See Universal Prompt Rule 21 — the Subject Lock never re-describes what the reference already carries; only state-changes the image can't carry (damp, dirty, torn, wet, dusty, bloodied) get spelled out.

**Canonical-over-plate rule (HARD LOCK).** Every named subject that appears in a Seedance scene gets its canonical reference attached as its own tag — even if that subject is also visible in the rendered environment plate. Characters, vehicles, props, creatures, animals — anything with locked identity that needs to hold across the cut gets its dedicated reference, no exceptions. The plate carries the world (location, weather, light, set dressing, composition); canonical references carry identity (face, body, livery, markings, silhouette). The plate is never a substitute for a canonical reference, and a subject's visible presence in the plate never reduces or removes the requirement to attach its canonical reference. If a character's reference sheet exists, attach it. If a vehicle's canonical reference exists, attach it. Subject Locks anchor to the canonical reference tag; the World Plate block anchors to the plate tag. This is the rule that prevents identity drift between the plate and the rendered Seedance output.

---

## FRAME MAP

Every Seedance prompt includes a Frame Map block that anchors every subject in screen space before motion enters the picture. Think of the Frame Map as the floorplan of the shot — where everything sits when the camera rolls.

**Treat the frame as 2D screen space:**

- **Horizontal:** left third / center / right third — or x% precision (0% = left edge, 50% = center, 100% = right edge)
- **Vertical:** upper third / center / lower third — or y% precision
- **Depth:** foreground / midground / background
- **Frame occupancy:** close-up / medium / full body / waist-up / chest-up / extreme close-up — or % of frame height
- **Negative space:** what stays empty, where the empty space sits, what fills it (atmosphere, environmental detail, distant elements)

**Single-subject example:**

> Frame Map: @sol_ref anchored in the left third, x=30%, foreground, medium shot from waist up, occupying 55% of frame height. The right two-thirds hold wet street and distant neon signage as negative space.

**Two-subject example:**

> Frame Map: @sol_ref in the left third, x=28%, foreground. @daye_ref in the right third, x=72%, midground, slightly deeper. The center holds open as tense negative space between them. Neither crosses the central vertical axis.

**Multi-shot example:**

> Frame Map: Shot 1 (0–6s) — wide two-shot. @sol_ref in the left third, x=32%, foreground, bent at the waist. @daye_ref in the right third, x=68%, midground, leaning against @white_camaro. Shot 2 (6–10s) — low-angle close-up at hip height looking up at the side window, framed tight on @sol_ref's reflection in the wet glass.

**When to skip percentages:** for clear classical compositions (centered single, OTS, profile two-shot, symmetrical wide), use film language without percentages. Coordinates earn their place when the composition is asymmetric, tightly blocked, or subject drift would visibly break the shot.

---

## SUBJECT LOCK

Every subject in the frame gets a Subject Lock block. The Lock pins every property that needs to stay stable across the runtime — pose, gaze, contact points, state — without re-describing what the reference image already carries.

**Properties to pin per subject:**

- **Identity anchor:** which `@tag` carries the face, hair, wardrobe, silhouette
- **Body orientation:** facing camera / profile left / profile right / three-quarter toward screen-right or screen-left / back to camera
- **Pose:** the specific physical posture (standing, kneeling, leaning, seated, walking, bent at the waist, hands raised, hand resting on X)
- **State:** emotional register described by what the body and face physically do — never abstract feelings
- **Expression:** lips, eyes, brow, jaw register
- **Gaze direction:** looking at @tag / looking screen-left / looking screen-right / looking offscreen toward X / locked on camera (rare)
- **Contact points:** where the body physically touches the world — feet on which surface, hand on which object, body part against which surface
- **State-change details the image can't carry:** damp, dirty, torn, wet, dusty, bloodied
- **Lock-down line:** "face, hair, wardrobe, and silhouette identical throughout"

**Single-subject example:**

> Subject Lock — @sol_ref: Face, hair, oxblood corset, and silhouette identical throughout. Ponytail damp from the drizzle, fabric darker where rain has soaked in. Bent at the waist, torso angled toward the side window of @white_camaro, both hands raised to her ponytail at the crown, fingers smoothing strands. Body squared to the car, weight even. Gaze locked on her own reflection in the wet glass.

**Multi-subject example:** each subject gets a discrete Subject Lock block.

> Subject Lock — @sol_ref: [block for first subject]
>
> Subject Lock — @daye_ref: [block for second subject]

Never jam multiple subjects into one Subject Lock paragraph. The discrete blocks make iteration easier and give Seedance cleaner anchoring.

---

## CROSS-FRAME RULES

When two or more subjects share the frame, the Frame Map and Subject Lock blocks aren't enough on their own — the relationships between subjects need their own explicit rules. Otherwise Seedance will sometimes swap them, cross them, drift their distance, or collapse their depth separation as the shot runs.

**Rules to specify for every multi-subject shot:**

- **No swap:** subjects never trade screen positions
- **No center crossing:** subjects never cross the central vertical axis (unless an action demands it, in which case state the crossing with timing)
- **No depth change:** subjects hold their depth layer throughout
- **Distance consistency:** the gap between them stays constant
- **Screen sides held:** left subject stays left, right subject stays right
- **Eyelines:** who looks at whom, and whether the look holds or breaks
- **Carry-across-the-cut:** for multi-shot sequences, name what holds when the camera cuts

**Standard language:**

> Cross-Frame Rules: @sol_ref and @daye_ref never swap positions, never cross center, never change depth. Distance, screen sides, eyelines, costumes, and silhouettes stay consistent across the full runtime.

**Multi-shot variant:**

> Cross-Frame Rules: @sol_ref holds her position at the side window across the full runtime of Shot 1. @daye_ref holds her lean at the rear quarter panel across Shot 1. In Shot 2 only the camera changes — @sol_ref's position holds.

**When subjects do need to cross:** state the crossing explicitly with timing. "At 4 seconds, @sol_ref steps across the central axis from the left third into the center. After 5 seconds, the new blocking holds: @sol_ref in the center foreground, @daye_ref unchanged in the right third midground."

---

## MOVEMENT

Movement in a Seedance shot is layered, not unified. The Movement block describes what happens across the runtime in flowing paragraph form, but the four layers — character motion, micro-motion, environmental motion, camera motion — should all appear in the description.

**The four layers (write them in this order in the paragraph):**

1. **Character motion** — what the subjects physically do across the runtime, with per-beat timestamps and speeds stated in km/h where movement is fast enough to matter
2. **Micro-motion** — what moves on the body while the dominant action plays out (breath, hair, fabric, jewelry)
3. **Environmental motion** — what the world does around the subjects (rain, smoke, dust, traffic, wind, particles), atmosphere quantified in % density and meter visibility
4. **Camera motion** — only when not already covered in the Camera Capture line; usually omitted from the Movement block since the Camera Capture handles it

**Single-shot example:**

> Movement: She takes one slow controlled step from the curb to the street across the first two seconds, then holds for the remaining eight. Ponytail catching subtle wind drift, parachute pants fabric rustling on the step, breath visible in the cold air on a controlled exhale, fingers flexing once inside her front pockets. Light cold rain falling at 20% density, neon reflections shimmering on the wet asphalt, distant taxi headlights moving slowly through the right midground at under 15 km/h, faint steam rising from a manhole grate behind her.

**Multi-shot example:**

> Movement: Shot 1 (0–6s) — @sol_ref smooths her ponytail at the crown, fingers working through strands. @daye_ref watches her with a soft closed-lip smile across the first three seconds, exhales a short scoff at 3 seconds, then turns her head slowly away toward the horizon screen-right and holds. Rain drizzles steadily at 20% density, damp hair on both catches subtle wind, faint mist off the warm hood. Hard cut to Shot 2 (6–10s) — low-angle close-up looking up at the side window. Her eyes flick down and to the side once at 7 seconds — a single controlled eye roll — then return to her reflection. Hands resume smoothing the ponytail. Rain streaks roll down the wet glass naturally across the full close-up.

**Critical rule:** never tangle the four layers. Each one named explicitly in the paragraph, even when one layer is "no motion" or "nothing else moves in the frame." Saying nothing moves is a directive; absence is not.

---

## LAST FRAME

Every prompt closes with a Last Frame block specifying the exact composition the shot lands on at the end of the runtime. Seedance reads it as a target and structures the motion of the shot to deliver that closing image.

**What goes in the Last Frame block:**

- Where each subject sits at the close (carries the Frame Map forward to the end)
- Their final pose / state / gaze
- What the camera is showing in focus
- What's in negative space at the close
- The visual punctuation — what the viewer's eye lands on
- **On-screen text suppression line:** "No on-screen text, no captions, no signage typography, no rendered text in the frame." (skip only when text is explicitly requested)

**Strong examples:**

> Last Frame: Hold on her in the left third, eyes still tracking the now-passed taxi offscreen right, ponytail settling, rain visible on her shoulders, the center of the frame filled with empty wet street and reflected neon, taxi taillights fading at the right edge. No on-screen text, no captions, no signage typography, no rendered text in the frame.

> Last Frame: The camera holds tight on her face in the right third, eyes wide and steady, lips slightly parted on a held breath. Her opponent is fully out of frame on the left, leaving the left two-thirds of the frame as soft-focus rain and distant lit windows. No on-screen text, no captions, no signage typography, no rendered text in the frame.

**Last Frame is mandatory.** Every prompt closes with this block.

---

## WORLD PLATE

The World Plate block names the location, time of day, weather, set dressing, and atmospheric quality — anchored to a reference image when one is attached, or built from text when none is.

**Properties to specify:**

- **Location:** anchored to `@tag` if a plate is attached; otherwise built from text
- **Time of day and weather:** lighting direction, quality, color temperature, sky, atmospheric conditions
- **Set dressing:** specific objects that shape the world (vehicles, signage, debris, vegetation, props, crowd)
- **Color palette:** dominant tones, contrast structure
- **Atmospheric quality:** haze density and particle suspension stated in % density and meter visibility, weather intensity

**Single-shot example:**

> World Plate: Anchored to `@cliffside_plate` — cliffside overlook with low grass and exposed rock at the edge, the drop falling away behind @white_camaro, dusk sky dropping from cool blue at top into deep magenta and warm tungsten residue at the horizon, distant clouds, light atmospheric haze at 10% density readable to 200 meters. @white_camaro parked perpendicular to the cliff edge, paint slick with rain, side windows wet, faint mist off the warm hood.

**Text-only example (no plate attached):**

> World Plate: Midtown New York City street at 3 AM — wet black asphalt, mixed neon signage in magenta and cyan reflected across the puddles, distant traffic lights cycling, sparse pedestrian foot traffic far in the background. Light cold rain at 20% density. Steam rising from grates, haze readable to 40 meters.

---

## SOUND BED

The Sound Bed describes **only what the scene physically produces** — sounds that exist within the world of the frame. Never reference music, lyrics, song names, soundtrack cues, or score. If the user wants music in the final cut, they upload the track as a separate audio reference inside Higgsfield.

**Allowed in the Sound Bed:**

- Footsteps (specify surface — wet pavement, gravel, polished floor, wood)
- Fabric movement (rustle, swish, whip on motion)
- Breath and breathing (steady, ragged, held, sharp inhale)
- Body sounds (hand on skin, grip on metal, jewelry chime)
- Object sounds (door, glass, paper, ceramic, metal, electronics, weapon mechanisms)
- Environmental ambient (room tone, wind, rain, traffic hum, distant horns, subway rumble, bird call, water, fire crackle)
- Mech / sci-fi diegetic (servos, weapon charging hum, pulse fire impact, alien screech, debris fall)
- Crowd diegetic (cheering, screaming, gasps, light stick taps, footsteps in unison)
- Stage diegetic (laser strobe hum, microphone handling noise, in-ear monitor cable rustle, stage floor creak, haze machine hiss)
- Weather and atmosphere (rain on lens, wind through structures, distant thunder, snowfall hush)

**Never in the Sound Bed:**

- Song names, artist names, album names
- Lyrics, sung vocals tied to a track
- "Music plays," "soundtrack swells," "song builds"
- Score descriptors (orchestral, synth pad, dramatic strings)
- Specific genre cues (hip hop beat drops, rock guitar)

**Audio modes (pick one based on user intent — ask if ambiguous):**

- **Mode 1 (default) — Diegetic with SFX and ambient.** Realistic in-scene audio. `Sound Bed: Diegetic only — [list of specific sounds], no music, no dialogue except what is physically spoken in frame.`
- **Mode 2 — Silent capture.** Used only when the user explicitly says they will upload music in post AND wants NO in-camera audio fighting it. `Sound Bed: NONE — fully silent capture. The audio track will be added separately in post.`
- **Mode 3 — Diegetic with SFX, no music explicitly.** Same as Mode 1, just confirming no music will be added. `Sound Bed: Diegetic only — [list of specific sounds], no music, no dialogue, no soundtrack.`

Mode 1/3 is the default. Use Mode 2 only when the user explicitly says they're adding a music track in post AND wants the video silent.

**Sound Bed example:**

> Sound Bed: Diegetic only — boots on wet pavement, fabric whip on movement, sharp inhale, distant traffic hum with layered horns, faint subway rumble below grade, rain hiss against the lens, wind cutting between buildings, no music, no dialogue except what is physically spoken in frame.

---

## CAPTURE REALISM BLOCK (LOCKED — THE REAL-FOOTAGE ENGINE)

This is the block that makes a shot read as real cinema capture instead of AI video. The Camera Capture line below names the *gear*; this block names the *physics* — the four mechanics that, in practice, are what separate footage that looks photographed from footage that looks rendered. It sits second-to-last in the block order, immediately before Camera Capture, and ships on every prompt unless the user explicitly asks for a glossy, clean, or commercial register.

**Why it exists:** the most common AI-video failure isn't bad framing or wrong lens — it's the over-contrasty, over-plastic look. That look comes from three things the model does by default: it invents flat single-plane staging (no air between subject and background), it renders moisture and skin as glossy/specular, and it over-renders contrast cues into clipped highlights and crushed blacks. This block attacks all three at the source. It is the codified, repeatable version of what hand-written one-off prompts had to spell out from scratch.

**The four mechanics — every Capture Realism block tunes all four to the scene.** Mechanic 1 (depth via suspended atmosphere) is default-on in every mode that has planes to separate — M1, M3, M4, and M5 always; M2 studio when there's any depth to read. It is the primary lever against the flat, over-contrasted, plastic look and should be scaled (thin/light/heavy) rather than dropped. Mechanics 2–4 tune or drop per scene as noted below.

**1. Depth via suspended atmosphere between planes.** This is the single biggest lever for real-camera depth. State that atmosphere — haze, mist, air density, particulate — is *suspended in the air between the camera, the subject, and the background*, forcing the model to render distant planes softer, desaturated, and lower-contrast than the foreground. This is what makes a subject sit *inside* the depth of the frame rather than pasted onto a flat backdrop. Always tie it to the actual planes in this shot (foreground subject / midground / far background element), and state the density in % and the visibility depth in meters (see § WRITE THE VISIBLE).

**2. Moisture without shine (only if the scene is wet/humid/sweaty).** The default AI failure on any wet scene is glossy beads and specular sheen, which instantly reads CGI. If the scene has moisture of any kind, state it as *present but matte* — surfaces are damp, not beaded; wet but not glossy; moisture that mutes and saturates without producing a single specular hotspot. Damp matte hair, slight moisture on skin that stays matte, wet ground with muted (not mirror) reflection, wet paint that stays matte not showroom. If the scene is bone-dry, skip this mechanic entirely.

**3. Per-zone specular kill on skin — and the flattering ceiling.** "Matte skin" is too vague to hold. Name the zones individually: zero shine on forehead, zero shine on nose bridge, zero shine on cheekbones, zero shine on temples, zero shine on chin, zero shine on collarbones. The blown specular hotspot on a nose bridge or cheekbone is *the* AI-skin tell — naming each zone kills each hotspot. Pair it with the biology cues: real peach fuzz at jaw and hairline, real soft pore texture, light absorbed like true subsurface scattering, warmth preserved (slightly desaturated is fine, washed-out/pale/cool-shifted is not). **The flattering ceiling is locked on every face:** the texture is fine, soft, and even — never harsh, severe, or unflattering. No acne, no blemishes, no prominent spots, no scarring, no enlarged/cratered/rough pores, no brutal clinical macro-detail. Realism never makes a face look ugly. Matte carries the anti-plastic; fine-and-even carries the flattering; both run together, and any tension resolves toward flattering.

**4. Contrast curve stated three ways.** Over-contrast is the headline complaint, so attack it from three angles in the same block: (a) the tonal curve — shadows lifted gently, highlights rolled off softly, nothing clipping to pure white or crushing to pure black; (b) specular removal — all specular highlights surgically removed from skin, hair, fabric, and surfaces, every pixel reading matte and diffuse; (c) the grade — low-contrast, slightly desaturated, warmth preserved. Three statements of the same intent is what holds it; one statement gets overridden by the model's default contrast bias.

**Canonical Capture Realism block (tune every bracket to the scene):**

```
Capture Realism: [Foreground subject] sits inside real depth — [thin/light/heavy, X% density, readable to Y meters] atmosphere suspended in the air between camera, subject, and [the far background element], the background rendered softer, desaturated, and lower-contrast than the foreground so the figure sits within the air rather than pasted on a flat plane. [IF WET: Slight moisture has settled on every surface — damp matte hair, slight moisture on skin holding fully matte with no beading and no wet sheen, [wet ground with muted reflection / damp matte fabric / car paint damp but matte not showroom], moisture that mutes and deepens without a single specular hotspot.] Skin reads true cinematic matte — zero shine on forehead, nose bridge, cheekbones, temples, chin, and collarbones, real peach fuzz catching light at the jaw and hairline, real soft fine even pore texture, light absorbed like true subsurface scattering, warmth preserved and natural, slightly desaturated but never pale or washed-out or cool-shifted, never plastic, never doll-skin, never AI-rendered, and never harsh — no acne, no blemishes, no enlarged or rough pores, fine flattering texture that keeps the face looking good. Low-contrast curve — shadows lifted gently holding texture, highlights rolled off softly never clipping to white, nothing crushed to black. All specular highlights surgically removed from skin, hair, fabric, and surrounding surfaces, every pixel reading matte and diffuse. Slightly desaturated grade with warmth preserved.
```

**Tuning notes:**
- **Dry scenes:** delete the entire `[IF WET: ...]` sentence. Don't force moisture into a dry environment.
- **No humans (M5 / pure environment plates):** drop the skin sentence entirely. Keep mechanics 1 and 4 (atmosphere-between-planes and the contrast curve), and apply the matte-not-glossy logic to environmental surfaces (wet concrete, metal, glass) instead of skin.
- **Studio / M2 editorial:** if the user wants the *crafted* glossy editorial look, this block is reduced (never skipped — the labelled block still ships, shortened) — M2 is the one mode where controlled specular (intentional highlight bloom on chrome/rhinestone) is intentional. Use judgment; ask if unsure.
- **Atmosphere density** scales with the scene and is always quantified: "thin atmosphere, 5% density" for a clear interior, "light haze, 15–25% density, readable to 60 meters" for most exteriors, "heavy suspended mist, 50%+ density, readable to 15 meters" for a moody pre-dawn or a destroyed-city plate. The denser the air, the stronger the depth separation.
- **This block does not name gear, grade hex, frame rate, or runtime** — that all stays in Camera Capture. No overlap. Capture Realism is physics; Camera Capture is hardware.

**Relationship to the negative→positive rule:** this block leans positive ("reads matte," "lifted gently," "warmth preserved") rather than piling negatives, but the specular-kill and the anti-plastic clauses are the sanctioned exception — like the on-screen-text suppression, the "no shine / no plastic / no beading" phrasings are known-failure-mode suppressions that earn their place. Keep them tight; don't let the block balloon into a wall of negatives.

---

## CAMERA CAPTURE

The Camera Capture is the single closing line of every Seedance prompt. It contains body, lens (FOV° + mm), filter, movement, stock, grade, frame rate, and runtime — all in one trimmed paragraph.

**This is the only camera/grade/film stock language anywhere in the prompt.** No discrete `Camera:` block in the middle of the body. No double specification. The Camera Capture line carries it all.

**Cameras and lighting are named by behaviour, never by brand.** Describe capture register, lens character, and light quality in physical terms Seedance can act on — "wide-latitude cinema capture," "vintage 2x anamorphic character," "wide directional key light with a warm 3200K temperature" — never fixture model numbers or camera-body brand names. This applies to lighting instruments as much as cameras: direction, quality (hard/soft, size relative to the subject), and color temperature carry the information; a named brand does not.

**Default camera energy is handheld with breath, drift, and organic operator movement** — **in M1, M3, and M4** — even in quiet or observational moments. The lived-in operator presence is part of the cinema register.

**In M1/M3/M4, locked-off tripod is OPT-IN ONLY** — used only when the user explicitly requests "locked off," "tripod," "no camera movement," "static," "still camera," or names a specific shot type that requires it (overhead surveillance plate, surgical observation, security cam aesthetic, formal portrait studio plate). **M2 (locked tripod with optional slow push) and M5 (locked-off or extremely slow push) bake in their own camera baselines per the Mode-Select Table — this opt-in rule does not apply there.**

---

## FOV DEGREE TABLE (LENS ANCHOR)

Seedance latches onto **FOV in degrees** as a snap value — the model treats every degree number as a discrete anchor. Millimeters read as suggestion; degrees read as instruction. Multishot sequences that only name mm drift lens character between beats. Degrees hold.

Write the FOV degree in the prompt body. Millimeters go in parentheses as a reader aid only. Pick from the anchor steps below. Never write a non-anchor value — 23° is not on the ladder, so use 18° or 29° instead.

| FOV | mm equiv | Feel | Use for |
|---|---|---|---|
| 180° | fisheye | spherical bulge | POV, dream-state, hallucination |
| 107° | 14–16mm | architectural ultra-wide | vast interior scale, epic establishing |
| 84° | 20–24mm | wide | full-body group blocking, environmental establish |
| 63° | 28–35mm | reportage wide | observational, walking-alongside, doc feel |
| 47° | 40–50mm | eye-level neutral | universal medium, dialogue two-shot, waist-up |
| 29° | 75–85mm | portrait compression | isolated bust, tight dialogue coverage |
| 18° | 100–135mm | portrait tight | identity-hold close-up, held emotional beat |
| 12° | 180–200mm | tele detail | hand insert, object close, jewelry, texture |
| 8° | 300–400mm | extreme long-lens | anchored-far observation, sports broadcast, watchtower feel |

**Write it in the prompt as:** `47° (50mm) eye-level neutral`, `29° (75mm) portrait compression`, `18° (100mm) portrait tight`. Never mm alone. Never an off-ladder degree.

**Multishot at extreme FOV** (8° or 107°): FOV declared per segment plus a "no drift mid-segment" clause. See § SPECIAL PROTOCOLS.

**Camera block position.** The Camera Capture line lives at the bottom of the prompt — 3rd position from the end (World Plate → Sound Bed → Capture Realism → Camera Capture). Bottom position holds the FOV lock. At the top of the prompt, FOV fights identity data; buried mid-body, it fades into the surrounding text.

**When in doubt** default to 47° (M1/M3/M4) or 47°–63° (M2) for medium framing. M5 typically uses the wider end (63°–84°) for environmental reach, pushing tighter (18°–29°) only for weathered-detail inserts.

---

## CUTS & TIMING PRECISION SCALE

Choose the tightest level of control the shot actually requires. Four registers, most-to-least precise:

- **Oner** — one continuous take. Write: *"one uninterrupted shot, no internal cuts, camera never breaks the take."*
- **Sequential cuts (untimed)** — beats matter, exact seconds don't. Label them `CUT 1 … CUT 2 … CUT 3` in Movement. Useful for concept-first editorial.
- **Timed multishot** — beats land on specific clock positions. Every cut declared with its second value, `HARD CUT` written explicitly.
- **Freestyle b-roll** — the camera and editor get to explore. Rare — only when the user asks for it out loud.

Whenever you specify cuts (either sequential or timed), close the door on unintended edits with: *"the camera does not add any additional cuts, edits happen only at the marks written above."*

**Timecoded format** (use only for timed multishot):
```
0.0s → 1.2s — [beat one description]
1.2s — HARD CUT
1.2s → 3.5s — [beat two description]
```

**Sequential format** (use for untimed cuts):
```
CUT 1 — [beat one description]
CUT 2 — [beat two description]
CUT 3 — [beat three description]
```

**Cut vocabulary Seedance recognizes:** `HARD CUT`, `SMASH CUT`, `MATCH CUT`, `INSERT CUT`, `REVERSE CUT`, `WHIP CUT`. Dissolves and crossfades only if the user explicitly names one.

**Continuity across a cut** — every internal edit holds: same subject set, same left/right geometry, same eyeline direction, same light temperature and direction, same wardrobe state, same prop states (drink half-full, jacket on, mic in right hand). State any of these that a scene puts stress on.

**Whip pan timing** — a whip needs at least 0.8 seconds of motion to render as a blur; anything shorter renders as a hard cut:
```
0.3s — Subject A framed, held
0.8s — WHIP begins, motion blur across the pan
1.4s — Subject B framed, held
```

**Speed changes.** When mixing real-time and slow-motion beats in one prompt, put a hard cut at every speed change. Never blend speed inside a single continuous shot — one speed per beat, cut cleanly at the transition.

---

## MODE-SELECT TABLE

| Mode | Use when scene is... | Capture | Lens character | Movement | Diffusion | Grade |
|---|---|---|---|---|---|---|
| **M1 — Narrative** | Real-world dramatic — streets, kitchens, cars, bars, interiors, exterior locations. Anywhere lived-in. | Wide-latitude cinema capture | Vintage 2x anamorphic character, wide aperture — oval bokeh, soft frame-edge falloff | Handheld with operator breath | Light diffusion bloom softening highlights | Color-negative daylight film rendition, fine 35mm grain, teal-amber |
| **M2 — Studio / Editorial** | White void, clean studio, hyperpop saturated set, fashion film, editorial portrait, performance-on-set | Wide-latitude cinema capture | Clean spherical character, wide aperture — natural round bokeh, even sharpness | Locked tripod with optional slow push | Mild diffusion bloom; intentional highlight bloom on chrome/rhinestone | Saturated editorial, warm-retained blacks, fine grain |
| **M3 — Action / Combat** | Combat, chase, stunts, war, mech battles, alien encounters, debris, smoke, dust | Wide-latitude cinema capture | Vintage 2x anamorphic character, wide aperture — oval bokeh, soft edge falloff | Handheld and shaky throughout, no stabilized shots | Light diffusion bloom softening highlights | Color-negative film rendition, heavier low-light grain, palette per scene, dusty haze |
| **M4 — Performance / Concert** | Stadium, arena, stage, jumbotron, lightstick crowd, festival pit | Wide-latitude cinema capture | Vintage 2x anamorphic character, wide aperture — oval bokeh, horizontal streak flares on stage lights | Mixed handheld pit-photographer and orbital, hard cuts | Light diffusion bloom softening highlights | Color-negative film rendition, fine grain, desaturated cool with warm bloom, stage color cast |
| **M5 — Atmospheric / Empty** | Abandoned environments, no-humans plates, landscapes, weather pieces, mood/world establishing shots | Wide-latitude cinema capture | Vintage 2x anamorphic character, wide aperture — oval bokeh, soft edge falloff | Locked-off or extremely slow push-in / pull-back | Light diffusion bloom softening highlights | Color-negative film rendition, fine grain, palette-driven (specify hex per scene) |

---

## MODE 1 — NARRATIVE (Real-World, Lived-In)

**When to use:** Real-world dramatic scenes. Streets, apartments, kitchens, cars, bars, diners, locker rooms, exterior locations, anywhere someone could plausibly walk into and shoot.

**Camera Capture line (drop in at end of any M1 prompt):**

```
Camera Capture: wide-latitude cinema capture, [FOV°] ([mm]) vintage 2x anamorphic character at a wide aperture — oval bokeh, soft frame-edge falloff — light diffusion bloom softening highlights, handheld with natural operator breath, color-negative daylight film rendition with fine 35mm grain, teal-amber grade, shallow depth of field, 24fps 180° shutter, [XX] seconds.
```

Replace `[FOV°] ([mm])` with an FOV table anchor (47° / 50mm wide, 29° / 75mm tight, 18° / 100mm close-up) and `[XX]` with the runtime.

**Multi-shot variant:**

```
Camera Capture: Shot 1 — wide-latitude cinema capture, 84° (24mm) vintage 2x anamorphic character at a wide aperture, light diffusion bloom softening highlights, handheld with natural operator breath. Shot 2 — same capture register, 29° (75mm) anamorphic character at a wide aperture, low-angle handheld at hip height, tight operator breath. Color-negative daylight film rendition with fine 35mm grain, teal-amber grade, shallow depth of field, 24fps 180° shutter, [XX] seconds total.
```

---

## MODE 2 — STUDIO / EDITORIAL (Crafted, Not Photographed)

**When to use:** White void, clean studio sets, editorial portraits, hyperpop saturated worlds, fashion film, performance-on-set, any scene that is *crafted* rather than *photographed.*

**FOV guide:**
- 84° (20–24mm) — full-body wide on the void / group framing
- 47° (50mm) — medium portrait
- 29° (75mm) — tight editorial face cuts
- 12°–18° (100–135mm) — extreme close-ups (lips, eyes, jewelry, fabric)

**Camera Capture line:**

```
Camera Capture: wide-latitude cinema capture, [FOV°] ([mm]) clean spherical character at a wide aperture — natural round bokeh, even sharpness — mild diffusion bloom, locked tripod with optional slow push-in, saturated editorial grade, fine grain, warm-retained blacks, 24fps 180° shutter, [XX] seconds.
```

For rhinestone, chrome, or surface-detail close-ups, add: `intentional highlight bloom on reflective surfaces, blooming the speculars on chrome and rhinestone.`

---

## MODE 3 — ACTION / COMBAT (Documentary-Sci-Fi)

**When to use:** Combat, chase, stunts, war, mech battles, alien encounters, fight choreography, any high-physicality scene with debris, smoke, dust, or destruction.

**Camera Capture line:**

```
Camera Capture: wide-latitude cinema capture, [FOV°] ([mm]) vintage 2x anamorphic character at a wide aperture — oval bokeh, soft edge falloff — light diffusion bloom softening highlights, handheld and shaky throughout with no stabilized shots, color-negative film rendition with heavier low-light grain, [palette descriptor] with dusty atmospheric haze, 24fps 180° shutter, [XX] seconds.
```

Replace `[palette descriptor]` with scene-appropriate language (e.g., "daylight overcast palette," "golden hour warm palette," "blue-hour cool palette," "stormy desaturated palette"). State any vehicle or figure speed in km/h and haze density in % (see § WRITE THE VISIBLE).

For impact slow-motion: append `intercut 96fps high-speed slow-motion at the [moment] holding 180° shutter for natural motion blur.`

---

## MODE 4 — PERFORMANCE / CONCERT (Pit-Photographer Documentary)

**When to use:** Stadium and arena performance shots, festival pits, concert footage, jumbotron-and-lightstick worlds, anywhere a performer is on stage with a crowd and stage lighting.

**Camera Capture line:**

```
Camera Capture: wide-latitude cinema capture, [FOV°] ([mm]) vintage 2x anamorphic character at a wide aperture — oval bokeh, horizontal streak flares on stage lights — light diffusion bloom softening highlights, mixed handheld pit-photographer and orbital operator energy with hard cuts between angles, color-negative film rendition with fine grain, [stage-lighting color cast], heavy volumetric haze, real sweat sheen, 24fps 180° shutter, [XX] seconds.
```

Replace `[stage-lighting color cast]` with scene-specific language (e.g., "magenta-red color cast from the LED cube above," "amber and ultraviolet wash from side rigs," "cyan and white strobe punching through warm tungsten").

---

## MODE 5 — ATMOSPHERIC / EMPTY (Environment & Mood)

**When to use:** Abandoned cityscapes, no-humans environment plates, landscapes, weather pieces, slow-burn mood shots, world-establishing footage where the environment is the subject.

Also use for: "no humans," "abandoned," "empty," "ghost city," "deserted," "weather plate," "establishing wide" requests.

**Camera Capture line:**

```
Camera Capture: wide-latitude cinema capture, [FOV°] ([mm]) vintage 2x anamorphic character at a wide aperture — oval bokeh, soft edge falloff — light diffusion bloom softening highlights, locked-off or extremely slow push-in only, color-negative film rendition with fine grain, palette grade [hex values], atmospheric haze, weathered material detail, 24fps 180° shutter, [XX] seconds. No humans, environment is the subject.
```

Replace `[hex values]` with actual color codes for the scene's palette (e.g., "#2A3540, #4A5560, #6B7280, #8B7355, #A89178"). State atmospheric haze in % density and meter visibility.

---

## OPTICAL TECHNIQUES

Named lens-and-camera patterns that produce specific recognizable looks. Use them by name-plus-application when the shot calls for one.

**Voyeur / long-lens observation** — the "someone is watching this from a distance" register. Three ingredients required simultaneously:
1. A foreground obstruction covering 20–30% of the frame — a wall edge, a pillar, a branch, a curtain, an arch, a leaf cluster — thrown out of focus
2. Suspended atmosphere between the camera and the subject — haze, dust, humidity, heat waver — stated in % density
3. Extreme long lens at 8° or 12° with the operator positioned far from the subject
The obstruction shape can change between shots in a sequence; the vantage stays anchored — never zoom-in on a voyeur shot.

**Broadcast press-box** — the televised-live-sport read: `8° (300mm) tele lens, operator handheld with a small 1–2cm hunting tremor, hunting for the action from a fixed distant vantage.`

**Foreground-loaded wide (macro-in-a-wide)** — small object made huge, background pushed back into deep space: `84° (24mm) wide, low-angle inches from the object, camera almost touching it.` Great for hero-shot props, hands, hardware.

**Wide portrait** — a close face rendered wide so the room stays legible around them: `63°–84° (28–24mm) wide FOV on a centered face at a normal working distance.` The face stays anchor; the world remains in-frame without going soft.

**Compressed atmosphere column** — the long lens's ability to stack air on itself: at 8°–12°, name the suspended particulate as a compressed column between camera and subject. *"a thick vertical column of suspended dust visible between the operator and the figure,"* *"a wall of heat haze stacked in front of the subject."*

---

## SPECIAL PROTOCOLS

**Extreme-FOV multishot stack (8°, 107° across multiple beats).** These lens ranges drift the fastest — the model loses the lens between beats after two or three cuts. Four locks required in combination, no substitutes:
1. **Anchor reference** — one location or environment reference held across every beat
2. **Opening lens declaration** — the FOV in degrees spoken at the top of every beat
3. **Closing lens declaration** — the FOV in degrees repeated at the end of every beat
4. **Color rendered by tying every hue to a surface, a light source, and a compositional purpose**, never as a bare list of color words
Drop any one of these four and the sequence starts drifting on beat three.

**Pressure fracture / impactless breaks.** When cracks, breaks, or debris need to happen *without* an impact point (glass fracturing from thermal stress, a wall giving way under crowd density, ice splitting from cold):
- Describe the origin as *edge stress* or *slow pressure*, never a point-of-strike
- Move the fracture pattern from edge inward rather than radiating out from a center
- Time the crack progression asymmetrically (0.3s at one edge, 0.6s spreading, 1.0s meeting midline)
- For crowds: *"the crowd pushes forward as a mass under its own weight, no strike, no throw"*

---

## STACKING MODES (Multi-World Sequences)

If a single Seedance sequence cuts between two worlds — for example, a music video that intercuts a white void (M2) with a kitchen (M1), or action footage (M3) intercut with performance footage (M4) — write each shot's Camera Capture specs inline in the closing line. Don't blend modes into one averaged grade. The cut between modes is the visual punch; collapsing them kills the contrast.

For multi-shot sequences in the same mode, you can compose one continuous prompt with hard-cut triggers in Movement and a single Camera Capture line with per-shot lens differences inline.

---

## FRAME RATE NOTES

All five modes default to **24fps with 180° shutter** for cinema-standard motion blur.

Slow-motion beats (impact, hair whip, fabric on a hit, water splash, weapon recoil): specify inside the Camera Capture line — `intercut 96fps high-speed slow-motion at [moment] holding 180° shutter.` Keep the base frame rate at 24fps.

---

## RUNTIME & PER-SHOT TIMING

**Total runtime** is stated in two places: the title line above the code block and the closing Camera Capture line. Both must match. **Always ask runtime — never default.**

**Shot complexity guidance:**
- **4–8 seconds** — one strong character action, single locked composition
- **8–12 seconds** — one action plus reveal or hold, optional micro-shift in composition
- **12–15 seconds** — 2–3 simple beats with hard cuts inside the prompt
- **Complex multi-action sequences** — split into separate prompts

**Per-shot timing for multi-cut sequences:** when a single Seedance prompt contains more than one shot stitched with hard cuts, label each shot inline in the Frame Map and Movement blocks with its time range (see § CUTS & TIMING PRECISION SCALE for the timecode format). The per-shot timing must add up to the total runtime stated in Camera Capture and the title.

---

## NEGATIVE → POSITIVE REWRITES

Seedance responds far better to positive locks than to negative prohibitions. See § POSITIVE PHRASING for the principle; this table is the studio's worked reference.

| Instinct (negative) | Lock (positive) |
|---|---|
| Don't change face | @sol_ref keeps the same face, hair, wardrobe, and silhouette throughout. |
| Don't switch positions | @sol_ref remains in the left third throughout; @daye_ref remains in the right third throughout. Neither crosses the center line. |
| Don't drift | Boots stay planted on the same ground marks across the full runtime. Only breath, eyes, hair, and fabric move subtly. |
| Don't change costume | Wardrobe identical across the runtime. |
| No extra people | The frame contains only @sol_ref and @daye_ref in their specified positions. No other figures enter or pass through. |
| No on-screen text | No on-screen text, no captions, no signage typography, no rendered text in the frame. |
| No camera chaos | Slow controlled handheld with natural operator breath, preserving @sol_ref in the left third and @daye_ref in the right third throughout. |
| No blur | Subjects remain sharply focused; controlled cinematic motion blur appears only on falling rain and distant background light sources. |
| Don't blink mid-action | Gaze stays locked on @daye_ref across the full runtime, eyes steady, no break in eye contact. |
| No mode switching | The shot runs as one continuous take with no cuts, no scene change, no time jump. |

**Always prefer the positive form.** Negative phrasing belongs only in the explicit suppression lines for known Seedance failure modes (the on-screen text suppression is the canonical example).

---

## PRE-DELIVERY PASS (Silent QA — Run Before Every Delivery)

Before delivering the full prompt to the user, silently run this pass. If anything fails the check, fix it before the prompt ships. Do not narrate this pass — it happens internally.

**The pass:**

- [ ] Character gate asked (if first prompt of session) and answer carried
- [ ] Every element tag named by the user for this scene is listed in the pre-prompt check and appears at least once inline as `@tag` in the code block
- [ ] **Canonical reference tagged for every named subject that appears in the scene, even when that subject is also visible in the rendered plate** — characters, vehicles, props, creatures
- [ ] Mode selected (M1 / M2 / M3 / M4 / M5) with rationale
- [ ] Frame Map block written — every subject pinned to a screen position, depth layer, frame occupancy
- [ ] Subject Lock block written for every subject — identity / orientation / pose / state / gaze / contact points / state-changes / lock-down line. Wardrobe NOT re-described from reference image — only state-changes the image can't carry.
- [ ] Cross-Frame Rules written if 2+ subjects in frame — no swap, no center cross, no depth change, distance held, screen sides held; single-subject scenes still ship the labelled block, shortened
- [ ] Movement block written — four layers present (character / micro / environmental / camera) in paragraph form, per-beat timestamps where the action demands, speeds in km/h, atmosphere in % and meters
- [ ] Last Frame block written — exact closing composition stated, on-screen text suppression line included (unless user requested in-frame text)
- [ ] World Plate written — location, time, weather, set dressing, anchored to plate tag if attached, atmosphere quantified
- [ ] Sound Bed written — diegetic mode chosen, specific sounds listed, no music referenced
- [ ] Capture Realism block written and tuned to the scene — depth-via-suspended-atmosphere between the actual planes (quantified in % and meters); moisture-without-shine ONLY if the scene is wet (deleted if dry); per-zone specular kill on skin (dropped if no humans); contrast curve stated three ways. Not duplicating any gear/grade/frame-rate language from Camera Capture. Reduced (never skipped) only if the user explicitly asked for a glossy/clean/editorial register.
- [ ] Camera Capture line at the bottom — single trimmed paragraph, FOV° (mm) + body / lens / filter / movement / stock / grade / frame rate / runtime, no double camera spec
- [ ] FOV picked from the discrete anchor table (never an off-ladder degree)
- [ ] Cuts precision picked (oner / sequential / timed / freestyle) and stated correctly
- [ ] Runtime confirmed with the user (never assumed). Runtime in title matches runtime in Camera Capture.
- [ ] Per-shot timing planned for multi-cut sequences, summing to total runtime
- [ ] Written the visible — no mood-word abstractions; emotion via muscle cues; speeds in km/h; atmosphere in % and meters; scale via human-height stacking
- [ ] No character names in prompt output
- [ ] No real brand names in prompt output
- [ ] No platform/tool names in prompt output
- [ ] No internal production context, no meta-commentary, no abstract emotional intent
- [ ] No music, no lyrics, no song references in Sound Bed
- [ ] Output language locked to English inside the code block
- [ ] Two-part delivery format: (1) bolded English title with runtime, (2) English code block with labeled blocks and `@tag` references
- [ ] All ten labeled blocks present in the code block, in exact locked order: Scene & Mood → Frame Map → Subject Lock(s) → Cross-Frame Rules → Movement → Last Frame → World Plate → Sound Bed → Capture Realism → Camera Capture. None missing, none reordered, none merged, none renamed.
- [ ] Style distributed across its home blocks — no top-of-prompt style prefix
- [ ] Negative prohibitions translated to positive locks throughout
- [ ] Total prompt body word count within target range (280–400 single shot, up to 600 multi-shot)

**Repair pass — if any of these conditions are detected, fix before delivery:**

- **Too poetic or abstract** → rewrite Scene & Mood as physical visual instructions
- **Overloaded with action** → split into a multi-shot sequence
- **Subject might drift** → tighten Subject Lock with contact points and ground marks
- **Subjects might swap positions** → tighten Cross-Frame Rules
- **Wardrobe re-described from the image** → cut redundant description, trust the reference
- **Double camera spec detected** → collapse to single Camera Capture line at the bottom
- **Mode register conflict** → keep one cinema mode dominant per shot
- **Action too complex** → keep one dominant subject motion, push the rest into the next shot
- **Last Frame missing or vague** → write a specific closing composition
- **FOV drift on extreme-FOV multishot** → apply the four-lock consistency stack in § SPECIAL PROTOCOLS
- **Prompt word count over target** → trim Subject Lock and Movement first, then Cross-Frame Rules

---

## OPTIONAL HANDOFFS

**Story bible pairing.** If a story bible skill (`story-bible-builder` or `cinema-world-bible`) is also active in the session — carrying character voice, movement, stillness, or aesthetic-era locks — pull the character's Movement/Stillness descriptors into Subject Lock, pull Speech into the Sound Bed's spoken-dialogue line, pull the aesthetic-era block into the grade half of Camera Capture, and pull production rules into the Universal Prompt Rules layer. The bible is the identity/context source; this skill is the cinematography grammar.

**Cinema World Bible cross-link.** In this studio, shot specs and locked character/reference continuity are managed upstream by the `cinema-world-bible` skill (owned by the Cinema Showrunner). That skill produces the structured shot spec — including which element tags are assigned to which references and in what order — before a Seedance prompt is written. When a shot spec is present, the tag names should follow the world-bible's reference-library index exactly. When the shot includes dialogue or other vocal sound, the same shot spec carries each character's voice register, cadence, phrasing, and timbre — pull that into the spoken-dialogue line inside Sound Bed. Voice spec describes vocal delivery only; it never introduces music, score, or genre cues into the Sound Bed. If a shot spec is not present, operate standalone as normal.

**Banana Pro handoff.** If the user mentions they have a Banana Pro plate for the environment, want camera grammar to match an existing plate, or are pairing a Seedance prompt with a still they already built in Banana Pro, ask which cinema mode the plate used and lock the matching camera grammar in the Seedance prompt. The two skills share the same five-mode framework — when paired, the still and the video share visual DNA.

Otherwise, do not bring any of this up. Cinema-worldbuilder operates standalone unless the user invokes a pairing.

---

## STUDIO CONVENTIONS

In this studio, written deliverables (briefs, shot specs, world bibles, integration documents) pass a QA gate (QAComplianceReviewer) and a humaniser pass before release. This applies to surrounding prose and structured documents, not to the prompt code-block output itself — the prompt grammar inside the fenced code block is verbatim copy-paste material and must never be humanised or reworded.
