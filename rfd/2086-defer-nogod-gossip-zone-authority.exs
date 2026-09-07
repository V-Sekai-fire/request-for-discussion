# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2086. `mix rfd.render` renders rfd/2086-defer-nogod-gossip-zone-authority/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2086 do
  use RFD.DSL

  rfd 2086, "Defer nogod gossip zone authority" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    `lean-rebac-core`'s `Rebac/core/NoGod.lean` (imported by `ReBAC.lean`)
    is a proven, coordinator-free gossip protocol for zone-range
    consensus: vector clocks (`VClock`), Hilbert-range containment
    (`ZoneRange`, `geometricAuthority`, `geometricInterest`), a hybrid
    logical clock (`HLC`), and theorems that gossip-based range adoption
    preserves `DisjointRanges` — no two zones ever claim overlapping
    authority — without a central coordinator.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Defer nogod gossip zone authority"

    details "Context", ~S"""
    `lean-rebac-core`'s `Rebac/core/NoGod.lean` (imported by `ReBAC.lean`)
    is a proven, coordinator-free gossip protocol for zone-range
    consensus: vector clocks (`VClock`), Hilbert-range containment
    (`ZoneRange`, `geometricAuthority`, `geometricInterest`), a hybrid
    logical clock (`HLC`), and theorems that gossip-based range adoption
    preserves `DisjointRanges`, no two zones ever claim overlapping
    authority, without a central coordinator.
    """

    details "Why not now", ~S"""
    `zone-server-h2o` today hardcodes `z_id = 0` in
    `src/transport/webtransport_server.c`, it binds one UDP port and
    services exactly one zone. There is no second zone to route between,
    no gossip peer to exchange `ZoneRange` claims with, and no vector
    clock needed to order events that, by construction, all originate
    from the one process that has them. Porting the full
    `VClock`/gossip/`HLC` system now would build structure for a need
    that does not exist yet.
    """

    details "What ports cleanly when multi-zone routing is real work", ~S"""
    When a second zone exists, the reusable piece is narrow: `ZoneRange`
    (a `{zoneId, lo, hi}` Hilbert-code interval) and `ZoneRange.contains`
    / `geometricAuthority` (find the zone whose range contains a given
    Hilbert code), about ten lines of pure C, directly portable the same
    way `rebac.c` was. The gossip protocol (`NodeView`, `GossipMsg`,
    `VClock.merge`, `HLC.advance`/`HLC.merge`) is what makes authority
    assignment coordinator-free across multiple zone-server processes —
    worth porting once there are multiple processes to coordinate, not
    before.
    """

    details "Revisit when", ~S"""
    A second concurrently-running zone process exists (not just a second
    `z_id` value handled by the same process). At that point, port
    `ZoneRange`/`geometricAuthority` first (needed immediately), and the
    gossip/`VClock`/`HLC` layer only once there is a real second process
    to gossip with.
    """

    details "Related", ~S"""
    - `rfd/2083-zone-server-h2o-replaces-godot-fabriczone`: the
      consolidation decision this defers within.
    - Original record: `zone-server-h2o`'s own
      `docs/0001-defer-nogod-gossip-authority.md` (removed once this RFD
      carried its content forward).
    """

    drafted_by :ai
  end
end
