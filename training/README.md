# Training

The adapter training chapter. This is a de-identified, aggregated record of
a small QLoRA fine-tuning experiment that shaped the memory architecture's
persona adapter. It carries receipts, plans, and measured numbers only. No
raw training sets, no transcripts, no prompt verbatims, and no persona
identity material appear here.

The experiment in one paragraph. A base instruction model was fine-tuned
with a small adapter on a small hand-curated set to shape a persona register
and fix a generation failure. Three adapter versions were trained and
measured. Each version's training receipt carries the aggregate numbers.
The generation failure was a wall-of-text pattern where the model generated
long synonym-chain tails on open prompts. The cure was training-side, not
sampling-side: a termination chunk taught the stopping boundary.

## Contents

- receipts/   three adapter training receipts plus the smoke and dataset receipts
- ab-test-card.md   the A/B measurement instrument and the standing law
- seed-set-plans/   the seed-set authoring plans for v2 and v3
- wall-probe-results.md   aggregated wall-of-text incidence, before and after the cure
- bench-results.md   distilled aggregate bench table across adapter versions
- curation-law.md   the dataset curation law distilled from the receipts
- qlora-recipe.md   a plain-words guide to the whole training approach

All numbers are aggregates reproducible from this chapter's own files or
from the receipts they cite. The estate originals stay private.

## A note on the dataset counts

Added 2026-11-03, per the reconciliation ruling of 2026-10-30. The receipt
bodies are not edited, so one number in them reads against the others.
`receipts/v1-receipt.md` records the training data as "v0, 48 examples", and
the two committed v0 receipts report 64 and 43. There were three cuts, not one,
and each figure belongs to its own source:

- 64 examples: the first cut, built from the session archive plus the corpus
  replica described in `receipts/trainset-v0-receipt.md`.
- 43 examples: the second cut, the gemma variant of the same source and method,
  in `receipts/trainset-v0-gemma-receipt.md`.
- 48 examples: the de-censused cut, which is the one v1 trained on.

This note is the only place the three are named together. A reader who wants
the count for a version should read that version's receipt, not this paragraph.

## Where this chapter ends

The receipts document the August lineage: one 27B base, loaded 4-bit on a single
24 GiB card. The base has changed since, and an adapter is bound to the base it
trained on, so a base swap means retraining rather than retuning. That does not
age the chapter. The law it records, a receipt for every number and an expert
eye over a sample before any set trains, carries forward to whatever base runs
now. The numbers are history. The method is current.
