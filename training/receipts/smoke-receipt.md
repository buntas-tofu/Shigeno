# Smoke receipt: QLoRA trains on the bench GPU (2026-08-20)

Vessel: a small 4-bit instruction model (smoke-sized; the large base pull
was step two)
Card: NVIDIA RTX 4090 (pinned)
30 steps, batch 4: 88 seconds, final loss 4.938
Peak VRAM: 3.2 GiB of 24 GiB
Adapter saved: smoke adapter, 34 MiB

Verdict: the training lane is open. Next: pull the large base weights, then
cut training set v0 from the session archive plus the persona system prompt.
