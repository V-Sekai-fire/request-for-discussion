# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1033. `mix rfd.render` renders rfd/1033-geometric-algorithms/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1033 do
  use RFD.DSL

  rfd 1033, "Geometric algorithms in the catalog" do
    state :published

    feature "model inventory"

    attest_in :none

    decision ~S"""
    List the geometric algorithms apart from the neural models. RFD 1016
    holds the neural models.

    See `DETAILS.md` for the algorithm table, how they scale with mesh
    size instead of parameter count, and a license note on
    `quadwild_retopology`.
    """

    problem ~S"""
    The catalog mixes deep learning models and geometric algorithms. A
    reader who plans memory cannot tell the two apart. They scale in
    different ways.
    """

    related ~S"""
    RFD 1016 lists the neural models. RFD 1026 gives their bf16 memory.
    """

    details_title "Geometric algorithms in the catalog"

    details "The algorithms", ~S"""
    | Model id                  | Task            | License |
    | ------------------------- | --------------- | ------- |
    | quadwild_retopology       | Mesh retopology | GPL-3   |
    | instant_meshes_retopology | Mesh retopology | BSD-3   |
    | xatlas_uv_unwrapping      | UV unwrapping   | MIT     |
    | colmap_3dgs_reconstruct   | Photos to splat | BSD-3   |

    Each one is packaged as its own model image, per RFD 1036.
    """

    details "How they scale", ~S"""
    These algorithms hold no weights. Their memory scales with the mesh,
    and not with a parameter count. A capacity plan must therefore use the
    vertex budget, and not a bf16 figure.

    src/library/aiModelsCatalog.js caps the mesh at 210,000 vertices. The
    constant is `API_MAX_MESH_VERTICES`, and it matches the API upload cap.
    """

    details "A license note", ~S"""
    quadwild_retopology uses the GPL-3 license, which RFD 1028 excludes.
    Instant Meshes is the permissive replacement, and RFD 1029 records the
    other options.
    """

    drafted_by :ai
  end
end
