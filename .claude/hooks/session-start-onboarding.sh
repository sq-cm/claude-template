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
if [ ! -f "$DIR/AGENTS.md" ] || [ ! -d "$DIR/.claude/agents" ]; then emit_silent; fi

SETTINGS="$DIR/Vault/Memory/onboarding-flags.json"
# A plugin disabled in .claude/settings.json enabledPlugins MUST NOT keep its
# tier2_plugin_<name> entry in REQUIRED_KEYS: it can never become true,
# all_complete never holds, and this block re-fires every session forever.
# superpowers was exactly that from 17/07/2026 until plan 060. REQUIRED_KEYS
# is the ONLY site to edit for a tier2_plugin_* plugin — the install-check
# loop, the migration branch's key list and the flag→step map are derived
# from it below (plan 128). Caveman is the one exception: it is
# tier2_caveman, not a tier2_plugin_* key, so it also appears literally in
# SKIPPABLE_KEYS, the install-check loop, the Step 7 case line and the
# flag→step map. Name sites by what they are, not by line number, which
# drifts every time this file is edited. validate.sh Check 14 FAILs a
# tier2_plugin_* key whose plugin is disabled or missing.
REQUIRED_KEYS="tier1_git_hooks tier1_env_copy tier1_node tier2_caveman tier2_plugin_claude_mem tier2_plugin_context_mode tier2_plugin_obsidian tier2_plugin_document_skills tier2_plugin_skill_creator tier2_plugin_frontend_design tier2_vscode_git tier1_notes_seed"

# Derived views of REQUIRED_KEYS — the roster is encoded ONCE, above.
# Check 14 in Vault/Scripts/validate.sh greps the literal REQUIRED_KEYS=
# line; keep that assignment literal and single-line forever.
PLUGIN_SHORT=""          # underscore names, prefix stripped: claude_mem context_mode ...
NONPLUGIN_KEYS=""        # every key the agent may write true: the migration list
for k in $REQUIRED_KEYS; do
  case "$k" in
    tier2_plugin_*) PLUGIN_SHORT="$PLUGIN_SHORT ${k#tier2_plugin_}" ;;
    *) NONPLUGIN_KEYS="$NONPLUGIN_KEYS $k" ;;
  esac
done
PLUGIN_SHORT="${PLUGIN_SHORT# }"
NONPLUGIN_KEYS="${NONPLUGIN_KEYS# }"
PLUGIN_NAMES=$(printf '%s' "$PLUGIN_SHORT" | tr '_' '-')       # hyphen plugin names
# PLUGIN_NAMES holds plugin names, not folder names: they are matched against
# the `<name>@` prefix of each .claude/settings.json enabledPlugins key, the
# same mapping Check 14 in Vault/Scripts/validate.sh uses. It stopped being a
# folder list in plan 128, when the directory probe was replaced by a read of
# Claude Code's own install record.
NONPLUGIN_KEYS_CSV=$(printf '%s' "$NONPLUGIN_KEYS" | sed 's/ /, /g')
PLUGIN_MAP_SEGMENT="tier2_plugin_$(printf '%s' "$PLUGIN_SHORT" | sed 's| |/|g')"

# Keys that are resolved, not just missing, when the flags file records them
# as the literal string "skipped" rather than true — for a step that was
# attempted and deliberately not run (e.g. no Node.js on this machine) or that
# the user does not want, as opposed to a step nobody has attempted yet.
# Never set these true to fake completion; write "skipped" instead, or the
# block re-fires forever exactly like the disabled-plugin defect described
# above. Every non-plugin tier2_* key is listed, plus tier1_node (plan 139).
# The tier2_plugin_* keys accept "skipped" too, but they are deliberately NOT
# listed here: their resolution runs through the plugin install check's own
# branch in the loop below (plan 128). Every tier2_* key, plugin or not, also
# accepts a snooze object {"snoozed_until":"YYYY-MM-DD"} — see snooze_active.
SKIPPABLE_KEYS="tier1_node tier2_caveman tier2_vscode_git"

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

