# Herdr SOP

Condensed from https://herdr.dev/agent-guide.md as reviewed **17/07/2026** — for anything not covered here, consult that guide or the linked docs page; never guess keybindings, config keys, or CLI flags.

How the team teaches a human to set up, use, and troubleshoot herdr, the sanctioned terminal workspace for this vault.

---

## Purpose & scope

This SOP covers three things: teaching a human what herdr is and how to use it, the setup context for this vault, and diagnosis when something isn't working. It does not cover an agent operating herdr from inside its own pane — that's a different job, done by the marketplace `herdr` skill under `HERDR_ENV=1`, not this SOP.

---

## What herdr is

A terminal multiplexer in the tmux family: a background server owns real terminal processes, and panes keep running through detach, closed terminals, or a dropped SSH connection. The difference from tmux is that herdr is mouse-first — panes, tabs, split borders, and menus are all clickable — and agent-aware: it detects coding agents running in a pane and shows each one's state (`working`, `blocked`, `done`, `idle`, `unknown`) in a sidebar across all open projects. A CLI and a local socket API expose the same control programmatically.

Docs: https://herdr.dev/docs/

---

## Concept model

Teach in this order:

- **Session** — a persistent background namespace. Plain `herdr` attaches to the default session; a named one (`herdr session attach work`) is a fully separate runtime namespace. Most people never need more than the default.
- **Workspace** — the project-level container, one per repo or task. Owns tabs and panes; the sidebar rolls agent states up per workspace.
- **Tab** — a layout inside a workspace, useful for separating views (e.g. `agents`, `logs`, `server`).
- **Pane** — a real terminal, splittable right or down, that survives a client detach.
- **Agent** — a process herdr recognises inside a pane, tracked through the five states above.
- **Modes** — terminal mode sends keys straight to the focused pane; prefix mode (`ctrl+b`, then one action key) sends a single command to herdr; navigate mode is a persistent navigation surface.

Docs: https://herdr.dev/docs/concepts/

---

## Install & update

herdr is an optional tool. This vault does not install it and does not check its version — onboarding once did both, and no longer does. Install it yourself from https://herdr.dev/docs/install/ on whatever channel that page recommends for your platform.

Once installed:

- Check the version: `herdr --version`
- Update: `herdr update` — never run this from inside a herdr session.

Docs: https://herdr.dev/docs/install/

---

## First-run walkthrough

Six steps, in order:

1. `cd` into the project and run `herdr`. This attaches to (or launches) the default session, creates a workspace for the project automatically, and shows an onboarding flow on first run.
2. Start the coding agent in the pane — `claude`, `codex`, or any other supported agent. herdr detects it on its own; running `herdr integration install claude` (or the matching command for another agent) improves detection accuracy.
3. Lead with the mouse: click panes and tabs to focus them, drag split borders to resize, right-click for menus, drag-select to copy. Nothing here requires a keybinding.
4. Split a pane: `prefix+v` for a right split, `prefix+minus` for a down split. New tab: `prefix+c`.
5. Detach with `prefix+q`, or just close the terminal window — everything keeps running in the background. Reattach later with plain `herdr`.
6. To stop everything (not just detach): `herdr server stop`.

**Nesting rule.** If `HERDR_ENV=1` is already set, the agent is running inside a herdr pane — skip step 1 and never launch `herdr` from within a pane. herdr blocks nested launches by design.

---

## Keyboard story

No keybindings are required — the mouse covers everything in the walkthrough above. When a human wants keyboard control anyway:

- The prefix is `ctrl+b` by default, and it's configurable under `[keys]` in the config file.
- `prefix+?` shows every binding currently active, live.
- If a chord does nothing, the outer terminal or OS consumed it before herdr saw it — this is expected for some chords, not a bug.

Point to https://herdr.dev/docs/keyboard/ rather than improvising a keybinding — it's the guided page for what to learn first and includes a vetted prefix-free `ctrl+alt` setup.

---

## Configuration

- Config file: `~/.config/herdr/config.toml`. herdr works fine without one.
- `herdr --default-config` prints the full set of defaults.
- `herdr server reload-config` applies edits to a running server without restarting it.
- Main config areas: `[keys]` (keybindings), `[theme]`, `[ui]` (sidebar and general UI behaviour), `[terminal]` (shell defaults), `[update]` (update channel).

Docs: https://herdr.dev/docs/configuration/

---

## Diagnosis recipes

**Agent not detected, or state looks wrong.** Run `herdr agent list` to see what herdr currently sees, and `herdr agent explain <target> --json` to see why the detector classified a pane the way it did. Installing the agent's integration (`herdr integration install <name>`, checked with `herdr integration status`) gives herdr authoritative state instead of relying on screen-scraping detection. Docs: https://herdr.dev/docs/agents/ and https://herdr.dev/docs/integrations/

**A keybinding does nothing.** The outer terminal or desktop environment is consuming the chord before herdr sees it. Send the human to https://herdr.dev/docs/keyboard/ to pick a chord herdr can actually receive.

**Startup or socket-API issues.** Logs live at `~/.config/herdr/herdr.log`, `~/.config/herdr/herdr-client.log`, and `~/.config/herdr/herdr-server.log`. `herdr status`, `herdr status server`, and `herdr status client` summarise runtime state.

**Working remotely.** Either SSH to the machine and run `herdr` there as usual, or attach a thin local client with `herdr --remote <host>`. Trade-offs: https://herdr.dev/docs/how-to-work/

**What survives a detach, restart, or update.** Covered in full at https://herdr.dev/docs/session-state/ — don't guess at this from the walkthrough above.

---

## Windows note

The preview beta is currently the only Windows channel. Update from *outside* a herdr session, same rule as any other platform. Any machine-local quirks discovered on this vault's Windows setup belong in `Vault/Memory/` per the [Memory Protocol SOP](Memory%20Protocol%20SOP.md), never recorded in this SOP.

---

## Rules for agents

- Never invent a keybinding, config key, or CLI flag. Verify against the linked docs page before stating one as fact.
- Teach mouse before keyboard to anyone new to a terminal multiplexer.
- herdr is not tmux — don't give tmux commands or `.tmux.conf` advice for a herdr question.
- For automation or scripting against herdr, point to the CLI reference (https://herdr.dev/docs/cli-reference/) and the socket API (https://herdr.dev/docs/socket-api/) rather than improvising a wrapper.

---

## Related

- [Repo Consultation SOP](Repo%20Consultation%20SOP.md)
- [Memory Protocol SOP](Memory%20Protocol%20SOP.md)
- `Resources/Onboarding/SETUP.md` § Appendix — Recommended plugins
- `Resources/SOPs/README.md` (SOP index)
