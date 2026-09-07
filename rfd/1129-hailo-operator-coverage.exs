# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1129. `mix rfd.render` in rfd_dsl/ renders rfd/1129-hailo-operator-coverage/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1129 do
  use RFD.DSL

  rfd 1129, "Which operators the Hailo-10H will not take" do
    state :discussion

    feature "operator coverage for edge deployment"

    scope "`3-interactor/rf-detr-cpp`"

    attest_in :none

    decision ~S"""
    Answer by compiling, not by reading documentation. The compiler is the
    authority on what the compiler accepts.

    `gate_dfc_parse.py` and the `DEVICE_OPS` allowlist exist already, for
    the keypoint detector. Point the same gate at an ONNX export of each
    stage and read the rejections. A disagreement between allowlist and
    compiler is the finding rather than an error.

    Export the smallest graph that carries the question: one DiT block,
    and NAF's attention layer, rather than the whole cascade. A rejection
    names an operator at any size, and a small graph fails in seconds.

    The keypoint detector still ships; this asks what else could.

    See `DETAILS.md` for the two stages. `SKILL.md` gives the procedure.
    """

    problem ~S"""
    A model reaches the ASUS UGen300 through the Dataflow Compiler, which
    takes a graph and rejects operators it cannot map. Two stages of the
    mesh pipeline are built from operators with no portable form at all.

    Sparse submanifold convolution runs on `flex_gemm` and `o_voxel`, CUDA
    kernels over sparse voxel grids, and ONNX has no operator for it.
    Neighborhood attention runs on natten, whose fused CUTLASS kernels are
    compiled per NVIDIA architecture. Neither is a quantisation question.
    Both ask whether the graph exists outside CUDA at all.
    """

    related ~S"""
    RFD 1128 asks whether four bits survive. RFD 1130 asks about
    throughput and needs this first. RFD 1040 packages the model.
    """

    details_title "Which operators the Hailo-10H will not take"

    details "Sparse submanifold convolution", ~S"""
    `o_voxel` and `flex_gemm` convolve over occupied voxels only, and the
    saving is the whole point: a dense 1024 grid is 2^30 cells while the
    occupied set is a thin shell.

    ONNX has `Conv` and no submanifold sparse convolution. An export
    therefore either densifies, which destroys the saving and the memory
    budget with it, or emits a gather, matmul and scatter pattern whose
    support is exactly the open question.
    """

    details "Neighborhood attention, reached through a model nobody declares", ~S"""
    Pixal3D's image conditioning loads `valeoai/NAF` over `torch.hub`, and
    NAF's attention layers call natten:

        naf.py:115 -> attentions.py:72 -> natten.functional.na2d
        -> neighborhood_attention_generic -> cutlass_fna_generic

    Nothing in Pixal3D imports natten, which is why grepping for it finds
    only a README line and concludes wrongly that it is unused.

    It is not optional. `IMAGE_COND_CONFIGS` sets `use_naf_upsample: True`
    for three of the four conditioning models, and the projection width
    depends on the flag, `proj_channels = embed_dim * 2 if
    use_naf_upsample`, so the published weights were trained with it in
    place. Turning it off mismatches the checkpoint rather than skipping a
    step.
    """

    details "What the gate already knows", ~S"""
    `scripts/gate_onnx_device.py` exports the device half and
    `scripts/gate_dfc_parse.py` runs the compiler against it. The two run
    as a pair, and their disagreement is the result:

    | macOS gate | DFC       | meaning                       |
    | ---------- | --------- | ----------------------------- |
    | PASS       | parses    | the allowlist held            |
    | PASS       | rejects X | `DEVICE_OPS` is too generous  |
    | FAIL on X  | parses    | `DEVICE_OPS` is too strict    |

    `weftspun-hailo-dfc:5.3.0` is built and `hailo_sdk_client` imports.
    The wheel is Linux-only, which is why that image exists at all.
    """

    details "The order that saves time", ~S"""
    Export the attention layer before the sparse convolution. It is
    smaller, it is the dependency nobody expected, and a rejection there
    blocks the conditioning path, which makes the convolution question
    moot until it is answered.
    """

    drafted_by :ai
  end
end
