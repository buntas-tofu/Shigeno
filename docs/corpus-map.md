# The memory corpus: map and conventions

The served memory corpus (the keeper serves it to the agents) and the session
agent's long-term memory home. Everything here is gathered as copies; originals
stay in their repos. This map carries roles and conventions, not counts (counts rot; `ls` is ground truth). Floor: no
em dashes, no ellipses.

As of 2026-07-02. Stocked 2026-06-28 from a full multi-provider AI history plus the
loose recap pile; two credential files that arrived with the bulk move were pulled out
by the principal. The heavy dedup, re-ground, and index work remains a queued pass,
not a hand-merge.

## Reading order (boot)

1. `curated/MEMORY.md`  the card index (auto-loaded via the harness mirror)
2. `recaps/journal/`  the newest `session_recap_*.md`, the narrative now
3. This file, then the room the session needs.

## Rooms

Every room carries its own profile file: conventions, contents, and pointers. It
auto-loads when a session opens inside that room, and it is one read away otherwise.

- `TOOLS.md`  the tools catalog, GENERATED not maintained (a walker reads each tool's own
  docstring, run by a scheduled job).
  Backward-declare, forward-derive: each tool carries its own docstring and the walker
  builds the index, so it cannot drift from the tools it describes. If something is
  missing there the fix is a docstring in that tool, never a line in the index. Chosen
  2026-07-30 on measurement: 92 percent of tools already self-declared while 12 percent
  appeared in any maintained index.
- `curated/`  canonical structured fact-cards, one fact per file, frontmatter format. The harness store mirrors it; see `curated-cards.md` for
  the two-layer model and the re-seed. `curated/_inbox/` holds the raw union of the prior nine harness
  stores, staged for the fabric dedup pass.
- `recaps/journal/`  the journal, the conductor's logbook and narrative system of
  record, live: new entries land here as `session_recap_YYYY-MM-DD_slug.md` and the
  dated stream sorts lexically. Undated and timeless pieces (origin story, spine,
  build standards) live in `journal/lore/`.
- `recaps/scattered/`  gathered one-off recaps, handoffs, fabric-state, reviews, and
  summaries from across the projects, named `cluster__repo__file.md`. Where cluster work
  lives in the corpus; the journal references it at altitude, never absorbs it by copy.
- `exports/`  raw session and provider exports, sub-roomed: `sessions/` (gathered session txts plus the provider bundle exports; the sweep
  deposits here), `providers/`
  (the big multi-provider dumps; index the JSON text, skip the audio), `extracts/`
  (hand-distilled summaries, source-named per export; the old `-b` files were a second
  EXPORT, not a second pass, so nothing merges),
  `artifacts/` (raw platform export files, provenance).
- `sediment/`  the fabric memory logs, single-homed on the recording node: the live
  replica is pulled nightly by `tools/gather-sediment.sh`. An earlier era's stream
  lives on in the sink mirror at `telemetry/legacy-sink/sediment/`; an older loose
  copy in this root was retired 2026-07-05 as redundant with the live replica. The
  corpus is the identity store's backup.
- `telemetry/`  the instrument tape: `odometer/` holds every node's usage stream (each
  node records to its own live store since the 2026-07-05 sink port), and
  `legacy-sink/` is a frozen pre-port archive. Feeds the aggregate build's memory
  system; the design conversation is queued.
- `logs/`  desktop and cowork diagnostic exhaust (the desktop app, mcp servers,
  system info). Kept for forensics; not memory proper.
- `tools/`  corpus tooling. `gather-strays.sh` sweeps the clusters for new session
  exports, recaps, and handoffs and copies them home, idempotently. Run it any time; it reports what it gathered. `family-drift.py` is a
  copy-inheritance smoke
  detector (landed 2026-07-11): a scheduled job regenerates
  `logs/family-drift-latest.md` before every report and the weekly deep edition
  folds the verdict in.

## Standing rule

Anything anywhere that smells like a recap, extract, or export gets gathered home as a
copy, prefix-named for its source. One local documents folder is kept empty by
design; gather from it by hand with a `documents__` prefix when something surfaces.
