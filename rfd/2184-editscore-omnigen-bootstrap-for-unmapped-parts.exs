# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2184. `mix rfd.render` in rfd_dsl/ renders rfd/2184-editscore-omnigen-bootstrap-for-unmapped-parts/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2184 do
  use RFD.DSL

  rfd 2184, "EditScore-guided OmniGen bootstrap for unmapped parts" do
    state :discussion

    feature "train OmniGen2 on V3 parts ANNY joints do not cover"

    scope "RFD 2183 (layer-decomp pipeline) middle step, part-label training"

    decision ~S"""
    Train OmniGen2 (RFD 2183 reconstruction stage) on the 13 See-Through
    V3 parts ANNY joints do not cover (front-hair, back-hair, iris,
    eyewhite, eyebrow, eyelash, mouth, ear, torso-back, footwear,
    handwear, accessory, background) under two combined signals:
    
    1. EditScore (RFD 1157 reward model) for semantic quality.
    2. Cross-view consistency on multi-view `sphere_hammersley_sequence`
       renders: same VRM from N angles must produce geometrically
       consistent per-part generations. This is a physical constraint,
       not a learned reward, and it stops EditScore from being gamed.
    
    Mix the 10 joint-covered parts (`anny_v3_face_groups.py` in
    anny-render-corpus) into every batch as ground-truth anchor.
    """

    problem ~S"""
    10 of 23 V3 parts are covered by nearest-joint clustering on ANNY;
    13 need training pairs OmniGen2 has never seen. Pure EditScore-only
    training reward-hacks; pure generation gives no signal. Combined
    EditScore + cross-view + anchor gives one physical signal, one
    learned signal, one ground-truth anchor: CLAUDE.md's four
    conditions added up.
    """

    related ~S"""
    RFD 2183 (layer-decomp pipeline), RFD 1157 (EditScore reward
    model), RFD 1173 (edit-reward corpus), RFD 2136 (gacha ladder),
    CLAUDE.md generated-synthetic clause, `anny_v3_face_groups.py`
    in anny-render-corpus.
    """

    drafted_by :ai
  end
end
