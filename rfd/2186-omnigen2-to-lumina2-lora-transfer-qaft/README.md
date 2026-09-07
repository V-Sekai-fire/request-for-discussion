# RFD 2186: Transfer OmniGen2's image-edit capability into a Lumina2 LoRA via QAFT-4bit
**State:** discussion
**Feature:** move OmniGen2's slow-but-image-edit-capable behaviour into
Lumina2's fast-but-text-to-image-only runtime, via distillation loss on
paired (source, instruction, OmniGen2-edit) triples, LoRA on nf4-quantized
Lumina2 base
**Scope:** `3-interactor/omnigen2/artifacts/lumina2-distill/o2_teacher/`;
deliverable is a Lumina2 LoRA that turns Lumina2 into an image editor

## Decision

Two-stage feasibility probe. **Do not** commit to a full training run
until stage 2 shows a signal.

`DETAILS.md` carries the milestones, verification, scope revisions and what is not in this RFD.

## Problem

Measured this session:

## Related

- **RFD 2184** (sdcpp OmniGen2 port): the parallel speedup path.
  Complementary; either can land without the other.
- **RFD 2185** (Flow-LCM + QAFT-nf4 for Lumina2): established the
  training mechanism (nf4 base + LoRA + distillation loss) this RFD
  extends to a different loss objective (image-edit distillation
  instead of endpoint consistency).
- Memory: [[editscore-api-surface]], [[pq-only-single-image-blocklisted]],
  [[three-model-vram-serialization]].

This RFD was drafted by an AI and read by a human before it shipped.
