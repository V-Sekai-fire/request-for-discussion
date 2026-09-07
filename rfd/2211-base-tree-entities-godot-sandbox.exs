# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2211. `mix rfd.render` in rfd_dsl/ renders rfd/2211-base-tree-entities-godot-sandbox/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2211 do
  use RFD.DSL

  rfd 2211, "base tree: `entities-godot-sandbox` for the atelier" do
    state :discussion

    decision ~S"""
    `entities-godot-sandbox` is the atelier base tree. It carries local
    `modules/sandbox/` modifications libriscv needs for the ELF loader
    path (RFD 2213 loads godot-vrm as a sandboxed ELF, RFD 2230 loads
    GDScript ggml adapters under Godot's script sandbox). Pin the exact
    commit in `.repo/manifests/default.xml`.
    """

    related ~S"""
    - [RFD 2210](../2210-atelier-godot-web-shipping-surface/), L3.
    - [RFD 2213](../2213-vrm-via-godot-sandbox-elf/), sandbox ELF loader.
    - [RFD 2229](../2229-interchangeable-parts-consolidation/) —
      consolidation policy.
    """

    drafted_by :ai
  end
end
