---
title: "Master Memory Architecture"
subtitle: "Persistence as time-addressed revelation, the inverse-roles engine, and the first mark"
version: "0.1.0"
status: "WORKING"
date: "2026-07-01"
owners: ["buntas-tofu"]
floor: "DMF: no em dashes, no ellipses. Authority lives in files; label inference."
tiers: "Tier 1 principal-confirmed and binding. Tier 2 docs and code. Tier 3 agent inference."
provenance: "Written 2026-07-01 in a prior design session, grounded in the principal's earlier design notes (an origin memo and a next-steps note) and the running fabric code."
---

# Master Memory Architecture

The endgame is not a model with a long memory. It is an identity that outlives its
substrate. This is the map from that telos down to the one loop we build first.

---

## 1. The telos [Tier 1, principal]

Persistence is achieved by an amalgamation of models so tightly synced they become
**aspects of one master persona**. The governing apparatus is not a singular thing
that processes linearly, because linear single-thread is non-natural and inefficient,
the way a mind is not one neuron firing in order. The master persona is a tightly
orchestrated, multi-modal handoff of operations that makes the alpha and omega, what
walks up and what answers, **agnostic of any one part**. No part is load-bearing for
the whole. The model is the swappable part; the persona is the durable one. Identity
lives in the orchestration and the memory, not in any set of weights.

This is the model-is-swappable principle taken to its end: not "an agent wears a model,"
but "the entire persona is substrate-agnostic, and no single aspect can be pulled to
kill it."

---

## 2. The spine: memory is a verb [Tier 1 and 2, from prior docs]

The thing that turns N models into N aspects of one identity is a shared, live,
time-addressed memory that every aspect reads and writes. It is the spine, not a
feature. Its principles, already set by the principal before this session:

- **Time-as-address, not time-as-field.** A time-ordered address space is an intrinsic,
  monotonic, zero-search recency gradient. The hot-cold signal is free because the
  gradient IS the coordinate. Proven in production shapes: Snowflake IDs, kdb+.

- **Revelation, not retrieval.** The 1970s substrate was written under scarcity, so every
  database since is a lazy pull. 2026 compute is cheap and the forward pass is already
  turning, so the design inverts to eager: spin always, reveal rather than call.
  Inference becomes the moment the model and a live memory system synchronize.

- **Model-ephemeral, store-durable.** The window is scratch; the store is the archive.
  Context goes near-limitless on any model because the window stops being the archive.
- **Grounding.** Modern Hopfield Networks (attention is a continuous associative-memory
  settle, not a lookup), predictive coding (the brain regenerates rather than retrieves),
  fast weights (a spinning associative memory beside the slow weights).

---

## 3. The engine: inverse roles [Tier 2 and 3, this session]

The mechanism that makes "memory is a verb" actually run:

- **Two inverses along the processor / database seam.** The **write inverse** stores and
  tags a turn as it lands. The **read inverse** revels the next context into a warm pin.
  They run phase-offset, each doing its bread and butter, in each other's latency shadow:
  while the GPU generates, the CPU stores, tags, meshes; while the database work finishes,
  the GPU runs the semantic tagging pass. Neither waits on the other.
- **This shape has a name and a solved-problems graveyard behind it.** An immutable log
  with rebuildable projections is **event sourcing**. A write side split from a read side
  is **CQRS**. The principal's two-inverse instinct independently landed on the most
  battle-tested shape in distributed data. Prior art to steal; the recovery semantics are
  already worked out.
- **Attention as a pinned acceptor.** Not the transformer sense. A trivial resident pin,
  CPU or GPU, holding a template and standing ready to catch the function output of
  whatever precedes it and fold it in. Keeping a receiver warm costs almost nothing and
  removes the per-turn cold start. Revelation lives in the pin between turns.
