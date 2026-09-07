# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1022. `mix rfd.render` in rfd_dsl/ renders rfd/1022-hexagonal-client/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1022 do
  use RFD.DSL

  rfd 1022, "A hexagonal client for the headless studio API" do
    state :discussion

    scope "`src/core/`"

    attest_in :none

    decision ~S"""
    Grow a hexagonal core inside `src/core/`. It takes the same ports
    and adapters split the Elixir side uses: a `domain/` of pure rules,
    `ports/` of contracts, and `adapters/` one per data source.
    
    The client keeps every other file. This is a strangler fig, as RFD
    1019 records. Nothing moves until a port covers it.
    
    See `DETAILS.md` for the full shape, why a port is a contract test,
    the first port this RFD builds, the method, and the risks.
    """

    problem ~S"""
    RFD 1019 makes the studio core an API server. The browser client
    becomes one consumer of that API. The client is not built that way
    today.
    
    The client holds 333 source files. 39 of them call the network
    directly, through `axios` or `fetch`. Domain logic, network calls,
    React state, and three.js all sit in the same modules. A rule such
    as "which model serves this task type" lives beside the code that
    fetches a job. A test of that rule must load React and the network.
    A second consumer, such as the XR client, cannot reach the rule at
    all.
    
    The model catalog shows the problem. `src/library/aiModelsCatalog.js`
    holds a fixed list of 28 models. The Elixir core holds the same
    list, from RFD 1016. The two already drifted once:
    `qwen_q4_k_m_image_edit` reached the inventory and never reached the
    client.
    """

    details_title "A hexagonal client for the headless studio API"

    details "The shape", ~S"""
    ```
    src/core/
      domain/     pure rules. No I/O, no React, no three.js.
      ports/      contracts, and the test that defines each one.
      adapters/   one per source of data.
    ```
    
    The rule for each directory is short:
    
    - `domain/` may import from `domain/` only.
    - `ports/` declare shape and behavior. They hold no logic.
    - `adapters/` may import ports and domain. Nothing imports an
      adapter except the composition step.
    
    ### The port is a test, not an interface
    
    JavaScript has no interfaces. A comment that says "an adapter must
    return an array" does not hold an adapter to anything.
    
    So each port ships a contract test. The test takes an adapter and
    runs the whole port against it. Every adapter runs the same test.
    
        describeCatalogSourceContract('static', makeStaticCatalogSource)
        describeCatalogSourceContract('http', makeHttpCatalogSource)
    
    An adapter that passes is usable. An adapter that fails is not. This
    is what makes the port real, and it is the reason to build the
    contract test before either adapter.
    """

    details "The first port", ~S"""
    Start with the model catalog. It is the smallest part that can move,
    for four reasons:
    
    - The Elixir core already serves it, at `GET /api/v1/models`.
    - A parity test already guards the two lists.
    - It needs no three.js and no React.
    - 13 modules read it, so the port earns its keep at once.
    
    Gall's law: a working simple system first.
    
    `CatalogSource` answers three questions:
    
    | Function                        | Returns                                      |
    | ------------------------------- | -------------------------------------------- |
    | `listModels()`                  | Every model, as `{ value, label, feature }`. |
    | `listFeatures()`                | Every feature name.                          |
    | `listModelsForFeature(feature)` | The models that serve one feature.           |
    
    The names follow `WeftspunStudio.Ports.CatalogSource`, so a reader of
    one side can read the other.
    
    ### Two adapters
    
    `staticCatalogSource` reads the list in
    `src/library/aiModelsCatalog.js`. It works with no server, so the
    client keeps working offline and today's behavior does not change.
    
    `httpCatalogSource` reads `GET /api/v1/models` from the studio core.
    It carries the fresh list, and it is the direction RFD 1019 goes.
    
    The composition step picks one. `VITE_STUDIO_API` names the server.
    Without that variable the client takes the static adapter, so no
    existing setup breaks.
    """

    details "Method", ~S"""
    Red, green, refactor. The RFD is the first red: it states the
    contract before any code exists.
    
    1. **Red.** This document, then the contract test. The test fails,
       because no adapter exists.
    2. **Green.** Write the two adapters until the contract passes.
    3. **Refactor.** Move the pure selection rules out of
       `aiModelsCatalog.js` into `domain/`, behind the port.
    """

    details "What this does not do", ~S"""
    It does not touch the other 38 network call sites. It does not touch
    React, three.js, or the job lifecycle. Those need their own ports,
    and each needs its own contract test first.
    
    It does not fix the 33 test failures the client already carries. Those
    predate the rebrand: the same 33 fail at commit `f0fa556f`, before
    any rebrand commit. They are a separate task.
    """

    details "Risks", ~S"""
    Two adapters mean two behaviors. The contract test is the answer:
    a difference that the contract does not cover is a hole in the
    contract, not a license to differ.
    
    The HTTP adapter adds a network dependency to a list that is fixed
    today. The static adapter stays as the fallback for that reason.
    
    `src/core/` is a second home for logic that also lives in
    `src/library/`. Until the refactor step finishes, a reader may find
    both. The port marks which one is current.
    """

    details "Status", ~S"""
    Done:
    
    - `src/core/` holds `domain/`, `ports/`, and `adapters/`.
    - The `CatalogSource` contract test runs against both adapters.
    - `staticCatalogSource` and `httpCatalogSource` both pass it.
    - `src/core/composition.js` picks one from `VITE_STUDIO_API`.
    - The selection rules moved into `domain/catalog.js`.
      `aiModelsCatalog.js` now calls them, so one implementation serves
      every consumer.
    - 47 tests cover the port, the rules, and the composition step.
    - The client still builds, and the suite holds at the 33 failures it
      carried before this work.
    
    Open:
    
    - Ports for the job lifecycle, assets, and the scene.
    - The other 38 direct network call sites.
    - The 33 inherited test failures.
    """

    drafted_by :ai
  end
end
