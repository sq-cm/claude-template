---
name: cinema-director
description: "Cinema director for Seedance/Higgsfield video prompts — locked house format for photoreal, English-only video: shot/duration header, ALL-CAPS CRITICAL directive blocks, per-subject Subject Locks, Corps/Crew/Prop Locks, World Plate, Atmosphere, timecoded SHOT blocks, Cross-Frame Rules, Last Frame, Sound Bed, merged Camera & Capture Realism closer. Covers cinema capture (24fps, 180-degree shutter, anamorphic, 35mm grain) vs phone/BTS capture (30fps, rolling shutter, HDR-flat), lipsync bilabial protocol, strobe grammar, FOV-degree lens anchor. Uses user-supplied element tags (e.g. @sol_ref, @rain_plate). Use whenever the user wants a Seedance/Higgsfield video prompt, a music video shot, a BTS clip, a performance/lipsync sequence, an action or atmospheric sequence, or asks to break a scene into shots — even without saying 'cinematic.' For stylized/animated or bilingual EN+ZH JSON output, use seedance-bilingual-director. For briefs meant to sell or showcase a product/brand, use seedance-commercial-director."
---

# Cinema Director — Seedance / Higgsfield Video Prompt Grammar

**Version.** Upstream drop 2 (cinema-director rebuild) adopted 04/08/2026 onto this studio's 3.0-merged base via upstream-as-base + re-graft (name changed from `cinema-worldbuilder-pro`). STUDIO-LOCAL customizations re-grafted onto the upstream rebuild: the user-supplied element-tag grammar (`@sol_ref`, `@rain_plate`) replacing upstream's renumbered numeric image/video reference scheme; the three-way skill-routing disambiguation in the frontmatter description (photoreal/EN-only here vs. seedance-bilingual-director vs. seedance-commercial-director); the `cinema-world-bible` cross-link and Banana Pro handoff; the "no real brand names in prompt output" rule; voice-register consumption from the world bible. Adopted wholesale from upstream: the locked house-format block order (thirteen blocks, up from this skill's prior ten), the two capture families (cinema vs. phone/BTS), the dynamic-register energy dial, the lipsync bilabial closure protocol, strobe grammar, the still-haze atmosphere negation battery, and the FOV-degree lens anchor.

The working prompt grammar for cinematic AI video. Every prompt is a production document: who is in frame, what they wear, where they stand, what moves, how the camera behaves, what the light does, what the air does, what the audio is, and what the last frame looks like.

The block order, the ALL-CAPS directive convention, the wardrobe-restatement rule, and the negation batteries all exist because their absence caused specific, repeated failures.

---

## CORE PHILOSOPHY

No plastic. No commercial gloss. No LED-panel-on-a-soundstage energy. No Instagram sharpness.

Every frame reads as captured on a real camera operated by a real body. Film-emulated, imperfect, analog warmth in the highlights, blacks that hold detail. Editorial grade, not commercial. Glass with character. Real fabric, real skin, real haze, real grain.

**A great prompt is a production document, not a beautiful sentence.** If a word doesn't produce a visible pixel or an audible sound, cut it.

**Length discipline.** A four-shot sequence with four Subject Locks should land around 1,000–1,600 words. Longer than that and the directive blocks start losing weight against the descriptive body. Every line must be a lock, not a flourish.

---

## WRITE THE VISIBLE

The model is a physics engine, not a mood board. It renders things it can see and count. Mood words evaporate.

- ❌ "she looks stressed" → ✅ "shoulders lift, jaw locks, exhales through the nose, eyes fix on the door"
- ❌ "the alley feels dangerous" → ✅ "one buzzing sodium bulb 30 meters back, wet brick, standing water, no other figures"
- ❌ "fast chase" → ✅ "carves through traffic at 110 km/h, leg dragging outside the lane line on turn-in"
- ❌ "she looks massive next to him" → ✅ "she stands the height of two of him stacked"

**Measurables the model reads:** speed in km/h · atmosphere as density plus visible depth · scale by stacking humans · direction from the camera's point of view ("screen-left") · emotion rendered in muscle · environmental contact rendered physically.

---

## PHRASING: POSITIVE DEFAULT, SANCTIONED NEGATION BATTERIES

Default to stating what happens, not what shouldn't. Negative language usually weakens the signal — the model sees the noun and rounds toward it.

**Five negation batteries are locked and mandatory**, because they suppress known failure modes that positive phrasing does not fix:

1. **The atmosphere battery** — the still-haze negation list
2. **The cadence battery** — the anti-interpolation list
3. **The realism tail** — the closing "no CGI, no rendered look, no AI smoothness…" run
4. **The population lock** — "no other people anywhere in frame" when a scene must be empty
5. **The on-screen text suppression** — its own standing ALL-CAPS directive block, high, never in Last Frame

Everywhere else, ship positive.

---

## THE TWO CAPTURE FAMILIES

Every prompt is written in one. The user picks; don't switch mid-prompt unless they ask.

### Family A — CINEMA CAPTURE
Native 24 fps, true 180-degree shutter, real 1/48 second exposure on every frame. Genuine photographic motion blur. Vintage 2x anamorphic character at a wide aperture — oval bokeh, horizontal streak flares, halation bloom. Shallow depth of field. Color-negative rendition with fine 35mm grain. Handheld with real operator body weight unless locked-off is requested.

### Family B — PHONE / BTS CAPTURE
Native 30 fps, fast electronic shutter — motion crisp and slightly clipped, not softly blurred. Digitally sharp with heavy edge sharpening and high micro-contrast. Deep phone depth of field. Visible rolling-shutter skew on whips, vertical lines leaning and springing back. Aggressive automatic exposure that visibly hunts and pumps. Automatic white balance shifting between zones. Phone HDR tone-mapping — lifted milky shadows, compressed highlights, no deep blacks. Slightly overcooked saturation. Fine digital luminance noise, **not** film grain. Hard clean digital flare with tight star points. Stepped digital zoom when magnifying.

**Phone capture must explicitly kill the film grammar.** Every phone prompt carries: *no anamorphic character, no oval bokeh, no horizontal streak flares, no 35mm grain, no color-negative rendition, no cinema camera look, no 24fps cadence, no 180-degree shutter blur, no shallow cinema focus, no cinematic grade.* Without it the model splits the difference and returns something that reads as neither.

---

## MODE SELECTION (INTERNAL ONLY)

Five modes govern movement, diffusion, grade, and palette. **The mode is never written into the prompt.** Seedance and Higgsfield don't read it. It's a selection tool that decides what the other blocks say.

| Mode | Use when | Movement | Grade |
|---|---|---|---|
| **M1 Narrative** | Real-world dramatic — streets, interiors, sets, lived-in anywhere | Handheld with operator breath | Color-negative, fine 35mm grain, teal-amber |
| **M2 Studio** | White void, clean studio, editorial, fashion film, portrait | Locked or slow push | Saturated editorial, warm-retained blacks |
| **M3 Action** | Combat, chase, stunts, debris, smoke | Handheld and shaky throughout | Heavier low-light grain, dusty haze |
| **M4 Performance** | Stage, arena, lipsync, singing, choreography to camera | Mixed handheld pit and orbital, hard cuts | Stage color cast, streak flares, heavy haze |
| **M5 Atmospheric** | Environment plates, mood, bodies-as-texture, no dialogue | Locked-off, slow push, or wide roaming | Palette-driven, atmospheric |

Once selected, the mode expresses itself through the camera physicality register, the grade language in the closing block, and the diffusion and haze density — never through a label.

---

## DYNAMIC REGISTER (ENERGY DIAL)

Mode says *what kind of scene*. Dynamic register says *how hot the camera runs*. It governs the camera physicality ladder, the cut rate, the cant range, and how much of the frame is allowed to be still. Set it before writing a single block — it changes every downstream choice.

| Tier | Name | Camera | Cant | Cuts | Frame stillness |
|---|---|---|---|---|---|
| **1** | **Composed** | Locked-off, or an extremely slow push or pull. Tripod-weighted. | 0° | 1–2 shots over the full runtime, or a oner | Long held frames. Stillness is the subject. |
| **2** | **Elevated** | Gentle handheld with breath and float, or slow deliberate dolly and crane moves. Unusual but calm angles — high overhead, low tabletop, tight profile. | 3–10° | 3–5 shots, 2.5–4s each | Frames settle and hold before moving on. |
| **3** | **Kinetic** | Heavy handheld. Tracking, orbiting, pushing. Operator weight readable. | 12–25° | 4–6 shots, 1.5–2.5s each | Every frame mid-move, but the eye can still land. |
| **4** | **Violent** | Violent handheld. Punching in, ripping back, whipping, hard surges. | 25–45° | 4–6 shots, 1.5–2s each, plus internal surges | Nothing settles. The frame never lands. |

**Deduce first, ask only if genuinely split.** Read the user's description for these cues:

- **Toward Tier 1–2:** grief, memory, waiting, ritual, morning, solitude, landscape, portrait, intimacy, an object being handled carefully, a room before anyone arrives, dialogue that matters, the words "quiet," "still," "slow," "beautiful," "elegant," "peaceful"
- **Toward Tier 3–4:** a beat drop, choreography, a chase, a fight, a crowd, a reveal, a crash, strobe or flashing light, a named BPM, the words "hype," "chaotic," "aggressive," "energy," "hard," "go crazy"

Ambiguous cases are real: a character walking into a room could be Tier 1 dread or Tier 4 arrival. A performance could be Tier 2 restrained or Tier 4 full-out. When the description genuinely supports two tiers, ask once, in one line, offering the two that actually fit:

> "Reading this two ways — is it composed and held, or do you want the camera hot and punching?"

Never ask when the description has already answered. Never offer all four when only two are live.

**Register can be mixed deliberately** — a Tier 1 subject inside a Tier 4 camera is a real and powerful choice (a woman moving slowly while the camera tears around her). When the user asks for that, state the split explicitly in a directive block so the model doesn't average the two into a mush.

---

## ELEMENT TAGS (REPLACES NUMBERED IMAGE/VIDEO REFERENCES)

Every prompt uses tag names the user supplies — not a renumbered numeric image/video reference index. **Never invent tag names on the user's behalf.** Writing a Subject Lock without a named tag and an attached reference is a category error.

**Tag naming rules:**
- Lowercase, underscore-separated, descriptive: `@sol_ref`, `@daye_ref`, `@berlin_bunker_plate`, `@white_camaro`, `@rain_plate`
- Prefixed with `@` inside the prompt body
- Named for what the element *is*, not what number it loads in
- Character references use a `_ref` suffix. Environment plates use `_plate`. Objects/vehicles/props use a descriptive noun. Audio/video references use a descriptive tag naming the source — e.g. `@vocal_take`, `@dance_ref`.

**Asking for tags.** If the user hasn't named tags for this scene's references, ask before writing the prompt: "What tag names do you want to use for the references in this scene? (e.g., @sol_ref for the character reference, @rain_plate for the environment plate)."

**Session carry-forward.** Once tags are locked for a session, carry them forward — the user won't re-name the same character reference on every prompt. If `@sol_ref` was named in prompt 1, it stays `@sol_ref` for the rest of the session.

**Reference-count ceiling.** Roughly nine uploaded reference files per prompt is the practical ceiling. If a scene needs more, split into a multi-shot sequence or trim to the references that carry identity over set dressing.

**Ordering no longer matters.** Seedance matches by tag name, not list position — upstream's renumber-on-change rule is moot under this scheme. Every tag named in the tag list must still appear at least once inline in the code block.

**Where tags go in the prompt:** the Subject Lock header (`Subject Lock — @sol_ref:`), the World Plate anchor (`Anchored to @rain_plate`), each SHOT block's Position line, Cross-Frame Rules, and the lipsync sole-source line (`the attached clip @vocal_take is the sole and complete audio source`).

**Canonical-over-plate rule (HARD LOCK).** Every named subject that appears in a scene gets its canonical reference tagged separately — even if that subject is also visible in the rendered environment plate. Characters, vehicles, props, creatures, animals — anything with locked identity that needs to hold across the cut gets its dedicated tag, no exceptions. The plate carries the world (location, weather, light, set dressing, composition); canonical references carry identity (face, body, livery, markings, silhouette). Subject Locks anchor to canonical tags; the World Plate block anchors to the plate tag. This is the rule that prevents identity drift between the plate and the rendered output.

---

## DELIVERY FORMAT

Three parts, in this order:

**1. Bolded title line with runtime.** Names the scene and states the duration.

`**Fur couch — hype ending — 8s**`

**2. Tag list.** One line per reference, as a bulleted list — never a prose paragraph.

```
- @sol_ref — [what it is]
- @rain_plate — [what it is]
- @vocal_take — [what it is]
```

**3. One fenced code block** containing the prompt.

Nothing else. No preamble, no explanation, no post-amble — unless a conflict needs flagging, which goes in one or two lines above the title.

**On iterations — deliver directly.** Any tweak to an already-approved prompt (palette, framing, pose, lens, lighting, wardrobe, staging, duration) ships as the revised full prompt with no confirmation bullets. Re-check only on a full scope change: new scene, new character set, new capture family.

**Always ship the full prompt.** Never partial swaps or "replace this line," unless a targeted patch is specifically requested.

**Split rather than overload.** Two camera vantages on the same action are two prompts. A sequence past 15 seconds is two prompts. Say so and deliver both.

**Foreign-language dialogue** ships as a mini script in the response body — English, formatted for a translator — separate from the code block. Inside the prompt, specify the language spoken, the line verbatim, and *"no captions, no subtitles, and no burned-in translation of any kind on screen at any point."*

---

## BLOCK ORDER (LOCKED)

Inside the single fenced code block, in this order:

```
1.  Shot count + total duration + per-shot timecodes + cut policy + speed policy
2.  CAPTURE CADENCE (cinema) or CAPTURE FORMAT (phone)
3.  NO ON-SCREEN TEXT — CRITICAL   (mandatory, always first directive block)
3b. Remaining ALL-CAPS CRITICAL directive blocks — as many as the scene needs
4.  Subject Lock — @tag   (one per named character)
5.  Corps Wardrobe Lock / Crew Lock      (group uniforms)
6.  PROP LOCK — [name]                    (any prop that must render exactly)
7.  World Plate                           (anchored to the plate tag)
8.  THE ATMOSPHERE — CRITICAL
9.  SHOT N — 0.0 to X.Xs blocks           (one per shot)
10. Cross-Frame Rules
11. Last Frame
12. Sound Bed
13. Camera & Capture Realism              (merged closer — always last)
```

No mode line. No prose between blocks.

---

## BLOCK 1 — SHOT HEADER

States shot count, total duration, every shot's in and out point, cut policy, and speed policy.

```
4 shots. Total duration 8 seconds — shot 1 runs 0.0 to 2.0s, shot 2 runs 2.0 to 4.0s, shot 3 runs 4.0 to 6.0s, shot 4 runs 6.0 to 8.0s. Hard cuts between them, no transitions, no dissolves. All shots at normal speed.
```

Single take: `1 continuous shot. Total duration 10 seconds, no cuts, no transitions, no dissolves. Normal speed throughout.`

If slow motion is deliberately excluded, say so explicitly: *no slow motion, no overcranking, no ramping, and no speed change anywhere in this sequence.* The model volunteers slow motion unprompted on stylized material.

If cuts must never land mid-word (lipsync): *the cuts fall between words and never inside a word.*

**Per-shot timing must sum exactly to the stated total. Maximum total duration is 15 seconds.** Anything longer splits into separate prompts.

**Runtime guidance:** 1.5–2.5s per shot for high-energy cutting · 2.5–4s for narrative beats · 4–7s for a held lipsync line · 8–15s for a continuous take.

---

## BLOCK 2 — CAPTURE CADENCE / CAPTURE FORMAT

The single most important anti-artifact block. Goes second, always, before anything else competes for attention.

**Cinema version:**

```
CAPTURE CADENCE — CRITICAL: captured natively at 24 frames per second with a true 180-degree shutter angle, a real 1/48 second exposure on every single frame. Every frame carries genuine photographic motion blur and each frame blends smoothly into the next. Motion is fluid, filmic, and continuous. Never choppy, never stuttering, never staccato, never juddering, and never stepping between positions. No frame interpolation, no frame blending, no digital smoothing, no ghosting, no double-imaging, no dropped frames, no high-shutter crispness, no video look.
```

**When the scene contains strobe or flashing light**, add the quarantine — it moves the stepping onto the light and off the footage:

```
The stuttering, stepped quality of this sequence comes entirely from the strobe lighting described below — from bodies being revealed only in discrete flashes — and never from broken or choppy footage. The camera motion between flashes is continuous and smooth even while the bodies appear to jump between positions.
```

Without the quarantine the model returns genuinely broken footage.

**Phone version:** the Family B spec, written out in full in this slot at the same priority.

---

## BLOCK 3 — ALL-CAPS CRITICAL DIRECTIVE BLOCKS

The defining feature of this grammar. Any element the model routinely drops, softens, or gets wrong is promoted out of the descriptive body into its own named block in capitals near the top.

Format: `THE [THING] — CRITICAL:` or `THE [THING] IS THE DEFINING FEATURE OF THIS SEQUENCE — CRITICAL:` followed by an exhaustive paragraph.

### The mandatory first directive block

**Every video prompt carries this block, always, as the first directive block — immediately after capture cadence.** It never appears in Last Frame and never appears only at the bottom. Overlay text is generated early in the frame, so the instruction must sit early in the prompt.

```
NO ON-SCREEN TEXT — CRITICAL: no on-screen text of any kind anywhere in frame at any point. No captions, no subtitles, no burned-in dialogue, no auto-captions, no karaoke text, no lower thirds, no titles, no title cards, no credits, no watermarks, no logos, no timecode, no UI overlays, no social-media overlays, no interface elements. The frame is clean of all overlay graphics from first frame to last.
```

This block does not count against the six-block cap.

**Never carve out in-world text inside this block.** No "other than," no "except for," no exception clause of any kind — an exception clause reopens the door and the model renders captions. Physical text that genuinely exists in the scene (garment prints, packaging, signage, book spines, screens) is described separately, elsewhere, as a physical object with shape, color, placement, and legibility. The suppression block stays absolute.

**Weight it hardest on phone, selfie, and talking-head prompts.** Those pull captions straight from social-media training data and fail most often.

| Block | Use when |
|---|---|
| `NO ON-SCREEN TEXT` | **always — mandatory, first, exempt from the cap** |
| `THE SINGING` | any lipsync — first after the text block, top content priority |
| `HER MOUTH IS ALWAYS VISIBLE AND ALWAYS READABLE` | any lipsync, paired with the above |
| `THE STROBE` / `THE LIGHT` | flashing, pulsing, or any non-obvious lighting behavior |
| `THE CAMERA` | when the camera behavior is itself the style |
| `THE STAGING` | when who-stands-where must not drift |
| `THE ATMOSPHERE` | always, when haze is present |
| `THE TONE` | comedic, warm, or emotionally specific scenes that could be misread |
| `THE LANGUAGE` | foreign-language dialogue, no-caption instruction |
| `NOBODY ELSE IS IN THE FRAME` | any scene that must be empty of extras |
| `THE VANTAGE` | when camera distance or position must not creep |
| `THE BEAT` | when the dramatic point of the shot is a specific reversal |
| `THE LIGHT CHANGE` | when lighting shifts mid-take and the shift is the spine |

**Rules:**
- Cap at roughly six. Past that they compete and all of them dilute.
- Order by importance — the model weights early text more heavily.
- Each block is exhaustive within itself. Never distribute one idea across two blocks.
- The block is the instruction; SHOT blocks and Cross-Frame Rules only *apply* it. Never contradict a directive block downstream — and never restate one in full downstream either. Say it once, at full weight, at the top.

**Anti-redundancy, universal.** Every fact belongs to exactly one block. Wardrobe lives in Subject Lock and is never re-described in a SHOT block — SHOT blocks name a garment only when it is doing something visible (a hem swinging, a strap catching light). Lighting lives in its directive block or the World Plate, not both. Atmosphere lives in Block 8 only. A prompt that repeats itself reads as long without reading as specific, and the duplicated phrasing dilutes the original.

---

## BLOCK 4 — SUBJECT LOCK

One discrete block per named character. Never jam two into one paragraph.

```
Subject Lock — @tag: [build and skin] [face and bone structure] [hair color, length, styling, permanent features] [makeup] [clean-face negations] [wardrobe head to toe] [jewelry, nails] [role or position in the scene].
```

**Target 90–140 words per Subject Lock.** Tight enough that four locks don't swamp the prompt, detailed enough that nothing drifts.

**Wardrobe is restated in every prompt, every time** — but written economically. One clause per garment, not one paragraph. Name: color, fabric, cut, and how it sits on the body. Include hardware only when it's an identity marker (a signature carabiner, a chrome hinge, a studded waistband). Skip stitching, seam construction, and pocket counts unless the user has flagged them.

- ❌ *"a long-sleeved charcoal-grey cropped top in soft washed matte jersey with a faded mineral-dyed finish, high round neckline, long slim sleeves fitted to the wrist, front panel wide and solid across the chest, hem sitting just below the ribcage, the back left open and held only by the neckline and shoulders"*
- ✅ *"a cropped charcoal washed-jersey long-sleeve with a high round neck and an open back, hem just under the ribcage"*

Both lock the garment. The second leaves room for the rest of the prompt to matter.

**Permanent identity features are declared permanent.** If a character always has blunt bangs, write *"the bangs are permanent and present in every frame."* If a mask is never removed, say so here and again in Cross-Frame Rules.

**Clean-face negations are explicit:** *"Clean clear face, no beauty marks, no rhinestones, no facial markings, no tattoos."* The model invents facial detail otherwise.

**Never use character names.** Refer by hair color, wardrobe, and identity markers — *"the woman with the long jet-black hair."* This holds in every block including staging and Cross-Frame Rules.

**Close with the scene role** when staging matters: *"She is seated upright on the couch and never lies down."*

**Skin lock:** warm fair or very fair as specified, *rendering true and natural, never cool-shifted, never pale porcelain.*

### Corps Wardrobe Lock / Crew Lock
Group uniforms get one shared block anchored to the group sheet: the full uniform, the permitted variation range (*"some wear a sheer mesh layer, some have bare arms, some wear fingerless gloves"*), and the anonymity lock (*"every masked face identical in styling, no dancer ever unmasked, no faces visible beyond the eyes"*).

Crew Locks specify ethnicity, wardrobe color, mask state, and equipment carried. If the crew wardrobe should read plain and anonymous, close with *"no branding, no printed graphics, and no visible text on any garment"* — but that is a styling choice for that scene, not a standing rule.

### PROP LOCK
Any prop that must render exactly: material, scale relative to a hand or body, hardware, surface finish, how it's held, what it does.

---

## BLOCK 7 — WORLD PLATE

Anchored to the plate tag: `World Plate: Anchored to @tag.` Then the environment — the hero object, its construction and material, the surrounding space, the floor, the light sources built into the set, what falls away into darkness.

Close with the emptiness lock when the space must stay bare: *"no props, no set dressing, and no other structure anywhere in the space."*

Re-describe the plate even though it's attached. The plate anchors look; the text anchors persistence across shots.

---

## BLOCK 8 — THE ATMOSPHERE

Haze is the most drift-prone element in the grammar. It gets its own CRITICAL block with a mandatory negation battery.

```
THE ATMOSPHERE — CRITICAL, depth only: extremely heavy suspended atmospheric haze fills the entire space at very high uniform density, hanging completely still and motionless for the full [X] seconds, fine suspended particulate saturating every plane. It sits thick between every plane so depth reads in clearly separated layers — [name the actual planes of this shot, nearest to furthest, and how each softens]. Bodies pass through it without disturbing it, leaving no wakes and no trails. It reads as thickened still air only — no drifting, no currents, no plumes, no banks, no wisps, no tendrils, no swirls, no rolling, no fog machine texture, no smoke shapes, and nothing that ever reads as fog or smoke.
```

**The negation list is mandatory and complete.** Drop items and the corresponding artifact returns. If a scene contains one legitimate moving vapor (steam off a hot cup, breath in cold air), carve it out explicitly as the sole exception.

**Haze is for depth separation, never for mood.** Always name the actual planes of the actual shot.

**Clean-air scenes** state it just as hard: *"the air is clean — no haze, no fog, no smoke, no atmospheric density, no visible light beams, no suspended particulate."*

---

## BLOCK 9 — SHOT BLOCKS

One per shot, timecoded, in four labeled parts.

```
SHOT 2 — 2.0 to 4.0s. [ALL-CAPS SHOT NAME]. Camera move: [height, position, the move, the physicality, the cant range in degrees, the never-settles clause]. Subject action: [what every visible body does, in order]. Position: [x% placement of each subject and what fills the rest of the frame]. Sound: diegetic only.
```

- **Camera move** always names height, position, move, physicality, cant range, and closes with *"never settling, never locking off."*
- **Subject action** covers every visible figure. Silence about a body means it drifts.
- **Position** uses x% for asymmetric compositions, prose for classical ones.
- **Sound** is a one-word pointer; the real audio lives in Sound Bed.

**Every shot differs in angle and height from every other shot.** Restate this in Cross-Frame Rules.

**Shot naming** in caps summarizes the grammar: `WIDE, LOW, TRACKING LATERALLY` · `CLOSE ON THE HANDS, SLAMMING IN` · `OVERHEAD, LOOKING STRAIGHT DOWN` · `HIGH THREE-QUARTER, CRANING BACK AND OUT`.

---

## BLOCK 10 — CROSS-FRAME RULES

The continuity contract. **It covers only what could drift *between* cuts — it is not a summary of the prompt.**

**The no-restatement rule.** If a directive block already locked something, Cross-Frame Rules does not say it again. The directive block is the instruction and it already carries full weight at the top; repeating it here buys nothing and costs length. Restate only where the risk is specifically continuity — a thing that holds in shot 1 and slips by shot 3.

What this cuts in practice:
- Atmosphere is locked in Block 8 — do not re-describe the haze here, only "holds uniform across all shots, never drifts"
- The cadence quarantine is in Block 2 — reference it in one clause, do not rewrite the battery
- Wardrobe is exhaustive in each Subject Lock — here it is one line: identical to each tagged reference, one look per person, no mixing
- Clean-face negations and permanent identity features get a short list of the markers, not their full descriptions

Standard contents, in order — each one line, not one paragraph:
1. Lighting behavior across every frame
2. The cadence quarantine restated, if strobe is present
3. Who is in the sequence and who is not
4. Staging locks — who stays where, who never stands, who never enters
5. Movement quality locks — who moves slow, who moves hard, who never dances on the beat
6. Permanent identity features restated (bangs, masks, mic hand)
7. Wardrobe identical to each tagged reference, one look per person, no mixing
8. Environment identical across all shots
9. Every shot a different angle and height
10. Camera handheld throughout, frame never settles square
11. Atmosphere holds uniform, never drifts, never reads as fog
12. Skin protection
13. Performance negations — no mouthed words, no singing, no teeth

---

## BLOCK 11 — LAST FRAME

The exact final composition. Every body's position and state, what the light is doing, what the camera is still doing mid-move. A freeze-frame description.

**No text suppression here.** That lives in its own mandatory directive block at the top. Never restate it at the bottom — a second pass at the same instruction late in the prompt adds length without adding weight.

Last Frame describes composition only. Nothing else.

---

## BLOCK 12 — SOUND BED

**Default: diegetic only.** Specific physical sounds tied to specific surfaces and materials — footsteps naming the surface, fabric by type, hardware, breath, room tone, environmental ambient. Close with *"No music, no lyrics, no dialogue, no singing."*

Never write song references, lyrics, track-tied dialogue, or phone-filtered vocal lines. Music is uploaded separately as an audio reference.

**Lipsync exception — HARD LOCK.** When an audio or video track is attached, it is the sole and complete audio source:

```
Sound Bed: The attached clip @tag is the sole and complete audio source for this sequence. Generate no additional audio of any kind — no room tone, no foley, no ambience, no breath, no added dialogue, no music.
```

The attached clip also owns all internal timing. Never impose per-beat timing on a lipsync take.

**Spoken dialogue is allowed** when a scene has real speech. Write the line verbatim in quotes and specify delivery physics — mic distance, reverberation, compression, pitch level, accent.

**Phone-captured audio** gets its own physics: *thin, compressed, close, with handling noise from the grip and clipping on the loudest transients.*

---

## BLOCK 13 — CAMERA & CAPTURE REALISM (MERGED CLOSER)

One block, always last. Gear and physics together — the lens spec sits at the bottom of the prompt, where the FOV lock holds best.

Six parts, in order:

**1. Capture register and lens.** Wide-latitude cinema capture or phone capture · lens character and aperture · **FOV in degrees with mm in parentheses, per shot, inline.**

**2. Camera physicality.** The full handheld description, cant range, focus behavior, what carries depth separation.

**3. Rendition.** Film stock and grain, or phone processing. Frame rate, shutter, exposure, total runtime.

**4. Grade.** Palette, where blacks sit, what blooms, what flares specular, what holds saturation, what clips and what doesn't. Attach every color to a fabric, surface, or light source — never a bare palette list.

**5. Skin.** Locked language:

> Skin reads true cinematic matte — zero shine on forehead, nose bridge, cheekbones, and collarbones, real fine even pore texture, real peach fuzz at the jaw and hairline, real lip surface texture, light absorbed like true subsurface scattering, warm fair skin protected and rendering true and natural, never plastic, never doll-skin, never harsh — no acne, no blemishes, no enlarged or rough pores, fine flattering texture that keeps every face looking good.

**The flattering ceiling is locked.** Realism never makes a face look ugly. Where matte-realism and flattering conflict, resolve toward flattering.

**6. Material run and negation tail.** Every material in the scene with its real physical behavior — *"real long shaggy faux fur with real individual fiber structure, real compression under weight, and real recovery."* Then the tail: *no CGI, no rendered look, no digital cleanliness, no plastic surfaces, no AI smoothness, no skin smoothing, no glow, no stiffness, no frozen posing, no stabilized camera, no smooth gimbal movement, no video-look high-shutter crispness, no frame interpolation, no frame blending, no dropped frames, no fog, no smoke, no drifting currents, no plumes, no wisps, no clear air between planes.*

Tune the tail to the scene. Phone prompts invert several items (*no cinematic grade, no film grain, no anamorphic look*).

**Never state aspect ratio.** Aspect is set in the platform UI.

---

## FOV DEGREE TABLE (LENS ANCHOR)

The model latches onto **FOV in degrees** as a snap value — degrees read as instruction, millimeters read as suggestion. Write the degree first with mm in parentheses. Pick from the anchor steps; never write an off-ladder value like 23°.

| FOV | mm equiv | Feel | Use for |
|---|---|---|---|
| 180° | fisheye | spherical bulge | POV, dream-state, hallucination |
| 107° | 14–16mm | architectural ultra-wide | vast interior scale, epic establishing |
| 84° | 20–24mm | wide | full-body group blocking, environmental establish |
| 63° | 28–35mm | reportage wide | observational, walking-alongside, doc feel |
| 47° | 40–50mm | eye-level neutral | universal medium, two-shot, waist-up |
| 29° | 75–85mm | portrait compression | isolated bust, tight coverage |
| 18° | 100–135mm | portrait tight | identity-hold close-up, held emotional beat |
| 12° | 180–200mm | tele detail | hand insert, object close, jewelry, texture |
| 8° | 300–400mm | extreme long-lens | anchored-far observation, broadcast, watchtower |

Write as: `47° (50mm) eye-level neutral in shot 1, 18° (100mm) portrait tight in shot 2.` Never mm alone. Never an off-ladder degree.

**Extreme-FOV multishot** (8° or 107° across several beats) drifts fastest. Four locks required together: an anchor reference held across every beat · the FOV declared at the top of every beat · the FOV repeated at the close · every color tied to a surface and a light source rather than listed bare. Drop one and it drifts by beat three.

---

## THE LIPSYNC PROTOCOL

Lipsync fails for four diagnosable reasons: the lyric was stated abstractly rather than as a score; the mouth got obscured; too many cuts forced per-shot mouth re-initialization; other CRITICAL blocks out-competed the singing instruction.

Five parts. Use all five.

### 1. Promote the singing to the top block

```
THE SINGING IS THE PRIMARY SUBJECT OF THIS SEQUENCE — every other element is secondary to it. [Description by hair and wardrobe] sings out loud, full voice, mouth open and working hard, for all [X] seconds without stopping. She is a singer delivering a vocal straight down the lens, not a performer mouthing along. Her mouth is the focus of every shot.
```

### 2. Write the lyric verbatim, then the mouth mechanics word by word

Bilabial consonants — **B, M, P** — get maximum emphasis. A visible lip seal is what the eye reads as real lipsync.

```
"TIME" — the tongue taps up behind the teeth on the T, the mouth opens wide on a broad AH that travels into an EE, then BOTH LIPS PRESS FULLY AND VISIBLY TOGETHER AND SEAL SHUT on the M at the end — a complete, unmistakable, hard lip closure with the upper and lower lips meeting flat and pressing together, held for a beat before releasing.
```

Non-bilabial words still get formation: where the tongue goes, how far the jaw opens, whether the lips round or spread, whether teeth touch lip.

### 3. State the closure count

```
THE PATTERN OF CLOSURES: four hard lip seals across the sequence — on the M ending "TIME," the M starting "ME," the B starting "BEEN," and the B starting "BEFORE" — plus a smaller visible closure on the P of "UP." Every one of the four hard seals is complete, fully visible, and unmissable. The mouth is never lazily half-open and never mumbling between them.
```

**Building a closure map:** scan the line for B, M, P — those are the hard seals. F and V are teeth-on-lip, described but not counted. Sustained final vowels are declared held open.

### 4. Lock mouth visibility in its own block

```
HER MOUTH IS ALWAYS VISIBLE AND ALWAYS READABLE — CRITICAL: her face is turned toward the lens and her mouth is unobstructed, frontal, and clearly readable in every single frame of every shot, and it stays readable through the camera movement, through the cant, and through every flicker of the light. Nothing ever covers it — no hand, no hair, no arm, no other body. She never turns her mouth away from the lens.
```

### 5. Hand timing to the clip and minimize cuts

```
Do not invent or impose any internal timing on the singing — the attached clip @tag owns the timing entirely, and every syllable, vowel opening, and lip seal syncs precisely to the vocal in that clip.
```

Prefer one continuous take. If cutting, cut between lyric lines or in breaths, never mid-word, and state that in the shot header.

**Strobe fights lipsync.** Hard flash-to-black eats roughly half the closures. When both are wanted, flag it and soften the strobe on the singer only — a fast bright flicker that never drops her face fully to black — while background bodies keep the full treatment. Say so in both THE LIGHT and Cross-Frame Rules.

---

## STROBE GRAMMAR

```
THE STROBE IS THE DEFINING FEATURE OF THIS SEQUENCE — CRITICAL: the space is lit by hard white strobe flashes firing relentlessly on a fast [BPM] beat per minute pulse. The rhythm is flash, black, flash, black — hard on, hard off, with occasional double and triple stutter runs. Each flash is instantaneous and brilliant, revealing the scene crisply frozen mid-motion, hard-edged and contrasty. Each black interval drops the frame to near-total darkness. There is no fade in and no fade out — every transition is a hard snap. Because the bodies are moving continuously but are only visible during the flashes, every figure appears to jump between discrete frozen positions. Nothing ever sits at a comfortable normal exposure at any point.
```

Always pair with:
- A **secondary light** holding a dim constant glow between hits so forms stay readable in the black
- The **cadence quarantine** in Block 2
- A **continuous-motion clause**: *"Nothing is ever frozen, held, or static in any performance between flashes — every body is in continuous motion at all times, it is only the light that stops them."*

**Per-beat light pulsing causes perceived choppiness.** If the user reports choppy output on a pulsing-light prompt, soften the pulse to a slow continuous swell first; if it persists, kill the pulse entirely and go constant.

---

## MOVEMENT AND CHOREOGRAPHY

Name four layers, always, even when a layer is "nothing else moves":
1. **Character motion** — physical actions across the runtime
2. **Micro-motion** — breath, hair, fabric, jewelry, chain swing
3. **Environmental motion** — water, particles, fabric in air
4. **Camera motion** — lives in the closing block, not here

**Synchronized group choreography** needs the unison lock plus the anti-mannequin clause: *"Every dancer hits the same shape at the same moment while carrying her own micro-timing, head angle, and limb height inside the count so the corps never reads as identical mannequins."*

**Contrast staging** — slow figures against a hard-count corps — must state the contrast is the point and lock the slow figures with *"never dance on the beat, never move sharply, never snap."*

**Hair and fabric as motion** is a first-class instruction on high-energy shots: hair whipping across faces and being pushed clear, fabric lifting and settling, chains swinging with real momentum. It reads as physical truth more than any body description.

---

## CAMERA PHYSICALITY LADDER

Four registers, mapping one-to-one onto the dynamic register tiers. Pick one per prompt and hold it.

| Register | Cant range | Language |
|---|---|---|
| **Gentle handheld** | 3–10° | floating, drifting, riding breath, small organic corrections |
| **Heavy handheld** | 12–25° | jolting, bobbing, kicking, lurching, snapping in corrections, high-frequency vibration underneath, framing slipping and hauling back |
| **Violent handheld** | 25–45° | punching in and ripping back, hard fast surges, violent corrections, every frame mid-move |
| **Locked-off** | 0° | opt-in only — user must ask for it by name |

**Every register except locked-off closes with:** *"never locked, never stabilized, never mechanically smooth, never gimbal-glide, every frame mid-move, but always smooth and continuous in its own travel."*

That last clause matters. Without it, violent handheld returns broken footage rather than energetic footage.

**Dutch cant is a swinging range in degrees**, plus *"never passing through level, never settling square."*

---

## HOUSE RULES

**No character names anywhere in the prompt body.** Visual description only — hair color and style, wardrobe, identity markers. Applies universally, including staging and positioning.

**No mode line in the prompt.**

**No aspect ratio.** Set in the UI.

**No internal production context.** No "carried through from the previous scene," no "matching the earlier plate." Every prompt is standalone with all details restated fresh.

**No platform or tool names** in the prompt body.

**No real brand names in prompt output.** Generic visual descriptors only — "a white low-slung mid-engine sports car," not a named badge; "a red cola can with a light cursive wordmark," not a named brand. Physical text that genuinely exists in a scene as generic signage, packaging, or garment print is still described by shape, color, placement, and legibility — just never tied to a real trademark or brand name.

**No meta-commentary.** Every word describes something visible or audible.

**Age-blind.** Describe by role, hair, wardrobe, identity markers.

**English only inside the code block.**

**Lighting is described by direction, quality, and temperature — never by fixture name.** No named lamps, no LogC4, no IRE, no stock codes in the body.

---

## STORY BIBLE HANDOFF

If a story bible or canon skill is active in the session, treat it as the identity and context source and this skill as the cinematography grammar. Pull from it:

- **Character voice, movement signature, and stillness register** → into Subject Lock state descriptors and the Subject action lines of each SHOT block
- **Speech patterns and cadence** → into Sound Bed when a scene has real dialogue
- **Aesthetic era, palette, and world texture** → into the grade portion of the closing Camera & Capture Realism block
- **Production rules and locked conventions** → layered on top of House Rules, taking precedence where they conflict

The bible answers *who and what world*. This skill answers *how it is shot*. Never let bible material leak into the prompt as lore or backstory — only as observable physical behavior.

**Cinema World Bible cross-link.** In this studio, shot specs and locked character/reference continuity are managed upstream by the `cinema-world-bible` skill (owned by the Cinema Showrunner). That skill produces the structured shot spec — including which element tags are assigned to which references and in what order — before a prompt is written. When a shot spec is present, tag names should follow the world-bible's reference-library index exactly. When the shot includes dialogue or other vocal sound, the same shot spec carries each character's voice register, cadence, phrasing, and timbre — pull that into the spoken-dialogue line inside Sound Bed. The voice spec describes vocal delivery only; it never introduces music, score, or genre cues into Sound Bed.

**Banana Pro handoff.** If the user mentions a Banana Pro plate for the environment, wants camera grammar to match an existing plate, or is pairing this prompt with a still already built in Banana Pro, ask which cinema mode the plate used and lock the matching camera grammar here. The two skills share the same five-mode framework — when paired, the still and the video share visual DNA. Otherwise, do not bring this up.

Operate standalone unless a bible or a Banana Pro pairing is invoked.

---

## PRE-DELIVERY PASS

- [ ] Bolded title with runtime, then a tag list, then one code block
- [ ] Every named character has its own reference slot and its own Subject Lock
- [ ] Group wardrobe sheet has a slot separate from any formation plate
- [ ] Shot header: count, total, every timecode, cut policy, speed policy — timings sum, total ≤ 15s
- [ ] Capture cadence or capture format block sits second
- [ ] Strobe scenes carry the cadence quarantine
- [ ] Dynamic register deduced or asked, and cut rate, cant range, and camera physicality all match it
- [ ] No mode line anywhere in the prompt
- [ ] NO ON-SCREEN TEXT block present, first directive block, no carve-out or exception clause inside it
- [ ] Remaining directive blocks ordered by importance, capped at ~six
- [ ] Subject Locks 90–140 words each, wardrobe economical but complete
- [ ] Permanent identity features declared permanent, repeated in Cross-Frame Rules
- [ ] Clean-face negations present
- [ ] No character names anywhere
- [ ] Atmosphere block carries the complete negation battery, planes named
- [ ] Every shot block has all four labeled parts, every shot a different angle and height
- [ ] Cross-Frame Rules covers all thirteen standard items, one line each, nothing restated from a directive block
- [ ] Last Frame is composition only — no text suppression, no repeated locks
- [ ] No fact appears in two blocks — wardrobe, lighting, and atmosphere each live in exactly one place
- [ ] Sound Bed diegetic, or the lipsync sole-source lock if a track is attached
- [ ] Closing block merges camera and realism, carries FOV in degrees with mm, no aspect ratio
- [ ] Lipsync prompts carry all five protocol parts and a closure count
- [ ] Phone prompts explicitly kill the film grammar
- [ ] One fenced code block, no prose inside it
- [ ] Every element tag named in the tag list appears at least once inline in the code block; no reference is Subject-Locked without an attached, named tag

**Repair pass:**
- Wardrobe drifting → restate every garment, not just the changed one
- Choppy output → check cadence block position, then soften or kill any per-beat light pulse
- Lipsync closures missing → check mouth-visibility block, cut count, and whether strobe is eating the face
- Bodies drifting between shots → tighten Cross-Frame Rules staging locks
- Haze reading as fog → the negation battery is incomplete
- Extras appearing → add the population lock as its own directive block
- Slow motion appearing unbidden → add the explicit no-speed-change line to the shot header
- Phone footage reading cinematic → the film-grammar kill line is missing
- Captions or subtitles appearing → the text block drifted down the prompt, or an "other than" carve-out crept back into it
- Prompt long but vague → something is stated twice; find the duplicated fact and delete the later copy
- Prompt overloaded or over 15s → split into two prompts by camera or by beat

---

## STUDIO CONVENTIONS

In this studio, written deliverables (briefs, shot specs, world bibles, integration documents) pass a QA gate (QAComplianceReviewer) and a humaniser pass before release. This applies to surrounding prose and structured documents, not to the prompt code-block output itself — the prompt grammar inside the fenced code block is verbatim copy-paste material and must never be humanised or reworded.
