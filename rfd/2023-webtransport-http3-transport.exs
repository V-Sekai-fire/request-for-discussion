# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2023. `mix rfd.render` in rfd_dsl/ renders rfd/2023-webtransport-http3-transport/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2023 do
  use RFD.DSL

  rfd 2023, "Webtransport http3 transport" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The stack needs a client/server transport that carries reliable
    control messages and high-rate unreliable state over one connection,
    on both native and web clients. Which transport does the engine
    provide?
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Webtransport http3 transport"

    details "Context and problem statement", ~S"""
    The stack needs a client/server transport that carries reliable
    control messages and high-rate unreliable state over one connection,
    on both native and web clients. Which transport does the engine
    provide?
    """

    details "Decision drivers", ~S"""
    - Unreliable datagrams for high-rate state, plus reliable streams for
      control.
    - One connection for both, with native and browser support.
    """

    details "Considered options", ~S"""
    - Standard `MultiplayerPeer` transports (ENet, WebSocket, WebRTC).
    - WebTransport over HTTP/3 / QUIC.
    """

    details "Decision outcome", ~S"""
    Chosen option: WebTransport over HTTP/3, provided by the engine's
    `modules/http3` (on `feat/module-http3`):

    - `quic_picoquic_backend.{cpp,h}`, native QUIC via picoquic.
    - `quic_web_backend.cpp` + `quic_web_glue.js`, the web/wasm backend.
    - `http3_client.{cpp,h}`, `quic_client.{cpp,h}`, `quic_server.h`.
    - Classes `HTTP3Client`, `QUICClient`, `QUICServer`, `WebTransportPeer`.
    - Demos: `modules/http3/demo/wt_client_test.gd`, `wt_server_demo.gd`,
      `wt_browser_test.html`.
    - `lean/http3/PollingTermination.lean` proves the poll loop
      terminates.

    One QUIC connection carries reliable streams and unreliable datagrams,
    so control messages and high-rate state share a connection.
    """

    details "Consequences", ~S"""
    - Good: datagrams suit high-rate state; one connection serves native
      and browser.
    - Bad: the fork carries a picoquic backend and a QUIC stack to
      maintain.
    """

    details "Confirmation", ~S"""
    The `modules/http3` demos open a WebTransport client and server over
    QUIC.
    """

    details "More information", ~S"""
    Pose streaming for the presence demo rides this transport; see
    presence demo pose networking. The engine is pinned to a frozen Godot
    4.7 commit.
    """

    drafted_by :ai
  end
end
