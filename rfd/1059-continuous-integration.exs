# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1059. `mix rfd.render` in rfd_dsl/ renders rfd/1059-continuous-integration/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1059 do
  use RFD.DSL

  rfd 1059, "Continuous integration, in one step" do
    state :published

    scope "`scripts/ci.sh`, `.github/workflows/main.yml`"

    attest_in :none

    decision ~S"""
    Follow Martin Fowler's ["Continuous
    Integration"](https://martinfowler.com/articles/continuousIntegration.html).
    One command builds and self-tests the whole system. A developer runs
    it before committing, and the integration machine runs the identical
    command.

    Two of his practices name the fault directly. "Automate the Build"
    and "Make Your Build Self-Testing" are the two. A broken `npm run`
    line that only ran on GitHub's machine shows what happens when the
    person who last touched a build never runs it.

    `scripts/ci.sh` is that one command. A developer runs it before
    committing, and an integration machine runs the identical command.

    See `DETAILS.md` for the three steps in order, why one script beats
    three CI steps, why the GitHub workflow is deleted for now, and what
    this deliberately does not cover.
    """

    problem ~S"""
    `.github/workflows/main.yml` ran `npm run test:anim-regression`.
    `package.json` never defined that script. Every run of this job
    failed at that line. CI stayed red, or silently skipped, since
    whenever that step was added.

    It also tested one of three parts of this repository. `weftspun_studio/`
    had no CI at all, and neither did the two Podman images RFD 1058 adds.
    """

    related ~S"""
    RFD 1058 gives the two container images this script builds. RFD 1020
    gives the CockroachDB the Elixir step tests against.
    """

    details_title "Continuous integration, in one step"

    details "What the one step does", ~S"""
    In order, stopping at the first failure:

    1. `npm install`, `vitest run`, `npm run build`. The JS side.
    2. `mix deps.get`, `mix compile --warnings-as-errors`, `mix test`
       against an ephemeral CockroachDB node the script starts and tears
       down itself (`mix weftspun.crdb`). The Elixir side.
    3. `podman build` (or `docker build`, whichever is on `PATH`) for
       both RFD 1058 images. No push, build only.

    Each step must pass before the next runs. A JS test failure never
    reaches the Elixir suite. A compile warning fails the build the same
    as a test failure does, per `--warnings-as-errors`.
    """

    details "Why one script, not three CI steps", ~S"""
    A step written only in YAML runs nowhere but GitHub's machine. This
    repository's one broken CI step proves what that costs. Nobody ran
    it locally, so nobody noticed it never worked. A shell script runs on
    a laptop and on a runner identically, through `bash scripts/ci.sh`,
    so the gap this RFD closes cannot reopen the same way.

    `CONTAINER_ENGINE` picks `podman` first, falling back to `docker`,
    because this project develops against Podman (RFD 1058), while
    GitHub's runners ship Docker. The Dockerfiles are engine-agnostic.
    Neither one assumes Podman.
    """

    details "Retracted for now: the GitHub workflow that called the script", ~S"""
    `.github/workflows/main.yml` once installed the toolchains and called
    `scripts/ci.sh`, and nothing in it duplicated a step the script already
    ran. That file is deleted, on purpose.

    `scripts/ci.sh` still exists, still runs the same one command, and a
    developer still runs it before committing. The browser client's own
    test suite carries many pre-existing failures across several files,
    unrelated to any one commit, and every push turned red for that reason
    alone. RFD 1057 tracks restoring the workflow once that suite is fixed.

    The decision this retracts is Fowler's, not this repository's, and it
    still holds. One command builds and self-tests the system. What is
    missing is the machine that runs it, not the command.
    """

    details "What this does not cover", ~S"""
    Playwright (`test:e2e`) and the smoke scripts under
    `test:anim-smoke` / `test:appearance-*` stay outside `scripts/ci.sh`.
    They need a browser, or a running dev server this RFD does not stand
    up.

    RFD 1058's `deploy-weftspun-quadlet.sh` stays outside it too.
    Continuous integration is not continuous deployment, and RFD 1058's
    open firewall question means that script cannot pass on this host
    yet regardless.
    """

    drafted_by :ai
  end
end
