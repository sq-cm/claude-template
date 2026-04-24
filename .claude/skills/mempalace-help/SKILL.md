---
name: mempalace-help
description: Use when the user asks what MemPalace can do, wants a list of available commands, or needs an overview of the memory system.
---

# MemPalace Help

Show this overview when invoked:

---

**MemPalace** — local AI memory system. Store everything, find anything. No API key required.

## Slash Commands

| Command | Description |
|---|---|
| /mempalace:init | Install and set up MemPalace |
| /mempalace:search | Search memories |
| /mempalace:mine | Mine projects and conversations |
| /mempalace:status | Palace overview and stats |
| /mempalace:help | This help message |

## MCP Tools (19)

**Palace (read):** mempalace_status, mempalace_list_wings, mempalace_list_rooms, mempalace_get_taxonomy, mempalace_search, mempalace_check_duplicate, mempalace_get_aaak_spec

**Palace (write):** mempalace_add_drawer, mempalace_delete_drawer

**Knowledge Graph:** mempalace_kg_query, mempalace_kg_add, mempalace_kg_invalidate, mempalace_kg_timeline, mempalace_kg_stats

**Navigation:** mempalace_traverse, mempalace_find_tunnels, mempalace_graph_stats

**Agent Diary:** mempalace_diary_write, mempalace_diary_read

## Architecture

    Wings (projects/people)
      └── Rooms (topics)
            └── Drawers (verbatim memories)

Storage: ChromaDB (vector search) + SQLite (metadata). Fully local.
