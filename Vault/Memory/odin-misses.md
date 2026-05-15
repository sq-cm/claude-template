# Odin Misses Log

<!-- Append a row whenever Odin's checkpoint failed to catch an issue that surfaced later. Used to improve checkpoint prompts and SOP coverage over time. -->

| Date | Session | Gap Description | Suggested Improvement |
|------|---------|----------------|-----------------------|
| 2026-05-15 | Vault audit Checkpoint A (Drew structural findings) | Drew flagged `Resources/sam-routing.gif` as orphaned binary with no documented owner (became M2 in merged report). README.md line 179 actually embeds the gif. Odin merged this severity without verifying inbound references. | When closing "orphaned file" findings, require auditor to grep the file basename across the vault before severity is finalised. Add this check to Checkpoint A SOP for any "X is orphaned / no owner" finding. |
