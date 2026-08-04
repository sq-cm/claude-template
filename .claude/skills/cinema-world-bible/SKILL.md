---
name: cinema-world-bible
description: Continuity tracker and prep system for an ACTIVE narrative AI-film production — world bible, character bibles, reference-image library index, shot specs. Use for "lock a character," "world bible," "continuity," "shot list," "reference library," or continuity-checklist work once a production is already underway. Produces specs that route to banana-pro-director, cinema-director, seedance-commercial-director, or character-builder — never writes those prompts itself. Not for a portable standalone canon document with no production yet — that's story-bible-builder; hand off there first, then return here once shots start.
---

# Cinema World Bible

**Version.** Updated 04/08/2026 for the upstream drop-2 ripple: `cinema-worldbuilder-pro` renamed to `cinema-director` (13-block locked house format, no standalone Frame Map block — screen-space per-shot placement now lives in each SHOT block's Position line); new `character-builder` skill installed as the primary destination for face-lock, outfit, and character-sheet builds (previously `banana-pro-director` Modes 0/1/2). Cross-refs and routing below updated accordingly; `banana-pro-director` keeps its full mode set and remains the destination for environment plates, scene plates, and detail shots.

The continuity layer that sits between the brief and the prompt skills. This skill owns the prep work that makes shot-to-shot consistency possible: the world record, the character specs, the reference-image index, and the shot specs that feed banana-pro-director, character-builder, and cinema-director.

It does not write Banana Pro, GPT Image 2, or Seedance prompts. It organizes everything those skills need before they run.

---

## Why this skill exists

Consistency across shots is the hardest problem in AI film pipelines. Locked reference sheets help. Separating identity from styling helps. Wardrobe locks help. But those things only help if they exist before the video prompt runs — and if they are organized so the prompt skill can find the right references and attach them in the right order.

This skill is the prep infrastructure. Every shot that works first try in a well-run pipeline had locked references, locked wardrobe, and a locked environment plate before the video prompt was written. This skill is the system that produces and tracks those locks.

---

## Scope and boundaries

**This skill owns:**
- The world bible (setting, palette, tone, cinema-mode register)
- Character bibles (visual identity specs, wardrobe states, identity markers)
- Outfit Bible (per-character colour palette, signature silhouette, identity markers — a companion doc to the character bibles, never contradicting them)
- Reference-image library index (naming convention, slot assignments)
- Continuity rules (the canonical-over-plate rule, wardrobe lock-down, cross-shot checks)
- Shot specs (a structured brief that names which references attach, in what order, at what runtime)

**This skill does not own:**
- Banana Pro or Seedance prompt grammar — route to `banana-pro-director` for scene/environment stills, `cinema-director` for video, `seedance-commercial-director` for commercial/product briefs, `character-builder` for character-reference stills (face locks, outfits, character sheets)
- Visual execution — the Showrunner or Stills Director runs the prompts, not this skill
- Content strategy or narrative — the story brief comes in from upstream; this skill tracks its visual consequences
- Portable standalone canon documents — if the user wants a dense, installable, world-and-character canon file with no active production yet (no shots, no references), that's `story-bible-builder`. Route there first; once a production starts and shots need locking, the resulting bible feeds this skill's character bible and world bible fields.

---

## Workflows

### 1. Start a new project — build the world bible

Run this first on any new project. A world bible does not need to be complete before character work begins, but the cinema-mode register and palette grade must be locked before any scene plates are built.

Use the world bible template: [WORLD-BIBLE-TEMPLATE.md](WORLD-BIBLE-TEMPLATE.md)

Steps:
1. Take the project brief and fill the world bible template
2. Lock the cinema-mode register (M1–M5) — this determines the camera grammar that every banana-pro scene plate and every Seedance prompt will use
3. Lock the palette grade — dominant tones, color temperature, grade style
4. Identify recurring locations and flag which need environment plates built in banana-pro-director (Mode 3B)
5. Note which characters will need character bibles

Deliver: a completed world bible markdown file, saved to the project folder.

---

### 2. Build or update a character bible

Run this for every named character before any outfit work, scene plate, or Seedance prompt is built for them. The character bible is the canonical source the operator skills' "trust the reference" rule points back to.

Use the character bible template: [CHARACTER-BIBLE-TEMPLATE.md](CHARACTER-BIBLE-TEMPLATE.md)

Steps:
1. Collect the character brief (written description, reference images if any)
2. Fill the character bible template — identity spec, voice register, wardrobe states, identity markers, locked references
3. Note which reference images still need to be built (face lock, outfit refs, 3-panel character sheet) and flag them as PENDING
4. Mirror back the locked spec for confirmation before marking anything as LOCKED
5. Update the reference-image library index with the character's reference slots

Character bible rules:
- Identity descriptors are visual only — no names in prompt output, no ages, no brand names (real brand names only where the production has confirmed authorisation — client's own brand or user-accepted risk; otherwise generic descriptors)
- Voice-register descriptors (timbre, cadence, phrasing) are not visual and are exempt from the identity-descriptor visual-only rule — they exist to carry into a Seedance Sound Bed or dialogue block, not a visual prompt block
- Describe by build, bone structure, hair, skin, eye shape, key identity markers (piercings, scars, beauty marks, tattoos, signature jewelry)
- Every wardrobe state gets a short slug name (e.g., `ZARA-OUTFIT-A`, `ZARA-OUTFIT-A-RAINY`) so shot specs can reference it unambiguously
- A wardrobe state is not locked until a base reference image exists (character-builder Part 3 — Outfit Builder, Step 2 direct-on-model build, or the invisible-mannequin path for complex construction)
- A character is not fully locked until a face-lock reference exists (character-builder Part 1 — Build From Scratch, Step A2 canonical 3:4 chest-up lock) and is indexed

Deliver: a completed character bible markdown file, saved to the project folder.

---

### 3. Maintain the reference-image library index

Every reference asset (face locks, outfit references, 3-panel character sheets, environment plates, vehicle references, prop references) gets an entry in the project's reference library index.

Use the library index template: [REFERENCE-LIBRARY-TEMPLATE.md](REFERENCE-LIBRARY-TEMPLATE.md)

Naming convention:
```
[CHARACTER-SLUG]-[TYPE]-[VARIANT]
```

Examples:
- `ZARA-FACE-LOCK` — canonical face lock for Zara
- `ZARA-OUTFIT-A` — Zara in Outfit A, dry
- `ZARA-OUTFIT-A-RAINY` — Zara in Outfit A, post-rain state
- `ZARA-SHEET-A` — 3-panel character sheet for Outfit A
- `ENV-GARAGE-NIGHT` — garage lounge environment plate, night
- `VEH-NULL-CAR-EXT` — NULL widebody car exterior reference

Each entry records:
- Slug name
- Reference type (face-lock / outfit-ref / character-sheet / environment-plate / vehicle-ref / prop-ref)
- Status (PENDING / BUILT / LOCKED)
- File path or Higgsfield library name
- Which skill (and mode, where applicable) built it — character-builder for face locks / outfits / character sheets, or banana-pro-director Mode 3B for environment plates
- Notes (wardrobe state, conditions, which character it belongs to)

**Higgsfield Elements name mapping — slug convention:**

Slugs are an index and operator-handoff convention; the element tag (e.g. `@zara_face`) is the prompt-facing handle assigned once per locked asset — attachment happens in the Higgsfield UI, the tag just names what got attached. Authoritative record, mapping chain (slug → element tag → Elements name), and sync rules: REFERENCE-LIBRARY-TEMPLATE.md § "Higgsfield Elements name mapping".

Slot assignment for Seedance (max 9 references per prompt):
- When building a shot spec, assign element tags from the index. Record the assignment in the shot spec. Canonical character references always take priority over environment plates when tag count is constrained.

---

### 4. Run the still→video continuity checklist

Before any shot spec routes to cinema-director, run this checklist. It encodes the canonical-over-plate rule and the identity lock-down lines that prevent drift.

**Pre-handoff continuity checklist:**

Character locks
- [ ] Every character in the shot has a LOCKED face-lock reference in the library index
- [ ] Every wardrobe state in the shot has a LOCKED outfit reference (character-builder Part 3 — Outfit Builder) in the library index
- [ ] Every wardrobe state that differs from the dry base (wet, torn, dirty) is flagged as a separate wardrobe state slug and a separate reference image exists or is PENDING build
- [ ] Identity markers (piercings, scars, beauty marks, tattoos) are documented in the character bible and visible in the locked reference

Environment locks
- [ ] Every recurring location has a LOCKED environment plate in the library index (or is flagged PENDING)
- [ ] The canonical-over-plate rule is noted: the environment plate carries world geometry; the character canonical reference carries identity — never substitute one for the other in the element-tag assignment

Cinema-mode alignment
- [ ] The cinema-mode register for this shot (M1–M5) matches the project's registered mode in the world bible (or deviation is deliberate and noted)
- [ ] The M-mode selected in the shot spec matches what banana-pro used for the scene plate, if one exists

Reference-slot assignment
- [ ] Element tags are assigned from the library index, with canonical character references filling their tags before environment plates
- [ ] Total reference count does not exceed 9 (Seedance hard cap)
- [ ] Priority order is documented in the shot spec so cinema-director can place the element tags correctly

---

### 5. Write a shot spec

A shot spec is the structured brief this skill hands to the Stills Director (banana-pro-director), the Seedance Director (cinema-director), or the Commercial Director (seedance-commercial-director) for commercial briefs. It is not a prompt — it is the information those skills need to write the prompt.

Use the shot spec template: [SHOT-SPEC-TEMPLATE.md](SHOT-SPEC-TEMPLATE.md)

A shot spec contains:
- Shot ID and sequence position
- Destination skill (banana-pro-director for a still / cinema-director for video / seedance-commercial-director for a commercial spot)
- Scene description (dramatic moment, not camera grammar)
- Characters in frame, with their character bible slug and wardrobe state slug
- Reference assignments (element tags from the library index)
- Cinema mode (M1–M5)
- Framing notes (wide / medium / close-up, depth layers)
- Runtime (video only — never default; always confirm with the director)
- Continuity notes (what this shot must match from previous shots in the sequence)
- Any wardrobe state deltas not visible in the reference (damp, dirty, torn — state-changes the image can't carry)
- Handoff destination (banana-pro-director, cinema-director, or seedance-commercial-director)

The shot spec does NOT contain:
- Banana Pro prompt grammar
- Seedance block structure
- Element tags written into prose — those belong in the Seedance prompt the cinema-director skill writes, not in the spec

---

### 6. Build a schematic map

Text cannot hold a location. A schematic map can — and size and position stay consistent take after take. Build a schematic map for any location where prop or subject placement must be reproducible across shots.

Use the schematic map template: [SCHEMATIC-MAP-TEMPLATE.md](SCHEMATIC-MAP-TEMPLATE.md)

A schematic map is a top-down spatial diagram of a single location. It records the GPT Image 2 prompt used to generate the diagram, the locked spatial facts extracted from it (which prop is where, at what size relative to a human figure), and a link to the generated diagram image.

**Relationship to per-shot screen-space grammar (cinema-director):**
- The schematic map is a **world-space prep artefact** — it records where props and landmarks physically sit in the location geometry (e.g., "fire hydrant at kerb; skydancer anchored 2× person-height to its right on the same line"). It is produced once per location, before shot prompting begins.
- cinema-director's 13-block locked house format carries no standalone Frame Map block. Screen-space per-shot placement — where each character sits in the frame (left / centre / right, foreground / midground / background) — now lives in each timecoded SHOT block's Position line, reinforced by the staging locks in Cross-Frame Rules.
- The schematic map informs the SHOT block Position lines. It does not replace them. Do not duplicate the schematic map's world-space spatial facts inside a Position line; reference the schematic map instead.

Steps:
1. Identify the location and list every prop or landmark that must stay spatially consistent
2. Write the GPT Image 2 schematic prompt (top-down view, labelled diagram, clean linework — no shading, no perspective)
3. Generate the diagram and save it to the project folder
4. Extract locked spatial facts from the diagram (position, relative size, clearance distances) and record them in the template
5. Attach the schematic map file path to the world bible's location entry and to any shot spec that uses this location

Deliver: a completed schematic map markdown file, saved to the project folder, with the generated diagram image linked or embedded.

---

## Quick start

**New project:** "Start a world bible for [project name]." → Skill fills the world bible template.

**New character:** "Build a character bible for [character description]." → Skill fills the character bible template and flags what reference builds are needed.

**Index a new reference:** "Add [reference name] to the library index." → Skill adds the entry with status, type, and slot note.

**Pre-video checklist:** "Run the continuity checklist for [shot description]." → Skill runs the checklist and flags any gaps before the shot spec routes to cinema-director.

**Shot spec:** "Write a shot spec for [scene description]." → Skill fills the shot spec template and hands it to the appropriate skill.

**Schematic map:** "Build a schematic map for [location name]." → Skill fills the schematic map template, records the GPT Image 2 diagram prompt, and locks the spatial facts for that location.

---

## Relationship to the operator skills

| Task | This skill | Downstream skill |
|---|---|---|
| Lock character identity spec | Yes — character bible | — |
| Build face-lock reference image | Flags as PENDING, writes spec | character-builder Part 1 (Build From Scratch, Step A2 canonical lock) |
| Build outfit reference image | Flags as PENDING, writes spec | character-builder Part 3 (Outfit Builder) |
| Build 3-panel character sheet | Flags as PENDING, writes spec | character-builder Part 3 (the 3-panel character sheet) |
| Build headless 3-panel Seedance-handoff sheet (Subject Lock anchor) | Flags as PENDING, writes spec | character-builder Part 3 (the headless 3-panel sheet — Seedance handoff) |
| Build environment plate | Flags as PENDING, writes spec | banana-pro-director Mode 3B |
| Write Banana Pro / GPT Image 2 prompt (scene, environment, or detail plate) | Never | banana-pro-director |
| Write Banana Pro / GPT Image 2 prompt (character reference) | Never | character-builder |
| Write Seedance prompt | Never | cinema-director |
| Assign element tags for a shot | Yes — in the shot spec | cinema-director uses these |
| Map slug → element tag → Higgsfield Elements name | Yes — Elements name mapping in reference library | Operator loads matching asset in Higgsfield UI |
| Track M-mode consistency | Yes — world bible | cinema-director enforces in prompt |
| Run pre-video continuity check | Yes | — |
| Build schematic map (world-space prop layout) | Yes — schematic map template | — |
| Screen-space character position per shot (SHOT block Position line) | Schematic map informs it | cinema-director owns the Position-line grammar |

---

## Advanced reference

- [WORLD-BIBLE-TEMPLATE.md](WORLD-BIBLE-TEMPLATE.md) — project-level world record
- [CHARACTER-BIBLE-TEMPLATE.md](CHARACTER-BIBLE-TEMPLATE.md) — per-character identity and wardrobe record
- [OUTFIT-BIBLE-TEMPLATE.md](OUTFIT-BIBLE-TEMPLATE.md) — per-character colour palette, silhouette, and identity-marker companion doc, cross-checked against the character bible
- [REFERENCE-LIBRARY-TEMPLATE.md](REFERENCE-LIBRARY-TEMPLATE.md) — reference-image index, slot assignments, and Higgsfield Elements name mapping
- [SHOT-SPEC-TEMPLATE.md](SHOT-SPEC-TEMPLATE.md) — shot brief for handoff to banana-pro-director or cinema-director
- [SCHEMATIC-MAP-TEMPLATE.md](SCHEMATIC-MAP-TEMPLATE.md) — top-down spatial diagram spec for locking prop position and size per location
