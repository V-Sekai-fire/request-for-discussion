# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1005. `mix rfd.render` in rfd_dsl/ renders rfd/1005-avatar-and-vrm-pipeline/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1005 do
  use RFD.DSL

  rfd 1005, "Avatar and VRM pipeline" do
    state :published

    feature "avatar pipeline"

    attest_in :none

    decision ~S"""
    Support two avatar creation paths.

    - Avatar from image chains mesh generation and a template rig.
    - Avatar from photo uses AvatarSDK, not the AIGC backend.

    The base body VRM stays soulbound. Clothing, hair, and accessories
    act as equippable layers. The client validates the rig against the
    API contract. The viewport loads the rigged GLB. The user can
    download a VRM after the pipeline.

    Export paths include GLB download, VRM build, avatar pipeline VRM,
    and GLB compression with gltf-transform.

    See `DETAILS.md` for file references.
    """

    problem ~S"""
    A user wants an animated avatar from a photo or a trait selection.
    The result must meet the rig contract and export as VRM.
    """

    related ~S"""
    RFD 1004 catalogs the avatar tasks. RFD 1008 defines trait remix.
    The wallet minting link (old RFD 1012) is abandoned. The project
    does not do NFTs.
    """

    details_title "Avatar and VRM pipeline"

    details_preamble ~S"""
    - Pipeline: `docs/AVATAR_PIPELINE.md`
    - Rig contract: `docs/API_AVATAR_RIG_CONTRACT.md`
    - Client: `src/library/avatarPipelineCatalog.js`
    - Client: `src/library/avatarPipelineExport.js`
    - Export: `src/components/GLBExport.jsx`
    - Export: `src/components/VRMExport.jsx`
    - Export: `src/library/glbCompress.js`
    - Export options: `src/library/glbExporter.js`. Real fields include
      `includeAnimations`, `includeTextures`, `optimize`, and
      `exportDate` (an ISO timestamp, set at export time). The deleted
      `m3/docs/model-format-specification.md` also claimed a
      `forWeftspun3DStudio` flag; no such field exists in the exporter,
      and its "Open3DStudio (Weftspun3DStudio)" framing described the
      same codebase under its old and new name as if bridging two
      systems. RFD 1102 gives the real Open3DStudio-to-Weftspun history.
    """

    drafted_by :ai
  end
end
