# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1044. `mix rfd.render` in rfd_dsl/ renders rfd/1044-seethrough-layer-decomposition/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1044 do
  use RFD.DSL

  rfd 1044, "Model image for seethrough_layer_decomposition" do
    state :discussion

    feature "model packaging"

    attest_in :none

    decision ~S"""
    Model the pipeline as a taskweft domain, and let the planner pick the
    order. `domain.ex` and `problem.ex` in this folder hold it.
    RFD 1037 gives the convention, and both files validate against
    `Code.string_to_quoted/1`.

    The model image calls `plan`, and it runs one function per action. The
    order lives in the domain, thus a pipeline change edits `domain.ex` and
    not Python.

    See `DETAILS.md` for why a planner earns its place here, the nine
    actions and their guards, and how one domain covers both runtimes.

    **WITHDRAWN 2026-08-29: the weights are not usable here.** RFD 1166
    dropped See-Through from the candidate ranking; its checkpoints state no
    licence and the depth one is an OpenRAIL++-M derivative. The layer
    taxonomy is what this workspace keeps.
    """

    problem ~S"""
    This entry names one task and runs nine networks. RFD 1030 lists them.
    A Python script that calls them in order hides the order, the guards,
    and the point where a failure happened.

    Nine networks need 9.82 GB together in bf16. They do not all need to
    be resident, because a text encoder finishes before the UNet starts.
    """

    related ~S"""
    RFD 1037 gives the convention. RFD 1030 lists the components. RFD 1006
    records the design.
    """

    details_title "Model image for seethrough_layer_decomposition"

    details "Why a planner earns its place here", ~S"""
    The domain carries `a_load` and `a_unload` as real actions. The peak
    memory is then a planning result, and not an accident.

    `make_depth` does not read the layer output. Marigold runs on the
    original image, thus the planner may order it before or after
    `make_layers`. A hand-written script fixes one order forever.
    """

    details "The nine, and their guards", ~S"""
    | Action           | Needs                        |
    | ---------------- | ---------------------------- |
    | a_inpaint        | lama, the image              |
    | a_encode_prompt  | layerdiff_te1, layerdiff_te2 |
    | a_diffuse_layers | the embeds, the inpaint      |
    | a_decode_rgb     | the latents                  |
    | a_decode_alpha   | the latents                  |
    | a_depth_encode   | marigold_te, marigold_unet   |
    | a_depth_decode   | the depth latents            |
    | a_write_psd      | rgb, alpha, and depth        |

    `a_decode_rgb` and `a_decode_alpha` read the same latents. That is the
    one fact a reader of the old script always missed.
    """

    details "Two runtimes, one domain", ~S"""
    RFD 1030 records a Replicate path at 9.82 GB in bf16, and a local
    ggml path at about 2.7 GB in Q4_K_M. The domain does not change
    between them. Only the action bodies change.
    """

    drafted_by :ai
  end
end
