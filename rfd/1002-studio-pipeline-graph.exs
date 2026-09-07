# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1002. `mix rfd.render` renders rfd/1002-studio-pipeline-graph/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1002 do
  use RFD.DSL

  rfd 1002, "Studio pipeline graph" do
    state :published

    feature "Studio pipeline"

    attest_in :none

    decision ~S"""
    Model the pipeline as a locked node graph. Each node is one stage.
    Each edge is a dependency. The graph has two views: a flow graph
    and a kanban board.

    Stages, in order: Prompt, Image, Layers, Mesh, Rig, Motion, Export.

    Runnable kinds, in order: text_to_image, layer_decomposition,
    image_to_3d, auto_rigging, motion_validation.

    The data model stays pure. The executor runs the nodes. Old saved
    projects migrate to the new template. Migration inserts missing
    stages.

    See `DETAILS.md` for file references.
    """

    problem ~S"""
    A user wants to go from a text prompt to an animatable asset.
    The steps are sequential. Each step needs a status and a result.
    """

    related ~S"""
    RFD 1003 defines the job lifecycle. RFD 1006 defines layer
    decomposition. RFD 1007 defines motion validation. RFD 1008 defines
    appearance remix.
    """

    details_title "Studio pipeline graph"

    details_preamble ~S"""
    - Data model: `src/library/studioGraph.js`
    - Executor: `src/library/studioGraphExecutor.js`
    - Page: `src/pages/StudioPage.jsx`
    - Views: `src/components/studio/StudioGraphView.jsx`
    - Views: `src/components/studio/StudioKanbanView.jsx`
    """

    drafted_by :ai
  end
end
