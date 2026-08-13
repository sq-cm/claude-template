#!/usr/bin/env bash
#
# tool-check.sh — freshness check for vault-dependent external tools
#
# Checks the locally installed plannotator binary against its latest
# GitHub release and prints a nudge line when it is behind.
# Never runs an update itself — check + nudge only (plannotator's install
# is a checksum-verified onboarding step, not something to run unattended).
#
# Bash 3.2 / Git Bash safe: no arrays, no `timeout`, no `mapfile`.
# set -u only (not -e) — always exits 0 so a SessionStart hook caller
# is never blocked by a network hiccup or a missing tool.
#
# Modes:
#   (no args)  print a nudge line only for tools that are behind (hook use)
#   --force    also print an `up to date` / `not installed` line per tool
#              (used by /update to report full freshness state)
#
# Comparison is string equality, not semver ordering — deliberate: every
# install path always pulls latest, so any mismatch is treated as behind.
#
# Network failure or unparseable API response: log one line to
# Vault/Memory/update-check-errors.md and skip that tool silently — never
# surfaced to the user, never a nonzero exit.

set -u

MODE="${1:-}"
ERROR_LOG="Vault/Memory/update-check-errors.md"

log_error() {
  mkdir -p "Vault/Memory" 2>/dev/null || true
  printf '%s — %s\n' "$(date -u +%FT%TZ 2>/dev/null || echo '?')" "$1" \
    >> "$ERROR_LOG" 2>/dev/null || true
}

fetch() {
  # $1 = URL. Prints body on stdout, empty on failure.
  curl -fsS --max-time 6 -H 'User-Agent: vault-tool-check' "$1" 2>/dev/null
}

# ---------------------------------------------------------------------------
# plannotator — https://github.com/backnotprop/plannotator
# ---------------------------------------------------------------------------
PLANNOTATOR_BIN=""
if command -v plannotator >/dev/null 2>&1; then
  PLANNOTATOR_BIN="plannotator"
elif [ -n "${LOCALAPPDATA:-}" ] && [ -x "$LOCALAPPDATA/plannotator/plannotator.exe" ]; then
  PLANNOTATOR_BIN="$LOCALAPPDATA/plannotator/plannotator.exe"
elif [ -x "/usr/local/bin/plannotator" ]; then
  PLANNOTATOR_BIN="/usr/local/bin/plannotator"
fi

if [ -n "$PLANNOTATOR_BIN" ]; then
  PLANNOTATOR_RAW="$("$PLANNOTATOR_BIN" --version 2>/dev/null)"
  PLANNOTATOR_VER="$(printf '%s' "$PLANNOTATOR_RAW" | sed 's/^plannotator[[:space:]]*//')"

  PLANNOTATOR_JSON="$(fetch 'https://api.github.com/repos/backnotprop/plannotator/releases/latest')"
  if [ -z "$PLANNOTATOR_JSON" ]; then
    log_error "tool-check: plannotator — GitHub API fetch failed"
  else
    LATEST_TAG="$(printf '%s' "$PLANNOTATOR_JSON" | grep -Eo '"tag_name": *"[^"]+"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"
    if [ -z "$LATEST_TAG" ]; then
      log_error "tool-check: plannotator — could not parse tag_name from GitHub API response"
    else
      LATEST_VER="${LATEST_TAG#v}"
      if [ "$PLANNOTATOR_VER" = "$LATEST_VER" ]; then
        [ "$MODE" = "--force" ] && printf 'plannotator: up to date (%s)\n' "$PLANNOTATOR_VER"
      else
        printf 'plannotator update available (installed %s, latest %s). Re-run /onboard Step 10 manually to update (checksum-verified download).\n' "$PLANNOTATOR_VER" "$LATEST_VER"
      fi
    fi
  fi
else
  [ "$MODE" = "--force" ] && printf 'plannotator: not installed\n'
fi

exit 0
