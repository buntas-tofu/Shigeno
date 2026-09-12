---
title: "Card discipline"
description: "How memory cards are written, promoted, superseded, and cited"
date: "2026-09-12"
tags: ["memory", "conventions", "cards"]
owners: ["buntas-tofu"]
status: "active"
provenance:
  last_reviewed: "2026-09-12"
  sources: ["prior design sessions"]
---

# Card discipline

A card is one durable fact, in one file, written so a later session can read
it cold and act on it. Cards are the structured layer of the memory
architecture: the journal is narrative, the captured layers are record, and
the cards are what a session can rely on without reading the rest.

This is the write discipline for that layer. It covers what a card holds, how
a card is created, why promotion is append-only, and what provenance a card
carries.

## What a card holds

- One fact per file. If a card needs the word "also" to arrive at its subject,
  it is two cards.
- Durable over point-in-time. A birthdate never rots; an age does. Write the
  fact that stays true and let volatile detail live in the journal.
- Authored text, read cold. A card is prose a future session reads without the
  conversation that produced it, so it stands alone, states its claim in the
  description line, and carries the style floor in full.

## The shape of a card

```yaml
---
name: durable-fact-slug
description: one line stating the fact
status: active
metadata:
  type: project
provenance:
  source: where the fact came from
  date: 2026-09-12
  supersedes: ""
---
```

- `name` is the file stem. Links between cards use it.
- `description` states the fact, not the topic. A reader should get the claim
  from the index line alone.
- `status` is `active` or `superseded`, nothing else.
- `metadata.type` is one of `user`, `feedback`, `project`, `reference`.
- `provenance` names the source and the date, and records the card this one
  replaces when it replaces one.
- Related cards are linked in the body as `[[name]]`, so a reader can walk the
  neighborhood of a fact from any card.

## Creating a card

1. Check for an existing card first. Update beats duplicate, always. A second
   card holding the same fact under a different name is the failure this step
   exists to prevent.
2. Write the card to the canonical location and add its line to the index in
   the same change. An index line without a card, or a card without an index
   line, is drift.
3. Record the source and the date in `provenance`. An unlabeled inference is
   not authority, and a card that does not say where its fact came from cannot
   be weighed against a later contradiction.

## Promotion is append-only

Promotion is the step that turns something a session noticed into a card that
counts. It has one direction and no in-place edit.

- A promoted card is never edited in place. Editing in place destroys the
  record of what the memory held before the correction, and it is exactly
  where silent drift enters: the card then reads as if it always said the new
  thing.
- A correction arrives as a new card. The new card sets `provenance.supersedes`
  to the old card's name, the old card's `status` becomes `superseded`, and
  both stay in the tree. The pair is the record of the change.
- Nothing becomes canonical without a promotion event that writes a file. A
  decision that lives only in a session or a working note is not memory yet,
  and a later session is free to contradict it.
- Removal is reserved for two cases: a card that was never promoted, and
  content that must not be retained at all. A card that is merely wrong is
  superseded, not deleted, because the wrongness is itself information about
  what the memory held.

## Provenance

Every card states three things: where the fact came from, when the card was
written, and what it replaced if anything. Provenance is what lets a later
session weigh a card instead of trusting it, and it is the only way a
correction can be traced back. A card with no provenance is a candidate at
best, and is labeled as one.

## The floor

A card is an artifact, so the style floor applies in full: no em dashes, no
ellipses, plain vocabulary. Mechanical rules are enforced by the linter in
continuous integration, not by re-reading every sentence at write time.

Worked examples of the shape live in `../examples/`.