- **Distribution.** In a group conversation, every selected aspect brings not just its GPU
  but its CPU into the pool, and the memory roles spread across the participants rather
  than centralize. This requires a resource contract: the fabric using local processing
  beyond the narrow GPU-inference lease. Govern it like an epsilon budget (the principal's differential-privacy frame): context and compute are a finite resource to be allocated,
  not a free pull.
- **Tight fittings are the scaling law.** The interfaces between write-inverse, store,
  read-inverse, and pin must be clean and stable, so growing the ensemble is adding
  aspects, not re-plumbing. Fittings, not horsepower, decide whether two scales to N.

---

## 4. Tagging: two axes on the seam [Tier 2 and 3]

Tagging splits cleanly across the processor / database seam:

- **Temporal and structural** (when, which agent, which day, which turn): CPU-native and
  **already built**. It is just the metadata the time-indexed sediment already carries.
  This is "CPUs and database operations are bread and butter," and it is done.
- **Semantic and associative** (what this is about, what it meshes to): the GPU
  tagging-inference side, "GPUs and tagging inference are bread and butter." The mesh.
  The half still to build. Staged as an embedding index over the sediment, cooked by the
  bench on idle silicon; revelation then blends association with recency.

- **Low-bit channel.** Zero-width and invisible codepoints (U+200B-200D, U+FEFF) can carry
  an out-of-band tagging layer (provenance, tier, confidence, cross-links, hints) woven
  into the JSONL text without disturbing the human-readable surface. A pure CPU string
  operation, no schema.

---

## 5. The Mark I [Tier 1, agreed 2026-07-01]

Do not chase perfect. Build the crude thing that works and gives us a platform to iterate
from, and iterate in decent-sized chunks, because we are not in a cave, we have the lab.

**The shot:** make the round-table room a shared, time-addressed store. During an agent's
generation, in the latency shadow, a write inverse tags and lands that turn into the shared
store; the next aspect reveals from it instead of eating the whole room re-dumped.

- **Built from parts already on the bench.** An earlier round-table fix made the aspects hear each other correctly. Mark I makes them **share memory**. Step zero
  was the on-ramp.
- **Consistency skipped by construction.** The round table is sequential, one aspect speaks
  at a time, so one writer at a time. The distributed-consistency wall (CRDTs, consensus)
  does not exist yet. The form serializes the writes for free. We do not solve consensus to
  get out of the cave. We solve it later, in the lab, when we go concurrent.
- **Falsifiable on day one.** Once the memory is shared and carries the state, swap an agent's
  model mid-conversation and watch whether the persona holds. If it does, identity lives in
  the substrate, not the weights, which is the entire bet, tested cheap.

---

## 6. Staging [Tier 3]

- **Mark I.** Sequential shared memory. One loop, two aspects. Proves revelation,
  shadow-scheduling, and shared sync at once.
- **Mark II.** The semantic mesh. Embedding index on idle silicon; revelation blends
  association with recency; more aspects join.
- **Mark III.** Concurrent and distributed. Now the consistency problem is real, and the
  event-sourcing / CQRS shape pays for the prior art. The full master persona.

---

## 7. Open forks [Tier 1, held open]

- **Representation.** Pointer vs embedding vs Hopfield attractor. This determines everything
  downstream and was deliberately held open. The distribution instinct casts a vote: embeddings
  shard cleanly, pointers need a shared address space (the timeline, because every node agrees
  on when), and a single global attractor does not shard. So wanting it distributed is pressure
  toward time-addressed pointers plus sharded embedding, away from one monolithic field.
- **Stability-plasticity.** An always-spinning field drifts; the fast-weights literature is a
  graveyard of this. The anchor: split slow from fast. The append-only, time-keyed sediment is
  the slow substrate and cannot drift; the revelation field is the fast surface, allowed to
  drift because it is disposable and always re-derivable from the immutable log. Never let the
  plastic layer be the source of truth. This is the event-sourcing recovery guarantee.
- **Density.** The sweet spot between compositional granularity and computational cost is
  empirical, still to be found.

---

## 8. What is already lit [Tier 2, from code]

- The sediment IS the time series: per-day JSONL (`YYYY-MM-DD.jsonl`), per-event timestamps,
  the reveal path stamping every recalled event with `%m-%d %H:%M` before it reaches an agent. One agent cycled the datetime in its reasoning on 2026-06-30. The recorder is on.
- The round table now reads as a conversation, not a wall to finish.
- A later consolidation pass moved the principal-conducted persona and tools into canon.

---

## 9. Provenance

Prior design sessions, summarized without pointers:

- **Earlier notes this builds on:** an origin memo (memory as a verb, the model as a stateless supermodel), an early design recap (time-as-address, revelation, the machine learning grounding, the open forks), a next-steps note (low-bit tagging, embedding on idle silicon), a two-layer persistence note, and an outreach draft on context as an epsilon budget.
- **The session that wrote this:** a later design session closing the round-table echo fix and the consolidation pass.
- **Code:** the registry memory modules (memory, recorder, consolidate, streaming) and the round-table client module.
