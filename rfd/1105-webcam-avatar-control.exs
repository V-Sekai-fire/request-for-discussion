# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1105. `mix rfd.render` in rfd_dsl/ renders rfd/1105-webcam-avatar-control/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1105 do
  use RFD.DSL

  rfd 1105, "Webcam avatar control, off during WebXR" do
    state :published

    scope "`src/library/webcamAvatarDriver.js`, `xrExpressionTrackingDriver.js`"

    attest_in :none

    decision ~S"""
    The webcam driver does not run while WebXR is presenting. Entering
    VR or AR stops it by itself: it frees the camera, ends the detection
    loop, and returns the avatar to neutral, with nothing left to
    conflict with headset tracking or Galaxy XR. A separate driver,
    `xrExpressionTrackingDriver.js`, takes over inside an immersive
    session, reading the draft WebXR `XRFrame.expressions` feature when
    a user agent grants it. Neither driver touches `enableVR()`,
    `enableAR()`, or reference spaces.
    
    See `DETAILS.md` for the feature list, the Android XR native-bridge
    path, and remote-logging setup for headset debugging.
    """

    problem ~S"""
    A webcam can drive the current VRM's face and head, using Kalidokit
    plus MediaPipe Holistic, the same approach XR Animator and Kalidoface
    use. That driver must never fight a headset's own tracking once a
    WebXR session presents.
    """

    related ~S"""
    **Unresolved duplicate:** weftspun-3d-studio's own
    `thirdparty/m3/docs/WEBCAM_AVATAR_CONTROL.md` covers the same topic,
    with real content differences. Neither version is authoritative;
    that reconciliation is still open. RFD 1096 gives the Android XR
    native face-tracking path this RFD's XR driver falls back to.
    """

    details_title "Webcam avatar control, off during WebXR"

    details "Stack and features", ~S"""
    MediaPipe Holistic reads face landmarks, Kalidokit's `Face.solve()`
    turns them into weights, and those weights drive the VRM's
    `expressionManager` and humanoid bones. Features: blink (optionally
    per eye), mouth shapes (Ah, Ee, Oh, Ou), and smoothed neck/head
    rotation from the same landmarks.
    
    `src/library/webcamAvatarDriver.js` is created, started, and stopped
    from `SceneContext`; the UI toggle lives in `BottomDisplayMenu`. It
    acts on the same VRM files the rest of the app uses (character
    manager avatars, or the current scene VRM), and never touches WebXR
    session state directly.
    """

    details "Usage", ~S"""
    1. Load a VRM model.
    2. Click "Cam" in the bottom control bar to start webcam avatar control.
    3. Allow camera access when prompted; the avatar's face follows the user's face.
    4. Click the same button ("Cam on") to stop.
    """

    details "Galaxy XR and WebXR expression tracking", ~S"""
    When a browser does not grant the `expression-tracking` feature, a
    WebView-wrapped Android XR app relays OpenXR's own
    `XR_ANDROID_face_tracking` weights into the page through
    `nativeFaceBridge.js`. See RFD 1096 for that native path, and
    `native/android-xr-face-bridge/README.md`.
    
    On a supported user agent (Chrome on Android XR, for instance),
    immersive VR and AR sessions request the optional
    `expression-tracking` feature descriptor. When granted, each
    `XRFrame` may expose `frame.expressions`, a draft WebXR Expression
    Tracking map of roughly FACS-like weight keys; the runtime maps
    headset sensors to `XR_ANDROID_face_tracking` semantics underneath.
    
    Implemented: `src/library/xrExpressionTrackingDriver.js` reads
    `XRFrame.expressions` and maps weights heuristically to VRM presets
    (`Blink`, `Ah`, `Ee`, `Oh`, `Ou`), with light per-VRM smoothing.
    `SceneManager` adds `expression-tracking` to `optionalFeatures` for
    both AR (`ARButton`) and manual VR
    (`requestSession('immersive-vr')`), logs once when
    `session.enabledFeatures` includes it, and applies the mapping every
    XR render frame. `SceneContext` registers the same VRM-list resolver
    webcam control uses.
    
    Debugging: append `?xrExpressionProbe=1` to log one `XRFrame`
    introspection (`maybeProbeXRFrame`).
    
    ### Why a second permission prompt may not appear
    
    On Android XR, Chrome can fold several sensitive capabilities,
    including tracked face, eye, and hand data, into the initial WebXR
    or spatial-mapping consent, rather than a separate dialog per
    sensor, per Android's own "Develop for the web on Android XR" page.
    No extra prompt after entering AR or VR is the expected case.
    
    Separately, `expression-tracking` is optional: if a Chrome build
    does not implement the draft `XRFrame.expressions` API yet,
    `session.enabledFeatures` may not list it, and the avatar's face
    stays neutral in XR with no error.
    
    Galaxy XR development workaround: install the "Weftspun XR Face"
    APK, run `npm run dev` on a PC, open Chrome's menu, "Open in Chrome
    for WebXR (+ face)" (`?nativeFaceRelay=1`), and keep the APK visible
    or in picture-in-picture so Jetpack or OpenXR PBuffer face tracking
    can relay to the dev server during Chrome's Full Space AR. See RFD
    1096 and the Android Studio AI brief (weftspun-3d-studio-designs'
    own numbering) for the fuller setup.
    
    First-frame diagnostics log as `[XR][expression] First-frame
    diagnostics`, with `enabledFeatures`, `expressionTrackingGranted`,
    and `expressionsNonNull`. Forward that line from a headset with
    `?remoteLog=1`.
    """

    details "Remote logging from a headset", ~S"""
    1. Start the dev server (`npm run dev`; HTTPS on port 3000 by
       default when certs exist).
    2. On the headset, open `https://<PC-LAN-IP>:3000/?remoteLog=1`
       (add `&xrExpressionProbe=1` for the extra probe).
       `https://localhost:3000` on the headset targets the headset
       itself, not the PC; use the PC's LAN address.
    3. Logs POST to `/__remote_log` on the same origin. Vite prints
       them and appends `logs/remote-log.txt`.
    4. A working client logs `[RemoteLog] Forwarding console to
    /__remote_log` in the browser console.
    """

    details "Current behavior, summarized", ~S"""
    Webcam avatar control stays off during WebXR. XR expression tracking
    applies only inside an immersive session, and only when the user
    agent exposes `expressions`; otherwise the avatar's face stays
    unchanged from whichever non-XR driver last ran.
    """

    drafted_by :ai
  end
end
