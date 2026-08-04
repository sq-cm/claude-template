# Reference Library Index — [PROJECT NAME]

> Every reference image asset for this project. Character-builder builds face locks, outfits, and character sheets; banana-pro-director builds environment plates, scene plates, vehicle, and prop references; this index tracks all of them. Shot specs pull element-tag assignments from here. Canonical character references always take priority over environment plates when tag count is constrained (Seedance hard cap: 9 references per prompt).

---

## Naming convention

```
[CHARACTER-SLUG]-[TYPE]-[VARIANT]      for character assets
ENV-[LOCATION-SLUG]-[CONDITION]        for environment plates
VEH-[VEHICLE-SLUG]-[ANGLE]            for vehicle references
PROP-[PROP-SLUG]                       for prop references
```

**Type codes:**
- `FACE-LOCK` — canonical face lock reference (character-builder Part 1, Step A2 canonical lock)
- `OUTFIT-[SLUG]` — single-image outfit reference (character-builder Part 3, Outfit Builder)
- `SHEET-[SLUG]` — 3-panel character sheet, standard or headless Seedance-handoff variant (character-builder Part 3)
- `PLATE` — environment plate, no characters (banana-pro Mode 3B)
- `SCENE` — scene plate with characters (banana-pro Mode 3A)
- `EXT` — exterior vehicle or object reference
- `INT` — interior vehicle reference
- `DETAIL` — detail shot (banana-pro Mode 4 scene/environment detail, or a character-builder expression-set panel)

---

## Character references

### [CHARACTER-SLUG] — [Short visual handle]

| Slug | Type | Status | Build source | Higgsfield library name / file path | Notes |
|---|---|---|---|---|---|
| `[CHAR-SLUG]-FACE-LOCK` | FACE-LOCK | PENDING | character-builder Part 1 | | |
| `[CHAR-SLUG]-OUTFIT-A` | OUTFIT-A | PENDING | character-builder Part 3 | | Dry base state |
| `[CHAR-SLUG]-OUTFIT-A-RAINY` | OUTFIT-A-RAINY | PENDING | character-builder Part 3 | | Post-rain state delta |
| `[CHAR-SLUG]-SHEET-A` | SHEET-A | PENDING | character-builder Part 3 | | Built after OUTFIT-A locked |

**Wardrobe test-pass note:** a garment reference may pass through a mannequin test stage (proven on an invisible mannequin — headless display, no character anchor) before it is composited onto the canonical character. Track this as a Notes-column annotation on the outfit row (e.g., "mannequin-tested, not yet composited to character") rather than a new status value — Status stays PENDING until the character-anchored composite exists and is BUILT/LOCKED. The escalation path across generation tools during the mannequin stage (if one is used) is prompt-craft and belongs to @{StillsDirector}'s domain, not this index.

*(Add rows as outfit states and character sheet variants are built)*

---

## Environment plates

| Slug | Location | Time of day / condition | Status | Banana Pro mode | Higgsfield library name / file path | Notes |
|---|---|---|---|---|---|---|
| `ENV-[SLUG]-NIGHT` | | Night | PENDING | Mode 3B | | |

*(Add rows as environment plates are built)*

---

## Vehicle references

| Slug | Description | Status | Banana Pro mode | Higgsfield library name / file path | Notes |
|---|---|---|---|---|---|
| `VEH-[SLUG]-EXT` | | PENDING | Mode 3B or Mode 1 | | |
| `VEH-[SLUG]-INT` | | PENDING | Mode 3 | | |

---

## Prop references

| Slug | Description | Status | Banana Pro mode | Higgsfield library name / file path | Notes |
|---|---|---|---|---|---|
| `PROP-[SLUG]` | | PENDING | | | |

---

## Higgsfield Elements name mapping

Every locked reference that will be passed as a Seedance reference input must have a corresponding asset in the operator's Higgsfield "Elements" library, and a **user-supplied semantic element tag** the prompt can call it by — e.g. `@zara_face`, `@rain_plate`, `@garage_night`. The slug in this index is the canonical identifier; the element tag is the shorthand a prompt body actually carries.

**Important — this is an index and operator-handoff convention, not free-text syntax.** Element tags are assigned once per locked asset and never improvised mid-prompt. The mapping below records the relationship between the slug (what this skill tracks), the element tag (what cinema-director places in the Seedance prompt body), and the Higgsfield Elements name (what the operator loads in the UI at generation time).

```
Slug (library index)  →  @element_tag (Seedance prompt)  →  Higgsfield Elements name (UI)
```

| Slug | Element tag | Higgsfield Elements name | Status | Notes |
|---|---|---|---|---|
| `[SLUG]` | `@[semantic_tag]` | [exact name as entered in Higgsfield Elements UI] | PENDING / LOCKED | |

**Rules:**
- The Higgsfield Elements name must match the slug exactly (case-insensitive matching is fine; spaces replaced with hyphens is fine — but the token must be recognisable as the slug).
- The element tag is a short, memorable, lowercase-with-underscores handle derived from the slug (e.g. `ZARA-FACE-LOCK` → `@zara_face`) — assigned by this index, not improvised per-shot. Shot specs cite the tag; they don't invent one.
- When an asset is renamed in Higgsfield, update the Elements name column, the slug column, **and** the element tag if it changes meaning. All three must remain in sync.
- This mapping sits above the element-tag grammar: slug → element tag → Elements name. The element-tag ordering (cinema-director grammar) governs what goes in the prompt body; this index governs what the operator loads in the UI to match it.

---

## Element-tag assignment log

When a shot spec is written, record the element tags assigned here so any future shot in the same sequence can maintain consistency. Up to 9 element tags per prompt (Seedance hard cap).

| Shot ID | Element tags attached (in priority order) |
|---|---|
| | `@[tag1]`, `@[tag2]`, `@[tag3]`, … |

**Canonical-over-plate rule (hard lock):** Every named subject (character, vehicle, prop) that appears in a shot gets its canonical reference as its own element tag — even if that subject is also visible in the environment plate. The plate carries world geometry. The canonical reference carries identity. Never substitute one for the other.

---

## Build queue

Assets that need to be built before upcoming shots can be prompted. Prioritized by production dependency.

| Priority | Slug | Element tag | Blocking which shots | Route to | Status |
|---|---|---|---|---|---|
| 1 | | `@[semantic_tag]` | | banana-pro-director Mode [N] | PENDING |

---

## Change log

| Date | Asset slug | Change | Author |
|---|---|---|---|
| | | | |
