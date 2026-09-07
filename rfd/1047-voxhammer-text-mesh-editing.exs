# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1047. `mix rfd.render` in rfd_dsl/ renders rfd/1047-voxhammer-text-mesh-editing/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1047 do
  use RFD.DSL

  rfd 1047, "Model image for voxhammer_text_mesh_editing" do
    state :discussion

    feature "model packaging"

    attest_in :none

    decision ~S"""
    Derive from the RFD 1038 base image, and add no weights. Model the
    three stages as a taskweft domain, because the guard that protects the
    unmasked region belongs in the plan and not in a comment.

    `domain.ex` and `problem.ex` in this folder hold it. RFD 1037
    gives the convention.

    See `DETAILS.md` for the model's shared-weight cost, the `predict()`
    interface, the unmasked-region guard, and why layering makes the edit
    reversible.
    """

    problem ~S"""
    VoxHammer edits a region of a mesh from a sentence. It carries no
    weights of its own. It runs on the TRELLIS.2 backbone from RFD 1038,
    and RFD 1026 records its parameter count as 0.

    The edit is not one forward pass. It inverts the mesh to latents, it
    edits inside the region, and it decodes. The region outside the mask
    must come back unchanged, and that is the hard requirement.
    """

    related ~S"""
    RFD 1038 holds the weights. RFD 1037 gives the composite convention.
    RFD 1048 is the image variant. RFD 1053 gives the layer rule.
    """

    details_title "Model image for voxhammer_text_mesh_editing"

    details "The model", ~S"""
    | Property   | Value                             |
    | ---------- | --------------------------------- |
    | Parameters | 0. It shares the RFD 1038 weights |
    | bf16       | 8.0 GB, the RFD 1038 cost         |
    | License    | MIT                               |
    """

    details "The interface", ~S"""
    | Input       | Type | Default |
    | ----------- | ---- | ------- |
    | mesh        | Path | none    |
    | instruction | str  | none    |
    | region      | Path | none    |
    | seed        | int  | -1      |

    `region` is a mask. RFD 1028 records the supported mask list in
    decisions/api/api.md.
    """

    details "The unmasked region must not move", ~S"""
    Inversion is lossy. A decode of an unedited latent does not give back
    the input mesh exactly, thus a naive implementation moves vertices the
    user never selected.

    The domain states this as a guard. `a_decode` requires
    `/have/preserved_outside`, and `a_splice` sets it by pasting the
    original geometry back outside the mask.

    That guard is the whole reason this model is a composite here.
    """

    details "Layers make the edit reversible", ~S"""
    RFD 1053 gives the rule. The edit is a sublayer over the source mesh,
    thus a caller mutes the layer and gets the original back. A flat file
    makes the edit permanent.
    """

    drafted_by :ai
  end
end
