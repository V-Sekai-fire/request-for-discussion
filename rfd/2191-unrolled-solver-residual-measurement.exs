# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2191. `mix rfd.render` renders rfd/2191-unrolled-solver-residual-measurement/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2191 do
  use RFD.DSL

  rfd 2191, "Unrolled solver residual measurement" do
    state :discussion

    feature "measure fixed-step Kusudama solver residual vs baselines"

    scope "the unrolled fit RFD 1122 decided on"

    decision ~S"""
    Measure the residual an unrolled fit reaches after K steps, as a
    percentage of stature per `soma_referee.py` convention (a
    millimetre is negligible on an adult and disqualifying on a
    child), against two baselines: `lbfgs_polish.py` run to convergence
    (what the unroll replaces), and K swept from one upward warm-
    started from the previous frame at 120 fps. Compute is trivial:
    one step is 25.6k MAC against 102 GMAC for a four-view backbone,
    0.0006% of the backbone. Waits on RFD 2190 (rig extrinsics
    calibration): a residual against an uncalibrated `view` is in
    unknown units.
    """

    problem ~S"""
    RFD 1122 (unrolled Kusudama solver) decided to unroll the descent
    into a fixed number of steps with a per-step pairwise-Kusudama
    clamp. Whether the residual is good enough was never measured. A
    solver shipped without its residual against a baseline is a number
    without a floor, which PITFALLS rule 4 refuses. Issue 28 on the
    register closed stale.
    """

    references ~S"""
    Original issue: `weftspun/request-for-discussion` issue 28;
    `pose-consensus/python/lbfgs_polish.py` (baseline);
    `pose-consensus/python/soma_referee.py` (reporting convention).
    """

    related ~S"""
    RFD 1122 (unrolled Kusudama solver), RFD 2190 (rig extrinsics
    calibration; blocks this), RFD 2168 (wholebody detector retract).
    """

    drafted_by :ai
  end
end
