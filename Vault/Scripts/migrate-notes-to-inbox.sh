#!/usr/bin/env bash
#
# migrate-notes-to-inbox.sh — one-off move of the root Notes/ folder to Inbox/ (plan 179)
#
# Clones made before plan 179 keep their own files in Notes/ (git-ignored).
# This moves every entry under Notes/ to the same path under Inbox/, then
# removes the directories it emptied. Old Notes/ READMEs the template deleted
# can linger as untracked files; they move like anything else.
#
# Safe to re-run: nothing is ever overwritten (mv -n, plus an existence check
# first), a clash is reported and left where it is, and only empty
# directories are removed (rmdir, never rm -rf). Silent when Notes/ is absent.
#
# One exception to "never delete": a .DS_Store that clashes with one already
# in Inbox/ is removed with rm -f. It is Finder metadata, not user content,
# and leaving it would stop Notes/ from ever being emptied. Any other clash,
# dotfiles included, is left in place.
#
# Skips while git still tracks files under Notes/ — that means the template
# update has not been pulled yet, and moving tracked files would dirty the
# tree that update.sh's clean-tree check needs.
#
# Bash 3.2 / Git Bash safe: no arrays, POSIX+BSD/GNU portable.
#
# Usage:
#   bash Vault/Scripts/migrate-notes-to-inbox.sh          exit 1 if anything was left behind
#   bash Vault/Scripts/migrate-notes-to-inbox.sh --hook   always exit 0 (hooks, update.sh)
#   MIGRATE_NOTES_HOOK=1 has the same effect as --hook.

set -u

HOOK="${MIGRATE_NOTES_HOOK:-0}"
[ "${1:-}" = "--hook" ] && HOOK=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SRC="$PROJECT_ROOT/Notes"
DEST="$PROJECT_ROOT/Inbox"

finish() {
  if [ "$HOOK" = "1" ]; then exit 0; fi
  exit "$1"
}

[ -d "$SRC" ] || exit 0

if [ -n "$(git -C "$PROJECT_ROOT" ls-files -- Notes 2>/dev/null)" ]; then
  echo "Notes → Inbox: skipped. Git still tracks files under Notes/, so pull the template update first."
  finish 0
fi

moved=0
clashes=0

# $1 = source dir, $2 = destination dir. Directories that exist on both sides
# are merged entry by entry; everything else moves whole.
move_tree() {
  local entry name target
  if ! mkdir -p "$2" 2>/dev/null; then
    echo "  could not create ${2#$PROJECT_ROOT/}/ — left ${1#$PROJECT_ROOT/}/ in place"
    clashes=$((clashes + 1))
    return
  fi
  for entry in "$1"/* "$1"/.[!.]* "$1"/..?*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    name="${entry##*/}"
    target="$2/$name"
    if [ -d "$entry" ] && [ ! -L "$entry" ] && [ -d "$target" ] && [ ! -L "$target" ]; then
      move_tree "$entry" "$target"
    elif [ -e "$target" ] || [ -L "$target" ]; then
      if [ "$name" = ".DS_Store" ]; then
        # Finder metadata, regenerated on demand — not user content.
        rm -f "$entry"
        continue
      fi
      echo "  clash: ${target#$PROJECT_ROOT/} already exists — left ${entry#$PROJECT_ROOT/} in place"
      clashes=$((clashes + 1))
    elif mv -n "$entry" "$target" 2>/dev/null && [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
      moved=$((moved + 1))
    else
      echo "  could not move ${entry#$PROJECT_ROOT/}"
      clashes=$((clashes + 1))
    fi
  done
}

move_tree "$SRC" "$DEST"

# Remove emptied directories, deepest first. rmdir refuses anything non-empty.
find "$SRC" -depth -type d -exec rmdir {} \; 2>/dev/null

if [ -d "$SRC" ]; then
  echo "Notes → Inbox: moved $moved item(s); $clashes left in Notes/. Sort those out by hand, then re-run this script."
  finish 1
fi
echo "Notes → Inbox: moved $moved item(s); Notes/ removed."
finish 0
