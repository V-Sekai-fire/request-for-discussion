# RFD 2205: Taskweft in Bao: database plugin, cgo-linked
**State:** discussion
**Feature:** the RECTGTN planner lives inside weftspun-bao as a
database-plugin-type Bao plugin (Go binary, cgo-linked C++ from
`taskweft_nif/standalone/`); the same C++ compiles via emcc to a
`taskweft.wasm` blob callable from the browser
**Scope:** the plugin binary itself; the weftspun-bao deploy that
loads it; the git-tracked fleet.jsonld → fleet.sqlite mirror pipeline;
the browser-side WASM parity target

## Decision

Ship one C++ planner (`taskweft_nif/standalone/*.hpp`, unchanged),
one thin `extern "C"` shim mirroring its 23-function NIF surface,
and two hosts that call the shim:

`DETAILS.md` carries the full text of this RFD.

## Problem

RFD 2204 named the fleet-coordination shape; the plan-mode session
of 2026-09-05 iterated three approaches before landing here. Two
earlier shapes are retracted, deliberately, retraction pointers
below.

## Related

- RFD 2204 (RECTGTN fleet coordination), the domain document
  shape the plugin queries. This RFD supersedes its "coordinator
  adapter" section with a one-line pointer, per CLAUDE.md doctrine.
- RFD 2140 (OpenBao on FoundationDB), the storage backend the
  plugin's SQLite fixture sits on top of.
- RFD 2142 (Bao PKI zerotrust), the cert-auth path peers use.
(continues in `DETAILS.md`)

This RFD was drafted by an AI and read by a human before it shipped.
