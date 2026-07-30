# /onboard

You are the Orchestrator. Run first-time workspace setup. Execute all steps in order. Narrate each step briefly as you go.

> **Note:** As of 2026-05-16, this command runs automatically via SessionStart hook (`.claude/hooks/session-start-onboarding.sh`) when `Vault/Memory/onboarding-flags.json` lacks the required flag-set. Manual invocation is still supported for re-runs, debugging, or to install plugins that previously failed. After successful steps, write per-step flags to `Vault/Memory/onboarding-flags.json` (see hook script for canonical key list).
>
> **Recovery — corrupted `onboarding-flags.json`:** if a flag write was interrupted (Claude crash mid-write) and the file becomes malformed, the hook treats it as "flag absent" and re-runs the full onboarding flow on next session. Tier 1 ops are idempotent. Tier 2 plugin installs are idempotent (Claude Code reports "already installed"). No manual repair needed — fix or delete the malformed JSON and re-open the chat.

---

## Step 1 — Lock repo to read-only (pull only)

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

## Step 2 — Verify Shared Projects folder

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

No symlinks or junctions needed. Claude Code accesses `../../Shared Projects` automatically once it exists at that path relative to the vault root. If it's not found, check your vault's location against the warning above.

---

## Step 3 — Configure VS Code settings

Add `"git.enabled": false` to `.vscode/settings.json` if not already present.

Read `.vscode/settings.json`, check if `git.enabled` exists. If not, add it:

```json
"git.enabled": false
```

Report: "VS Code git.enabled set to false ✓"

This disables VS Code's built-in git UI for the vault — Claude Code handles git operations directly.

---

## Step 4 — Create .env and seed local memory

Check if `.env` exists in the vault root.

- **If it does not exist:** Copy `.env.example` to `.env`. Leave all values as-is — do not fill in or prompt for any keys. Report: "`.env` created from `.env.example`. Fill in your API keys before first use. Never commit this file."
- **If it already exists:** Report: "`.env` already present — skipped."

Then check if `Vault/Memory/context.md` exists (idempotent, same shape as `install.sh`/`install.bat`'s own copy-if-absent step).

- **If it does not exist:** Copy `Vault/Memory/context.example.md` to `Vault/Memory/context.md` — `cp` only, never overwrite an existing file. Report: "`Vault/Memory/context.md` created from template — your local team memory."
- **If it already exists:** Report: "`Vault/Memory/context.md` already present — skipped." This is the common case when the installer already ran.

---

## Step 5 — Create .mcp.json (optional)

Check if `.mcp.json` exists in the vault root. This step is **optional** — unlike `.env`, no copy is required for the template to work.

- **If it does not exist and the user wants project MCP servers:** Copy `.mcp.json.example` to `.mcp.json` and add server definitions there. Report: "`.mcp.json` created from `.mcp.json.example`. Add your MCP server definitions before use."
- **Otherwise:** Skip. Report: "`.mcp.json` skipped — optional, add later if project MCP servers are needed."

Google Search Console + GA4 example (analytics-mcp, gsc):

```json
{
  "mcpServers": {
    "analytics-mcp": {
      "command": "uvx",
      "args": ["--python", "3.12", "analytics-mcp==0.6.0"],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "${USERPROFILE}/.config/claude-google/adc.json",
        "GOOGLE_PROJECT_ID": "${GOOGLE_PROJECT_ID}"
      }
    },
    "gsc": {
      "command": "npx",
      "args": ["-y", "mcp-server-gsc@0.3.0"],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "${USERPROFILE}/.config/claude-google/adc.json"
      }
    }
  }
}
```

Env values (`${USERPROFILE}`, `${GOOGLE_PROJECT_ID}`) resolve from the shell/`.env`; on macOS/Linux change `${USERPROFILE}` to `${HOME}`.

---

## Step 6 — Verify SOP path

Confirm `Resources/SOPs/Advisor Checkpoints SOP.md` exists.

- **Found:** Report: "Advisor Checkpoints SOP ✓"
- **Missing:** Warn the user: "⚠️ `Resources/SOPs/Advisor Checkpoints SOP.md` is missing. @{SeniorAdviser} checkpoints will not work until this file is restored from the template."

---

## Step 7 — Install Caveman + activate lite

First, check if Node.js is available:

```bash
node --version
```

**If Node.js not found:** on Windows, install it via `winget` (below) and retry. On macOS and Linux, do not install anything — give the user the instruction below and skip Caveman.

**Windows:**
```powershell
winget install -e --id OpenJS.NodeJS.LTS --silent
```

**macOS:** do **not** auto-install. Tell the user:

> ⚠️ Caveman needs Node.js, which is not installed. Install it yourself with either:
>   - Homebrew (if you have it): `brew install node`
>   - Or the official installer: https://nodejs.org/en/download
>
> Then re-run `/onboard`. Everything else is already set up — Caveman is an optional token-saving plugin, not a requirement.

Write `tier1_node` and `tier2_caveman` as `"skipped"` (never `true`) in `Vault/Memory/onboarding-flags.json`, then skip to Step 8. Do not install Homebrew on the user's behalf under any circumstances.

**Linux:** do **not** auto-install. Tell the user:

> ⚠️ Caveman needs Node.js, which is not installed. Install it with your distribution's package manager — for example `sudo apt-get install nodejs npm` on Debian or Ubuntu — then re-run `/onboard`. Caveman is an optional token-saving plugin, not a requirement.

Write `tier1_node` and `tier2_caveman` as `"skipped"` (never `true`) in `Vault/Memory/onboarding-flags.json`, then skip to Step 8. Do not run `sudo` on the user's behalf.

After a Windows install, refresh PATH and retry `node --version`. If that install fails too, write `tier1_node` and `tier2_caveman` as `"skipped"` (never `true`) in `Vault/Memory/onboarding-flags.json` and print:

> ⚠️ Caveman skipped — could not install Node.js automatically. Install Node.js LTS manually then re-run `/onboard`.

**Once Node.js is confirmed**, install Caveman as a plugin (its hooks run via Node at session start):

```
/plugin marketplace add JuliusBrussee/caveman
/plugin install caveman@caveman
```

The vault's `.claude/settings.json` already declares the caveman marketplace and enables `caveman@caveman` — if Claude Code already prompted the user to install it when they trusted this folder, skip the commands above and just confirm the plugin is installed. `autoUpdate` is explicitly `false` (see the accepted-risk note in `Resources/Onboarding/SETUP.md`), so run `/plugin marketplace update` manually if you want the latest.

After install completes, activate lite mode by invoking: `/caveman lite`

Report: "Caveman installed (plugin) and set to lite mode."

---

## Step 8 — Install claude-mem

claude-mem is declared in `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins` — see that file for the canonical roster) and auto-installs on first launch after the trust prompt. Run the manual steps below only if auto-install failed (check `/plugin`).

