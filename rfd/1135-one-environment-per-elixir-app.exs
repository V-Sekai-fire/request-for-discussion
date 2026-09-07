# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1135. `mix rfd.render` in rfd_dsl/ renders rfd/1135-one-environment-per-elixir-app/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1135 do
  use RFD.DSL

  rfd 1135, "One Python environment per Elixir app" do
    state :discussion

    feature "how an Elixir app reaches Python"

    scope "`7-service/service-livebook`"

    attest_in :none

    decision ~S"""
    An Elixir app reaches Python through pythonx and through nothing else.
    `priv/python/check_pixi_free.py` fails the build on a call to the other
    environment manager, and it reads prose without complaining, so the rule
    stays writable.
    
    An embedded interpreter starts once, with one dependency set. So a second
    dependency set is a second app: its own mix project, its own setup cell,
    its own runtime. The gate holds that too. It reads the `pyproject.toml`
    cell of every notebook in an app and fails when two of them differ.
    
    This is what the corpus repository's environments were for. OmniGen2 pins
    torch 2.6.0+cu124 and EditScore pins cu128, and no interpreter holds
    both. That separation stays, as apps beside each other rather than
    environments inside one app. The corpus repository keeps its own
    environments, and what is forbidden is this app calling into them.
    """

    problem ~S"""
    `service-livebook` embeds a Python interpreter with `pythonx`. Its setup
    cell names the packages and the pins travel in the notebook file. Beside
    that, a helper shelled into five environments in another repository. The
    notebook described three packages while the loop depended on five
    environments it never names, so it ran on one desk and nowhere else.
    
    The failure was not theoretical. Loop 1 stopped with `No module named
    'drjit'`, because it called the `anny` environment for a renderer that
    only the default environment carries. The notebook cannot show that.
    """

    related ~S"""
    RFD 1134 tests these notebooks in the browser, which is how the missing
    renderer was found.
    """

    drafted_by :ai
  end
end
