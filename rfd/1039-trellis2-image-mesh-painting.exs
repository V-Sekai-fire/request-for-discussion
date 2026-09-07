# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1039. `mix rfd.render` in rfd_dsl/ renders rfd/1039-trellis2-image-mesh-painting/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1039 do
  use RFD.DSL

  rfd 1039, "Model image for trellis2_image_mesh_painting" do
    state :discussion

    feature "model packaging"

    attest_in :none

    decision ~S"""
    Build `FROM` the RFD 1038 image. Add a `predict.py`, and add no
    weights. The model image is then about 40 MB, and not 8 GB.
    
    See `DETAILS.md` for the model's shared-weight cost, the `predict()`
    interface, and why the UV unwrap must not hide inside this model image.
    """

    problem ~S"""
    Mesh painting takes a mesh that exists and gives it a texture from an
    image. It uses the same TRELLIS.2 weights as RFD 1038. A second copy
    of those weights costs 8.0 GB and buys nothing.
    """

    related ~S"""
    RFD 1038 holds the weights. RFD 1036 gives the model image convention. RFD
    1033 records the UV stage.
    """

    details_title "Model image for trellis2_image_mesh_painting"

    details "The model", ~S"""
    | Property   | Value                                 |
    | ---------- | ------------------------------------- |
    | Parameters | 0. It shares the RFD 1038 weights.    |
    | bf16       | 8.0 GB, and that is the RFD 1038 cost |
    | License    | MIT                                   |
    """

    details "The interface", ~S"""
    | Input              | Type | Default |
    | ------------------ | ---- | ------- |
    | mesh               | Path | none    |
    | image              | Path | none    |
    | texture_resolution | int  | 1024    |
    | seed               | int  | -1      |
    
    `mesh` takes GLB, and the API contract in decisions/api/api.md gives
    `mesh_file_id` as the recommended handle. The model image takes a
    file, thus the adapter resolves the id before the call.
    """

    details "The one hard part", ~S"""
    The mesh arrives with its own UV layout, or with none. The painting
    stage needs a layout. When the mesh has no UV set, run xatlas first.
    RFD 1033 records xatlas, and it holds no weights.
    
    Do not unwrap inside this model image. A hidden unwrap makes the output
    depend on a step the caller cannot see or repeat.
    """

    drafted_by :ai
  end
end
