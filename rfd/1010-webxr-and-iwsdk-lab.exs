# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1010. `mix rfd.render` in rfd_dsl/ renders rfd/1010-webxr-and-iwsdk-lab/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1010 do
  use RFD.DSL

  rfd 1010, "WebXR and IWSDK lab" do
    state :published

    feature "WebXR"

    attest_in :none

    decision ~S"""
    Use WebXR in the main viewport. Two session modes exist.

    - VR mode shows a virtual sky background.
    - AR mode shows pass-through transparency.

    Floor anchoring places the model at the correct height. The WebXR
    expression tracking drives VRM blink and mouth shapes. When the
    browser lacks expression tracking, the native face bridge relays
    face data from a companion APK.

    A separate /xr route hosts the IWSDK lab. It experiments with grab
    and locomotion. The main app also runs IWSDK distance grab and
    thumbstick locomotion.
    """

    problem ~S"""
    The app targets XR headsets. Users need VR and AR modes with floor
    anchoring. The main app must also support expression tracking for
    avatar faces.
    """

    references ~S"""
    - XR: `src/library/sceneManager.js`
    - Lab: `src/pages/IwsdkImmersive.jsx`
    - Face relay: `src/library/nativeFaceBridge.js`
    - Config: `src/library/xrHubConfig.js`
    - Docs: `docs/XR_MODE_FLOOR_ANCHORING_AND_BACKGROUNDS.md`
    - Docs: `docs/IWSDK_INTEGRATION.md`
    """

    related ~S"""
    RFD 1009 defines the shared viewport.
    """

    drafted_by :ai
  end
end
