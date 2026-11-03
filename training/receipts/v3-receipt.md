# Adapter v3 training receipt (2026-09-02)

Base: Qwen3.8-27B HF bf16, loaded 4-bit on a 24 GiB consumer GPU (pinned)
Data: training set v3, 51 examples (41 from v2 plus 10 termination records),
  sole source
LoRA: rank 16, alpha 32, dropout 0.05, attention projections only
Train: 6 epochs, batch 1 with 4x accumulation, learning rate 1e-4 cosine:
  198 seconds, final loss 1.539 (v2 was 1.745)
Peak VRAM: 17.2 GiB of 24 GiB
Adapter: saved to the model shelf

Register: the v2 register unchanged; the stopping boundary taught by 10
open-prompt termination records. The tenth record answers the exact open
prompt that failed live, verbatim. All 51 records passed the provenance gate.

Next: convert to GGUF against the fixed converter, then A/B against the
current adapter, then operator ruling on a live swap.
