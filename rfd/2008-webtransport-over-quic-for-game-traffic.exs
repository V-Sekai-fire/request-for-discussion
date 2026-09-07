# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2008. `mix rfd.render` in rfd_dsl/ renders rfd/2008-webtransport-over-quic-for-game-traffic/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2008 do
  use RFD.DSL

  rfd 2008, "Webtransport over quic for game traffic" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The zone server needs low-latency bidirectional communication between
    clients and the Godot game server. HTTP/1.1 and WebSocket both run
    over TCP, which head-of-line blocks on packet loss and degrades
    real-time game state.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Webtransport over quic for game traffic"

    details "Context", ~S"""
    The zone server needs low-latency bidirectional communication between
    clients and the Godot game server. HTTP/1.1 and WebSocket both run over
    TCP, which head-of-line blocks on packet loss and degrades real-time
    game state.
    """

    details "Consequences", ~S"""
    - UDP eliminates TCP head-of-line blocking.
    - Fly.io passes UDP without DNAT, so the app must bind to the same port
      clients connect to.
    - Port 443 requires running as root (or `CAP_NET_BIND_SERVICE`). The
      gateway container runs as root.
    - Datagrams are used for game state messages. Streams are avoided for
      ping/pong to sidestep stream half-close deadlock (client must close
      write side before server response fires).
    - Cloudflare's proxy cannot forward QUIC/UDP. All game-traffic DNS
      records must be DNS-only (no proxy).
    """

    drafted_by :ai
  end
end
