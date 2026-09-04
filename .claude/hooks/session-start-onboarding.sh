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
  # jq is guaranteed present at every call site below the jq guard. No
  # non-jq fallback: the old printf '"%s"' fallback escaped nothing and
  # produced invalid JSON whenever jq was present but failed on the
  # multi-line, quote-bearing CTX this hook emits (same fix as
  # update-check.sh's emit_context). A present-but-malfunctioning jq can
  # emit partial stdout and still exit non-zero, so checking for emptiness
  # alone is not sufficient, and `local enc=$(...)` would mask the
  # pipeline's exit status behind the always-successful `local`
  # assignment. Declare, assign and capture the status as separate
  # statements so none of that is masked.
  local enc
  local rc
  enc="$(printf '%s' "$1" | jq -Rs .)"
  rc=$?
  if [ "$rc" -ne 0 ] || [ -z "$enc" ]; then
    log_error "jq present, encoding failed (exit $rc) — onboarding context skipped"
    emit_silent
  fi
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' "$enc"
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
# A plugin disabled in .claude/settings.json enabledPlugins MUST NOT appear in
# REQUIRED_KEYS, the migration-detection `for p in ...` loop below, the
# migration branch's comma-separated key list inside the CTX string, or the
# flag→step map at the bottom of this file. It can never become true,
# all_complete never holds, and this block re-fires every session forever.
# superpowers was exactly that from 17/07/2026 until plan 060. Four sites in
# this file encode the plugin roster — name them by what they are, not by
# line number, which drifts every time this file is edited.
REQUIRED_KEYS="tier1_git_hooks tier1_env_copy tier1_node tier2_caveman tier2_plugin_claude_mem tier2_plugin_context_mode tier2_plugin_obsidian tier2_plugin_document_skills tier2_plugin_skill_creator tier2_plugin_frontend_design tier2_plugin_plannotator tier2_plugin_higgsfield tier2_vscode_git tier2_plannotator_binary tier1_notes_seed"

# Derived views of REQUIRED_KEYS — the roster is encoded ONCE, above.
# Check 14 in Vault/Scripts/validate.sh greps the literal REQUIRED_KEYS=
# line; keep that assignment literal and single-line forever.
PLUGIN_SHORT=""          # underscore names, prefix stripped: claude_mem context_mode ...
for k in $REQUIRED_KEYS; do
  case "$k" in
    tier2_plugin_*) PLUGIN_SHORT="$PLUGIN_SHORT ${k#tier2_plugin_}" ;;
  esac
done
PLUGIN_SHORT="${PLUGIN_SHORT# }"
PLUGIN_DIRS=$(printf '%s' "$PLUGIN_SHORT" | tr '_' '-')        # hyphen folder names
REQUIRED_KEYS_CSV=$(printf '%s' "$REQUIRED_KEYS" | sed 's/ /, /g')
PLUGIN_MAP_SEGMENT="tier2_plugin_$(printf '%s' "$PLUGIN_SHORT" | sed 's| |/|g')"

# Keys that are resolved, not just missing, when the flags file records them
# as the literal string "skipped" rather than true — for a step that was
# attempted and deliberately not run (e.g. no Node.js on this machine), as
# opposed to a step nobody has attempted yet. Never set these true to fake
# completion; write "skipped" instead, or the block re-fires forever exactly
# like the disabled-plugin defect described above. tier2_plannotator_binary's
# "skipped" is narrower than the other two: it applies only when Step 10's
# privileged move fails for lack of a cached sudo credential, never when the
# checksum mismatches or the download fails — those stay unresolved so the
# step retries instead of being silently accepted.
SKIPPABLE_KEYS="tier1_node tier2_caveman tier2_plannotator_binary"

