# Shigeno

The memory side of a personal generative-AI practice: files that hold a long-lived
assistant's continuity, the conventions that keep them truthful, and the adapter
training story that shaped them.

## What this is

Most setups treat the model as the scarce object and a user's history as disposable
context, replayed on every call. This repository documents the inversion. The model is
the cheap, swappable part. The durable thing is the memory substrate that carries
continuity and accumulated context on the user's side, and inference is the moment a
live memory system and a stateless engine synchronize.

The substrate is files, and the shape is deliberate:

- A journal spine. Session recaps are written to the same path under the same
  convention, and the newest one is what the next session reads at boot. Every session
  starts from the same written truth rather than from whatever the model happened to
  retain.
- A memory cache. Persistent memory loads fast and steers behavior, but it is
  candidate-tier by default. It shortens the gap between "the principal said it once"
  and "the agent acts on it next week." It does not bind.
- An extract-and-promote gate. Raw logs, sediment, and transcripts are not authority.
  Nothing becomes canonical without an explicit promotion step that writes a card, and
  promotion is append-only. No silent drift into "the model seems to remember we
  decided X."

Around that triad sit the conventions that keep it honest (one fact per file, an update
beats a duplicate, a canonical layer that is never hand-edited and a derived layer that
is never trusted as source, a consent-driven enrichment loop that never re-asks the same
question), a small set of tools that read and search the corpus, worked examples of the
card shape, and a training chapter that documents adapting an open model on curated
transcripts, with receipts.

Architecture only, never data. These files describe the pattern and its rules. The live
stores stay where they live, and nothing copies across that line. Every example in the
tree is synthetic by rule.

## Layout

- `docs/` the design documents: the master architecture, the memory spine, the
  enrichment loop and its longer sitting form, the card layer, and the corpus map.
- `conventions/` the written practice, short and single-subject: card discipline and
  the rules around it.
- `examples/` worked examples of the card shape, synthetic by rule.
- `tools/` the corpus tooling: four read-mostly tools plus a self-test, standard library
  and shell only, configured from the environment with neutral defaults.
- `training/` the adapter chapter: receipts, seed-set plans, the A/B instrument, the
  wall-of-text probe results, the distilled bench table, the curation law, and a plain
  QLoRA recipe. Aggregates and receipts only.
- `scripts/` the vendored invariant linter, `inertia-drift-lint`, run by continuous
  integration on every push.
- `.github/workflows/` the governance workflow: the linter plus manifest schema
  validation.
- `AGENTS.md` the agent contract: the principal GLOBAL block and this project's LOCAL
  layer.
- `agent-manifest.json` and `agent-manifest.schema.json` the machine-readable summary
  and its schema.
- `LICENSE` the MIT license.

## Quick start

Nothing here needs network access or a GPU. A fresh clone runs green offline.

Run the tool self-test:

```
bash tools/self-test.sh
```

It checks shell syntax, compiles the Python tools against a throwaway fixture, writes
nothing outside a temporary directory, and touches no network. Exit 0 means every check
passed. The individual tools take their configuration from the environment, so the same
commands run against any corpus root without editing:

```
MEMORY_ROOT=~/.agent-memory SOURCE_ROOT=~/projects bash tools/gather-strays.sh
REPO_ROOT=~/code python3 tools/ignored-code.py
```

See `tools/README.md` for the full variable tables.

Run the governance gate the way continuous integration does:

```
python3 scripts/inertia-drift-lint .
```

That checks the contract fences, the manifest pointers, and the artifact style floor.
Expect a clean exit on the tree as shipped.

Read the design in this order: `docs/master-memory-architecture.md`, then
`docs/memory-spine.md`, then the two enrichment documents together.

The training chapter is documentation of a process, not a turnkey trainer. It records
what was done, what it measured, and what it cost, on one consumer GPU, with aggregate
numbers only. It is a reading chapter, not an entry point you run.

## Status

What is documented and proven:

- The architecture design, in full, as `docs/`. The four laws, the inverse-roles engine,
  the tagging axes, the card layer, and the corpus map.
- The conventions and their worked examples.
- The tooling, with a self-test that runs green on a fresh clone with no network and no
  host-specific configuration.
- The governance layer: the contract, the manifest, the vendored linter, and the CI
  workflow.
- The adapter chapter: three trained and measured versions, the termination cure for a
  generation failure, and the receipts behind the aggregate numbers.

What remains a pattern rather than a shipped mechanism:

- The architecture is described as a design and validated by use on one system. It is
  not packaged as an installable product, and there is no supported upgrade path.
- The tools are examples of the corpus discipline on a generic root. The richer
  multi-machine replication paths assume hosts you have configured yourself.
- The enrichment sitting form is a draft revision, marked for review, not settled.
- The training numbers are aggregates from one run on one card. They are honest
  measurements, not a benchmark, and not a claim about other models or hardware.

Where a document says what is measured versus assumed, it says so on its face. That is
the house habit, not a hedge.

## Governance

This repository is governed by [Inertia-Drift-Framework](https://github.com/buntas-tofu/Inertia-Drift-Framework):
`AGENTS.md` carries the principal contract and this project's layer,
`agent-manifest.json` is the machine-readable summary, and the invariant
linter plus schema validation run in CI on every push.

Note: the bundled `scripts/inertia-drift-lint` is a faithful copy of the
framework linter; it deliberately still recognizes the legacy `CLAUDE.md`
contract filename so that pre-rename adopters lint correctly. That string is
a compatibility affordance, not this project's naming.

## License

MIT, for code and documentation. The copyright line in `LICENSE` carries the operator's
legal name.

---

Shigeno adopts [Inertia-Drift-Framework](https://github.com/buntas-tofu/Inertia-Drift-Framework)
for its governance. Its companion repository is Masashi-Tune, the machine side.
