# Persona adapter v3, seed set plan: the termination chunk (2026-09-02)

Draft for the operator's eye. These records teach one behavior the v2
adapter under-learned: where the reply ends.

## Why this fixes v2

v2's 41 dense register records taught the persona strongly and the stopping
boundary weakly. On open prompts the face slides stochastically into
synonym-chain avalanches (measured 2026-09-01: wall tokens up to 1494 beside
85-token clean stops at identical sampling parameters). The sampler is
exonerated, including at the vendor's own numbers; the attractor is
trained-in, so the cure is training-side. v2's multi-turn pairs already
teach short answers followed by another user turn, but none of its user
turns is the pure open invitation, the exact shape that triggers the wall.
v3 adds that shape directly.

## Shape (operator ruling, 2026-09-02)

41 approved v2 records unchanged, plus a new termination chunk of ten
records: each an open-ended prompt answered completely and stopped at a
natural stopping point, in the register. Warm, direct, one view stated,
often one probe at the end, and then nothing more. The lesson is the
boundary itself: a complete answer can be short.

The tenth record answers the exact open prompt that failed live, so the
shape that failed has a taught ending.

## System prompt

The v2 system prompt, byte for byte, in every record. No register drift
rides in with the termination lesson.

## Validation metric

Wall incidence over N repeats of the wall prompt at matched parameters,
with at least one probe through the full warm route, since the warm context
may raise incidence versus bare-seat pokes. The instrument exists and is
calibrated.

## Baseline measured 2026-09-02 (v2 adapter, live)

Raw route (controlled sampling, N=10): 3 of 10 walls, a 30 percent
incidence. View route (warm carry, N=3): 2 of 3 walls. The view-route walls
were run-on drift tails rather than pure synonym chains; the classifier
reads both as walls. One calibration pass was banked to review: the first
raw read scored 1 of 10 before the classifier learned the -ing and
alphabetical avalanche shapes, and three view rows were empty-parse junk
before the streaming named-event shape was handled. All kept on disk,
nothing deleted.

## File layout

- This plan
- The termination chunk: 10 records, OpenAI chat format
- The review view

## Status (2026-09-03)

Chunk approved and trained, A/B complete, live swap pending the operator's
ruling. The operator approved the chunk verbatim. Assembled training set
v3, 51 records, provenance gate ready 51 of 51 on the first pass (pure
authored prose, zero disqualifying markers, full provenance), trained 198
seconds on the bench GPU at 6 epochs (final loss 1.539 versus v2's 1.745;
the termination records fit easier, the lesson absorbed), converted 128
tensors with the fixed in-tree converter. A/B on the bench port: 58 of 68
total (entity 22 of 24, instruction 16 of 24, persona 20 of 20; v2 was 54
of 68, entity 22 of 24, instruction 14 of 24, persona 18 of 20), and wall
incidence on the raw route fell from 3 of 10 to 1 of 10, with the surviving
wall truncated to 374 tokens where v2's ran 986 to 2815. The one surviving
wall was a periodic-table avalanche, the same attractor family in a new
costume. Pending: the operator's ruling on wearing v3 live, then a
view-route wall probe on the mounted adapter.
