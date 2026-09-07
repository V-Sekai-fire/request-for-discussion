# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1028. `mix rfd.render` renders rfd/1028-model-license-gate/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1028 do
  use RFD.DSL

  rfd 1028, "Model license gate" do
    state :published

    feature "model licensing"

    attest_in :none

    decision ~S"""
    Any model shipped to paying users must clear commercial use. The gate
    is the hard prerequisite in MODEL_LICENSES.md. The repository keeps a
    FOSS blocklist for permissive licenses only.

    See `DETAILS.md` for the deleted models and the blocklisted models,
    each with its license and its replacement.
    """

    problem ~S"""
    Some model weights permit non-commercial use only. Some carry
    territory rules and user-count rules. The catalog must not ship them
    to paying users.
    """

    related ~S"""
    RFD 1016 lists the active models. RFD 1029 gives the FOSS
    replacements. RFD 1035 lists the legacy models. The license audit is
    docs/MODEL_LICENSES.md in AlfaOmegaGrafx/3DAIGC-API.
    """

    details_title "Model license gate"

    details "Deleted models", ~S"""
    PartField, PartPacker, and FastMesh fail the gate. Their weight
    licenses permit non-commercial use only.

    - PartField uses the NVIDIA license section 3.3.
    - PartPacker uses the NVIDIA Source Code License section 3.3.
    - FastMesh uses the S-Lab non-commercial license.

    The pass tracks in issue #6. These models are not in the catalog. The
    repository does not reference them in the UI. Their residual
    references remain in docs/api/api.md. The delete pass removes them.
    """

    details "Blocklisted models", ~S"""
    - hunyuan3dv21_image_to_raw_mesh uses the Tencent Community license.
      The license has territory and MAU rules. The blocklist removes it.
    - ultrashape_image_to_raw_mesh inherits the Hunyuan pipelines. It
      inherits the Tencent rules. Review it with the same gate.
    - hunyuan3dv21_image_to_textured_mesh uses the same Tencent license.
      It needs the same review.
    - hunyuan3dv21_image_mesh_painting uses the same Tencent license. It
      needs the same review.
    - CGAL uses the GPL license with a commercial dual license. The
      project excludes GPL on license grounds. The blocklist removes it.

    The FOSS replacement for raw mesh generation is TRELLIS.2. It uses the
    MIT license. The catalog already carries it.
    """

    drafted_by :ai
  end
end
