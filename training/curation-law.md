# The dataset curation law

Distilled from the training-set receipts. The law governs how session data
becomes a training set, in plain words.

1. Source by copy, not by reference. The set is built from copies of the
   session archive, never by mutating the archive itself. Identical day
   files are skipped by name and size before parsing.
2. Pair within a turn window. A user turn and the model's answer are paired
   only within a fixed window. A turn with no partner in the window is
   orphaned and set aside, not forced.
3. Drop the noise, always. Harness and smoke traffic never trains. Short
   turns (under set character floors) never train.
4. Deduplicate. Near-identical pairs collapse to one.
5. Label the curation honestly. Heuristic curation is Tier 3: a low-trust
   label. An expert eye over a sample is the gate before any training run
   consumes the set. No unexamined set trains.
6. Keep the set and the receipt together. The receipt records events read,
   pairs formed, drops, orphans, and the final count, so every number a
   later claim makes has an instrument.

Example receipts: the two v0 dataset receipts in receipts/.