if ! command -v jq >/dev/null 2>&1; then
  log_error "jq not found on PATH — auto-onboarding disabled"
  # Say something rather than exiting silently. Onboarding cannot run without a
  # JSON parser, and a silent skip leaves the session looking fully configured
  # when none of Tier 1 or Tier 2 has happened. emit_context needs jq, so this
  # one message is emitted as a bare JSON string literal instead: it contains
  # no double quotes, no backslashes and no newlines, so the unescaped %s
  # substitution is valid JSON by construction. Keep it that way.
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' \
    'AUTO-ONBOARDING SKIPPED: jq is not installed, so first-time setup cannot run. Tell the user in one line that jq must be installed and /onboard re-run, point them at Resources/Onboarding/SETUP.md, and then answer their original question normally. Do not attempt to install jq.'
  exit 0
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
  if [ "$v" = "true" ]; then
    continue
  fi
  case " $SKIPPABLE_KEYS " in
    *" $k "*) [ "$v" = "skipped" ] && continue ;;
  esac
  all_complete=false
  missing="$missing $k"
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

TIER1_NOTES="no Notes.example.md found"
if [ -f "$DIR/Notes/Personal/Notes.md" ]; then
  TIER1_NOTES="exists"
elif [ -f "$DIR/Resources/Onboarding/Notes.example.md" ]; then
  mkdir -p "$DIR/Notes/Personal" 2>/dev/null || true
  if cp "$DIR/Resources/Onboarding/Notes.example.md" "$DIR/Notes/Personal/Notes.md" 2>/dev/null; then
    TIER1_NOTES="created from Notes.example.md"
  else
    TIER1_NOTES="FAILED to copy"
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
[ "$TIER1_NOTES" = "exists" ] || behavioural_pass=false
[ "$NODE_OK" = "true" ] || behavioural_pass=false
PLUGINS_DIR="${HOME:-$USERPROFILE}/.claude/plugins"
if [ -d "$PLUGINS_DIR" ] && command -v find >/dev/null 2>&1; then
  # caveman stays literal: it is tier2_caveman, not a tier2_plugin_* key, so
  # it is not derivable from the plugin subset — it was part of this
  # migration signal by original design before this derivation existed.
  for p in $PLUGIN_DIRS caveman; do
    if ! find "$PLUGINS_DIR" -maxdepth 2 -type d -iname "$p" 2>/dev/null | grep -q .; then
      behavioural_pass=false
      break
    fi
  done
else
  behavioural_pass=false
fi

# tier2_plannotator_binary migration signal — binary on disk. Same locate
# order as Vault/Scripts/tool-check.sh. Checked independently of
# behavioural_pass so an existing machine that already has the binary does
# not trigger a needless re-run of Step 10.
PLANNOTATOR_BIN_FOUND=false
if command -v plannotator >/dev/null 2>&1; then
  PLANNOTATOR_BIN_FOUND=true
elif [ -n "${LOCALAPPDATA:-}" ] && [ -x "$LOCALAPPDATA/plannotator/plannotator.exe" ]; then
  PLANNOTATOR_BIN_FOUND=true
elif [ -x "/usr/local/bin/plannotator" ]; then
  PLANNOTATOR_BIN_FOUND=true
fi

# Full early-exit migration path: only when EVERY signal (the whole
# behavioural_pass bundle — git hooks, .env, the personal scratchpad, Node
# and the plugin roster — plus the plannotator binary) already passes on
# disk — matches the "all onboarding signals already pass" claim below.
if [ "$behavioural_pass" = "true" ] && [ "$PLANNOTATOR_BIN_FOUND" = "true" ]; then
  CTX="=== AUTO-ONBOARDING: MIGRATION ===

All onboarding signals already pass on disk but Vault/Memory/onboarding-flags.json has no onboarded flags.

ACTION (silent — before responding to user):
1. Read Vault/Memory/onboarding-flags.json (create with {} if absent).
2. Merge in 'onboarded' object with all these keys set true: $REQUIRED_KEYS_CSV.
3. Write back. Do NOT narrate. Then handle the user's original message normally."
  emit_context "$CTX"
fi

