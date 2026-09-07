# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2009. `mix rfd.render` in rfd_dsl/ renders rfd/2009-ghcr-package-ownership-same-repo/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2009 do
  use RFD.DSL

  rfd 2009, "Ghcr package ownership same repo" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The zone server binary was built by `multiplayer-fabric-baker` and
    pushed to `ghcr.io/v-sekai-fire/godot-zone-double`. The zone deploy
    workflow (in `multiplayer-fabric-zone`) used `--local-only` with
    `docker/login-action` to pull that image, but received 403 Forbidden.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Ghcr package ownership same repo"

    details "Context", ~S"""
    The zone server binary was built by `multiplayer-fabric-baker` and
    pushed to `ghcr.io/v-sekai-fire/godot-zone-double`. The zone deploy
    workflow (in `multiplayer-fabric-zone`) used `--local-only` with
    `docker/login-action` to pull that image, but received 403 Forbidden.

    GitHub Container Registry ties package write access to the repository
    whose `GITHUB_TOKEN` created it. The zone repo's token could not push to
    a package owned by the baker repo, and could not pull a private package
    owned by another repo without package-scoped access.
    """

    details "Consequences", ~S"""
    - Package names must reflect the owning repo to avoid confusion.
    - Moving a package between repos requires deleting it (needs
      `delete:packages` API scope) and rebuilding, or renaming.
    - Cross-repo GHCR access requires either a PAT with `read:packages`
      scope or making the package public.
    """

    drafted_by :ai
  end
end