```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@claude-mem
```

Report: "claude-mem installed ✓ — restart Claude Code to activate memory hooks."

If the plugin command fails or is unavailable, print:

> ⚠️ claude-mem skipped — plugin marketplace unavailable. Install manually: `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem@claude-mem`

---

## Step 9 — Install recommended plugins

The full recommended plugin roster is declared in `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`) and auto-installs on first launch after the trust prompt. Run the manual steps below only for whichever plugin failed to auto-install (check `/plugin`).

**context-mode** (context-window management):
```
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
```

**obsidian** (Obsidian vault skills — bases, CLI, markdown, JSON Canvas, defuddle):
```
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills
```

**marketing-skills**:
```
/plugin marketplace add coreyhaines31/marketingskills
/plugin install marketing-skills@marketingskills
```

**document-skills**:
```
/plugin marketplace add anthropics/skills
/plugin install document-skills@anthropic-agent-skills
```

**skill-creator** (create and improve skills):
```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install skill-creator@claude-plugins-official
```

**frontend-design** (production UI generation):
```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install frontend-design@claude-plugins-official
```

**higgsfield** (Higgsfield AI generation skills — image/video/audio for the AI-Cinema unit):
```
/plugin marketplace add higgsfield-ai/skills
/plugin install higgsfield@higgsfield
```

> **Known issue (recorded 14/07/2026, CLI 2.1.208 — delete this block once a CLI release parses the marketplace `skills` field):** the higgsfield install can fail with *"This plugin uses a source type your Claude Code version does not support. Update Claude Code and try again."* The message is misleading — updating does not fix it. The upstream marketplace.json carries a `skills: [{name, path, invoke}]` field that current CLIs cannot parse. **Only apply the workaround below if you hit this exact error** — a fixed CLI or upstream needs no intervention. The strip step is a safe no-op when the `skills` field is absent.
>
> 1. Back up and strip the field from the local marketplace cache:
>    ```bash
>    cd ~/.claude/plugins/marketplaces/higgsfield/.claude-plugin
>    cp marketplace.json marketplace.json.bak
>    python3 -c "import json; m=json.load(open('marketplace.json')); m['plugins'][0].pop('skills', None); json.dump(m, open('marketplace.json','w'), indent=2)"
>    ```
> 2. Retry: `/plugin install higgsfield@higgsfield` — now succeeds.
> 3. Restore the original: `mv marketplace.json.bak marketplace.json`
>
> Caveat: `/higgsfield:*` skill commands may not register until the CLI supports the `skills` field — the plugin files are cached either way, and the Higgsfield MCP connector tools work regardless. Running `claude plugin marketplace update higgsfield` then reinstalling hits the same error until then; the same workaround applies.

