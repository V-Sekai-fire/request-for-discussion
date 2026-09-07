# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2187. `mix rfd.render` in rfd_dsl/ renders rfd/2187-identity-anny-via-omnigen2/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2187 do
  use RFD.DSL

  rfd 2187, "Identity ANNY via OmniGen2" do
    state :discussion

    feature "hair/eyes/skin/face overlay on the ANNY base mesh"

    scope "identity stage of the atelier-workshop, upstream of RFD 2183"

    preamble ~S"""
    Shelved 2026-09-02: waiting for RFD 2183 (layer-decomp pipeline)
    baseline from CUDA and for training compute on the 3090.
    """

    decision ~S"""
    OmniGen2 (Apache-2.0 on Qwen-VL-2.5) generates hair, eye, skin,
    and face-detail overlays on the ANNY base mesh, once per character
    (frozen across scenes, unlike dressing in RFD 2186 which changes
    per frame).
    
    Owns V3 parts (See-Through's taxonomy, RFD 2183 stopgap):
    `front-hair`, `back-hair`, `iris`, `eyewhite`, `eyebrow`,
    `eyelash`, `mouth`, `ear`.
    
    Trained under RFD 2184's three-signal pattern: EditScore (RFD 1157
    reward model) for semantic quality, cross-view consistency on
    `sphere_hammersley_sequence` renders for anti-hacking, and
    constructed anchor data (real anime character reference,
    licence-clean corpus TBD).
    """

    problem ~S"""
    ANNY is a template mesh, not a character. No hair, no iris colour,
    no eyelash, no eyebrow, no skin detail, no mouth painting. RFD
    2183's layer-decomp pipeline assumes an identified character; those
    V3 training pairs cannot exist without this stage.
    """

    related ~S"""
    RFD 2183 (layer-decomp pipeline; consumes this), RFD 2184 (EditScore
    three-signal training pattern), RFD 2186 (dressing overlay, parallel),
    RFD 2136 (gacha ladder; slots upstream of Rung 6).
    """

    drafted_by :ai
  end
end
