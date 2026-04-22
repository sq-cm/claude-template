# /onboard

You are the Orchestrator. Run first-time workspace setup. Execute all steps in order. Narrate each step briefly as you go.

---

## Step 0 — Lock repo to read-only (pull only)

Run the following two commands to prevent accidental pushes back to the template repo:

```bash
git remote set-url --push origin no_push
git config core.hooksPath .githooks
```

- First command disables push — `git push` will fail with a clear error.
- Second command activates the pre-push hook as a backup layer.

Report: "Repo locked to pull-only ✓"

If not a git repo (no `.git/` folder), skip silently.

---

## Step 1 — Create .env

Check if `.env` exists in the vault root.

- **If it does not exist:** Copy `.env.example` to `.env`. Leave all values as-is — do not fill in or prompt for any keys. Report: "`.env` created from `.env.example`. Fill in your API keys before first use. Never commit this file."
- **If it already exists:** Report: "`.env` already present — skipped."

---

## Step 2 — Verify SOP path

Confirm `Resources/SOPs/Advisor Checkpoints SOP.md` exists.

- **Found:** Report: "Advisor Checkpoints SOP ✓"
- **Missing:** Warn the user: "⚠️ `Resources/SOPs/Advisor Checkpoints SOP.md` is missing. @{SeniorAdviser} checkpoints will not work until this file is restored from the template."

---

## Step 3 — Install Caveman + activate lite

Detect platform:
- If `$env:OS` contains `Windows` or `$OSTYPE` is unset on Windows → run PowerShell install
- Otherwise → run bash install

**Windows:**
```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/hooks/install.ps1 | iex
```

**macOS / Linux:**
```bash
bash <(curl -s https://raw.githubusercontent.com/JuliusBrussee/caveman/main/hooks/install.sh)
```

After install completes, activate lite mode by invoking: `/caveman lite`

Report: "Caveman installed and set to lite mode."

---

## Step 4 — Theme

Ask the user:

> Want to apply a name theme to your team? Themes replace the default names (Sam, Harper, Ryan…) with characters from a chosen universe. You can do this now or any time later with "Set theme to [theme]".
>
> Here are 12 options — or pick your own:
>
> 1. **Vikings** — Odin, Freya, Thor, Loki, Sigrid, Bjorn, Astrid, Ragnar, Ingrid, Gunnar
> 2. **Greek Myths** — Apollo, Iris, Hermes, Athena, Calypso, Daedalus, Selene, Eros, Theia, Nereus
> 3. **Studio Ghibli** — Totoro, Kiki, Nausicaä, Ashitaka, San, Chihiro, Howl, Sophie, Mononoke, Calcifer
> 4. **Pokémon** — Eevee, Raichu, Gengar, Mewtwo, Jolteon, Umbreon, Espeon, Alakazam, Machamp, Vaporeon
> 5. **Jazz Musicians** — Miles, Coltrane, Monk, Billie, Ella, Dizzy, Bird, Mingus, Chet, Cannonball
> 6. **Planets & Moons** — Sol, Luna, Vega, Orion, Cassini, Titan, Lyra, Sirius, Halley, Io
> 7. **Colours** — Indigo, Sable, Ochre, Vermeil, Slate, Cobalt, Sienna, Teal, Onyx, Flax
> 8. **Mushrooms** — Morel, Chanterelle, Truffle, Shiitake, Matsutake, Porcini, Cremini, Amanita, Russula, Lactarius
> 9. **Gemstones** — Onyx, Jasper, Topaz, Garnet, Obsidian, Beryl, Citrine, Opal, Spinel, Zircon
> 10. **Star Wars** — Yoda, Leia, Han, Luke, Lando, Padmé, Obi-Wan, Anakin, Ahsoka, Grogu
> 11. **Lord of the Rings** — Gandalf, Frodo, Aragorn, Legolas, Gimli, Elrond, Galadriel, Boromir, Sam, Pippin
> 12. **Game of Thrones** — Jon, Daenerys, Tyrion, Cersei, Arya, Sansa, Brienne, Jaime, Theon, Davos
>
> Type a number, type your own theme name, or type "skip" to keep default names.

