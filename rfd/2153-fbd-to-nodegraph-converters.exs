# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2153. `mix rfd.render` in rfd_dsl/ renders rfd/2153-fbd-to-nodegraph-converters/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2153 do
  use RFD.DSL

  rfd 2153, "PLCopen FBD to VRChat Udon assembly" do
    compact_head true

    state :prediscussion

    feature "convert taskweft's PLCopen FBD (RFD 2150) directly into\nUdon assembly for VRChat"

    scope "taskweft (`Taskweft.OpenPLC.Udon`)"

    decision ~S"""
    Udon is the only target.
    
    `DETAILS.md` carries the full text of this RFD.
    """

    problem ~S"""
    RFD 2150 makes PLCopen FBD the one runtime target. The two platforms
    taskweft ships to are **godot-sandbox** (RFD 2154, C++ + Rust ELFs
    via RFD 2159) and **VRChat Udon**. Udon has its own native
    assembly language; FBD needs a direct compiler into it.
    """

    references ~S"""
    1. `sigs/vrchat_udon_asm.sigs`; the target instruction set
    2. RFD 2150 FBD target, RFD 2160 USD intermediate
    3. UdonSharp (source of truth for opcode set): vrchat-community/UdonSharp
    """

    details_title "PLCopen FBD to VRChat Udon assembly"

    details "Decision", ~S"""
    Udon is the only target.
    
    **Ship FBD -> Udon assembly, direct.** **C# as an intermediate is
    blocklisted**; UdonSharp adds Roslyn as a dep for one output format
    and duplicates verification outside RFD 2159's C++/Rust cross-check.
    Direct mirrors godot-sandbox's SafeGDScript pattern (source
    language -> target ISA, no C++ intermediate). VRChat's creator
    feedback loop demos in-world without a compile-and-flash cycle.
    
    **Dropped (were parked previously):**
    1. UE 4/5 Blueprint; out of scope for taskweft.
    2. Resonite ProtoFlux; out of scope.
    3. glTF Interactivity; out of scope.
    
    Udon assembly's opcode + directive surface lives at
    `taskweft-fbd-compiler/sigs/vrchat_udon_asm.sigs` (extracted from
    UdonSharp's own assembler, MIT). The FBD emitter walks each block
    and writes the corresponding uasm opcodes into the RFD 2160 USD
    plan's `/Deliveries/UdonAsm` string.
    
    `DETAILS.md` carries the block-to-uasm mapping and the round-trip
    against the `blocks_get_or` fixture.
    """

    details "Problem", ~S"""
    RFD 2150 makes PLCopen FBD the one runtime target. The two platforms
    taskweft ships to are **godot-sandbox** (RFD 2154, C++ + Rust ELFs
    via RFD 2159) and **VRChat Udon**. Udon has its own native
    assembly language; FBD needs a direct compiler into it.
    """

    details "References", ~S"""
    1. `sigs/vrchat_udon_asm.sigs`; the target instruction set
    2. RFD 2150 FBD target, RFD 2160 USD intermediate
    3. UdonSharp (source of truth for opcode set): vrchat-community/UdonSharp
    """

    drafted_by :ai
  end
end
