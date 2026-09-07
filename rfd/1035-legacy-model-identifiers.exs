# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1035. `mix rfd.render` in rfd_dsl/ renders rfd/1035-legacy-model-identifiers/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1035 do
  use RFD.DSL

  rfd 1035, "Legacy model identifiers" do
    state :published

    feature "model inventory"

    attest_in :none

    decision ~S"""
    Keep the identifiers, and list them last in every picker.
    `LEGACY_MODEL_IDS` in src/library/aiModelsCatalog.js drives that
    order. Do not delete them, because saved tasks reference them.

    See `DETAILS.md` for the seven identifiers and the two rules that
    still apply to two of them.
    """

    problem ~S"""
    Seven model identifiers remain in the code after the TRELLIS.2 move.
    A reader who sees them in a picker cannot tell them from the current
    models.
    """

    related ~S"""
    RFD 1016 lists the active models. RFD 1005 records the avatar
    pipeline. RFD 1028 records the license gate.
    """

    details_title "Legacy model identifiers"

    details "The identifiers", ~S"""
    | Model id                       | Task                         |
    | ------------------------------ | ---------------------------- |
    | trellis_text_to_textured_mesh  | Text to 3D                   |
    | trellis_image_to_textured_mesh | Image to 3D (legacy)         |
    | trellis_image_mesh_painting    | Image mesh painting (legacy) |
    | trellis_text_mesh_painting     | Text mesh painting           |
    | unirig_auto_rig                | Auto rig (template VRM)      |
    | appearance_component_auto_rig  | Auto rig (appearance)        |
    | creature_template_auto_rig     | Auto rig (creature)          |
    """

    details "Two rules stay", ~S"""
    TRELLIS v1 fails xformers on GB200-class GPUs. Avoid it on that
    hardware tier, except for the multiview path.

    UniRig is the only backend for the template VRM mode. SkinTokens
    rejects that mode.
    """

    drafted_by :ai
  end
end
