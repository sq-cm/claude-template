#!/usr/bin/env bash
# redact-regression.sh — manual regression check for redact() in
# .claude/hooks/capture-log.sh (plan 199).
#
#   bash Vault/Scripts/tests/redact-regression.sh
#   bash Vault/Scripts/tests/redact-regression.sh --exhaustive <git-ref>
#
# Run it by hand from the repo root after any change to redact(). It is not
# wired to a hook or to validate.sh: PR #328 removed the general test harness,
# and this one file is the maintainer's exception for redact() alone.
#
# Default run: feeds the sample lines below through redact() and compares the
# result with the expected lines, once with the system sed and once with GNU
# sed when a second sed is installed (gsed), then times four long lines.
# --exhaustive <git-ref>: also generates about 1.16 million lines and checks
# that the current redact() never shows more of a secret than the redact() at
# <git-ref> does. Needs python3; takes about a minute.
#
# Every sample value is a dummy. Never paste a real key into this file.
# Exit codes: 0 pass, 1 a check failed, 2 the check could not run.
#
# Bash 3.2 / Git Bash safe: no arrays, no `timeout`, POSIX+BSD/GNU portable.

set -u

HOOK="${REDACT_HOOK:-.claude/hooks/capture-log.sh}"
REF=""
if [ "${1:-}" = "--exhaustive" ]; then
  REF="${2:-}"
  [ -n "$REF" ] || { echo "usage: redact-regression.sh [--exhaustive <git-ref>]"; exit 2; }
elif [ -n "${1:-}" ]; then
  echo "usage: redact-regression.sh [--exhaustive <git-ref>]"; exit 2
fi
[ -f "$HOOK" ] || { echo "Cannot find $HOOK. Run this from the repo root."; exit 2; }

T=$(mktemp -d "${TMPDIR:-/tmp}/redact-regression.XXXXXX") || exit 2
trap 'rm -rf "$T"' EXIT

sed -n '/^redact() {/,/^}/p' "$HOOK" > "$T/fn.sh"
[ -s "$T/fn.sh" ] || { echo "No redact() function found in $HOOK."; exit 2; }

# Sample lines. Rows 1-30 are the plan 193/194 table, 31-37 the older token
# rules and backslash values, 38-63 the plan 199 shapes, 64-77 harmless lines
# that must come out unchanged.
cat > "$T/in.txt" <<'IN'
password="abcdefgh'TAILTAIL99" after
token: "abcdefghij\"TAILTAIL99" after
password="my pass phrase TAILTAIL99" after
secret='two words TAILTAIL99' after
password="unterminated TAILTAIL99
{"client_secret": "abcdefghij1234567890","user":"bob"}
export CMD="password=abcdefghij1234567890"
secret: abcdefghij1234567890"quoted after"
token="abcdefghij1234" api_key="zyxwvutsrq9876" end
API_KEY=abcdefghij1234567890 tail
password="short7" x
token="abcdefgh\\" api_key="zyxwvutsrq9876" end
console.log("token:", t); password = "abcdefghij1234";
password="mylongword phrase TAILTAIL99" after
x("token:", t); password = "my long pass phrase"
{"token":"abcdefgh1234"}
password='abcdefgh"x' y
password=***starsecret99 z
token="my_secret = password="TAILTAIL99 x
secret="token="abcdefgh"password="TAILTAIL99 x
print('api_key:', k); token = 'spaced secret value'
x("token:", t); password = "my long pass phrase
print('api_key:', k); token = 'spaced secret value
secret = password="my long pass phrase"
token: password = 'spaced secret value'
x("token:", t); password = "it's my long pass phrase"
x("token:", t); password = "my \"long\" pass phrase"
print('api_key:', k); token = 'say "hi" to everyone'
x('token:', t); password = "it's Bob's long pass phrase"
secret = password="my \"long\" pass phrase"
key sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
key ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
Authorization: Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
jwt eyJxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
password="\a\b\c\d" x
secret='C:\k\e\y' x
password="abcdefg\
DATABASE_URL=postgres://dbuser:TAILTAIL99pw@db.example.com:5432/app
curl -u admin:TAILTAIL99pw https://example.com/api
curl --user "admin:TAILTAIL99pw" https://example.com
Authorization: Basic xxxxxxxxxxxxxxxxxxxxxxxx==
{"Authorization": "Basic xxxxxxxxxxxxxxxxxxxxxxxx"}
key glpat-xxxxxxxxxxxxxxxxxxxxxxxxxx end
key hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
key npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx end
Authorization: Bearer hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx TAILTAIL99pw
Authorization: Bearer npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx TAILTAIL99pw
Authorization: Bearer glpat-xxxxxxxxxxxxxxxxxxxxxxxx TAILTAIL99pw
https://hooks.slack.com/services/T0/B0/token=abcdefghij1234
glpat-xxxxxxxxxxxxxxxxxxxx_token=abcdefghij1234
npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxtoken=abcdefghij1234
https://hooks.slack.com/services/T0000/B0000/xxxxxxxxxxxx
DefaultEndpointsProtocol=https;AccountName=acct;AccountKey=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx==;EndpointSuffix=core.windows.net
secret => "TAILTAIL99pw"
'password' => 'TAILTAIL99pw',
passphrase: TAILTAIL99pw
private_key: "TAILTAIL99pw"
auth_key=TAILTAIL99pw
access_key=TAILTAIL99pw
-----BEGIN PGP PRIVATE KEY BLOCK-----
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-----END PGP PRIVATE KEY BLOCK-----
after the block
git push -u origin main
see https://example.com:8080/path@v2 for details
ssh://git@github.com:22/owner/repo.git
git@github.com:owner/repo.git
Author: Christopher Example
PWD=/Users/someone/projects/vault
a basic understanding of internationalisation
gcc -pedantic-errors -pthread file.c
mkdir -p /tmp/some/long/path/name
hf_hub_download_with_a_very_long_function_name()
npm_config_registry=https://registry.npmjs.org/
bypass: everything-here-is-fine
the tokenizer => splits words
x => y
IN

