# SPDX-License-Identifier: MIT
#
# This RFD is authored in the DSL it proposes. `mix rfd.render` in rfd_dsl/
# writes README.md and DETAILS.md beside this file; `mix rfd.check` refuses a
# hand edit to either. The Python gates then read the rendered files as before.
defmodule RFD2232 do
  use RFD.DSL

  rfd 2232, "RFD authoring as an Elixir DSL" do
    state :discussion
    flight_level :l2

    feature(
      "one `rfd.exs` per RFD, compiled by `RFD.DSL`; README.md and DETAILS.md " <>
        "are renderings of it, and the render is checked in"
    )

    scope(
      "`rfd_dsl/` (the Mix project), any `rfd/NNNN-slug/rfd.exs`; RFDs without " <>
        "a source stay as they are"
    )

    decision("""
    An RFD may be an Elixir module that uses `RFD.DSL`: one `rfd` block with
    `state`, `feature`, `scope`, `flight_level`, `decision`, `problem`,
    `references`, `related`, `details` sections and `drafted_by`. The block
    builds an `RFD.Doc` and validates it against RFD 1000 while the file
    compiles, so a state outside the list, a missing Decision, a README over
    40 lines or an em-dash join is a compile error that names the rule.
    `mix rfd.render` writes README.md and DETAILS.md in the shape the gates
    and `render_site.py` read, which is how the document reaches Quarto;
    `RFD.Doc.qmd/1` adds YAML front matter for a project without that script.
    """)

    problem("""
    The shape is enforced after the fact by four Python gates reading
    Markdown, and 143 problems accumulated before one pass fixed them. The
    taskweft domains beside many RFDs are already Elixir, so the authoring
    form that can refuse a malformed document before it is written is the
    language the repository already runs in its hooks.
    """)

    references(["RFD 1000, the shape", "RFD 2177, the flight_level tag on the register"])

    related(
      "RFD 1000 (the README limit and the spine), RFD 2177 (the register " <>
        "carries `flight_level`, so the DSL writes it to the register row, not " <>
        "the README), RFD 2026 (commit style the rendered files ride on)."
    )

    details("What the render is checked against", """
    `mix test` in `rfd_dsl/` runs the positive case and six negative controls:
    an unknown state, a missing Decision, a 40-line overflow, an em-dash join,
    a pompous copula and an `exact` on a soft noun are each refused, and a
    broken source fails at compile time with the rule in the message. The
    rendered README of this RFD then passes `check-rfd-structure.py`,
    `check_tropes.py` and `check_rfd_canary.py` unchanged, which is the
    compatibility claim: the DSL emits what the existing pipeline consumes.
    """)

    details("What the DSL does not do", """
    It does not allocate serials; the register stays the source of a serial
    and `register_row/2` only formats the row for it. It does not render
    Quarto itself; `quarto render` runs on the files as before. It does not
    rewrite existing RFDs: a directory without `rfd.exs` is untouched, and a
    directory with one is refused by `mix rfd.check` when README.md or
    DETAILS.md no longer match the source.
    """)

    drafted_by :ai
  end
end
