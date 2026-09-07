# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1017. `mix rfd.render` in rfd_dsl/ renders rfd/1017-fork-rebrand-to-weftspun/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1017 do
  use RFD.DSL

  rfd 1017, "Fork rebrand to Weftspun" do
    state :published

    scope "all files"

    attest_in :none

    decision ~S"""
    This repository takes the name Weftspun 3D Studio. The code token is
    Weftspun3DStudio. The package name is weftspun-3d-studio. The
    Electron identifier is com.weftspun.studio. The Android identifier is
    com.weftspun.xrfacebridge.

    The application header shows one title line. The rebrand drops the
    second title line and its style rules.

    A new mark replaces the upstream artwork. The new mark shows a woven
    warp and weft lattice. A rename alone does not satisfy the upstream
    terms, because the terms reserve the artwork itself.

    The repository keeps the upstream repository links. These links give
    credit to the upstream authors. Nominative credit does not claim any
    affiliation.

    See `DETAILS.md` for the compatibility fallbacks, the known risks,
    and file references.
    """

    problem ~S"""
    Upstream reserves the names "Space-Time" and "OpenNexus3DStudio".
    Upstream also reserves the orbital clock logo artwork. The upstream
    terms require a rebrand for each fork. A fork must remove the
    upstream names, logos, and trade dress. A fork must then take a
    unique name.
    """

    related ~S"""
    RFD 1018 records the M3 documentation removal.
    """

    details_title "Fork rebrand to Weftspun"

    details "Compatibility", ~S"""
    Three identifiers keep a fallback path. Each fallback reads the old
    name once.

    - The Gradle build reads the old local.properties key.
    - The task store reads the old browser storage keys.
    - The lighting reader accepts the old glTF extras key.
    """

    details "Risk", ~S"""
    The rebrand renames one backend model identifier. The client sends
    weftspun_image_to_world to the 3DAIGC-API server. The server must
    accept the new name. Image to World tasks fail until then.

    The face bridge APK changes its application identifier. A headset
    installs the APK as a new application. Users must delete the old APK.
    """

    details "References", ~S"""
    - Brand terms: `README.md`, section Legal and Trademark Information
    - Mark: `public/weftspun-favicon.svg`
    - Android icon: `native/android-xr-face-bridge/app/src/main/res/raw/ic_app_icon.svg`
    - Fallbacks: `src/library/taskPersistence.js`, `src/library/viewportLighting.js`
    - Commit: `16afbc27`
    """

    drafted_by :ai
  end
end
