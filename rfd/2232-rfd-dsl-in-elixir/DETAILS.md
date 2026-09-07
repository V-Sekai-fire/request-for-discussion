# RFD 2232 details: RFD authoring as an Elixir DSL

This RFD was drafted by an AI and read by a human before it shipped.

## What the render is checked against

`mix test` in `rfd_dsl/` runs the positive case and six negative controls:
an unknown state, a missing Decision, a 40-line overflow, an em-dash join,
a pompous copula and an `exact` on a soft noun are each refused, and a
broken source fails at compile time with the rule in the message. The
rendered README of this RFD then passes `check-rfd-structure.py`,
`check_tropes.py` and `check_rfd_canary.py` unchanged, which is the
compatibility claim: the DSL emits what the existing pipeline consumes.

## What the DSL does not do

It does not allocate serials; the register stays the source of a serial
and `register_row/2` only formats the row for it. It does not render
Quarto itself; `quarto render` runs on the files as before. It does not
rewrite existing RFDs: a directory without `rfd.exs` is untouched, and a
directory with one is refused by `mix rfd.check` when README.md or
DETAILS.md no longer match the source.
