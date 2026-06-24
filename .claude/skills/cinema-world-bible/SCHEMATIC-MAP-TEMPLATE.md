# Schematic Map — [LOCATION SLUG]

> A top-down spatial diagram artefact for a single location. Records prop positions, sizes, and clearance distances so they stay consistent take after take. Text cannot hold a location; a map can.
>
> **Relationship to the Frame Map:** this schematic map is a world-space prep artefact (where things physically are in the location geometry). The Frame Map, owned by cinema-worldbuilder-pro-2.0, is a screen-space per-shot grammar (where characters sit in the frame for a specific Seedance prompt). The schematic map informs the Frame Map — it does not duplicate or replace it. Do not write Frame Map entries here; reference this document from the Frame Map instead.

**Project:**
**Location slug:** (e.g., `ENV-STREET-DAY`, `ENV-GARAGE-NIGHT`)
**Location description:** (one sentence — physical space, time of day, key character of the space)
**Date locked:**

---

## GPT-Image-2 schematic prompt

Record the exact prompt used to generate the top-down diagram. Version it if regenerated.

**Version:** 1.0
**Prompt:**

```
Top-down architectural diagram of [location description]. Clean linework, no shading, no perspective, no colour. Label every prop and landmark. Include a human-figure scale reference at [position]. Minimal style, white background, black lines.
```

*(Replace bracketed content. Add specific props and landmarks as needed. The human-figure scale reference is mandatory — it anchors all size comparisons.)*

**Generated diagram:** [file path or embed]

---

## Locked spatial facts

Extract these from the diagram after generation. Each fact must be verifiable against the diagram image. Lock = confirmed stable; do not change without regenerating the schematic.

### Anchor points

Anchor points are fixed landmarks that other props are positioned relative to. Every schematic map must have at least one anchor point.

| Anchor slug | Description | Position in diagram (e.g., lower-left quadrant, centred on kerb line) | Notes |
|---|---|---|---|
| `ANCHOR-[SLUG]` | (e.g., fire hydrant) | (e.g., lower-left quadrant, on kerb, 20% from left edge) | |

### Prop positions

| Prop slug | Description | Positioned relative to | Direction | Distance | Size relative to human figure | Status |
|---|---|---|---|---|---|---|
| `PROP-[SLUG]` | (e.g., skydancer / inflatable tube figure) | `ANCHOR-[SLUG]` | (e.g., directly right) | (e.g., 0.5× human-figure width) | (e.g., 2× person-height) | LOCKED |

**Size convention:** all sizes are expressed as multiples of the human-figure scale reference included in the diagram (e.g., "2× person-height", "0.5× shoulder-width"). Never use absolute units — the diagram has no real-world scale, only relative proportions.

### Clearance zones

Record any clearance distances that matter for composition or safety (digital safety for characters passing props, clearance for camera sightlines, etc.).

| Zone | Between | Clearance distance | Notes |
|---|---|---|---|
| (e.g., hydrant-to-skydancer gap) | `ANCHOR-[SLUG]` and `PROP-[SLUG]` | (e.g., 0.3× human-figure width) | Character must pass through this gap in S02-03 |

---

## Location geometry notes

Any spatial facts about the location itself (not props) that affect shot composition.

- (e.g., kerb line runs horizontally across lower third of diagram)
- (e.g., building façade establishes hard left edge — nothing exits left)
- (e.g., street depth allows three distinct depth planes: kerb / mid-street / far pavement)

---

## Frame Map cross-reference

This section links the schematic map to the per-shot Frame Map entries that use this location. Do not copy Frame Map content here — record the reference only.

| Shot ID | Frame Map entry location | Notes |
|---|---|---|
| (e.g., S01-E02-003) | (e.g., `SHOT-SPEC-S01-E02-003.md` § Reference-image assignments) | (e.g., skydancer slug used as @image4 in this shot) |

---

## Change log

| Date | Change | Author |
|---|---|---|
| | | |
