# RFD 2153: PLCopen FBD to VRChat Udon assembly
**State:** prediscussion
**Feature:** convert taskweft's PLCopen FBD (RFD 2150) directly into
Udon assembly for VRChat
**Scope:** taskweft (`Taskweft.OpenPLC.Udon`)

## Decision

Udon is the only target.

`DETAILS.md` carries the full text of this RFD.

## Problem

RFD 2150 makes PLCopen FBD the one runtime target. The two platforms
taskweft ships to are **godot-sandbox** (RFD 2154, C++ + Rust ELFs
via RFD 2159) and **VRChat Udon**. Udon has its own native
assembly language; FBD needs a direct compiler into it.

## References

1. `sigs/vrchat_udon_asm.sigs`; the target instruction set
2. RFD 2150 FBD target, RFD 2160 USD intermediate
3. UdonSharp (source of truth for opcode set): vrchat-community/UdonSharp

This RFD was drafted by an AI and read by a human before it shipped.

This RFD was drafted by an AI and read by a human before it shipped.
