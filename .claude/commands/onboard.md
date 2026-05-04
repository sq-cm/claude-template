# /onboard

You are the Orchestrator. Run first-time workspace setup. Execute all steps in order. Narrate each step briefly as you go.

---

## Step 0 — Lock repo to read-only (pull only)

Run the following commands to prevent accidental pushes back to the template repo and set up a personal local branch:

```bash
git remote set-url --push origin no_push
git config core.hooksPath .githooks
git checkout -b local/main 2>/dev/null || git checkout local/main
```

- First command disables push — `git push` will fail with a clear error.
- Second command activates the pre-push hook as a backup layer.
- Third command creates and switches to `local/main` — all personal commits go here; `main` stays clean as the upstream mirror. If the branch already exists (re-run), it just checks it out.

Report: "Repo locked to pull-only, switched to local/main ✓"

If not a git repo (no `.git/` folder), skip silently.

---

## Step 0.5 — Verify Shared Projects folder

Check if `../../Shared Projects` exists relative to the vault root:

**macOS / Linux:**
```bash
test -d "../../Shared Projects" && echo "FOUND" || echo "NOT FOUND"
```

**Windows:**
```powershell
if (Test-Path "..\..\Shared Projects") { "FOUND" } else { "NOT FOUND" }
```

**If found:** Report: "Shared Projects folder detected — accessible via Claude Code ✓"

**If not found:** Print:

> ⚠️ Shared Projects folder not found at `../../Shared Projects`. Make sure your vault is inside the Team shared drive (`Team/[Name]/Claude-[Name]/`). Claude Code will not have access to shared work until this is resolved.

No symlinks or junctions needed. `../../Shared Projects` is pre-configured as an `additionalDirectory` in `.claude/settings.json` — Claude Code picks it up automatically when the folder exists.

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

First, check if Node.js is available:

```bash
node --version
```

**If Node.js not found:** auto-install using the platform package manager, then retry.

**Windows:**
```powershell
winget install -e --id OpenJS.NodeJS.LTS --silent
```

**macOS:**
```bash
command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node
```

**Linux:**
```bash
sudo apt-get install -y nodejs npm
```

After install, refresh PATH and retry `node --version`. If install fails, print:

> ⚠️ Caveman skipped — could not install Node.js automatically. Install Node.js LTS manually then re-run `/onboard`.

**Once Node.js is confirmed**, detect platform and run Caveman install:
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

## Step 3.5 — Install claude-mem

Install claude-mem via the plugin marketplace:

```
/plugin marketplace add thedotmack/claude-mem
```

Then install the plugin:

```
/plugin install claude-mem
```

Report: "claude-mem installed ✓ — restart Claude Code to activate memory hooks."

If the plugin command fails or is unavailable, print:

> ⚠️ claude-mem skipped — plugin marketplace unavailable. Install manually: `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem`

---

## Step 3.55 — Install recommended plugins

Install four plugins via the plugin marketplace. Run each pair sequentially.

**context-mode** (context-window management):
```
/plugin marketplace add mksglu/context-mode
/plugin install context-mode
```

**superpowers** (skill collection):
```
/plugin marketplace add obra/superpowers
/plugin install superpowers
```

**skill-creator** (create and improve skills):
```
/plugin marketplace add anthropics/claude-plugins-official/plugins/skill-creator
/plugin install skill-creator
```

**frontend-design** (production UI generation):
```
/plugin marketplace add anthropics/claude-plugins-official/plugins/frontend-design
/plugin install frontend-design
```

Report: "context-mode, superpowers, skill-creator, frontend-design installed ✓ — restart Claude Code to activate."

If any plugin command fails, print a warning for that plugin and continue with the rest:

> ⚠️ [plugin-name] skipped — install manually: `/plugin marketplace add [source]` then `/plugin install [plugin-name]`

---

## Step 4 — Setup complete

Read the Active Team Roster table from `CLAUDE.md` and print it.

Then print:

> **Workspace ready.**
> Drop GitHub repo URLs into `Resources/Git/IMPORT.md` and run `/import-repos` to set up your reference library.
> Send any message to begin — the Orchestrator will route it.

---

## Step 5 — Open the onboarding guide

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

## Step 6 — Learn by doing: sample projects

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
