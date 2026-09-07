# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1172. `mix rfd.render` renders rfd/1172-a-diffusion-lm-does-not-land-on-the-npu/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1172 do
  use RFD.DSL

  rfd 1172, "A diffusion LM does not land on the NPU" do
    state :discussion

    feature "where diffusion text generation runs on this desk"

    scope "the XDNA1 NPU in the 7840U laptop, and the dLLM candidates of 2026"

    attest_in :none

    decision ~S"""
    It cannot, and the XDNA blocklist row stands unchanged.

    Three facts settle it, each sourced in DETAILS.md. The vendor's LLM flows
    exclude this NPU generation: every supported path requires the newer 50 TOPS
    part, and the one prototype flow that reaches ours measured 2.3 tokens per
    second on the NPU against 7.8 on the CPU beside it. The inference pattern is
    heavier than autoregressive decoding: bidirectional attention over the full
    sequence, dozens of passes, no KV cache in the standard formulation. The one
    published NPU deployment of a dLLM anywhere runs an 8B model on a phone
    accelerator in the 45 TOPS class, and it rewrote the algorithm to get there.
    Ours peaks at 10.

    If diffusion text generation earns a place in this workspace, it runs on the
    3090 or a rented GPU. DiffusionGemma 26B-A4B and LLaDA2.1-mini, both Apache
    2.0, are the sizes that fit a desk card.
    """

    problem ~S"""
    Diffusion language models generate text by unmasking a full sequence over
    repeated denoising passes instead of decoding one token at a time. The
    strongest one whose weights we could hold is LLaDA2.1-flash: a 100B mixture
    of experts with 6.1B active parameters, Apache 2.0, ungated, with the best
    benchmark table any dLLM has published (MMLU-Pro 76.6, HumanEval+ 89.6).
    The question was whether it, or any dLLM, could run on the laptop's NPU.
    """

    references ~S"""
    1. Candidate table, sources, and the throughput numbers: `DETAILS.md`
    2. The XDNA row in `BLOCKLIST.md` carries the standing toolchain argument.
    """

    details_title "A diffusion LM does not land on the NPU"

    details_preamble ~S"""
    Surveyed 2026-08-30. Claims below cite the vendor or paper that made them;
    none were reproduced on this desk. Throughput figures marked "claimed" have
    no independent replication we could find.
    """

    details "The candidate table", ~S"""
    | model                              | params                 | weights          | licence       | standing                                                                                   |
    | ---------------------------------- | ---------------------- | ---------------- | ------------- | ------------------------------------------------------------------------------------------ |
    | LLaDA2.1-flash (inclusionAI)       | 100B MoE, 6.1B active  | open, ungated    | Apache 2.0    | MMLU-Pro 76.6, BBH 88.7, HumanEval+ 89.6, AIME 2025 63.3; claimed 892 tok/s peak           |
    | LLaDA2.1-mini (inclusionAI)        | 16B MoE, 1B active     | open, ungated    | Apache 2.0    | the small sibling of the same release                                                      |
    | DiffusionGemma 26B-A4B (Google)    | 25.2B MoE, 3.8B active | open             | Apache 2.0    | block diffusion on the Gemma 4 architecture; claimed 4x over comparable AR                 |
    | Dream-v0 7B, Dream-Coder 7B        | 7B dense               | open             | Apache 2.0    | strongest 2025-era 7B dLLM, now mid-tier                                                   |
    | LLaDA-8B-Instruct                  | 8B dense               | open             | MIT           | the original, near LLaMA3-8B quality                                                       |
    | Mercury 2 (Inception Labs)         | undisclosed            | closed, API only | commercial    | claimed 1,009 tok/s on datacenter GPUs; trails frontier AR on reasoning by its own account |
    | Gemini Diffusion (Google)          | undisclosed            | closed, waitlist | none readable | experimental demo, no public API                                                           |
    | Seed Diffusion Preview (ByteDance) | undisclosed            | closed           | none readable | code model; claimed 2,146 tok/s on H20                                                     |

    Strongest overall and strongest open with a commercially usable licence are
    the same row: LLaDA2.1-flash. The closed models publish speed, not a
    benchmark table that beats it.

    1. https://huggingface.co/inclusionAI/LLaDA2.1-flash
    2. https://github.com/inclusionAI/LLaDA2.X
    3. https://ai.google.dev/gemma/docs/diffusiongemma
    4. https://huggingface.co/GSAI-ML/LLaDA-8B-Instruct
    5. https://www.inceptionlabs.ai/blog/mercury-refreshed
    6. https://deepmind.google/models/gemini-diffusion/
    """

    details "Why the XDNA1 NPU cannot carry any of them", ~S"""
    The vendor's own LLM flows exclude the part. The Ryzen AI OGA flows, hybrid
    and NPU-only, state that Phoenix and Hawk Point are not supported; every
    supported path requires the 50 TOPS XDNA2 generation. GAIA on a 7840U falls
    back to CPU and iGPU with the NPU idle. The third-party NPU runtimes say the
    same, citing tile-structure differences.

    1. https://ryzenai.docs.amd.com/en/latest/hybrid_oga.html
    2. https://ryzenai.docs.amd.com/en/1.4/npu_oga.html
    3. https://github.com/amd/GAIA

    The one path that reaches Phoenix loses to its own CPU. The Ryzen AI 1.2-era
    eager-mode flow offloads GEMMs at w4abf16 (AWQ INT4 weights via Quark, bf16
    activations) and is labelled prototyping-only. A published project measured a
    7B autoregressive model at 2.3 tok/s on the Phoenix NPU against 7.8 tok/s on
    the same package's CPU. That is the baseline rule: the floor sits in the same
    table, and the floor wins by 3.4x.

    1. https://ryzenai.docs.amd.com/en/1.2/llm_flow.html
    2. https://www.hackster.io/ru3ll/ray-empowering-your-digital-life-943398

    The dLLM pattern is strictly heavier than the AR pattern that already loses.
    Bidirectional attention over the full sequence, dozens of denoising passes
    per generation, no KV cache in the standard formulation. The single published
    NPU deployment of a dLLM runs LLaDA-8B at Q4_0 on a Snapdragon Hexagon, a
    part in the 45 TOPS class, and reaches 128 tokens in about 16 s only by
    changing the algorithm: multi-block speculative decoding plus an approximate
    prefix cache with staged token stabilisation. Nothing comparable exists for
    any AMD NPU, XDNA1 or XDNA2.

    1. https://arxiv.org/abs/2606.13740
    """

    details "What this does not decide", ~S"""
    Condition 5 of the data-hygiene rule does not bite here: an on-device dLLM
    would serve interaction, not corpus generation, so INT4 weights would be
    permissible in that role. The block is capability and toolchain, not policy.
    A future desk with an XDNA2 part reopens the toolchain half of the question
    and none of the physics; the blocklist row would still need its own
    revisiting first.
    """

    details "Local measurement: LLaDA-1.5 on the RTX 3090", ~S"""
    LLaDA-1.5 (8B dense, MIT, GSAI-ML/LLaDA-1.5) was measured on the desk 3090
    with quality controls: coherence gate (no comma degeneration, no excessive
    repetition, 10-word minimum), relevance gate (topic keywords), and a negative
    control (steps=16 must fail).

    bf16 + torch.compile (WSL2, Triton 3.6, PyTorch 2.11):

    | steps | batch | wall s | tok/s | pass |
    | ----: | ----: | -----: | ----: | ---- |
    |   128 |     1 |   6.83 |  18.7 | OK   |
    |    64 |     1 |   3.43 |  37.4 | OK   |
    |    32 |     1 |   1.71 |  74.9 | OK   |
    |    16 |     1 |   0.85 | 149.9 | FAIL |
    |    32 |     4 |   4.71 | 108.7 | OK   |

    Best passing configuration: steps=32, batch=4, 108.7 tok/s at 15.9 GiB VRAM.
    NF4 quantization saves VRAM (6.5 GiB) but degrades quality at steps=32,
    capping its best passing throughput at 46.5 tok/s (steps=64, batch=8).

    The 108.7 tok/s is 9.2x below Mercury's claimed 1,000 tok/s. The gap is
    hardware-bound: Mercury runs on datacenter GPUs with multi-GPU parallelism
    and a production serving stack. On a single 3090, software optimisation
    (compile, batching, step reduction) is exhausted.

    Unconfirmed, stated rather than smoothed over: Mercury 2 and Gemini
    Diffusion parameter counts; independent replication of the 892 and 1,009
    tok/s claims; whether the Hexagon deployment's code is public.
    """

    drafted_by :ai
  end
end
