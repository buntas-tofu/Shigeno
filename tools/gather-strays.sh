#!/usr/bin/env bash
# gather-strays.sh: sweep a source tree for memory strays and copy them into
# the memory root. Copies only; originals stay where they were born.
#
# What it gathers:
#   1. Session exports whose file name carries a datetime stamp, under either
#      convention: <theme>-YYYYMMDD-HHMM.<ext> or YYYYMMDD-HHMM-<theme>.<ext>.
#      Both are matched, because the earlier version of this sweep understood
#      only the first and every drop named the other way was invisible to it.
#      Silence then read as "nothing to gather", which is the one failure a
#      sweep must never report.
#   2. Recaps and handoffs (*recap*.md, *handoff*.md).
#   3. Optionally, files left at the top level of GROUND_DIR, which are MOVED
#      rather than copied (see GROUND_DIR below).
#
# Naming: the source path relative to SOURCE_ROOT, with slashes rewritten as
# double underscores. team/tool/run-20260101-1200.txt gathers home as
# team__tool__run-20260101-1200.txt.
#
# Idempotent: an existing copy is skipped. A file whose bytes are already home
# under a different name is detected by a size prefilter plus sha256, so a
# rename upstream does not gather the same bytes twice.
#
# Environment (all optional):
#   MEMORY_ROOT  corpus home to gather into.        Default: $HOME/agent-memory
#   SOURCE_ROOT  tree to sweep.                     Default: $HOME/projects
#   PRUNE        directory names never descended into. Default: (see below)
#   GROUND_DIR   top-level drop directory. When set, files at its top level
#                that match the datetime naming are MOVED into
#                MEMORY_ROOT/exports/, not copied. This is the one place the
#                tool moves rather than copies, and it is opt-in by design:
#                a ground directory is a staging area whose strays belong in
#                the corpus, while work inside a project stays where it was
#                born. Unset by default, so sweeping never moves anything.
#   RESIDENTS    space separated base names never swept from GROUND_DIR.
#                Default: AGENTS.md README.md
#
# A drop modified within the last hour is left alone: a session may still be
# writing it, and this tool is expected to run on a timer.

set -euo pipefail

MEMORY_ROOT="${MEMORY_ROOT:-$HOME/agent-memory}"
SOURCE_ROOT="${SOURCE_ROOT:-$HOME/projects}"
PRUNE_NAMES="${PRUNE:-.git .venv node_modules archive _archive}"
RESIDENTS="${RESIDENTS:-AGENTS.md README.md}"

gathered=0 skipped=0 sorted=0

# Identity is CONTENT, not name. A source can be renamed upstream, and a
# name-only check would gather the same bytes again under the new name. Size
# is the cheap prefilter; sha256 decides.
already_home() {
  local src="$1" dest_dir="$2"
  local size; size="$(stat -c%s "$src")"
  local sum=""
  local f fsize
  for f in "$dest_dir"/*; do
    [ -f "$f" ] || continue
    fsize="$(stat -c%s "$f")"
    [ "$fsize" = "$size" ] || continue
    [ -n "$sum" ] || sum="$(sha256sum "$src" | cut -d" " -f1)"
    if [ "$(sha256sum "$f" | cut -d" " -f1)" = "$sum" ]; then
      echo "$f"
      return 0
    fi
  done
  return 1
}

gather() {
  local src="$1" dest_dir="$2"
  local rel="${src#"$SOURCE_ROOT"/}"
  local name="${rel//\//__}"
  if [ -e "$dest_dir/$name" ]; then
    skipped=$((skipped+1))
    return
  fi
  local twin
  if twin="$(already_home "$src" "$dest_dir")"; then
    echo "same bytes already home as $(basename "$twin"), not re-gathering: $name"
    skipped=$((skipped+1))
    return
  fi
  cp -p "$src" "$dest_dir/$name"
  echo "gathered: $name"
  gathered=$((gathered+1))
}

# Ground level only: move the drop home instead of copying it. It keeps its
# bare name (no path prefix), because it came from the staging root itself.
sort_home() {
  local src="$1" dest_dir="$2"
  local name; name="$(basename "$src")"
  if [ -e "$dest_dir/$name" ]; then
    echo "ALREADY HOME, left in place for your hand: $name"
    skipped=$((skipped+1))
  else
    mv "$src" "$dest_dir/$name"
    echo "sorted from ground level: $name"
    sorted=$((sorted+1))
  fi
}

# Either naming convention: theme-then-datetime, or datetime-then-theme.
SESSION_RE='.*(-20[0-9]{6}-[0-9]{4}|/20[0-9]{6}-[0-9]{4}-[^/]*)\.[A-Za-z0-9]+'

# Prune expression: every listed directory name, joined with -o. The caller
# wraps the list in \( ... \) -prune, so a directory matching any entry is
# never descended into.
prune_args=()
for d in $PRUNE_NAMES; do
  [ "${#prune_args[@]}" -gt 0 ] && prune_args+=( -o )
  prune_args+=( -path "*/$d" )
done

mkdir -p "$MEMORY_ROOT/exports/sessions" "$MEMORY_ROOT/recaps/scattered"

# 0. ground-level drops: moved home, not copied. Depth 1, never a resident,
# never a file still warm from a running session. Opt-in via GROUND_DIR.
if [ -n "${GROUND_DIR:-}" ]; then
  while IFS= read -r f; do
    base="$(basename "$f")"
    case " $RESIDENTS " in *" $base "*) continue;; esac
    sort_home "$f" "$MEMORY_ROOT/exports"
  done < <(
    find "$GROUND_DIR" -maxdepth 1 -type f -mmin +60 \
      -regextype posix-extended -regex "$SESSION_RE" -print 2>/dev/null | sort)
fi

# 1. session exports (datetime-stamped), anywhere under the source tree.
while IFS= read -r f; do gather "$f" "$MEMORY_ROOT/exports/sessions"; done < <(
  find "$SOURCE_ROOT" \
    \( \( "${prune_args[@]}" \) -prune \) -o \
    -type f -regextype posix-extended -regex "$SESSION_RE" -print \
    2>/dev/null | sort)

# 2. recaps and handoffs (md).
while IFS= read -r f; do gather "$f" "$MEMORY_ROOT/recaps/scattered"; done < <(
  find "$SOURCE_ROOT" \
    \( \( "${prune_args[@]}" \) -prune \) -o \
    -type f \( -iname '*recap*' -o -iname '*handoff*' \) -name '*.md' -print \
    2>/dev/null | sort)

echo "done: $sorted sorted from ground level, $gathered gathered, $skipped already home"