# Partial back-fill: drop tier2_plannotator_binary from the missing-flag
# list (and queue a silent flag write) whenever its own disk check passes,
# independently of behavioural_pass — so a machine that already has the
# binary does not re-trigger Step 10 just because another flag is missing.
BACKFILL_NOTE=""
case " $missing " in
  *" tier2_plannotator_binary "*)
    if [ "$PLANNOTATOR_BIN_FOUND" = "true" ]; then
      missing=" $missing "
      missing=${missing/ tier2_plannotator_binary / }
      missing=${missing# }
      missing=${missing% }
      BACKFILL_NOTE="${BACKFILL_NOTE}tier2_plannotator_binary "
    fi
    ;;
esac

BACKFILL_ACTION=""
if [ -n "$BACKFILL_NOTE" ]; then
  BACKFILL_ACTION="
Before running steps: these keys are already true on disk (binary/tool found) but absent from the flags file — silently set them true under 'onboarded' in Vault/Memory/onboarding-flags.json first, no step needed: $BACKFILL_NOTE"
fi

# Known gap in the flag→step map below, left alone deliberately by plan 091:
# tier1_env_copy has the same sample-absent case the tier1_notes_seed clause
# spells out. TIER1_ENV reports "no .env.example found" when the sample is
# missing, and the general set-true-unless-FAILED rule reads as permitting
# true — resolving a key whose copy never happened. Out of scope for plan 091,
# which added the notes clause only; logged here so the next reader finds it
# recorded rather than rediscovering it. Fix both clauses together if either
# is ever revisited.

# The ACTION below runs onboard.md Steps 3, 7, 8, 9 and 10 only. Steps 11–13
# (print the roster, open the Learn guide in a browser, the demo-project tour)
# are deliberately left to a manual /onboard: this hook fires while the user
# is waiting for an answer to their own first message, and launching a
# browser or a long tour mid-question is intrusive. The ACTION closes with a
# one-line pointer at the guide instead (plan 119, 04/09/2026). Tier 1 steps
# stay out of the list for a different reason — the hook performs them itself
# (plan 091).
CTX="=== AUTO-ONBOARDING TRIGGERED ===

Tier 1 (done by hook): git=$TIER1_GIT; env=$TIER1_ENV; node=$TIER1_NODE; notes=$TIER1_NOTES.
Missing flags:$missing
$BACKFILL_ACTION

ACTION: Tell user one line: 'First-time setup detected — running onboarding (~1 min). Then I will handle your question.' Then execute the steps in .claude/commands/onboard.md (Steps 3, 7, 8, 9, 10). For each missing flag above, complete the matching step and set that key to true under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys). One-line narration per step ('claude-mem ok'). If Node MISSING, follow onboard.md Step 7's Node branch for this platform (never install Node on macOS or Linux), and if Node is still unavailable write tier1_node and tier2_caveman as the string \"skipped\" (never true) — this records Caveman as attempted and deliberately not run, which resolves both keys instead of re-triggering onboarding every session — then continue with Steps 8, 9 and 10: Caveman is the only step that needs Node; the plugin roster and the plannotator binary do not. Never stop onboarding because Node is missing. If Step 10's privileged move fails only because there is no cached sudo credential (not a checksum mismatch or a download failure), write tier2_plannotator_binary as the string \"skipped\" (never true) — the step was attempted and deliberately not completed, so recording it resolves the key instead of re-triggering onboarding every session. On any step failure: one-line warning, continue, do not set that flag. After all attempted, add one line pointing at the onboarding guide — 'Your onboarding guide is at Resources/Learn/index.html; ask me how to use the system any time and I will open it.' — and do not open it now; then pivot to user's original message ('Setup done. On your question: ...').

Flag→step map: tier1_git_hooks/tier1_env_copy/tier1_notes_seed = hook already ran (set true unless the Tier 1 line reports FAILED for that key — for the two copy keys both 'exists' and 'created from ...' set it true); for tier1_notes_seed there is one further case — if the Tier 1 line reports notes=no Notes.example.md found, the tracked sample is missing from a partial pull, so leave the key unset rather than true and the step retries after the next pull (same reasoning as the tier2_plannotator_binary checksum-mismatch rule later in this map); tier1_node = set true iff Node present, else \"skipped\" if the user declines or cannot install it (never true); $PLUGIN_MAP_SEGMENT = Step 8+9 plugin pairs (the plugin registration flag here covers only the Claude Code plugin, which auto-installs per settings.json); tier2_plannotator_binary = Step 10 (auto-run, checksum-verified, no consent gate), or \"skipped\" if the privileged move needs a password with no cached credential, never on a checksum mismatch or a download failure (never true); tier2_caveman = Step 7 + '/caveman lite', or \"skipped\" alongside tier1_node when Node is unavailable; tier2_vscode_git = Step 3."

emit_context "$CTX"
