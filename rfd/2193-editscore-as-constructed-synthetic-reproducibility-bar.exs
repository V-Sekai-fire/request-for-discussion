# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2193. `mix rfd.render` in rfd_dsl/ renders rfd/2193-editscore-as-constructed-synthetic-reproducibility-bar/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2193 do
  use RFD.DSL

  rfd 2193, "EditScore as the constructed-synthetic reproducibility bar" do
    state :discussion

    feature "replace sha256 byte-equality with a semantic reproducibility judge"

    scope "`anny-render-corpus` and every constructed-synthetic renderer"

    preamble ~S"""
    Shelved 2026-09-03: waiting on two blockers named below.
    """

    decision ~S"""
    Replace sha256 byte-equality with EditScore (RFD 1157 reward
    model) as the reproducibility judgment for constructed-synthetic
    corpus. Reuses an instrument the workspace has; permits Metal-fast
    rendering while keeping the bar honest.
    """

    problem ~S"""
    Measured on M2 Pro against `render_view.py`'s film: CPU one-thread
    takes 32,592 ms per image, byte-identical; CPU default threads
    4,364 ms and differs; Metal 545 ms and differs. Metal is sixty
    times faster; three seed-zero runs produced three digests, so
    divergence is GPU accumulation order.
    
    Two blockers. First, `feature.editscore` in
    `anny-render-corpus/pixi.toml` takes torch from a CUDA index with
    no Apple wheels; the verifier does not run where needed. Second,
    PITFALLS rule 2: the judge must separate a different render from
    a 1/255 dither, or it is a rubber stamp. CLAUDE.md's 2026-09-02
    condition-5 retraction permits a quantised verifier.
    """

    references ~S"""
    Issue: `weftspun/weftspun-keypoint` 29; `anny-render-corpus/score_edits.py`.
    """

    related ~S"""
    RFD 1157 (EditScore reward), RFD 1173 (edit-reward corpus; MaskScore),
    RFD 2196 (HF viewer rules), CLAUDE.md constructed-synthetic rule.
    """

    drafted_by :ai
  end
end
