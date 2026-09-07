# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1133. `mix rfd.render` in rfd_dsl/ renders rfd/1133-models-excluded-from-conversion/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1133 do
  use RFD.DSL

  rfd 1133, "Models excluded from conversion" do
    state :discussion

    feature "model conversion order"

    attest_in :none

    decision ~S"""
    Separate the exclusion from the ranking, and name which kind each
    row is.
    
    Every excluded model carries the blocklist entry, the RFD, or the
    absence that excludes it. The kind decides what reopens the row. A
    blocklist row reopens when the agreements change. An abandoned RFD
    reopens when the roadmap returns to its scope. An unexplained mark
    reopens the moment somebody reads the checkout it names.
    
    `DETAILS.md` gives the three groups, the reason under each row, and
    a retraction: the last three were first published as unfound, and
    `default.xml` places all three.
    """

    problem ~S"""
    RFD 1132 ranks the models to convert for the accelerator, and it
    carried a second table beside the ranking: ten model ids marked
    blocklisted. One word covered three exclusions, and the word is
    wrong for seven of the ten.
    
    Three are blocklisted: CLAUDE.md excludes Qwen-Image-Edit, P3-SAM
    and Krea 2. Four are abandoned, and RFD 1064 turned the roadmap
    away from their scope. The last three are placed projects on
    3-interactor carrying no recorded reason at all.
    
    A reader who asks why a model is unranked gets one answer where
    there are three, and two of the three can reverse.
    """

    related ~S"""
    RFD 1132 ranks the convertible models and cites this one. RFD 1016
    inventories them. RFD 1041, RFD 1042 and RFD 1043 package the three
    blocklisted models.
    """

    details_title "Models excluded from conversion"

    details_preamble ~S"""
    Ten model ids were carried under one heading in RFD 1132, and the heading was
    `blocklisted`. Reading each row back against what excludes it splits the ten
    three ways, and only the first three rows are what the word says.
    """

    details "Blocklisted by the agreements", ~S"""
    CLAUDE.md's blocklist names all three, and `BLOCKLIST.md` carries the argument
    under each. This table restates neither, it points at them.
    
    | model id                  | goal         | entry                        | RFD      |
    | ------------------------- | ------------ | ---------------------------- | -------- |
    | qwen_q4_k_m_image_edit    |,            | Qwen-Image-Edit (2509/2511)  | RFD 1043 |
    | p3sam_mesh_segmentation   | mesh-latents | P3-SAM / Hunyuan3D-Part      | RFD 1041 |
    | krea2_turbo_text_to_image |,            | Krea 2 / krea2-turbo         | RFD 1042 |
    
    Qwen-Image-Edit is 20.4B and runs here only quantised, and quantised it
    corrupts. P3-SAM carries a territory-restricted licence that excludes the EU,
    the UK and South Korea. Krea 2 is revenue-gated and the restriction propagates.
    
    The identifier `qwen_q4_k_m_image_edit` names the Q4_K_M build directly, so the
    catalog identifier and the reason for exclusion are the same fact. That is the
    one row where the id alone is the evidence.
    
    Ranking these would send somebody to work the agreements have already closed. A
    blocklist row reopens when the agreements change, and nothing in the conversion
    work can reopen it.
    """

    details "Abandoned with the world-building scope", ~S"""
    These four are not blocklisted anywhere. Each has an RFD in state `abandoned`,
    and each names the same cause: RFD 1064 turned the roadmap toward character
    concepts.
    
    | model id                     | RFD      | scope it left      |
    | ---------------------------- | -------- | ------------------ |
    | weftspun_image_to_world      | RFD 1049 | explorable worlds  |
    | lingbot_map_environment_scan | RFD 1050 | environment scan   |
    | worldmirror2_reconstruct     | RFD 1051 | multi-photo splat  |
    | triposplat_image_to_splat    | RFD 1052 | single-photo splat |
    
    RFD 1049 is the caller and RFD 1051 and RFD 1052 are two of its halves, so the
    four are one pivot rather than four decisions.
    
    Calling them blocklisted was wrong in a direction that costs something. A
    blocklisted model stays out whatever the roadmap does. An abandoned one returns
    with its scope, and RFD 1049 says so in its own words: package this entry again
    only if the world-building scope returns. A reader who saw `blocklisted` would
    not go looking for that sentence.
    
    None of the four is licence-dirty, and none was measured and rejected. They are
    out of scope, which is the cheapest exclusion to reverse.
    """

    details "Named in RFD 1132 and nowhere else, RETRACTED", ~S"""
    **The three are placed, and this section said they were not.** It is kept rather
    than rewritten, because the way it was wrong is the more useful half.
    
    | model id                 | path                                | revision                              |
    | ------------------------ | ----------------------------------- | ------------------------------------- |
    | multimodal_semantic_ids  | 3-interactor/multimodal-semantic-ids | refs/tags/mesh-latents/v0.1.0-dev.1  |
    | residual_fsq_recommender | 3-interactor/residual-fsq-recommender | refs/tags/mesh-latents/v0.1.0-dev.1 |
    | unified_modal_embedder   | 3-interactor/unified-modal-embedder | refs/tags/mesh-latents/v0.1.0-dev.1   |
    
    `default.xml` carries all three as `<project>` entries, pinned to the
    mesh-latents tag, and all three are checked out at 3-interactor. Placement is
    what a live goal manifest says, and it says these are placed.
    
    What the first version searched was the RFD corpus: no directory, no README, no
    ALIASES.md row, no citation. That search was accurate and its bound was stated.
    The bound was then read as a result anyway, which is the failure. An absence
    measured over one tree was written up under a heading that claimed the workspace,
    and the file that would have settled it in one grep is the same `default.xml`
    this document already cites for the `goal` column of RFD 1132's table.
    
    So the correct finding is smaller and worse. These three are not unfound, and
    they are not excluded either. They are placed projects on 3-interactor that RFD
    1132 listed as blocklisted, and nothing in this repository records a reason. The
    RFD corpus still has no entry for any of them, which is now a documentation gap
    rather than evidence of absence.
    
    Two ways to close it. Read the three checkouts and record what they are, or
    delete the rows from RFD 1132 and say the blocklisted mark was never supported.
    The first is the one that leaves a reader better off.
    """

    details "What this leaves for RFD 1132", ~S"""
    RFD 1132 keeps every convertible model, the measured rank, and the census that
    orders the rest. It cites this document instead of carrying a second table, so
    one ranking and one exclusion list do not have to agree by hand.
    """

    drafted_by :ai
  end
end
