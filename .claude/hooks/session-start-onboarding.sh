#!/usr/bin/env bash
# SessionStart hook — auto-onboard new teammates.
# MUST always exit 0 (non-zero blocks the session).

set -u

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi

emit_silent() { exit 0; }

emit_context() {
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' \
    "$(printf '%s' "$1" | jq -Rs . 2>/dev/null || printf '"%s"' "$1")"
  exit 0
}

log_error() {
  mkdir -p "$DIR/Vault/Memory" 2>/dev/null || true
  printf '%s — %s\n' "$(date -u +%FT%TZ 2>/dev/null || echo '?')" "$1" \
    >> "$DIR/Vault/Memory/onboarding-errors.md" 2>/dev/null || true
}

# Maintainer short-circuit
if [ "${CLAUDE_TEMPLATE_MAINTAINER:-}" = "1" ]; then emit_silent; fi

# Bail if not inside template
if [ ! -f "$DIR/CLAUDE.md" ] || [ ! -d "$DIR/.claude/agents" ]; then emit_silent; fi

SETTINGS="$DIR/Vault/Memory/onboarding-flags.json"
REQUIRED_KEYS="tier1_git_hooks tier1_env_copy tier1_node tier2_caveman tier2_plugin_claude_mem tier2_plugin_context_mode tier2_plugin_obsidian tier2_plugin_superpowers tier2_plugin_marketing_skills tier2_plugin_document_skills tier2_plugin_skill_creator tier2_plugin_frontend_design tier2_plugin_plannotator tier2_plugin_higgsfield tier2_vscode_git tier2_plannotator_binary tier2_herdr"

if ! command -v jq >/dev/null 2>&1; then
  log_error "jq not found on PATH — auto-onboarding disabled"
  emit_silent
fi

ONBOARDED_JSON="{}"
if [ -f "$SETTINGS" ]; then
  if jq empty "$SETTINGS" >/dev/null 2>&1; then
    ONBOARDED_JSON=$(jq -c '.onboarded // {}' "$SETTINGS" 2>/dev/null || echo "{}")
  else
    log_error "malformed onboarding-flags.json — treated as flag absent"
  fi
fi

all_complete=true
missing=""
for k in $REQUIRED_KEYS; do
  v=$(printf '%s' "$ONBOARDED_JSON" | jq -r --arg k "$k" '.[$k] // false' 2>/dev/null)
  if [ "$v" != "true" ]; then
    all_complete=false
    missing="$missing $k"
  fi
done

if [ "$all_complete" = "true" ]; then emit_silent; fi

# Tier 1 silent fixes
TIER1_GIT="skipped (not a git repo)"
if [ -d "$DIR/.git" ]; then
  CURRENT=$(git -C "$DIR" config --get core.hooksPath 2>/dev/null || echo "")
  if [ "$CURRENT" = ".githooks" ]; then
    TIER1_GIT="already set"
  else
    if git -C "$DIR" config core.hooksPath .githooks 2>/dev/null; then
      TIER1_GIT="set to .githooks"
    else
      TIER1_GIT="FAILED to set"
    fi
  fi
fi

TIER1_ENV="no .env.example found"
if [ -f "$DIR/.env" ]; then
  TIER1_ENV="exists"
elif [ -f "$DIR/.env.example" ]; then
  if cp "$DIR/.env.example" "$DIR/.env" 2>/dev/null; then
    TIER1_ENV="created from .env.example"
  else
    TIER1_ENV="FAILED to copy"
  fi
fi

if command -v node >/dev/null 2>&1; then
  TIER1_NODE="present ($(node --version 2>/dev/null || echo unknown))"
  NODE_OK=true
else
  TIER1_NODE="MISSING"
  NODE_OK=false
fi

# Migration detection
behavioural_pass=true
[ "$TIER1_GIT" = "already set" ] || behavioural_pass=false
[ "$TIER1_ENV" = "exists" ] || behavioural_pass=false
[ "$NODE_OK" = "true" ] || behavioural_pass=false
PLUGINS_DIR="${HOME:-$USERPROFILE}/.claude/plugins"
if [ -d "$PLUGINS_DIR" ] && command -v find >/dev/null 2>&1; then
  for p in claude-mem context-mode obsidian superpowers marketing-skills document-skills skill-creator frontend-design plannotator higgsfield caveman; do
    if ! find "$PLUGINS_DIR" -maxdepth 2 -type d -iname "$p" 2>/dev/null | grep -q .; then
      behavioural_pass=false
      break
    fi
  done
else
  behavioural_pass=false
fi

# tier2_plannotator_binary / tier2_herdr migration signals — binary on disk,
# herdr on PATH. Same locate order as Vault/Scripts/tool-check.sh. Checked
# independently of behavioural_pass and of each other: an existing machine
# with plannotator but no herdr (or vice versa) must not fail the other
# tool's back-fill and trigger a needless re-run of its step.
PLANNOTATOR_BIN_FOUND=false
if command -v plannotator >/dev/null 2>&1; then
  PLANNOTATOR_BIN_FOUND=true