**plannotator** (visual plan & diff review — plugin registration only; the binary is a separate step, see Step 10):
```
/plugin marketplace add backnotprop/plannotator
/plugin install plannotator@plannotator
```

Report: "All plugins declared in `.claude/settings.json` `enabledPlugins` installed ✓ — restart Claude Code to activate."

If any plugin command fails, print a warning for that plugin and continue with the rest:

> ⚠️ [plugin-name] skipped — install manually: `/plugin marketplace add [source]` then `/plugin install [plugin-name]`

---

## Step 10 — Install plannotator binary

Auto-run by the SessionStart onboarding hook — no consent prompt. Download the platform-matching asset from the **latest** release via `gh release download` (no tag — always pulls current) and verify its SHA-256 against the published `.sha256` sibling before running it — do not pipe an installer script from a URL.

Idempotent: re-running this step (manually, or via `/update`'s tool-freshness nudge) always re-downloads and overwrites the existing install — it is not gated by the `tier2_plannotator_binary` flag already being set.

**Windows:**
```powershell
gh release download --repo backnotprop/plannotator --pattern "plannotator-win32-x64.exe*"
$expected = (Get-Content plannotator-win32-x64.exe.sha256).Split(" ")[0]
$actual = (Get-FileHash plannotator-win32-x64.exe -Algorithm SHA256).Hash
if ($expected -ieq $actual) { New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\plannotator" | Out-Null; Move-Item plannotator-win32-x64.exe "$env:LOCALAPPDATA\plannotator\plannotator.exe" -Force } else { Write-Host "⚠️ checksum mismatch — aborting install" }
```

**macOS (arm64) / Linux (x64) — substitute the asset name for your platform:**
```bash
ASSET="plannotator-darwin-arm64"   # or plannotator-linux-x64, etc.
gh release download --repo backnotprop/plannotator --pattern "${ASSET}*"
echo "$(cat ${ASSET}.sha256 | cut -d' ' -f1)  ${ASSET}" | sha256sum -c - && chmod +x "$ASSET" && sudo -n mv "$ASSET" /usr/local/bin/plannotator
```

`sudo -n` never prompts — it either succeeds using a cached credential or fails immediately, rather than blocking an automated step on a password prompt.

Report: "plannotator binary installed and checksum-verified ✓" or, on mismatch/failure: "⚠️ plannotator binary skipped — checksum did not match / download failed. Retry manually or report to the maintainer." If `sudo -n` fails for lack of a cached credential, report: "⚠️ plannotator binary downloaded and verified, but installing it needs a password. Re-run Step 10 manually from a terminal where you can authenticate."

---

## Step 11 — Setup complete

Read the team roster from `Vault/Memory/theme-name-map.md` (the role → name map and file-path table) and print it. Root `CLAUDE.md` carries no roster table — its `## Theme & Roster` section only points to the name map.

Then print:

> **Workspace ready.**
> Drop GitHub repo URLs into `Resources/Git/IMPORT.md` and run `/import-repos` to set up your reference library.
> Drop documentation URLs into `Resources/Refs/IMPORT.md` and run `/import-ref` to index reference docs.
> Send any message to begin — the Orchestrator will route it.

---

## Step 12 — Open the onboarding guide

Open `Resources/Learn/index.html` in the default browser:

**Windows:**
```powershell
if (-not $env:CLAUDE_PROJECT_DIR) {
  Write-Host "⚠️ CLAUDE_PROJECT_DIR unset. Run from inside Claude Code, or open Resources/Learn/index.html manually."
} else {
  Start-Process "$env:CLAUDE_PROJECT_DIR/Resources/Learn/index.html"
}
```

**macOS / Linux:**
```bash
if [ -z "${CLAUDE_PROJECT_DIR}" ]; then
  echo "⚠️ CLAUDE_PROJECT_DIR unset. Run from inside Claude Code, or: open Resources/Learn/index.html"
else
  open "${CLAUDE_PROJECT_DIR}/Resources/Learn/index.html"
fi
```

Tell the user:

> **Your onboarding guide is now open in the browser.**
> It's a single scrolling page — Team, How it works, Who it's for, and a collapsed Reference section (commands, sample projects, FAQ). Bookmark it — you can come back any time, or ask the Orchestrator to open it again.

---

## Step 13 — Learn by doing: sample projects

Print the following block exactly:

---

**Want to try something straight away? Here are five sample projects — just copy and send any one of them.**

The `Resources/Onboarding/Demos/` folder contains 5 half-finished sample projects. Each one teaches a different workflow layer. No setup needed. Work through them in order — each builds on what the previous one introduced.

| # | Project | What it teaches |
|---|---------|-----------------|
| 1 | `Demo - Bloom Bakery - SEO Audit` | Standard audit pipeline: {Orchestrator} → {SEOSpecialist} → {QAComplianceReviewer} → Deliverables |
| 2 | `Demo - Meridian Law - Homepage UX Review` | Cross-functional handoff: {UXUIDesigner} + {Copywriter} + {QAComplianceReviewer}, multi-file report assembly |
| 3 | `Demo - NovaStar Gym - Social Media Calendar` | Multi-specialist creative: {ContentStrategist} → {SocialMediaManager} → {VisualAIProducer}, calendar format |
| 4 | `Demo - Thornwood Coffee - Brand Copywriting` | **Core orchestration mechanic**: {SeniorAdviser} Checkpoint A + B, repo consultation |
| 5 | `Demo - Velora Studio - Hire Paid Media Specialist` | **Full hiring pipeline**: {Orchestrator} gap → {SeniorResearcher} brief → {HRLead} persona → roster update |

Each project has a `README.md` with learning objectives and exact completion steps.

Projects 4 and 5 teach the two most important system mechanics — don't skip them.

To begin any project, just copy and send the prompt below.

---

**1. Demo - Bloom Bakery - SEO Audit**
> I'd like to continue the Bloom Bakery SEO audit.

*The Orchestrator routes to the SEO Specialist, who picks up from the draft. The QA Compliance Reviewer reviews before delivery.*

---

**2. Demo - Meridian Law - Homepage UX Review**
> I want to continue the Meridian Law UX review.

*The Orchestrator routes to the UX/UI Designer for sections 4–7, then the QA Compliance Reviewer evaluates the WCAG checklist. Both outputs compile into one final report.*

---

**3. Demo - NovaStar Gym - Social Media Calendar**
> Continue the NovaStar Gym social calendar — I need Weeks 2 through 4.

*The Orchestrator routes to Sage (content strategy), then the Social Media Manager (copy) and Cleo (visual prompts). Week 1 is the format template.*

---

**4. Demo - Thornwood Coffee - Brand Copywriting** ★ *teaches @{SeniorAdviser} checkpoints*
> Continue the Thornwood Coffee brand copy — I need Remi to finish the audience section, then Finn to complete the headlines.

*Remi hands off to Finn. The Senior Adviser Checkpoint A fires before drafting; Checkpoint B fires before delivery. This project is the core quality gate mechanic.*

---

**5. Demo - Velora Studio - Hire Paid Media Specialist** ★ *teaches the hiring pipeline*
> I want to run the paid media specialist hiring pipeline.

*The Orchestrator confirms the gap, routes to the Senior Researcher (research brief), then the HR Lead (persona file), then updates the roster. This is the most important meta-workflow — it teaches how the team grows.*

---

## Step 14 — Install herdr

Check first:

```bash
command -v herdr
```

**Already installed:** report "herdr already installed ✓" and skip the installer below.

**Not found:** run the official installer for the platform.

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -c "irm https://herdr.dev/install.ps1 | iex"
```

**macOS / Linux:**
```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

After install, refresh PATH and verify:

```bash
herdr --version
```

Note: Windows installs the preview channel by default — that is the only channel available on Windows.

**On success:** report "herdr installed ✓ ($(herdr --version))".

**On failure** (pattern of Step 7's Node fallback): write `tier2_herdr` as `"skipped"` (never `true`) in `Vault/Memory/onboarding-flags.json` and print:

> ⚠️ herdr skipped — could not install automatically. Install manually from https://herdr.dev/docs/install/ then re-run `/onboard`.
