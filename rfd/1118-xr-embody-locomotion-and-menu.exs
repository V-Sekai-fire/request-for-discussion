# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1118. `mix rfd.render` in rfd_dsl/ renders rfd/1118-xr-embody-locomotion-and-menu/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1118 do
  use RFD.DSL

  rfd 1118, "XR embody, view toggle, and Move stay input, not menu state" do
    state :committed

    scope "`sceneManagerXr*.js`"

    attest_in :none

    decision ~S"""
    On XR spawn, `alignXrLocomotionRigToViewport` runs on the first
    frame, from the current desktop view and the live headset pose. On
    XR exit, `captureXrViewAsDesktop` carries the last XR view back into
    desktop OrbitControls. Left X always toggles view; the stick click
    always toggles Move; neither reads menu state. Embodying the avatar
    aligns the rig's XZ position and yaw only, never Y. Disembodying
    places the avatar at the exit spot, facing the headset, with the
    viewer one meter behind, and switches Move to Viewpoint. Yaw math
    stays parent-local, `theta = atan2(fx, fz)`, where yaw zero faces
    +Z in this scene tree.

    The in-headset menu keeps a 25% opacity background, right-side tabs
    in one uniform column, Close at the bottom, and View, Move, and
    Measure paired together. The menu panel's bottom edge sits on the
    controller grip; it does not float roughly 0.5 m ahead of it.

    `bash scripts/verify_xr_avatar_view_locomotion.sh` runs before a
    merge touching this file. See `DETAILS.md` for the changes this RFD
    forbids without an explicit user request.
    """

    problem ~S"""
    Inside the main app's XR session (not the `/xr` IWSDK lab), the
    headset controls three things: whether the camera rides the avatar
    (embody) or floats free (third-person), whether Move drives the
    avatar or the free viewpoint, and an in-headset menu. Left X and the
    stick click must toggle view and Move at any time, menu open or
    closed; a regression kept gating both behind an open menu instead.
    """

    related ~S"""
    RFD 1010 gives the WebXR session modes this locomotion runs inside.
    RFD 1108 gives the floor-anchor placement this embody step assumes.
    """

    details_title "XR embody, view toggle, and Move stay input, not menu state"

    details_preamble ~S"""
    Sourced from `xr-avatar-view-locomotion-protected.mdc`
    (user-locked 2026-07-26).

    Without an explicit user request, a change must not:

    - Teleport the avatar back to its pre-embody spot on disembody,
      instead of the exit spot the user actually stood at.
    - Shift the rig's Y position on embody.
    - Leave Move set to Avatar after the user switches to third person;
      Move must follow the view switch to Viewpoint.
    - Require the in-headset menu to be open before Left X or the stick
      click can toggle view or Move.
    - Float the menu roughly 0.5 m ahead of the controller grip; the
      panel's bottom edge belongs on the grip itself.
    """

    drafted_by :ai
  end
end
