# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1054. `mix rfd.render` renders rfd/1054-headless-cms-on-taskweft/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1054 do
  use RFD.DSL

  rfd 1054, "The planner inside the studio core" do
    state :published

    scope "`weftspun_studio/`"

    attest_in :none

    decision ~S"""
    Delete `extension/`. Put the planner inside `weftspun_studio`, which
    RFD 1019 already makes the API server.

    RFD 1023 gives the shape, and this RFD does not restate it.

    See `DETAILS.md` for the wrong-answer record of a second application
    and the port-mocking rule. It also gives the measured plans, three
    taskweft fixes this work needed, and the two planner routes.
    """

    problem ~S"""
    `extension/` ran Elixir in an editor panel, through Popcorn and
    AtomVM. It proved the pipeline, and it could not ship.

    AtomVM needs `SharedArrayBuffer`, thus the page must be cross-origin
    isolated. An editor webview is not isolated, and an extension cannot
    set the headers. The panel worked only with `codium --enable-coi`.

    The proof stands, and the vehicle does not.
    """

    related ~S"""
    RFD 1019 makes this the API server. RFD 1023 gives the shape. RFD 1037
    gives the composite convention. RFD 1055 selects the worker host.
    """

    details_title "The planner inside the studio core"

    details "A second application was the wrong answer first", ~S"""
    This RFD first built `cms/`, a new Elixir application. That was a
    mistake, and the record of it matters more than the correction.

    `weftspun_studio` already held ports, adapters, an HTTP router, Ecto,
    and CockroachDB. RFD 1019 and RFD 1020 record it. The second
    application duplicated every one of those.

    Three parts were new, and only those moved:

    | Part               | Where it lives now              |
    | ------------------ | ------------------------------- |
    | Planning documents | `priv/domains`, `priv/problems` |
    | `Ports.Planner`    | Beside the other ports          |
    | `TaskweftPlanner`  | Beside the other adapters       |

    `cms/` is deleted. That also settles the overlap with RFD 1023, which
    this RFD carried while it described a parallel application.
    """

    details "Mock every port, and keep the documents real", ~S"""
    Every port is a `Mox` mock. A mock derives from the behavior, thus a
    port that gains a callback breaks its mock when it compiles.

    The planning documents are the exception. A mocked domain proves
    nothing about the pipeline, because the domains are the pipeline.
    `pipeline_test.exs` mocks nothing, and it runs the real planner over
    the real documents.
    """

    details "The measured plans", ~S"""
    | Pipeline     | Steps | Composes                                   |
    | ------------ | ----: | ------------------------------------------ |
    | content_only |     3 | the base alone                             |
    | mesh         |     7 | base and stage_mesh                        |
    | avatar       |    10 | base, stage_mesh, stage_rig, and a problem |

    The avatar plan is the evidence. `stage_rig` calls `a_generate_mesh`,
    which `stage_mesh` defines, and that resolves only because the merge
    unions the actions of every document first.
    """

    details "Three faults came out of this", ~S"""
    The work needed three fixes to taskweft, and each came from use and
    not from reading. Each one answered `no_plan`, which names nothing.

    - Composition did not exist. `merge/2` was private to the CLI, and it
      took one domain and one problem. PR 207.
    - A shared variable replaced instead of merging its keys, thus the
      base lost the keys its own guards read. PR 208.
    - A goal serialized `eq: true` as the string `"true"`, thus it never
      matched a boolean in state. PR 209.

    PR 207 also rewrote the DSL diagnostics. A domain written against an
    API that does not exist compiled without complaint, and returned an
    empty document.
    """

    details "Two routes", ~S"""
    `/api/v1/pipelines` lists what this deployment knows.
    `/api/v1/pipelines/:name/plan` solves one and runs nothing, thus a
    caller sees the plan before it pays for the models.

    `Pipeline.parse/1` takes `String.to_existing_atom/1`. An HTTP caller
    must not fill the atom table, which never shrinks.
    """

    drafted_by :ai
  end
end
