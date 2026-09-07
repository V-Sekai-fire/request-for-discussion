# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2177. `mix rfd.render` renders rfd/2177-flight-levels-taxonomy/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2177 do
  use RFD.DSL

  rfd 2177, "Flight Levels taxonomy for RFDs" do
    front_matter ~S"""
    ---
    name: rfd-2177-flight-levels-taxonomy
    description: When tagging an RFD's altitude, use the flight_level field on its serial-register entry. Values are L1 (operations, single-team execution), L2 (coordination, cross-team value flow), L3 (strategy, portfolio bet). Follow Klaus Leopold's numbering (L1 = ground, L3 = altitude). Tagging is opt-in.
    tools: Read, Edit
    ---
    """

    state :committed

    feature "classify every RFD by which altitude of work it describes"

    scope "`SERIALS-*.usda` schema, `scripts/render_flight_level_pages.py`,\n`_quarto.yml` navbar, `pages/flight-level-*.qmd`"

    decision ~S"""
    Every RFD carries an optional `flight_level` tag, L1/L2/L3 (Flight Levels: execution / coordination / strategy), and three Quarto listings render from that tag; tagging is opt-in.
    """

    problem ~S"""
    An RFD describes a decision at some altitude of work (portfolio bet, cross-team coordination, or a single team's execution), but the register carries no field for that altitude. A reader wanting "all the strategy decisions" reads every RFD and infers.
    """

    section "Details", ~S"""
      L1  Operations    how a single team executes; fast cadence
      L2  Coordination  how work flows across teams to deliver value
      L3  Strategy      portfolio decisions about where to invest

    Numbering follows Klaus Leopold's original: L1 is ground, L3 is altitude, matching the flight-altitude metaphor. The register is greenfield for this axis, so no earlier convention needs inverting.

    `scripts/render_flight_level_pages.py` reads the tag from every serial register and writes three Quarto listings under `pages/flight-level-{1,2,3}-*.qmd`. Navbar carries a Flight Levels dropdown. Untagged RFDs stay off the three pages.

    See DETAILS.md for the tag schema, the render script's shape, and the Klaus Leopold citation.
    """

    related ~S"""
    RFD 1000 (RFD conventions), RFD 1053 (OpenUSD internal format), RFD 2174 (open-abandoned index) and RFD 2176 (committed-terminal index): same pattern of one document plus tag.
    """

    details_title "flight levels taxonomy"

    details "Tag schema", ~S"""
    Every RFD entry in `SERIALS.usda` or `SERIALS-vsekai-fabric.usda` may
    carry a `flight_level` field:

    ```usda
    def "S2177" {
        custom string slug = "flight-levels-taxonomy"
        custom string flight_level = "L3"    # optional: L1 | L2 | L3
    }
    ```

    Values are strings `"L1"`, `"L2"`, `"L3"`. Absent field means no
    level classification; the RFD stays off the three per-level pages.
    """

    details "Render script", ~S"""
    `scripts/render_flight_level_pages.py` reads the tag from every
    serial register and writes three files:

      pages/flight-level-1-operations.qmd
      pages/flight-level-2-coordination.qmd
      pages/flight-level-3-strategy.qmd

    Each is a Quarto listing whose `contents:` names the `rfd/NNNN-slug/
    index.md` paths of the RFDs tagged at that level. The listing sorts
    by RFD number descending, matches the format of `pages/rfd.qmd`, and
    regenerates on every render pass.
    """

    details "Klaus Leopold citation", ~S"""
    The Flight Levels model is Klaus Leopold's, first published as an
    organizational-improvement framework. Cite as:

    ```yaml
    cff-version: 1.2.0
    type: book
    title: >-
      Rethinking Agile: Why Agile Teams Have Nothing To Do With Business
      Agility
    authors:
     , family-names: Leopold
        given-names: Klaus
    year: 2018
    publisher:
      name: LEANability
    isbn: "978-3-903205-16-9"
    url: https://www.klausleopold.com/rethinking-agile
    ```
    """

    details "Trade-offs recorded", ~S"""
    - **Tag, not new arc.** A structural namespace (site 5 = Level 1,
      site 6 = Level 2, site 7 = Level 3) was on the table and dropped.
      A tag is a data axis; a site is a URN axis. Levels change more
      often than URNs are allowed to, so a tag fits the churn.
    - **Optional, not required.** Untagged RFDs stay in the register.
      Retrofitting 176 existing RFDs at once loses more than it gains.
    - **Leopold's numbering (L1 = ops, L3 = strategy).** Renumbering him
      to match RFD-serial-lower-is-more-foundational was proposed and
      rejected: the flight-altitude metaphor is the naming, and a
      greenfield tag has no reason to invert its source.
    """

    drafted_by :ai
  end
end