# Plugin install check — Claude Code's own install record is the authority on
# which plugins are installed, not this repo's flags file and not a directory
# probe. Two defects made the old arrangement report plugins as present when
# they were not: the flags file was trusted outright, so a stale
# tier2_plugin_claude_mem: true hid a plugin whose ID had never resolved; and
# the migration probe matched folder names with `find -maxdepth 2`, which both
# missed real installs at cache/<marketplace>/<plugin> (depth 3) and counted a
# plugin installed from the wrong marketplace as present (plan 128).
#
# The record alone turned out not to be enough either: a plugin that is loaded
# and cached can be missing from it (claude-mem was, on two machines, on
# 30/09/2026), and the single startup read races the trust-prompt
# auto-install. So a plugin also counts as installed when its cache holds a
# non-empty version dir (plugin_cached), and a changed enabledPlugins set buys
# one session of grace before any plugin is reported (PLUGIN_GRACE, plan 139).
#
# This runs BEFORE the all_complete loop deliberately, so it fires on every
# session — including the sessions that loop would otherwise exit silently on.
# That places it before the hook's early exits, so everything here is written
# to be `set -u`-safe and every jq call is silenced: the hook must still always
# exit 0.
#
# Installed, not enabled, is the test. .claude/settings.local.json is never
# read — a plugin disabled locally is resolved by writing the literal "skipped"
# into the flags file, not by this check.
PLUGIN_RECORD_STATE="absent"   # absent | ok | unrecognised
INSTALLED_IDS=""
# Where the record lives. CLAUDE_CONFIG_DIR moves Claude Code's whole config
# tree, plugins/ included, so when it is set it wins outright and neither HOME
# nor USERPROFILE is consulted at all. Otherwise the config dir is
# $HOME/.claude, with USERPROFILE as the Windows fallback.
PLUGIN_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-}"
if [ -z "$PLUGIN_CONFIG_DIR" ]; then
  PLUGIN_HOME="${HOME:-${USERPROFILE:-}}"
  [ -n "$PLUGIN_HOME" ] && PLUGIN_CONFIG_DIR="$PLUGIN_HOME/.claude"
fi
if [ -z "$PLUGIN_CONFIG_DIR" ]; then
  # Nowhere to look at all. That is an unrecognised record, not an absent one:
  # not knowing where the record lives is not evidence that nothing is
  # installed, and declaring the whole roster missing on that basis would
  # re-fire onboarding every session on such a machine. Plugin keys fall back
  # to flags-file semantics instead.
  PLUGIN_RECORD_STATE="unrecognised"
  log_error "no CLAUDE_CONFIG_DIR, HOME or USERPROFILE — plugin install record unlocatable, plugin keys fall back to flags-file semantics"
else
  if command -v cygpath >/dev/null 2>&1; then
    PLUGIN_CONFIG_DIR=$(cygpath -u "$PLUGIN_CONFIG_DIR" 2>/dev/null || echo "$PLUGIN_CONFIG_DIR")
  fi
  PLUGIN_RECORD="$PLUGIN_CONFIG_DIR/plugins/installed_plugins.json"
  # A config dir that resolves but holds no record file stays "absent": that is
  # a machine with no plugins installed, and every plugin counts as missing.
  if [ -f "$PLUGIN_RECORD" ]; then
    # Shape gate. A v2 record is {"version": 2, "plugins": {"<id>": [ ... ]}}.
    # Anything else — a v1 record, a future format, or malformed JSON — falls
    # back to flags-file semantics for plugin keys rather than declaring every
    # plugin missing, so an upstream format change cannot put every machine
    # into a permanent onboarding loop.
    if [ "$(jq -r '.version // empty' "$PLUGIN_RECORD" 2>/dev/null)" = "2" ] \
      && [ "$(jq -r '.plugins | type' "$PLUGIN_RECORD" 2>/dev/null)" = "object" ]; then
      PLUGIN_RECORD_STATE="ok"
      # A plugin counts as installed when its entry array is non-empty — empty
      # arrays do occur. Entries of any `scope` count, including `project`
      # entries installed from other paths: the plugin is on this machine
      # either way, which is what onboarding is asking about.
      INSTALLED_IDS=$(jq -r '.plugins | to_entries[] | select(.value | length > 0) | .key' "$PLUGIN_RECORD" 2>/dev/null)
    else
      PLUGIN_RECORD_STATE="unrecognised"
      log_error "installed_plugins.json is not a recognised v2 record — plugin keys fall back to flags-file semantics"
    fi
  fi
fi

# Full plugin IDs come from the checked-in roster, so the marketplace half of
# an ID is never guessed: match each PLUGIN_NAMES entry against the `<name>@`
# prefix of the enabledPlugins keys, then compare the whole ID exactly.
# The old folder-name probe never compared the marketplace half of an ID, so a
# roster entry naming the wrong marketplace passed as long as some folder
# carried the plugin name. Never reintroduce a match that ignores the
# `@marketplace` half.
ENABLED_IDS=$(jq -r '.enabledPlugins | keys[]' "$DIR/.claude/settings.json" 2>/dev/null || echo "")

