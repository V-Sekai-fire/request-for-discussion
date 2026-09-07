# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1055. `mix rfd.render` in rfd_dsl/ renders rfd/1055-beam-workers-local-first/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1055 do
  use RFD.DSL

  rfd 1055, "BEAM workers, local first" do
    state :discussion

    scope "`weftspun_studio/`, every model image"

    attest_in :none

    decision ~S"""
    Blocklist Replicate. Run the worker on this box's own 4090 first, in
    plain Docker images, on RFD 1058's existing Quadlets. vast.ai stays
    priced and ready, the next tier once this box stops being enough, per
    RFD 1062's Gall's law, not the immediate plan.
    
    The BEAM owns the queue, the retries, and the state, no Python
    involved, whichever host runs it.
    
    See `DETAILS.md` for the providers priced for later, the host tiers,
    the two phases, and what stays unresolved.
    """

    problem ~S"""
    Replicate runs each model as a serverless Cog. That model costs more
    than it should, and it fights the stack in three ways.
    
    **Cog is Python, and this is an Elixir shop.** Replicate runs a
    `predict.py`, thus no Elixir queue, no supervision tree, and no Nx
    work can live inside the worker.
    
    **The price is a markup, and the retention terms are Replicate's,
    not ours.** Replicate bills per second above the cost of the card,
    volume and long jobs make that worse, and a job's data lives as long
    as Replicate's own terms say, not RFD 1058's zero-trust design.
    
    **The boundary leaked into the repository.** It produced a duplicate
    application in `cms/`, and a passthrough whose model map was empty,
    thus every job answered 400.
    """

    related ~S"""
    RFD 1036 gives the image convention. RFD 1027 gives the GPU tier.
    RFD 1040 records the first worker. RFD 1019 records the core.
    """

    details_title "BEAM workers, local first"

    details "What was considered, and when it applies", ~S"""
    This project owns an RTX 4090, in this box. RFD 1062's Gall's law
    applies here first: rent a card only after the owned one is the
    bottleneck. The table below prices the rented tier, for the day this
    box stops being enough, not for today.
    
    | Provider  | Model      | RTX 4090 | Against it                       |
    | --------- | ---------- | -------: | -------------------------------- |
    | vast.ai   | P2P market |   ~$0.35 | Host quality varies              |
    | RunPod    | Datacenter |    $0.69 | Twice the price                  |
    | Google    | TPU spot   |    $0.60 | Needs XLA, breaks CUDA           |
    | Replicate | Serverless |     high | Hostile to the BEAM, blocklisted |
    
    The TPU row also disagrees with RFD 1019 now. That RFD first selected
    EXLA, which is XLA. Torchx replaced it, because XLA publishes no
    Windows archive, and Torchx binds LibTorch and CUDA.
    """

    details "Two host tiers, for the rented future, not the local present", ~S"""
    vast.ai sells community hosts and verified hosts, priced here for the
    day this box needs a second card, not for the local worker this RFD
    builds first.
    
    Take community hosts for development, near the price floor of about
    0.15 US dollars per hour. Take verified hosts for production, at the
    median of about 0.35, and accept the price for the PCIe lanes, the
    bandwidth, and the privacy terms.
    """

    details "Phase 1: unify the repository", ~S"""
    1. Commit the CockroachDB fixes and the let-it-crash pass. Done in
       `e1a4767b`. The Torchx swap in that commit is reverted, and
       RFD 1056 records why.
    2. Delete `cms/`, and fold the planning documents, the `Planner` port,
       and `TaskweftPlanner` into `weftspun_studio`. Done in `c2d659f7`.
       That settles the overlap RFD 1023 and RFD 1054 carried.
    3. Remove the Replicate passthrough and `ReplicateJobs`. Open, and see
       below.
    4. Abandon the Cog build. Done in `06c5c4ba`. RFD 1036 selects plain
       Docker, and RFD 1040 records a contract stage tested in Docker.
    """

    details "Replicate is blocklisted, and the passthrough is tolerated, not kept", ~S"""
    Replicate is blocklisted on two grounds: the per-second markup, and
    retention terms this project does not set and cannot audit. No new
    dependency on Replicate is acceptable, matching the RFD 1028 gate's
    own shape for a blocklisted model license.
    
    Step 3 removes the only path from the router to a model. Nothing
    replaces it yet, because Phase 2 has not run. `ReplicateJobs` keeps
    running in code today, an explicit, temporary exception, not an
    endorsement, until this box's own worker answers `/predict`. Then the
    adapter changes host and keeps its port, which is what RFD 1023
    makes possible.
    
    `Ports.JobSink` and `Ports.JobSource` do not change. A local adapter
    implements the same two behaviors, thus the router never learns which
    host runs the model. A rented adapter, later, does the same.
    """

    details "Phase 2: deploy the compute, on this box", ~S"""
    1. Write a `Dockerfile` for `weftspun_studio` with Elixir and CUDA.
    2. Run it on this box's own RTX 4090, through RFD 1058's Quadlets,
       already built and verified running. No instance to rent.
    3. Measure the inference speed, and cluster the router with the
       worker.
    """

    details "One image, or one per model", ~S"""
    This RFD proposes a unified image that holds the application and the
    weights. RFD 1036 keeps one model per image.
    
    The two disagree, and the weights decide it. RFD 1026 sums the catalog
    at 116.45 GB. One image that carried all of it would take an hour to
    pull, and a change to one model would rebuild every other.
    
    Keep one image per model. Put the BEAM inside each one, which is what
    this RFD asks for, and let the router cluster with them.
    """

    details "Unresolved", ~S"""
    Local storage is not billed per pause, so the rented-tier question,
    whether a host keeps the weights or a container pulls them from a
    bucket at start, only reopens the day this box is not enough.
    
    Pixal3D is 24.045 GB either way. Measure the local pull-at-start cost
    before it matters for the rented tier too.
    """

    drafted_by :ai
  end
end
