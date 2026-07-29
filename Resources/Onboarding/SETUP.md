# First-Run Setup

Everything needed to deploy a new instance of this vault from scratch.

> **Auto-onboarding is on.** The first time you open this folder in Claude Code, a SessionStart hook detects missing setup and runs onboarding automatically — silent where possible, narrated only for slash-command installs (plugins, Caveman). If you've already onboarded (signals: git hooks active, `.env` present, plugins installed), the hook back-fills flags silently and you'll see nothing.
>
> If you prefer the manual flow, follow the steps below — they still work, and explain what the hook does under the hood. Maintainers should `export CLAUDE_TEMPLATE_MAINTAINER=1` to suppress the hook entirely.

---

## See it work first

Before configuring anything, take five minutes with one of the worked demos under `Demos/` — `Demo - Bloom Bakery - SEO Audit` is the fullest example of the pipeline — and skim its brief, working files and deliverable to see the routing and QA flow end-to-end. [Demos/README.md](Demos/README.md) indexes all five demos and explains how to run one yourself. Then come back and carry on from Step 0 — the install below is still required before any real work.

---

## Prerequisites

Before you start, make sure these are on your machine:

- **A POSIX shell and `bash`.** On Windows this means Git Bash, which ships with Git for Windows. The vault's hooks are bash scripts, and `.claude/settings.json` invokes them through a shell expression that needs a POSIX shell to evaluate before it needs `bash` itself.
- **`jq`.** Required by five of the vault's scripts, including the hook that runs first-time setup. Without it, auto-onboarding is skipped and `Vault/Memory/onboarding-errors.md` records why.
- **`git`.** For cloning the repo, the pull-only update flow, and the commit hooks.
- **`curl`.** For the tool-freshness check and the herdr installer.

These are the dependencies the vault's scripts actually use; the install path has not yet been exercised on a machine that genuinely lacks any of them, so treat that case as untested rather than assumed to fail.

Paste this to check all four at once:

```bash
for c in bash jq git curl; do command -v "$c" >/dev/null 2>&1 && echo "ok   $c" || echo "MISS $c"; done
```

Each line should read `ok`, not `MISS`. If any read `MISS`, install that tool before continuing.

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

