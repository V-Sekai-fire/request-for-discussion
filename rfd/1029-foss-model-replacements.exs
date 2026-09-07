# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1029. `mix rfd.render` in rfd_dsl/ renders rfd/1029-foss-model-replacements/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1029 do
  use RFD.DSL

  rfd 1029, "FOSS model replacements" do
    state :published

    feature "model licensing"

    attest_in :none

    decision ~S"""
    Replace each deleted model with a permissive alternative. Prefer the
    MIT license and the BSD license.

    See `DETAILS.md` for the PartField, FastMesh, and PartPacker
    replacements, each with its candidates and its license.
    """

    problem ~S"""
    RFD 1028 removes three models from the catalog. Their tasks still
    need a model.
    """

    related ~S"""
    RFD 1028 records the license gate. RFD 1031 records the geometry
    refinement path and its alpha wrap problem.
    """

    details_title "FOSS model replacements"

    details "PartField replacement (mesh segmentation)", ~S"""
    The web search from August 2026 found three MIT candidates.

    - PartSAM (czvvd/PartSAM, ICLR 2026) segments parts on native 3D data.
      It supports a segment-every-part mode.
    - HoloPart (VAST-AI/Research) completes occluded parts.
    - OmniPart (HKU-MMLab, SIGGRAPH Asia 2025) does part-aware 3D
      generation.

    PartSAM is the primary recommendation. It trains on native 3D data, so
    it works on AI-generated meshes. PartField needs clean mesh
    connectivity, which generated meshes lack.
    """

    details "FastMesh replacement (retopology)", ~S"""
    The catalog already carries Instant Meshes under the BSD-3 license. It
    is the primary replacement. QuadriFlow, meshoptimizer,
    trimesh_decimate, and AutoRemesher are the MIT alternatives.

    The QuadWild Bi-MDF fork does not qualify. It uses the GPL-3 license.
    """

    details "PartPacker replacement (image to raw mesh)", ~S"""
    The catalog already carries TRELLIS.2 and TRELLIS. Both use the MIT
    license. Prefer them over PartPacker.
    """

    drafted_by :ai
  end
end
