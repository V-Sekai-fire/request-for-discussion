# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1057. `mix rfd.render` in rfd_dsl/ renders rfd/1057-open-work/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1057 do
  use RFD.DSL

  rfd 1057, "Open work" do
    state :published

    scope "the repository"

    attest_in :none

    decision ~S"""
    Keep one list of open work, in `DETAILS.md`. Each entry names the
    RFD that owns it, and what closing it needs. Delete an entry when it
    closes, so that file shrinks and never grows a history section.

    `DETAILS.md` holds five sections: verified and running, written and
    never run, measured and not built, unknown and blocking a number, and
    decided but waiting.
    """

    problem ~S"""
    This branch changed the host, the packaging, the backend, and the
    planner. Some of that work is complete, some is measured but not
    built, and some is written but never run.

    A reader who returns to this cannot tell those apart from the RFDs
    alone. Each RFD records its own decision, and none records what is
    still owed.
    """

    related ~S"""
    RFD 1055 selects the host. RFD 1056 selects the development system.
    RFD 1036 packages the models. RFD 1026 holds the memory numbers.

    RFD 1058 gives the Quadlet deployment. RFD 1059 gives the one-step
    build. RFD 1061 gives the `idtx_core` upload-prep decision. RFD 1062
    gives the Fly.io / 4090 split.
    """

    details_title "Open work"

    details_preamble ~S"""
    Delete an entry when it closes. This file shrinks, and it never
    grows a history section.
    """

    details "Verified, and running", ~S"""
    | What                                 | Evidence                                                                                                                                                 |
    | ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | The planner composes three documents | `pipeline_test.exs`, all 105 pass on this box now that `taskweft_nif` is rebuilt for x86_64                                                              |
    | The model image serves HTTP          | RFD 1040, run in Docker on this machine                                                                                                                  |
    | CockroachDB provisions and runs      | RFD 1020, 92 tests with the node up                                                                                                                      |
    | taskweft composition                 | PRs 207, 208, 209, merged upstream                                                                                                                       |
    | Both Quadlets run end to end         | RFD 1058, `weftspun.service` and `weftspun-crdb.service` both `active (running)`, `/api/v1/health` and `/api/v1/models` answered over `weftspun.network` |
    | `taskweft_nif` runs on x86_64        | `make clean && mix deps.compile taskweft_nif --force` from `deps/taskweft_nif/`. `mix test` then runs 105/105 with no arch-mismatch failure              |
    """

    details "Written, and never run", ~S"""
    **The dev container.** RFD 1056. The image does not build yet. The
    Debian attempt failed at `mix local.hex`, and the Fedora rewrite
    answers that by reading the error. Build it before trusting it.

    **The Pixal3D worker stage.** RFD 1040. Only the contract stage ran.
    The worker stage pulls 24.045 GB and needs an NVIDIA device, thus it
    needs a rented card.

    **The local worker.** RFD 1055 Phase 2. No worker service runs on
    this box yet, only a manual contract-stage test (RFD 1040). No
    instance is rented either, and RFD 1062's Gall's law says none
    should be, until this box is not enough.

    **The Fly.io / 4090 split.** RFD 1062. No `fly.toml`, no worker-side
    job-receiving adapter, no Tailscale join between a Fly machine and
    this box, no CockroachDB migration off this box. RFD 1062 names the
    target. None of it runs yet. The adapter's asset-transport half is
    settled, `idtx_transport`/aria-storage, per RFD 1062's own DETAILS.md.
    Open work narrows to the job-control envelope, and whether an
    aria-storage instance runs anywhere reachable yet.
    """

    details "Measured, and not built", ~S"""
    **Fourteen model folders.** RFD 1036. Each still carries a `cog.yaml`
    and a `predict.py`, and RFD 1036 no longer selects Cog. Convert one
    when its model is next worked on, and not in a sweep. The folder
    names are already converted, and the files inside are not.

    **`_to_usd` in the worker.** RFD 1053. The layer records the GLB as an
    asset attribute, because `usd-core` alone reads no glTF. A glTF file
    format plugin would let it be a reference arc.

    **The `idtx_core` NIF adapter.** RFD 1061. `flow/adapters/` in
    `thirdparty/fabric-flow-adapters/` holds three hosts, Godot, Unity,
    CLI, and no Elixir one. Needs a fourth adapter, a `weftspun_studio`
    route, and the browser call site swapped over. RFD 1061's stopgap
    (`prepareGlbForApiUpload` in `glbCompress.js`) stays until this
    lands.
    """

    details "Unknown, and blocking a number", ~S"""
    **The Q4_K_M quality cost.** RFD 1043. Quantization is a price choice
    now, and no measurement compares the two formats.

    **The browser client's own test suite.** RFD 1059. Failures span
    `skintokensLoadOrientation.test.js`,
    `taskAdvancedOptionsDecimation.test.js` (multiple, past the three
    already skipped), `viewportAnimationTarget.test.js`, and
    `src/library/taskModelUrl.test.js`, unrelated to each other and to
    any one commit. `.github/workflows/main.yml` is deleted until this
    is fixed, not patched test by test under a deadline.
    """

    details "Decided, and waiting on order", ~S"""
    **The Replicate passthrough.** RFD 1055 Phase 1 step 3 removes it.
    RFD 1055 also records why it stays until this box's own worker
    answers.

    **The abandoned world cluster's stale references.** RFD 1064 pivots
    the roadmap to character concepts. RFD 1049, RFD 1050, RFD 1051, and
    RFD 1052 record the abandonment, but RFD 1016, RFD 1017, RFD 1026,
    RFD 1027, RFD 1037, and RFD 1038 still cite all four as active work.
    `lib/weftspun_studio/inventory.ex` still marks all four `:active`.
    Update each reference, or mark the four `:vetoed`, when the catalog
    is next touched.
    """

    drafted_by :ai
  end
end
