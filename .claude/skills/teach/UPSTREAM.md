# teach — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 19/11/2026 (plan 180) so it stops loading on every invocation; only comment delimiters were removed. In the moved text, "this header" means the comment block that sat at the top of `SKILL.md`; "below" and "this file" refer to `SKILL.md`. Read it before any resync.

## Moved 19/11/2026 (plan 180)

Source: https://github.com/mattpocock/skills/tree/main/skills/productivity/teach (by Matt Pocock).
Synced with upstream @ 49dd158 on 14/10/2026 (plan 150); earlier @ 272f99b on 05/07/2026 (#116).
The four *-FORMAT.md helpers in this folder are upstream-verbatim. SKILL.md carries six vault
adaptations, all to be carried over any future upstream replace:
  1. Workspace pin: the teaching workspace is `Vault/Learning/<topic-slug>/` (git-ignored,
     personal), and every workspace-relative path resolves under it, never the current directory
     (#46, 09/06/2026). It replaces upstream's whole opening paragraph of the Teaching Workspace
     section. For the same reason plan 150 rejected upstream's workspace-path anchoring sentence
     (ad5400b), which ties paths to the directory /teach was run in.
  2. Topic-slug rule: derive a short topic slug from the free-text /teach argument, and confirm
     it with the user when it is ambiguous (#46, 09/06/2026).
  3. Orchestrator override block: /teach runs inline, is never routed, and is exempt from the QA
     Gate, PM tracking and Advisor Checkpoints (AGENTS.md § Identity, the /teach exception).
  4. Output Locale note: teach output is vault-internal, so its prose is Australian English
     (#142, 06/07/2026; reworded since to point at AGENTS.md § Output Locale).
  5. `GLOSSARY.md` bullet in the workspace file list, in the vault's own wording (#137,
     06/07/2026). Upstream had a differently worded GLOSSARY.md bullet until 88eb3f8
     (06/06/2026) removed it; 272f99b and 49dd158 have none, though both ship GLOSSARY-FORMAT.md.
  6. Opening a lesson: per-platform commands (macOS/Linux `open`, Windows `Start-Process`)
     replace upstream's one-line instruction to open the lesson with a CLI command (#46,
     09/06/2026).
Plan 150 took upstream's quiz answer-position rule (ad5400b) and its em-dash sweep (3216582) on
upstream-origin lines only; vault-authored lines keep their dashes. Upstream's `agents/openai.yaml`
(Codex metadata, 697d4ce) is deliberately not vendored.
