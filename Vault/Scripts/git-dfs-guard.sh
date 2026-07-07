#!/usr/bin/env bash
#
# git-dfs-guard.sh — self-healing DFS collision guard
#
# Google-Drive (and similar DFS/cloud-sync) mounts duplicate files under a
# " N" suffix (space + one or more digits) when two processes write the same
# path concurrently, e.g. `advisor 2`, `.mcp 2.json`. Inside `.git/refs` these
# duplicates are invalid ref names (spaces are illegal), so `git fetch` aborts
# with `fatal: bad object refs/remotes/origin/advisor 2/...`. Untracked
# " N" files in the worktree also trip a clean-tree gate.
#
# This script runs two passes and self-no-ops on non-DFS clones.
#
# Pass 1 — junk refs: deletes a " N"-suffixed entry (file OR directory —
#          DFS can duplicate a whole ref directory, e.g.
#          `refs/remotes/origin/advisor 2/`) under the git refs directory
#          ONLY when its twin base entry (same name minus the suffix, in
#          the same parent) also exists.
# Pass 2 — twin duplicates: deletes an untracked " N"-suffixed worktree
#          file ONLY when its twin base file also exists AND the " N" file
#          itself is untracked.
#
# RESIDUAL RISK — READ BEFORE RELYING ON THIS SCRIPT:
#   Pass 2 cannot distinguish a DFS-duplicated file from a legitimately
#   named, untracked file that happens to match the pattern
#   "<base> N.<ext>" when a twin "<base>.<ext>" also exists. Such a file
#   WILL be deleted. This is an accepted trade-off: the pattern is narrow
#   enough (space + digits, twin-must-exist, untracked-only) that false
#   positives are expected to be rare in practice, but it is not zero-risk.
#   Tracked files are never touched — Pass 2 checks
#   `git ls-files --error-unmatch` before deleting anything.
#
# POSIX/bash 3.2 compatible. Portable across macOS BSD `find` and GNU
# `find` — uses only `-type f`/`-type d`, `-mindepth`, and `-print0`, no
# `-printf`.

set -eu

# Work from the repo root so relative paths behave predictably.
toplevel="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "git-dfs-guard: not a git repository — skipping" >&2
    exit 0
}
cd "$toplevel"

junk_count=0
twin_count=0

# ---------------------------------------------------------------------------
# Pass 1 — junk refs
# ---------------------------------------------------------------------------

refs_dir="$(git rev-parse --git-path refs 2>/dev/null)" || refs_dir=""

if [ -n "$refs_dir" ] && [ -d "$refs_dir" ]; then
    # Materialise the full listing (files AND directories, any depth) to a
    # temp file first — NOT a streamed pipe — so that when a matched
    # directory is rm -rf'd mid-loop, entries already queued for its
    # now-deleted children are simply skipped via the `[ -e ]` guard below,
    # rather than racing a still-running `find`.
    refs_list="$(mktemp)"
    trap 'rm -f "$refs_list"' EXIT
    find "$refs_dir" -mindepth 1 \( -type f -o -type d \) -print0 > "$refs_list"

    while IFS= read -r -d '' ref_entry; do
        # Skip entries already removed as part of an ancestor directory
        # deleted earlier in this same loop.
        [ -e "$ref_entry" ] || continue

        base_name="${ref_entry##*/}"
        dir_name="${ref_entry%/*}"

        # Match a trailing " N" suffix (space + one or more digits) on the
        # basename of THIS path component — refs have no file extension to
        # preserve, and the suffix may land on a directory or a leaf file.
        if [[ "$base_name" =~ ^(.+)\ [0-9]+$ ]]; then
            twin_base="${BASH_REMATCH[1]}"
            twin_path="$dir_name/$twin_base"
            if [ -e "$twin_path" ]; then
                rm -rf -- "$ref_entry"
                junk_count=$((junk_count + 1))
            fi
        fi
    done < "$refs_list"

    rm -f "$refs_list"
    trap - EXIT
fi

# ---------------------------------------------------------------------------
# Pass 2 — untracked worktree twin duplicates
# ---------------------------------------------------------------------------

while IFS= read -r -d '' candidate; do
    # Path relative to repo root, stripping the leading "./".
    rel="${candidate#./}"
    base_name="${rel##*/}"
    dir_name="${rel%/*}"
    if [ "$dir_name" = "$rel" ]; then
        dir_name="."
    fi

    # Split basename into stem + extension, splitting on the LAST dot only
    # (never the first — preserves leading-dot dotfiles and multi-dot names).
    case "$base_name" in
        .*)
            case "${base_name#.}" in
                *.*)
                    # Dotfile WITH a further extension, e.g. ".mcp 2.json".
                    ext=".${base_name##*.}"
                    stem="${base_name%.*}"
                    ;;
                *)
                    # Dotfile with only its leading dot, e.g. ".mcp 2" — no
                    # extension to split off.
                    stem="$base_name"
                    ext=""
                    ;;
            esac
            ;;
        *.*)
            ext=".${base_name##*.}"
            stem="${base_name%.*}"
            ;;
        *)
            # No dot at all.
            stem="$base_name"
            ext=""
            ;;
    esac

    # Strip a trailing " N" suffix from the STEM only.
    if [[ "$stem" =~ ^(.+)\ [0-9]+$ ]]; then
        base_stem="${BASH_REMATCH[1]}"
        twin_name="${base_stem}${ext}"
        if [ "$dir_name" = "." ]; then
            twin_path="$twin_name"
        else
            twin_path="$dir_name/$twin_name"
        fi

        if [ -f "$twin_path" ]; then
            # Only delete if the " N" candidate itself is untracked.
            if ! git ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
                rm -f -- "$candidate"
                twin_count=$((twin_count + 1))
            fi
        fi
    fi
done < <(find . \( -path ./.git -prune \) -o -type f -print0)

echo "git-dfs-guard: removed $junk_count junk refs, $twin_count twin duplicates"
