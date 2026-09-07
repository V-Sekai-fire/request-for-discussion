# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1041. `mix rfd.render` in rfd_dsl/ renders rfd/1041-p3sam-mesh-segmentation/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1041 do
  use RFD.DSL

  rfd 1041, "Model image for p3sam_mesh_segmentation" do
    state :discussion

    feature "model packaging"

    attest_in :none

    decision ~S"""
    Return the labels as data, and return the split meshes as files. A
    caller that only needs the label array must not pay for a mesh split.
    
    See `DETAILS.md` for the model's memory and license, the `predict()`
    interface, the output shape, and why the label array leads.
    """

    problem ~S"""
    P3-SAM segments a mesh into parts. It replaces PartField, which
    RFD 1028 removed for a non-commercial weight license.
    
    The model is small at 0.8 GB in bf16. The packaging risk is not the
    memory. It is the output shape.
    """

    related ~S"""
    RFD 1029 selects P3-SAM and PartSAM. RFD 1028 records why PartField
    went. RFD 1008 records the trait remix that consumes the parts.
    """

    details_title "Model image for p3sam_mesh_segmentation"

    details "The model", ~S"""
    | Property   | Value            |
    | ---------- | ---------------- |
    | Parameters | 0.4 B, estimated |
    | bf16       | 0.8 GB           |
    | Q4_K_M     | 0.22 GB          |
    | License    | MIT              |
    | Format     | bf16             |
    """

    details "The interface", ~S"""
    | Input              | Type | Default |
    | ------------------ | ---- | ------- |
    | mesh               | Path | none    |
    | segment_every_part | bool | false   |
    | max_parts          | int  | 32      |
    | seed               | int  | -1      |
    
    `segment_every_part` is the mode PartSAM and P3-SAM share. It returns
    every part it finds, and it ignores `max_parts`.
    """

    details "The output", ~S"""
    `predict()` returns a `BaseModel`. It carries `labels`, which is one
    integer per face, and `parts`, which is a list of GLB files.
    
    A face-length integer array on a 210000 vertex mesh is large. Write it
    as a JSON file, and not as an inline list. RFD 1033 gives the vertex
    cap.
    """

    details "Why the label array leads", ~S"""
    A part label is stable input for the rig stage and for the remix
    stage. A split mesh is not, because a later decimation renumbers the
    faces. Give the caller the stable thing first.
    """

    drafted_by :ai
  end
end
