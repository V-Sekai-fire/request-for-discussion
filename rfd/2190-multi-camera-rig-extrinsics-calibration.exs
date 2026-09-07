# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2190. `mix rfd.render` renders rfd/2190-multi-camera-rig-extrinsics-calibration/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2190 do
  use RFD.DSL

  rfd 2190, "Multi-camera rig extrinsics calibration" do
    state :discussion

    feature "solve `view` matrices for every physical rig camera"

    scope "`pose-consensus` silhouette pipeline, `renders.camera_id` FK"

    decision ~S"""
    Pick a calibration method and land it as
    `pose-consensus/python/calibrate_rig.py`, producing per-camera
    `view` matrices consumed by `Camera.project`. Three candidates:
    bundle adjustment via structure-from-motion, checkerboard
    calibration via a computer-vision toolkit, or a Kimodo-fit reusing
    the workspace's own silhouette solver. The method is the decision;
    implementation follows. Constraint: it must run on owned hardware,
    so a CUDA-only calibrator is rented-compute by another name.
    """

    problem ~S"""
    `pose-consensus/python/silhouette.py` carries a pinhole `Camera`
    with pixel intrinsics, a world-to-camera `view` matrix, and a
    differentiable `project`; `renders.camera_id` is a foreign key.
    Nothing solves the `view` matrices for a physical rig, so every
    consumer of `Camera.project` holds a placeholder. RFD 1122
    (unrolled Kusudama solver) sits on that placeholder, so its
    residual is not measurable in world units until calibration lands.
    Issue 30 closed stale.
    """

    references ~S"""
    Original issue: `weftspun/request-for-discussion` issue 30.
    `pose-consensus/python/silhouette.py` (Camera class).
    """

    related ~S"""
    RFD 1122 (unrolled Kusudama solver; consumes `view`),
    RFD 2168 (wholebody detector retract),
    RFD 2191 (unrolled solver residual; blocked by this).
    """

    drafted_by :ai
  end
end
