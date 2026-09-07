# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2051. `mix rfd.render` in rfd_dsl/ renders rfd/2051-headless-openxr-testing-with-monado/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2051 do
  use RFD.DSL

  rfd 2051, "Headless openxr testing with monado" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    Functional and integration coverage of the OpenXR path needs a
    runnable runtime on the box, with no display and no hardware.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Headless openxr testing with monado"

    details "Context and problem statement", ~S"""
    Functional and integration coverage of the OpenXR path needs a
    runnable runtime on the box, with no display and no hardware.
    """

    details "The install recipe (Fedora, Monado 25.1.0)", ~S"""
    - Install `monado monado-devel monado-vulkan-layers`.
    - Select the runtime: symlink `~/.config/openxr/1/active_runtime.json`
      to `/usr/share/openxr/1/openxr_monado.json`, or set
      `XR_RUNTIME_JSON`.
    - Start the service headless:
      `tail -f /dev/null | XRT_COMPOSITOR_NULL=1 SIMULATED_ENABLE=1 monado-service`.
    - OpenXR clients connect over the IPC socket
      `$XDG_RUNTIME_DIR/monado_comp_ipc`.
    """

    details "The stdin-pipe caveat", ~S"""
    `monado-service` watches stdin through `epoll` to notice shutdown, and
    a non-epoll-able stdin (a closed descriptor or a regular file, which
    is what a background job, a `nohup`, or a container hands it) makes
    `epoll_ctl(stdin)` fail and the service aborts before it opens the
    socket. Feeding it an epoll-able pipe (`tail -f /dev/null | ...`, or a
    held-open FIFO) is what lets it start.
    """

    details "Consequences", ~S"""
    - The OpenXR path runs on the workstation and in a podman quadlet with
      no display and no headset.
    - `XRT_COMPOSITOR_NULL` discards submitted frames, so this covers the
      runtime, the tracking, and frame submission, with no rendered output
      and no performance signal.
    - `SIMULATED_ENABLE` supplies a head and controllers driven
      programmatically; the `qwerty` driver (`QWERTY_ENABLE`) adds
      keyboard and mouse control for an interactive desktop run.
    - This is functional and integration coverage; the standalone OpenXR
      build is the performance and comfort gate.
    """

    details "Confirmation", ~S"""
    `openxr_runtime_list`, and any OpenXR app, reaches `xrCreateInstance`
    against the running service, and the service log reports the null
    compositor and a simulated HMD.
    """

    drafted_by :ai
  end
end
