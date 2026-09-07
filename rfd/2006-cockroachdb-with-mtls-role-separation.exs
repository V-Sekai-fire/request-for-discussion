# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2006. `mix rfd.render` in rfd_dsl/ renders rfd/2006-cockroachdb-with-mtls-role-separation/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2006 do
  use RFD.DSL

  rfd 2006, "Cockroachdb with mtls role separation" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The stack needs a relational database reachable by the Elixir gateway
    and the Phoenix zone backend. It must support schema migrations (DDL)
    separately from application queries (DML) to limit blast radius if
    application credentials are compromised.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Cockroachdb with mtls role separation"

    details "Context", ~S"""
    The stack needs a relational database reachable by the Elixir gateway and
    the Phoenix zone backend. It must support schema migrations (DDL)
    separately from application queries (DML) to limit blast radius if
    application credentials are compromised.
    """

    details "Consequences", ~S"""
    - `--advertise-addr` must be `localhost`. A flycast address routes the
      internal gRPC loopback through Fly's NAT, breaking the admin UI.
    - `prepare: :unnamed` is required in Postgrex to avoid statement-cache
      OOM on single-node deployments.
    - Port 26257 is never publicly exposed. Access is via Fly's private
      network (6PN) using `socket_options: [:inet6]` in Ecto, because
      `.internal` DNS returns only AAAA records.
    - The `root` cert is provisioned on the CRDB machine only.
      `gateway_admin` is the highest-privilege cert available to the
      application.
    """

    drafted_by :ai
  end
end
