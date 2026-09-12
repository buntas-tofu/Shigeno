# Tools

The corpus tooling. Four tools and one self-test. Everything here is
standard library and shell only, reads more than it writes, and takes its
configuration from the environment with neutral defaults, so the same tools
work on any machine and any corpus root without editing.

Run the self-test after any change:

```
bash tools/self-test.sh
```

It checks shell syntax, compiles the Python tools, and then runs each tool
over a throwaway fixture with planted files. It writes nothing outside a
temporary directory and touches no network. Exit 0 means every check passed.

## gather-strays.sh

Sweeps a source tree for memory strays and copies them into the corpus.
Session exports whose names carry a datetime stamp, plus recaps and
handoffs, gather home under source-prefixed names. Copies only; a project
file stays where it was born. Idempotent by an existing-name check plus a
size and checksum comparison, so a rename upstream does not gather the same
bytes twice.

```
MEMORY_ROOT=~/.agent-memory SOURCE_ROOT=~/projects bash tools/gather-strays.sh
```

| Variable | Default | Meaning |
|---|---|---|
| `MEMORY_ROOT` | `$HOME/agent-memory` | corpus home to gather into |
| `SOURCE_ROOT` | `$HOME/projects` | tree to sweep |
| `PRUNE` | `.git .venv node_modules archive _archive` | directory names never descended into |
| `GROUND_DIR` | unset | staging root whose top-level drops are moved, not copied |
| `RESIDENTS` | `AGENTS.md README.md` | names never swept from `GROUND_DIR` |

## gather-sediment.sh

Replicates live memory and telemetry streams into the corpus: the sediment
and the memory core inscription from the single recording machine
(`RECORD_NODE`), plus one usage-counter stream per recording machine
(`NODES`). Copies only, and the exit code carries the failure count so a
timer driving the pull stays honest. The self-test covers its syntax only; a
pull needs hosts and is out of scope for a fixture.

```
MEMORY_ROOT=~/.agent-memory RECORD_NODE=recorder NODES="recorder node-b" bash tools/gather-sediment.sh
```

| Variable | Default | Meaning |
|---|---|---|
| `MEMORY_ROOT` | `$HOME/agent-memory` | corpus home to replicate into |
| `REMOTE_DIR` | `/srv/agent-memory` | corpus root on each remote machine |
| `RECORD_NODE` | unset | machine that single-homes the sediment |
| `NODES` | unset | machines with usage-counter streams |
| `SELF_NODE` | `$(hostname)` | this machine's name |
| `LOCAL_OD` | `$MEMORY_ROOT/odometer` | local usage-counter root |

## family-drift.py

The copy-inheritance smoke detector. A family of sibling repositories
shares organs by copy, and copies rot: a fix that lands in two members and
misses the third produces no error and no failing test. This gate compares
the members three ways, reports what it finds as markdown on stdout, and
exits 0 always. It reports; a person judges. A root it cannot read produces
an explicit blind-gate banner, never a clean verdict.

```
FAMILY_ROOT=~/code FAMILY_APPS="alpha beta gamma" python3 tools/family-drift.py
```

| Variable | Default | Meaning |
|---|---|---|
| `FAMILY_ROOT` | `$HOME/code` | parent directory of the family members |
| `FAMILY_APPS` | `alpha beta gamma` | member names, each a directory under the root |

The organ list, the probe sets, and the identity phrases are a worked
example from one family of applications that share a database layer by
copy. Edit them for yours.

## ignored-code.py

The silent-exclusion gate. An ignore rule fails in one direction only, and
it is the quiet one: an over-tracked file costs one revert, while an
over-ignored file produces no error, no warning, and no status line. This
tool lists the code and documentation files that are being ignored, names
the exact rule doing the ignoring, and separates the accounted-for from the
unaccounted-for. Every allowlist entry carries its reason.

```
REPO_ROOT=~/code python3 tools/ignored-code.py
```

| Variable | Default | Meaning |
|---|---|---|
| `REPO_ROOT` | `$HOME/code` | directory scanned for repositories |

## Adding a tool

Land it here with a self-test check in `self-test.sh`, a section in this
file, and a line in the repository manifest. A tool with no self-test does
not ship.
