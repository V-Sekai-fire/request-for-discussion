# RFD 2159: Two `.elf` implementations of the Lean 4 FBD spec
**State:** committed
**Feature:** ship two independent RISC-V ELF implementations of the
compiler RFD 2157 formalises in Lean 4. Outputs cross-check on the
same fixtures; both are graded against the spec.
**Scope:** two sibling repos + a differential harness

## Decision

Green-lit; C++ and Rust both to ship.

`DETAILS.md` carries the full text of this RFD.

## Problem

RFD 2157's Lean formalisation is the ground truth. RFD 2158 blocks
Lean-emitted ELF today (upstream RFC 12655 open). Trusting one
backend makes soundness a hope; two agreeing backends give the
property `compile_correct` alone cannot.

## References

1. RFD 2157 (Lean spec), RFD 2158 (self-host blockers)
2. godot-sandbox CI:
  `libriscv/godot-sandbox/.github/workflows/build_gdscript_elf.yml`
3. Rust riscv64 target: platform-support docs

This RFD was drafted by an AI and read by a human before it shipped.

This RFD was drafted by an AI and read by a human before it shipped.
