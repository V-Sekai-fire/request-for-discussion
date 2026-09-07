# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1075. `mix rfd.render` in rfd_dsl/ renders rfd/1075-github-oauth-admin-login/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1075 do
  use RFD.DSL

  rfd 1075, "GitHub OAuth login, gated on weftspun org membership" do
    state :prediscussion

    scope "`weftspun_studio`, the upload-admin routes"

    attest_in :none

    decision ~S"""
    An OAuth App, not a GitHub App. The user needs to log in as
    themselves and prove `weftspun` org membership. A GitHub App suits
    an unattended deploy action instead, a different, separate need,
    already distinguished from this one in the discussion that produced
    this RFD.
    
    Register the OAuth App by hand, GitHub gives no API for it, at
    `github.com/organizations/weftspun/settings/applications/new`, name
    `weftspun-studio`, homepage `https://weftspun-studio.fly.dev`,
    callback `https://weftspun-studio.fly.dev/auth/github/callback`.
    See `DETAILS.md` for the exact registration values, the login flow
    `weftspun_studio` needs to add, and the org-membership check that
    makes this a real gate, not only a login button.
    """

    problem ~S"""
    Uploads need an admin, a real person, organized under a real
    identity, not an open, anonymous route. The user asked for a way to
    verify someone's GitHub identity and their `weftspun` org
    membership, so only real org members can admin and organize
    uploads.
    """

    related ~S"""
    RFD 1062 gives the Fly.io toplevel this login flow runs on. RFD 1058
    names the zero-trust posture this session already applies
    elsewhere, the same reasoning that makes an org-membership check
    necessary here, not merely "logged in with GitHub."
    """

    details_title "GitHub OAuth login, gated on weftspun org membership"

    details "Why an OAuth App, not a GitHub App", ~S"""
    GitHub gives two different mechanisms for this kind of thing.
    
    An OAuth App logs a user in as themselves; the resulting token
    carries that user's own permissions. A GitHub App installs on
    specific repos with its own fine-grained permissions and short-lived
    installation tokens, independent of any one user's account, the
    right tool for an unattended deploy action, not for "prove this is
    really you."
    
    This RFD's problem is squarely the first case: a person needs to
    prove who they are and that they belong to `weftspun`, before
    admining or organizing uploads. An OAuth App is the correct,
    narrower tool for that, nothing more.
    """

    details "Registration, done by hand", ~S"""
    GitHub gives no API to script this part; it needs a browser, signed
    in as an owner of the `weftspun` org.
    
    1. Visit `https://github.com/organizations/weftspun/settings/applications/new`.
    2. **Application name:** `weftspun-studio`
    3. **Homepage URL:** `https://weftspun-studio.fly.dev`
    4. **Authorization callback URL:** `https://weftspun-studio.fly.dev/auth/github/callback`
    5. Click **Register application**. GitHub shows the **Client ID**
       directly. Click **Generate a new client secret** for the
       **Client Secret**, shown once.
    6. Both values become Fly secrets, `GITHUB_OAUTH_CLIENT_ID` and
       `GITHUB_OAUTH_CLIENT_SECRET`, never committed to the repo, the
       same pattern RFD 1073's `VGW_ACCESS_KEY`/`VGW_SECRET_KEY` already
       set with `flyctl secrets set`.
    """

    details "The login flow, not yet built", ~S"""
    Two routes, added to `lib/weftspun_studio/router.ex`:
    
    **`GET /auth/github/login`** redirects to GitHub's own authorize
    URL, `https://github.com/login/oauth/authorize`, with `client_id`,
    the callback `redirect_uri`, and `scope=read:org`. That scope reads
    org membership only; it does not grant repo access, matching RFD
    1058's zero-trust habit of asking for no more than the task needs.
    
    **`GET /auth/github/callback`** receives the `code` GitHub appends,
    exchanges it for an access token at
    `https://github.com/login/oauth/access_token`, then calls
    `GET /orgs/weftspun/members/{username}` with that token. GitHub
    answers `204` for a real member, `404` otherwise, per GitHub's own
    documented contract for that endpoint. Only a `204` starts a
    session; a `404` ends the flow with a plain, honest "not a weftspun
    member" response, not a silent failure.
    """

    details "The real DevOps steps, as run", ~S"""
    1. `flyctl secrets set GITHUB_OAUTH_CLIENT_ID=... GITHUB_OAUTH_CLIENT_SECRET=...
    --app weftspun-studio`, values from the hand-done registration
       above, run by the user directly rather than pasted into any
       chat transcript.
    2. A signed-cookie session needs its own signing key, separate from
       the OAuth secrets. Generated with `openssl rand -base64 48`, the
       same urandom-based pattern RFD 1073 already used for
       `VGW_ACCESS_KEY`/`VGW_SECRET_KEY`, and set as a fourth Fly
       secret, `SECRET_KEY_BASE`, with
       `flyctl secrets set SECRET_KEY_BASE=... --app weftspun-studio`.
    3. Each `flyctl secrets set` restarts the running machine on its
       own, independent of the GitHub Actions deploy pipeline, so the
       secret exists before the code that reads it ever deploys.
    """

    details "Session storage: a signed cookie", ~S"""
    Decided: `Plug.Session`, `store: :cookie`, signed with
    `SECRET_KEY_BASE` above. No new database table, no new ETS
    process, nothing to garbage-collect. `Plug.Router` sets no
    `secret_key_base` on its own, unlike a Phoenix endpoint, so a small
    plug sets `conn.secret_key_base` from the Fly secret before
    `Plug.Session` runs.
    """

    details "What still needs deciding", ~S"""
    Session lifetime, and whether the org-membership check runs once at
    login or again on some cadence, since a person removed from
    `weftspun` after logging in should not keep admin access
    indefinitely on an old session. Which upload-admin routes actually
    exist to gate: none do yet, this session's own scope stops at
    proving the login and membership check work, demonstrated on one
    small protected route, not at building the upload-admin feature
    itself.
    """

    drafted_by :ai
  end
end
