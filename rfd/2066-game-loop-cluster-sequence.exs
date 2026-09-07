# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2066. `mix rfd.render` in rfd_dsl/ renders rfd/2066-game-loop-cluster-sequence/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2066 do
  use RFD.DSL

  rfd 2066, "Game loop cluster sequence" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The team polled on which concern to stabilise next. Game-loop received
    2 of 4 votes (50%). The uiux-polish, cassie-pen-mesh, shop-economy,
    and openUSD-i/o concerns all require a verified game-loop as their
    integration target and are not testable end-to-end without one.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Game loop cluster sequence"

    details "The context", ~S"""
    The team polled on which concern to stabilise next. Game-loop received
    2 of 4 votes (50%). The uiux-polish, cassie-pen-mesh, shop-economy,
    and openUSD-i/o concerns all require a verified game-loop as their
    integration target and are not testable end-to-end without one.
    """

    details "The problem statement", ~S"""
    The uiux-polish, cassie-pen-mesh, shop-economy, and openUSD-i/o
    concerns have no stable integration target while the game-loop
    remains unverified. Work that lands on an unstable loop accumulates
    rework debt that blocks the feedback release.
    """

    details "Design", ~S"""
    The OpenXR Windows build (export preset `OpenXR`,
    `build/openxr/loop-slice.exe`) is the external feedback artifact. It
    runs the full hub-to-field-to-loot round trip and is the
    SteamVR-compatible path for PCVR reviewers.
    
    The game-loop is complete when `smoke.sh` passes, the OpenXR Windows
    build exports without error, and at least one external reviewer runs
    the full loop against a live server.
    """

    details "The downsides", ~S"""
    The shop-economy and openUSD-i/o concerns have no integration path
    before the feedback release. If the game-loop verification slips, all
    four dependent concerns slip with it and there is no parallel path to
    absorb the delay.
    """

    details "The road not taken", ~S"""
    - Parallel concerns: advancing uiux-polish or cassie-pen-mesh alongside
      the game-loop risks landing polish or authoring work on a loop that
      is still changing, producing rework.
    - Content-first: stabilising content concerns before the loop pushes
      integration gaps late, when they are most expensive to fix.
    """

    drafted_by :ai
  end
end
