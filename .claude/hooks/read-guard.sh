#!/usr/bin/env bash
# read-guard.sh — PreToolUse hook (matcher: Read|Grep|Glob).
# Blocks unbounded Read calls on files over LIMIT lines; bounded reads
# (any `offset` or `limit` in the tool input) always pass, so
# Edit-prerequisite reads of large files still work via offset/limit.
# The line-limit guard applies to Read alone — Grep and Glob are otherwise
# unrestricted by it, since a large file must stay searchable and globbable.
# Also blocks Read, Grep and Glob calls that target .env* or .mcp.json
# material — Grep and Glob are otherwise allowed unconditionally, so without
# this check Grep's content mode can return secret values the Read-only deny
# rules never see, and Glob can enumerate secret paths outright. All three
# branches classify on whole PATH COMPONENTS, case-insensitively, via one
# shared `classify_path` function, rather than each branch running its own
# pattern — that drift (Read matching basename only, Grep matching a bare
# substring) is what let `secrets/.env.d/keys.txt` through the Read branch
# and blocked `mail.envelope.json` on the Grep branch. `.env.example` and
# `.mcp.json.example` are exempt (exact basename match, checked first in
# `classify_path`) — both are git-tracked, secrets-free, and onboarding
# directs users/agents to copy and fill them. Exit 2 blocks the tool call
# and feeds stderr back to Claude as guidance.
# Ported from cc-token-demos/block-huge-reads (Python original), adapted
# to bash+jq for consistency with this repo's other hooks, with the
# offset/limit pass-through and a 1000-line threshold per Odin's checkpoint
# amendments. Grep .env* guard added per 2026-07-06 drift audit; component
# matching, case-insensitivity, and the Glob branch added by plan 056.
#
# Degraded no-jq path (below) is the ONLY fail-open branch in this file —
# it always ends in its own `exit 0` inside the `if`. There is deliberately
# no second fail-open check after it; jq is a declared repo prerequisite,
# so once jq is confirmed present every path below runs the full,
# parser-based classifier and never falls open again.

LIMIT=1000

INPUT=$(cat)

# Degraded no-jq path: jq is required to parse tool_name/tool_input below,
# so without it we cannot reliably tell Read from Grep/Glob apart, let alone
# extract path/glob/pattern/file_path values — but the secret-file guard
# below is this hook's whole reason for existing, and letting it fail open
# on a jq-less machine would defeat it silently. Fall back to a conservative
# raw-string substring check on the still-unparsed JSON: only ever blocks,
# never lets a false positive brick a legitimate call. For `path`/`file_path`
# the pattern anchors on both the JSON field-name prefix (`"path":"`,
# `"file_path":"`) AND the terminal quote immediately after `.env` — this
# catches an exact `.env` value but deliberately misses suffixed variants
# like `.env.local`/`.env.production`, and won't match an unrelated value
# that merely contains `.env` as a substring (e.g. `mail.envelope.json`,
# `config.environment.md`). The `glob`/`pattern` fields are looser (no
# terminal-quote anchor, since glob values are patterns rather than exact
# filenames) and the `.mcp.json` patterns are terminal-anchored on the
# filename itself for `path`/`file_path`. `pattern` (Glob's field) is
# checked alongside `glob` (Grep's field) in both the env and mcp blocks —
# its absence here previously let a jq-less machine pass a Glob call
# targeting `.env`/`.mcp.json` straight through, despite the matcher having
# widened to admit Glob. Suffixed `.env*` variants slipping past the
# `path`/`file_path` check, plus any escaped characters or unusual key
# ordering in the raw JSON, are an accepted false-negative tolerance in this
# degraded path only; this block is defence-in-depth, not the primary layer
# (that's the jq-based checks below, which run whenever jq exists).
if ! command -v jq >/dev/null 2>&1; then
    # .env.example / .mcp.json.example exemption — checked first, same
    # ordering rationale as the jq path's exemptions further down.
    case "$INPUT" in
        *'.env.example"'*|*'.mcp.json.example"'*) exit 0 ;;
    esac
    case "$INPUT" in
        *'"path":"'*'.env"'*|*'"file_path":"'*'.env"'*|*'"glob":"'*'.env'*|*'"pattern":"'*'.env'*)
            echo "BLOCKED: degraded no-jq check — raw tool input references a .env* path/glob/pattern; jq is unavailable so this is a conservative substring block rather than the primary parser-based check. (.env.example is the readable exception.)" >&2
            exit 2
            ;;
    esac
    case "$INPUT" in
        *'"path":"'*'.mcp.json"'*|*'"file_path":"'*'.mcp.json"'*|*'"glob":"'*'.mcp.json'*|*'"pattern":"'*'.mcp.json'*)
            echo "BLOCKED: degraded no-jq check — raw tool input references .mcp.json; jq is unavailable so this is a conservative substring block rather than the primary parser-based check. (.mcp.json.example is the readable exception.)" >&2
            exit 2
            ;;
    esac
    exit 0
