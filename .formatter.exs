# Formats every RFD's taskweft RECTGTN domain/problem/plan file.
# Moved here from weftspun-3d-studio's own root .formatter.exs when
# decisions/ itself moved to this repository.
# `*/*` reached scripts/ when the logbook merged in, and its .exs files were
# never mix-formatted. Each half keeps the convention it arrived with.
[
  inputs: ["[0-9][0-9][0-9][0-9]-*/*.{ex,exs}"],
  line_length: 98,
  # RFD.DSL's fields (rfd_dsl/.formatter.exs exports the same list) read as
  # declarations: `state :discussion`, not `state(:discussion)`.
  locals_without_parens: [
    rfd: 3,
    state: 1,
    feature: 1,
    scope: 1,
    flight_level: 1,
    decision: 1,
    problem: 1,
    references: 1,
    related: 1,
    drafted_by: 1,
    details: 2
  ]
]
