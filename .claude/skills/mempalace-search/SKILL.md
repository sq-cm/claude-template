---
name: mempalace-search
description: Use when searching MemPalace memories, retrieving stored knowledge, or navigating the palace taxonomy by wing/room.
---

# MemPalace Search

## 1. Parse the Search Query

Extract the core search intent. Identify filters:
- Wing — top-level category (e.g., "work", "personal", "research")
- Room — sub-category within a wing
- Keywords / semantic query

## 2. Determine Wing/Room Filters

Map the user's context to wing/room if possible. If unsure, omit filters to search globally.

## 3. Use MCP Tools (Preferred)

Priority order:
- `mempalace_search(query, wing, room)` — primary search
- `mempalace_list_wings` — discover available wings
- `mempalace_list_rooms(wing)` — list rooms in a wing
- `mempalace_get_taxonomy` — full wing/room tree overview
- `mempalace_traverse(room)` — walk knowledge graph from a room
- `mempalace_find_tunnels(wing1, wing2)` — cross-wing connections

## 4. CLI Fallback

If MCP tools are not available:

    PYTHONUTF8=1 python -m mempalace search "query" [--wing X] [--room Y]

## 5. Present Results

- Include source attribution: wing, room, drawer for each result
- Show relevance scores if available
- Group by wing/room when returning multiple hits

## 6. Offer Next Steps

- Drill deeper — narrow the query or filter by room
- Traverse — explore knowledge graph from a related room
- Check tunnels — look for cross-wing connections
- Browse taxonomy — show full structure for manual exploration