fi

# Classify a path as secret-bearing. Echoes one of: env | mcp | "" (safe).
# Case-insensitive, and matches on whole path COMPONENTS rather than a bare
# substring, so:
#   .env, .env.local, .ENV                      -> env   (filename)
#   secrets/.env.d/keys.txt                     -> env   (directory component)
#   **/.env*  (a glob pattern, not a path)      -> env   (component starts .env)
#   .env.example, .mcp.json.example             -> ""    (exempt, git-tracked)
#   mail.envelope.json, config.environment.md   -> ""    (NOT a component match)
#   .environment                                -> ""    (.env not followed by . or *)
# The mail.envelope.json line is load-bearing: the old *.env* substring form
# blocked it, which is the false positive PR #238's reviewer rejected.
# Component matching is the fix for every branch at once.
#
# $2 selects match mode: "path" (default) for file-path fields, or "glob" for
# glob/pattern fields (Grep's glob, Glob's pattern). Glob mode additionally
# matches a wildcard-PREFIXED component for both kinds (*.env, *.env.local,
# *.mcp.json, ...) — a glob value of literally "*.env*" or "*.mcp.json*"
# splits to one component beginning with "*", not ".env"/".mcp.json", and
# would otherwise fail open on exactly the pattern this hook exists to catch
# (it was blocked by the old substring form). That alternate is glob-mode
# only: applying it to a plain file-path component would reintroduce the
# mail.envelope.json false positive.
#
# Known residual, not fixed here: a wildcard INSIDE a component (Grep glob
# `.en*`, Glob pattern `**/.en*`) evades literal component matching while
# still matching `.env` at the filesystem. Pre-existing class, not a
# regression introduced by this change — logged alongside the symlink and
# degraded-path fail-open findings.
#
# Windows silently strips trailing whitespace when resolving a path
# component, so a Read of ".env " (trailing space) reaches the real .env
# file even though the literal string doesn't match. Trim trailing
# whitespace before classifying so the check sees what the filesystem sees.
# The trim is a native `case` loop, not `sed` — an external tool that is
# missing or fails would make the command substitution yield empty, and
# `[ -n "$_p" ] || return 0` would then classify every path as safe. That is
# the same class of fail-open Odin rejected in plan 057; the two pre-existing
# `tr` calls below carry the same theoretical risk but were approved as-is
# at Checkpoint A and are a separate logged finding, not this fix's job.
#
# A caller that omits $2 silently gets "path" mode (no wildcard-prefixed
# match). That is deliberate default-safe behaviour, not a gap to paper
# over — inverting the default so an omitted $2 became "glob" would
# reintroduce the mail.envelope.json false positive on every plain
# file-path field. A future call site that forgets to pass "glob" for a
# glob/pattern field degrades silently to path-only matching; there is no
# mechanical guard against that, only this comment and code review.
classify_path() {
    _p=$(printf '%s' "${1:-}" | tr '\\' '/' | tr '[:upper:]' '[:lower:]')
    while :; do
        case "$_p" in
            *[[:space:]]) _p=${_p%?} ;;
            *) break ;;
        esac
    done
    _mode=${2:-path}
    [ -n "$_p" ] || return 0
    # Exempt the tracked example files by their own basename, before anything else.
    case "${_p##*/}" in
        .env.example|.mcp.json.example) return 0 ;;
    esac
    # set -f disables pathname expansion for the split below. Without it, a
    # component like `*.md` would glob against the current directory and the
    # loop would iterate real filenames instead of the path's own components.
    # This function is called on attacker-influenced input; it must not touch
    # the filesystem at all.
    _oldifs=$IFS
    set -f
    IFS='/'
    for _c in $_p; do
        case "$_c" in
            # `.env` exactly, or `.env` followed by `.` (.env.local, .env.d) or
            # by `*` (the glob-pattern form `**/.env*`). The [.*] bracket is what
            # keeps `.environment` out — `.env` there is followed by `i`.
            .env|.env[.*]*)     IFS=$_oldifs; set +f; printf 'env'; return 0 ;;
            .mcp.json|.mcp.json[.*]*) IFS=$_oldifs; set +f; printf 'mcp'; return 0 ;;
        esac
        if [ "$_mode" = "glob" ]; then
            case "$_c" in
                *.env|*.env[.*]*) IFS=$_oldifs; set +f; printf 'env'; return 0 ;;
                *.mcp.json|*.mcp.json[.*]*) IFS=$_oldifs; set +f; printf 'mcp'; return 0 ;;
            esac
        fi
    done
    IFS=$_oldifs
    set +f
    return 0
}

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

