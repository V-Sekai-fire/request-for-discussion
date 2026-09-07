# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1001. `mix rfd.render` in rfd_dsl/ renders rfd/1001-app-shell-and-routing/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1001 do
  use RFD.DSL

  rfd 1001, "App shell and routing" do
    state :published

    feature "app shell"

    attest_in :none

    decision ~S"""
    Use React Router with three routes.

    - `/` is the main app.
    - `/studio` is the Studio pipeline page.
    - `/xr` is the IWSDK lab.

    The main app mounts SceneManager, TaskManager, and the avatar
    panels. The Studio page and the XR lab load lazily.

    The shell inits the native face bridge and the remote log client.
    Init errors do not block the viewport.
    """

    problem ~S"""
    The app ships one viewport and many tools. Tools need separate
    routes. The shell must keep one scene session.
    """

    references ~S"""
    - Routes: `src/main.jsx`
    - Main app: `src/App.jsx`
    - Studio page: `src/pages/StudioPage.jsx`
    - XR lab: `src/pages/IwsdkImmersive.jsx`
    """

    related ~S"""
    RFD 1002 defines the Studio pipeline. RFD 1010 defines the XR lab.
    """

    drafted_by :ai
  end
end
