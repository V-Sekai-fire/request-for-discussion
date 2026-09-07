# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2040. `mix rfd.render` renders rfd/2040-hexagon-combat-core/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2040 do
  use RFD.DSL

  rfd 2040, "Hexagon combat core" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The combat concern — combo timing, hit validation, the enemy
    spawn-invulnerability window, and damage — needs to be deterministic
    and testable with no server and no headset. Per
    `rfd/2028-hexagonal-core-ports-adapters` it becomes a core behind
    narrow ports.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Hexagon combat core"

    details "Context and problem statement", ~S"""
    The combat concern, combo timing, hit validation, the enemy
    spawn-invulnerability window, and damage, needs to be deterministic
    and testable with no server and no headset. Per
    `rfd/2028-hexagonal-core-ports-adapters` it becomes a core behind
    narrow ports.
    """

    details "Decision outcome", ~S"""
    Chosen option: structure combat as a hexagon. The core resolves the
    combo timing, validates each hit against the authoritative positions,
    holds the enemy invulnerable for its spawn window, and deducts health,
    as a pure reducer (`rfd/2033-core-contract-pure-reducer-byte-state`)
    over deterministic state
    (`rfd/2034-deterministic-cores-integer-seeded-rng`).

    Driving ports: `input_source` (player commands with timestamps and
    targets), `tick_source` (the constant-step clock), `behavior_source`
    (enemy intents). Driven ports: `state_sink` (authoritative entity
    state), `event_sink` (hits, deaths, door unlocks). Adapters:
    `feat/module-http3` feeds `input_source`; the `zone-server` hosts the
    core and drives `tick_source` under server authority
    (`decisions/20260611-server-authoritative-simulation-deferred-rollback.md`);
    sandboxed behavior (`rfd/2037-generated-behavior-sandboxed-riscv`)
    implements `behavior_source`; a fixture adapter replays recorded
    inputs for CI.
    """

    details "Consequences", ~S"""
    - The server-authoritative adapter binds `input_source` and
      `state_sink` with interpolation and no prediction for the deadline;
      the rollback adapter lands after the gate behind the same ports.
    - The combat core runs headless against fixtures, so a flaky adapter
      fails in isolation.
    - The melee archetype ships first; the ranged and caster archetypes
      land after the gate.
    """

    details "Confirmation", ~S"""
    The combat core passes its fixtures, and a melee combo lands a hit
    under server authority on the OpenXR client.
    """

    drafted_by :ai
  end
end
