# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2072. `mix rfd.render` renders rfd/2072-actor-lite-worker-pool/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2072 do
  use RFD.DSL

  rfd 2072, "Actor lite worker pool" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    Top 10 TechEmpower R23 data update test.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Actor lite worker pool"

    details "Target", ~S"""
    Top 10 TechEmpower R23 data update test.

    | Rank  | Framework             | RPS           | Lang  | ORM     |
    | ----- | --------------------- | ------------- | ----- | ------- |
    | 1     | may-minihttp          | 1,327,378     | Rust  | Raw     |
    | **2** | **h2o**               | **1,226,814** | **C** | **Raw** |
    | 3     | ntex [sailfish]       | 1,210,348     | Rust  | Raw     |
    | 4     | ntex [async-std,db]   | 1,197,351     | Rust  | Raw     |
    | 5     | xitca-web             | 1,146,712     | Rust  | Raw     |
    | 6     | xitca-web [orm]       | 1,115,124     | Rust  | Full    |
    | 7     | axum [postgresql]     | 1,114,265     | Rust  | Raw     |
    | 8     | lithium-postgres      | 1,073,846     | C++   | Full    |
    | 9     | lithium-postgres-beta | 1,068,560     | C++   | Full    |
    | 10    | hyper-db              | 1,066,644     | Rust  | Raw     |

    h2o is already rank #2 with 1,226,814 RPS. All top 10 use Postgres
    with raw SQL (no ORM). The h2o-bench-tpcc target is to match this
    performance with TPC-C transactions (heavier per request) on
    CockroachDB (Postgres wire protocol).
    """

    details "Architecture", ~S"""
    ```
    HTTP client (wrk)
        │
        ▼
    H2O network thread (event loop, HTTP/3)
        │  spsc_ring_push (lock-free, no mutex)
        ├──► Worker 0 (SPSC ring → libpq pipeline → h2o_multithread_send)
        ├──► Worker 1
        └──► Worker N
        │
        │  h2o_multithread_send (return path)
        ▼
    H2O network thread (send HTTP response)
        │
        ▼
    FoundationDB (libfdb_c, pure C, no JVM)
    ```
    """

    details "Three components", ~S"""
    ### 1. SPSC lock-free ring buffer (`spsc_ring.c`)

    Single-producer/single-consumer ring with atomic load/store.
    Power-of-two capacity (mask-based indexing). No CAS, no mutexes.

    - Producer (H2O thread): `atomic_store_release(head)`
    - Consumer (worker thread): `atomic_store_release(tail)`
    - Invariant: `tail <= head <= tail + capacity`

    Verified by CBMC (`test/cbmc/spsc_harness.c`) and Lean 4
    (`test/verification/TpccVerification/Spsc.lean`).

    ### 2. Worker threads (`worker_pool.c`)

    Each worker:

    - Owns one SPSC ring (1024 slots)
    - Owns one libpq connection (pipeline mode)
    - Runs a tight loop: pop -> execute -> return
    - Returns results via `h2o_multithread_send`

    Dispatch: round-robin across workers (atomic fetch_add).

    ### 3. Return path

    `h2o_multithread_send()` wakes the H2O event loop to send the
    HTTP response. No shared state on the return path.
    """

    details "Verification layers", ~S"""
    | Layer            | Tool                  | What it verifies                                             |
    | ---------------- | --------------------- | ------------------------------------------------------------ |
    | C invariants     | CBMC                  | SPSC ring FIFO, bounds, head-tail invariant                  |
    | Specification    | Lean 4                | SPSC linearizability, push/pop preserve bounds               |
    | TPC-C invariants | plausible-witness-dag | NewOrder atomicity, Delivery correctness, Stock non-negative |
    """

    details "Why this beats a generalized actor framework", ~S"""
    - No scheduler overhead, each worker is a bare pthread
    - No lock contention, SPSC rings have zero cross-thread writes on the fast path
    - FDB async callbacks chain transaction steps without blocking
    - FDB transactions are native ACID (no SQL BEGIN/COMMIT overhead)
    - libfdb_c is pure C, no JVM, no JNI, no SQL parser
    - h2o's event loop handles HTTP/3 natively (no separate QUIC stack)
    - Top 10 is exclusively Rust and C/C++, no managed runtime in the top 10
    """

    drafted_by :ai
  end
end
