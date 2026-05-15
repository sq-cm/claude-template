# Reference: Email Build Standards Extraction

**Date:** 2026-05-15

**What:** Extracted `email-build-standards.md` from Rory's (Email Developer) persona after Checkpoint A with Odin.

**Why:** Rory's persona contained 219 lines of technical build standards that apply to all email builds. Centralizing them in a dedicated file improves maintainability, makes updates easier, and creates a single source of truth for code patterns and deliverables requirements.

**Where:** 
- New file: `Resources/Build Standards/email-build-standards.md`
- New index: `Resources/Build Standards/README.md`
- Updated persona: `.claude/agents/email-developer.md` — lines 58–85 now point to build standards and Basis section cites the new file

**Content verified:** Original lines 58–276 from persona copied verbatim into new file; zero content loss confirmed via diff.

**Related:**
- Odin's 9 corrections applied in full
- Checkpoint A with Odin cleared this extraction
- See `email-developer.md` "Build Standards" section for pointer and deviations clause
