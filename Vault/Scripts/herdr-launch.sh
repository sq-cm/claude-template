#!/usr/bin/env bash
# herdr-launch.sh — check-and-install layer for herdr (https://herdr.dev), the
# agent multiplexer. install.sh and the VS Code startup terminal (on
# macOS/Linux, once .vscode/restore-terminals.json is swapped per SETUP.md)
# both call this script so the check+install logic exists exactly once.
#
# Never depends on cwd — all paths are $HOME/env based; herdr launches
# wherever the terminal's cwd happens to be.
#
# --install-only: run the guarded install steps only, never launch herdr.

INSTALL_ONLY=false
[ "$1" = "--install-only" ] && INSTALL_ONLY=true

YELLOW='\033[1;33m'
NC='\033[0m'

warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# --- Step a: herdr binary ---------------------------------------------------
if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr not found — installing..."
    install_script="$(curl -fsSL --max-time 120 https://herdr.dev/install.sh)" && printf '%s' "$install_script" | sh \
        || warn "herdr install failed — install manually with: curl -fsSL https://herdr.dev/install.sh | sh"

    if ! command -v herdr >/dev/null 2>&1; then
        export PATH="${HERDR_INSTALL_DIR:-$HOME/.local/bin}:$PATH"
    fi
fi

# --- Step b: Claude Code integration -----------------------------------------
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

if command -v herdr >/dev/null 2>&1 && [ -d "$CLAUDE_CONFIG_DIR" ]; then
    hook_exists=false
    ls "$CLAUDE_CONFIG_DIR"/hooks/herdr-agent-state.* >/dev/null 2>&1 && hook_exists=true

    settings_file="$CLAUDE_CONFIG_DIR/settings.json"
    settings_has_herdr=false
    [ -f "$settings_file" ] && grep -q herdr "$settings_file" 2>/dev/null && settings_has_herdr=true

    if [ "$hook_exists" = false ] && [ "$settings_has_herdr" = false ]; then
        [ -f "$settings_file" ] && cp "$settings_file" "$settings_file.herdr-backup"
        herdr integration install claude || warn "herdr Claude Code integration install failed — run manually: herdr integration install claude"
    fi
fi

# --- Step c: agent skill -----------------------------------------------------
if [ ! -d "$CLAUDE_CONFIG_DIR/skills/herdr" ] && command -v npx >/dev/null 2>&1; then
    npx_warning="herdr agent skill install failed — run manually: npx -y skills add ogulcancelik/herdr --skill herdr -g"
    if command -v timeout >/dev/null 2>&1; then
        timeout 120 npx -y skills add ogulcancelik/herdr --skill herdr -g || warn "$npx_warning"
    else
        npx -y skills add ogulcancelik/herdr --skill herdr -g || warn "$npx_warning"
    fi
fi

# --- Launch ------------------------------------------------------------------
if [ "$INSTALL_ONLY" = false ]; then
    if command -v herdr >/dev/null 2>&1; then
        exec herdr
    else
        warn "herdr still not on PATH — install manually with: curl -fsSL https://herdr.dev/install.sh | sh"
        exit 0
    fi
fi
