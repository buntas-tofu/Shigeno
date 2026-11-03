# Curated memory: the portable structured-fact layer

This folder is the canonical, in-tree home for the principal's structured memory: the frontmatter fact-cards that began in an agent harness's per-project memory stores. It was shifted in-tree on 2026-06-28 so the memory survives machine moves and renames, the same way the recap corpus already does.

## Two layers

- **Canonical (here):** `curated/*.md`, one fact per file, frontmatter format. This is the
  source of truth. It travels with the repository and survives any rename, because it lives inside the tree.
- **Harness mirror:** a per-project agent-harness memory directory. This is what the agent harness actually reads as live memory. It is a regenerable cache, re-seeded from here.

## Re-seed after any move or rename

```
DST=$HOME/.agent-harness/projects/<key>/memory
CURATED=<path to the curated layer>
mkdir -p "$DST"   # the harness garbage-collects an empty memory dir, so mkdir is required
find "$CURATED" -maxdepth 1 -name '*.md' \
  ! -name 'ARCHITECTURE.md' -exec cp {} "$DST"/ \;
```

`<key>` is the working directory with slashes rendered as dashes. One copy restores active memory on a fresh machine or after a rename.

`CURATED` is wherever the curated layer sits in your tree. The convention is the directory and its card shape, never one machine's layout: the layer is portable because it is a directory of files, and a path written into a re-seed command is the one part of it that is not.

Provenance: 2026-11-03, the example path is stated as a placeholder per the layout ruling of 2026-10-30. The principle is unchanged.

## _inbox/

`_inbox/<store-key>/` holds the raw union of the original per-project harness memory stores (54 cards across 9 stores), copied here provenance-intact, originals untouched. It is the input to a queued dedup-and-index pass (a small solver adapted to run on the resident fleet, free compute). That pass deduplicates the union, re-grounds stale paths, retires superseded cards, and promotes the result into canonical `curated/*.md` cards. Until then, the hand-authored canonical cards cover the cross-cutting essentials.
