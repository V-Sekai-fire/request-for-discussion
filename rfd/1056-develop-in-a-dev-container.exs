# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1056. `mix rfd.render` in rfd_dsl/ renders rfd/1056-develop-in-a-dev-container/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1056 do
  use RFD.DSL

  rfd 1056, "Develop in a dev container" do
    state :discussion

    scope "`.devcontainer/`"

    attest_in :none

    decision ~S"""
    Develop in a dev container. It runs Debian, thus EXLA builds and the
    Linux CockroachDB build runs.
    
    This box's own Quadlets run Linux, and RFD 1055 selects them first,
    so the container is the same system production uses. Torchx goes:
    EXLA is the only backend this project builds against, and a second
    one only existed to work around the host.
    
    VSCodium carries no Dev Containers support. The Microsoft extension
    is proprietary, and Open VSX does not carry it. Enter the container
    by CLI instead, through `podman exec` or the `devcontainer` CLI, and
    not through editor integration. The editor still edits the source
    through the bind mount this RFD already sets.
    
    See `DETAILS.md` for what the container carries, why it uses named
    volumes instead of bind mounts, and what it deliberately does not do.
    """

    problem ~S"""
    Two dependencies do not build on Windows, and both are required. XLA
    publishes no Windows archive, so EXLA can never resolve there. The
    V-Sekai CockroachDB release does ship a Windows zip, and the
    database tests need a running node either way.
    
    Work on Windows therefore either skips those parts or replaces them.
    This branch already did both, and neither workaround is the answer.
    See `DETAILS.md` for why.
    """

    related ~S"""
    RFD 1019 selects EXLA. RFD 1020 selects the CockroachDB build.
    RFD 1036 packages the model images. RFD 1055 selects the local
    worker first.
    """

    details_title "Develop in a dev container"

    details "The abandoned workarounds", ~S"""
    This branch first swapped EXLA for Torchx, and made the dependency
    conditional on the platform. Neither workaround is the answer. RFD
    1019 selects EXLA because it compiles `Nx.Defn` graphs, while Torchx
    runs them one operation at a time.
    """

    details "What the container carries", ~S"""
    | Part             | Why                                     |
    | ---------------- | --------------------------------------- |
    | Elixir 1.17.3    | On Erlang 27, on Debian bookworm.       |
    | cmake and g++    | EXLA compiles a NIF.                    |
    | python3          | The model image check runs it.          |
    | Docker in Docker | The model images build here.            |
    | CockroachDB      | `mix weftspun.crdb install` fetches it. |
    
    Debian, and not Alpine. The XLA archive links against shared libraries
    that a musl base does not carry.
    """

    details "Two volumes, and not bind mounts", ~S"""
    `_build` and `deps` each take a named volume. A bind mount from a
    Windows host makes both slow, because the BEAM writes many small files
    into them.
    
    The source stays a bind mount. An edit on the host must reach the
    container without a copy.
    """

    details "What this does not do", ~S"""
    It does not give the container a GPU. EXLA takes its host client here,
    and `XLA_TARGET=cuda12` needs the NVIDIA runtime on the host.
    
    RFD 1027 records that every model reaches a 24 GB card. That card is
    rented, and it is not this machine.
    """

    drafted_by :ai
  end
end
