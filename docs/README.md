# Shigeno design documents

The design documents for the memory architecture: what it remembers, how a session
reads it, and how the corpus keeps improving without anyone maintaining it by hand.

Architecture only, never data. These files describe the pattern and the rules. The
live stores stay where they live, and nothing copies across that line.

## Index

- [master-memory-architecture.md](master-memory-architecture.md) - the flagship
  design. Persistence as time-addressed revelation, the inverse-roles engine, the
  tagging axes, and the staged build marks.
- [memory-spine.md](memory-spine.md) - the anchor doc. The four laws, the shipped
  state with dates, and the curation rules for what enters the memory.
- [enrichment-loop.md](enrichment-loop.md) - the consent-driven intake valve. One
  press, one question, answered and folded back into the corpus, with a registry
  that stops the questions from repeating.
- [enrichment-sitting.md](enrichment-sitting.md) - a draft revision that serves
  five questions in one sitting. For review, not settled.
- [curated-cards.md](curated-cards.md) - the portable structured-fact layer. The
  two-layer card store and the re-seed that restores it on a fresh machine.
- [corpus-map.md](corpus-map.md) - the room map and the conventions for what
  enters each layer.

## Reading order

Start with the master architecture, then the spine. The two enrichment docs come
next, and they read together: the loop is the shipped mechanism, the sitting is the
proposed longer form. The card layer and the corpus map are reference material.

## Other rooms

The rest of the repository hangs off this design: `conventions/` for the card write
discipline, `examples/` for sample cards, `training/` for the adapter chapter and its
receipts, and `tools/` for the corpus tooling the corpus map describes.
