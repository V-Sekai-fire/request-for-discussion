# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2060. `mix rfd.render` renders rfd/2060-org-scoped-github-app-token-for-gh-access/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2060 do
  use RFD.DSL

  rfd 2060, "Org scoped github app token for gh access" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    Repository operations against
    [`v-sekai-multiplayer-fabric`](https://github.com/v-sekai-multiplayer-fabric)
    — archiving, renaming, pushing, editing settings — run through `gh`
    from a working environment. `gh` was authenticated with a personal
    OAuth token (`gho_`, scopes `gist, read:org, repo, workflow`). The
    `repo` scope is not org-scoped: it grants read/write/**admin/delete**
    on every repository the personal account can reach, across every org
    and every private repo. A mistyped owner in a destructive command, or
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Org scoped github app token for gh access"

    details "Context and problem statement", ~S"""
    Repository operations against
    [`v-sekai-multiplayer-fabric`](https://github.com/v-sekai-multiplayer-fabric) —
    archiving, renaming, pushing, editing settings, run through `gh` from
    a working environment. `gh` was authenticated with a personal OAuth
    token (`gho_`, scopes `gist, read:org, repo, workflow`). The `repo`
    scope is not org-scoped: it grants read/write/**admin/delete** on
    every repository the personal account can reach, across every org and
    every private repo. A mistyped owner in a destructive command, or a
    leak of that single token, could damage anything the account touches
    anywhere on GitHub, far beyond the one org being worked on. `gh`
    authenticates per host, not per org, so the limit cannot live in `gh`
    config; it has to live in the token.
    """

    details "Decision drivers", ~S"""
    - Confine write/admin reach to the one org, so blast radius stops at
      its boundary.
    - Short-lived credentials, so a leak expires on its own rather than
      living until revoked.
    - Decouple automation from the personal account, so its cross-org
      access never rides along.
    - Least privilege, only the permissions the repo work actually needs.
    - Still usable from the CLI and from CI.
    """

    details "Considered options", ~S"""
    - Keep the broad personal OAuth token (`repo` scope).
    - A fine-grained Personal Access Token with resource owner set to the
      org.
    - A GitHub App installed on the org, minting installation access
      tokens.
    """

    details "Decision outcome", ~S"""
    Chosen option: "a GitHub App installed on the org". The App is
    installed on `v-sekai-multiplayer-fabric`; a helper
    (`~/bin/gh-fabric-token.sh`) reads the App id and private key from
    1Password, signs an RS256 JWT, exchanges it for an installation access
    token, and exports it as `GH_TOKEN`. `gh` then uses that token with no
    `gh auth login`.

    An installation token is org-scoped by construction, expires ~1 hour
    after minting, and acts as the App rather than the personal account —
    covering all three of the top drivers in one mechanism, where a
    fine-grained PAT covers org-scoping but stays long-lived and a
    human-account secret. The cost is a token-minting step (JWT →
    installation token) and guarding the App private key, which 1Password
    holds.

    The everyday installation is granted `administration: write`,
    `contents: write`, `workflows: write`, `actions: read`, `metadata:
    read` on all repositories in the org, the set the repo work (push,
    edit workflows, archive/rename) needs.
    """

    details "Consequences", ~S"""
    - Good: cross-org private access is impossible, the token cannot read
      or write any private repo outside the org, and cannot act as the
      personal account.
    - Good: a leaked token is dead within ~1 hour, with no manual
      revocation step.
    - Good: the App is its own identity, so audit-log entries and access
      are decoupled from the personal account's lifecycle.
    - Bad: minting needs a JWT-exchange helper rather than a single static
      secret.
    - Bad: the App private key is itself high-value (it can mint tokens
      for every install of the App) and must be guarded as carefully as
      the token it replaces.
    - Bad: `administration: write` on all repos means the token can still
      archive / rename / delete / transfer any repo _within_ the org, the
      in-org fat-finger case is not mitigated by scoping alone.
    """

    details "Confirmation", ~S"""
    A minted token was probed against the live API. `GET
    /installation/repositories` reports 49 repos, `repository_selection:
    all`. Org repos are reachable; `GET /user` returns `403 Resource not
    accessible by integration` (the token is not the personal account);
    private repos in other orgs are unreachable. Public repos elsewhere
    stay readable, which is public-is-public and not a private exposure.
    The minted token's permissions read back as
    `administration/contents/workflows: write, actions/metadata: read`.
    """

    details "More information", ~S"""
    In-org blast radius, every repo, with `administration: write`, is
    narrowed further by installing on selected repositories instead of
    all, and by splitting off a separate, rarely-used admin App so the
    everyday token drops `administration: write`. The accidental
    destructive command _within_ the org is caught only by an
    out-of-band confirmation step, not by token scoping. This pairs with
    the move to podman quadlets on Fedora 44
    (`rfd/203d-quadlets-on-fedora-44-instead-of-harvester`), where `gh`
    drives the same org's repos that carry the quadlet sources.
    """

    drafted_by :ai
  end
end
