# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# `mix rfd.plan` renders pen-66606.usda from this file; the layer is a
# build artifact (RFD 2232, extended to the apparatus plans).
defmodule Plan.Pen66606 do
  use RFD.Plan

  plan "Pen66606" do
    meta(metersPerUnit: 1, upAxis: "Z", defaultPrim: "Serials")
    sublayers(["./SERIALS.usda", "./SERIALS-vsekai-fabric.usda"])

    string("category", "1")
    string("categoryName", "documents")
    string("holder", "iFire")
    string("pen", "1.3.6.1.4.1.66606")
    string("rule", "rfd/1000-conventions/DETAILS.md")
    string("scope", "This layer resolves only in a repo workspace, because its sublayers are other repositories. check_pen_66606.py reads it there, at the manual stage. A single-repository checkout cannot, which is why .pre-commit-config.yaml excludes it from usd-valid by name.")
    string_list("sites", [
      "1 weftspun request-for-discussion 1.3.6.1.4.1.66606.1.1 decommissioned",
      "2 v-sekai-fabric request-for-discussion 1.3.6.1.4.1.66606.1.2",
      "3 v-sekai manuals 1.3.6.1.4.1.66606.1.3",
      "4 fire manuals 1.3.6.1.4.1.66606.1.4 decommissioned"
    ])
    string_list("sitesDecommissioned", [
      "4 decommissioned 2026-08-29. It allocated no serial, naming a decision by its date instead, so nothing freezes and nothing moves. Its 21 dated decisions stay in the archived repository.",
      "2 decommissioned 2026-08-29, THEN REACTIVATED 2026-08-31 when site 1 was frozen and 2NNN became the source of new serials. Its 129 documents and its register moved into site 1's repository on 2026-08-29, which is why this layer sublayers a local file for it. The 2026-08-29 sentence -- 'The arcs are kept and are never reused; no serial is allocated under 66606.1.2 again' -- is retracted here rather than deleted: retractions stay in place next to what they retract. The site is authored from `request-for-discussion` from 2026-08-31 forward, which is why the `sites` row now names that repository.",
      "1 decommissioned 2026-08-31. Its 165 allocated serials and 6 retired serials stay in place and stay citable; nothing is renumbered. New RFDs in this repository get 2NNN serials from site 2, whose register moved here on 2026-08-29 and was reactivated for that purpose. RFD 1000's DETAILS.md still carries the numbering rule, with a retraction paragraph next to the passage that named site 1 as the active register. When site 2 fills up, site 5 opens at arc 66606.1.5 under RFD 1000's rule; sites 3 and 4 stay reserved for date-named registers."
    ])
    string_list("sitesWithoutRegister", [
      "3 names a decision by its date and allocates no serial",
      "4 names a decision by its date and allocates no serial"
    ])

    over("Serials", [
      attr("thesis", "string", "The composed view of every serial the PEN has issued under category 1. It stores none of them. Each site keeps its own register and this layer sublayers them, so a serial is authored once and read everywhere. A site that copied another's rows would be a second record of one fact, and the first copy edited would win by accident."),
      attr("howToAddASite", "string", "Add the site's SERIALS.usda to subLayers above, and add its row to the sites list. The site keeps authoring its own serials. Nothing is copied here, and check_pen_66606.py fails if two sites author the same one.")
    ])

  end
end
