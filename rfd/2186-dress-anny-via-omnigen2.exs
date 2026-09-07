# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2186. `mix rfd.render` in rfd_dsl/ renders rfd/2186-dress-anny-via-omnigen2/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2186 do
  use RFD.DSL

  rfd 2186, "Dress ANNY via OmniGen2" do
    state :discussion

    feature "clothing/accessory overlay on the ANNY base mesh"

    scope "dressing stage of the atelier-workshop, upstream of RFD 2183"

    preamble ~S"""
    Shelved 2026-09-02: waiting for RFD 2183 (layer-decomp pipeline)
    baseline from CUDA and for training compute on the 3090.
    """

    decision ~S"""
    OmniGen2 (Apache-2.0 on Qwen-VL-2.5) generates clothing, footwear,
    handwear, and accessory overlays on the ANNY base mesh, per-scene
    (changes across frames unlike identity, which is frozen per
    character in RFD 2187).

    Owns V3 parts (See-Through's taxonomy, RFD 2183 stopgap):
    `footwear`, `handwear`, `torso-back` (cloth surface), `accessory`.

    Trained under RFD 2184's three-signal pattern: EditScore (RFD 1157
    reward model) for semantic quality, cross-view consistency on
    `sphere_hammersley_sequence` renders for anti-hacking, and
    constructed anchor data (real fashion / commercial-cleared cloth
    assets, or Live2D clothing drawables where available).
    """

    problem ~S"""
    ANNY is undressed. RFD 2183's layer-decomp pipeline assumes a
    dressed composite; without this stage, footwear/handwear/accessory
    training pairs cannot exist and RFD 2184's bootstrap has nothing to
    score for those V3 parts.
    """

    related ~S"""
    RFD 2183 (layer-decomp pipeline; consumes this), RFD 2184 (EditScore
    three-signal training pattern), RFD 2187 (identity overlay, parallel),
    RFD 2136 (gacha ladder; slots upstream of Rung 6).
    """

    drafted_by :ai
  end
end
