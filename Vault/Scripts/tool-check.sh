#!/usr/bin/env bash
#
# tool-check.sh — freshness check and installer for vault-dependent external tools
#
# Checks the locally installed plannotator binary against its latest GitHub
# release, and — in `--apply` mode — downloads, checksum-verifies and
# installs the matching asset.
#
# Bash 3.2 / Git Bash safe: no arrays, no `timeout`, no `mapfile`.
# set -u only (not -e) — every failure path gets a controlled message and a
# documented exit code instead of an uncontrolled abort. Never interactive.
#
# Modes:
#   (no args)  print a nudge line only for tools that are behind (hook use).
#              Always exits 0 so a SessionStart hook caller is never blocked
#              by a network hiccup or a missing tool.
#   --force    also print an `up to date` / `not installed` line per tool
#              (freshness report only). Always exits 0, same as no args.
#   --apply    install or update a tool that is missing or behind, then
#              report what happened. The one mode with a real exit table —
#              its caller needs to know which step stopped and why.
#
# Exit codes (--apply only; the other two modes always exit 0):
#   0 up to date, or installed/updated OK
#   1 unexpected failure
#   2 unsupported platform
#   3 release lookup failed (API/parse)
#   4 download failed or too slow (partial staging kept for resume)
#   5 checksum mismatch (staging deleted)
#   6 privileged move needs a password — verified file left at <path> (macOS/Linux)
#   7 replace failed, binary in use — verified file left at <path> (Windows)
#   8 another update in progress (lock held)
#   9 installed plannotator lives outside the directory this script manages
#
# Comparison is string equality, not semver ordering — deliberate: every
# install path always pulls latest, so any mismatch is treated as behind.
#
# Download safety: the asset URL and its `.sha256` sibling are both built
# from the `tag_name` in the API response, never from `/releases/latest/
# download/` — that path can resolve to a different release than the one the
# tag was read from. The downloaded file is hashed locally and the two hex
# strings are compared in bash; no external tool makes the accept/reject
# decision. Nothing is ever piped from a URL into a shell.
#
# Network failure or unparseable API response in the two check-only modes:
# log one line to Vault/Memory/update-check-errors.md and skip that tool
# silently — never surfaced to the user, never a nonzero exit. In `--apply`
# every non-zero path logs the same way *and* reports.

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
  # -L follows redirects: release asset URLs (including the tiny `.sha256`
  # siblings this helper also fetches) answer with a 302 to a CDN host.
  curl -fsSL --max-time 6 -H 'User-Agent: vault-tool-check' "$1" 2>/dev/null
}

hash_file() {
  # $1 = path. Prints the lowercase hex digest, empty when it cannot be read.
  #
  # Hash from stdin, not by filename: GNU coreutils escapes an output line
  # whose filename contains a backslash by prefixing the whole line with one,
  # and every Windows staging path contains backslashes. Reading stdin makes
  # the reported filename `-` and the first field always a bare hex string.
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum < "$1" 2>/dev/null | cut -d' ' -f1 | tr 'A-Z' 'a-z'
  else
    shasum -a 256 < "$1" 2>/dev/null | cut -d' ' -f1 | tr 'A-Z' 'a-z'
  fi
}

apply_fail() {
  # $1 = exit code, $2 = message. One controlled line, one log entry, one code.
  log_error "tool-check --apply: $2"
  printf '%s\n' "$2"
  exit "$1"
}

