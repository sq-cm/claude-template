# Pipeline Integration — Cross-Scene Workflow

Process lore for multi-scene animated short-film production. These are workflow techniques that live outside the prompt grammar — they govern how scenes connect across a production, not how individual prompts are written.

**These notes describe the pipeline. No tool or platform name from this document should ever appear in prompt output.**

---

## Previous-Video Attachment for Cross-Scene Consistency

Feed the completed video from scene N into the generation tool alongside the prompt for scene N+1. This carries forward:
- Visual style continuity (the engine reads the prior clip's aesthetic register)
- Portal effects, teleport signatures, or other recurring visual motifs
- Character silhouette and costume state as they appeared at the end of the prior scene

Without the previous video attached, each scene generates independently and style drift accumulates across the cut.

---

## Prop Sheet via Claude for Cross-Scene Prop Consistency

When a prop recurs across multiple scenes (a watch, a weapon, a distinctive object):

1. Upload the character key frame or reference image to Claude.
2. Ask Claude to generate a prop sheet that matches the exact visual style of that image.
3. Generate the prop sheet as a multi-angle reference (front, side, back, detail inset) — the generation engine needs to know what the prop looks like from every direction to hold it consistent across shots.
4. Attach the prop sheet as a reference image for every subsequent scene in which the prop appears.

A multi-angle prop sheet prevents the prop from redesigning itself between cuts.

---

## Style Refinement Without Re-Generation

When a generated key frame has the right visual style but a character detail is wrong (hair color, wardrobe, a specific feature):

- Take the output image into a targeted image-editing tool.
- Make the specific swap (hair to black, suit instead of armor, etc.).
- Use the edited result as the new key frame — do not regenerate from scratch.

This preserves the style, lighting, and composition of a successful generation while correcting only what needs to change.

---

## Scene-to-Scene Workflow (Standard Chain)

1. Generate a key frame in a stylized image generator (for the style register of the new scene).
2. If the character needs to match a prior scene's look, refine the key frame in an image editor rather than regenerating.
3. Upload the key frame + the prior scene's video into Claude with the scene description.
4. Claude produces the prompt.
5. Feed the prompt + key frame + prior video into the generation tool.

This three-input structure (prompt + key frame + prior video) is what maintains story continuity across scenes with different visual styles.

---

## Character-State Accumulation

Track and carry forward any physical changes the character accumulates across scenes. Example: by the final scene of an eight-scene film, the character might have a torn jacket, paint on his face, and a missing shoe — each damage state earned in a prior scene.

When writing the prompt for a late-in-sequence scene, describe the accumulated state explicitly in the character description. Do not describe the character as fresh or intact unless the narrative resets them.

---

## Scene Length and Generation Count

- Keep each scene at or under 15 seconds. This is the reliable complexity ceiling for a single generation run.
- One generation per visual style. Scenes in different animation registers should be separate generation runs — do not attempt to blend two visual styles in a single generation.
- One dominant action per scene. If a scene requires more than one major beat, split it into separate prompts.

---

## Manga and Style-Specific Character Sheets

When a scene's visual style requires the character to exist in a new register (e.g., the character must now appear as a manga drawing rather than a paper-cutout cartoon):

1. Upload the original key frame and any prop reference sheets to Claude.
2. Ask Claude for a character sheet in the new style (e.g., "manga character sheet that matches this exact visual language").
3. Generate that character sheet in a stylized image generator that specializes in that register.
4. Use the style-specific character sheet as the key frame reference for that scene's generation.

This re-anchors the character's visual identity into each new style while maintaining recognizable continuity (silhouette, hair, wardrobe markers, props).
