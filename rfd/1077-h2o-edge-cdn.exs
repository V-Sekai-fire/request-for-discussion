# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1077. `mix rfd.render` in rfd_dsl/ renders rfd/1077-h2o-edge-cdn/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1077 do
  use RFD.DSL

  rfd 1077, "An H2O edge, not yet a CDN" do
    state :prediscussion

    scope "the deploy target, `apps/weftspun_studio/`, `apps/usd_viewer_app/`"

    attest_in :none

    decision ~S"""
    Not yet, and not that repo. See `DETAILS.md`'s RED step: `h2o-bench-tpcc`
    is a TPC-C benchmark harness with no reverse-proxy or caching code,
    and real H2O itself, checked against its own directive reference,
    has no response-caching module at all, unlike nginx's `proxy_cache`
    or Varnish. A multi-region H2O deployment gives closer HTTP/3
    termination, not a cached origin fetch; the slow hop this problem
    names would still cross regions on every request.

    The GREEN step ships instead: `Cache-Control` headers, at the
    existing origin, no new service. RFD 1058 and RFD 1067 both already
    found no load that needs more than this. If load ever does, the
    REFACTOR step names Tigris, Fly's own S3-compatible object storage
    with automatic edge replication, not H2O — see `DETAILS.md` for the
    full RED/GREEN/REFACTOR account.
    """

    problem ~S"""
    The gallery's proxy chain (RFD 1076) sets no `Cache-Control`
    anywhere. Every asset, including the multi-megabyte `emHdBindings.wasm`
    and `.data` files, refetches on every request, through two Fly
    machines, both in `sjc`. The user asked for "a fast CDN," and named
    `h2o-bench-tpcc`'s own `libh2o` dependency as the mechanism.
    """

    related ~S"""
    RFD 1076 gives the proxy chain this fixes. RFD 1058 and RFD 1067
    give the "no demonstrated load" finding this reapplies. RFD 1073
    adopts this RFD's REFACTOR step, Tigris, for a different reason:
    not load, but that `versitygw` (RFD 1058's loopback-only bind)
    became unreachable from `apps/usd_viewer_app/` once RFD 1076 split
    it onto its own machine. A real reachability blocker, not a
    capacity one, moved that decision to "now," not "if load ever does."
    """

    details_title "An H2O edge, not yet a CDN"

    details_preamble ~S"""
    This RFD verifies the plan before writing any code for it, the same
    discipline a test suite gives a function: state the claim, check it
    against something real, and only then decide what to build.
    """

    details "RED: the naive plan fails on inspection, no code needed to show it", ~S"""
    The claim on the table: "stand up `h2o-bench-tpcc` (or H2O) in
    multiple Fly regions as a CDN, fixes the no-caching gap in RFD
    1076's proxy chain."

    Two checks, both against real sources, both fail the claim before
    any container gets built:

    1. **`h2o-bench-tpcc` is not a reverse proxy.** Its own README states
       what it is: a TPC-C benchmark harness, `libh2o`'s event loop with
       `libfdb_c` calls compiled directly into the worker pool, built to
       measure FoundationDB write throughput. It has no static-file
       serving, no reverse-proxy config, no caching logic. It cannot
       front `weftspun_studio` or `usd_viewer_app` as written.
    2. **H2O itself has no response cache.** Checked against H2O's own
       configuration reference (`configure/proxy_directives.html`): the
       proxy module's only buffer-related directive,
       `proxy.max-buffer-size`, is explicitly transitory, it decouples
       the upstream and downstream connections and then discards the
       data. No directive stores a response body for reuse. This is a
       real, structural difference from nginx's `proxy_cache` or
       Varnish, both of which do store and serve cached bytes.

    The consequence: even a real, multi-region H2O deployment gives
    closer HTTP/3/QUIC connection termination, and nothing else. Every
    request still crosses to the single origin (`weftspun_studio`, Fly
    region `sjc`) for the actual bytes, on every request, from every
    edge region. The slow hop RFD 1076's gap actually names, a repeated
    full fetch of multi-megabyte WASM binaries with no cache anywhere,
    is not fixed by this plan. A user in `syd` gets a faster TLS
    handshake and a slower-than-necessary origin fetch behind it, not a
    cached response.

    This is the RED step: the test the plan needed to pass, "does this
    avoid re-fetching from origin," fails, verified by reading the two
    projects' own documentation, not by building and then discovering it
    at runtime.
    """

    details "GREEN: the smallest change that actually passes", ~S"""
    `Cache-Control`, at the existing origin, no new service:

    - `usd_viewer_app/server.js` sets `Cache-Control: public,
    max-age=31536000, immutable` on every path under `dist/assets/`
      (Vite's own content-hashed filenames, such as
      `index-797Eygc6.js`, the hash changes only when the content
      does, so an immutable, year-long cache is correct, not stale) and
      a short `Cache-Control: public, max-age=300` on `index.html` and
      every other path, so a caption or dataset-card update still
      reaches a browser in minutes, not a year.
    - `weftspun_studio`'s `HttpGallery.fetch` and `Router.proxy_gallery`
      forward whatever `Cache-Control` the gallery app sent, instead of
      the current behavior of setting only `content-type` and the
      COEP/COOP pair.

    This needs no new deployed app, no new language in the fleet, no
    multi-region cost, and it is real: a browser that already fetched
    `emHdBindings.wasm` once does not fetch it again, for free, using
    infrastructure every browser already has. RFD 1058 and RFD 1067 both
    already found no load that needs more than this, a browser cache
    plus a content-hashed filename is the whole fix at today's traffic.

    Not yet built: this RFD stops at the plan, per the user's own
    instruction to write the RFD and stop, not ship the GREEN step's
    code in the same pass.
    """

    details "REFACTOR: Tigris, not H2O, if load ever justifies more than GREEN", ~S"""
    If traffic ever outgrows a browser cache (many first-time visitors,
    not repeat ones, is the case a browser cache cannot help), the right
    next step is not H2O. It is **Tigris**, Fly's own S3-compatible
    object storage.

    Checked against Fly's own docs: Tigris replicates an object close to
    the region where it was written, then close to the region that
    requests it, automatically, with no separate proxy and no config.
    Fly's own claim: "This automatic global replication can replace a
    CDN." That is precisely the capability H2O's RED step found missing
    — H2O has no directive that stores a response body for reuse; Tigris
    stores the bytes themselves, at the edge, as its whole job.

    The concrete move: push the gallery's static assets (the WASM
    binaries, the `usd-viewer` vendor JS, the dataset images and
    `.usdz` files) to Tigris directly, and reference them by their
    Tigris URL. `versitygw`, RFD 1073's self-hosted S3-API gateway on a
    single-region Fly Volume, is a manual stand-in for exactly what
    Tigris already does natively; Tigris replaces it, not adds to it.
    `weftspun_studio` and `usd_viewer_app` still need one live app
    origin for the dynamic parts (the API, the current `index.html`
    shell), but the static bytes stop being this app's problem.

    This is still a real decision, not a code change to make in this
    pass: it retires `versitygw` and the Fly Volume it depends on, and
    needs its own RFD once a load number justifies it, the same
    reasoning RFD 1067 already applied to FoundationDB.
    """

    drafted_by :ai
  end
end
