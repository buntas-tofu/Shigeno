# Memory Spine: the architecture of what it remembers

**Version:** v0.1.0 WORKING
**Date:** 2026-07-15
**Status:** the strand's anchor doc. The canonical deep spec sits beside this file
(`master-memory-architecture.md`, carried over from an earlier design tree on 2026-07-15, checksummed). This anchor states the principles, the shipped state, and
the curation rules; when it disagrees with shipped code, code wins and this gets
corrected.
**Floor:** DMF. No em dashes, no ellipses. Label inference.

## Principles (the four laws)

1. **Time as address.** The recency gradient is free because the gradient IS the
   coordinate. One tape, read by axes.
2. **Revelation, not retrieval.** Eager spin into a warm context, not lazy pull on
   demand.
3. **Model-ephemeral, store-durable.** The window is scratch; the store is the
   archive; context goes near-limitless because the store carries it.
4. **Inverse dual roles.** CQRS plus event sourcing: a write inverse tags and
   stores in the latency shadow, a read inverse revels the next context into a
   warm acceptor.

## Shipped state (receipts, with dates)

- **Mark I** (2026-07-01): the round-table room as a shared time-addressed store; agents reveal from the store, clients send a room and agent identifier, with no transcript. Proven at the wire.
- **Server-side recording** (2026-07-01): generation and recording run as a server-side task; a dropped client can no longer truncate the record.
- **Session axis and room replay** (2026-07-06): sessions as the fourth read-axis over the one tape; scoped read-only replay of any past room; cross-session reference rides as an origin-labeled Tier 3 block, pull never write across. The room IS the record.
- **Tagging axes:** temporal/structural is CPU-native and built (the time-indexed
  sediment). Semantic/associative is the mesh still to build: an embedding index cooked on idle silicon by the small resident models (a local vectorizer service).

## Curation (what enters the person)

- The **curated cards** (two-layer store: the in-tree canonical copy plus a regenerable harness mirror) are the structured self.
- The **journal** is the narrative self.
- The **sediment** (a per-node live store) is the lived tape: rooms, turns,
  telemetry. It stays fabric-side and operational.
- The design room holds **specs and curation rules only, never the data**. Live stores do not move, nothing copies across the memory line, and the corpus
  distillate one strand over is identity feedstock, not memory.

## Faculty hooks

The acceptable-labs allowlist, the functions frame (brain, eyes, ears, mouth), the
feeder-synapse topology, and the output-layer open decision are principal-level matters, tracked in the persona charter and the faculty card. The spine serves whatever board the principal locks.

## Open forks (held, from the canonical spec)

Representation (pointer vs embedding vs Hopfield attractor; the distribution
instinct votes time-addressed pointers plus sharded embedding),
stability-plasticity (immutable time-substrate slow, disposable revelation surface
fast), density. Held deliberately; the spine ships in marks, not in one leap.
