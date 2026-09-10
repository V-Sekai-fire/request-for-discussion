# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2187. Abandoned; collapsed into RFD 2244.
defmodule RFD2187 do
  use RFD.DSL

  rfd 2187, "Identity ANNY via OmniGen2" do
    state :abandoned

    feature "retracted"

    scope "retracted"

    decision ~S"""
    Retracted 2026-09-10 into RFD 2244. Identity and fit are one deformation
    operator over different corner sets, and this RFD described half of it.
    """

    drafted_by :ai
  end
end
