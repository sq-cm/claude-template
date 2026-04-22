# First-Run Setup

Everything needed to deploy a new instance of this vault from scratch.

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

This does three things automatically: blocks push to the upstream template repo (your instance is yours — you can't accidentally push back), activates git hooks, and creates your `.env` file. Then continue with the steps below.

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

```bash
git config core.hooksPath .githooks
```

Run this once after cloning. Hooks enforce vault hygiene on commit.

---

## Step 3 — Choose a team naming theme (or keep default)

The vault ships with placeholder role names. You have two options:

**Option A — Keep default (no action needed)**  
Default names are already set in `Vault/Memory/theme-name-map.md`. Skip to Step 4.

**Option B — Apply a naming theme**  
Ask Sam: `apply a [theme] naming theme to the team` — e.g. Norse mythology, Greek gods, Pokémon.  
Sam will route to Ryan (research) → Harper (persona renaming) → Sam (execution).  
See `Resources/SOPs/Theme Setup SOP.md` for the full workflow.

---

## Step 4 — Bootstrap memory

Open `Vault/Memory/MEMORY.md` and add a first entry:

```markdown
## Session Bootstrap — [YYYY-MM-DD]

- Vault deployed from template
- Theme: [default / name of theme applied]
- Active team size: 20
- Notes: [anything worth remembering from setup]
```

This anchors the memory file for future sessions.

---

## Step 5 — Populate the repo index (optional but recommended)

If you plan to use repo-backed best practices (Repo Consultation SOP), add repos to `Resources/Git/INDEX.md`.

See `Resources/SOPs/Repo Setup SOP.md` for how to clone repos and add index entries.

---

## Step 6 — Verify the vault

Ask Sam: `check the roster` — Sam will confirm all 20 team members are present and correctly linked.

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
| `Team/INDEX.md` | Quick roster lookup |
