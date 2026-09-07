# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1103. `mix rfd.render` in rfd_dsl/ renders rfd/1103-vercel-loot-assets/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1103 do
  use RFD.DSL

  rfd 1103, "Loot assets from a CDN, not a full clone, on Vercel" do
    state :published

    scope "`vercel.json`, `src/library/lootAssetsConfig.js`"

    attest_in :none

    decision ~S"""
    Read assets from `m3-org.github.io/loot-assets/` (GitHub Pages)
    instead of bundling them. `vercel.json` already sets
    `VITE_ASSET_PATH` to that URL, alongside `VITE_PUBLIC_DEMO=1`; with
    it set, `npm run get-assets` downloads only the trait-UI icon set
    into `public/loot-assets/icons/`, not the full tree, and
    `src/library/lootAssetsConfig.js` rewrites every asset path to the
    CDN automatically. Removing `VITE_ASSET_PATH` reverts to the
    bundled, full-clone mode RFD 1093 gives.
    
    See `DETAILS.md` for the dashboard setup steps, the CDN URL layout,
    the post-deploy verification steps, and the secret-variable audit
    this mode still needs.
    """

    problem ~S"""
    RFD 1093's default asset fetch clones the full `m3-org/loot-assets`
    repository at build time. A public Vercel deploy does not need every
    asset bundled; it needs a small, fast build and a runtime source for
    the rest.
    """

    related ~S"""
    RFD 1093 gives the bundled-clone default this RFD's CDN mode
    replaces. RFD 1098 gives the public-build secret checklist this RFD
    also names.
    """

    details_title "Loot assets from a CDN, not a full clone, on Vercel"

    details "One-line setup, recommended", ~S"""
    This repository's own `vercel.json` already sets:
    
    ```env
    VITE_ASSET_PATH=https://m3-org.github.io/loot-assets/
    VITE_PUBLIC_DEMO=1
    ```
    
    RFD 1098 gives the full public-build security checklist this
    setting sits inside. Deploy from the Vercel dashboard or its CLI;
    no extra environment variable is required unless one is overridden.
    """

    details "Dashboard setup, by hand", ~S"""
    1. Open the project on `vercel.com`, then Settings, then Environment Variables.
    2. Add:
    
       | Name               | Value                                   | Environments                                    |
       | ------------------ | --------------------------------------- | ----------------------------------------------- |
       | `VITE_ASSET_PATH`  | `https://m3-org.github.io/loot-assets/` | Production, Preview, Development                |
       | `VITE_PUBLIC_DEMO` | `1`                                     | Production, Preview; hides the API Status panel |
    
       Never set `VITE_API_ENDPOINT` on the public Vercel demo; a
       self-hosted build is where a user configures their own API.
    
    3. Redeploy; an environment-variable change only applies to a new build.
    """

    details "What happens at build time", ~S"""
    ```
    npm run build
      -> verify-public-build-env
      -> npm run get-assets   (sees VITE_ASSET_PATH set, fetches icons only, no full clone)
      -> vite build
    ```
    
    At runtime, manifests, models, and animations load from
    `https://m3-org.github.io/loot-assets/…`. At build time, only the
    trait-UI SVGs download into `public/loot-assets/icons/` (Vite
    imports them directly, from `Load.jsx` and similar components).
    """

    details "URL layout, GitHub Pages", ~S"""
    GitHub Pages serves the legacy asset tree under `/loot/`:
    
    | App path        | CDN URL                       |
    | --------------- | ----------------------------- |
    | Main manifest   | `…/manifest.json`             |
    | Models manifest | `…/loot/models/manifest.json` |
    | Model GLB       | `…/loot/models/…`             |
    | Animations      | `…/loot/animations/…`         |
    
    `src/library/lootAssetsConfig.js` rewrites every path automatically
    once `VITE_ASSET_PATH` is set; no other code change is needed.
    """

    details "Verify after a deploy", ~S"""
    1. Open the deployed site, then DevTools, then the Network tab.
    2. Confirm `manifest.json` loads from `m3-org.github.io`, not the Vercel origin itself.
    3. Open Appearance; confirm the loot pack's trait groups load.
    4. Confirm the bottom animation bar loads its FBX files from the CDN.
    """

    details "Local development with the same CDN", ~S"""
    In `.env`:
    
    ```env
    VITE_ASSET_PATH=https://m3-org.github.io/loot-assets/
    ```
    
    Then:
    
    ```powershell
    npm run get-assets
    npm run dev
    ```
    
    No full `../loot-assets` clone is needed for CDN mode, only the
    small icon set the build itself downloads.
    """

    details "The bundled alternative", ~S"""
    Remove `VITE_ASSET_PATH` from both the Vercel environment and
    `vercel.json`. The build then shallow-clones the full
    `m3-org/loot-assets` repository into `public/loot-assets`, a larger
    deploy with no external CDN dependency, RFD 1093's own default mode.
    """

    details "Security, on a public Vercel deploy", ~S"""
    The disconnected-state UI names environment-variable keys
    (`VITE_API_ENDPOINT`, and so on) but never their values, so that
    alone is not a breach. Never set on Vercel:
    `VITE_3DAIGC_API_KEY`, `VITE_AVATARSDK_CLIENT_SECRET`,
    `VITE_THIRDWEB_SECRET_KEY`, or any Pinata or Alchemy secret; Vite
    embeds every `VITE_*` variable directly in the client bundle. A
    production build hides the API Status panel, the dev troubleshooting
    tools, the endpoint editor, and the sidebar debug panel when
    `VITE_PUBLIC_DEMO=1`. Audit periodically: Vercel, Settings,
    Environment Variables, remove any secret-shaped `VITE_*` key found,
    then redeploy.
    """

    drafted_by :ai
  end
end
