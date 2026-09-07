# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2033. `mix rfd.render` renders rfd/2033-core-contract-pure-reducer-byte-state/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2033 do
  use RFD.DSL

  rfd 2033, "Core contract pure reducer byte state" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    Every hexagonal core (`rfd/2028-hexagonal-core-ports-adapters`) needs
    to be replayable, snapshot-able, fixture-testable, and
    transport-agnostic. A core that hides mutable state behind methods
    defeats all four.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Core contract pure reducer byte state"

    details "Context and problem statement", ~S"""
    Every hexagonal core (`rfd/2028-hexagonal-core-ports-adapters`) needs
    to be replayable, snapshot-able, fixture-testable, and
    transport-agnostic. A core that hides mutable state behind methods
    defeats all four.
    """

    details "Considered options", ~S"""
    - Stateful objects whose internal state lives behind methods.
    - A pure reducer over an explicit, serializable state value.
    """

    details "Decision outcome", ~S"""
    Chosen option: model each core as a pure reducer,
    `step : State -> Event -> State x Effects`, with `State`, `Event`, and
    `Effects` serialized to bytes deterministically, so the core is bytes
    to bytes. The flat C ABI exposes `step` plus `snapshot` and `restore`
    over the byte state, and the compute kernels lower through
    `rfd/2032-core-codegen-lean-slang` to SPIR-V, dispatched on the GPU.
    Hidden mutable state defeats snapshots and exact fixtures, so the
    first option loses replay and rollback.

    With `rfd/2034-deterministic-cores-integer-seeded-rng`, this makes
    replay byte-exact and snapshots a value copy.
    """

    details "Consequences", ~S"""
    - Snapshots and rollback are copies of the state bytes.
    - Fixtures pin exact output bytes, so a divergence shows up as a
      failing fixture.
    - The same `step` backs every adapter, so `webtransportd` and the
      engine carry the same bytes.
    """

    details "Confirmation", ~S"""
    Replaying an event log reproduces the state bytes on every target.
    """

    drafted_by :ai
  end
end
