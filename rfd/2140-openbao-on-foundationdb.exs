# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2140. `mix rfd.render` renders rfd/2140-openbao-on-foundationdb/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2140 do
  use RFD.DSL

  rfd 2140, "OpenBao on FoundationDB" do
    state :discussion

    feature "FoundationDB as the storage backend for the secrets manager"

    scope "weftspun-bao on Fly.io; the OpenBao fork at weftspun/openbao"

    attest_in :none

    decision ~S"""
    Restore the FoundationDB backend from Vault v1.14.8 (last MPL-2.0
    release), connecting to the existing weftspun-fdb cluster over 6PN.
    The port rewrites three interfaces that diverged after the fork:
    `ListPage`, interactive transactions (`BeginTx`/`BeginReadOnlyTx`
    with Commit/Rollback), and pins the FDB 7.3.79 Go binding
    (`headerVersion = 730`). Build tag `foundationdb`, `CGO_ENABLED=1`.

    Deployment files in weftspun/service-openbao. The bao machine carries
    only the FDB client library and connects to the cluster via a TLS
    client certificate. Interface details and deploy measurements are
    in DETAILS.md.
    """

    problem ~S"""
    OpenBao dropped every storage plugin when it forked from Vault
    v1.14.x. The weftspun-fdb cluster already runs three machines with
    double redundancy, TLS, and backup, and raft on a single shared-cpu
    machine has no replication path.
    """

    section "Verification", ~S"""
    `bao status`: Storage foundationdb, unsealed. KV v2 at `secret/`,
    anchor creds written from weftspun-fdb over 6PN. Root in 1Password.
    """

    related ~S"""
    RFD 2109 (FDB as the store), RFD 2134 (cluster TLS).
    """

    details_title "OpenBao on FoundationDB"

    details "The three interface changes", ~S"""
    OpenBao's `physical.Backend` diverged from Vault's after v1.14.x.
    The port rewrites three sites.

    **ListPage.** Vault's `List(prefix)` returned all keys. OpenBao added
    `ListPage(ctx, prefix, after, limit)` to the interface. The FDB
    implementation uses a range query with `after` as a begin-selector
    offset and `limit` as the range option.

    **Interactive transactions.** Vault used a one-shot
    `Transaction([]*TxnEntry)`. OpenBao replaced it with `BeginTx` and
    `BeginReadOnlyTx`, each returning a `physical.Transaction` carrying
    Put/Get/Delete/List/ListPage/Commit/Rollback. The FDB port calls
    `db.CreateTransaction()` and wraps the result in a struct that tracks
    committed/readonly state and returns the canonical error sentinels
    (`ErrTransactionReadOnly`, `ErrTransactionAlreadyCommitted`,
    `ErrTransactionCommitFailure`). PostgreSQL's `transaction.go` was the
    reference for the shape.

    **Backend registry.** `internal/command/commands.go` gains one import
    and one map entry (`"foundationdb": physFDB.NewFDBBackend`), wired the
    same way file, inmem, raft, and postgresql are.
    """

    details "The binding version", ~S"""
    The FDB Go binding hardcodes a `headerVersion` that must match or
    exceed the C client's API version. The 2019 binding
    (`cd5c9d91fad2`, headerVersion around 520) crashed at startup with
    error 2203 against the FDB 7.3 C client. The 7.3.79 binding
    (`0074653ee011`, `headerVersion := 730`) resolved it. The Go pseudo-
    version is `v0.0.0-20260715201227-0074653ee011`.
    """

    details "The deploy", ~S"""
    Fly app `weftspun-bao`, region sjc, `shared-cpu-1x`, 512 MB.
    Dockerfile.fdb is a two-stage build: Go 1.27 on bookworm compiles
    with the `foundationdb` build tag and CGO, then a slim runtime image
    installs the FDB client library deb (not the server).

    The bao machine connects to the existing weftspun-fdb cluster (3
    machines, double redundancy, mutual TLS per RFD 2134) over Fly 6PN.
    It presents its own TLS client certificate (`fdb-bao.chibifire.com`)
    and verifies the cluster with the same rule the cluster uses.

    Listener binds `[::]:8200` (dual-stack) so the machine is reachable
    over 6PN from other apps in the org.

    Storage: `auto_stop_machines = "suspend"`, `min_machines_running = 1`.
    """

    details "What the co-located fdbserver was, and why it moved", ~S"""
    The first deploy ran a single-node fdbserver inside the bao machine
    on the same volume. That worked for initialization but carried no
    redundancy, no backup, and no TLS. Moving to the cluster gives all
    three for free. The co-located entrypoint and the single-node config
    are kept in the repository's git history.
    """

    details "What the anchor creds cover", ~S"""
    Two KV v2 paths carry the FDB cluster's identity material:

    `secret/fdb/tls-anchor`: the CA certificate (base64 PEM), the
    cluster ID, and the verify-peers rule.

    `secret/fdb/blobstore`: the Tigris S3 credentials used by the FDB
    backup agents (AWS key pair, endpoint, region, bucket name).

    Both were written from a weftspun-fdb machine over 6PN, where the
    Fly secrets are available as environment variables.
    """

    drafted_by :ai
  end
end
