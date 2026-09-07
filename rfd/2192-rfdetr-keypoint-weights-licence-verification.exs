# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2192. `mix rfd.render` in rfd_dsl/ renders rfd/2192-rfdetr-keypoint-weights-licence-verification/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2192 do
  use RFD.DSL

  rfd 2192, "rfdetr keypoint weights licence verification" do
    state :discussion

    feature "written licence terms for the separately-hosted keypoint weights"

    scope "`RFDETRKeypointPreview`, `rf-detr-cpp` README claim"

    decision ~S"""
    Contact the weights publisher for written licence terms on
    `rf-detr-keypoint-preview-xlarge.pth` and siblings, alongside the
    download URL. If clean, correct the `rf-detr-cpp` README so its
    licence claim matches the installed package. If unlicensed, add
    rfdetr-keypoint to BLOCKLIST.md under the See-Through checkpoints
    reasoning. Until terms are written, the weights are usable for
    local investigation, not for a shipping corpus or deployed model.
    """

    problem ~S"""
    `RFDETRKeypointPreview` downloads
    `rf-detr-keypoint-preview-xlarge.pth` (164 MB) from the vendor's
    object storage. The rfdetr 1.9.3 package on disk is Apache-2.0
    across every source (`LICENSE`, `METADATA`, per-variant `license`).
    The weights are hosted separately and carry no separate licence
    statement, the shape the See-Through row in BLOCKLIST.md already
    addresses. `rf-detr-cpp`'s README claims "PML 1.0 for XL/2XL";
    the installed package says Apache-2.0. One claim is wrong and
    neither is written alongside the weights. Issue 29 closed stale.
    """

    references ~S"""
    Original issue: `weftspun/request-for-discussion` issue 29;
    `rf-detr-cpp` README; rfdetr 1.9.3 `LICENSE` and `METADATA`.
    """

    related ~S"""
    BLOCKLIST.md See-Through checkpoints row (precedent shape),
    CLAUDE.md licence discipline, `rf-detr-cpp` project.
    """

    drafted_by :ai
  end
end