cat > "$T/want.txt" <<'WANT'
password=***REDACTED***
token: ***REDACTED***
password=***REDACTED***
secret=***REDACTED***
password=***REDACTED***
{"client_secret": ***REDACTED***
export CMD="password=***REDACTED***
secret: ***REDACTED***
token=***REDACTED***
API_KEY=***REDACTED***
password="short7" x
token=***REDACTED***
console.log("token:***REDACTED***
password=***REDACTED***
x("token:***REDACTED***
{"token":***REDACTED***
password=***REDACTED***
password=***REDACTED***
token=***REDACTED***
secret=***REDACTED***
print('api_key:***REDACTED***
x("token:***REDACTED***
print('api_key:***REDACTED***
secret = ***REDACTED***
token: ***REDACTED***
x("token:***REDACTED***
x("token:***REDACTED***
print('api_key:***REDACTED***
x('token:***REDACTED***
secret = ***REDACTED***
key sk-ant-***REDACTED*** end
key gh_***REDACTED*** end
Authorization: Bearer ***REDACTED***
jwt ***REDACTED JWT*** end
password=***REDACTED***
secret=***REDACTED***
password=***REDACTED***
DATABASE_URL=postgres://dbuser:***REDACTED***
curl -u admin:***REDACTED***
curl --user "admin:***REDACTED***
Authorization: Basic ***REDACTED***
{"Authorization": "Basic ***REDACTED***
key glpat-***REDACTED*** end
key hf_***REDACTED*** end
key npm_***REDACTED*** end
Authorization: Bearer ***REDACTED***
Authorization: Bearer ***REDACTED***
Authorization: Bearer ***REDACTED***
https://hooks.slack.com/services/***REDACTED***=***REDACTED***
glpat-***REDACTED***=***REDACTED***
npm_***REDACTED***=***REDACTED***
https://hooks.slack.com/services/***REDACTED***
DefaultEndpointsProtocol=https;AccountName=acct;AccountKey=***REDACTED***
secret => ***REDACTED***
'password' => ***REDACTED***
passphrase: ***REDACTED***
private_key: ***REDACTED***
auth_key=***REDACTED***
access_key=***REDACTED***
***REDACTED PRIVATE KEY BLOCK***
after the block
git push -u origin main
see https://example.com:8080/path@v2 for details
ssh://git@github.com:22/owner/repo.git
git@github.com:owner/repo.git
Author: Christopher Example
PWD=/Users/someone/projects/vault
a basic understanding of internationalisation
gcc -pedantic-errors -pthread file.c
mkdir -p /tmp/some/long/path/name
hf_hub_download_with_a_very_long_function_name()
npm_config_registry=https://registry.npmjs.org/
bypass: everything-here-is-fine
the tokenizer => splits words
x => y
WANT

# Which seds to run. The system sed always runs. If it is not GNU sed and a
# gsed binary exists, a second leg runs GNU sed through a temporary link named
# `sed`, because redact() calls plain `sed`.
LEGS="system"
if ! sed --version >/dev/null 2>&1 && command -v gsed >/dev/null 2>&1; then
  mkdir -p "$T/gnubin"
  if ln -s "$(command -v gsed)" "$T/gnubin/sed" 2>/dev/null; then
    LEGS="system gnu"
  fi
fi

leg_path() {  # $1 = leg name; prints the PATH for that leg
  if [ "$1" = "gnu" ]; then printf '%s' "$T/gnubin:$PATH"; else printf '%s' "$PATH"; fi
}

FAIL=0

for leg in $LEGS; do
  PATH="$(leg_path "$leg")" bash -c ". \"$T/fn.sh\"; redact" < "$T/in.txt" > "$T/got.$leg"
  if cmp -s "$T/want.txt" "$T/got.$leg"; then
    echo "samples ($leg sed): PASS ($(wc -l < "$T/in.txt" | tr -d ' ') lines in)"
  else
    echo "samples ($leg sed): FAIL — expected (<) against actual (>):"
    diff "$T/want.txt" "$T/got.$leg"
    FAIL=1
  fi
done

# Long lines: a pattern that backtracks badly shows up as seconds, not
# milliseconds. Five seconds is a loose ceiling for a slow Drive mount.
printf 'password="%s\n' "$(printf '%020000d' 0)" > "$T/long.txt"
printf 'password="abcdefghij" %s\n' "$(printf '%020000d' 0)" >> "$T/long.txt"
printf 'postgres://u:%s\n' "$(printf '%020000d' 0)" >> "$T/long.txt"
printf 'curl -u a:%s\n' "$(printf '%020000d' 0)" >> "$T/long.txt"
for leg in $LEGS; do
  START=$SECONDS
  PATH="$(leg_path "$leg")" bash -c ". \"$T/fn.sh\"; redact" < "$T/long.txt" > /dev/null
  TOOK=$((SECONDS - START))
  if [ "$TOOK" -le 5 ]; then
    echo "long lines ($leg sed): PASS (${TOOK}s)"
  else
    echo "long lines ($leg sed): FAIL — took ${TOOK}s"
    FAIL=1
  fi
done

case "$LEGS" in
  *gnu*) : ;;
  *) sed --version >/dev/null 2>&1 || echo "NOTE: GNU sed leg skipped — no gsed found (macOS: brew install gnu-sed)." ;;
esac

# Optional: never show more than the redact() at <git-ref>.
if [ -n "$REF" ]; then
  command -v python3 >/dev/null 2>&1 || { echo "--exhaustive needs python3."; exit 2; }
  git show "$REF:.claude/hooks/capture-log.sh" 2>/dev/null | sed -n '/^redact() {/,/^}/p' > "$T/ref.sh"
  [ -s "$T/ref.sh" ] || { echo "No redact() found at git ref $REF."; exit 2; }
  python3 -I - "$T" <<'PY'
import itertools, random, sys
t = sys.argv[1]
# A digit run stands in for a secret; position i gets digit i, nine times.
run = lambda i: str(i % 9 + 1) * 9
toks = ['password=', 'token:', 'secret = ', '"', "'", ' ', None]
with open(t + '/exhaustive.txt', 'w') as f:
    for n in range(1, 8):
        for c in itertools.product(toks, repeat=n):
            f.write(''.join(run(i) if x is None else x for i, x in enumerate(c)) + '\n')
random.seed(5)
wide = toks + ['\\', '*', ',', ';', 'a', 'x y', '"', ' => ', '://u:', '@', '-u a:', 'Basic ']
with open(t + '/random.txt', 'w') as f:
    for _ in range(200000):
        c = [random.choice(wide) for _ in range(random.randint(2, 9))]
        f.write(''.join(run(i) if x is None else x for i, x in enumerate(c)) + '\n')
PY
  for leg in $LEGS; do
    for set in exhaustive random; do
      PATH="$(leg_path "$leg")" bash -c ". \"$T/ref.sh\"; redact" < "$T/$set.txt" > "$T/ref.$leg.$set"
      PATH="$(leg_path "$leg")" bash -c ". \"$T/fn.sh\"; redact" < "$T/$set.txt" > "$T/now.$leg.$set"
      python3 -I - "$T/$set.txt" "$T/ref.$leg.$set" "$T/now.$leg.$set" "$leg $set" <<'PY' || FAIL=1
import sys
lines, old, new = (open(p).read().splitlines() for p in sys.argv[1:4])
if not len(lines) == len(old) == len(new):
    print('%s: FAIL — line counts differ (%d in, %d ref, %d now)' % (sys.argv[4], len(lines), len(old), len(new)))
    sys.exit(1)
# Worse = some digit appears more often in b than in a.
worse = lambda a, b: any(b.count(d) > a.count(d) for d in '123456789')
more = sum(worse(a, b) for a, b in zip(old, new))
less = sum(worse(b, a) for a, b in zip(old, new))
print('exhaustive (%s): %s — %d lines, shows more than ref: %d, shows less than ref: %d'
      % (sys.argv[4], 'PASS' if more == 0 else 'FAIL', len(lines), more, less))
sys.exit(1 if more else 0)
PY
    done
  done
fi

if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS"
  exit 0
fi
echo "RESULT: FAIL"
exit 1
