# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2230. Abandoned; the current answer is in RFD 2242.
defmodule RFD2230 do
  use RFD.DSL

  rfd 2230, "ggml adapters as sandboxed GDScript over one native module" do
    state :abandoned

    flight_level :l2

    feature "retracted"

    scope "retracted"

    decision ~S"""
    Retracted 2026-09-09. The GDScript-adapters shape is superseded
    by RFD 2242 (ggml consumers as native Godot modules stacked on
    modules/ggml), following the operator's 2026-09-09 directive to
    keep every consumer in native C++.

    See RFD 2242.
    """

    drafted_by :ai
  end
end
