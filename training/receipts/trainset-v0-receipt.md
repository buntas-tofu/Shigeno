# Training set v0 receipt (2026-08-22)

Source: the live session archive plus a corpus replica, identical day files
skipped by name and size before parsing.
Model: the serving base model. Pair window: 300 seconds.

Events read: 8634 (user turns plus model turns)
Pairs formed: 4147
Dropped as harness or smoke traffic: 4063
Dropped short (under 15 user or 40 assistant chars): 9
Orphaned turns (no partner in window): 331
Deduped: 75 to 64

Written: training set v0 (64 examples, chat format, persona system prompt)
Curation is heuristic and Tier 3; an expert eye over a sample is the gate
before any training run consumes this set.