- If user picks a theme: hand off to the Orchestrator with the message: `"Set theme to [chosen theme]"`
- If user types their own theme: hand off to the Orchestrator with: `"Set theme to [their theme]"`
- If user skips: continue to Step 5.

---

## Step 5 — Setup complete

Read the Active Team Roster table from `CLAUDE.md` and print it.

Then print:

> **Workspace ready.**
> Drop GitHub repo URLs into `Resources/Git/IMPORT.md` and run `/import-repos` to set up your reference library.
> Send any message to begin — the Orchestrator will route it.

---

## Step 6 — Open the onboarding guide

Open `Resources/Learn/index.html` in the default browser:

**Windows:**
```powershell
Start-Process "Resources/Learn/index.html"
```

**macOS / Linux:**
```bash
open "${CLAUDE_PROJECT_DIR}/Resources/Learn/index.html"
```

Tell the user:

> **Your onboarding guide is now open in the browser.**
> It has two tabs — "I'm using the team" (roster, skills, how to talk to the team) and "I'm setting this up" (admin steps, vault structure). Bookmark it — you can come back any time, or ask the Orchestrator to open it again.

---

## Step 7 — Learn by doing: sample projects

Print the following block exactly:

---

**Want to try something straight away? Here are five sample projects — just copy and send any one of them.**

The `Projects/` folder contains 5 half-finished sample projects. Each one teaches a different workflow layer. No setup needed. Work through them in order — each builds on what the previous one introduced.

| # | Project | What it teaches |
|---|---------|-----------------|
| 1 | `Demo — Bloom Bakery — SEO Audit` | Standard audit pipeline: {Orchestrator} → {SEOSpecialist} → {QAComplianceReviewer} → Deliverables |
| 2 | `Demo — Meridian Law — Homepage UX Review` | Cross-functional handoff: {UXUIDesigner} + {Copywriter} + {QAComplianceReviewer}, multi-file report assembly |
| 3 | `Demo — NovaStar Gym — Social Media Calendar` | Multi-specialist creative: {ContentStrategist} → {SocialMediaManager} → {VisualAIProducer}, calendar format |
| 4 | `Demo — Thornwood Coffee — Brand Copywriting` | **Core orchestration mechanic**: {SeniorAdviser} Checkpoint A + B, repo consultation |
| 5 | `Demo — Velora Studio — Hire Paid Media Specialist` | **Full hiring pipeline**: {Orchestrator} gap → {SeniorResearcher} brief → {HRLead} persona → roster update |

Each project has a `README.md` with learning objectives and exact completion steps.

Projects 4 and 5 teach the two most important system mechanics — don't skip them.

To begin any project, just copy and send the prompt below.

---

**1. Demo — Bloom Bakery — SEO Audit**
> I'd like to continue the Bloom Bakery SEO audit.

*The Orchestrator routes to the SEO Specialist, who picks up from the draft. The QA Compliance Reviewer reviews before delivery.*

---

**2. Demo — Meridian Law — Homepage UX Review**
> I want to continue the Meridian Law UX review.

*The Orchestrator routes to the UX/UI Designer for sections 4–7, then the QA Compliance Reviewer evaluates the WCAG checklist. Both outputs compile into one final report.*

---

**3. Demo — NovaStar Gym — Social Media Calendar**
> Continue the NovaStar Gym social calendar — I need Weeks 2 through 4.

*The Orchestrator routes to Sage (content strategy), then the Social Media Manager (copy) and Cleo (visual prompts). Week 1 is the format template.*

---

**4. Demo — Thornwood Coffee — Brand Copywriting** ★ *teaches @{SeniorAdviser} checkpoints*
> Continue the Thornwood Coffee brand copy — I need Remi to finish the audience section, then Finn to complete the headlines.

*Remi hands off to Finn. The Senior Adviser Checkpoint A fires before drafting; Checkpoint B fires before delivery. This project is the core quality gate mechanic.*

---

**5. Demo — Velora Studio — Hire Paid Media Specialist** ★ *teaches the hiring pipeline*
> I want to run the paid media specialist hiring pipeline.

*The Orchestrator confirms the gap, routes to the Senior Researcher (research brief), then the HR Lead (persona file), then updates the roster. This is the most important meta-workflow — it teaches how the team grows.*
