# The DSL's fields read as declarations, so the formatter leaves their parens off:
# `state :discussion`, not `state(:discussion)`. The root .formatter.exs carries the
# same list for the rfd/*/rfd.exs sources it formats.
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 98,
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
  ],
  export: [
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
]
