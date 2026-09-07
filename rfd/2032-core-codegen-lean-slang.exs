# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2032. `mix rfd.render` in rfd_dsl/ renders rfd/2032-core-codegen-lean-slang/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2032 do
  use RFD.DSL

  rfd 2032, "Core codegen lean slang" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The cores carry compute kernels — hit raycasts, the budgeter solve,
    geometry costing — that need to be verified once and run as GPU
    compute, with the dispatch wrapped behind the flat C ABI port
    (`rfd/2044-lean4-kernel-cores-flat-c-host-adapters`). Hand-porting a
    kernel from a separate spec to a shader drifts.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Core codegen lean slang"

    details "Context and problem statement", ~S"""
    The cores carry compute kernels, hit raycasts, the budgeter solve,
    geometry costing, that need to be verified once and run as GPU
    compute, with the dispatch wrapped behind the flat C ABI port
    (`rfd/2044-lean4-kernel-cores-flat-c-host-adapters`). Hand-porting a
    kernel from a separate spec to a shader drifts.
    """

    details "Decision drivers", ~S"""
    - One verified Lean source per kernel, with no separate shader to
      drift.
    - The kernel runs on the GPU and integrates with GPU convergence; the
      CPU Slang target lacks that integration.
    - Integer ops keep the kernel deterministic across conformant devices.
    """

    details "Considered options", ~S"""
    - Hand-write each kernel as a shader from a separate spec.
    - Lower a CPU host target through Slang.
    - Author the kernel in Lean and lower it to SPIR-V.
    """

    details "Decision outcome", ~S"""
    Chosen option: author the compute kernels in Lean and lower them to
    Slang through [lean-slang](https://github.com/V-Sekai-fire/lean-slang),
    then run `slangc -target spirv` to SPIR-V (`.spv`), and dispatch the
    `.spv` behind the flat C ABI, because SPIR-V runs the kernel on the
    GPU with the convergence integration the CPU Slang target lacks, and
    one verified Lean source produces the shipped kernel. The `idtx-flow`
    repository already depends on `LeanSlang` and byte-pins the emitted
    Slang against committed source with `native_decide`.
    """

    details "Consequences", ~S"""
    - One Lean kernel source produces the `.spv`, so the spec and the
      shipped kernel stay one artifact.
    - The lowered Slang and the `.spv` are committed and byte-pinned, so a
      regen that drifts fails the pin.
    - The kernels use integer ops, so the SPIR-V stays deterministic
      across conformant devices
      (`rfd/2034-deterministic-cores-integer-seeded-rng`).
    """

    details "Confirmation", ~S"""
    The emitted Slang matches its committed byte-pin, and the dispatched
    `.spv` kernel passes the core fixtures.
    """

    drafted_by :ai
  end
end
