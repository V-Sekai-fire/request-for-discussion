# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1120. `mix rfd.render` in rfd_dsl/ renders rfd/1120-split-apps-into-own-repos/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1120 do
  use RFD.DSL

  rfd 1120, "Split apps/ into their own repos" do
    state :committed

    scope "`weftspun-3d-studio`'s `apps/`, `deploy/`, `scripts/`, and `thirdparty/`"

    attest_in :none

    decision ~S"""
    Each app moved to its own repository, with history preserved by
    `git subtree split --prefix=apps/<app>`, then pushed as that repo's
    `main`: `weftspun/weftspun-studio`,
    `weftspun/weftspun-character-taxonomy`, and
    `weftspun/weftspun-usd-viewer`. `apps/`, `scripts/ci.sh`, and
    `scripts/studio-test.sh` were removed from `weftspun-3d-studio`,
    since none apply to a repo with no app code left. `deploy/`,
    `.github/workflows/deploy-fly.yml`, and
    `scripts/deploy-weftspun-quadlet.sh` moved into `weftspun-studio`,
    the one app that requires the other two reachable.
    `thirdparty/3d_studio/` and `thirdparty/android-xr-face-bridge/`
    moved to `weftspun-3d-studio`'s own repo root, leaving that repo the
    browser client and the companion APK only.
    
    See `DETAILS.md` for the exact path changes, the new
    `/opt/weftspun/<repo>/` deploy convention, and open follow-up work.
    """

    problem ~S"""
    `weftspun-3d-studio` held three independently deployed apps
    (`weftspun_studio`, `character_taxonomy`, `usd_viewer_app`) under one
    `apps/` directory (RFD 1076), plus a large vendored browser client
    and a companion APK under `thirdparty/`. A monorepo checkout, one
    `scripts/ci.sh` building all three, and one shared self-hosted
    deploy script no longer matched three apps with three separate Fly
    deploy targets and no code sharing between them.
    """

    related ~S"""
    RFD 1058 gives the Quadlet deploy this split's `deploy/` move
    adapts. RFD 1060 and RFD 1076 give the repo-layout history this RFD
    continues.
    """

    details_title "Split apps/ into their own repos"

    details "Repo map", ~S"""
    | Old path (in `weftspun-3d-studio`)   | New repo                                                        |
    | ------------------------------------ | --------------------------------------------------------------- |
    | `apps/weftspun_studio/`              | `weftspun/weftspun-studio`                                      |
    | `apps/character_taxonomy/`           | `weftspun/weftspun-character-taxonomy`                          |
    | `apps/usd_viewer_app/`               | `weftspun/weftspun-usd-viewer`                                  |
    | `thirdparty/3d_studio/`              | `weftspun-3d-studio`'s own repo root, `3d_studio/`              |
    | `thirdparty/android-xr-face-bridge/` | `weftspun-3d-studio`'s own repo root, `android-xr-face-bridge/` |
    
    `git subtree split --prefix=apps/<app>` only carries history for
    commits where that content already lived under `apps/<app>/`. Each
    new repo's history starts at RFD 1076's move into `apps/`, not the
    project's full history; the fuller history stays in
    `weftspun-3d-studio`'s own git log.
    """

    details "The `/opt/weftspun/<repo>/` convention", ~S"""
    The self-hosted Quadlet deploy (RFD 1058) used to `rsync` one
    monorepo checkout to `/opt/weftspun/src`, and every `.build` unit's
    `File=` path pointed inside it. With three repos, `weftspun-studio`'s
    own `scripts/deploy-weftspun-quadlet.sh` now:
    
    1. Syncs itself to `/opt/weftspun/weftspun-studio` (an `rsync` of the
       working copy, as before).
    2. Clones or `git pull --ff-only`s `weftspun/weftspun-usd-viewer`
       directly from GitHub to `/opt/weftspun/weftspun-usd-viewer`.
    3. Installs `weftspun.network` (from `weftspun-studio`'s own
       `deploy/quadlet/`) plus every `.build`/`.container`/`.volume` unit
       found under either app's own `deploy/quadlet/`.
    
    Each `.build` unit's `File=` path now reads
    `/opt/weftspun/<repo-name>/...`, one directory per repo instead of
    one path inside a monorepo. `character_taxonomy` needs no quadlet
    entry here; it deploys to Fly alone, with no self-hosted or
    cross-app dependency.
    """

    details "Removed, not moved", ~S"""
    - `scripts/ci.sh`: built the JS suite, the Elixir suite, and both
      container images from one checkout. No longer applies with three
      separate repos.
    - `scripts/studio-test.sh`, and its `.pre-commit-config.yaml` hook:
      ran `weftspun_studio`'s own `mix test`. Removed from
      `weftspun-3d-studio` along with the last hook that file had; each
      split repo needs its own CI, not yet built.
    - `scripts/push_gallery_to_vgw.exs`: pushed proof assets to
      versitygw's S3 API. Already dead before this split, since RFD 1079
      removed versitygw.
    """

    details "Open work", ~S"""
    Each split repo needs its own CI (JS test and build for
    `weftspun-usd-viewer`, `mix test` for `weftspun-studio` and
    `weftspun-character-taxonomy`), not yet built. The self-hosted
    Quadlet deploy script is updated but not re-run against a live host
    since this split; a first run after this change should be treated
    as a fresh deploy, not an incremental one.
    """

    drafted_by :ai
  end
end
