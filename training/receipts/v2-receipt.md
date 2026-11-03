# Adapter v2 training receipt (2026-09-01)

Base: Qwen3.8-27B HF bf16, loaded 4-bit on a 24 GiB consumer GPU (pinned)
Data: seed set v2, 41 examples, operator-approved, sole source
LoRA: rank 16, alpha 32, dropout 0.05, attention projections only
Train: 6 epochs, batch 1 with 4x accumulation, learning rate 1e-4 cosine:
  191 seconds, final loss 1.745
Peak VRAM: 17.2 GiB of 24 GiB
Adapter: saved to the model shelf

Register: co-ownership and Socratic probing, taught in the system prompt of
every record plus three dedicated examples. Five termination pairs. All 41
records passed the provenance gate.

Next: convert to GGUF against the fixed converter, then A/B against the
current adapter, then operator ruling on a live swap.
