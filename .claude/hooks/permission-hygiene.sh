#!/usr/bin/env bash
# SessionStart hook — report risky or rotting rules in .claude/settings.local.json.
# MUST always exit 0 (non-zero blocks the session).
#
# Report only: never writes to settings.local.json or anywhere else. Silent
# (fail open) when the file is missing, empty or invalid JSON, when jq is
# missing, or when nothing is flagged. The only stdout is one top-level
# {"systemMessage": ...} object: SessionStart's non-JSON stdout becomes model
# context, so everything else goes to /dev/null. Rule text is never printed.
# bash 3.2 safe (macOS): no mapfile, associative arrays or ${var,,}.
# Opt-out: CLAUDE_PERMISSION_HYGIENE=quiet silences every category except
# the maintainer-bypass check. Guidance: Resources/SOPs/Sub-Agent
# Architecture SOP.md § Auto mode and permissions. Plan 142.

set -u

DIR="${CLAUDE_PROJECT_DIR:-.}"
if command -v cygpath >/dev/null 2>&1; then
  DIR=$(cygpath -u "$DIR" 2>/dev/null || echo "$DIR")
fi

LOCAL="$DIR/.claude/settings.local.json"
TRACKED="$DIR/.claude/settings.json"
THRESHOLD=100

[ -s "$LOCAL" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

case "$(uname -s 2>/dev/null)" in
  MINGW*|MSYS*|CYGWIN*) OS=win ;;
  *) OS=posix ;;
esac

# One jq program classifies every rule. Line 1: total, mid-command wildcards,
# broad interpreter/VCS, maintainer bypass, foreign paths, duplicates. Each
# further line is a native `//` path candidate with one leading slash
# stripped (`//c/...` becomes `/c/...` on Windows), cut to the directory
# before the first glob character, for bash to test with [ -e ].
# Regexes use \A and \z so a multi-line rule cannot match on an inner line.
PROG='
def inner: if startswith("Bash(") and endswith(")") then .[5:-1] else null end;
def strip_tail:
  if endswith(" *") or endswith(":*") then .[:-2]
  elif endswith("*") then .[:-1]
  else . end;
def spec:
  if (startswith("Read(") or startswith("Edit(")) and endswith(")") then .[5:-1]
  elif startswith("Write(") and endswith(")") then .[6:-1]
  else null end;
def abspath: spec | if . != null and startswith("//") then .[1:] else null end;
def foreign_abs:
  if $os == "win" then test("\\A/(?:Users|home|Volumes|private)(?:/|\\z)")
  else test("\\A/[A-Za-z](?:/|\\z)") end;
def foreign_bash:
  if $os == "win" then test("(?:\\A|[\\s\"'\''=(])/(?:Users|home|Volumes)/")
  else test("(?:\\A|[^A-Za-z0-9])[A-Za-z]:[\\\\/]") end;
def cut_glob:
  if test("[*?\\[]") then
    (capture("\\A(?<p>[^*?\\[]*)").p | sub("/[^/]*\\z"; "")
     | if . == "" then "/" else . end)
  else . end;
def tools: "python|python3|py|node|bash|sh|zsh|pwsh|powershell|cmd|perl|ruby|php|deno|bun|npx|npm|pnpm|yarn|git|gh|curl|wget|env|xargs|eval|source|sudo";

.permissions.allow as $all
| if ($all | type) != "array" then empty else
  ((try ($tr[0].permissions.allow // []) catch []) | if type == "array" then . else [] end) as $dups
  | [$all[] | select(type == "string")] as $r
  | ($all | length) as $total
  | ([$r[] | inner | select(. != null) | strip_tail | select(contains("*"))] | length) as $mid
  | ([$r[] | select(. == "Bash" or ((inner // "") as $c
        | $c == "*" or ($c | test("\\A(?:" + tools + ")(?: \\*|:\\*|\\*)\\z"))))] | length) as $broad
  | ([$r[] | select(contains("CLAUDE_TEMPLATE_MAINTAINER"))] | length) as $bypass
  | ([$r[] | abspath | select(. != null and foreign_abs)] | length) as $fa
  | ([$r[] | inner | select(. != null and foreign_bash)] | length) as $fb
  | ([$r[] | . as $x | select(any($dups[]; . == $x))] | length) as $dup
  | "\($total) \($mid) \($broad) \($bypass) \($fa + $fb) \($dup)",
    ($r[] | abspath | select(. != null and (foreign_abs | not))
     | cut_glob)
  end
'

if [ -s "$TRACKED" ]; then
  OUT=$(jq -r --arg os "$OS" --slurpfile tr "$TRACKED" "$PROG" "$LOCAL" 2>/dev/null) || exit 0
else
  OUT=$(jq -r --arg os "$OS" --argjson tr '[]' "$PROG" "$LOCAL" 2>/dev/null) || exit 0
fi
[ -n "$OUT" ] || exit 0

CR=$(printf '\r')
FIRST=1
MISSING=0
TOTAL=0 MID=0 BROAD=0 BYPASS=0 FOREIGN=0 DUP=0
while IFS= read -r LINE; do
  LINE=${LINE%"$CR"}
  if [ "$FIRST" = 1 ]; then
    FIRST=0
    set -- $LINE
    [ $# -eq 6 ] || exit 0
    for N in "$@"; do
      case "$N" in ''|*[!0-9]*) exit 0 ;; esac
    done
    TOTAL=$1 MID=$2 BROAD=$3 BYPASS=$4 FOREIGN=$5 DUP=$6
  elif [ -n "$LINE" ] && [ ! -e "$LINE" ]; then
    MISSING=$((MISSING + 1))
  fi
done <<EOF
$OUT
EOF
FOREIGN=$((FOREIGN + MISSING))

OVER=0
[ "$TOTAL" -gt "$THRESHOLD" ] && OVER=1

if [ "${CLAUDE_PERMISSION_HYGIENE:-}" = "quiet" ]; then
  MID=0 BROAD=0 FOREIGN=0 DUP=0 OVER=0
fi

[ $((OVER + MID + BROAD + BYPASS + FOREIGN + DUP)) -gt 0 ] || exit 0

FLAGGED=""
add() {
  # add <count> <singular> <plural>
  [ "$1" -gt 0 ] || return 0
  if [ "$1" -eq 1 ]; then ITEM="1 $2"; else ITEM="$1 $3"; fi
  if [ -z "$FLAGGED" ]; then FLAGGED="$ITEM"; else FLAGGED="$FLAGGED, $ITEM"; fi
}
add "$MID" "mid-command wildcard" "mid-command wildcards"
add "$BROAD" "broad interpreter/VCS rule" "broad interpreter/VCS rules"
add "$BYPASS" "maintainer-bypass rule" "maintainer-bypass rules"
add "$FOREIGN" "foreign or missing path" "foreign or missing paths"
add "$DUP" "duplicate of settings.json" "duplicates of settings.json"

RULES="allow rules"
[ "$TOTAL" -eq 1 ] && RULES="allow rule"
MSG="Permission hygiene: .claude/settings.local.json has $TOTAL $RULES (threshold $THRESHOLD)."
[ -n "$FLAGGED" ] && MSG="$MSG Flagged: $FLAGGED."
MSG="$MSG Review and prune by hand: Resources/SOPs/Sub-Agent Architecture SOP.md § Auto mode and permissions."

jq -n --arg m "$MSG" '{systemMessage: $m}' 2>/dev/null
exit 0
