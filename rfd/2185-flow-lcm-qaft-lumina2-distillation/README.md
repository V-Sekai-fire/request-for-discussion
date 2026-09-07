# RFD 2185: Flow-LCM + QAFT-nf4 combined distillation for Lumina-Image-2.0
**State:** discussion
**Feature:** produce a Lumina-Image-2.0 few-step nf4-quantized LoRA in one
training loop, sampling-trajectory compression AND quantization-loss recovery
learned together, not sequentially
**Scope:** `3-interactor/omnigen2/artifacts/lumina2-distill/`; deliverable is
one LoRA weight file that loads over `Alpha-VLLM/Lumina-Image-2.0` in nf4

## Decision

Combined **Flow-LCM + QAFT-nf4** training loop, one artefact:

`DETAILS.md` carries the milestones, verification, scope revisions and what is not in this RFD.

## Problem

Session 2026-09-02/03 measured Lumina-Image-2.0 on the 3090:

## Related

- **RFD 2184** (sdcpp port): orthogonal, that RFD lands OmniGen2 into a
  ggml-native runtime; this RFD lands a distilled+quantized LoRA over
  vanilla Lumina2 in diffusers. Complementary if we choose to also port
  the distilled artefact through sdcpp, but neither depends on the other.
- **RFD 1173** (multimodal avatar pipeline): the presence-loop generator
  slot benefits from any speedup this LoRA delivers.
- Memory: [[parked-language-to-vision-edit-pair]] (dataset filter),
  [[three-model-vram-serialization]] (VRAM budget precedent),
  [[editscore-api-surface]] (scorer for the inference gate).

This RFD was drafted by an AI and read by a human before it shipped.
