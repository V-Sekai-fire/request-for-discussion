# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1053. `mix rfd.render` in rfd_dsl/ renders rfd/1053-openusd-as-the-internal-format/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1053 do
  use RFD.DSL

  rfd 1053, "OpenUSD as the internal format" do
    state :committed

    flight_level :l2

    feature "asset interchange"

    attest_in :none

    decision ~S"""
    OpenUSD is the internal format. Every stage reads a stage and writes a
    layer. glTF, VRM, and KHR avatar stay the transmission formats, and
    the pipeline converts to them at the edge.

    USD is to this pipeline what `.blend` is to Blender. It is the working
    file, and it never reaches a browser.

    See `DETAILS.md` for why layers beat a flat mesh format, the
    internal/transmission boundary, the shared runtime, and what every
    model image must return.

    Committed 2026-09-02: CLAUDE.md ratifies the choice as a hard
    constraint (OpenUSD `.usda` for text-editable, ZStandard parquet for
    bulk; zip and gzip banned; usdz exempt). RFD 2169 abandoned the
    Elixir studio core; the `fabric-stage-runtime` Hex package still
    ships OpenUSD to every consumer.
    """

    problem ~S"""
    Each pipeline stage reads a GLB and writes a GLB. A rig stage rewrites
    the whole file to add bones. A texture stage rewrites it again.

    Every rewrite loses what came before. glTF holds one flat result, thus
    a stage cannot add an opinion without erasing the previous author.
    When a mesh is wrong, no record says which stage made it wrong.
    """

    related ~S"""
    RFD 1036 gives the model image convention. `fabric-stage-runtime`
    (Hex) links this runtime to every stage. RFD 1002 records the
    pipeline stages that become layers.
    """

    details_title "OpenUSD as the internal format"

    details "Why layers, and not a better mesh format", ~S"""
    USD composes. A stage adds a sublayer with its own opinion, and the
    layer below stays intact and readable.

    | Stage        | Writes                                |
    | ------------ | ------------------------------------- |
    | image to 3D  | the base mesh layer                   |
    | retopology   | a layer that overrides the mesh       |
    | UV unwrap    | a layer that adds the primvar         |
    | segmentation | a layer of part scopes                |
    | rig          | a layer of skeleton and skin bindings |
    | texture      | a layer of material bindings          |

    A caller may then mute the retopology layer and see the original. That
    is not possible in a flat file.
    """

    details "The boundary", ~S"""
    | Direction  | Format                       |
    | ---------- | ---------------------------- |
    | Internal   | `.usdc`, and `.usda` to read |
    | Avatar out | VRM, or KHR avatar           |
    | Asset out  | glTF binary                  |
    | Archive    | `.usdz`                      |

    Convert at the boundary only. A stage that converts in the middle
    throws away the composition this RFD exists to keep.
    """

    details "The runtime", ~S"""
    `fabric-stage-runtime` ships OpenUSD 26.5.0 as an Elixir Hex package.
    It exposes `include_dir/0`, `lib_dir/0`, and `target/0`, thus every
    consumer links the same USD build the model images write. (An
    earlier draft named "the Elixir core from RFD 1019" as the consumer;
    RFD 2169 abandoned that plan, and the Hex package survives without
    the studio-core wrapper.)

    One USD version across the pipeline matters. A layer written by a
    newer build may not open in an older one.
    """

    details "What each model image must do", ~S"""
    `predict()` returns the USD layer, and it returns the transmission
    file as well. The caller keeps the layer, and it ships the other.

    RFD 1036 records this in the model image convention.
    """

    drafted_by :ai
  end
end
