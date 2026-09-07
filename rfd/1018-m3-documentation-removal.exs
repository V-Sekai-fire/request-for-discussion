# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1018. `mix rfd.render` renders rfd/1018-m3-documentation-removal/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1018 do
  use RFD.DSL

  rfd 1018, "M3 documentation removal" do
    state :discussion

    scope "`m3/`"

    attest_in :none

    decision ~S"""
    Delete the M3 API reference. Do not rewrite it. A code map replaces
    it, naming each module and pointing at the source file.

    Delete the Docusaurus site machinery. This step removes the M3 site
    identity and the dependency cost. The markdown files stay, because
    the README links to them.

    Rewrite each remaining M3 guide in Weftspun words. Then delete the M3
    original. A rewrite must describe the current code, not the M3 code.

    Keep `m3/LICENSE` until the last M3 file goes. A deletion before
    that step would drop a notice the MIT terms require.

    Keep an `m3/static/` image only while a surviving markdown file names
    it under `/img/`. Delete the rest now. See `DETAILS.md` for the list.
    """

    problem ~S"""
    `m3/` holds a fork of the M3 Character Studio site. M3 holds the
    copyright for that content. The file `m3/LICENSE` records the M3
    copyright. The MIT terms require the repository to keep that notice
    while the M3 content stays. This tree moved here from
    weftspun-3d-studio's own `docs/`; the paths below read `m3/docs/`
    and `m3/static/`, the current location.

    The site costs more than it returns. No pipeline builds the site. The
    site keeps a separate package file and two lock files. The site
    caused seven dependency security commits. Its config and its API
    reference both drift from the current code, per `DETAILS.md`.
    """

    related ~S"""
    RFD 1017 records the rebrand.
    """

    details_title "M3 documentation removal"

    details "Background", ~S"""
    The site config still names the M3 origin. The rebrand changed only
    the title, so the config now claims the Weftspun name over the M3
    identity.

    The API reference under `Developers` copies the source. RFD 1000
    forbids a copy of the source. The reference has also drifted. The
    animation manager source holds 47 methods, and the document lists
    26 and misses the viewport and XR work.
    """

    details "Plan", ~S"""
    The work follows this order:

    1. Delete the template blog and the template page.
    2. Delete the `Developers` reference. Add the code map.
    3. Rewrite the `Modders` manifest guides. Delete the originals.
    4. Rewrite the `General` guides and the quickstart.
    5. Rewrite the history page as a short lineage note.
    6. Delete the site config, the sidebars, and the package files.
    7. Delete `docs/LICENSE`.

    Steps 1, 2, 4, and 5 are complete. Steps 3, 6, and 7 remain open.
    """

    details "Risk", ~S"""
    The image folder holds 29 MB. The history page uses many of those
    images. A rewrite of the history page must drop the unused images.

    The GitHub Pages workflow named an M3 host. The workflow now runs as
    a check only. It builds the app and runs the animation tests. It no
    longer publishes to any host. RFD 1013 keeps Vercel as the deploy
    path for the public demo.
    """

    details "Static assets", ~S"""
    `m3/static/img/` holds 40 files. Ten markdown files under `m3/docs/`
    name 37 of them, under `/img/`. Three go unnamed anywhere in the
    repository: `charstudio.jpg`, `overview-app.jpg`,
    `overview-schema.jpg`. Delete those three now. Delete each remaining
    image only when the guide rewrite that named it either drops the
    image or moves to a source the reader can reach on their own.
    """

    details "Misc top-level guides, beyond the original plan", ~S"""
    The original plan named the `Modders` and `General` guides, the
    quickstart, and the history page. `m3/docs/` also held nine other
    top-level guides the plan did not name. Four left the tree mid-session,
    outside this RFD's own work: `E2E_DGX_DEVTOOLS.md`,
    `IWSDK_OPTION_A_MIGRATION_BLUEPRINT.md`, `MCP_SETUP.md`,
    `quickstart.md`.

    Six more are deleted now, each superseded rather than rewritten, and
    none linked from any `README.md`:

    | File                                     | Why deletion, not a rewrite                                                                            |
    | ---------------------------------------- | ------------------------------------------------------------------------------------------------------ |
    | `WALLET_OWNED_ASSETS_AVATAR_APPROACH.md` | Wallet, minting, and Thirdweb; RFD 1012 abandons this line of work                                     |
    | `THIRDWEB_BENEFITS_AND_UI.md`            | Same abandoned line, RFD 1012                                                                          |
    | `QUICK_RECONNECT_STEPS.md`               | Manual ADB reconnect steps; `scripts/reconnect-galaxy-xr-debug.ps1` automates this now, per RFD 1099   |
    | `SIMPLE_ADB_CONNECT_GUIDE.md`            | Same script supersedes this Cursor-IDE clickthrough                                                    |
    | `WIRELESS_ADB_SETUP.md`                  | Same script supersedes this guide                                                                      |
    | `SceneControlsIntegration.md`            | Documents merging `SceneControlsBackup.jsx`, a file that no longer exists; the merge already completed |

    The remaining four are resolved too, none rewritten:

    | File                                  | Disposition                                                                                                                                                                                                            |
    | ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | `THREEJS_QUICK_START.md`              | Deleted. `getRendererInfo()`, `setupPostProcessing()`, and `createPositionalAudio()` do not exist in `sceneManager.js`; a build that never shipped, or shipped then shrank                                             |
    | `THREEJS_WEBGPU_WEBXR_MIGRATION.md`   | Deleted. Same drift; RFD 1009 dropped its own reference to this file and gained a `DETAILS.md` with the real renderer fallback chain instead                                                                           |
    | `FACE_EXPRESSION_TUNING_REFERENCE.md` | Deleted from this repo only. The live copy is the app's own `docs/FACE_EXPRESSION_TUNING_REFERENCE.md`, named directly in `xrExpressionTrackingDriver.js`'s header; a copy here would drift. RFD 1096 points to it now |
    | `model-format-specification.md`       | Deleted. Confused "Open3DStudio (Weftspun3DStudio)" bridge framing for what RFD 1102 shows is one codebase under its old and new name; the real, current export fields moved into RFD 1005's `DETAILS.md`              |
    """

    details "history.md's dropped Roadmap section", ~S"""
    The pre-rewrite `history.md` carried a "Roadmap" section mixed into
    the history page: real, current content (WebXR, Kimodo, moeChat and
    AIRI, with working RFD links), beside two abandoned wallet items
    ("Connect wallet to load profiles or mint files," an external
    Solana/Arweave launchpad) RFD 1012 already abandons, and a closing
    link to `MONETIZATION_ROADMAP.md`, a file `weftspun-moat-protected.mdc`
    names as never committed. That link pointed at a file this public
    repository does not, and should not, hold. The rewrite drops the
    whole Roadmap section; a history page states lineage, not a live
    roadmap, and RFD 1106 already gives the public-safe open/proprietary
    split this section partly restated.
    """

    details "References", ~S"""
    - M3 notice: `m3/LICENSE`
    - Site config: `m3/docs/docusaurus.config.js` (if still present)
    - Code map: `m3/docs/CODE_MAP.md` (to add)
    - DRY policy: RFD 1000
    - Attribution: `README.md`, section Third-Party Trademarks
    """

    drafted_by :ai
  end
end
