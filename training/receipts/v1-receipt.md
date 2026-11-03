# Adapter v1 training receipt (2026-08-29)

Base: Qwen3.8-27B HF bf16, loaded 4-bit on a 24 GiB consumer GPU (pinned)
Data: training set v0, 48 examples, the persona system prompt, chat template
LoRA: rank 16, alpha 32, dropout 0.05, attention projections only
Train: 6 epochs, batch 1 with 4x accumulation, learning rate 1e-4 cosine:
  663 seconds, final loss 2.107
Peak VRAM: 18.4 GiB of 24 GiB
Adapter: saved to the model shelf

Next: convert to GGUF, mount the adapter on the serve script, then run the
A/B against the bare base.
