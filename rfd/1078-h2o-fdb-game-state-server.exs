# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1078. `mix rfd.render` in rfd_dsl/ renders rfd/1078-h2o-fdb-game-state-server/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1078 do
  use RFD.DSL

  rfd 1078, "An H2O/FoundationDB game-state server" do
    state :moved

    preamble ~S"""
    Developed in its own repository,
    [weftspun/h2o-bench-tpcc](https://github.com/weftspun/h2o-bench-tpcc)
    (`rfd/0022-weftspun-studio-consumer.md`,
    [PR #1](https://github.com/weftspun/h2o-bench-tpcc/pull/1)),
    per the user's own direction: `weftspun_studio` is a backend
    service, not the state database, so the open question belongs
    beside the project that would host the state, not here.
    """

    attest_in :none

    related ~S"""
    RFD 1077 gives the CDN question that raised this one. RFD 1061 and
    RFD 1062 name `multiplayer-fabric-godot` as the asset-streaming
    transport's other consumer, and a candidate home for this server.
    """

    drafted_by :ai
  end
end
