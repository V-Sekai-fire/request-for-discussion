# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2235. Abandoned; the repository it specifies is archived.
defmodule RFD2235 do
  use RFD.DSL

  rfd 2235, "An ACP agent that plans with taskweft and executes through the editor" do
    state :abandoned

    flight_level :l2

    feature "retracted"

    scope "retracted"

    decision ~S"""
    Retracted 2026-09-10. `1-transport/transport-taskweft-acp`, the whole
    scope of this RFD, was archived on 2026-09-09 and its manifest entry
    removed. An RFD cannot specify a read-only repository.
    """

    drafted_by :ai
  end
end
