---
name: cinema-director
description: "Cinema director for Seedance 2.0/2.5 and Higgsfield video prompts. Establishes the target version first — 2.0 caps at 9 references and 15s, 2.5 at 50 and 30s. Writes multi-shot prompts on a locked 16-slot spine: header, Style Prefix, NO ON-SCREEN TEXT, CRITICAL blocks, Assets, Geometry Map, First Frame, Optics in FOV degrees, Camera, Light and Colour, Atmosphere, Action Timing, Physics, Acting, Audio, Locks. Covers cinema vs phone/BTS capture, M1–M5 modes, lipsync bilabial protocol, strobe grammar, true-gravity physics, source-bound atmosphere, diegetic audio under NO BGM. Uses user-supplied element tags (e.g. @sol_ref, @rain_plate). Use whenever the user wants a Seedance or Higgsfield video prompt, a music video shot, a BTS clip, a performance or lipsync sequence, an action or atmospheric sequence, or asks to break a scene into shots. For stylized or bilingual EN+ZH JSON output, use seedance-bilingual-director. For briefs meant to sell or showcase a product or brand, use seedance-commercial-director."
---

# Cinema Director — Seedance 2.5 / Higgsfield Prompt Grammar

<!-- STUDIO-LOCAL BEGIN: version and provenance record — upstream ships no provenance block, and this studio needs the adoption trail to keep future drops mechanical. -->
**Version.** Upstream drop 3 (`cinema-director-v3`) adopted 19/08/2026 as the new base for this skill via upstream-as-base + re-graft, on top of the drop-2 base adopted 04/08/2026. The spine moved from thirteen blocks to sixteen slots; the old Last Frame block was retired upstream and is deliberately not resurrected here.

