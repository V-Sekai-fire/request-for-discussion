# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1006. `mix rfd.render` in rfd_dsl/ renders rfd/1006-layer-decomposition-see-through/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1006 do
  use RFD.DSL

  rfd 1006, "Layer decomposition (See-Through)" do
    state :discussion

    feature "image-to-layers"

    attest_in :none

    decision ~S"""
    Add a layer decomposition stage between text to image and image to
    3D. The stage runs the See-Through model.
    
    The task decomposes one image into RGBA body-part layers. It returns
    a layers zip, a PSD, a composite URL, and a layer count. The Studio
    pipeline stores the artifacts on the layer_decomposition node.
    Image to 3D prefers the composite image as its input.
    """

    problem ~S"""
    An anime illustration is one flat image. A user wants to edit the
    hair, the face, and the clothing separately. Image to 3D also works
    better with a clean subject.
    """

    references ~S"""
    - Paper: https://doi.org/10.1145/3799902.3811209
    - Cog model: weftspun/see-through (branch cog)
    - Executor: `src/library/taskManager.js`
    - URLs: `src/library/taskModelUrl.js`
    
    **WITHDRAWN 2026-08-29: See-Through is a reference, not a model here.**
    RFD 1166 dropped it from the candidate ranking because every checkpoint
    its inference scripts load states no licence, and the depth one is a
    fine-tune of an OpenRAIL++-M model whose restrictions travel into
    derivatives. What is kept is the layer taxonomy in
    `common/live2d/scrap_model.py`. The approach below still describes the
    task; it no longer describes a model this workspace can run.
    """

    related ~S"""
    RFD 1002 places the stage in the pipeline. RFD 1008 remixes the
    layers into appearance traits. RFD 1004 catalogs the task.
    """

    drafted_by :ai
  end
end
