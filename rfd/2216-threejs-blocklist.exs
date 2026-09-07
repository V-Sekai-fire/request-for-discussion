# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2216. `mix rfd.render` in rfd_dsl/ renders rfd/2216-threejs-blocklist/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2216 do
  use RFD.DSL

  rfd 2216, "Three.js blocklist" do
    state :discussion

    feature "three.js goes on the CLAUDE.md / BLOCKLIST.md\nblocklist as an in-browser 3D runtime"

    scope "`CLAUDE.md`, `BLOCKLIST.md`, cascade of retirements\nin consumer files"

    decision ~S"""
    Blocklist three.js as an in-browser 3D runtime. Substitute is
    **Godot as a native binary per platform** built from
    `entities-godot-sandbox` with the Vulkan renderer (MoltenVK on
    macOS). Three.js itself is MIT-licensed, the objection is not
    licence, it is
    runtime story: the workspace ships every 3D surface via Godot,
    and a three.js path forks the scene-graph, material pipeline,
    animation graph, and lighting model.
    
    Live rows: `CLAUDE.md` blocklist table + `BLOCKLIST.md` full
    section (the section body carries the argument in current form).
    """

    related ~S"""
    - [RFD 2210](../2210-atelier-godot-web-shipping-surface/), L3
      strategic bet.
    - [RFD 2211](../2211-base-tree-entities-godot-sandbox/), base
      tree pick.
    - [RFD 2215](../2215-one-binary-two-heads/), the "one runtime,
      not two" argument that also drives this blocklist.
    - RFD 1170 (cleanroom presence loop), earlier RFD picking Godot
      over three.js for a different workload.
    """

    drafted_by :ai
  end
end
