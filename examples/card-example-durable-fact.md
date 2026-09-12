---
name: card-example-durable-fact
description: The example corpus is one directory on the recording host; a second copy exists only after a gather runs
status: active
metadata:
  type: project
provenance:
  source: synthetic example, written for this repository
  date: 2026-09-12
  supersedes: ""
---

# Synthetic sample: the everyday card

This card is an example of the format. The subject, the host name, and every
figure in it are invented.

The example corpus lives in a single directory on the recording host. Nothing
replicates it on its own. A second copy exists only after a gather runs, and a
gather that fails leaves the corpus where it was rather than half copied. The
gather tool reports failures in its exit code for exactly that reason, so a
scheduled run that quietly could not reach the recording host is visible the
next morning.

**Why this is durable.** The claim is about the design, not about a snapshot.
The directory can move and the log line count can change without making the
card wrong. A card stating how many files the corpus held on one particular
day would have rotted within a week, and the count belongs in the journal.

**How to apply.** Treat the recording host as the only place the corpus is
whole. A second copy is a result of a gather, so check the gather result
before assuming two copies exist. If a session needs the corpus elsewhere for
a while, copy it deliberately and note the copy in the journal rather than
assuming replication happened.

Related: [[card-example-reference]].