**Adopted wholesale from upstream drop 3:** the STEP ZERO 2.0/2.5 target-version gate and its long-form anti-drift kit; SLOT 2 Style Prefix; the merged SLOT 5 Assets line (identity + THIS SCENE action + fidelity assertion) with state-conditional identity and inline anti-drift negation; SLOT 6 Geometry Map; SLOT 7 First Frame; SLOT 12 Action Timing; SLOT 13 Physics; SLOT 14 Acting; the 70/20/10 colour doctrine; source-bound vapour replacing the old blanket still-haze ban; the `NO BGM` convention; the eighteen-row repair table; and the optional negative-prompt block. Upstream drop 3 is written in Australian English, so the flip carried the locale sweep with it (upstream's `vapor` corrected to `vapour`).

**Re-grafted studio-local**, each marked inline with a `STUDIO-LOCAL` wrapper and a justification comment: the user-supplied element-tag grammar (`@sol_ref`, `@rain_plate`) replacing upstream's numbered image/video index; the tag-list delivery format; the canonical-over-plate hard lock; the no-real-brand-names rule with its authorised override; the three-way skill-routing disambiguation in the frontmatter description; the `cinema-world-bible` cross-link and voice-register consumption; the Banana Pro handoff; STUDIO CONVENTIONS; the M1–M5 mode framework; the phone/BTS capture family and its film-grammar kill; mode-driven anamorphic optics; and the end-state guidance folded into Action Timing.

**Stripped from upstream on the fold:** named-DP shorthand (style-by-proxy, against the behavioural-description doctrine, and it imports a real person's name into client-facing output); the brand-name inversion in House Rules (studio policy is prohibition with an authorised override); and the renumber-on-change reference rule (moot under tag matching).
<!-- STUDIO-LOCAL END -->

Every prompt is a production document. Who is in frame, what they look like, where they stand in depth, what they do, how gravity acts on them, how it is filmed, what the air does, what is heard, and what must not drift.

**The model is a physics engine, not a mood board.** It renders what it can see, count, and weigh. Mood words evaporate.

**If a word does not produce a visible pixel or an audible sound, cut it.**

<!-- STUDIO-LOCAL BEGIN: core philosophy — the "editorial, not commercial" line is load-bearing for the routing boundary with seedance-commercial-director; upstream has no equivalent. -->
**House register.** No plastic. No commercial gloss. No LED-panel-on-a-soundstage energy. No Instagram sharpness. Every frame reads as captured on a real camera operated by a real body — film-emulated, imperfect, analog warmth in the highlights, blacks that hold detail. Editorial grade, not commercial grade. Glass with character. Real fabric, real skin, real air, real grain. A brief whose purpose is to sell or showcase a product belongs to `seedance-commercial-director`, not here.
<!-- STUDIO-LOCAL END -->

---

## STEP ZERO — TARGET VERSION CHECK

**Establish the target engine before writing a single block.** Two hard ceilings differ between versions, and both change the architecture of the prompt, not just its trim.

| | Seedance 2.0 | Seedance 2.5 |
|---|---|---|
| **Image references** | 9 maximum | 50 maximum |
| **Maximum runtime** | 15 seconds | 30 seconds |

**If the user has not stated the version, ask once, in one line, before prompting.** Do not guess. A 2.5-shaped prompt fed to 2.0 loses references silently and truncates; a 2.0-shaped prompt on 2.5 leaves half the identity budget unspent.

Once stated, it holds for the session unless the user changes it.

### What changes on 2.0 (9 refs / 15s)

Reference slots are scarce, so every slot is contested. Characters first in narrative order, then one shared group wardrobe sheet, then props, then the environment plate, then video or audio last. Collapse where you must: a prop that only needs to read approximately can live inside a character's Asset description instead of taking a slot. Anything past 15 seconds splits into two prompts.

### What changes on 2.5 (50 refs / 30s)

Reference slots stop being scarce, which changes strategy rather than just raising a number:

- **Multi-angle identity.** A character can carry a front reference, a profile, and a detail plate rather than one composite sheet. Identity holds far harder across a long take.
- **Wardrobe, prop and environment references separate cleanly.** No more collapsing a prop into a character line.
- **Every group member gets an individual reference** instead of sharing one corps wardrobe sheet.

**More references is not automatically better.** Every reference must do distinct work. Near-duplicate references blend and produce an averaged face, and a cluttered reference set drifts worse than a tight one. If two references would teach the model the same thing, ship one.

**Long-form 2.5 (16–30s) needs extra anti-drift weight**, because drift compounds with runtime:

- One **anchor reference** held and named across every beat
- The **lens lock declared at the top of every beat**, not just at the head of the prompt
- **Geometry Map restated** at any point the staging materially resets
- **Locks carries the full ordered chain**, every link, no abbreviation

**Runtime available is not runtime required.** A 30-second ceiling does not mean 30-second prompts. Two camera vantages on the same action are still two prompts on 2.5 — that split is about coverage, not about the cap.

---

## WRITE THE VISIBLE

| Instead of | Write |
|---|---|
| she looks stressed | shoulders lift, jaw locks, exhales through the nose, eyes fix on the door |
| the alley feels dangerous | one buzzing bulb 30 metres back, wet brick, standing water, no other figures |
| fast chase | carves through traffic at 110 km/h, leg dragging outside the lane line on turn-in |
| she looks tall next to him | she stands 183cm to his 168cm |
| heavy mech | five-ton mass, cratering the ground on landing |

**Measurables the model reads:** speed in km/h · height in cm · mass in kg or tons · atmosphere as density plus named depth planes · direction as screen-relative or character-relative (always labelled) · emotion rendered in muscle · contact rendered as deformation.

<!-- STUDIO-LOCAL BEGIN: negation-battery index — pointer-only, so the sanctioned-negation doctrine survives the flip without restating any list that the source-bound vapour rule has superseded. -->
**Positive default, sanctioned negations.** Default to stating what happens, not what must not. Negative language usually weakens the signal — the model sees the noun and rounds toward it. Five negation batteries are sanctioned because positive phrasing does not fix the failure they suppress, and each lives in exactly one slot: the cadence battery (slot 2) · on-screen text suppression (slot 3) · the population lock, when a scene must be empty (slot 4) · the vapour-shape negations, under the source rule (slot 11) · the closing realism tail (slot 16). Everywhere else, ship positive.
<!-- STUDIO-LOCAL END -->

---

## LENGTH DISCIPLINE

A four-shot sequence with four assets lands at **900–1,400 words**. Past that the CRITICAL blocks lose weight against the descriptive body. Every line is a lock, not a flourish.

**Every fact lives in exactly one slot.** Wardrobe lives in Assets and is never re-described in Action Timing — Action Timing names a garment only when it is doing something visible (a hem swinging, hair whipping clear). Light lives in slot 10. Atmosphere lives in slot 11. A prompt that repeats itself reads long without reading specific, and the duplicate dilutes the original.

---

<!-- STUDIO-LOCAL BEGIN: M1–M5 mode framework — dropped upstream but load-bearing across two personas, three research briefs and the Banana Pro handoff, which cites "the same five-mode framework" by name. -->
## MODE SELECTION (INTERNAL ONLY)

Five modes govern optics, movement, diffusion, grade and palette. **The mode is never written into the prompt.** Seedance and Higgsfield do not read it. It is a selection tool that decides what the other slots say.

| Mode | Use when | Optics | Movement | Grade |
|---|---|---|---|---|
| **M1 Narrative** | Real-world dramatic — streets, interiors, sets, lived-in anywhere | Anamorphic | Handheld with operator breath | Colour-negative, fine 35mm grain, teal-amber |
| **M2 Studio** | White void, clean studio, editorial, fashion film, portrait | Spherical | Locked-off or slow push | Saturated editorial, warm-retained blacks |
| **M3 Action** | Combat, chase, stunts, debris, smoke | Anamorphic | Handheld and hard throughout | Heavier low-light grain, dusty air |
| **M4 Performance** | Stage, arena, lipsync, singing, choreography to camera | Anamorphic | Mixed handheld pit and orbital, hard cuts | Stage colour cast, streak flares, heavy air density |
| **M5 Atmospheric** | Environment plates, mood, bodies-as-texture, no dialogue | Anamorphic | Locked-off, slow push, or wide roaming | Palette-driven, atmospheric |

Once selected, the mode expresses itself through the optics family in slot 8, the camera register in slot 9, the grade language in slot 10 and the air density in slot 11 — never through a label.

**No mode selected is a legitimate state.** When the brief does not resolve to a mode, fall back to the house spherical default in slot 8 and deduce the camera register from the description as normal. Never invent a mode label to fill the gap, and never write one into the prompt either way.
<!-- STUDIO-LOCAL END -->

---

<!-- STUDIO-LOCAL BEGIN: two capture families — Family B is advertised in the skill description and BTS clips are a real studio deliverable type; upstream ships only the cinema stack. -->
## THE TWO CAPTURE FAMILIES

Every prompt is written in one. The user picks; do not switch mid-prompt unless they ask.

### Family A — CINEMA CAPTURE

The house default, and the one the SLOT 2 Style Prefix below is written for. Native 24 fps, true 180-degree shutter, real 1/48 second exposure on every frame. Genuine photographic motion blur. Shallow depth of field on the face. Colour-negative rendition with fine organic grain. Handheld with real operator body weight unless locked-off is deduced or requested.

### Family B — PHONE / BTS CAPTURE

**Family B replaces the entire SLOT 2 Style Prefix stack — all five labelled lines — not just the Texture and Technical lines.** Upstream's Style Prefix is an invariant that mandates organic film grain, large-format capture and a photochemical look, and every one of those contradicts phone capture. Swapping two lines and leaving Style and Operating style intact ships a self-contradicting prompt. Write the phone stack in the same slot, at the same priority, in the same labelled-line format:

```
Style: 8K, photorealism, modern smartphone capture, high dynamic range, phone HDR tone-mapping. NOT a 3D render, NOT a game engine, NOT a game-cutscene aesthetic, NOT a cartoon.

Operating style: handheld phone footage, arm's-length framing, behind-the-scenes immediacy, casual reframing and re-aiming, screen-referred look.

Texture: digitally sharp with heavy edge sharpening and high micro-contrast, fine digital luminance noise, lifted milky shadows, compressed highlights, no deep blacks, slightly overcooked saturation.

Skin: pore-level realism — visible pores, fine vellus hair, natural asymmetry, no smoothing, no retouching, phone-sharpened rather than film-soft.

Technical: 8K, native 30fps, fast electronic shutter — motion crisp and slightly clipped, not softly blurred. Deep phone depth of field. Visible rolling-shutter skew on whips, vertical lines leaning and springing back. Aggressive automatic exposure that visibly hunts and pumps. Automatic white balance shifting between zones. Hard clean digital flare with tight star points. Stepped digital zoom when magnifying. Smooth stable motion, no flicker, no warping, no morphing, no frame interpolation, no frame blending, no ghosting, no double-imaging.
```

**Every phone prompt carries the film-grammar kill**, appended to Technical: *no anamorphic character, no oval bokeh, no horizontal streak flares, no film grain, no colour-negative rendition, no cinema camera look, no 24fps cadence, no 180-degree shutter blur, no shallow cinema focus, no cinematic grade.* Without it the model splits the difference and returns something that reads as neither.

Family B also inverts several items in the slot 16 negation tail and takes its own audio physics in slot 15. Both are noted in those slots.
<!-- STUDIO-LOCAL END -->

---

<!-- STUDIO-LOCAL BEGIN: element-tag grammar — the studio's reference scheme; replaces upstream's numbered @Image/@Video index end to end, including the renumber-on-change rule, which is moot under name matching. -->
## ELEMENT TAGS (REPLACES NUMBERED IMAGE/VIDEO REFERENCES)

Every prompt uses tag names the user supplies — not a renumbered numeric image/video index. **Never invent tag names on the user's behalf.** Writing an Asset line without a named tag and an attached reference is a category error.

**Tag naming rules:**
- Lowercase, underscore-separated, descriptive: `@sol_ref`, `@daye_ref`, `@berlin_bunker_plate`, `@white_camaro`, `@rain_plate`
- Prefixed with `@` inside the prompt body
- Named for what the element *is*, not what number it loads in
- Character references use a `_ref` suffix. Environment plates use `_plate`. Objects, vehicles and props use a descriptive noun. Audio and video references use a descriptive tag naming the source — `@vocal_take`, `@dance_ref`

**Asking for tags.** If the user has not named tags for this scene's references, ask before writing the prompt: "What tag names do you want to use for the references in this scene? (e.g. @sol_ref for the character reference, @rain_plate for the environment plate)."

**Session carry-forward.** Once tags are locked for a session, carry them forward — the user will not re-name the same character reference on every prompt. If `@sol_ref` was named in prompt 1, it stays `@sol_ref` for the rest of the session.

**Reference-count ceiling — version-gated.** The old flat "roughly nine uploaded references" ceiling was a fact about Seedance 2.0, not about tag grammar. Under STEP ZERO it reads: **≤ 9 tagged references on 2.0, ≤ 50 on 2.5.** On 2.0 the ceiling still bites, so collapse anything that only needs to read approximately into a neighbouring Asset line, or split into a multi-shot sequence. On 2.5 the ceiling stops rationing and the binding constraint becomes distinctness — every tag must teach the model something no other tag teaches.

**Ordering is moot on both versions.** Seedance matches by tag name, never by list position, so there is no index to renumber and no stale index to leave behind. The narrative order of the tag list is a reading convenience for the human operator, nothing more. Every tag named in the tag list must still appear at least once inline in the code block.

**Where tags go in the prompt:** the head of each Asset line in slot 5 (`@sol_ref = 177cm, …`), the location asset and its reference-scoping clause (`@rain_plate = the location — …`), the Geometry Map when a figure needs naming past its visual descriptors, the First Frame composition call (`open on the composition of @rain_plate exactly`), the Locks chain, and the Audio sole-source line (`the attached clip @vocal_take is the sole and complete audio source`).

**Canonical-over-plate rule (HARD LOCK).** Every named subject that appears in a scene gets its canonical reference tagged separately — even if that subject is also visible in the rendered environment plate. Characters, vehicles, props, creatures, animals: anything with locked identity that has to hold across the cut gets its dedicated tag, no exceptions. The plate carries the world (location, geography, materials, weather, light direction, set dressing, composition); canonical references carry identity (face, body, livery, markings, silhouette). Character and object Asset lines anchor to canonical tags; the location Asset line anchors to the plate tag and is scoped to world only. This replaces upstream's weaker "every character gets its own slot even if visible inside the environment plate" statement rather than sitting alongside it — the hard lock is the operative rule, and it is what prevents identity drifting from the plate into the render.
<!-- STUDIO-LOCAL END -->

---

## DELIVERY

Three parts, nothing else:

1. **Bolded title with runtime** — `**Underground garage — entry walk — 8s**`
2. <!-- STUDIO-LOCAL BEGIN: tag-list delivery format — replaces upstream's numbered attach-order list, which the element-tag grammar makes meaningless. --> **Tag list** — one line per reference, as a bulleted list, never a prose paragraph. Attach order is a convenience, not a spec; the ceiling is version-gated (≤ 9 on 2.0, ≤ 50 on 2.5, plus one video or audio slot).

```
- @sol_ref — [what it is]
- @rain_plate — [what it is]
- @vocal_take — [what it is]
```
<!-- STUDIO-LOCAL END -->
3. **One fenced code block** containing the whole prompt, English only

No preamble, no post-amble. Flag a conflict in one or two lines above the title if one exists.

**A NEGATIVE PROMPT block ships as an optional second code block** — only when the scene has a known drift risk (mixed character designs, locked spatial geometry, identity swaps) or when asked. Group it by failure category, comma-separated, no sentences.

**Iterations deliver directly.** Any tweak to an approved prompt — palette, framing, pose, lens, lighting, wardrobe, staging, duration — ships as the revised full prompt, no confirmation bullets. Re-check only on full scope change: new scene, new character set, new capture family.

**Always ship the full prompt.** Never partial swaps or "replace this line" unless a targeted patch is requested.

**Split rather than overload.** Two camera vantages on the same action are two prompts regardless of version. Anything past the target's runtime ceiling — 15s on 2.0, 30s on 2.5 — is two prompts. Say so and deliver both.

<!-- STUDIO-LOCAL BEGIN: foreign-language script handoff — a studio delivery convention with no upstream equivalent; upstream covers the on-screen half via THE LANGUAGE but not the translator-facing script. -->
**Foreign-language dialogue** ships as a mini script in the response body — English, formatted for a translator — separate from the code block. Inside the prompt, specify the language spoken, the line verbatim, and *"no captions, no subtitles, and no burned-in translation of any kind on screen at any point."*
<!-- STUDIO-LOCAL END -->

---

## THE SPINE (LOCKED ORDER)

```
1.  HEADER              shot count · runtime · timecodes · cut policy · speed policy
2.  STYLE PREFIX        the invariants — style, operating style, texture, skin, technical
3.  NO ON-SCREEN TEXT   mandatory, always here, never lower
4.  CRITICAL BLOCKS     scene-specific, cap 4
5.  ASSETS              @tag = identity + THIS SCENE action + fidelity assertion
6.  GEOMETRY MAP        absolute frame position and depth planes
7.  FIRST FRAME         what is already happening at frame one
8.  OPTICS              lens lock in FOV degrees, per shot
9.  CAMERA              physicality register and behaviour
10. LIGHT & COLOUR      direction, quality, temperature + the percentage doctrine
11. ATMOSPHERE          air density, depth planes, source-bound vapour
12. ACTION TIMING       timecoded beats, hard cuts inline
13. PHYSICS             mass, deformation, rebound, lag, contact
14. ACTING              face, eyes, brow, liveness
15. AUDIO               diegetic default, or attached-track sole source
16. LOCKS               positive ordered chain of what must hold
```

No mode label. No prose between blocks. No aspect ratio.

---

## SLOT 1 — HEADER

```
4 shots. Total 8 seconds — shot 1 runs 0.0–2.0s, shot 2 runs 2.0–4.0s, shot 3 runs 4.0–6.0s, shot 4 runs 6.0–8.0s. Hard cuts between them, no transitions, no dissolves. All shots real-time, no slow motion, no overcranking, no ramping, no speed change anywhere in this sequence.
```

Single take: `1 continuous shot. Total 10 seconds, no cuts, no transitions. Real-time throughout.`

Timings sum exactly. **Maximum 15 seconds on 2.0, 30 seconds on 2.5.**

Runtime guide: 1.5–2.5s per shot for high-energy cutting · 2.5–4s for narrative and dialogue beats · 4–7s for a held lipsync line · 8–15s for a continuous take.

**Past 15 seconds (2.5 only), the header also declares the shot budget** so the model does not compress the whole sequence into the first third: `9 shots across 24 seconds` reads very differently from `24 seconds`. Long sequences hold better when built as a chain of 2.5–4s beats than as one unbroken take.

**Slow-motion accents are carved out explicitly**, both where they land and in the closing clause: `Brief slow motion on the impact only, 2.0–2.5s. All other footage real-time.`

If cuts must never land mid-word: `the cuts fall between words and never inside a word.`

---

## SLOT 2 — STYLE PREFIX

The invariant capture stack. Labelled lines, front-loaded, never restated later.

```
Style: 8K, photorealism, real organic film grain and halation, high dynamic range, shot on large-format film. NOT a 3D render, NOT a game engine, NOT a game-cutscene aesthetic, NOT a cartoon, NOT anime cel-shading.

Operating style: large-scale realism with intimate handheld closeness, immersive in-camera feel, tactile textures, shallow depth of field on the face, documentary framing, photochemical look.

Texture: matte non-reflective surfaces, lived-in worn materials, organic 65mm film grain, no digital gloss, no plastic sheen.

Skin: pore-level realism — visible pores, fine vellus hair, natural asymmetry, no smoothing, no retouching. Half the face often falls into shadow.

Technical: 8K, real-time 24fps, true 180-degree shutter with a real 1/48 second exposure on every frame, genuine photographic motion blur, each frame blending smoothly into the next. Smooth stable motion, no flicker, no warping, no morphing, no frame interpolation, no frame blending, no ghosting, no double-imaging, no high-shutter video crispness.
```

**The render quad is mandatory and always four items:** `NOT a 3D render, NOT a game engine, NOT a game-cutscene aesthetic, NOT a cartoon.` Add `NOT anime cel-shading` when the material is stylized enough to invite it.

**The cadence clause lives in Technical and nowhere else.** It is the single most important anti-artifact instruction in the prompt, which is why the Style Prefix sits second.

<!-- STUDIO-LOCAL BEGIN: Family B pointer — the stack above is a Family A invariant, and phone/BTS capture must replace it wholesale rather than inherit it. -->
**This stack is the Family A (cinema) form.** On a phone or BTS prompt, all five lines are replaced by the Family B stack, and the film-grammar kill is appended to Technical. See THE TWO CAPTURE FAMILIES above. Never mix the two stacks — a Family B prompt carrying "organic 65mm film grain" or "photochemical look" contradicts itself and the model averages the difference.
<!-- STUDIO-LOCAL END -->

**Strobe quarantine.** When the scene contains strobe or hard flashing light, append to Technical:

```
The stepped, stuttering quality of this sequence comes entirely from the strobe lighting described below — from bodies revealed only in discrete flashes — and never from broken or choppy footage. The camera motion between flashes stays continuous and smooth even while bodies appear to jump between positions.
```

Without the quarantine the model returns genuinely broken footage.

<!-- STUDIO-LOCAL BEGIN: replaces stripped upstream :169 per the decision-ledger rejection of style-by-proxy — named-DP shorthand is imprecise and puts a real person's name into client-facing output. -->
**Describe the look behaviourally, never by proxy.** No named director-of-photography shorthand, no named film titles, no named campaigns — state the large-format realism, the handheld closeness, the in-camera feel and the photochemical rendition as behaviour, in the lines above. Style-by-proxy is imprecise and puts a real person's name into client-facing output.
<!-- STUDIO-LOCAL END -->

---

## SLOT 3 — NO ON-SCREEN TEXT

Mandatory in every prompt, always in this position. Overlay text is generated early in the frame, so the instruction sits early.

```
NO ON-SCREEN TEXT — CRITICAL: no on-screen text of any kind anywhere in frame at any point. No captions, no subtitles, no burned-in dialogue, no auto-captions, no karaoke text, no lower thirds, no titles, no title cards, no credits, no watermarks, no logos, no timecode, no UI overlays, no social-media overlays, no interface elements, no Chinese characters, no Korean characters. The frame is clean of all overlay graphics from first frame to last.
```

**Never carve out in-world text inside this block.** No "other than," no "except for." An exception clause reopens the door and captions return. Physical text that genuinely exists in the scene — garment prints, packaging, signage, a split-flap board — is described separately in Assets or Geometry Map as a physical object with shape, colour, placement and legibility.

Weight it hardest on phone, selfie and talking-head prompts, which pull captions straight from social training data.

---

## SLOT 4 — CRITICAL BLOCKS

Any element the model routinely drops, softens or gets wrong is promoted out of the descriptive body into its own ALL-CAPS named block here.

Format: `THE [THING] — CRITICAL:` followed by one exhaustive paragraph.

| Block | Use when |
|---|---|
| `THE SINGING` | any lipsync — first block, top content priority |
| `THE MOUTH IS ALWAYS VISIBLE` | any lipsync, paired with the above |
| `THE GEOMETRY` | a spatial relationship must not invert (above/below, inside/outside) |
| `THE STAGING` | who stands where must not drift |
| `THE STROBE` / `THE LIGHT CHANGE` | flashing, pulsing, or lighting that shifts mid-take |
| `TWO DISTINCT DESIGNS` | two similar objects or characters that must never merge |
| `NOBODY ELSE IS IN THE FRAME` | any scene that must be empty of extras |
| `EVERYONE IS LIVE` | dialogue or group scenes where backgrounded bodies freeze |
| `THE TONE` | comedic or emotionally specific scenes that could be misread |
| `THE LANGUAGE` | foreign-language dialogue |
| `THE BEAT` | the dramatic point of the shot is a specific reversal |

<!-- STUDIO-LOCAL BEGIN: two extra block types carried from the studio's own table; both address failures this pipeline hits and neither has an upstream row. -->
| `THE CAMERA` | when the camera behaviour is itself the style of the piece |
| `THE VANTAGE` | when camera distance or position must not creep across the cut |
<!-- STUDIO-LOCAL END -->

**Cap at four.** Past that they compete and all of them dilute. Order by importance — early text carries more weight.

Each block is exhaustive within itself. Never split one idea across two. **The block is the instruction; downstream slots only apply it.** Never restate a CRITICAL block in full further down.

---

## SLOT 5 — ASSETS

Every asset is one line: **tag, permanent identity, THIS SCENE action, fidelity assertion.** This merges what used to be a separate identity lock and per-shot action line into a single non-repeating unit.

```
@daye_ref = 177cm, dark bob with blonde balayage ends, centre part, warm fair skin. Navy short-sleeve polo, grey micro-shorts, olive suede wide belt, barefoot. Clean clear face, no beauty marks, no facial markings. Voice strict and focused, mezzo-soprano. THIS SCENE: seated centre of the sofa, speaking, irritation sliding into teasing surprise. 100% match to the reference.
```

**Target 60–110 words per character asset.** Tight enough that five assets don't swamp the prompt.

**Identity components, in order:** height in cm · build and skin · face and bone structure · hair colour, length, styling · permanent markers · makeup · clean-face negations · wardrobe head to toe, one clause per garment · jewellery and nails · voice descriptor · THIS SCENE · fidelity assertion.

**Wardrobe is restated every prompt but written economically.** One clause per garment: colour, fabric, cut, how it sits.

- ❌ *a long-sleeved charcoal-grey cropped top in soft washed matte jersey with a faded mineral-dyed finish, high round neckline, long slim sleeves fitted to the wrist, hem sitting just below the ribcage, the back left open*
- ✅ *a cropped charcoal washed-jersey long-sleeve, high round neck, open back, hem just under the ribcage*

**Permanent features are declared permanent** — `the blunt bangs are permanent and present in every frame`.

**State-conditional identity is declared with its state and its reason** — `no horns in this scene, omit them entirely for continuity, horns are battle-state only`. This prevents the model splitting the difference.

**Known-drift attributes get an inline anti-drift negation** — `BROWN eyes, never blue, never green`.

**Clean-face negations are explicit.** The model invents facial detail otherwise.

**Skin lock:** warm fair or as specified, `rendering true and natural, never cool-shifted, never pale porcelain, never tan`.

**Reference scoping.** State what a reference governs and what it does not:

```
@ruined_city_plate = the location — high-walled ruined city canyon, decayed grey towers, collapsed slabs, debris-littered ground. Controls geography, materials, atmosphere and light direction only.
```

**Group and crew assets** get one shared block: the full uniform, the permitted variation range (`some wear a sheer mesh layer, some have bare arms`), and the anonymity lock (`every masked face identical in styling, no dancer ever unmasked`).

<!-- STUDIO-LOCAL BEGIN: plain-crew wardrobe clause carried from the studio's Crew Lock; upstream's group block has no equivalent. -->
Where a crew wardrobe should read plain and anonymous, close the group block with `no branding, no printed graphics, no visible text on any garment` — a styling choice for that scene, not a standing rule.
<!-- STUDIO-LOCAL END -->

**Prop assets** carry material, scale relative to a hand or body, hardware, finish, how it is held. Scale is the one that fails: `a 20cm combat knife, noticeably shorter than the mech's 40cm forearm — it reads short, not a sword`.

**Reference reading order:** characters first in narrative order, then group wardrobe sheet, then props, then environment plate, then video or audio last.

<!-- STUDIO-LOCAL BEGIN: replaces upstream's renumber-on-change rule and its weaker plate statement — both are superseded by tag matching and the canonical-over-plate hard lock. -->
**Ordering carries no index, so nothing renumbers.** Tags match by name; the sequence above is a reading order for the human operator. Every named subject still gets its own canonical tag under the **canonical-over-plate HARD LOCK** above — the plate carries world, the canonical carries identity, no exceptions.
<!-- STUDIO-LOCAL END -->

**On 2.0 the ordering is a rationing scheme** — nine slots, so collapse anything that only needs to read approximately into a neighbouring Asset line. **On 2.5 it is purely a reading order**, and characters can carry multiple angles each.

---

## SLOT 6 — GEOMETRY MAP

Where everything sits in the frame and in depth. **This is the block that stops bodies drifting between cuts.**

```
GEOMETRY MAP: on the dark-green L-sofa — the woman with the black hair and brown eyes on the LEFT, the woman with the dark bob in the MIDDLE, the woman with the ashy-blonde shag on the RIGHT. A beanbag pouffe front-right, in front of the blonde. Windows and corkboard on the wall behind, thrown soft. Depth planes: sofa foreground, standing figure mid-ground, window wall background.
```

**Three things every geometry map states:**

1. **Absolute lateral position** — LEFT, MIDDLE, RIGHT, and what is off-frame in which direction
2. **Depth plane per subject** — foreground, mid-ground, background, and which planes are sharp and which fall soft
3. **Vertical relationship where it matters** — ABOVE, BELOW, inverted, suspended, and never let it invert

**Screen-relative and character-relative direction are always labelled.** `she turns to her OWN right` is not `screen-left`. Pick one per instruction and name it; unlabelled direction inverts about half the time.

<!-- STUDIO-LOCAL BEGIN: percentage frame-mapping — the studio's frame-map convention for asymmetric compositions; upstream states thirds only. -->
**Percentage precision is available and preferred on asymmetric compositions.** Where thirds language is too coarse, place subjects by x% (and y% where height matters) across the frame and state what fills the rest — `the standing figure at x 22%, the seated pair at x 55% and x 72%, the remaining right third empty wall`. Use film language for classical compositions and percentages for asymmetric ones; do not mix the two inside one map.
<!-- STUDIO-LOCAL END -->

**Naming who the frame favours resolves ambiguous framing** — `three-quarter angle, off-centre, favouring the woman in the middle`.

**A locked spatial relationship gets promoted to a CRITICAL block** and defended in the negative prompt. Vertical inversions and above/below pairs are the most drift-prone geometry there is.

**Scatter over lines.** When several figures share a frame, place them at different depths rather than side by side: `scattered at different depths, NOT in a row`. Line-ups read as posed group photos.

---

## SLOT 7 — FIRST FRAME

One or two lines. What is already happening at frame one.

```
FIRST FRAME: already mid-sprint toward the first creature, blade in hand, the others spread around at different depths. No empty establishing frame, no static hold before the action starts.
```

The empty establishing frame is a default the model volunteers and it costs half a second of an eight-second clip. Kill it explicitly. When the reference plate is the intended opening composition, say so: `open on the composition of @ruined_city_plate exactly, already in motion`.

---

## SLOT 8 — OPTICS

<!-- STUDIO-LOCAL BEGIN: mode-driven optics — four of the studio's five modes prescribe anamorphic, so upstream's blanket spherical default applies only when no mode is selected. -->
**Optics follow the mode.** M1, M3, M4 and M5 are anamorphic families: vintage 2x anamorphic character at a wide aperture — oval bokeh, horizontal streak flares, halation bloom, shallow depth of field. M2 Studio is spherical large-format. State the family once here and let the closing Locks carry it; never stack two families in one prompt.

**When no mode is selected, the house fallback is spherical large-format.** Clean glass — natural halation around highlights, creamy focus falloff, subtle lens breathing, natural 180-degree motion blur. **No anamorphic streak flares, no oval bokeh, no artificial flares, no fisheye** unless the user asks for anamorphic by name. Under the fallback, anamorphic is opt-in per prompt.

Family B (phone/BTS) overrides both: phone optics, deep depth of field, hard clean digital flare, and the film-grammar kill that explicitly bans anamorphic character and oval bokeh.
<!-- STUDIO-LOCAL END -->

### FOV degree anchor

The model latches onto **degrees** as a snap value; millimetres read as suggestion. Write the degree first, mm in parentheses. Never use an off-ladder value.

| FOV | mm | Feel | Use for |
|---|---|---|---|
| 180° | fisheye | spherical bulge | POV, dream state, hallucination |
| 107° | 14–16mm | architectural ultra-wide | vast interior scale, epic establishing |
| 84° | 20–24mm | classic wide | full-body blocking, immersive action, environmental establish |
| 63° | 28–35mm | reportage wide | observational, walking alongside, doc feel |
| 47° | 40–50mm | eye-level neutral | universal medium, two-shot, waist-up |
| 34° | 60–70mm | short tele | compressed group, stacked depth planes |
| 29° | 75–85mm | portrait compression | isolated bust, detail on hands, tight coverage |
| 18° | 100–135mm | portrait tight | identity-hold close-up, held emotional beat |
| 12° | 180–200mm | tele detail | hand insert, object close, jewellery, texture |
| 8° | 300–400mm | extreme long lens | anchored-far observation, watchtower |

### Lens lock per segment

```
LENS LOCK SHOT 1 = 84° (22mm) classic wide, low, the sprint immersive.
LENS LOCK SHOT 2 = 29° (80mm) short telephoto, detail on the hands.
LENS LOCK SHOT 3 = 47° (50mm) standard normal, side angle, the swing readable.
No focal drift mid-shot.
```

**Unusual FOVs need a defense battery.** A long lens will be averaged back toward a normal unless you name what it is not:

```
This is a LONG lens — strong telephoto compression, flattened perspective, background pulled in close and thrown soft, only one to three faces sharp at a time, tight crop. NOT wide-angle, NOT large-format coverage, no fisheye, no edge distortion, no deep focus, no full-room coverage.
```

Same in reverse for ultra-wide. **Extreme FOV across several beats drifts fastest** — declare the FOV at the top of every beat, repeat it in Locks, and hold one anchor reference across every beat.

---

## SLOT 9 — CAMERA

Pick one register and hold it. Register governs cant, cut rate, and how much of the frame is allowed to be still.

| Register | Cant | Cuts | Language | Frame |
|---|---|---|---|---|
| **Locked-off** | 0° | 1–2 shots or a oner | tripod-weighted, or an extremely slow push | long held frames, stillness is the subject |
| **Gentle handheld** | 3–10° | 3–5 shots, 2.5–4s | floating, drifting, riding breath, small organic corrections | frames settle and hold before moving on |
| **Heavy handheld** | 12–25° | 4–6 shots, 1.5–2.5s | jolting, bobbing, lurching, snapping corrections, high-frequency vibration underneath | every frame mid-move, the eye can still land |
| **Violent handheld** | 25–45° | 4–6 shots, 1.5–2s | punching in and ripping back, whip-pans, hard surges, violent corrections | nothing settles, the frame never lands |

<!-- STUDIO-LOCAL BEGIN: dynamic-register ladder — the studio's tier vocabulary maps one-to-one onto upstream's registers and is what the mixed-register rule below refers to by number. -->
**Dynamic register (energy dial).** Mode says *what kind of scene*; register says *how hot the camera runs*. The studio's four tiers map one-to-one onto the table above: **Tier 1 Composed** = locked-off · **Tier 2 Elevated** = gentle handheld · **Tier 3 Kinetic** = heavy handheld · **Tier 4 Violent** = violent handheld. Set the tier before writing a single slot — it changes every downstream choice.

Ambiguous cases are real: a character walking into a room could be Tier 1 dread or Tier 4 arrival. When the description genuinely supports two tiers, ask once, in one line, offering only the two that actually fit — *"Reading this two ways — is it composed and held, or do you want the camera hot and punching?"* Never ask when the description has already answered, and never offer all four when only two are live.
<!-- STUDIO-LOCAL END -->

**Deduce the register from the description; ask only if genuinely split.** Toward locked-off and gentle: grief, memory, waiting, ritual, solitude, portrait, dialogue that matters, "quiet," "still," "slow," "elegant." Toward heavy and violent: a beat drop, choreography, a chase, a fight, a crowd, a crash, a named BPM, "chaotic," "aggressive," "hard," "go crazy."

**Every register except locked-off closes with:**

```
never locked, never stabilized, never mechanically smooth, never gimbal-glide, never floaty drone — real shoulder-mounted mass, weight shifts, breath, human over-correction, every frame mid-move but always smooth and continuous in its own travel.
```

That last clause is load-bearing. Without it, violent handheld returns broken footage rather than energetic footage.

**Dutch cant is a swinging range in degrees** plus `never passing through level, never settling square`.

**Roaming coverage** — a camera that physically travels between subjects — is stated as an explicit behaviour with what it snaps to: `roams between them and zooms onto details, snapping to a singing mouth, a jumping pair of legs, flailing hands, a laughing face, then drifting to the next`.

**A Tier 1 subject inside a Tier 4 camera is a real choice** — a still figure while the camera tears around her. State the split explicitly so the model does not average the two.

---

## SLOT 10 — LIGHT & COLOUR

**Light is described by direction, quality and temperature. Never by fixture name.** No named lamps, no stock codes, no LogC4, no IRE.

```
LIGHT: motivated natural light, one soft key from camera-side and above, soft roll-off, faithful skin tones, no heavy grade. Cool daylight counter-note from the windows behind. Half-faces rolling through shadow as they move.
```

### The colour accent doctrine

Percentages, each nailed to a physical source. This allocates frame area, which a bare palette list does not.

```
COLOUR: ~70% desaturated green-grey room tone and raw concrete; ~20% warm orange-yellow accent from warm daylight and the warm ceiling wash through the netting; ~10% cool daylight blue as a counter-note from the windows.
```

Three bands, roughly 70 / 20 / 10. **Every band names its source.** A colour with no source in frame will not render.

State where blacks sit, what blooms, what flares specular, what holds saturation. Attach every colour to a fabric, a surface or a light source.

---

## SLOT 11 — ATMOSPHERE

**Air is always present. Vapour is always source-bound.**

Real air at real density, filling the entire frame including the foreground — a continuous scattering gradient from lens to horizon, blacks lifted at every depth, high micro-contrast inside the lift.

```
ATMOSPHERE: the air carries real density at every depth — a continuous scattering gradient from the lens to the far wall, blacks lifted at every plane, depth reading in clearly separated layers: [name the actual planes of this shot, nearest to furthest, and how each softens]. Razor skin and fabric texture up close, heavy grain inside the lifted shadows, natural bloom at point light sources. Low macro contrast, high micro contrast. Bodies pass through the air without disturbing it, leaving no wakes and no trails.
```

### The source rule

**Visible vapour shapes only exist when something in frame is physically making them.** Named source, named emission, and nothing anywhere else.

- ✅ *a lit cigarette in her left hand, a thin ribbon of smoke rising off the ember and dissipating within 30cm*
- ✅ *every footfall and impact blasts up dust that blooms and streams off in the wind*
- ✅ *breath condensing in the cold, visible on the exhale only*
- ✅ *steam lifting off the cup surface*

Without a source in frame, close the block:

```
No plumes, no banks, no tendrils, no wisps, no swirls, no rolling, no fog-machine texture, no smoke shapes, no volumetric shafts, no god rays. Nothing in the air is emitted by anything.
```

Naturally foggy exteriors are legitimate — cold morning fog, coastal haze, mist in a ruined city — and read as **uniform density and reduced visibility with distance**, not as shapes moving through frame. Write it as `thick cold fog holding at uniform density, visibility falling off with distance` and keep the shape negations.

**Clean-air scenes state it just as hard:** `the air is clean — no haze, no density, no visible beams, no suspended particulate, full clarity to the back wall`.

**Always name the actual depth planes of the actual shot.** Atmosphere is for depth separation, never for mood.

---

## SLOT 12 — ACTION TIMING

Timecoded beats. Hard cuts on their own line. Every visible body accounted for in every beat.

```
0.0–1.5s (SHOT 1, low charge-leap): sprints at 60 km/h toward the first creature and leaps, rising and driving down, blade in hand, dust torn up beneath.
1.5s HARD CUT
1.5–3.0s (SHOT 2, stomp): comes down and stomps one clawed foot onto the creature's head, crushing it into the ground — skull plate shattering, ichor bursting under the foot, rubble cratering, dust blasting up. Brief slow motion on the impact only, 2.0–2.5s.
3.0s HARD CUT
```

**Silence about a body means it drifts.** Every figure in frame gets an action in every beat, even if the action is small: `in the foreground she shifts and reacts, a small head turn, breathing, listening`.

**EVERYONE IS LIVE.** Backgrounded and foregrounded bodies freeze by default in dialogue scenes. State the counter explicitly: `nobody sits frozen, everyone is reacting throughout`.

**Each figure on her own clock.** For group energy: `each moves differently at her own random timing, deliberately messy, never moving as one`.

<!-- STUDIO-LOCAL BEGIN: end-state guidance — the one item taken now from the deferred net-new list, folded into ACTION TIMING rather than resurrecting the deleted Last Frame block. -->
**Never end a shot on an action beginning.** The final beat lands on a completed state — a body that has arrived, a hand that has closed, a head that has turned and settled — not on a motion the clip cuts away from mid-swing. Write the end state into the last beat: `ends on her weight settled, head turned to camera-left, breathing`. This pairs with SLOT 7 FIRST FRAME: the clip opens mid-action and closes on a state, never the reverse.
<!-- STUDIO-LOCAL END -->

**Dialogue is written verbatim in quotes**, with the emotional arc and the physical beat tied to the stressed word:

```
speaks to the woman beside her, lightly teasing without malice: "We've got HER, though." — clear stress on HER — and ON THAT WORD she turns her gaze to her OWN RIGHT and looks and nods directly toward the figure off-camera to her right, a pointed "right there — her" beat.
```

**Synchronized choreography** needs the unison lock plus the anti-mannequin clause: `every dancer hits the same shape at the same moment while carrying her own micro-timing, head angle and limb height inside the count, so the group never reads as identical mannequins`.

<!-- STUDIO-LOCAL BEGIN: contrast staging and shot naming — two studio conventions with no upstream row; both address failures this pipeline hits on performance work. -->
**Contrast staging** — slow figures against a hard-count corps — must state that the contrast is the point, and lock the slow figures with `never dance on the beat, never move sharply, never snap`.

**Beat labels take an ALL-CAPS shot name** that summarises the grammar of the shot in the parenthetical: `(SHOT 2, CLOSE ON THE HANDS, SLAMMING IN)` · `(SHOT 3, OVERHEAD, LOOKING STRAIGHT DOWN)` · `(SHOT 4, HIGH THREE-QUARTER, CRANING BACK AND OUT)`.
<!-- STUDIO-LOCAL END -->

**Name four motion layers, always**, even when one is "nothing else moves": character motion · micro-motion (breath, hair, fabric, jewellery) · environmental motion (water, particles, dust) · camera motion, which lives in slot 9.

**Hair and fabric as motion** is first-class on high-energy shots — hair whipping across faces and being pushed clear, fabric lifting and settling, chains swinging with real momentum. It reads as physical truth more than any body description.

---

## SLOT 13 — PHYSICS

True gravity. **The chain is always the same, scaled to the mass in play.**

```
1. Stated mass          — kg, tons, or bodyweight
2. Contact event        — foot lands, body hits, hand grips
3. Deformation          — the receiving surface gives: cushions compress, ground craters, fabric bunches
4. Rebound / recovery   — the surface returns, knees absorb, the body recovers
5. Secondary lag        — hair, loose fabric, cables, hydraulics trail the primary motion
6. Contact shadow       — where the body meets the surface, grounded
7. Closing negation     — nothing floats, nothing slides, nothing teleports
```

Bodyweight scale:

```
PHYSICS: real gravity, inertia and mass — weighted body movement, jumping with real impact and recovery, sofa cushions compressing and rebounding under the jumps, knees absorbing the landings, hair and loose fabric whipping with the motion, accurate contact shadows where feet meet floor and cushion. Nothing floats, nothing slides.
```

Heavy scale:

```
PHYSICS: real five-ton mass — the leap and stomp crush the head with crushing weight, cratering the ground; the swing carries weight into the carapace; the throw follows a true arc with the body's weight; kicks land with heavy follow-through. Hydraulic and cable elements lag the motion. Inside the cockpit the pilot's body and hair jolt with each strike. Bodies tumble with gravity, plates crack and splinter. Nothing floats, nothing teleports.
```

**Effort is physics.** Strain, exhaustion and struggle are rendered in the body, not asserted: `shaking arms, slipping grips, hands slip and catch, the body trembles, boots scrabbling for purchase, hard breathing`.

**Resistance is physics.** A thing that dies or yields does so over time: `it does not die instantly — it thrashes and resists, limbs clawing, before it finally goes limp`.

**Falling debris obeys gravity and is declared harmless** when it should be: `a scatter of pebbles and grit falls past her with real gravity; she is unharmed and keeps climbing`.

**Structures that must hold are declared to hold:** `the rig holds, no fall, no free fall, no snapping cable`.

---

## SLOT 14 — ACTING

```
ACTING: natural eye blinking throughout, active forehead and brow micro-expression, no frozen mask-face, no dead eyes. Forehead and eyebrow movement precisely matches the emotion of each line — brows up on the surprised peaks, scrunching down on the hard belts, foreheads alive throughout.
```

**Brow and forehead matched to the line is the single highest-yield acting instruction.** Faces go slack and generic without it.

**Eyelines are stated as targets** — `they look at each other, never into the lens`. Looking at camera is a strong default and must be suppressed explicitly in observational and documentary work.

**Emotional arcs inside a beat** are written as a slide, not a state: `first slightly irritated, then sliding into teasing surprise`.

**Physical performance negations** where relevant: no mouthed words, no singing, no teeth-baring, unless the scene calls for them.

---

## SLOT 15 — AUDIO

**Default: diegetic only.** Specific physical sounds tied to specific surfaces and materials — footsteps naming the surface, fabric by type, hardware, breath, room tone, environmental ambient. Close with `NO BGM — no background music, no lyrics, no score, no subtitles`.

### The NO BGM convention

**Write `NO BGM` — expanded once as "no background music" — rather than "no music".** The bare phrase "no music" reads as a weak stylistic preference and gets overridden by the model's strong prior that generated video wants a score under it. `NO BGM` is a production term and reads as a hard spec.

Expand it on first use in a prompt so the term is unambiguous, then let the abbreviation carry:

```
NO BGM — no background music of any kind. No score, no soundtrack, no instrumental, no underscore, no ambient musical pad, no drone, no tone bed, no swell, no sting, no humming, no singing, no whistling, no lyrics. Diegetic sound effects and room tone only. Nothing musical anywhere at any point.
```

**On a scene that must land silent, NO BGM is promoted to the header block**, alongside the shot count and the cut policy, not left to slot 15. Audio instructions carry more weight early, and by the time the model reaches the closing audio block it has already decided what the piece sounds like. Restate it in slot 15 as the closing clause.

**Name the specific musical forms it must not generate.** A bare negation leaves the model room to supply an "ambient texture" or a "tone bed" and consider the instruction honoured. The list above is the working set: score, soundtrack, instrumental, underscore, ambient pad, drone, tone bed, swell, sting, humming, singing, whistling, lyrics.

Never write song references, lyrics, or track-tied dialogue. Music is uploaded separately as an audio reference.

**Attached-track lock — HARD.** When an audio or video track is attached it is the sole and complete audio source:

```
AUDIO: the attached clip @vocal_take is the sole and complete audio source for this sequence. Generate no additional audio of any kind — no room tone, no foley, no ambience, no breath, no added dialogue, NO BGM.
```

The attached clip also owns all internal timing. Never impose per-beat timing on a lipsync take.

**The unheard-track technique** lets bodies sing with NO BGM in the mix:

```
AUDIO: NO BGM in the mix — no background music, the track is not audible. Only the voices, loud and a little off-key, singing roughly in time to the unheard 87 BPM beat: "[lyric]". Plus room tone, footfalls, sofa creak, laughter, fabric. No track, no instrumental.
```

**Spoken dialogue is allowed** when a scene has real speech. Line verbatim in quotes, plus delivery physics: mic distance, reverberation, compression, pitch level, accent.

**Non-verbal scenes** state it: `environmental sound and non-verbal effort sounds only — strained grips, hard breathing, an exertion grunt. No spoken words, no dialogue.`

**Slow-motion beats** get their own audio treatment: `slow-motion accents drop ambient under a low pressurized tone`.

<!-- STUDIO-LOCAL BEGIN: phone audio physics — pairs with Family B; upstream has no phone capture family and therefore no phone audio rule. -->
**Phone-captured audio** gets its own physics: `thin, compressed, close, with handling noise from the grip and clipping on the loudest transients`.
<!-- STUDIO-LOCAL END -->

---

## SLOT 16 — LOCKS

A positive ordered chain of what must hold. **Not a summary of the prompt** — only what could drift between cuts, phrased as what happens rather than what does not.

```
LOCKS: the sequence runs in order — sprint and leap, stomp the first creature's head into the ground, switch the blade from normal to reverse grip, side-swing kill of a second creature that struggles before dying, throw that body into another, kicks and a blade finish on the rest. Same identity, same blade, same geography and same creature design continuous across all cuts. It reads as genuinely heavy yet fast and brutal. Every shot a different angle and height. Wardrobe identical to each tagged reference, one look per figure, no mixing. Light direction and colour temperature identical across all shots. The air holds uniform density throughout.
```

Standard contents, one line each: **ordered action chain · identity continuity · staging and geometry holds · wardrobe identical to references · permanent markers restated as a short list · environment identical across shots · every shot a different angle and height · light and colour temperature consistent · atmosphere uniform · skin protection.**

**The no-restatement rule.** If a CRITICAL block already locked it, Locks does not repeat it — one clause pointing at it, not a rewrite.

<!-- STUDIO-LOCAL BEGIN: material run — a studio convention from the retired merged closer; it is the one part of that block with no home in the 16-slot spine. -->
**The material run.** Where a scene turns on how a material behaves, name each material with its real physical behaviour in one clause — `real long shaggy faux fur with real individual fibre structure, real compression under weight, and real recovery`. Materials only, never a second wardrobe pass.
<!-- STUDIO-LOCAL END -->

**Skin protection closes the block:**

```
Skin reads true cinematic matte — zero shine on forehead, nose bridge, cheekbones and collarbones, real fine even pore texture, real peach fuzz at the jaw and hairline, real lip surface texture, light absorbed like true subsurface scattering, skin protected and rendering true and natural, never plastic, never doll-skin — no acne, no blemishes, no enlarged or rough pores, fine flattering texture that keeps every face looking good.
```

**The flattering ceiling is locked.** Realism never makes a face look ugly. Where matte-realism and flattering conflict, resolve toward flattering.

**Closing negation tail**, tuned to the scene:

```
No CGI, no rendered look, no digital cleanliness, no plastic surfaces, no AI smoothness, no skin smoothing, no glow, no stiffness, no frozen posing, no stabilized camera, no gimbal glide, no video-look high-shutter crispness, no frame interpolation, no frame blending, no dropped frames.
```

<!-- STUDIO-LOCAL BEGIN: Family B tail inversion — the tail above is written for cinema capture and several items invert on phone/BTS. -->
**Family B inverts several tail items.** A phone or BTS prompt drops `no stabilized camera` and `no video-look high-shutter crispness`, and adds `no cinematic grade, no film grain, no anamorphic look, no shallow cinema focus`. Tune the tail to the capture family before shipping.
<!-- STUDIO-LOCAL END -->

---

## THE LIPSYNC PROTOCOL

Lipsync fails for four diagnosable reasons: the lyric was stated abstractly instead of as a score; the mouth got obscured; too many cuts forced per-shot mouth re-initialization; other CRITICAL blocks out-competed the singing instruction.

**1. Promote the singing to the first CRITICAL block.**

```
THE SINGING IS THE PRIMARY SUBJECT — CRITICAL: every other element is secondary. [Description by hair and wardrobe] sings out loud, full voice, mouth open and working hard, for all [X] seconds without stopping. She is a singer delivering a vocal, not a performer mouthing along. Her mouth is the focus of every shot.
```

**2. Write the lyric verbatim, then the mouth mechanics word by word.** Bilabials — **B, M, P** — get maximum emphasis. A visible lip seal is what the eye reads as real lipsync.

```
"TIME" — the tongue taps up behind the teeth on the T, the mouth opens wide on a broad AH travelling into an EE, then BOTH LIPS PRESS FULLY AND VISIBLY TOGETHER AND SEAL SHUT on the M — a complete, unmistakable, hard lip closure with upper and lower lips meeting flat and pressing together, held a beat before releasing.
```

Non-bilabial words still get formation: where the tongue goes, how far the jaw opens, whether lips round or spread, whether teeth touch lip.

**3. State the closure count.** Scan the line for B, M, P — those are the hard seals. F and V are teeth-on-lip, described but not counted. Sustained final vowels are declared held open.

```
THE PATTERN OF CLOSURES: four hard lip seals across the sequence — on the M ending TIME, the M starting ME, the B starting BEEN, the B starting BEFORE — plus a smaller visible closure on the P of UP. Every one of the four is complete, fully visible and unmissable. The mouth is never lazily half-open and never mumbling between them.
```

**4. Lock mouth visibility in its own CRITICAL block.**

```
THE MOUTH IS ALWAYS VISIBLE AND ALWAYS READABLE — CRITICAL: her face is turned toward the lens, her mouth unobstructed, frontal and clearly readable in every single frame of every shot, and it stays readable through the camera movement, through the cant and through every flicker of the light. Nothing ever covers it — no hand, no hair, no arm, no other body.
```

**5. Hand timing to the clip and minimize cuts.** Prefer one continuous take. If cutting, cut between lyric lines or in breaths, never mid-word, and state it in the header.

```
Do not invent or impose any internal timing on the singing — the attached clip @vocal_take owns the timing entirely, and every syllable, vowel opening and lip seal syncs precisely to the vocal in that clip.
```

**Strobe fights lipsync** — hard flash-to-black eats roughly half the closures. When both are wanted, flag it and soften the strobe on the singer only, a fast bright flicker that never drops her face fully to black, while background bodies keep the full treatment.

---

## STROBE GRAMMAR

```
THE STROBE IS THE DEFINING FEATURE — CRITICAL: the space is lit by hard white strobe flashes firing relentlessly on a fast [BPM] pulse. The rhythm is flash, black, flash, black — hard on, hard off, with occasional double and triple stutter runs. Each flash is instantaneous and brilliant, revealing the scene crisply frozen mid-motion, hard-edged and contrasty. Each black interval drops the frame to near-total darkness. No fade in, no fade out, every transition a hard snap. Because the bodies move continuously but are visible only during the flashes, every figure appears to jump between discrete frozen positions. Nothing sits at a comfortable normal exposure at any point.
```

Always pair with: a **secondary light** holding a dim constant glow between hits so forms stay readable in the black · the **cadence quarantine** in Style Prefix · a **continuous-motion clause**: `nothing is ever frozen, held or static between flashes — every body is in continuous motion at all times, it is only the light that stops them`.

**Per-beat light pulsing causes perceived choppiness.** On a report of choppy output, soften the pulse to a slow continuous swell first; if it persists, kill the pulse and go constant.

---

## HOUSE RULES

**No character names anywhere in the prompt body.** Visual descriptors only — hair colour and style, wardrobe, identity markers. Applies universally including staging, geometry and camera lines.

<!-- STUDIO-LOCAL BEGIN: amends upstream's tag-aliasing clause, which forbade tags inside the code block and is incompatible with the element-tag grammar this studio runs on. -->
**Element tags are the exception, and they appear inline.** A tag is a reference handle, not a character name: `@sol_ref` inside the prompt body is correct and required, while `Sol turns to the door` is not. The tag token may contain a name; the prose around it never may. The human-readable gloss for each tag lives in the tag list above the code block and nowhere else.
<!-- STUDIO-LOCAL END -->

<!-- STUDIO-LOCAL BEGIN: no-mode-line rule — only meaningful because this studio runs the M1–M5 framework upstream dropped. -->
**No mode line in the prompt.** The M1–M5 selection is internal and expresses itself through the other slots.
<!-- STUDIO-LOCAL END -->

**No aspect ratio.** Set in the UI.

**No internal production context.** No "carried through from the previous scene," no "matching the earlier plate." Every prompt is standalone with everything restated fresh.

**No platform or tool names** in the prompt body.

**No meta-commentary.** Every word describes something visible or audible.

**Age-blind.** Describe by role, hair, wardrobe, identity markers.

**English only inside the code block.** No Simplified Chinese, no bilingual mode.

<!-- STUDIO-LOCAL BEGIN: upstream ships an inverted rule here (brand names, text and graphics written verbatim) — studio default is prohibition with an authorised override; the override clause is byte-identical to character-builder rule 9. Re-graft on future upstream updates. -->
**No unauthorised real brand names in prompt output.** Generic visual descriptors only — "a white low-slung mid-engine sports car," not a named badge; "a red cola can with a light cursive wordmark," not a named brand. Physical text that genuinely exists in a scene as generic signage, packaging or garment print is still described by shape, colour, placement and legibility — just never tied to a real trademark or brand name. **Override:** when the user explicitly supplies a real brand name and either confirms the rights (the client's own brand under an engagement) or explicitly accepts the risk (personal, non-commercial work), write it verbatim and describe its physical marks — shape, colour, placement, legibility — so the model has something to draw. Never introduce a real brand the user didn't name.
<!-- STUDIO-LOCAL END -->

**Lighting by direction, quality and temperature only.** Never a fixture name.

<!-- STUDIO-LOCAL BEGIN: replaces stripped upstream :169 per the decision-ledger rejection of style-by-proxy — named-DP shorthand is imprecise and puts a real person's name into client-facing output. -->
**No named-DP or style-by-proxy shorthand.** Describe the look behaviourally.
<!-- STUDIO-LOCAL END -->

---

## STORY BIBLE HANDOFF

When a story bible or canon skill is active, it is the identity and context source and this skill is the cinematography grammar. Pull character voice, movement signature and stillness register into Assets. Pull speech patterns into Audio. Pull aesthetic era and palette into Light & Colour. Layer the bible's production rules on top of House Rules, taking precedence where they conflict.

The bible answers *who and what world*. This skill answers *how it is shot*. Never let bible material leak in as lore or backstory — only as observable physical behaviour. Operate standalone when no bible is present.

<!-- STUDIO-LOCAL BEGIN: cinema-world-bible cross-link and voice-register consumption — this studio's upstream shot-spec source; upstream drop 3 knows nothing about it. -->
**Cinema World Bible cross-link.** In this studio, shot specs and locked character and reference continuity are managed upstream by the `cinema-world-bible` skill (owned by the Cinema Showrunner). That skill produces the structured shot spec — including which element tags are assigned to which references — before a prompt is written. When a shot spec is present, tag names follow the world bible's reference-library index exactly. When the shot includes dialogue or other vocal sound, the same shot spec carries each character's voice register, cadence, phrasing and timbre — pull that into the spoken-dialogue line in SLOT 15 AUDIO. The voice spec describes vocal delivery only; it never introduces music, score or genre cues into Audio.
<!-- STUDIO-LOCAL END -->

<!-- STUDIO-LOCAL BEGIN: Banana Pro handoff — the still/video pairing convention; banana-pro-director cites "the same five-mode framework" by name, so this and the M1–M5 block stand or fall together. -->
**Banana Pro handoff.** If the user mentions a Banana Pro plate for the environment, wants camera grammar to match an existing plate, or is pairing this prompt with a still already built in Banana Pro, ask which cinema mode the plate used and lock the matching optics and camera grammar here. The two skills share the same five-mode framework — when paired, the still and the video share visual DNA. Otherwise, do not bring this up.

Operate standalone unless a bible or a Banana Pro pairing is invoked.
<!-- STUDIO-LOCAL END -->

---

## PRE-DELIVERY PASS

<!-- STUDIO-LOCAL BEGIN: conversion note — rows below that name element tags, the tag list, the capture family or the mode label are converted from upstream's numbered-reference and single-capture-family forms, not additions to them. -->
<!-- STUDIO-LOCAL END -->

- [ ] **Target version established — 2.0 or 2.5 — before anything else was written**
- [ ] Reference count within the target's ceiling: ≤ 9 on 2.0, ≤ 50 on 2.5; tags match by name, so no attach position is load-bearing
- [ ] Bolded title with runtime, then the bulleted tag list, then one code block
- [ ] Header timings sum exactly, total ≤ 15s on 2.0 or ≤ 30s on 2.5, speed policy stated
- [ ] Past 15s, shot budget declared and anti-drift weight added (anchor ref, per-beat lens lock)
- [ ] Style Prefix second, matching the declared capture family, render quad present, cadence clause inside Technical
- [ ] NO ON-SCREEN TEXT third, no carve-out clause inside it
- [ ] CRITICAL blocks capped at four, ordered by importance
- [ ] Every character has its own reference tag and its own Asset line with THIS SCENE
- [ ] Fidelity assertion on every asset, reference scoping on the location asset
- [ ] Geometry Map states lateral position, depth planes, and vertical relationship
- [ ] Direction labelled screen-relative or character-relative
- [ ] First Frame kills the empty establishing hold; the final beat lands on a completed state
- [ ] Lens lock per shot in FOV degrees with mm, unusual FOVs defended
- [ ] Camera register consistent with cut rate and cant, never-settles clause present
- [ ] Colour doctrine in three bands, every band sourced
- [ ] Atmosphere names the actual depth planes; every visible vapour has a source in frame
- [ ] Physics runs the full chain at the right scale, closes with nothing floats
- [ ] Every visible body has an action in every beat
- [ ] Brow and forehead matched to the emotion, eyeline target stated
- [ ] Audio diegetic and closing on NO BGM, or the attached-track sole-source lock
- [ ] Locks is an ordered positive chain, no restatement of CRITICAL blocks
- [ ] Skin protection and negation tail close the prompt, tail tuned to the capture family
- [ ] No character names, no aspect ratio, no tool names, no mode label, no named DP
- [ ] Nothing stated twice anywhere

<!-- STUDIO-LOCAL BEGIN: checklist rows for the re-grafted features — element tags, the Family B film-grammar kill, and the no-mode fallback have no upstream row. -->
- [ ] Every element tag named in the tag list appears at least once inline in the code block, and no reference carries an Asset line without an attached, named tag
- [ ] Canonical-over-plate holds — every named subject has its own canonical tag even where it is visible in the plate, and the location asset is scoped to world only
- [ ] Phone/BTS prompts replace the whole Style Prefix stack with the Family B stack and carry the film-grammar kill; no film-grain, photochemical or large-format language survives anywhere in them
- [ ] Optics match the selected mode — anamorphic on M1/M3/M4/M5, spherical on M2 — and where no mode was selected, the spherical house fallback is the one in force
<!-- STUDIO-LOCAL END -->

**Repair pass:**

| Symptom | Fix |
|---|---|
| Wardrobe drifting | restate every garment in the Asset, not just the changed one |
| Choppy output | check the cadence clause sits in Style Prefix, then soften or kill any per-beat light pulse |
| Bodies drifting between cuts | tighten Geometry Map, add depth planes and a favours-line |
| Geometry inverting | promote it to a CRITICAL block and defend it in the negative prompt |
| Air reading as fog machine | a vapour has no source in frame — bind it or cut it |
| Figures floating or sliding | the physics chain is missing deformation or contact shadow |
| Background bodies frozen | add EVERYONE IS LIVE and give each an action per beat |
| Lens averaging back to normal | add the not-the-other-thing defense battery |
| Lipsync closures missing | check mouth-visibility block, cut count, and whether strobe is eating the face |
| Extras appearing | add the population lock as its own CRITICAL block |
| Slow motion appearing unbidden | add the explicit no-speed-change line to the header |
| Captions appearing | the text block drifted down, or a carve-out crept into it |
| Long but vague | something is stated twice — find the duplicate and delete the later copy |
| Over the runtime ceiling or overloaded | split into two prompts by camera or by beat |
| References silently dropped | reference count exceeds the target's ceiling — confirm 2.0 vs 2.5 |
| Faces averaging or blending | two references are teaching the same thing — cut one |
| Long take compressing into the first third | declare the shot budget in the header, rebuild as 2.5–4s beats |
| Identity drifting late in a long 2.5 take | add an anchor reference named in every beat, repeat the lens lock per beat |
<!-- STUDIO-LOCAL BEGIN: repair rows for the re-grafted features. -->
| Wrong subject rendering from the plate | the subject has no canonical tag — add one, and scope the location asset to world only |
| A reference ignored entirely | its tag was named in the tag list but never appears inline in the code block |
| Phone footage reading cinematic | the Family B stack was half-applied — replace all five Style Prefix lines and add the film-grammar kill |
| Anamorphic flares on a clean studio look | mode is M2, or no mode was selected — fall back to spherical and cut the anamorphic language |
| A mode label appearing in output | the mode is a selection tool only; strip it from the prompt body |
<!-- STUDIO-LOCAL END -->

---

<!-- STUDIO-LOCAL BEGIN: studio release conventions — the QA gate and humaniser pass are vault policy, and the carve-out for code-block output is what keeps prompts verbatim. -->
## STUDIO CONVENTIONS

In this studio, written deliverables (briefs, shot specs, world bibles, integration documents) pass a QA gate (QAComplianceReviewer) and a humaniser pass before release. This applies to surrounding prose and structured documents, not to the prompt code-block output itself — the prompt grammar inside the fenced code block is verbatim copy-paste material and must never be humanised or reworded.
<!-- STUDIO-LOCAL END -->
