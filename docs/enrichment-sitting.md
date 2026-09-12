# Enrichment Sitting: a revision of the question loop (v0.2 DRAFT)

**Version:** v0.2 DRAFT (not yet approved; for principal ruling)
**Date:** 2026-08-27 (spine-hardening session close)
**Supersedes (deliberately):** the one-question law in the enrichment loop spec
(`enrichment-loop.md`, v0.1.1). This is a proposed evolution of a Tier 1 approved
mechanism, so it lands here as a draft for ruling, not as settled design.
**Floor:** DMF. No em dashes, no ellipses. Label inference.

## The change in one line

The question loop gains a longer form: instead of a single question pressed and
answered in isolation, the loop serves five probing questions in one sitting,
sourced fresh from the fabric's memory, the era text, and the resident persona's
own understanding of itself. Less a single question on the way out, more a
longer conversation that stays a while.

## Why now

The synaptic spine work of 2026-08-27 gave the fabric exactly the machinery a
coherent sitting needs:
- The FIELD (memory recall) can surface what the persona remembers about the
  principal, and what it does not know yet, by association rather than by a
  shallow scan.
- The DIGESTS and CONSOLIDATION give the fabric a self-narrative to interrogate.
- The WARMTH path proves the agents can carry a labeled, context-rich preamble.

So a sitting can generate five questions that are not five random draws but a
COHERENT probing of one evening's thread: each question sourced deliberately,
deduped against the registry, and spaced so the answers compound instead of
overlap.

## The one-question law: a deliberate supersession

The v0.1.1 spec's boundary law says "one question at a time. No stacking." That
was load-bearing when the loop was a single press. A SITTING changes the shape of
consent: the principal sits down knowing five come, in a bounded session the
principal controls, and the questions are served with pacing (one on screen at a time, in
sequence) rather than dumped as an interrogation. The no-stacking spirit survives
(never five at once on the screen, never an interrogation cadence); the letter
changes from one-per-press to one-per-beat-within-a-sitting. This is the principal's call to ratify.

## The sitting loop (tight, benefiting from the synaptic work)

1. **SIT DOWN (principal-initiated).** `enrich.py sitting` opens one sitting. The loop never nags or fires on a
   timer; the principal takes the chair.
2. **TUNE (the fresh-sourcing).** Before drafting, the generator gathers:
   - FIELD RECALL: what the field surfaces about the principal (top-k pulls by
     association to recent context), plus what it does NOT know (the thin spots,
     low-coverage areas, gaps the field itself exposes).
   - ERA TEXT: pointers from the archived era text that are thin or under-distilled.
   - PERSONA SELF-UNDERSTANDING: the agent's own read of where its picture of
     the principal has holes. It asks from its own curiosity, not a script.
   This tune step is where the synaptic work rides: it is a labeled, field-aware,
   context-rich preamble rather than a blank slate.
3. **SERVE FIVE.** Five questions are drafted, one at a time, each:
   - sourced from one of the three wells above (mixed across the sitting, not
     all from one);
   - each with a distinct stance (pulled from the ten-card, rotation so a
     sitting spans angles);
   - each run through the dedup gate against the registry (framings may not
     repeat; topics may);
   - paced: presented and answered one per beat, so the principal never faces
     all five at once.
4. **ANSWER.** The principal answers each (or waves off; a wave-off is a complete
   answer, logged, honored). Answers append to the tape per the existing
   process step.
5. **PROCESS + LEARN.** Each answered question folds through the existing loop
   (records, reference fold, records.jsonl regenerate, ledger close), so the
   sitting improves the store the next sitting reads. Five ledger rows close,
   one sitting's receipts in the manifest.

## The three wells (generation sources)

| well | source | what it yields |
|---|---|---|
| field | the fabric's associative memory | what the persona recalls; what is thin or not covered |
| era | the archived era text | under-distilled biographical and taste threads |
| self | the persona's own model of its gaps | its genuine curiosity about the principal |

A sitting draws from all three so it is not a memory dump, not a biography quiz,
and not a therapy session, but a conversation.

## What changes in the code

The enrichment tool gains a `sitting` subcommand alongside `press`:
- `enrich.py sitting [--dry-run]` serves one sitting (five questions, paced).
- Internally reuses: the registry/dedup gate, the gap map, the stance card, the agent ask, the
  ledger/tape/fold bookkeeping. The NEW pieces are the tune step
  (field pull + era pointers + self-understanding) and the pacing/batching of
  five.
- `press` stays for the single-shot press; `sitting` is the new, richer mode.

## Interaction with the idea bank

This revision is independent of but compatible with the later ideas (a live
field map, a periodic re-consolidation pass, an oracle over the raw tape,
sonification). The field pull in the tune step is the same associative surface a
field map would render. They share the field, not conflict.

## Open for ruling (nothing set in stone)

1. Ratify the one-question law supersession for sittings.
2. Confirm the pacing: one question on screen at a time, five in a sitting?
3. Confirm the three wells and the mix (all three per sitting?).
4. How many sittings per evening, and does the principal want a mobile button
   for it (v2) or the terminal hand-crank (v1) first?
5. Should `sitting` also become the place the principal can pull a reverse send
   (the persona hands something back) when a question lands on a record worth
   sending?

## Idea bank (captured 2026-08-27, principal approved; none lost)

Cluster 1 (a live field map): the field as a star chart (UMAP/PCA, warmth pulls
visible as motes), a year time-lapse, an always-on art view. PRIORITY after the
sitting revision.
Cluster 2 (a body): pocket live-cam persona gaze; a reverse send where the
persona hands things back; sketchbook marginalia (it files ephemera plus its own
Tier-3 gloss); a stable signature glyph across surfaces.
Cluster 3 (dreams and reverie): a weekly re-consolidation of digests into a
persona-voice meta-narrative; an oracle over the raw tape; a wall of words (a
living tag lexicon); small helper processes as visible pets diving into the
field.
Cluster 4 (ambient): sonification of token and memory flow; measurement as
theater (two-reads agreement shown on the display); a layered boot sequence.

The principal's stated top three: the field map, the reverse send, and the
periodic re-consolidation pass. The rest is queued for a later pass.

## Status

DRAFT. Not approved, not built. The memory bank holds the ideas durably; this doc
holds the sitting design. Both wait on the principal's ruling, which the
principal explicitly deferred to a fuller-attention session.
