# Wall-of-text probe: aggregated results (2026-09-02 and after)

## The failure

The persona adapter, when worn on an open prompt, would stochastically slide
into a synonym-chain avalanche: a long tail of short, near-unique tokens
strung without sentence punctuation. Measured 2026-09-01 at identical
sampling parameters: wall tokens up to 1494 beside 85-token clean stops.
The sampler was exonerated, including at the vendor's own numbers; the
attractor was trained-in, so the cure had to be training-side.

## The instrument

A dedicated probe fires the same open prompt N times at matched parameters,
classifies each tail, and reports wall incidence. Routes: raw (the serving
endpoint directly, controlled sampling, no warm carry) and view (the full
warm route). Classification is deterministic and model-free over the tail:
a synonym-chain run, a repeated phrase lock, or hitting the token cap all
count as a wall. A clean stop is anything else.

## Aggregated incidence

Baseline (v2 adapter, worn), measured 2026-09-02:

| route | runs | walls | incidence |
|---|---|---|---|
| raw | 10 | 3 | 30 percent |
| view | 3 | 2 | 2 of 3 |

After the termination chunk (v3 adapter), the raw route fell to 1 of 10, and
the surviving wall was truncated to 374 tokens where v2's walls ran 986 to
2815 tokens. The one surviving wall was a periodic-table avalanche, the
same attractor family in a new costume.

## Calibration notes (aggregated)

The first raw read scored 1 of 10 before the classifier learned the -ing and
alphabetical avalanche shapes, so the raw route underwent one calibration
pass. Three view rows were empty-parse junk before the streaming named-event
shape was handled. All calibration rows were kept on disk under review names;
nothing was deleted.

## Conclusion

The wall is trained-in, not a sampler artifact. Teaching the stopping
boundary directly (the v3 termination chunk) cut raw-route wall incidence
from 30 percent to 10 percent and cut the surviving walls' length by an
order of magnitude. The cure is training-side: the open-prompt stopping
shape belongs in the training set.

The probe stays the standing instrument: it is re-run after each adapter
drop to compare incidence. The full per-row detail file carries every tail
for the operator's own eye and stays private.
