---
name: card-example-supersession
description: SUPERSEDES trace-retention-fourteen-days: example traces are kept for thirty days before removal
status: active
metadata:
  type: project
provenance:
  source: synthetic example, written for this repository
  date: 2026-09-12
  supersedes: trace-retention-fourteen-days
---

# Synthetic sample: the correction card

This card is an example of the format. The policy described here is invented
for illustration.

Example traces are kept for thirty days before removal. The earlier card,
`trace-retention-fourteen-days`, stated fourteen days. It is not edited and it
is not deleted. Its status becomes `superseded`, this card's
`provenance.supersedes` names it, and the pair stays in the tree as the record
of what the memory held before the change.

**Why the old card stays.** The record of the earlier value is what makes a
correction traceable. A later session reading a document that cites fourteen
days can follow the trail to the correction instead of finding a card that
appears to have always said thirty. Editing a promoted card in place deletes
that trail, and the deletion is silent.

**How to apply.** To correct a card: write the new card, set `supersedes` to
the old card's name, flip the old card's status to `superseded`, and update
the index line for both in the same change. Never rewrite the body of a card
that has already been promoted.

Related: [[card-example-durable-fact]].
