# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1013. `mix rfd.render` in rfd_dsl/ renders rfd/1013-public-demo-deploy/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1013 do
  use RFD.DSL

  rfd 1013, "Public demo deploy" do
    state :published

    feature "public demo"

    attest_in :none

    decision ~S"""
    Deploy a public viewport demo on Vercel. The build sets
    VITE_PUBLIC_DEMO=1 and loads loot assets through a CDN.
    
    The verify:public-env script blocks client secrets in CI and on
    Vercel. Full AI generation stays on local dev and the self-hosted
    backend. The demo does not require VITE_API_ENDPOINT.
    """

    problem ~S"""
    The app runs against a private DGX backend. A public deploy must
    not expose LAN or DGX secrets. A demo must still show the viewport,
    VRM upload, and traits.
    """

    references ~S"""
    - Config: `vercel.json`
    - Guard: `scripts/verify-public-build-env.mjs`
    - Docs: `docs/PUBLIC_DEPLOY.md`
    - UI toggle: `src/library/runtimeUi.js`
    """

    related ~S"""
    RFD 1001 defines the app shell that the demo deploys.
    """

    drafted_by :ai
  end
end
