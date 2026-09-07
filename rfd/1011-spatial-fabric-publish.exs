# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1011. `mix rfd.render` in rfd_dsl/ renders rfd/1011-spatial-fabric-publish/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1011 do
  use RFD.DSL

  rfd 1011, "Spatial fabric publish" do
    state :published

    feature "spatial fabric"

    attest_in :none

    decision ~S"""
    Add a publish flow for completed tasks.

    - Publish RP1 sends the completed mesh to the spatial fabric.
    - Validate OMB tier checks the GLB export against the fabric.

    The flow opens the Scene Assembler in a new tab. The spatial
    fabric adapter checks the manifest and the tier presets.
    """

    problem ~S"""
    A completed mesh task should reach shared worlds. The app needs a
    publish path to the spatial fabric. The fabric needs a valid
    manifest and a scene assembler.
    """

    references ~S"""
    - Adapter: `src/library/spatialFabricAdapter.js`
    - Hook: `src/hooks/useSpatialFabric.js`
    - Presets: `src/library/ombExportPresets.js`
    - Docs: `docs/SPATIAL_FABRIC_INTEGRATION.md`
    """

    related ~S"""
    RFD 1007 replaces the publish terminal validation with motion
    validation in the Studio pipeline.
    """

    drafted_by :ai
  end
end
