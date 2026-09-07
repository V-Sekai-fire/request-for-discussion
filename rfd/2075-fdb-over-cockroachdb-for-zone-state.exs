# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2075. `mix rfd.render` in rfd_dsl/ renders rfd/2075-fdb-over-cockroachdb-for-zone-state/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2075 do
  use RFD.DSL

  rfd 2075, "Fdb over cockroachdb for zone state" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    **1. Write throughput.** TPC-C is 88% writes (NewOrder + Payment).
    FDB's log-structured MVCC separates transaction processing from
    storage, giving fundamentally lower write latency than CockroachDB's
    Raft consensus path. For a write-heavy benchmark, the database is the
    bottleneck.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Fdb over cockroachdb for zone state"

    details "Rationale", ~S"""
    **1. Write throughput.** TPC-C is 88% writes (NewOrder + Payment).
    FDB's log-structured MVCC separates transaction processing from storage,
    giving fundamentally lower write latency than CockroachDB's Raft
    consensus path. For a write-heavy benchmark, the database is the
    bottleneck.

    **2. Active Apple development.** FDB 7.3.79 (July 2026), actively
    maintained by Apple. CockroachDB's v-sekai fork is a dead engine with
    no upstream activity.

    **3. Pure C client.** `libfdb_c` is a native C shared library, no JVM,
    no JNI, no gRPC bridge. The C API is callback-based
    (`fdb_future_set_callback`), integrating naturally with h2o's event
    loop.

    **4. Native ACID transactions.** FDB transactions are built in:
    `fdb_database_create_transaction` / `fdb_transaction_set` /
    `fdb_transaction_commit`. No `BEGIN`/`COMMIT` SQL parsing, no pipeline
    mode complexity. The transaction object IS the transaction.

    **5. No SQL layer overhead.** Raw key-value operations eliminate SQL
    parsing, planning, and optimization. The framework's throughput is
    measured against the raw storage engine, not an SQL interpreter.
    """

    details "API surface (FDB C API 7.3)", ~S"""
    ```
    fdb_select_api_version_impl(730, 730)
    fdb_setup_network()           // start FDB network thread
    fdb_create_database(cluster)  // get database handle
    fdb_database_create_transaction(db, &tr)  // create transaction
    fdb_transaction_get(tr, key, len, snapshot, &future)  // read
    fdb_transaction_set(tr, key, klen, val, vlen)  // write
    fdb_transaction_commit(tr, &future)  // commit
    fdb_transaction_on_error(tr, err, &future)  // retry
    fdb_future_set_callback(future, cb, ctx)  // async callback
    fdb_future_get_value(future, &out, &len)  // extract result
    ```
    """

    details "What we lose", ~S"""
    - SQL comparability with other TFB entries (they all use Postgres)
    - TPC-C's SQL schema must be re-mapped to FDB key-value subspace design
    - StockLevel's COUNT requires a range scan instead of SQL aggregate
    """

    details "When to revisit", ~S"""
    If TFB-comparable numbers become the goal, add CockroachDB as a second
    adapter behind the same h2o handler interface. The FDB adapter stays
    primary.
    """

    drafted_by :ai
  end
end
