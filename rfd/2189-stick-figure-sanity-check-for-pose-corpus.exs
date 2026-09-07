# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2189. `mix rfd.render` in rfd_dsl/ renders rfd/2189-stick-figure-sanity-check-for-pose-corpus/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2189 do
  use RFD.DSL

  rfd 2189, "Stick-figure sanity check for the pose corpus" do
    state :discussion

    feature "cheap visual audit of corpus poses against illustration needs"

    scope "810-clip mocap corpus feeding the atelier-workshop pipeline"

    decision ~S"""
    Draw twenty stick figures by projecting the 104-joint corpus
    through the existing camera arithmetic, ask a character artist to
    review the sheet, and decide whether the corpus fits the
    atelier-workshop (the pipeline) before further capture spend.
    `extract_poses.py` already yields world-space joints; RFD 2190
    (rig extrinsics calibration) will pin the `view` matrices. One
    contact sheet, twenty SVGs. No renderer, no GPU install.
    """

    problem ~S"""
    The 810 clips are locomotion: walking, running, turning,
    standing. Character illustrations are rarely mid-stride. RFD 1122
    (unrolled Kusudama solver) called this the cheapest thing that
    could change the plan and it was never run. RFD 2168 (wholebody
    detector retract) closed without running the check; issue 27
    closed stale. If the artist confirms the mismatch, the pipeline
    takes a different corpus. If the artist accepts it, later work
    has a written verdict.
    """

    references ~S"""
    Original issue: `weftspun/request-for-discussion` issue 27.
    `pose-consensus/python/extract_poses.py`.
    """

    related ~S"""
    RFD 1122 (unrolled Kusudama solver), RFD 2168 (wholebody detector
    retract), RFD 2171 (atelier-workshop vocabulary), RFD 2136 (gacha
    ladder; corpus feeds its rungs).
    """

    drafted_by :ai
  end
end
