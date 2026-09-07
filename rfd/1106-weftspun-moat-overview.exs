# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1106. `mix rfd.render` in rfd_dsl/ renders rfd/1106-weftspun-moat-overview/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1106 do
  use RFD.DSL

  rfd 1106, "The open/proprietary boundary, in public words" do
    state :published

    scope "licensing, trademark, the hosted service boundary"

    attest_in :none

    decision ~S"""
    Publish one page stating the split, with no pricing, revenue
    target, or investor detail in it. The client (`LICENSE`) is open,
    self-hostable under a different product name. Three areas stay
    proprietary, not granted by the OSS license: the trademark, the
    hosted `3DAIGC-API` with its model tuning and quality gates, and the
    marketplace/personalization services built on it.
    
    See `DETAILS.md` for the architecture split diagram and the
    per-area table.
    """

    problem ~S"""
    The client source is open. A fork could read that as an invitation
    to run as "Weftspun," or reuse the hosted AI and registry backends.
    Nothing public states where the open license ends and the
    proprietary service begins.
    """

    related ~S"""
    The public Vercel demo (`0098-public-deploy/`) runs the open client
    with none of the proprietary services exposed. Trademark terms live
    in this project's own `README.md` and `TRADEMARKS`. RFD 1109 gives
    the payment-rail and phygital-registry areas this page's own source
    document once listed; both are abandoned, per RFD 1012 and RFD
    1015, and removed from this table.
    """

    details_title "The open/proprietary boundary, in public words"

    details "What forking the repository does not grant", ~S"""
    | Area                    | Why it stays proprietary                                                                                                             |
    | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
    | Trademark               | "Weftspun", the Weftspun3DStudio branding, the logo, apparel designs. See this project's own `README.md`, Legal & Trademark section. |
    | Hosted AI               | The commercial `3DAIGC-API` queue, model-matrix tuning, and quality gates, running on operator hardware.                             |
    | Marketplace graph       | Curated mint paths, soulbound identity and equippable assets, official secondary listings.                                           |
    | Personalization service | Optional, user-approved profile context for generation. A compute product, not a sale of raw user data.                              |
    
    Two areas this page's own source document once listed here, payment
    rails (x402/wallet) and a phygital passport registry, are gone from
    this table. RFD 1109 gives why: both are abandoned, per RFD 1012 and
    RFD 1015, and both were fully stripped from the codebase before this
    page was even written. Listing them as a current proprietary moat
    was incorrect.
    """

    details "The architecture split", ~S"""
    ```
    [Open OSS client]  --API-->  [Hosted 3DAIGC + billing + SLA]  (operator moat)
           |
           +--> Trademark + official drops (brand moat)
           +--> Marketplace / personalization loop (network moat)
    ```
    
    Forking the repository grants the client source under its own
    license. It grants nothing else: not the right to operate as
    "Weftspun," and not access to the hosted AI or marketplace backends
    this page names.
    """

    details "What stays out of this document, on purpose", ~S"""
    Internal strategy (pricing, ARR, the full revenue map) lives in
    local-only files this session found and removed from public view
    once discovered, not in any RFD; this repository's own history
    carries that redaction as a real commit, not a silent one.
    """

    drafted_by :ai
  end
end