This automatically blocks push to the upstream template repo (your instance is yours — you can't accidentally push back), activates git hooks (commit + push gates), creates your `.env` file, and seeds your local `Vault/Memory/context.md`. The script verifies `core.hooksPath` resolved before proceeding — if it prints `[FAIL]`, fix that before continuing.

### What you can and can't change locally

The template flows one direction: maintainer → upstream → your clone. Your clone is read-only for template files.

- **Editable** — `Notes/`, `Projects/` (all gitignored — your work lives here)
- **Not editable for commit** — everything else (CLAUDE.md, `.claude/agents/`, SOPs, settings, etc.)

`.githooks/pre-commit` blocks any commit touching paths outside the editable zone. `.githooks/pre-push` blocks all pushes. If you genuinely need a template change, propose it to the maintainer.

---

## Step 1 — Copy environment file

```bash
cp .env.example .env
```

Open `.env` and populate credentials for any services you'll use:
- `ANTHROPIC_API_KEY` — **not** required for the vault's own AI team operations, which run through Claude Code's own authentication (a Max, Team or Pro plan, or the key you signed in with — see `README.md` § Requirements). Nothing in this repo reads this variable directly; populate it only if you add something outside Claude Code that calls the Anthropic API on its own.
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

`Vault/Memory/context.md` was created from the tracked seed (`context.example.md`) by whichever of these ran on your clone: `install.sh` / `install.bat`, or `/onboard` (which also seeds it, since the documented quick-start path in `README.md` goes straight to `/onboard` without an installer step). Open `Vault/Memory/context.md` and fill in the `## Session Bootstrap` block:

```markdown
## Session Bootstrap — [YYYY-MM-DD]

- Vault deployed from template
- Theme: [default / name of theme applied]
- Active team size: 28
- Notes: [anything worth remembering from setup]
```

This anchors your local memory for future sessions.

> **`context.md` vs `MEMORY.md`.** `context.md` is your clone's **local** team memory — git-ignored, the write target for the bootstrap entry above and for `/memory-reconcile`. `MEMORY.md` is the shipped, git-tracked **vault-operations index**, maintainer-curated and the same for every install. Never hand-edit `MEMORY.md` for local facts — doing so causes rebase conflicts on `/update`. Both files load into context every prompt.

> **Migrating an existing clone (one-time).** If your clone predates the memory split, local entries you added to `MEMORY.md` are now in the maintainer-owned tracked file and will conflict on your next `/update`. Move them into `Vault/Memory/context.md`, then run `git checkout MEMORY.md` to restore the shipped index. New clones skip this — `context.md` already exists by the time this matters, created by the installer or by `/onboard`.

---

## Step 5 — Populate the repo index (optional but recommended)

If you plan to use repo-backed best practices (Repo Consultation SOP), add repos to `Resources/Git/INDEX.md`.

See `Resources/SOPs/Repo Setup SOP.md` for how to clone repos and add index entries.

If you plan to use doc-URL references instead (or as well), drop documentation URLs into `Resources/Refs/IMPORT.md` and run `/import-ref` — see `Resources/Refs/IMPORT.md`'s header for the expected format.

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

The vault's `.claude/settings.json` declares the caveman marketplace and enables the plugin — Claude Code prompts to install it when you trust the folder. `autoUpdate` is `false`, matching every other declared marketplace (see the accepted-risk note below) — update it manually with `/plugin marketplace update` when you want the latest. Manual install, if the prompt was dismissed:

```
claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
```

> The old standalone-hooks installer (`hooks/install.sh` / `hooks/install.ps1`) no longer exists upstream — the plugin is the only supported install path.

### Levels

| Command | Style |
|---------|-------|
| `/caveman lite` | Drop filler, keep grammar. Professional but no fluff. |
| `/caveman` | Drop articles, fragments OK. Default grunt mode. |
| `/caveman ultra` | Maximum compression. Telegraphic. |

Set lite as default per session with `/caveman lite`. Repo & docs: [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

---

## Appendix — Recommended plugins

Auto-onboarding installs the recommended Claude Code plugins (onboard.md Steps 8 + 9). The canonical, current roster — plugin IDs, marketplace sources, and enabled state — lives in `.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`); do not restate it here. If you onboarded manually or a plugin failed, `.claude/commands/onboard.md` Steps 8 and 9 give the exact `/plugin marketplace add` + `/plugin install` command pair for each declared plugin.

**plannotator** ([github.com/backnotprop/plannotator](https://github.com/backnotprop/plannotator)) adds visual review of agent plans and code diffs — approve/deny plans with inline annotations, review git diffs and PRs, send feedback back to the agent. Its Claude Code plugin registers automatically like the rest of the roster; the plannotator *binary* is a separate, auto-run install (`.claude/commands/onboard.md` Step 10, no consent gate) — a checksum-verified download of the **latest** release (unpinned; see accepted-risk note below), not a pipe-to-shell installer. `Vault/Scripts/tool-check.sh` nudges when a newer release is available; re-running Step 10 updates an existing install.

**herdr** ([herdr.dev](https://herdr.dev)) — auto-installed at `.claude/commands/onboard.md` Step 14 via the vendor's official pipe-to-shell installer (Windows: `irm https://herdr.dev/install.ps1 | iex`; macOS/Linux: `curl -fsSL https://herdr.dev/install.sh | sh`). Windows installs the preview channel by default — the only channel available on that platform. `Vault/Scripts/tool-check.sh` checks it against GitHub releases the same way it checks plannotator; herdr updates itself via `herdr update` (never run automatically — see the tool's own docs for why). Day-to-day usage, the concept model, and troubleshooting live in the [Herdr SOP](../SOPs/Herdr%20SOP.md).

Restart Claude Code after any plugin install.

### Accepted risk — unpinned third-party code paths

Every marketplace in `.claude/settings.json` `extraKnownMarketplaces` sourced from GitHub (`plannotator`, `context-mode`, `obsidian-skills`, `caveman`, `higgsfield`, `marketingskills`, `anthropic-agent-skills`, `claude-mem`) tracks its repo's default branch at HEAD, not a pinned commit or tag — of the eight, seven publish no tags at all; commit-SHA refs were tested and rejected by the clone mechanism (`git clone --branch <sha>` fails), so branch-at-HEAD is the only option for those seven. Plannotator *does* publish tags, but the `extraKnownMarketplaces` github-type source form has no ref field to pin one — a git-URL `#tag` form is untested against project-level settings, so marketplace-level pinning for plannotator is deferred too. Its separate binary install (Step 10) was previously pinned to `v0.9.3`; that pin is now deliberately dropped — Step 10 always downloads the **latest** release, checksum-verified against the release's own `.sha256` sibling. Unpinning trades reduced review lag against a moving target: the checksum only proves the download matches what the publisher shipped for that tag, not that the publisher's intent is safe — accepted because a stale pinned binary that never gets updated is a worse security posture over the vault's lifetime, and `Vault/Scripts/tool-check.sh` now nudges immediately when a newer release ships. `autoUpdate` is explicitly `false` on the caveman entry (previously `true`); the other seven entries omit the key, which defaults to `false`. Either way, a fresh trust-prompt install always uses whatever is at HEAD at trust time, and updates only happen when a maintainer explicitly runs `/plugin marketplace update`.

herdr (Step 14) carries the same class of risk from a different source: it installs via the vendor's own pipe-to-shell installer (`irm ... | iex` on Windows, `curl ... | sh` on macOS/Linux), which is unpinned and unverified by design — there is no checksum step, because the installer itself is the trust boundary. Accepted because herdr has no alternative install path documented for casual use, and the check-only nudge (never an automatic re-run of the installer) keeps the exposure to onboarding time only.

**Privileged installs during `/onboard` — removed rather than accepted.** Earlier versions of `.claude/commands/onboard.md` Step 7 auto-installed Node.js on the user's behalf: on macOS by piping `https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh` into `/bin/bash` at a moving HEAD, and on Linux with `sudo apt-get install -y nodejs npm`. Neither was reviewable before it ran and neither was recorded here. Both are now gone: Step 7 tells the user how to install Node.js and skips Caveman if they have not, because Caveman is an optional token-saving plugin and installing a system-wide package manager to enable it is out of proportion. Windows still uses `winget`, which needs no privilege escalation and pipes nothing into a shell. The only remaining privilege escalation in the onboarding path is Step 10's `sudo -n mv` of the checksum-verified plannotator binary, which never prompts and skips instead of hanging.

The trade-off accepted in its place: each repo's HEAD commit was reviewed (see per-row date below) and recorded below. Anyone auditing what code actually ran can diff against these SHAs; anyone updating a marketplace should re-review and update this list.

| Repo | Reviewed HEAD SHA | Reviewed |
|------|--------------------|----------|
| backnotprop/plannotator | `82f5648ccb1fc718407fbc794e8a40c95c94a536` | 2026-07-06 |
| mksglu/context-mode | `f267bdae970f0b01652a2ab413793318ed02065a` | 2026-07-06 |
| kepano/obsidian-skills | `a1dc48e68138490d522c04cbf5822214c6eb1202` | 2026-07-06 |
| JuliusBrussee/caveman | `0d95a81d35a9f2d123a5e9430d1cfc43d55f1bb0` | 2026-07-06 |
| coreyhaines31/marketingskills | `30dbd7f793b86f0ec2f007757b333afac93c24db` | 2026-07-06 |
| anthropics/skills | `9d2f1ae187231d8199c64b5b762e1bdf2244733d` | 2026-07-06 |
| thedotmack/claude-mem | `804504b351cabbe45c63fa8692ff09c57e0d03e6` | 2026-07-06 |
| higgsfield-ai/skills | `27defbaa75efa34d064f208e72b3dbfc71db0a92` | recorded 2026-07-25; maintainer review pending |

The last row above was added when the drift between this table and `.claude/settings.json` was reconciled (2026-07-25) — the SHA is what HEAD was at recording time, not a reviewed-safe attestation; a maintainer still needs to review it and replace "review pending" with a review date.

Disabling any plugin listed here requires removing its matching `tier2_plugin_<name>` entry from `REQUIRED_KEYS` in `.claude/hooks/session-start-onboarding.sh` in the same change — a `REQUIRED_KEYS` entry that can never become true makes onboarding re-fire every session, forever. `tier2_plugin_higgsfield` is the entry that pairs with the `higgsfield-ai/skills` row above; it stays live only because that row's boolean is still `true`, so do not disable it without also removing the key.

This is the single place this SHA list is recorded — other docs link here rather than restating it.

### What enabling a plugin grants

Ten plugins are enabled by default in `.claude/settings.json` `enabledPlugins`. Seven are third-party (`plannotator`, `context-mode`, `obsidian`, `caveman`, `marketing-skills`, `claude-mem`, `higgsfield`); three are Anthropic's own — `document-skills@anthropic-agent-skills` (from `anthropics/skills`), plus `skill-creator` and `frontend-design` (from `claude-plugins-official`). They install at the trust prompt, before the user has reviewed anything.

A Claude Code plugin, once enabled, can register hooks via its own `hooks/hooks.json`, place executables where the Bash tool can reach them, and run background processes. This is a statement of capability, not an accusation against any specific plugin in the roster above. In practice, enabling a plugin is a trust decision of the same weight as running its install script — the marketplace SHA table above is the record of what was reviewed for each one.

**To opt out**, set the plugin to `false` in `.claude/settings.json` `enabledPlugins`. That flip alone is not sufficient: the disabling paragraph above this section names one of four places `.claude/hooks/session-start-onboarding.sh` encodes the plugin roster — `REQUIRED_KEYS` — but the same name also has to come out of the migration-detection loop, the migration branch's key list, and the flag→step map at the bottom of the file, or a stale entry left behind in any of the other three makes onboarding re-fire every session, forever. `superpowers` was exactly this case from 17/07/2026 until plan 060 fixed it. `higgsfield` is currently enabled, so its `REQUIRED_KEYS` entry is satisfiable and it is a latent case, not a live one.

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
