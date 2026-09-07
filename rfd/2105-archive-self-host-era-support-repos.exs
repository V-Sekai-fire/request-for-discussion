# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2105. `mix rfd.render` renders rfd/2105-archive-self-host-era-support-repos/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2105 do
  use RFD.DSL

  rfd 2105, "Archive self host era support repos" do
    state :moved

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    | Repo | Size | Last push | Basis for the archive | |
    ------------------------- | ---- | ---------- |
    -----------------------------------------------------------------------
    | | `fabric-container-verify` | 0 KB | 2026-06-20 | `rfd/0056` quadlet
    queue. `rfd/0089` archives every quadlet it targets. | |
    `fabric-casync-central` | 0 KB | 2026-06-24 | Empty. No content was
    ever pushed. | | `fabric-scoop-central` | 8 KB | 2026-06-30 | Scoop
    bucket for the Windows demo of the archived `godot-loop-slice`. | |
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Archive self host era support repos"

    details "What each repo carried", ~S"""
    | Repo                      | Size | Last push  | Basis for the archive                                                   |
    | ------------------------- | ---- | ---------- | ----------------------------------------------------------------------- |
    | `fabric-container-verify` | 0 KB | 2026-06-20 | `rfd/0056` quadlet queue. `rfd/0089` archives every quadlet it targets. |
    | `fabric-casync-central`   | 0 KB | 2026-06-24 | Empty. No content was ever pushed.                                      |
    | `fabric-scoop-central`    | 8 KB | 2026-06-30 | Scoop bucket for the Windows demo of the archived `godot-loop-slice`.   |
    | `fabric-platform-central` |,    | 2026-06-25 | `rfd/0065` Burrito and casync packaging.                                |
    | `vulkan-video-godot`      | 0 KB | 2026-05-28 | Empty placeholder.                                                      |
    | `steamdeck`               | 1 KB | 2026-06-14 | Empty placeholder.                                                      |

    `fabric-container-verify` reports 0 KB for its packed size. Its
    GDScript content is present in history.
    """

    details "The `fabric-platform-central` risk", ~S"""
    `rfd/0090` describes a live Burrito release of `uro` on Fly.io.
    `rfd/0065` puts the Burrito and casync packaging in
    `fabric-platform-central`. An archive makes the repo read-only. If the
    current `zone-backend` deploy still reads from this repo, its pushes
    and its Actions stop.

    The archive is reversible with one API call. This record states the
    risk so a later failure has a written cause.
    """

    details "Counts after the sweep", ~S"""
    These counts predate the archive split of `rfd/0106`, which adds one
    repository.

    | Set         | Count |
    | ----------- | ----- |
    | Total repos | 72    |
    | Archived    | 24    |
    | Active      | 48    |
    """

    details "Open inconsistency, not resolved here", ~S"""
    `zone-server-h2o` is archived. `rfd/0094` names it the host of the
    minimum UGC game loop, and `rfd/0095` carries it in scope. Its last
    push is 2026-08-07. An archived repo accepts no push.

    This record does not resolve the state of `zone-server-h2o`. Either
    the archive is an error, or a decision that supersedes `rfd/0094` is
    missing from `rfd/`. One of the two needs a record.
    """

    details "Stale names found in the inventory", ~S"""
    Every repository name in `rfd/0062`'s inventory still resolves, because
    GitHub keeps a redirect after a rename. A redirect hides the rename
    from a reader. `rfd/0064` sets kebab-case repository names, and these
    renames follow it.

    | Name in the old inventory | Current name                 |
    | ------------------------- | ---------------------------- |
    | `godot`                   | `fabric-godot-core`          |
    | `merge`                   | `fabric-godot-assembly`      |
    | `observability`           | `fabric-game-observability`  |
    | `zone-server-image`       | `zone-server-quadlet`        |
    | `zone-baker-image`        | `zone-baker-quadlet`         |
    | `zone-backend-image`      | `zone-backend-quadlet`       |
    | `gha-runner-image`        | `gha-runner-quadlet`         |
    | `sccache-cache-image`     | `sccache-cache-quadlet`      |
    | `manuals`                 | `multiplayer-fabric-manuals` |

    Three repos moved to a third organization, `V-Sekai-archive`, and are
    archived there: `lean-predictive-bvh`, `viser`, and
    `usd-converter-for-vrchat`.
    """

    drafted_by :ai
  end
end
