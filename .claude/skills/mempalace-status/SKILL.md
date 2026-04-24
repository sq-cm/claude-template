---
name: mempalace-status
description: Use when checking the current state of the MemPalace memory system, viewing palace statistics, or verifying the installation is healthy.
---

# MemPalace Status

## Step 1: Gather Palace Status

If MCP tools available: call `mempalace_status`.

CLI fallback:

    PYTHONUTF8=1 python -m mempalace status

## Step 2: Display Wing/Room/Drawer Counts

Present concisely:
- Number of wings, rooms, drawers
- Total memories stored

## Step 3: Knowledge Graph Stats (MCP only)

If MCP available, also call:
- `mempalace_kg_stats` — triple count, entity count, relationship types
- `mempalace_graph_stats` — connectivity, average connections per entity

## Step 4: Suggest Next Actions

- Empty palace: suggest `/mempalace:mine` to add data
- Has data but no KG: suggest adding knowledge graph triples
- Healthy palace: suggest `/mempalace:search` to query memories

Keep output brief — quick glance, not a report.
