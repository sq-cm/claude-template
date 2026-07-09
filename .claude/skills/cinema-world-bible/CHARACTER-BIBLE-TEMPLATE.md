# Character Bible — [CHARACTER-SLUG]

> This is the canonical source for this character's visual identity. Every banana-pro prompt and every Seedance Subject Lock block points back here. Do not write character names, real ages, or brand names into any prompt output — use visual descriptors only.

**Project:**
**Character slug:** `[CHAR-SLUG]`
**Short visual handle:** (the 4–6 word descriptor used in prompts — e.g., "jet-black-bangs high-ponytail woman")
**Status:** [ ] In development / [ ] Face lock built / [ ] Fully locked

---

## Identity spec (locked visual descriptor)

This is the text spec that banana-pro-director-2.0 uses at Mode 0 (face lock) and carries into every downstream prompt. Fill it from reference images or from the character brief. Confirm with the Showrunner before marking LOCKED.

**Build:**
(e.g., slim with refined proportions / athletic / full / slight — described by silhouette and proportion, never by size numbers)

**Face:**
(bone structure, face shape, eye shape and color, brow shape, nose, lip shape — plain visual description)

**Skin:**
(tone and finish — e.g., warm fair matte Korean skin / deep warm brown with natural matte finish / warm tan with fine even texture)

**Hair:**
(color with every nuance, length, texture, default style, parting, any signature styling)

**Default makeup register:**
(skin finish, brow treatment, eye treatment, lip register, cheek treatment — described as what the camera sees, not product names)

**Default expression and energy:**
(e.g., sharp neutral, subtle controlled energy, eyes direct / soft smirk, relaxed / intense and held)

**Key identity markers:**
List every marker that must appear consistently and be noted in every prompt that shows this character at close range:

| Marker | Description | Visibility threshold |
|---|---|---|
| (e.g., Beauty mark) | (small dark beauty mark under the left eye) | (visible in close-up and medium shots; drop from wide shots per resolution-aware detail rule) |
| (e.g., Scar) | (thin scar through the right brow) | |
| (e.g., Piercing) | (small silver hoop at the left nostril) | |
| (e.g., Tattoo) | (fine-line script on the inside of the right forearm — visible at waist-up framing) | |

**Naming rule (HARD LOCK):** Never use this character's real name in any prompt output. Always refer by the short visual handle (e.g., "the jet-black-bangs high-ponytail woman") or by their @imageN reference tag.

**Age-blind rule (HARD LOCK):** Never describe by age. No "young," "mid-twenties," "older," "teen," "girl," "boy," "elderly." Describe by build, role, and wardrobe.

**Brand-neutral rule (HARD LOCK):** No real brand names in prompt output. Use generic visual descriptors — "three-stripe athletic sneakers," "wide-logo athletic tee," "chunky platform boots."

---

## Voice register

Voice consistency is a context problem, not a tool problem: if the model doesn't have a locked reference for how this character sounds, it improvises a different voice every time. This section is that lock — every Seedance dialogue or voiceover-bearing prompt for this character draws its Sound Bed and phrasing choices from here.

**Register:**
(e.g., mid-range with a slight sassy edge / low and even / bright and quick)

**Timbre:**
(the quality of the voice itself — warm and breathy, clipped and precise, rasp on the low end)

**Cadence:**
(pace and rhythm — clipped short sentences, long unhurried run-ons, deliberate pauses before a point)

**Phrasing patterns:**
(how this character specifically constructs a sentence — word choice, sentence length, verbal tics — described comparatively where a second character exists, e.g., "Daye leads with the conclusion and backfills the reason; Mira leads with the reason and holds the conclusion back")

**Notes for downstream prompts:**
(anything that must carry into a Sound Bed or dialogue block — accent markers, things this character would never say, energy under pressure vs. at rest)

---

## Locked reference images

The reference images that carry this character's identity. Mark each as PENDING (not yet built), BUILT (generated, not finalized), or LOCKED (finalized and indexed).

| Ref type | Library slug | Status | Notes |
|---|---|---|---|
| Face lock (Mode 0) | `[CHAR-SLUG]-FACE-LOCK` | PENDING / BUILT / LOCKED | Banana Pro or GPT-2 path |
| 6-panel character sheet (Mode 2) | `[CHAR-SLUG]-SHEET-[OUTFIT]` | PENDING / BUILT / LOCKED | Built after Mode 1 base |

> The face lock reference is the canonical identity anchor. No outfit work (Mode 1), no scene plates (Mode 3), and no Seedance prompts should be built for this character until the face lock is LOCKED.

---

## Wardrobe states

Each outfit or wardrobe condition that this character wears across the project. A wardrobe state is not locked until a Mode 1 base reference exists.

### [OUTFIT-SLUG] — [Short outfit description]

**Status:** PENDING / BUILT / LOCKED

**Garments (top to bottom):**
(fabric, color, fit, structural details, neckline, sleeve, hem — every visible garment)

**Footwear:**

**Jewelry and accessories:**
(every piece — earring style, necklace count and material, rings, bracelets, bag, sunglasses, belt)

**Body markers visible in this outfit:**
(which identity markers from above are visible in this wardrobe state)

**Condition variants:**
List any condition-specific versions of this outfit that need separate reference images:

| Condition slug | Description | Status | Library ref |
|---|---|---|---|
| `[OUTFIT-SLUG]-DRY` | Base dry state | | |
| `[OUTFIT-SLUG]-RAINY` | Post-rain — fabric darker and damp where rain has soaked in, hair damp | PENDING | |
| `[OUTFIT-SLUG]-DIRTY` | Dusty or dirty from a specific scene | PENDING | |

**Reference images for this wardrobe state:**

| Ref type | Library slug | Status |
|---|---|---|
| Outfit reference (Mode 1) | `[CHAR-SLUG]-OUTFIT-[SLUG]` | PENDING / BUILT / LOCKED |
| 6-panel sheet (Mode 2) | `[CHAR-SLUG]-SHEET-[SLUG]` | PENDING / BUILT / LOCKED |

**Prompt notes for this wardrobe state:**
(anything that does not appear in the reference images and must be written into prompts — e.g., "jacket removed in cabin scenes — reference shows jacket on; note in shot spec as state-change delta")

---

*(Add additional wardrobe states by duplicating the section above)*

---

## Character continuity rules

Rules specific to this character that every shot spec and every prompt must respect:

- (e.g., "Jacket-removed state: when the jacket is off, the reference shows it on — always flag as a state-change delta in the shot spec")
- (e.g., "Ring stack: the layered gold rings appear on both hands — reference the 6-panel detail shot panel for clarity")
- (e.g., "Hair: high ponytail is the locked default; loose hair is a distinct wardrobe state requiring its own outfit reference")

---

## Change log

| Date | Change | Author |
|---|---|---|
| | | |
