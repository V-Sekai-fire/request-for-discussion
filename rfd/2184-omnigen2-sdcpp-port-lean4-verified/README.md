# RFD 2184: Port OmniGen2's Lumina2 DiT into stable-diffusion.cpp, Lean4-verified
**State:** discussion
**Feature:** GGUF Q4_K_M inference of OmniGen2 via stable-diffusion.cpp, with
Lean4 proofs certifying the ggml graph agrees with the PyTorch reference
**Scope:** new project `3-interactor/omnigen2-sdcpp-port` (C++/ggml + Lean4);
new upstream mirror `3-interactor/stable-diffusion-cpp-upstream`

## Decision

Add a Lumina2 block family to stable-diffusion.cpp, then compose the
OmniGen2 DiT out of those blocks, then land the GGUF weight loader that
maps `calcuis/omnigen2-gguf`'s Q4_K_M safetensors to ggml tensors.

`DETAILS.md` carries the milestones, verification, scope revisions and what is not in this RFD.

## Problem

Session 2026-09-02 measured OmniGen2 on the 3090:

## Related

- **RFD 2158 (abandoned)**, Lean 4 FBD compiler self-host, whose Stage
  0-1 work established the Lean-writes-real-bytes pattern this RFD
  reuses at a different target (ggml tensor semantics vs RISC-V ELF).
- **`formal/rfdetr_proofs/`** in `3-interactor/rf-detr-cpp/`, the
  working template for Lean4 proofs alongside a ggml port.
- Upstream: `github.com/leejet/stable-diffusion.cpp`,
  `github.com/OmniGen2/OmniGen2`, `github.com/city96/ComfyUI-GGUF`,
  `huggingface.co/calcuis/omnigen2-gguf`.
- **Blocklist row** at the workspace's `BLOCKLIST.md` for
  `Qwen-Image-Edit` and `FLUX.1-Kontext-dev`: both are the obvious
  ready-made ggml-stack image editors but blocked, which is precisely
  why the OmniGen2 port is warranted rather than a substitution.

This RFD was drafted by an AI and read by a human before it shipped.
