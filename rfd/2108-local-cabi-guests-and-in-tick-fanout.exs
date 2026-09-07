# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2108. `mix rfd.render` renders rfd/2108-local-cabi-guests-and-in-tick-fanout/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2108 do
  use RFD.DSL

  rfd 2108, "Local cabi guests and in tick fanout" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    Every number comes from `rfd/0097` and `rfd/0096`. One ZoneTick at 64
    Hz is 15.6 ms.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Local cabi guests and in tick fanout"

    details "The measurements this rests on", ~S"""
    Every number comes from `rfd/0097` and `rfd/0096`. One ZoneTick at
    64 Hz is 15.6 ms.

    | Path                                  | Median     | Fraction of one tick |
    | ------------------------------------- | ---------- | -------------------- |
    | FDB watch fire, publish to subscriber | 12214.3 us | 78 percent           |
    | FDB commit, one publish               | 3552.9 us  | 23 percent           |
    | FDB versionstamp log append           | 2509.5 us  | 16 percent           |
    | `AF_UNIX` round trip, from `rfd/0096` | 8.9 us     | 0.06 percent         |

    A local C ABI call removes the 8.9 us hop as well, because the guest
    shares the address space.
    """

    details "Why watches stay unused", ~S"""
    Three facts from `rfd/0097` rule them out, and each one is enough:

    - The watch path is about 1371 times slower than an `AF_UNIX` round
      trip.
    - The probe held exactly 10000 concurrent watches, then failed with
      error 1032, `Too many watches currently set`. That cap belongs to the
      database, and a fabric of many zones shares it.
    - A watch is edge-triggered. It reports that a key changed, not what
      the value became. A subscriber re-reads the key, and values that
      change between the fire and the re-read are lost.

    The third fact is the one that disqualifies a watch as an event stream,
    independent of speed.
    """

    details "The ring, and why one writer", ~S"""
    The tick is the only writer, so the write side needs no lock. A reader
    holds a cursor, and it advances at its own rate.

    Serializing once is the point. Fan-out to N subscribers costs one
    serialization and N pointer writes, rather than N serializations. The
    packet is 100 bytes and integral, per `rfd/0053`, so a subscriber reads
    the same bytes the wire carries.
    """

    details "Wakeup batching", ~S"""
    A cross-loop delivery needs a wakeup, and a wakeup is a syscall. One
    wakeup per message does not hold at this rate.

    Signal a loop once per tick instead, after the ring advances. At 64 Hz
    that caps a loop near 64 wakeups per second, whatever the message
    count.
    """

    details "Back-pressure, which needs a rule per channel", ~S"""
    A lagging reader must never stall the writer. A cursor that falls out
    of the ring gets dropped, and the subscriber receives a resync signal
    rather than a gap.

    `rfd/0049` makes fabric channels reliability classes, and that gives
    the rule its vocabulary. A state channel may drop, because the next
    tick supersedes the last one. A control channel may not drop, so it
    needs its own path rather than the ring.
    """

    details "The sandbox this removes", ~S"""
    A local `.so` shares the zone's address space. A guest fault takes the
    zone down, and a guest reads any memory the zone holds.

    `rfd/0083` chose Fil-C for memory safety against untrusted client
    input. `rfd/0095` built two guest classes for the same reason. Local
    mode has neither property.

    That is correct for first-party simulation code, which the project
    writes and builds. It is wrong for user-generated code. `rfd/0094`'s
    UGC loop therefore needs a mechanism this record does not supply.
    """

    details "What this resolves in RFD 2107", ~S"""
    Two of the four open questions close.

    The tick drives the `libfdb_c` callbacks, and h2o's ingress loop does
    not. The callback chain of `rfd/0073` moves with the tick, and the
    durable append runs off-tick.

    The guest boundary sits in-process, over the C ABI, for simulation
    guests.

    Two questions stay open, and one arrives.

    Where Elixir and `zone-backend` sit is unchanged by this record.

    Which part terminates a WebTransport session stays open, and it now
    matters more. This record binds a subscriber to the loop that owns its
    connection. `rfd/0097` states that the zone server holds subscriber
    connections through picoquic and WebTransport, and `rfd/0088` chose
    picoquic over h2o's own QUIC. So the owning loop is h2o's thread for
    HTTP and picoquic's loop for WebTransport. Whether those unify decides
    how many cross-loop wakeups a tick needs.

    How a UGC guest runs is the new question. Local mode does not sandbox,
    so the UGC loop needs its own record.
    """

    drafted_by :ai
  end
end
