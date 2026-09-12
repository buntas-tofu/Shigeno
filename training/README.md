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