if [ "$TOOL_NAME" = "Grep" ]; then
    GREP_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.path // empty' 2>/dev/null)
    GREP_GLOB=$(printf '%s' "$INPUT" | jq -r '.tool_input.glob // empty' 2>/dev/null)
    # Secret-file guard for Grep. Full-path component match via classify_path
    # on both fields — the old substring form on $GREP_PATH/$GREP_GLOB
    # blocked mail.envelope.json (a false positive) and missed nested
    # components like secrets/.env.d/keys.txt (a false negative).
    case "$(classify_path "$GREP_PATH")" in
        env) echo "BLOCKED: Grep path '$GREP_PATH' matches .env material — secrets must not be searched this way. (.env.example is the readable exception.)" >&2; exit 2 ;;
        mcp) echo "BLOCKED: Grep path '$GREP_PATH' matches .mcp.json — may hold inline MCP server secrets. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
    esac
    case "$(classify_path "$GREP_GLOB" glob)" in
        env) echo "BLOCKED: Grep glob '$GREP_GLOB' matches .env material — secrets must not be searched this way. (.env.example is the readable exception.)" >&2; exit 2 ;;
        mcp) echo "BLOCKED: Grep glob '$GREP_GLOB' matches .mcp.json — may hold inline MCP server secrets. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
    esac
    exit 0
fi

if [ "$TOOL_NAME" = "Glob" ]; then
    GLOB_PATTERN=$(printf '%s' "$INPUT" | jq -r '.tool_input.pattern // empty' 2>/dev/null)
    GLOB_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.path // empty' 2>/dev/null)
    case "$(classify_path "$GLOB_PATTERN" glob)" in
        env) echo "BLOCKED: Glob pattern '$GLOB_PATTERN' enumerates .env material. (.env.example is the readable exception.)" >&2; exit 2 ;;
        mcp) echo "BLOCKED: Glob pattern '$GLOB_PATTERN' enumerates .mcp.json. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
    esac
    case "$(classify_path "$GLOB_PATH")" in
        env) echo "BLOCKED: Glob path '$GLOB_PATH' enumerates .env material. (.env.example is the readable exception.)" >&2; exit 2 ;;
        mcp) echo "BLOCKED: Glob path '$GLOB_PATH' enumerates .mcp.json. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
    esac
    exit 0
fi

# Line-limit guard applies to Read alone. A >LIMIT-line file must stay editable
# and globbable; only an unbounded READ of it is the problem.
[ "$TOOL_NAME" = "Read" ] || exit 0

FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -n "$FILE_PATH" ] || exit 0

# Secret-file guard for Read. Full-path component match via classify_path —
# the old basename-only form let secrets/.env.d/keys.txt through, because its
# basename is keys.txt.
case "$(classify_path "$FILE_PATH")" in
    env) echo "BLOCKED: $FILE_PATH targets .env material — secrets must not be read this way. (.env.example is the readable exception.)" >&2; exit 2 ;;
    mcp) echo "BLOCKED: $FILE_PATH targets .mcp.json — may hold inline MCP server secrets. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
esac

# Bounded read (offset or limit supplied) → pass
BOUNDED=$(printf '%s' "$INPUT" | jq -r '(.tool_input.offset // .tool_input.limit) // empty' 2>/dev/null)
[ -n "$BOUNDED" ] && exit 0

# Normalise Windows path for Git Bash if needed
if command -v cygpath >/dev/null 2>&1 && printf '%s' "$FILE_PATH" | grep -q '^[A-Za-z]:'; then
    FILE_PATH=$(cygpath -u "$FILE_PATH")
fi

# Unreadable/missing → pass; let the Read tool produce its own error
[ -f "$FILE_PATH" ] && [ -r "$FILE_PATH" ] || exit 0

LINES=$(wc -l < "$FILE_PATH" 2>/dev/null | tr -d '[:space:]')
case "$LINES" in ''|*[!0-9]*) exit 0 ;; esac

if [ "$LINES" -gt "$LIMIT" ]; then
    echo "BLOCKED: $(basename "$FILE_PATH") is $LINES lines (unbounded-read limit $LIMIT). Re-read with offset/limit for the section you need, use Grep to locate it, or use ctx_execute_file to derive the answer in the sandbox." >&2
    exit 2
fi

exit 0
