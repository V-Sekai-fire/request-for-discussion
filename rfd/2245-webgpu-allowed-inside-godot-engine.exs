# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2245. `mix rfd.render` renders rfd/2245-webgpu-allowed-inside-godot-engine/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2245 do
  use RFD.DSL

  rfd 2245, "WebGPU allowed inside Godot engine" do
    state :discussion

    feature "carve-out on the WebGPU blocklist row: WebGPU is allowed\ninside a Godot engine fork; workspace deployment target stays Vulkan"

    scope "`CLAUDE.md` (row cell unchanged), `BLOCKLIST.md`\n(section body amended), `weftspun-keypoint/default.xml` (add\nentities-webgpu fork alongside entities-godot)"

    decision ~S"""
    WebGPU is allowed as a RenderingDevice driver inside a Godot
    engine fork. The row still blocks WebGPU as a *workspace
    render / compute target* — the atelier shipping surface stays
    Vulkan / MoltenVK per RFD 2210 — but porting davnotdev's
    WebGPU driver into a Godot fork is in-scope.

    A Godot engine that carries both drivers keeps the workspace's
    Vulkan pick for the shipping surface and gives an in-tree
    WebGPU path if it is ever wanted upstream. The atelier binary
    still selects `RenderingDevice`'s Vulkan backend at boot.
    """

    problem ~S"""
    The WebGPU blocklist row lists "Godot forks whose sole purpose
    is a WebGPU renderer" as blocked. Read literally, that reaches
    the entities-webgpu fork one session over — where davnotdev's
    WebGPU driver is being ported on top of feat/ci-ar-response-file.
    The row's intent was to keep the workspace deployment target on
    Vulkan, not to ban WebGPU code inside an engine fork. Operator
    directive 2026-09-11: WebGPU is now allowed in the Godot engine.
    """

    section "Details", ~S"""
    The BLOCKLIST.md WebGPU section's "What the row does not cover"
    gains a Godot-engine-fork carve-out. The row's summary in
    CLAUDE.md ("WebGPU as a workspace render / compute target")
    already scopes narrowly; no edit there.

    See DETAILS.md for the amendment text and the manifest entry.
    """

    related ~S"""
    - [RFD 2210](../2210-atelier-godot-web-shipping-surface/), L3
      strategic bet — atelier ships Godot's Vulkan renderer, which
      the carve-out does not touch.
    - [RFD 2211](../2211-base-tree-entities-godot-sandbox/), base
      tree pick — entities-godot-sandbox stays the atelier substrate.
    - [RFD 2216](../2216-threejs-blocklist/), the sibling row that
      names WebGPU as separately blocklisted; that row's argument
      is unchanged.
    - The WebGPU blocklist row in `BLOCKLIST.md` and CLAUDE.md,
      whose "What the row does not cover" this RFD amends.
    """

    details_title "webgpu allowed inside godot engine"

    details "Amendment text for BLOCKLIST.md", ~S"""
    The WebGPU section's "What the row does not cover" adds:

    > A Godot engine fork carrying a WebGPU RenderingDevice driver
    > alongside Vulkan is in-scope. The row blocks WebGPU as the
    > *workspace deployment target*; it does not block WebGPU code
    > inside a Godot engine tree. The atelier binary still selects
    > the Vulkan backend at boot, and the shipping surface stays
    > `entities-godot-sandbox` with MoltenVK on macOS.
    """

    details "Manifest entry", ~S"""
    `weftspun-keypoint/default.xml` gains one project for the
    entities-webgpu fork alongside entities-godot. The revision is
    the branch on which the WebGPU driver is being ported
    (davnotdev/godot@webgpu on top of feat/ci-ar-response-file).

    Path lands under `4-entities/entities-webgpu` (side 4, one repo
    per model, next to entities-godot).
    """

    details "What this does not open", ~S"""
    - `Ggml.WebGPU=ON` and successor flags stay blocked. The
      inference substrate is ggml + Vulkan on native (RFD 2188).
    - Dawn / wgpu-native as a workspace build dependency stays
      blocked. Any WebGPU code lives inside the Godot engine tree
      and links through Godot's own driver.
    - ORT-Web + TFJS WebGPU execution providers stay blocked; the
      ORT-Web / TFJS row above the WebGPU row is not touched.
    - three.js as an in-browser 3D runtime stays blocked (RFD 2216).
    """

    drafted_by :ai
  end
end
