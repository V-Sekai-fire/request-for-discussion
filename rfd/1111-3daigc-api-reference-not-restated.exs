# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1111. `mix rfd.render` in rfd_dsl/ renders rfd/1111-3daigc-api-reference-not-restated/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1111 do
  use RFD.DSL

  rfd 1111, "The 3DAIGC-API reference, not restated here" do
    state :committed

    scope "`3DAIGC-API` (DGX, port 7842), `weftspun-3d-studio`'s own\n`thirdparty/m3/api/api.md`"

    attest_in :none

    decision ~S"""
    `3DAIGC-API`'s own repository, not this one, holds the current
    endpoint reference. `3DAIGC-API` itself ships interactive docs at
    `/docs` (Swagger UI) and `/redoc` on its own host and port, and those
    stay the source of truth for exact request and response shapes. RFD
    1102 already gives this project's own task-to-model catalog, at the
    level a client developer needs. See `DETAILS.md` for the endpoint
    group names this reference held, kept as a map, not a copy.
    """

    problem ~S"""
    `thirdparty/m3/api/api.md` held an 1,872-line endpoint reference for
    `3DAIGC-API`: health checks, file upload, mesh generation,
    segmentation, auto-rigging, splat generation, mesh editing,
    retopology, UV unwrapping, workflow examples, error codes, and the
    spatial-fabric publish path. RFD 1000's DRY policy forbids a copy of
    source documentation in this repository, since a copy drifts and the
    source stays correct. RFD 1085 already made this same call for the
    browser client's own API surface.
    """

    related ~S"""
    RFD 1085 gives the same DRY call for the browser client's own
    module map. RFD 1102 gives the task catalog a client developer needs
    day to day. RFD 1100 gives the spatial-fabric publish path this
    reference's own RP1/OMB section covered.
    """

    details_title "The 3DAIGC-API reference, not restated here"

    details_preamble ~S"""
    `GET /health` and other system checks; optional token-based user
    management, off by default (`user_auth_enabled`); a file upload
    system returning file IDs, with a 24-hour cleanup; mesh generation,
    by task type; mesh segmentation; auto-rigging; splat generation;
    mesh editing, by text or image; mesh retopology; UV unwrapping;
    worked workflow examples per task type; a named error-code table;
    the spatial-fabric publish path (RP1/OMB); model preference
    settings; and the file formats each endpoint group accepts.
    
    Every response follows one shape: a job envelope
    (`job_id`/`status`/`message`) on success, an error envelope
    (`error`/`message`/`detail`) on failure.
    
    A client developer who needs the exact request and response schema
    for one of these groups reads `3DAIGC-API`'s own `/docs` (Swagger UI)
    or `/redoc`, generated from the live server, not this page.
    """

    drafted_by :ai
  end
end