elif [ -n "${LOCALAPPDATA:-}" ] && [ -x "$LOCALAPPDATA/plannotator/plannotator.exe" ]; then
  PLANNOTATOR_BIN_FOUND=true
elif [ -x "/usr/local/bin/plannotator" ]; then
  PLANNOTATOR_BIN_FOUND=true
fi

HERDR_FOUND=false
command -v herdr >/dev/null 2>&1 && HERDR_FOUND=true

# Full early-exit migration path: only when EVERY signal (the original
# behavioural_pass bundle plus both new tools independently) already passes
# on disk — matches the "all onboarding signals already pass" claim below.
if [ "$behavioural_pass" = "true" ] && [ "$PLANNOTATOR_BIN_FOUND" = "true" ] && [ "$HERDR_FOUND" = "true" ]; then
  CTX="=== AUTO-ONBOARDING: MIGRATION ===

All onboarding signals already pass on disk but Vault/Memory/onboarding-flags.json has no onboarded flags.

ACTION (silent — before responding to user):
1. Read Vault/Memory/onboarding-flags.json (create with {} if absent).
2. Merge in 'onboarded' object with all these keys set true: tier1_git_hooks, tier1_env_copy, tier1_node, tier2_caveman, tier2_plugin_claude_mem, tier2_plugin_context_mode, tier2_plugin_obsidian, tier2_plugin_superpowers, tier2_plugin_marketing_skills, tier2_plugin_document_skills, tier2_plugin_skill_creator, tier2_plugin_frontend_design, tier2_plugin_plannotator, tier2_plugin_higgsfield, tier2_vscode_git, tier2_plannotator_binary, tier2_herdr.
3. Write back. Do NOT narrate. Then handle the user's original message normally."
  emit_context "$CTX"
fi

# Partial back-fill: drop tier2_plannotator_binary / tier2_herdr from the
# missing-flag list (and queue a silent flag write) whenever their own disk
# check passes, independently of behavioural_pass and of each other — so a
# machine missing only herdr does not also re-trigger plannotator's Step 10.
BACKFILL_NOTE=""
case " $missing " in
  *" tier2_plannotator_binary "*)
    if [ "$PLANNOTATOR_BIN_FOUND" = "true" ]; then
      missing=$(printf '%s' "$missing" | sed 's/\btier2_plannotator_binary\b//')
      BACKFILL_NOTE="${BACKFILL_NOTE}tier2_plannotator_binary "
    fi
    ;;
esac
case " $missing " in
  *" tier2_herdr "*)
    if [ "$HERDR_FOUND" = "true" ]; then
      missing=$(printf '%s' "$missing" | sed 's/\btier2_herdr\b//')
      BACKFILL_NOTE="${BACKFILL_NOTE}tier2_herdr "
    fi
    ;;
esac

BACKFILL_ACTION=""
if [ -n "$BACKFILL_NOTE" ]; then
  BACKFILL_ACTION="
Before running steps: these keys are already true on disk (binary/tool found) but absent from the flags file — silently set them true under 'onboarded' in Vault/Memory/onboarding-flags.json first, no step needed: $BACKFILL_NOTE"
fi

CTX="=== AUTO-ONBOARDING TRIGGERED ===

Tier 1 (done by hook): git=$TIER1_GIT; env=$TIER1_ENV; node=$TIER1_NODE.
Missing flags:$missing
$BACKFILL_ACTION

ACTION: Tell user one line: 'First-time setup detected — running onboarding (~1 min). Then I will handle your question.' Then execute the steps in .claude/commands/onboard.md (Steps 3, 7, 8, 9, 10, 14). For each missing flag above, complete the matching step and set that key to true under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys). One-line narration per step ('claude-mem ok'). If Node MISSING, stop Tier 2 and ask user to install Node.js LTS manually. On any step failure: one-line warning, continue, do not set that flag. After all attempted, pivot to user's original message ('Setup done. On your question: ...').

Flag→step map: tier1_git_hooks/tier1_env_copy = hook already ran (set true unless FAILED); tier1_node = set true iff Node present; tier2_plugin_claude_mem/context_mode/obsidian/superpowers/marketing_skills/document_skills/skill_creator/frontend_design/plannotator/higgsfield = Step 8+9 plugin pairs (the plugin registration flag here covers only the Claude Code plugin, which auto-installs per settings.json); tier2_plannotator_binary = Step 10 (auto-run, checksum-verified, no consent gate); tier2_herdr = Step 14; tier2_caveman = Step 7 + '/caveman lite'; tier2_vscode_git = Step 3."

emit_context "$CTX"
