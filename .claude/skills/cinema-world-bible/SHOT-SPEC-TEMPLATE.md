# Shot Spec — [SHOT-ID]

> This is a spec, not a prompt. It tells banana-pro-director or cinema-worldbuilder-pro what the shot needs. Those skills write the prompt from it. Do not include Banana Pro prompt grammar or Seedance block structure here.

**Project:**
**Shot ID:** (e.g., S01-E02-003 or a simple slug like CLIFFSIDE-RAIN-01)
**Sequence position:** (e.g., Scene 2, Shot 3 of 5)
**Destination skill:** [ ] banana-pro-director (still) / [ ] cinema-worldbuilder-pro (video)
**Date:**

---

## Dramatic moment

What is happening in this shot? Describe the moment, not the camera — one or two sentences. The destination skill translates this into camera grammar.

(e.g., "The driver sits sideways in the open car door in the rain, watching the horizon, a moment of stillness before the next scene. The car's pop-up headlights cut twin cones forward through the falling rain.")

---

## Characters in frame

| Character slug | Wardrobe state slug | Condition delta | Character bible |
|---|---|---|---|
| `[CHAR-SLUG]` | `[OUTFIT-SLUG]` | (e.g., jacket removed / hair damp from rain) | `[CHAR-SLUG]-BIBLE.md` |

**State-change deltas** — wardrobe or condition details not visible in the locked reference images that must be written into the prompt:

- (e.g., "[CHAR-SLUG]: jacket removed in this scene — reference shows jacket on. Note for Subject Lock block.")
- (e.g., "[CHAR-SLUG]: oxblood corset is damp, fabric darker where rain has soaked in — the outfit reference is dry.")

---

## Reference-image assignments

Pull from the reference library index. Canonical character references first, then environment plates, then vehicles and props. Hard cap: 9 total for Seedance.

| Slot | Library slug | Reference type | Notes |
|---|---|---|---|
| @image1 | `[CHAR-SLUG]-FACE-LOCK` or `[CHAR-SLUG]-OUTFIT-[SLUG]` | Character canonical | |
| @image2 | | | |
| @image3 | | | |
| @imageN | `ENV-[SLUG]` | Environment plate | Carries world geometry |

**Total reference count:** [N] of 9

**Canonical-over-plate check:** Every named character and vehicle in this shot has their canonical reference in a dedicated slot. (Confirm: yes / no — if no, flag as a library gap.)

---

## Cinema-mode

**Mode:** [ ] M1 Narrative / [ ] M2 Studio-Editorial / [ ] M3 Action-Combat / [ ] M4 Performance-Concert / [ ] M5 Atmospheric-Empty

**Deviation from world bible default?** [ ] No / [ ] Yes — reason:

---

## Framing notes

(High level only — the destination skill owns the exact camera grammar)

**Shot scale:** (wide / medium / close-up / extreme close-up)
**Depth layers:** (what is in foreground / midground / background)
**Camera movement:** (static / slow push / handheld / locked off / etc. — prompt suggestion only, final call is the destination skill's)
**Key compositional intent:** (e.g., character anchored left third, car in center midground / symmetrical two-shot with negative space at center / low-angle looking up at subject)

---

## Runtime (video shots only)

**Requested runtime:** [N] seconds

> Never assume a default. If not specified by the Showrunner, ask before writing the spec.

**Shot count inside this Seedance prompt:** [ ] Single shot / [ ] Multi-shot sequence ([N] shots)

**Per-shot beats (if multi-shot):**
- Shot 1 (0–[N]s): [brief beat description]
- Shot 2 ([N]–[N]s): [brief beat description]

---

## Audio notes (video shots only)

Diegetic sounds to include in the Sound Bed. No music, no lyrics.

- (e.g., continuous rain impact on car body and ground)
- (e.g., engine idle)
- (e.g., fabric movement on pose shift)
- (e.g., single mechanical wiper sweep at [timestamp])

---

## Continuity with adjacent shots

What does this shot need to match from the previous shot, or set up for the next?

**Must match from previous shot:**
- (e.g., "ZARA-OUTFIT-A-RAINY state — she has been in rain for the previous three shots, fabric should read damp throughout")
- (e.g., "Car headlights on and pop-up housings deployed — established in shot 01")

**Must set up for next shot:**
- (e.g., "Wipers are OFF throughout this shot — Shot 4 is the wiper-activation beat")

**Cross-frame rules (if multi-character):**
- (e.g., "@image1 holds in driver's seat, @image2 holds in passenger seat — no position swap across the cut")

---

## Pre-handoff continuity checklist

Run before routing this spec to the destination skill. Check means confirmed, not assumed.

Character locks
- [ ] Face lock reference is LOCKED in the library index for every character in this shot
- [ ] Outfit reference is LOCKED for every wardrobe state in this shot (or PENDING build is flagged)
- [ ] All state-change deltas (damp, dirty, torn, jacket-off) are documented above under condition delta

Environment locks
- [ ] Environment plate is LOCKED (or PENDING and flagged as a library gap)
- [ ] Canonical-over-plate rule applied: canonical references in dedicated slots, plate does not substitute for any canonical reference

Cinema-mode alignment
- [ ] M-mode matches world bible (or deviation is noted and approved)
- [ ] M-mode matches the banana-pro scene plate mode if a scene plate is being used

Reference slots
- [ ] All @imageN assignments are pulled from the library index and recorded above
- [ ] Total reference count is 9 or fewer
- [ ] Slot order is documented

---

## Destination handoff

**Route to:** banana-pro-director / cinema-worldbuilder-pro

**Handoff note to the destination skill:**
(Any additional context the skill needs that isn't captured above — unusual compositional requests, specific reference to a prior approved output the director should match, etc.)

---

*Shot spec complete. Route to destination skill.*
