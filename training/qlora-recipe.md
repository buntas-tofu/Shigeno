# A small-set QLoRA training recipe

A plain-words guide distilled from a persona-adapter training campaign. No
raw scripts and no raw data; this is the method, written down so a stranger
with a bench GPU could follow it. Receipts are cited throughout.

## 1. Start with a smoke run

Before any real training, prove the lane on a small 4-bit instruction model:
a few dozen steps, a small batch, and a small adapter. The smoke run answers
one question: does QLoRA train here at all? It validates the card, the
pinned GPU, the adapter save path, and the conversion step with minutes of
compute, not hours. A green smoke run is the gate to pulling the large base
weights. See receipts/smoke-receipt.md.

## 2. Curate the set by the law

Session data does not train itself. Apply the curation law
(curation-law.md): copy, pair within a window, drop harness and smoke
traffic, drop short turns, dedupe, and label the result as Tier 3 heuristic.
Every receipt records events read, pairs formed, and drops. A sample is
always reviewed by an expert eye before it trains. See the two v0 dataset
receipts in receipts/.

## 3. Design for the failure you have

The first version trained short single-turn examples, and the model learned
to open a turn but never to close one. Under a continuing conversation it
kept generating. The fix was to teach termination directly: multi-turn
pairs where a short answer is followed by another user turn teach "pour
once, hand it back, wait." When a specific live prompt fails, the pure open
invitation shape, put that shape in the set with a taught ending. One lesson
is a boundary, and a complete answer can be short. See the two seed-set
plans in seed-set-plans/.

## 4. Two stages, then the mount

Smoke first, then the full set. Train at a modest rank on attention
projections only, a fixed number of epochs, and a cosine learning-rate
schedule. Record final loss, wall-clock time, and peak VRAM in the receipt.
Convert the adapter with a converter that is known to match the base model
family; a stale converter produced a mis-map that was pinned and then fixed
before the next conversion. See the three adapter receipts in receipts/.

## 5. Measure on a controlled lane

Do not judge an adapter on a register feel alone. Use a standing instrument
with one candidate at a time, two reads, temperature 0, and agreement beside
every score. Price throughput on a hot-swap lane where only the adapter
scale moves, so a throughput delta is attributable. And include a tool lane:
a bench with a deferred lane measures nothing there, and the first adapter
survived its register wash while failing to answer from a tool result,
which is what got it reverted. See ab-test-card.md and bench-results.md.

## 6. A/B card, then the operator rules

The measured numbers earn the mount or not, but the register decision is a
human ear on the timing. The hot-swap lane lets a candidate be judged and
reverted in minutes with no restart. A candidate that holds capability and
adds a trained-in failure goes back to training with a named lesson. See
ab-test-card.md.

## Receipts in this chapter

- v1, v2, v3 adapter receipts: receipts/
- smoke receipt: receipts/smoke-receipt.md
- dataset receipts: receipts/trainset-v0-receipt.md and
  receipts/trainset-v0-gemma-receipt.md
- the A/B card: ab-test-card.md
- wall-of-text results: wall-probe-results.md
- bench aggregates: bench-results.md
