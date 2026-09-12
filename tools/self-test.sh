#!/usr/bin/env bash
# self-test.sh: exercise the corpus tools against a throwaway fixture.
#
# No network, no writes outside a temporary directory. Every check is a real
# run of a real tool over planted files, not an inspection of the source.
# Exit 0 means every check passed.
#
# Run it from anywhere: bash tools/self-test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAIL=0
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass() { echo "ok: $1"; }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

# 1. Language checks: shell syntax, Python byte-compile.
bash -n "$HERE/gather-strays.sh" && pass "gather-strays.sh syntax" || fail "gather-strays.sh syntax"
bash -n "$HERE/gather-sediment.sh" && pass "gather-sediment.sh syntax" || fail "gather-sediment.sh syntax"
python3 -m py_compile "$HERE/family-drift.py" && pass "family-drift.py compiles" || fail "family-drift.py compiles"
python3 -m py_compile "$HERE/ignored-code.py" && pass "ignored-code.py compiles" || fail "ignored-code.py compiles"

# 2. gather-strays on an empty tree: runs clean and gathers nothing.
mkdir -p "$TMP/src" "$TMP/mem"
out="$(MEMORY_ROOT="$TMP/mem" SOURCE_ROOT="$TMP/src" bash "$HERE/gather-strays.sh" 2>&1)" \
  && pass "gather-strays runs on an empty tree" || fail "gather-strays empty run"
case "$out" in
  *"0 gathered"*) pass "gather-strays reports nothing to gather" ;;
  *) fail "gather-strays empty report" ;;
esac

# 3. gather-strays gathers a planted export and prefixes it with its source.
mkdir -p "$TMP/src/team/tool"
printf 'export body\n' > "$TMP/src/team/tool/run-20260101-1200.txt"
MEMORY_ROOT="$TMP/mem" SOURCE_ROOT="$TMP/src" bash "$HERE/gather-strays.sh" >/dev/null 2>&1
[ -f "$TMP/mem/exports/sessions/team__tool__run-20260101-1200.txt" ] \
  && pass "gather-strays gathers and prefixes by source" || fail "gather-strays gather"

# 4. gather-strays is idempotent: a second run adds no file and no copy.
before="$(find "$TMP/mem" -type f | wc -l)"
MEMORY_ROOT="$TMP/mem" SOURCE_ROOT="$TMP/src" bash "$HERE/gather-strays.sh" >/dev/null 2>&1
after="$(find "$TMP/mem" -type f | wc -l)"
[ "$before" = "$after" ] && pass "gather-strays is idempotent" || fail "gather-strays idempotent"

# 5. family-drift on a root it cannot see: reports a blind gate, exits 0.
mkdir -p "$TMP/fam"
out="$(FAMILY_ROOT="$TMP/fam" FAMILY_APPS="alpha" python3 "$HERE/family-drift.py" 2>&1)"
rc=$?
[ "$rc" = "0" ] && pass "family-drift exits 0" || fail "family-drift exit code"
case "$out" in
  *"GATE BLIND"*) pass "family-drift announces a blind gate" ;;
  *) fail "family-drift blind banner" ;;
esac

# 6. family-drift over an identical family: shared organs read IDENT.
for a in alpha beta gamma; do
  mkdir -p "$TMP/fam/$a/core"
  printf 'def normalize(value):\n    return value.strip().lower()\n' > "$TMP/fam/$a/core/name_match.py"
done
out="$(FAMILY_ROOT="$TMP/fam" FAMILY_APPS="alpha beta gamma" python3 "$HERE/family-drift.py" 2>&1)"
case "$out" in
  *"| name_match.py | IDENT"*) pass "family-drift reads identical organs as IDENT" ;;
  *) fail "family-drift IDENT verdict" ;;
esac

# 7. family-drift over a drifted family: the laggard is named.
{
  printf 'def normalize(value):\n    return value.strip().lower()\n'
  for i in 1 2 3 4 5 6 7 8; do
    printf '\ndef extra_%s(value):\n    return value\n' "$i"
  done
} > "$TMP/fam/gamma/core/name_match.py"
out="$(FAMILY_ROOT="$TMP/fam" FAMILY_APPS="alpha beta gamma" python3 "$HERE/family-drift.py" 2>&1)"
case "$out" in
  *"gamma lags"*) pass "family-drift names the laggard organ" ;;
  *) fail "family-drift laggard verdict" ;;
esac

# 8. ignored-code flags an ignored code file with no stated reason.
mkdir -p "$TMP/repo/hidden"
git -C "$TMP/repo" init -q >/dev/null 2>&1
printf 'hidden/\n' > "$TMP/repo/.gitignore"
printf 'print("x")\n' > "$TMP/repo/hidden/secret.py"
out="$(REPO_ROOT="$TMP/repo" python3 "$HERE/ignored-code.py" 2>&1)"
rc=$?
[ "$rc" = "0" ] && pass "ignored-code exits 0" || fail "ignored-code exit code"
case "$out" in
  *"1 unaccounted"*) pass "ignored-code flags the unaccounted ignore" ;;
  *) fail "ignored-code finding" ;;
esac

echo
if [ "$FAIL" -eq 0 ]; then
  echo "self-test: all checks passed"
else
  echo "self-test: $FAIL check(s) failed"
fi
exit "$FAIL"
