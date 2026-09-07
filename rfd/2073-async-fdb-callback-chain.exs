# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2073. `mix rfd.render` in rfd_dsl/ renders rfd/2073-async-fdb-callback-chain/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2073 do
  use RFD.DSL

  rfd 2073, "Async fdb callback chain" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    ``` create_transaction -> get(district) [async future] ->
    on_district_read [callback: extract next_o_id] -> get(customer) [async
    future] -> on_customer_read [callback: extract discount] ->
    get(stock[0]) [async future] -> on_stock_read [callback: update stock,
    next item] -> ... (loop for 5-15 items) -> set(oorder, new_order,
    order_line[], stock[]) -> commit [async future] -> on_commit
    [callback: send HTTP response] ```
    
    ## Related
    
    See `DETAILS.md` for the full argument.
    """

    details_title "Async fdb callback chain"

    details "Pattern", ~S"""
    ```
    create_transaction
      -> get(district)        [async future]
        -> on_district_read   [callback: extract next_o_id]
          -> get(customer)    [async future]
            -> on_customer_read [callback: extract discount]
              -> get(stock[0]) [async future]
                -> on_stock_read [callback: update stock, next item]
                  -> ... (loop for 5-15 items)
                  -> set(oorder, new_order, order_line[], stock[])
                  -> commit [async future]
                    -> on_commit [callback: send HTTP response]
    ```
    """

    details "Why async, not blocking", ~S"""
    FDB's C API is callback-based by design. `fdb_future_set_callback()`
    fires when the future resolves. Blocking with
    `fdb_future_block_until_ready()` would stall the event loop thread.
    
    In the actor-lite architecture (`rfd/2072-actor-lite-worker-pool`),
    the H2O network thread dispatches work to worker threads via SPSC
    rings. If a worker blocks on FDB, it can't process the next request
    from its ring.
    """

    details "Error handling and retry", ~S"""
    On any FDB error (conflict, timeout, etc.), call
    `fdb_transaction_on_error(tr, err)`. This returns a future. When it
    resolves, the transaction has been reset. The callback re-reads the
    first key and restarts the chain.
    
    The retry is transparent: the same `new_order_ctx_t` struct flows
    through the chain, carrying the transaction parameters. On reset,
    the read state is cleared and the chain restarts from step 1.
    """

    details "Memory management", ~S"""
    Each transaction allocates a context struct (`new_order_ctx_t`,
    `payment_ctx_t`, etc.) on the heap. The context is freed in the final
    callback (commit success or unrecoverable error). The FDB transaction
    handle is destroyed in the same callback.
    
    No reference counting needed: the callback chain is linear, each step
    has exactly one outstanding future, and the context outlives all
    callbacks.
    """

    details "Limitations", ~S"""
    - No batching across transactions: each HTTP request creates its
      own FDB transaction. Batching multiple requests into one transaction
      would improve throughput but violate TPC-C spec (each terminal
      executes one transaction at a time).
    - Stack depth is bounded: the callback chain is finite (max 15 stock reads +
      writes + commit), so no stack overflow risk.
    """

    drafted_by :ai
  end
end
