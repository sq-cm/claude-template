---
name: write-a-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill.
---

<!--
Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/write-a-skill (by Matt
Pocock, MIT). Synced against upstream commit `f304057` (12/05/2026) on 21/08/2026 via import commit
b019628 — lineage recorded retroactively (see plan 108); imported alongside the confirmed handoff
and prototype copies from the same repo. Local deltas: the SKILL.md line-limit guidance is raised
from 100 lines to ~150 (aim) / 500 (hard ceiling), with an added exemption for skills whose body is
a locked prompt grammar or determinism spec. Deliberately NOT resynced — lineage record only.
Upstream removed this skill at HEAD (last commit on the path: bc4cf90, 17/06/2026, "Added writing-great-skills skill"); its likely successor there is writing-for-agents. Not adopted — lineage frozen as above (plan 135, 24/09/2026).
Local adaptation, not a resync (plan 153, 15/10/2026): on a user ruling of 14/10/2026, writing-for-agents is vendored as its own skill (.claude/skills/writing-for-agents/, upstream 49dd158), reversing plan 135's "Not adopted" for it. This file stays frozen and keeps the lineage above; it gains one pointer line to writing-for-agents, an overlap check under Process, the "What makes a description fire" subsection and one Review Checklist item, the last three drawn from addyosmani/agent-skills @ aeac41d (by Addy Osmani, MIT).
-->

# Writing Skills

For the writing inside the skill (pointer wording, what stays in SKILL.md and what moves behind a pointer, completion criteria, pruning), use the `writing-for-agents` skill.

## Process

Before step 1, check for overlap: read the table in `.claude/skills/README.md` and the skill descriptions already in your context. If an existing skill covers the idea in whole or in part, propose extending that skill instead of adding a near-duplicate, and reference other skills by name rather than copying their content.

1. **Gather requirements** - ask user about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Draft the skill** - create:
   - SKILL.md with concise instructions
   - Reference files for distinct-domain or rarely-needed content (aim to keep SKILL.md under ~150 lines; 500 is a hard ceiling — determinism-spec exemption under "When to Split Files")
   - Utility scripts if deterministic operations needed

3. **Review with user** - present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more/less detailed?

## Skill Structure

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── REFERENCE.md       # Detailed docs (if needed)
├── EXAMPLES.md        # Usage examples (if needed)
└── scripts/           # Utility scripts (if needed)
    └── helper.js
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Link to separate files: See [REFERENCE.md](REFERENCE.md)]
```

## Description Requirements

The description is **the only thing your agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills. Your agent reads these descriptions and picks the relevant skill based on the user's request.

**Goal**: Give your agent just enough info to know:

1. What capability this skill provides
2. When/why to trigger it (specific keywords, contexts, file types)

**Format**:

- Max 1024 chars
- Write in third person
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"

**Good example**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:

```
Helps with documents.
```

The bad example gives your agent no way to distinguish this from other document skills.

### What makes a description fire

- **Name the case the model would do alone.** In agent-skills' measured runs (Claude Code, `claude-opus-5-5` pinned), describing what a skill adds did not raise firing; naming the requests users make, and saying the skill applies even in the case the model treats as "I can just do this myself", did. One clause, "even when the diff is pasted inline", took a review skill from 7 of 27 fires to 21 of 27, and nine nearby prompts that must not fire stayed at 0 of 27. A TDD skill needed its three request types named as well: 6 of 24 became 19 of 24.
- **Read rates, not single runs.** The same prompt fires in some runs and not in others. Compare a description change over several runs on one pinned model.
- **Say when; leave the how to the body.** An agent can follow process steps written in a description instead of reading the skill.
- **Use the user's words.** If a realistic request can't match because the description lacks its vocabulary, fix the description.
- **Close each overlap with a sibling skill** with a negative clause, "Not for X; use Y." (vault house style, plan 127; see `grill-me` and `brainstorming`).

Source: addyosmani/agent-skills @ aeac41d (by Addy Osmani, MIT): `evals/README.md` § Plugin evals, `docs/skill-anatomy.md`, `CONTRIBUTING.md` § Before proposing a new skill.

## When to Add Scripts

Add utility scripts when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## When to Split Files

Split into separate files when:

- SKILL.md is past ~150 lines (aim), or 500 lines (hard ceiling for instruction-style skills)
- **Determinism-spec exemption:** a skill whose body is a locked prompt grammar or determinism spec — where the exact wording IS the deliverable and splitting it across files would break reproducibility — may exceed the ceiling. Everything separable (background, rationale, examples) still moves to reference files first.
- Content has distinct domains (finance vs sales schemas)
- Advanced features are rarely needed

## Review Checklist

After drafting, verify:

- [ ] Description includes triggers ("Use when...")
- [ ] Overlap check done; each overlapping sibling skill is closed off with "Not for X; use Y."
- [ ] SKILL.md under ~150 lines (hard ceiling 500 — split before you reach it, unless the determinism-spec exemption applies)
- [ ] No time-sensitive info
- [ ] Consistent terminology
- [ ] Concrete examples included
- [ ] References one level deep
