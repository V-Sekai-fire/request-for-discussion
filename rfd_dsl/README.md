# rfd_dsl

Author an RFD as Elixir; README.md and DETAILS.md are renderings of it. RFD 2232 says why.

    defmodule RFD2232 do
      use RFD.DSL

      rfd 2232, "RFD authoring as an Elixir DSL" do
        state :discussion
        flight_level :l2
        feature "..."
        scope "..."
        decision """
        ...
        """
        problem """
        ...
        """
        references ["RFD 1000, the shape"]
        related "RFD 1000."
        details "A heading", """
        ...
        """
        drafted_by :ai
      end
    end

The block validates against RFD 1000 while the file compiles: a state outside the list,
a missing Decision, a README over 40 lines, an em-dash join, a pompous copula or an
`exact` on a soft noun is a compile error that names the rule.

    mix rfd.render                 # every rfd/NNNN-slug/rfd.exs -> README.md, DETAILS.md
    mix rfd.render 2232-rfd-dsl-in-elixir
    mix rfd.render --qmd ...       # also index.qmd with YAML front matter
    mix rfd.check                  # refuse when a rendered file drifted from its source
    mix test                       # the positive case and six negative controls

The README is the CommonMark `scripts/check-rfd-structure.py` and `scripts/render_site.py`
read, so it reaches Quarto through the same pipeline as a hand-written one. The
`flight_level` goes to the register row (`RFD.Doc.register_row/2`), never the README,
as RFD 2177 decides. A directory without `rfd.exs` is untouched.
