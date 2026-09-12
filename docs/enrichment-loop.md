# Enrichment Loop: the consent-driven intake valve

**Version:** v0.1.1 WORKING
**Date:** 2026-07-16 (v0.1.1 same day: approval, registry law, stance inheritance, round one folded)
**Approval:** Tier 1, principal, 2026-07-16. The loop runs one question at a time,
at session close, and its shape matches the front desk's closing exchange.
**Status:** commissioned by the principal as a one-press function that generates a
new question from what the store already knows, then starts a storage and processing
loop when the answer comes back. Exercised the same day: round one asked, answered,
and folded end to end (q-0001, an origin thread, one correction landed). Tier 1: the
mechanism is wanted and the registry law below is the principal's own ruling;
everything else is Tier 2/3 design for iteration.
**Lineage:** an earlier enrichment campaign (53 prompts, 10 sessions, closed out
cleanly) reborn as a live mechanism. A 2026-07-16 mining run proved the
precondition: agents can read the store and surface what is missing.
**Floor:** DMF. No em dashes, no ellipses. Label inference.

## What it is

A self-improving intake valve for the corpus. One press, one question, sourced
from what the store knows and (more importantly) what it knows it is missing.
The principal answers; the answer is Tier 1 source material; the loop processes
it into the corpus shapes the fabric already eats (module records, references,
regenerated records.jsonl, eventually reveal extracts). The store improves, so
the next question improves. Honest framing of "self-improving": the loop
converges the map toward the territory; it does not modify its own machinery.
Re-asking an answered question converges to the same record (the ledger
deduplicates), which is the idempotency property applied to intake.

## The loop (five steps)

1. **PRESS.** Principal-initiated, always. The loop never interrupts, never
   nags, never fires on a timer. Consent is the button itself.
2. **ASK.** The generator reads the used-questions registry, the ledger, and
   the gap map, pulls a stance at random from the stance card, and emits ONE
   question that clears the dedup gate, with provenance (which gap, which flag,
   which stance, and the dedup receipt). No stacking. Modes:
   - **new-ground:** open an explicitly flagged blank (an "open question" line,
     a "banked for future surfacing" note, a "largest untouched period" flag).
   - **verify:** hold up a low-grade or grade-lean record ("the record claims X
     at T1; confirm, correct, or demote"). This mode gives the taste-pilot
     verdict backlog a standing home.
   - **sharpen:** resolve a contradiction or cross-module drift.
   - **refresh:** re-date a stale fact in a fast-moving domain.
3. **ANSWER.** The principal answers at any depth, or waves off. Wave-offs are
   logged as no-go signal and teach the generator; they are never argued with.
4. **PROCESS.** The storage loop:
   a. Tape: verbatim answer appended to `corpus/enrichment/tape_YYYYMM.jsonl`
      (append-only, with question id, date, mode). The tape is the loop's
      canonical session record, the earlier campaign pattern in file form.
   b. Records: facts minted into the target module's JSON records (agent-drafted
      under schema validation per the harness pattern, judgment-verified),
      evidence grade Verified (principal-stated), provenance `enrichment-loop`
      plus the question id.
   c. Reference fold: the relevant WORKING reference gains the material where
      it changes the picture (WORKING iterates freely; CANON stays Tier 1).
   d. Cards: a curated card only if the fact is operational for sessions.
   e. Regenerate `records.jsonl` (`tools/build_records.py`), receipts in the
      ledger row.
5. **LEARN.** The ledger row closes (asked, answered or waved, folded, record
   ids). The next press reads a fresher map.

## The registry law (Tier 1, principal, 2026-07-16)

