# First-Run Setup

Everything needed to deploy a new instance of this vault from scratch.

> **Auto-onboarding is on.** The first time you open this folder in Claude Code, a SessionStart hook detects missing setup and runs onboarding automatically — silent where possible, narrated only for slash-command installs (plugins, Caveman). If you've already onboarded (signals: git hooks active, `.env` present, plugins installed), the hook back-fills flags silently and you'll see nothing.
>
> If you prefer the manual flow, follow the steps below — they still work, and explain what the hook does under the hood. Maintainers should `export CLAUDE_TEMPLATE_MAINTAINER=1` to suppress the hook entirely.

---

## Step 0 — Run the install script

After cloning, run once from the vault root:

**Mac / Linux:**
```bash
bash install.sh
```

**Windows:**
```bat
install.bat
```

This does three things automatically: blocks push to the upstream template repo (your instance is yours — you can't accidentally push back), activates git hooks (commit + push gates), and creates your `.env` file. The script verifies `core.hooksPath` resolved before proceeding — if it prints `[FAIL]`, fix that before continuing.

### What you can and can't change locally

The template flows one direction: maintainer → upstream → your clone. Your clone is read-only for template files.

- **Editable** — `Inbox/`, `Notes/`, `Projects/` (all gitignored — your work lives here)
- **Not editable for commit** — everything else (CLAUDE.md, `.claude/agents/`, SOPs, settings, etc.)

`.githooks/pre-commit` blocks any commit touching paths outside the editable zone. `.githooks/pre-push` blocks all pushes. If you genuinely need a template change, propose it to the maintainer.

---

## Step 1 — Copy environment file

```bash
cp .env.example .env
```

Open `.env` and populate credentials for any services you'll use:
- `ANTHROPIC_API_KEY` — required for all AI team operations
- Google / Gmail credentials — required if using calendar or email MCP tools
- MCP server tokens (GitHub, Slack, Notion) — add as needed

Never commit `.env` to git.

---

## Step 2 — Confirm git hooks are active

The install script already wired this. To verify:

```bash
git config --get core.hooksPath
```

Expected output: `.githooks`. If you see nothing, re-run the install script.

---

## Step 3 — Choose a team naming theme (or keep default)

The vault ships with placeholder role names. You have two options:

**Option A — Keep default (no action needed)**
Default names are already set in `Vault/Memory/theme-name-map.md`. Skip to Step 4.

**Option B — Apply a naming theme**
Ask Sam: `apply a [theme] naming theme to the team` — e.g. Norse mythology, Greek gods, Pokémon.
Sam will route to Ryan (research) → Sam (execution).
See `Resources/SOPs/Theme SOP.md` for the full workflow.

---

## Step 4 — Bootstrap memory

`install.sh` / `install.bat` already created `Vault/Memory/context.md` from the tracked seed (`context.example.md`). Open `Vault/Memory/context.md` and fill in the `## Session Bootstrap` block:

```markdown
## Session Bootstrap — [YYYY-MM-DD]

- Vault deployed from template
- Theme: [default / name of theme applied]
- Active team size: 28
- Notes: [anything worth remembering from setup]
```

This anchors your local memory for future sessions.

> **`context.md` vs `MEMORY.md`.** `context.md` is your clone's **local** team memory — git-ignored, the write target for the bootstrap entry above and for `/memory-reconcile`. `MEMORY.md` is the shipped, git-tracked **vault-operations index**, maintainer-curated and the same for every install. Never hand-edit `MEMORY.md` for local facts — doing so causes rebase conflicts on `/update`. Both files load into context every prompt.

> **Migrating an existing clone (one-time).** If your clone predates the memory split, local entries you added to `MEMORY.md` are now in the maintainer-owned tracked file and will conflict on your next `/update`. Move them into `Vault/Memory/context.md`, then run `git checkout MEMORY.md` to restore the shipped index. New clones skip this — `install` already created `context.md`.

---

## Step 5 — Populate the repo index (optional but recommended)

If you plan to use repo-backed best practices (Repo Consultation SOP), add repos to `Resources/Git/INDEX.md`.

See `Resources/SOPs/Repo Setup SOP.md` for how to clone repos and add index entries.

---

## Step 6 — Verify the vault

Ask Sam: `check the roster` — Sam will confirm all 28 team members are present and correctly linked.

---

## You're ready

Start any session by addressing Sam directly or just typing your request. Sam routes everything.

```
@Sam I need to [task]
```

Or just describe what you need — Sam will intercept and route.

---

## Key files for ongoing reference

| File | Purpose |
|------|---------|
| `CLAUDE.md` | System bible — how Sam and the team work |
| `Vault/Memory/MEMORY.md` | Persistent cross-session memory |
| `Vault/Memory/theme-name-map.md` | Current name → role mapping |
| `Resources/SOPs/` | All standard operating procedures |

---

## Appendix — Caveman Mode (optional)

Caveman mode reduces Claude's output tokens by ~65% by stripping filler, articles, and pleasantries while keeping full technical accuracy. The recommended default is **lite** — terse but readable. Auto-onboarding installs this automatically; the manual install is documented here for completeness.

### Install

**Claude Code (plugin):**
```
claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
```

**Claude Code (standalone hooks):**

macOS/Linux:
```bash
bash <(curl -s https://raw.githubusercontent.com/JuliusBrussee/caveman/main/hooks/install.sh)
```

Windows:
```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/hooks/install.ps1 | iex
```

### Levels

| Command | Style |
|---------|-------|
| `/caveman lite` | Drop filler, keep grammar. Professional but no fluff. |
| `/caveman` | Drop articles, fragments OK. Default grunt mode. |
| `/caveman ultra` | Maximum compression. Telegraphic. |

Set lite as default per session with `/caveman lite`. Repo & docs: [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

---

## Appendix — Recommended plugins

Auto-onboarding installs a set of recommended Claude Code plugins (onboard.md Step 3.5 + 3.55). If you onboarded manually or a plugin failed, install them yourself:

| Plugin | Install |
|--------|---------|
| claude-mem | `/plugin marketplace add thedotmack/claude-mem` → `/plugin install claude-mem` |
| context-mode | `/plugin marketplace add mksglu/context-mode` → `/plugin install context-mode` |
| superpowers | `/plugin marketplace add obra/superpowers` → `/plugin install superpowers` |
| skill-creator | `/plugin marketplace add anthropics/claude-plugins-official/plugins/skill-creator` → `/plugin install skill-creator` |
| frontend-design | `/plugin marketplace add anthropics/claude-plugins-official/plugins/frontend-design` → `/plugin install frontend-design` |
| plannotator | binary first (below), then `/plugin marketplace add backnotprop/plannotator` → `/plugin install plannotator@plannotator` |

**plannotator** ([github.com/backnotprop/plannotator](https://github.com/backnotprop/plannotator)) adds visual review of agent plans and code diffs — approve/deny plans with inline annotations, review git diffs and PRs, send feedback back to the agent. It needs its binary installed before the plugin:

**Windows:**
```powershell
irm https://plannotator.ai/install.ps1 | iex
```

**macOS / Linux / WSL:**
```bash
curl -fsSL https://plannotator.ai/install.sh | bash
```

Restart Claude Code after any plugin install.

---

## Appendix — Remote Control (optional)

Remote control lets you drive a running Claude Code session from claude.ai on the web or the mobile app — start a task, steer it mid-flight, or approve a prompt from your phone while the session is live on your machine.

It is on by default. The vault ships with `remoteControlAtStartup: true` in `.claude/settings.json`, and clones inherit that setting via the install script. Nothing extra to configure.

### Settings at a glance

| Setting | File | Value | Effect |
|---------|------|-------|--------|
| `remoteControlAtStartup` | `.claude/settings.json` | `true` | Starts remote-control listener when Claude Code launches |
| `claudeCode.useTerminal` | `.vscode/settings.json` | `true` | Launches Claude in the VS Code integrated terminal, which is required for the startup flag to fire |

The VS Code entry matters: Claude Code's native panel mode bypasses the terminal startup sequence, so `remoteControlAtStartup` would silently do nothing without it. With `useTerminal: true`, the flag fires as expected.

### One manual prerequisite

The setting wires up the listener, but it can only route to your session if you are signed into the same claude.ai account in the browser or app. That's the only step that can't be automated — sign in once and it stays put.

### Managing it

To check status or turn remote control off for the current session, run `/remote-control`.
