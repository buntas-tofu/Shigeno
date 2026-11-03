# Training set v0 receipt, second cut (2026-08-20)

Same source and method as the first v0 cut: live session archive plus a
corpus replica, identical day files skipped by name and size, pair window
300 seconds, on the serving base model.

Events read: 8547
Pairs formed: 4105
Dropped as harness or smoke traffic: 4055
Dropped short (under 15 user or 40 assistant chars): 3
Orphaned turns (no partner in window): 328
Deduped: 47 to 43

Written: training set v0 (43 examples, chat format, persona system prompt)
Curation is heuristic and Tier 3; an expert eye over a sample is the gate
before any training run consumes this set.
