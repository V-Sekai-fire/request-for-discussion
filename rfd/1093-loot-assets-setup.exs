# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1093. `mix rfd.render` in rfd_dsl/ renders rfd/1093-loot-assets-setup/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1093 do
  use RFD.DSL

  rfd 1093, "Loot assets, fetched, never committed" do
    state :published

    scope "`public/loot-assets/`, `scripts/loot-assets-paths.mjs`, `scripts/ensure-loot-assets.mjs`"

    attest_in :none

    decision ~S"""
    Never commit the binaries. `npm run get-assets` clones
    `m3-org/loot-assets`, and links or inlines it depending on
    environment: a sibling clone linked into `public/loot-assets` for
    local development, a shallow clone straight into `public/loot-assets`
    for Vercel and CI (`npm run build` runs `get-assets` first). `git
    push` carries only app code; `public/loot-assets/` stays gitignored.
    App code reads `/loot-assets/…` with no import-path change
    (`src/library/lootAssetsConfig.js`).

    See `DETAILS.md` for the local layout, the quick-start commands, and
    the CDN alternative for a bundle-free Vercel build.
    """

    problem ~S"""
    Loot asset binaries have no place in this project's own git
    history. `github.com/m3-org/loot-assets` already holds them as the
    source of truth; committing a second copy here would duplicate that
    data and drift from it.
    """

    related ~S"""
    RFD 1103 gives the CDN-manifest alternative
    (`VITE_ASSET_PATH=https://m3-org.github.io/loot-assets/`) this
    RFD's `vercel.json` sets by default.
    """

    details_title "Loot assets, fetched, never committed"

    details "What happens per environment", ~S"""
    | Environment             | What happens                                                                                                                            |
    | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
    | Local dev (Surface/DGX) | `npm run get-assets` clones to `../loot-assets`, links `public/loot-assets` to that clone.                                              |
    | Vercel / CI             | `npm run build` runs `get-assets` first: a shallow clone lands straight inside `public/loot-assets`, and Vite bundles it into `build/`. |
    | `git push`              | Only app code moves. `public/loot-assets/` is gitignored, a junction locally, a build-time clone in CI.                                 |

    A pointer file, `loot-assets.source`, sits at the repository root.
    """

    details "Quick start", ~S"""
    ```powershell
    cd C:\Users\alfao\Documents\GitHub\Weftspun3DStudio
    npm run get-assets
    npm run dev
    ```

    ```bash
    # DGX
    cd /home/sifr/Weftspun3DStudio
    npm run get-assets
    ```
    """

    details "Local layout", ~S"""
    | Path                                          | Role                                                              |
    | --------------------------------------------- | ----------------------------------------------------------------- |
    | `C:\Users\alfao\Documents\GitHub\loot-assets` | The git clone of `m3-org/loot-assets`.                            |
    | `Weftspun3DStudio\public\loot-assets`         | A junction or symlink to that external clone.                     |
    | App URLs                                      | `/loot-assets/manifest.json`, `/loot-assets/models/…`, and so on. |

    Override the clone location with `LOOT_ASSETS_EXTERNAL_DIR` in
    `.env`. A Windows-only re-link: `.\scripts\link-loot-assets.ps1`, or
    `npm run link-assets`.
    """

    details "Vercel deploy", ~S"""
    `vercel.json` calls `npm run build`, which runs `npm run get-assets
    && vite build`. On Vercel, the `VERCEL=1` environment variable makes
    the clone land inside `public/loot-assets` directly, no sibling
    folder, no submodule, no manual asset upload.

    RFD 1103 gives the CDN alternative this project can point manifests
    at instead of bundling:

    ```env
    VITE_ASSET_PATH=https://m3-org.github.io/loot-assets/
    ```

    `vercel.json` sets this by default for Vercel deploys, an
    icons-only build with the CDN read at runtime.
    """

    details "Scripts", ~S"""
    | Command               | Purpose                                                                |
    | --------------------- | ---------------------------------------------------------------------- |
    | `npm run get-assets`  | Clone `m3-org/loot-assets` if missing; link or inline per environment. |
    | `npm run link-assets` | Windows junction, `public/loot-assets` to `../loot-assets`.            |

    Implementation: `scripts/loot-assets-paths.mjs`,
    `scripts/ensure-loot-assets.mjs`.
    """

    drafted_by :ai
  end
end
