# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2013. `mix rfd.render` renders rfd/2013-archival-file-naming-convention/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2013 do
  use RFD.DSL

  rfd 2013, "Archival file naming convention" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The manuals repo now commits binary assets alongside prose, starting
    with screenshots under `decisions/attachments/`. Ad-hoc names like
    `image.png` collide, sort poorly, and lose their provenance once they
    leave the page that referenced them. What naming convention should
    committed assets follow so they stay unique, sortable, and
    self-describing?
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Archival file naming convention"

    details "Context and Problem Statement", ~S"""
    The manuals repo now commits binary assets alongside prose, starting with
    screenshots under `decisions/attachments/`. Ad-hoc names like `image.png`
    collide, sort poorly, and lose their provenance once they leave the page
    that referenced them. What naming convention should committed assets
    follow so they stay unique, sortable, and self-describing?
    """

    details "Decision Drivers", ~S"""
    - Names should be unique and not collide across decisions.
    - Names should sort chronologically and read as self-describing.
    - Names should survive being copied out of the repo (provenance in the
      name).
    - The convention should match established digital-preservation guidance.
    """

    details "Considered Options", ~S"""
    - Keep source names (`image.png`, `screenshot (1).png`).
    - Content hash names (`a1b2c3.png`).
    - A Library of Congress style descriptive convention.
    """

    details "Following the Library of Congress file-naming guidance", ~S"""
    - Lowercase ASCII only; no spaces or special characters.
    - ISO 8601 date first (`YYYYMMDD`) so names sort chronologically.
    - Facets separated by underscores (`_`); words within a facet by
      hyphens (`-`).
    - A zero-padded sequence (`NNNN`) to keep same-day captures unique and
      ordered.
    - Descriptive but reasonably short.
    """

    details "Consequences", ~S"""
    - Good: assets are unique, sort by date, and carry their provenance in
      the name.
    - Good: the convention matches preservation practice and is mechanical
      to apply.
    - Bad: names are longer than source names, and renaming on import is a
      manual step.
    """

    details "Confirmation", ~S"""
    Assets under `decisions/attachments/` match
    `YYYYMMDD_project_description_NNNN.ext` and have a matching entry under
    `references:` in `CITATION.cff`. The first example is
    `20260606_vsekai-mpf_xr-grid-debug-orbs_0001.png`, cited from the
    presence-demo decision.
    """

    details "More Information", ~S"""
    Based on the Library of Congress guidance on file naming for digital
    preservation (descriptive, no spaces, lowercase, ISO dates, zero-padded
    sequences).
    """

    drafted_by :ai
  end
end
