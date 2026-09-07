# request-for-discussion

Every RFD and both serial registers as Elixir sources; one Mix project renders, gates, serves and answers them over MCP.

    rfd/NNNN-slug.exs          one RFD, `use RFD.DSL`
    SERIALS*.exs               one serial register per site, `use RFD.Register`
    lib/                       the DSL, the renderers, the site, the MCP server
    logbook/                   what was measured, next to what it retracts

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
    mix rfd.render --check         # fail when a rendered file on disk drifted
    mix rfd.check                  # compile every source
    mix rfd.serials [--base REF]   # the registers against the sources and a base revision
    mix rfd.usda SERIALS.exs       # one register's layer on stdout
    mix rfd.serve [--port 4000]    # the site and the MCP endpoint, locally
    mix rfd.pack                   # priv/corpus.bin, what the release boots from
    mix test                       # the positive cases and the negative controls

The rendered files are build artifacts and `.gitignore` names them: the README is the
CommonMark the Python gates read, and the `.usda` is what `check-rfd-serials.py` and
`pen-66606.usda` read. CI and the prek hooks render before any gate reads the tree.

The same corpus is a site and a public, read-only MCP endpoint on Fly (`fly.toml`,
`Containerfile`, the Deploy workflow). A new RFD is a new `.exs` and one `serial`
line in the fabric register's `allocated` block; the endpoint's `get_register` tool
names the next unused serial. RFD 2232 carries the argument.
