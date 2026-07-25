#!/usr/bin/env bash
# read-guard.sh — PreToolUse hook (matcher: Read|Grep).
# Blocks unbounded Read calls on files over LIMIT lines; bounded reads
# (any `offset` or `limit` in the tool input) always pass, so
# Edit-prerequisite reads of large files still work via offset/limit.
# Also blocks Grep calls whose `path` or `glob` targets a .env* file —
# Grep is otherwise allowed unconditionally, so without this check its
# content mode can return secret values that the Read-only deny rules
# never see. `.env.example` is exempt (exact basename match, checked
# before the .env* block) — it is git-tracked, secrets-free, and
# onboarding directs users/agents to copy and fill it. Exit 2 blocks
# the tool call and feeds stderr back to Claude as guidance.
# The same guard also covers .mcp.json (may hold inline MCP server
# secrets), exempting .mcp.json.example for the same reason.
# Ported from cc-token-demos/block-huge-reads (Python original), adapted
# to bash+jq for consistency with this repo's other hooks, with the
# offset/limit pass-through and a 1000-line threshold per Odin's
# checkpoint amendments. Grep .env* guard added per 2026-07-06 drift audit.

LIMIT=1000

INPUT=$(cat)

# Degraded no-jq path: jq is required to parse tool_name/tool_input below,
# so without it we cannot reliably tell Read from Grep, let alone extract
# path/glob/file_path values — but the Grep .env*/.mcp.json guard below is
# this hook's whole reason for existing, and letting it fail open on a
# jq-less machine would defeat it silently. Fall back to a conservative
# raw-string substring check on the still-unparsed JSON: only ever blocks,
# never lets a false positive brick a legitimate call. Anchored on the
# JSON field-name prefix (`"path":"`, `"file_path":"`, `"glob":"`) plus
# the `.env`/`.mcp.json` substring, so an unrelated path containing letters
# that merely look similar (e.g. `dotenv-guide.md`, no literal dot before
# "env") won't match. Escaped characters or unusual key ordering in the
# raw JSON can still slip past this — an accepted false-negative in the
# degraded path only; this block is defence-in-depth, not the primary
# layer (that's the jq-based checks below, which run whenever jq exists).
if ! command -v jq >/dev/null 2>&1; then
    # .env.example / .mcp.json.example exemption — checked first, same
    # ordering rationale as the jq path's exemptions further down.
    case "$INPUT" in
        *'.env.example"'*|*'.mcp.json.example"'*) exit 0 ;;
    esac
    case "$INPUT" in
        *'"path":"'*'.env'*'"'*|*'"file_path":"'*'.env'*'"'*|*'"glob":"'*'.env'*)
            echo "BLOCKED: degraded no-jq check — raw tool input references a .env* path/glob; jq is unavailable so this is a conservative substring block rather than the primary parser-based check. (.env.example is the readable exception.)" >&2
            exit 2
            ;;
    esac
    case "$INPUT" in
        *'"path":"'*'.mcp.json"'*|*'"file_path":"'*'.mcp.json"'*|*'"glob":"'*'.mcp.json'*)
            echo "BLOCKED: degraded no-jq check — raw tool input references .mcp.json; jq is unavailable so this is a conservative substring block rather than the primary parser-based check. (.mcp.json.example is the readable exception.)" >&2
            exit 2
            ;;
    esac
    exit 0
fi

# jq missing → fail open (never brick the Read tool over a dependency)
command -v jq >/dev/null 2>&1 || exit 0

TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

if [ "$TOOL_NAME" = "Grep" ]; then
    GREP_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.path // empty' 2>/dev/null)
    GREP_GLOB=$(printf '%s' "$INPUT" | jq -r '.tool_input.glob // empty' 2>/dev/null)
    # .env.example exemption — checked before the broad .env* block
    case "$(basename "$GREP_PATH" 2>/dev/null)" in .env.example) exit 0 ;; esac
    case "$GREP_GLOB" in .env.example|*/.env.example) exit 0 ;; esac
    # .mcp.json.example exemption — checked before the .mcp.json block
    case "$(basename "$GREP_PATH" 2>/dev/null)" in .mcp.json.example) exit 0 ;; esac
    case "$GREP_GLOB" in .mcp.json.example|*/.mcp.json.example) exit 0 ;; esac
    case "$GREP_PATH" in *.env*) echo "BLOCKED: Grep path targets a .env* file — secrets must not be searched or read this way. (.env.example is the readable exception.)" >&2; exit 2 ;; esac
    case "$GREP_GLOB" in *.env*) echo "BLOCKED: Grep glob targets .env* files — secrets must not be searched or read this way. (.env.example is the readable exception.)" >&2; exit 2 ;; esac
    case "$(basename "$GREP_PATH" 2>/dev/null)" in .mcp.json) echo "BLOCKED: Grep path targets .mcp.json — may hold inline MCP server secrets; must not be searched this way. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;; esac
    case "$GREP_GLOB" in .mcp.json|*/.mcp.json|*.mcp.json) echo "BLOCKED: Grep glob targets .mcp.json — may hold inline MCP server secrets; must not be searched this way. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;; esac
    exit 0
fi

FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -n "$FILE_PATH" ] || exit 0

# .env.example exemption for Read — checked before the broad .env* block
case "$(basename "$FILE_PATH" 2>/dev/null)" in
    .env.example) exit 0 ;;
    .env*) echo "BLOCKED: $(basename "$FILE_PATH") matches .env* — secrets must not be read this way. (.env.example is the readable exception.)" >&2; exit 2 ;;
    .mcp.json.example) exit 0 ;;
    .mcp.json) echo "BLOCKED: .mcp.json may hold inline MCP server secrets — must not be read this way. (.mcp.json.example is the readable exception.)" >&2; exit 2 ;;
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
