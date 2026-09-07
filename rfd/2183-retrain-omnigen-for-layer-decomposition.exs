# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2183. `mix rfd.render` in rfd_dsl/ renders rfd/2183-retrain-omnigen-for-layer-decomposition/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2183 do
  use RFD.DSL

  rfd 2183, "MaskScore-driven layer decomposition on OmniGen2" do
    state :discussion

    feature "SAM2/rf-detr-Seg mask + OmniGen2 reconstruction + MoGe-3 depth"

    scope "layer decomposition rung of the gacha ladder"

    decision ~S"""
    Three license-clean, purpose-built steps:

    - Mask: SAM2 or rf-detr-Seg (both Apache-2.0) from the composite.
    - Reconstruction: new weights on OmniGen2 (Apache-2.0, Qwen-VL-2.5),
      MaskScore-driven (RFD 1173 edit-reward corpus), trained on
      multi-view renders of atelier-workshop-passed VRMs.
    - Depth: MoGe-3 (MIT) per RFD 1102 (task catalog).

    Replaces LayerDiff3D (See-Through's role) and RFD 1168's LaMa half;
    rf-detr-Seg stays as segmentation. MaskScore's mask-reconstruct-score
    loop fits natively: each layer IS a mask.

    Corpus VRMs from the pipeline, `sphere_hammersley_sequence`
    (CLAUDE.md); labels true by construction.
    """

    problem ~S"""
    See-Through's LayerDiff3D is closed both ways per BLOCKLIST.md.
    `ask`: no grant on any weight; the new `seethroughv0.0.2_layerdiff3d`
    labels apache-2.0 but a diffusion fine-tune does not cure SDXL's
    CreativeML Open RAIL++-M. `adapt`: retraining on SDXL inherits it.

    LaMa (RFD 1168's reconstruction substitute) is a patch inpainter and
    cannot reconstruct hidden-layer content from surrounding pixels.
    """

    related ~S"""
    RFD 1168 (segmentation kept, LaMa superseded), RFD 1173 (edit-reward
    corpus), RFD 1102 (task catalog), RFD 2136 (gacha ladder), RFD 2196
    (HF dataset viewer rules), BLOCKLIST.md See-Through row.
    """

    drafted_by :ai
  end
end
