#!/usr/bin/env bash
# gather-sediment.sh: replicate live memory and telemetry streams into the
# memory root. Copies only; the sources are never written.
#
# Two things are replicated:
#   1. The sediment, the recorded conversation stream. It is single-homed on
#      one machine (RECORD_NODE), together with the memory core inscription,
#      one file gathered whole.
#   2. The per-node usage counters under the memory root of every recording
#      machine (NODES), one stream per node, so a chair that moves does not
#      silently drop the machine it left behind.
#
# An unreachable source warns and the gather continues. The exit code carries
# the failure count, so a timer driving this stays honest.
#
# Environment (all optional):
#   MEMORY_ROOT  corpus home to replicate into.   Default: $HOME/agent-memory
#   REMOTE_DIR   memory root on each remote node. Default: /srv/agent-memory
#   RECORD_NODE  host that single-homes the sediment. Empty: nothing to pull,
#                the sediment is assumed local.
#   NODES        space separated hosts with usage-counter streams. Empty:
#                local only.
#   SELF_NODE    this machine's name.             Default: $(hostname)
#   LOCAL_OD     local usage-counter root, used when SELF_NODE is in NODES.
#                Default: $MEMORY_ROOT/odometer
#
# Pulls ride the operator's own ssh trust (aliases in ~/.ssh/config), and
# rsync keeps them incremental and idempotent.

set -uo pipefail

MEMORY_ROOT="${MEMORY_ROOT:-$HOME/agent-memory}"
REMOTE_DIR="${REMOTE_DIR:-/srv/agent-memory}"
RECORD_NODE="${RECORD_NODE:-}"
NODES="${NODES:-}"
SELF_NODE="${SELF_NODE:-$(hostname)}"
LOCAL_OD="${LOCAL_OD:-$MEMORY_ROOT/odometer}"
FAIL=0

pull() { # pull <src> <dest>
  rsync -a --timeout=20 "$1" "$2" || { echo "WARN: pull failed: $1"; FAIL=$((FAIL + 1)); }
}

mkdir -p "$MEMORY_ROOT/sediment" "$MEMORY_ROOT/telemetry/odometer"

if [ -n "$RECORD_NODE" ] && [ "$RECORD_NODE" != "$SELF_NODE" ]; then
  pull "$RECORD_NODE:$REMOTE_DIR/sediment/" "$MEMORY_ROOT/sediment/"
  pull "$RECORD_NODE:$REMOTE_DIR/core"      "$MEMORY_ROOT/sediment-core"
else
  echo "note: sediment is local to $SELF_NODE, nothing to pull"
fi

for node in $NODES; do
  if [ "$node" = "$SELF_NODE" ]; then
    # The local stream is pulled by path, never by host name, because a
    # stream that is never attempted cannot fail. Naming every node and
    # special-casing whichever one is local keeps the mirror honest from
    # any machine that runs the gather.
    if [ "$LOCAL_OD" = "$MEMORY_ROOT/odometer" ]; then
      echo "note: usage counters for $node are already home"
    else
      pull "$LOCAL_OD/" "$MEMORY_ROOT/telemetry/odometer/"
    fi
  else
    pull "$node:$REMOTE_DIR/odometer/" "$MEMORY_ROOT/telemetry/odometer/"
  fi
done

echo "sediment: $(ls "$MEMORY_ROOT/sediment" 2>/dev/null | wc -l) files in the local stream"
echo "usage counters: $(du -sh "$MEMORY_ROOT/telemetry/odometer" 2>/dev/null | cut -f1) across $(ls "$MEMORY_ROOT/telemetry/odometer" 2>/dev/null | wc -l) node streams"
exit "$FAIL"