apply_plannotator() {
  # $1 = release tag, $2 = latest version, $3 = installed version ("" = absent)
  local tag="$1"
  local latest="$2"
  local installed="$3"
  local osname arch asset install_dir install_path staging part tagf lock
  local url expected_raw expected local_hash lock_epoch now newver
  local bin_path bin_dir want_dir

  case "$(uname -m 2>/dev/null || echo '?')" in
    x86_64|amd64)  arch="x64" ;;
    arm64|aarch64) arch="arm64" ;;
    *)             arch="" ;;
  esac
  case "$(uname -s 2>/dev/null || echo '?')" in
    MINGW*|MSYS*|CYGWIN*) osname="win32" ;;
    Darwin)               osname="darwin" ;;
    Linux)                osname="linux" ;;
    *)                    osname="" ;;
  esac
  if [ -z "$osname" ] || [ -z "$arch" ]; then
    apply_fail 2 "plannotator: unsupported platform ($(uname -s 2>/dev/null) $(uname -m 2>/dev/null)) — install manually from https://github.com/backnotprop/plannotator/releases"
  fi

  if [ "$osname" = "win32" ]; then
    asset="plannotator-win32-$arch.exe"
    if [ -z "${LOCALAPPDATA:-}" ]; then
      apply_fail 2 "plannotator: LOCALAPPDATA is not set — cannot resolve the Windows install directory."
    fi
    install_dir="$LOCALAPPDATA/plannotator"
    install_path="$install_dir/plannotator.exe"
    # Same filesystem as the install path, so the final move is atomic.
    staging="$install_dir"
  else
    asset="plannotator-$osname-$arch"
    install_dir="/usr/local/bin"
    install_path="$install_dir/plannotator"
    # /usr/local/bin is not user-writable; stage in $HOME and move with sudo -n.
    staging="$HOME/.plannotator/staging"
  fi

  if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
    apply_fail 1 "plannotator: no checksum tool available (need sha256sum or shasum) — refusing to install unverified."
  fi

  # Only manage the copy this script installed. `command -v plannotator` can
  # resolve to a Homebrew build, the upstream installer's copy, or anything
  # else on PATH. Installing over the top of one of those leaves the PATH
  # copy stale, so the version check reads "behind" again tomorrow and every
  # day after — a download and a sudo attempt each time. Compare physical
  # paths so Windows mixed-form paths and symlinked directories agree.
  if [ -n "$PLANNOTATOR_BIN" ]; then
    if [ "$PLANNOTATOR_BIN" = "plannotator" ]; then
      bin_path="$(command -v plannotator 2>/dev/null)"
    else
      bin_path="$PLANNOTATOR_BIN"
    fi
    bin_dir="$(cd "$(dirname "$bin_path")" 2>/dev/null && pwd -P)"
    want_dir="$(cd "$install_dir" 2>/dev/null && pwd -P)"
    if [ -z "$want_dir" ]; then
      want_dir="$(cd "$(dirname "$install_dir")" 2>/dev/null && pwd -P)/$(basename "$install_dir")"
    fi
    if [ -n "$bin_dir" ] && [ -n "$want_dir" ] && [ "$bin_dir" != "$want_dir" ]; then
      apply_fail 9 "plannotator: the copy on your PATH is at $bin_path, which this vault does not manage (it installs to $install_path). Update it the way it was installed."
    fi
  fi

  mkdir -p "$staging" 2>/dev/null
  if [ ! -d "$staging" ]; then
    apply_fail 1 "plannotator: could not create the staging directory $staging"
  fi

  part="$staging/$asset.part"
  tagf="$staging/$asset.tag"
  lock="$staging/.update.lock"

  # Single-writer lock. noclobber makes the create-or-fail atomic; a lock
  # older than an hour is treated as abandoned (a session killed mid-download
  # leaves one behind) and taken over.
  if ! ( set -o noclobber; printf 'pid=%s\nepoch=%s\n' "$$" "$(date +%s 2>/dev/null || echo 0)" > "$lock" ) 2>/dev/null; then
    lock_epoch="$(sed -n 's/^epoch=//p' "$lock" 2>/dev/null | head -1)"
    [ -z "$lock_epoch" ] && lock_epoch=0
    now="$(date +%s 2>/dev/null || echo 0)"
    if [ "$((now - lock_epoch))" -lt 3600 ]; then
      apply_fail 8 "plannotator: another update is already running (lock held at $lock) — skipping this one."
    fi
    rm -f "$lock" 2>/dev/null
    if ! ( set -o noclobber; printf 'pid=%s\nepoch=%s\n' "$$" "$(date +%s 2>/dev/null || echo 0)" > "$lock" ) 2>/dev/null; then
      apply_fail 8 "plannotator: could not take over the stale update lock at $lock — skipping this one."
    fi
  fi
  trap 'rm -f "$lock" 2>/dev/null' EXIT INT TERM

  # A partial download from an older release is worthless — resuming into it
  # would splice two different binaries together.
  if [ -f "$part" ] && [ "$(cat "$tagf" 2>/dev/null)" != "$tag" ]; then
    rm -f "$part" "$tagf" 2>/dev/null
  fi
  printf '%s\n' "$tag" > "$tagf" 2>/dev/null

  url="https://github.com/backnotprop/plannotator/releases/download/$tag/$asset"

  # Published checksum first, before any transfer decision — everything
  # below branches on it. A complete staging file is proved good by hashing
  # it, never by asking curl whether a resume is a no-op: curl only reports
  # "already complete" by special-casing an HTTP 416, and versions before
  # 7.86 fail that 416 under -f (Ubuntu 22.04 ships 7.81, as do older macOS
  # builds). Relying on it would turn a verified file kept by an earlier
  # exit 6 or 7 into an exit 4 every day, forever.
  expected_raw="$(fetch "$url.sha256")"
  expected="$(printf '%s' "$expected_raw" | head -1 | cut -d' ' -f1 | tr 'A-Z' 'a-z')"
  case "$expected" in
    ????????????????????????????????????????????????????????????????) : ;;
    *) apply_fail 4 "plannotator: could not read the published checksum ($url.sha256) — nothing installed." ;;
  esac

  # A complete, correct staging file skips the network entirely.
  local_hash=""
  [ -f "$part" ] && local_hash="$(hash_file "$part")"

  if [ "$local_hash" != "$expected" ]; then
    # -C - resumes a genuinely partial file. The speed floor aborts a
    # stalled transfer long before --max-time would.
    if ! curl -fsSL -C - --max-time 180 --speed-limit 51200 --speed-time 30 -o "$part" "$url" 2>/dev/null; then
      apply_fail 4 "plannotator: download failed or stalled ($url) — partial file kept at $part for resume."
    fi

    # Verify again after the transfer, so nothing is ever placed unverified.
    # The comparison itself is bash, not the checksum tool's own -c mode:
    # the accept/reject decision stays in this script.
    local_hash="$(hash_file "$part")"
    if [ "$local_hash" != "$expected" ]; then
      rm -f "$part" "$tagf" 2>/dev/null
      apply_fail 5 "plannotator: checksum mismatch for $asset ($tag) — download deleted, nothing installed."
    fi
  fi

  if [ "$osname" = "win32" ]; then
    chmod +x "$part" 2>/dev/null
    if ! mv -f "$part" "$install_path" 2>/dev/null; then
      apply_fail 7 "plannotator: could not replace $install_path — the binary is probably running. Verified file is at $part; close plannotator and re-run, or move it there yourself."
    fi
  else
    # sudo -n never prompts: it uses a cached credential or fails at once,
    # which is what keeps this step safe to run unattended.
    if ! { sudo -n cp "$part" "$install_dir/.plannotator.tmp" 2>/dev/null \
        && sudo -n chmod 0755 "$install_dir/.plannotator.tmp" 2>/dev/null \
        && sudo -n mv "$install_dir/.plannotator.tmp" "$install_path" 2>/dev/null; }; then
      sudo -n rm -f "$install_dir/.plannotator.tmp" 2>/dev/null
      apply_fail 6 "plannotator: installing needs a password, so it was left for you. Verified file is at $part — finish with: sudo install -m 0755 '$part' '$install_path'"
    fi
  fi

  newver="$(printf '%s' "$("$install_path" --version 2>/dev/null)" | sed 's/^plannotator[[:space:]]*//')"
  [ -z "$newver" ] && newver="$latest"
  if [ -n "$installed" ]; then
    printf 'plannotator updated %s → %s\n' "$installed" "$newver"
  else
    printf 'plannotator installed %s\n' "$newver"
  fi
  rm -f "$part" "$tagf" 2>/dev/null
  exit 0
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

