# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1074. `mix rfd.render` in rfd_dsl/ renders rfd/1074-3d-billboard-labels/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1074 do
  use RFD.DSL

  rfd 1074, "A caption label over each billboard card" do
    state :moved

    preamble ~S"""
    Developed in its own repository,
    [weftspun/billboard-labels](https://github.com/weftspun/billboard-labels),
    per the user's own direction: a feature too large for one session,
    built where it can be reviewed as a pull request. Moves back to
    this directory once that PR lands.
    """

    attest_in :none

    drafted_by :ai
  end
end