# Cache fallback for a plugin the record misses. The path is built from the
# full ID, cache/<marketplace>/<name>/<version>/, so the `@marketplace` half is
# still compared. Accepted residual (plan 139, Decision 1): a stale cache dir
# left behind by an uninstalled plugin hides it from this check indefinitely.
plugin_cached() {              # $1 = a full plugin ID, <name>@<marketplace>
  local d
  [ -n "$PLUGIN_CONFIG_DIR" ] || return 1
  case "$1" in *@*) ;; *) return 1 ;; esac
  for d in "$PLUGIN_CONFIG_DIR/plugins/cache/${1#*@}/${1%%@*}"/*/; do
    [ -d "$d" ] || continue
    [ -n "$(ls -A "$d" 2>/dev/null)" ] && return 0
  done
  return 1
}

PLUGINS_PRESENT=""             # hyphen names confirmed present in the record or cache
ALL_PLUGINS_INSTALLED=true
# caveman stays literal: it is tier2_caveman, not a tier2_plugin_* key, so it
# is not derivable from the plugin subset — it was part of the migration signal
# by original design before this derivation existed.
for p in $PLUGIN_NAMES caveman; do
  pid=$(printf '%s\n' "$ENABLED_IDS" | grep -m1 -e "^$p@" || echo "")
  if [ -n "$pid" ] && { { [ "$PLUGIN_RECORD_STATE" = "ok" ] && printf '%s\n' "$INSTALLED_IDS" | grep -qxF "$pid"; } || plugin_cached "$pid"; }; then
    PLUGINS_PRESENT="$PLUGINS_PRESENT $p"
  else
    ALL_PLUGINS_INSTALLED=false
  fi
done

plugin_key_present() {         # $1 = a tier2_plugin_<name> flag key
  local short
  short=$(printf '%s' "${1#tier2_plugin_}" | tr '_' '-')
  case " $PLUGINS_PRESENT " in *" $short "*) return 0 ;; esac
  return 1
}

# Settings-change grace. The auto-install that follows the trust prompt, or a
# roster change pulled by /update, races this hook's single startup read, so a
# plugin reported missing in that session may be seconds from installed. The
# sorted list of enabledPlugins IDs set true is kept in a git-ignored snapshot;
# when it is new or has changed, no plugin is reported this session and the
# check runs next session. Grace needs the new snapshot written: a snapshot
# that cannot be written would grant grace every session and hide a missing
# plugin forever, so on a failed write the checks run normally.
PLUGIN_SNAPSHOT="$DIR/Vault/Memory/.onboarding-plugin-snapshot"
PLUGIN_GRACE=false
SNAP_NEW=$(jq -r '.enabledPlugins // {} | to_entries[] | select(.value == true) | .key' "$DIR/.claude/settings.json" 2>/dev/null | tr -d '\r' | sort)
SNAP_OLD=""
[ -f "$PLUGIN_SNAPSHOT" ] && SNAP_OLD=$(tr -d '\r' < "$PLUGIN_SNAPSHOT" 2>/dev/null)
if [ ! -f "$PLUGIN_SNAPSHOT" ] || [ "$SNAP_OLD" != "$SNAP_NEW" ]; then
  mkdir -p "$DIR/Vault/Memory" 2>/dev/null || true
  if printf '%s\n' "$SNAP_NEW" > "$PLUGIN_SNAPSHOT" 2>/dev/null; then
    PLUGIN_GRACE=true
  else
    log_error "could not write .onboarding-plugin-snapshot — plugin checks run without the settings-change grace"
  fi
fi

# Dates come from jq, which is already required, so no GNU/BSD `date` split.
# ISO dates compare correctly as strings. An empty TODAY resolves no snooze.
TODAY=$(jq -rn 'now | strftime("%Y-%m-%d")' 2>/dev/null | tr -d '\r')
SNOOZE_UNTIL=$(jq -rn '(now + 30 * 86400) | strftime("%Y-%m-%d")' 2>/dev/null | tr -d '\r')

# A snooze is {"snoozed_until":"YYYY-MM-DD"} on any tier2_* key: shown once,
# checked again after that date. Only a well-formed date on or after today
# resolves the key; anything malformed counts as unresolved, never hidden.
snooze_active() {              # $1 = a tier2_* flag key
  local s
  [ -n "$TODAY" ] || return 1
  s=$(printf '%s' "$ONBOARDED_JSON" | jq -r --arg k "$1" '.[$k] | if type == "object" and (.snoozed_until | type) == "string" and (.snoozed_until | length) == 10 then .snoozed_until else "" end' 2>/dev/null)
  case "$s" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
    *) return 1 ;;
  esac
  [[ "$s" < "$TODAY" ]] && return 1
  return 0
}

# First run = no flags yet, or any tier1_* key missing (set in the loop).
# Anything else missing is a top-up: one line after the answer, never the
# "First-time setup" flow (plan 139).
FIRST_RUN=false
[ "$(printf '%s' "$ONBOARDED_JSON" | jq -r 'if type == "object" then length else 0 end' 2>/dev/null)" = "0" ] && FIRST_RUN=true

all_complete=true
missing=""
missing_plugins=""             # the tier2_plugin_* subset of $missing
for k in $REQUIRED_KEYS; do
  # An object (a snooze) prints as "{}" here and is read by snooze_active.
  v=$(printf '%s' "$ONBOARDED_JSON" | jq -r --arg k "$k" '.[$k] // false | if type == "object" then "{}" else tostring end' 2>/dev/null)
  case "$k" in
    tier2_plugin_*)
      # Installed always wins, then grace, then "skipped" (the user does not
      # want it — the only escape for a plugin disabled in settings.local.json,
      # which never reaches the record), then a live snooze. A plugin key's
      # `true` counts only when the record is unrecognised: otherwise a stale
      # `true` would hide an uninstalled plugin, the defect plan 128 fixed.
      plugin_key_present "$k" && continue
      [ "$PLUGIN_GRACE" = "true" ] && continue
      [ "$v" = "skipped" ] && continue
      snooze_active "$k" && continue
      [ "$PLUGIN_RECORD_STATE" = "unrecognised" ] && [ "$v" = "true" ] && continue
      all_complete=false
      missing="$missing $k"
      missing_plugins="$missing_plugins $k"
      continue
      ;;
  esac
  if [ "$v" = "true" ]; then
    continue
  fi
  case " $SKIPPABLE_KEYS " in
    *" $k "*) [ "$v" = "skipped" ] && continue ;;
  esac
  case "$k" in
    tier2_*) snooze_active "$k" && continue ;;
    tier1_*) FIRST_RUN=true ;;
  esac
  all_complete=false
  missing="$missing $k"
done

if [ "$all_complete" = "true" ]; then emit_silent; fi

# Plugins are never an agent step: auto mode blocks `claude plugin install`
# through Bash and the agent cannot run /plugin, so an install instruction
# could never complete and re-fired every session (plan 139). The user gets
# the exact /plugin commands instead, built from settings rather than
# hard-coded: a marketplace add wherever extraKnownMarketplaces declares the
# repo, then the install.
PLUGIN_LINE=""
if [ -n "$missing_plugins" ]; then
  n=0
  names=""
  cmds=""
  for k in $missing_plugins; do
    name=$(printf '%s' "${k#tier2_plugin_}" | tr '_' '-')
    pid=$(printf '%s\n' "$ENABLED_IDS" | grep -m1 -e "^$name@" | tr -d '\r')
    [ -n "$pid" ] || pid="$name"
    repo=""
    case "$pid" in
      *@*) repo=$(jq -r --arg m "${pid#*@}" '.extraKnownMarketplaces[$m].source.repo // empty' "$DIR/.claude/settings.json" 2>/dev/null | tr -d '\r') ;;
    esac
    [ -n "$repo" ] && cmds="$cmds; /plugin marketplace add $repo"
    cmds="$cmds; /plugin install $pid"
    names="$names, $name"
    n=$((n + 1))
  done
  PLUGIN_LINE="$n plugin(s) declared in settings aren't installed: ${names#, }. To install, run: ${cmds#; }"
fi

# The top-up ACTION: answer first, then the line(s), then a 30-day snooze on
# every listed key so the line shows once rather than every session.
# $1 = the line(s) to add, $2 = the keys to snooze, $3 = an optional lead-in.
topup_action() {
  printf '%s' "ACTION: ${3}Answer the user's message first and in full. Do not mention setup before the answer. After the answer, add the following, one line each, as written:
$1
Then silently write {\"snoozed_until\":\"$SNOOZE_UNTIL\"} under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys) for each of these keys, so the line shows once and returns after that date: $(printf '%s' "${2# }" | sed 's/ /, /g'). Never install a plugin yourself: the user runs the /plugin commands."
}

if [ "$FIRST_RUN" != "true" ]; then
  # Top-up: every tier1_* key is resolved, so this clone has onboarded before
  # and nothing here is first-time setup. Tier 1 fixes and the migration path
  # are first-run only.
  SETUP_ITEMS=""
  case " $missing " in *" tier2_caveman "*) SETUP_ITEMS="Caveman" ;; esac
  case " $missing " in *" tier2_vscode_git "*) SETUP_ITEMS="${SETUP_ITEMS:+$SETUP_ITEMS / }VS Code settings" ;; esac
  TOPUP_LINES="$PLUGIN_LINE"
  if [ -n "$SETUP_ITEMS" ]; then
    TOPUP_LINES="${TOPUP_LINES:+$TOPUP_LINES
}Setup not finished: $SETUP_ITEMS — run /onboard when convenient."
  fi
  CTX="=== AUTO-ONBOARDING: TOP-UP ===

Missing flags:$missing

$(topup_action "$TOPUP_LINES" "$missing" "")"
  emit_context "$CTX"
fi

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
# Plugin roster on disk — answered by the install check above, from Claude
# Code's install record or the plugin cache. A plugin in neither leaves
# ALL_PLUGINS_INSTALLED false, which costs only a migration early-exit that
# would have been guesswork either way.
[ "$ALL_PLUGINS_INSTALLED" = "true" ] || behavioural_pass=false

# Full early-exit migration path: only when EVERY signal (the whole
# behavioural_pass bundle — git hooks, .env, the personal scratchpad, Node
# and the plugin roster) already passes on disk — matches the "all
# onboarding signals already pass" claim below.
if [ "$behavioural_pass" = "true" ]; then
  CTX="=== AUTO-ONBOARDING: MIGRATION ===

All onboarding signals already pass on disk but Vault/Memory/onboarding-flags.json has no onboarded flags.

ACTION (silent — before responding to user):
1. Read Vault/Memory/onboarding-flags.json (create with {} if absent).
2. Merge in 'onboarded' object with all these keys set true: $NONPLUGIN_KEYS_CSV. Write nothing for the tier2_plugin_* keys: they are read from Claude Code's install state.
3. Write back. Do NOT narrate. Then handle the user's original message normally."
  emit_context "$CTX"
fi

# Known gap in the flag→step map below, left alone deliberately by plan 091:
# tier1_env_copy has the same sample-absent case the tier1_notes_seed clause
# spells out. TIER1_ENV reports "no .env.example found" when the sample is
# missing, and the general set-true-unless-FAILED rule reads as permitting
# true — resolving a key whose copy never happened. Out of scope for plan 091,
# which added the notes clause only; logged here so the next reader finds it
# recorded rather than rediscovering it. Fix both clauses together if either
# is ever revisited.

# Derived step list. The ACTION used to name Steps 3, 7, 8, 9 and 10 (10 was
# the since-removed plannotator binary step) unconditionally, so a session
# missing one plugin flag re-ran all five — the list is now built from
# $missing instead (plan 128). Keep the two clauses in step order: that is
# what makes the list ascending, with no sort. Steps 8 and 9 (the plugins) are
# never derived: the agent cannot install a plugin, so a missing plugin gets
# the /plugin commands in PLUGIN_LINE instead (plan 139). Step 7 is therefore
# the last step the list can hold, and nothing ever waits on Node after it.
# Tier 1 keys add no step — the hook performs them itself (plan 091). Steps
# 10–12 (print the roster, open the Learn guide in a browser, the demo-project
# tour) are never derived: this hook fires while the user is waiting for an
# answer to their own first message, and launching a browser or a long tour
# mid-question is intrusive, so they are left to a manual /onboard and the
# ACTION closes with a one-line pointer at the guide instead (plan 119,
# 04/09/2026).
STEPS=""
case " $missing " in *" tier2_vscode_git "*) STEPS="$STEPS 3" ;; esac
case " $missing " in *" tier1_node "*|*" tier2_caveman "*) STEPS="$STEPS 7" ;; esac
STEPS="${STEPS# }"

# "3 7" → "Steps 3, 7"; "7" → "Step 7"; "" → "". `set --` inside a
# function only rebinds that function's positional parameters.
fmt_steps() {
  set -- $1
  [ "$#" -gt 0 ] || return 0
  if [ "$#" -eq 1 ]; then
    printf 'Step %s' "$1"
  else
    printf 'Steps %s' "$(printf '%s' "$*" | sed 's/ /, /g')"
  fi
}
STEPS_PHRASE=$(fmt_steps "$STEPS")

# Missing plugins close the first-run flow with the same line the top-up shape
# uses, and are snoozed the same way.
PLUGIN_CLOSE=""
if [ -n "$PLUGIN_LINE" ]; then
  PLUGIN_CLOSE="add this line as written:
$PLUGIN_LINE
then silently write {\"snoozed_until\":\"$SNOOZE_UNTIL\"} under 'onboarded' for each of these keys: $(printf '%s' "${missing_plugins# }" | sed 's/ /, /g'). Never install a plugin yourself: the user runs the /plugin commands. Then "
fi

# Three ACTION shapes. When the derived list is empty every missing non-plugin
# key is a Tier 1 key the hook has already performed, so there is nothing to
# run and no reason to tell the user setup is happening — only the flag writes
# remain. If plugins are missing too, the top-up shape carries those writes as
# a silent lead-in, so the /plugin commands still reach the user after the
# answer (plan 139); otherwise the flag writes are the whole ACTION.
if [ -z "$STEPS" ] && [ -n "$PLUGIN_LINE" ]; then
  ACTION=$(topup_action "$PLUGIN_LINE" "$missing_plugins" "First, silently (no narration), apply the flag→step map below to each missing tier1_* key under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys). Then: ")
elif [ -z "$STEPS" ]; then
  ACTION="ACTION (silent — before responding to user): no onboarding steps are outstanding. Every missing flag above is a Tier 1 key this hook performs itself, so only the flag writes remain: apply the flag→step map below and set each missing key under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys). Run no onboard.md step and do NOT narrate. Then handle the user's original message normally."
else
  ACTION="ACTION: Tell user one line: 'First-time setup detected — running onboarding (~1 min). Then I will handle your question.' Then execute the steps in .claude/commands/onboard.md ($STEPS_PHRASE) — those and no others, whatever else that file documents. For each missing non-plugin flag above, complete the matching step and set that key to true under 'onboarded' in Vault/Memory/onboarding-flags.json (read-modify-write, preserve other keys). One-line narration per step ('Caveman ok'). If Node MISSING, follow onboard.md Step 7's Node branch for this platform (never install Node on macOS or Linux), and if Node is still unavailable write tier1_node and tier2_caveman as the string \"skipped\" (never true) — this records Caveman as attempted and deliberately not run, which resolves both keys instead of re-triggering onboarding every session — and note that nothing else is waiting on Node: Caveman is the only step that needs it. Never stop onboarding because Node is missing. On any step failure: one-line warning, continue, do not set that flag. After all attempted, ${PLUGIN_CLOSE}add one line pointing at the onboarding guide — 'Your onboarding guide is at Resources/Learn/index.html; ask me how to use the system any time and I will open it.' — and do not open it now; then pivot to user's original message ('Setup done. On your question: ...')."
fi

CTX="=== AUTO-ONBOARDING TRIGGERED ===

Tier 1 (done by hook): git=$TIER1_GIT; env=$TIER1_ENV; node=$TIER1_NODE; notes=$TIER1_NOTES.
Missing flags:$missing

$ACTION

Flag→step map: tier1_git_hooks/tier1_env_copy/tier1_notes_seed = hook already ran (set true unless the Tier 1 line reports FAILED for that key — for the two copy keys both 'exists' and 'created from ...' set it true); for tier1_notes_seed there is one further case — if the Tier 1 line reports notes=no Notes.example.md found, the tracked sample is missing from a partial pull, so leave the key unset rather than true and the step retries after the next pull; tier1_node = set true iff Node present, else \"skipped\" if the user declines or cannot install it (never true); $PLUGIN_MAP_SEGMENT = no onboard.md step — plugin keys are read from Claude Code's install state; the only values you ever write to one are \"skipped\" (the user does not want it) or a snooze object {\"snoozed_until\":\"YYYY-MM-DD\"}; tier2_caveman = Step 7 + '/caveman lite', or \"skipped\" alongside tier1_node when Node is unavailable; tier2_vscode_git = Step 3."

emit_context "$CTX"
