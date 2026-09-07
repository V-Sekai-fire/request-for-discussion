# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1034. `mix rfd.render` in rfd_dsl/ renders rfd/1034-krea-memory-cross-check/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1034 do
  use RFD.DSL

  rfd 1034, "Krea memory cross-check" do
    state :published

    feature "capacity planning"

    attest_in :none

    decision ~S"""
    Check the rule against the one model with a measured number. Krea 2
    Turbo is that model. `scripts-cheatsheet.md` records 57 GB on disk,
    and a 32 GB reserve per worker.

    See `DETAILS.md` for the parameter estimate by part, and how it
    compares against the measured reserve and disk size.
    """

    problem ~S"""
    RFD 1025 gives a rule for the memory. RFD 1026 applies that rule to
    models with no published parameter count. An unchecked rule on an
    estimated count gives two errors, and not one.
    """

    related ~S"""
    RFD 1025 gives the rule. RFD 1026 gives the counts this check cannot
    confirm.
    """

    details_title "Krea memory cross-check"

    details "The estimate", ~S"""
    | Part               | Parameters | bf16 weights |
    | ------------------ | ---------: | -----------: |
    | diffusion backbone |     12.0 B |      24.0 GB |
    | T5 text encoder    |      4.7 B |       9.4 GB |
    | CLIP text encoder  |     0.12 B |      0.24 GB |
    | VAE                |     0.08 B |      0.16 GB |
    | **total**          | **16.9 B** |  **33.8 GB** |
    """

    details "The result", ~S"""
    The 32 GB reserve agrees with 33.8 GB. The worker does not hold every
    part at the same time.

    The 57 GB on disk is larger than 33.8 GB. The folder carries fp32
    copies as well, thus the disk size is not the load size.

    This agreement raises the confidence in the method. It does not raise
    the confidence in the parameter counts of the other models. There is
    no DGX, per RFD 1027 and RFD 1036. Replace each estimated count with
    a measured count from `config/models.yaml`, when a reachable host
    carries that file.
    """

    drafted_by :ai
  end
end
