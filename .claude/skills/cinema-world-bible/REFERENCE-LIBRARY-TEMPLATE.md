# Reference Library Index — [PROJECT NAME]

> Every reference image asset for this project. Banana-pro-director builds these; this index tracks them. Shot specs pull @imageN slot assignments from here. Canonical character references always take priority over environment plates when slot count is constrained (Seedance hard cap: 9 references per prompt).

---

## Naming convention

```
[CHARACTER-SLUG]-[TYPE]-[VARIANT]      for character assets
ENV-[LOCATION-SLUG]-[CONDITION]        for environment plates
VEH-[VEHICLE-SLUG]-[ANGLE]            for vehicle references
PROP-[PROP-SLUG]                       for prop references
```

**Type codes:**
- `FACE-LOCK` — canonical face lock reference (banana-pro Mode 0)
- `OUTFIT-[SLUG]` — single-image outfit reference (banana-pro Mode 1)
- `SHEET-[SLUG]` — 6-panel character sheet (banana-pro Mode 2)
- `PLATE` — environment plate, no characters (banana-pro Mode 3B)
- `SCENE` — scene plate with characters (banana-pro Mode 3A)
- `EXT` — exterior vehicle or object reference
- `INT` — interior vehicle reference
- `DETAIL` — detail shot (banana-pro Mode 4 or Mode 2 detail panel)

---

## Character references

### [CHARACTER-SLUG] — [Short visual handle]

| Slug | Type | Status | Banana Pro mode | Higgsfield library name / file path | Notes |
|---|---|---|---|---|---|
| `[CHAR-SLUG]-FACE-LOCK` | FACE-LOCK | PENDING | Mode 0 | | |
| `[CHAR-SLUG]-OUTFIT-A` | OUTFIT-A | PENDING | Mode 1 | | Dry base state |
| `[CHAR-SLUG]-OUTFIT-A-RAINY` | OUTFIT-A-RAINY | PENDING | Mode 1 | | Post-rain state delta |
| `[CHAR-SLUG]-SHEET-A` | SHEET-A | PENDING | Mode 2 | | Built after OUTFIT-A locked |

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

Every locked reference that will be passed as a Seedance reference input must have a corresponding asset in the operator's Higgsfield "Elements" library. The slug in this index is the canonical identifier — the operator names the Higgsfield Elements entry with the **exact same slug** so that shot specs, build queues, and handoff notes can all refer to a single unambiguous identifier.

**Important — this is an index and operator-handoff convention, not prompt-body syntax.** Slugs are never written as `@slug` into a Banana Pro or Seedance prompt body. banana-pro-director-2.0 explicitly prohibits `@image` tags in prompt bodies (attachment happens in the Higgsfield UI directly). The mapping below records the relationship between the slug (what this skill tracks), the @imageN position (what cinema-worldbuilder-pro-2.0 places in the Seedance prompt body), and the Higgsfield Elements name (what the operator loads in the UI at generation time).

```
Slug (library index)  →  @imageN slot (Seedance prompt)  →  Higgsfield Elements name (UI)
```

| Slug | @imageN slot | Higgsfield Elements name | Status | Notes |
|---|---|---|---|---|
| `[SLUG]` | @image[N] | [exact name as entered in Higgsfield Elements UI] | PENDING / LOCKED | |

**Rules:**
- The Higgsfield Elements name must match the slug exactly (case-insensitive matching is fine; spaces replaced with hyphens is fine — but the token must be recognisable as the slug).
- The @imageN slot is assigned by the shot spec, not here — this column is a reference lookup, not an authoritative slot assignment. Authoritative slot assignments live in the Slot assignment log below and in individual shot specs.
- When an asset is renamed in Higgsfield, update both the Elements name column here **and** the slug column. Slug and Elements name must remain in sync.
- This mapping sits above the @imageN grammar: slug → @imageN → Elements name. The @imageN ordering (CWP / cinema-worldbuilder-pro-2.0 grammar) governs what goes in the prompt body; this index governs what the operator loads in the UI to match it.

---

## Slot assignment log

When a shot spec is written, record the @imageN assignments here so any future shot in the same sequence can maintain slot consistency.

| Shot ID | @image1 | @image2 | @image3 | @image4 | @image5 | @image6 | @image7 | @image8 | @image9 |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

**Canonical-over-plate rule (hard lock):** Every named subject (character, vehicle, prop) that appears in a shot gets its canonical reference in its own @imageN slot — even if that subject is also visible in the environment plate. The plate carries world geometry. The canonical reference carries identity. Never substitute one for the other.

---

## Build queue

Assets that need to be built before upcoming shots can be prompted. Prioritized by production dependency.

| Priority | Slug | Blocking which shots | Route to | Status |
|---|---|---|---|---|
| 1 | | | banana-pro-director-2.0 Mode [N] | PENDING |

---

## Change log

| Date | Asset slug | Change | Author |
|---|---|---|---|
| | | | |