The old campaign's documented failure mode: late rounds got repetitive or lost
track entirely (v0.6.0's own postmortem says 53 was too many to hold cleanly;
the principal's account matches). The cure is determinism in inquiry
generation, and the principal's ruling is precise: never seed new question
banks, but maintain a master list of used questions, hash-identified, and
generate against it.

- **The registry:** `corpus/enrichment/USED_QUESTIONS.jsonl`. One row per
  question across every generation: uqid, generation, code, verbatim text,
  stance (where tagged), topic tags, status (asked | designed_unasked |
  withdrawn), asked_in, sha256 of normalized text. Seeded 2026-07-16 with 79
  rows: 53 asked (v0.5.0, session-mapped from the tracking final), 25 designed
  and never asked (v0.6.0 Wave 1), plus the loop's own q-0001.
- **The dedup gate, applied at every press:** exact hash match refuses
  outright; similar framing gets reduced (v0: the generator reads the registry
  and names the nearest prior framings in the press receipt; v1: the local
  vectorizer embeds the registry and a similarity threshold does it
  deterministically). Topics may repeat forever; framings may not. A new stance
  on an old topic is legitimate by design.
- **The designed-unasked rule:** if a press lands on a (gap, stance) pair that
  already has a designed-unasked prompt from the sealed campaign, the loop asks
  THAT prompt verbatim and credits its code. Honoring the backlog is not
  seeding; the first actual ask of a designed question is a first ask.
- **Determinism receipts:** every press records the stance pulled, the gap
  chosen, the registry rows consulted, and the nearest-neighbor framings. The
  inquiry generation becomes auditable, which is what deterministic means here.

## The stance card (inherited whole from v0.6.0, the principal's own design)

Ten stances, pulled at random per press; the randomness is the feature and the
rotation prevents the loop from settling into a default angle: S Silence,
E Embodied, R Relational triangulation, M Meta-on-framework, C Compression,
D Domain transfer, A Absurdity, T Mortality filter, P Provocation, F Failure
autopsy. Stance definitions live in the sealed enrichment prompt set (read-only
reference material); the card carries here by reference. Waves of 25 remain
available as a campaign mode (v2) when the principal wants a batch rather than a
single press.

## The gap ladder (generation heuristics, in preference order)

a. Explicit flags already in the references: open-questions sections, "banked
   for future surfacing," "largest untouched," the format spec's own gap
   register.
b. Low epistemic grades: inferred and thin-ice records wanting verification;
   grade-lean batches (the taste pilot's T1 lean).
c. Contradiction and cross-module drift (the earlier watchlist made active).
d. Staleness: dated facts in fast domains (business numbers, rosters, health of
   projects).
e. Thin-by-importance: sections whose weight in the life exceeds their weight
   in the record.

## Boundary law (load-bearing, non-negotiable)

- The locked cabinet is out of generator scope: the sensitive family shelf
  (health, trauma, finances, decline) is never fished for. The principal can
  always volunteer and steer; the door opens only from the principal's side.
- Data minimization (GLOBAL Section 9) governs: the loop asks about what is
  already in scope, at the altitude the record already holds it.
- Family-tone floor applies to question wording. One question at a time. No
  stacking, no interrogation cadence.
- A wave-off is a complete answer. Logged, honored, not revisited unless the principal reopens it.

## Routing (who does what, by version)

- **v0 (now, the game-out):** conversational hand-crank. The session agent
  generates from the gap ladder, the principal answers in session, the agent runs
  the processing loop with receipts. Proves the shapes.
- **v1 (fabric-native):** generation drafted by a second agent (store content
  pushed inline until the keeper read-roots fix lands), processing agent-drafted
  under schema validation with judgment verification. The principal remains the only
  Tier 1 source. Free local compute on the resident fleet.
- **v2 (the button proper):** a view route plus a mobile button, and the exchange
  lands at the front desk: the resident persona asks the question. A front-desk
  agent interviewing the principal is the mechanism personified. Shape: a press
  at session close, one question, banked.

## Files

- `corpus/enrichment/LEDGER.jsonl`: one row per question (qid, date, mode, gap
  source, question text, status: asked | answered | waved | folded, minted
  record ids, receipts note). The generator reads it first; it is the loop's
  memory of itself.
- `corpus/enrichment/USED_QUESTIONS.jsonl`: the registry (see the registry law).
- `corpus/enrichment/tape_YYYYMM.jsonl`: the verbatim answers, append-only.
  Source-code convention for provenance tags in references and records:
  `[ENRICH-qNNNN]`, the loop's equivalent of the older capture codes.
- This spec. The button surface lands in the runtime when v2 builds.

## Open items (the docket)

1. Settled: the loop is approved (Tier 1, 2026-07-16).
2. Tape privacy cadence: periodic principal review of the tape against the
   locked-cabinet rule, since answers arrive at whatever depth the principal chooses.
6. Archive generations sweep: the pre-v0.5.0 question sets (CONTENT_QUESTIONS
   v0.2.x through v0.3.7, ENRICHMENT_PROMPTS v0.4.0, in the sealed archive)
   get extracted into the registry by a fabric lane; running 2026-07-16.
7. Reference version-bump policy: loop folds currently land in the WORKING
   reference in place with [ENRICH] tags; when a bump ships is the principal's
   call per distillation pass, not per fact.
3. Reveal extracts: when the persona warmth era wants corpus-fed extracts, the
   loop's records ride in automatically; budgets per the persona config.
4. Whether verify-mode should batch (five records, one press) for backlog
   clearing: against the one-question law; probably a distinct "verdict mode"
   with its own consent shape.
5. Auto-grading of minted records by a second agent (drafter and grader split),
   per the judgment-harness pattern.
