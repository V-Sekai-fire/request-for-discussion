# RFD 2160: OpenUSD `.usda` as taskweft's intermediate
**State:** prediscussion
**Feature:** one bidirectional intermediate that carries the source
FBD, every derived artefact (`.gd`, Udon asm, `.elf`, `.uasset`),
and provenance to round-trip between them
**Scope:** taskweft, taskweft-fbd-compiler, all emitters, taskweft-godot-sandbox

## Decision

Adopt **OpenUSD `.usda`** as the plan's canonical form. CLAUDE.md
blesses it ("OpenUSD `.usda` if we want to remain text editable";
zip/gz blocklisted). USD gives hierarchical Prims, typed attributes,
references + layer composition (native bidirectional shape), and
asset refs for binary payloads.

`DETAILS.md` carries the full text of this RFD.

## Problem

Each emitter reads PLCopen FBD XML and writes its own format.
Nothing carries all of them side-by-side. RFD 2159's differential
(C++ vs Rust ELFs) needs a place to store both outputs alongside
the input FBD so a checker cross-verifies.

## References

1. CLAUDE.md archive-format rule + blocklist
2. RFDs 2150, 2148, 2149, 2150, 2152, 2154

This RFD was drafted by an AI and read by a human before it shipped.

This RFD was drafted by an AI and read by a human before it shipped.