PLANNOTATOR_VER=""
if [ -n "$PLANNOTATOR_BIN" ]; then
  PLANNOTATOR_RAW="$("$PLANNOTATOR_BIN" --version 2>/dev/null)"
  PLANNOTATOR_VER="$(printf '%s' "$PLANNOTATOR_RAW" | sed 's/^plannotator[[:space:]]*//')"
fi

# Nothing installed and nothing to install: report per mode and stop before
# spending a network call.
if [ -z "$PLANNOTATOR_BIN" ] && [ "$MODE" != "--apply" ]; then
  [ "$MODE" = "--force" ] && printf 'plannotator: not installed\n'
  exit 0
fi

PLANNOTATOR_JSON="$(fetch 'https://api.github.com/repos/backnotprop/plannotator/releases/latest')"
if [ -z "$PLANNOTATOR_JSON" ]; then
  log_error "tool-check: plannotator — GitHub API fetch failed"
  [ "$MODE" = "--apply" ] && apply_fail 3 "plannotator: could not reach the GitHub releases API — nothing installed."
else
  LATEST_TAG="$(printf '%s' "$PLANNOTATOR_JSON" | grep -Eo '"tag_name": *"[^"]+"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"
  if [ -z "$LATEST_TAG" ]; then
    log_error "tool-check: plannotator — could not parse tag_name from GitHub API response"
    [ "$MODE" = "--apply" ] && apply_fail 3 "plannotator: could not read a release tag from the GitHub API response — nothing installed."
  else
    LATEST_VER="${LATEST_TAG#v}"
    if [ -n "$PLANNOTATOR_BIN" ] && [ "$PLANNOTATOR_VER" = "$LATEST_VER" ]; then
      case "$MODE" in
        --force|--apply) printf 'plannotator: up to date (%s)\n' "$PLANNOTATOR_VER" ;;
      esac
    elif [ "$MODE" = "--apply" ]; then
      apply_plannotator "$LATEST_TAG" "$LATEST_VER" "$PLANNOTATOR_VER"
    else
      printf 'plannotator update available (installed %s, latest %s). Run /update to apply it (checksum-verified download).\n' "$PLANNOTATOR_VER" "$LATEST_VER"
    fi
  fi
fi

exit 0
