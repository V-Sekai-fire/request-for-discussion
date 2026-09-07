# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

# The DSL's fields read as declarations, so the formatter leaves their parens off:
# `state :discussion`, not `state(:discussion)`. The root .formatter.exs carries the
# same list for the rfd/*/rfd.exs sources it formats.
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 98,
  locals_without_parens: [
    rfd: 3,
    register: 2,
    layer: 1,
    thesis: 1,
    allocated: 1,
    unused: 2,
    deleted: 1,
    deleted: 2,
    serial: 2,
    serial: 3,
    never_written: 1,
    retired: 2,
    state: 1,
    feature: 1,
    scope: 1,
    flight_level: 1,
    decision: 1,
    problem: 1,
    references: 1,
    related: 1,
    drafted_by: 1,
    details: 2,
    details_title: 1,
    details_preamble: 1,
    preamble: 1,
    front_matter: 1,
    compact_head: 1,
    attest_in: 1,
    details_pointer: 1,
    section: 2
  ],
  export: [
    locals_without_parens: [
      rfd: 3,
      register: 2,
      layer: 1,
      thesis: 1,
      allocated: 1,
      unused: 2,
      deleted: 1,
      deleted: 2,
      serial: 2,
      serial: 3,
      never_written: 1,
      retired: 2,
      state: 1,
      feature: 1,
      scope: 1,
      flight_level: 1,
      decision: 1,
      problem: 1,
      references: 1,
      related: 1,
      drafted_by: 1,
      details: 2,
      details_title: 1,
      details_preamble: 1,
      preamble: 1,
      front_matter: 1,
      compact_head: 1,
      section: 2
    ]
  ]
]
