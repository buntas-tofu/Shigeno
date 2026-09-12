# Distilled bench table (aggregates only)

The face bench scores a persona-facing candidate on entity, instruction, and
persona lanes, plus speed. Two reads per run, temperature 0, agreement
beside every score. These are aggregates; the raw per-anchor tapes stay
private.

## Scored lanes

| candidate | entity | instruction | persona | speed |
|---|---|---|---|---|
| bare incumbent (2026-08-07) | 12/12 | 10/12 | 9-10/10 | 184 tok/s |
| v1 A/B, bare side (2026-08-21) | 12/12 | 10/12 | 9.5/10 avg | 177-181 tok/s |
| v1 A/B, v1 adapter side | 12/12 | 10/12 | 9.0/10 avg | 159-160 tok/s |
| v2 (from the v3 A/B record) | 22/24 | 14/24 | 18/20 | not re-specified |
| v3 (bench port A/B) | 22/24 | 16/24 | 20/20 | not re-specified |

Entity and instruction held flat across v1: the adapter did not degrade
instruction-holding. Persona was a count wash for v1 but the transcripts
showed a flatter, shorter register and one reproducible persona-law
violation.

## Throughput cost

The v1 adapter cost about 11 percent of generation throughput (159 to 160
tokens per second worn versus 177 to 181 bare), consistent cold and warm,
and attributable on a controlled hot-swap lane where only the adapter scale
moved.

## The tool-lane failure and the reversal

A bench with a deferred lane does not measure a wash in that lane, it
measures nothing there. A control run on the same hot-swap lane found the v1
adapter called a tool correctly and then returned nothing, while the bare
base answered in one sentence. The adapter could call a tool and could not
answer from one. Disposition: reverted live with no restart; the adapter,
receipt, and weights kept on disk. The standing rule that followed: no
adapter gets benched for a register verdict without a tool lane, because the
register was never the risk worth measuring.

## v2 and v3

v3 improved on v2 on instruction and persona at matched scoring: 58 of 68
total versus 54 of 68, with instruction 16 of 24 versus 14 of 24 and persona
20 of 20 versus 18 of 20. The v3 numbers are aggregates carried from the v3
seed-set plan's A/B record. Final training loss fell from 1.745 (v2) to
1.539 (v3).
