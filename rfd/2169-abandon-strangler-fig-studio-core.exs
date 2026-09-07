# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2169. `mix rfd.render` renders rfd/2169-abandon-strangler-fig-studio-core/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2169 do
  use RFD.DSL

  rfd 2169, "Abandon the strangler-fig studio core; the ladder is MaskScore" do
    state :published

    feature "documentation retraction"

    scope "`rfd/1019-strangler-fig-studio-core`"

    decision ~S"""
    Abandon RFD 1019 (strangler-fig studio core); the workspace laddered up via MaskScore (edit-reward corpus) with Gemma-4-12B as the reasoning core instead.
    """

    problem ~S"""
    RFD 1019 proposed growing an Elixir application beside the browser client and taking studio responsibilities from it one at a time. The plan assumed a DGX plus CUDA backend, the JS catalog as authoritative first, and CockroachDB persistence. Every premise was walked back.
    """

    section "What replaces it", ~S"""
    Gemma-4-12B (QAT Q4_0, Apache-2.0, local) is the reasoning core. Gemma runs the vision and IPA panel today, produces the text-stub instructions, and RFD 2167 (voice-reward distillation) targets it as the fine-tune base. MaskScore constructs edit triples, RFD 1157 (EditScore reward model) scores them. The Rung 1 corpus (RFD 2164, 5 stubs shipped) and its schema module (RFD 2165.1) are the current spine. RFD 1173 (edit-reward corpus)'s Qwen3-VL wording is drift and needs its own update.

    Carried forward: facts-not-rows became ETNF (Essential Tuple Normal Form: no nulls, satellites); hexagonal ports became the 1-7 directory numbering.

    Abandoned: the Elixir studio core beside the JS client (no parity check ran); DGX plus CUDA plus Nx/EXLA (local desktop GPU is the only compute now, RunPod and Vast.ai blocklisted); JS catalog authoritative (per-model RFDs 1038-1052 and RFD 1102 ship it differently); CockroachDB persistence (RFD 1067 walked it back; replaced with sqlite-fdb plus S3-compatible streaming backup RFD 2143, plus OpenBao RFD 2140).
    """

    related ~S"""
    Retracts: urn:oid:1.3.6.1.4.1.66606.1.1.1019
    Superseded by: urn:oid:1.3.6.1.4.1.66606.1.1.{1173,1157}
    """

    drafted_by :ai
  end
end
