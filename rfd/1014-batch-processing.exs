# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1014. `mix rfd.render` renders rfd/1014-batch-processing/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1014 do
  use RFD.DSL

  rfd 1014, "Batch processing" do
    state :published

    feature "batch processing"

    attest_in :none

    decision ~S"""
    Add batch processing with manifest files.

    - The user loads a manifest.json that lists the input files.
    - The app runs each item through the editing pipeline.
    - BatchDownload saves the output VRMs.

    The pipeline also renders VRM thumbnails, spritesheets, and LoRA
    training data from the same manifests.
    """

    problem ~S"""
    One avatar at a time is slow. A user with many VRM files wants to
    process them in one run. The app must accept a manifest and produce
    many results.
    """

    references ~S"""
    - UI: `src/pages/BatchManifest.jsx`
    - UI: `src/pages/BatchDownload.jsx`
    - Parser: `src/library/manifestDataManager.js`
    - Docs: `docs/docs/Modders/manifest-files/`
    """

    related ~S"""
    RFD 1005 defines the avatar pipeline that batch processing runs.
    """

    drafted_by :ai
  end
end
