# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1038. `mix rfd.render` in rfd_dsl/ renders rfd/1038-trellis2-image-to-textured-mesh/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1038 do
  use RFD.DSL

  rfd 1038, "Model image for trellis2_image_to_textured_mesh" do
    state :discussion

    feature "model packaging"

    attest_in :none

    decision ~S"""
    Package TRELLIS.2 once, and publish the image as the base for
    RFD 1039, RFD 1047, RFD 1048, and RFD 1049. Those four add a
    `predict.py`, and they add no weights.
    
    See `DETAILS.md` for the model's memory and license, the `predict()`
    interface, and why both flow stages stay in one container.
    """

    problem ~S"""
    TRELLIS.2 is the default for image to 3D. It is the backbone of four
    other catalog entries. A model image that packages it badly costs five
    models, and not one.
    """

    related ~S"""
    RFD 1036 gives the model image convention. RFD 1053 gives the asset
    format. RFD 1026 gives the memory. RFD 1002 records the pipeline stage
    this model fills.
    """

    details_title "Model image for trellis2_image_to_textured_mesh"

    details "The model", ~S"""
    | Property   | Value              |
    | ---------- | ------------------ |
    | Parameters | 4.0 B, estimated   |
    | bf16       | 8.0 GB             |
    | Q4_K_M     | 2.20 GB            |
    | License    | MIT                |
    | Format     | bf16, per RFD 1027 |
    """

    details "The interface", ~S"""
    `predict()` takes the image, the texture resolution, and the face
    budget. It returns the base USD layer, and a GLB beside it. RFD 1053
    gives that rule.
    
    | Input              | Type | Default |
    | ------------------ | ---- | ------- |
    | image              | Path | none    |
    | texture_resolution | int  | 1024    |
    | decimation_target  | int  | 210000  |
    | seed               | int  | -1      |
    
    `decimation_target` must not exceed 210000. That is
    `API_MAX_MESH_VERTICES` in src/library/aiModelsCatalog.js, and it
    matches the API upload cap. A larger mesh fails the next stage.
    """

    details "Two stages, one container", ~S"""
    The sparse structure flow runs first, and the SLat flow runs second.
    Both stay in one model image. They share the DINOv2 image encoder, thus a
    split would load that encoder twice.
    """

    drafted_by :ai
  end
end
