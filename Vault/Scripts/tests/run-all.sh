#!/usr/bin/env bash
#
# run-all.sh — runs every *-tests.sh harness in this directory and tallies.
#
# Each harness owns its own fixtures under mktemp -d and never touches the live
# vault. Output from every harness is printed in full; the last line is the
# tally. Exit 1 if any harness exited non-zero. Bash 3.2 / Git Bash safe.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! bash -n "$SCRIPT_DIR/lib/assert.sh"; then
  echo "FATAL: lib/assert.sh does not parse" >&2
  exit 1
fi

RUN=0
BAD=0
for t in "$SCRIPT_DIR"/*-tests.sh; do
  [ -e "$t" ] || continue
  name="$(basename "$t")"
  echo "=== $name ==="
  bash "$t"
  code=$?
  RUN=$((RUN + 1))
  if [ "$code" -eq 0 ]; then
    echo "ok - $name"
  else
    echo "FAIL - $name (exit $code)"
    BAD=$((BAD + 1))
  fi
  echo ""
done

echo "$RUN harnesses, $BAD failed"
if [ "$BAD" -gt 0 ]; then
  exit 1
fi
exit 0
