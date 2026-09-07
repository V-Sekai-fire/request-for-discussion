# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2036. `mix rfd.render` in rfd_dsl/ renders rfd/2036-forward-renderer-baked-light/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2036 do
  use RFD.DSL

  rfd 2036, "Forward renderer baked light" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The mobile tile renderer rations bandwidth across file, memory, and
    network IO, and deferred rendering competes for it. The slice needs
    predictable frame cost regardless of light count.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Forward renderer baked light"

    details "Context and problem statement", ~S"""
    The mobile tile renderer rations bandwidth across file, memory, and
    network IO, and deferred rendering competes for it. The slice needs
    predictable frame cost regardless of light count.
    """

    details "Considered options", ~S"""
    - Deferred rendering.
    - A simple forward renderer with baked global illumination.
    """

    details "Decision outcome", ~S"""
    Chosen option: a simple forward renderer with baked global
    illumination and light probes for static geometry, a dedicated shadow
    pass for avatars, and probe lighting for dynamic entities, because the
    frame cost stays predictable regardless of light count. Deferred
    rendering pressures the bandwidth the mobile tile renderer rations.
    """

    details "Consequences", ~S"""
    - Frame cost stays predictable, so artists place many lights without
      watching the budget.
    - Dynamic entities take lower-fidelity probe lighting.
    - The renderer removes one axis the small team otherwise tunes by
      hand.
    """

    details "Confirmation", ~S"""
    The Field room holds the frame floor on the standalone VR build with
    many lights placed.
    """

    drafted_by :ai
  end
end
