# rfd_dsl

Author an RFD and a serial register as Elixir; the Markdown and the `.usda` are renderings. RFD 2232 says why.

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

    defmodule Serials.VSekaiFabric do
      use RFD.Register

      register "VSekaiFabric" do
        layer arc: "1.3.6.1.4.1.66606.1.2", site: 2, site_name: "v-sekai-fabric", ...
        thesis "Every serial this site has allocated. ..."

        allocated do
          serial 2000, "conventions"
          serial 2229, "interchangeable-parts-consolidation", flight_level: :l3
        end

        deleted do
          serial 2003, "castspell-sandbox-package-and-manifest-encoding"
        end
      end
    end

Both validate while the file compiles: a state outside the list, a missing Decision, a
README over 40 lines, a serial listed twice, a serial from another site or a retired
row naming no serial is a compile error that names the rule. Tropes are warnings.

    mix rfd.render                 # rfd/NNNN-slug.exs -> rfd/NNNN-slug/{README,DETAILS}.md
                                   # SERIALS*.exs      -> SERIALS*.usda
    mix rfd.render 2232-rfd-dsl-in-elixir
    mix rfd.render --check         # fail when a rendered file on disk drifted
    mix rfd.check                  # compile every source
    mix rfd.serials [--base REF]   # the registers against the tree and a base revision
    mix rfd.usda SERIALS.exs       # one register's layer on stdout
    mix rfd.import [--force]       # README/DETAILS -> .exs (the one-off conversion)
    mix test                       # the positive cases and the negative controls

The rendered files are build artifacts and `.gitignore` names them: the README is the
CommonMark `scripts/check-rfd-structure.py` and `scripts/render_site.py` read, and the
`.usda` is what `scripts/check-rfd-serials.py` and `pen-66606.usda` read. CI and the
prek hooks render before any gate reads the tree. The `flight_level` goes to the
register row, never the README, as RFD 2177 decides.
