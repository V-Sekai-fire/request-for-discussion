# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1165. `mix rfd.render` in rfd_dsl/ renders rfd/1165-finetuning-exhausts-the-desk-card/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1165 do
  use RFD.DSL

  rfd 1165, "Fine-tuning exhausts the desk card, and batch size is the lever" do
    state :ideation

    feature "the second wall in the compile"

    scope "`3-interactor/rf-detr-cpp/scripts/compile_hef.py`"

    attest_in :none

    decision ~S"""
    **RETRACTED 2026-08-29: this said batch size was the lever, and it is
    not.** A probe at `batch_size=1, epochs=1` on 64 frames raised the same
    `AccelerasResourceError` after 44 minutes.
    
    **The requirement is measured: QAFT needs 32.5 GiB, on an A40.** The
    desk 3090 holds 24, so the shortfall is 8.5 GiB and no batch size
    closes it. Separately, `a16_w16` is refused by this part outright --
    twelve `precision_change` layers the target will not take -- so
    `a8_w8` is the precision ceiling. `DETAILS.md` carries both.
    """

    problem ~S"""
    Two walls stopped this compile, and they are different walls.
    
    The first was system memory. Statistics Collector took SIGKILL at
    Docker's 30.26 GiB; raising `.wslconfig` to 48 GB cleared it and the
    stage completed in 14:58. The run peaked at 39.87 GiB, 85 per cent of
    the new ceiling and well above the old, so the lift was load-bearing.
    
    The second is video memory, and no amount of system RAM answers it:
    
        AccelerasResourceError: GPU memory has been exhausted. Please
        try Quantization-Aware Fine-Tuning with lower batch size.
    
    QAFT ran about thirty minutes of epoch 1 of 4 on 1024 frames and
    exhausted 24 GiB. RFD 1140 says match the card to the wall you hit;
    clearing the RAM ceiling only bought the right to meet this one.
    """

    related ~S"""
    RFD 1140 rents the card. RFD 1163 divides the work. RFD 1164 says
    what the calibration set becomes. RFD 1167 places the rung.
    """

    details_title "Fine-tuning exhausts the desk card, and batch size is the lever"

    details_preamble ~S"""
    The README states the walls. This carries the numbers behind them and,
    where the apparatus is incomplete, says so rather than rounding the gap
    away.
    """

    details "The two walls, with their floors", ~S"""
    Rule 4 asks for the floor in the same table as the number, so both
    ceilings sit beside what was asked of them.
    
        wall            asked        available    verdict
        system memory   39.87 GiB    30.26 GiB    SIGKILL, then cleared at 48 GB
        video memory    32.5 GiB     24 GiB       refused, and no lever reaches it
    
    System memory was answered by raising `.wslconfig` to 48 GB. Video
    memory has no equivalent knob: 32.5 GiB against the desk 3090's 24 is
    a shortfall of 8.5 GiB, and the retraction above is what happens when
    that gap is mistaken for a batch-size problem.
    """

    details "Why batch size was never going to work", ~S"""
    The first version of this RFD read the compiler's own advice --
    `Please try Quantization-Aware Fine-Tuning with lower batch size` --
    as a lever, and the advice is not wrong in general. It is wrong here
    because the floor of the range is still above the card.
    
    `batch_size=1, epochs=1` on 64 frames is the bottom of the range, and
    it raised the same `AccelerasResourceError` after 44 minutes. A lever
    that has been pushed to its stop is not a lever, and 44 minutes is
    what it cost to find that out the slow way. The 32.5 GiB figure is the
    number that would have said it in advance.
    """

    details "The A40 measurement, and what it does not include", ~S"""
    32.5 GiB was measured on a rented A40, 46 GiB of VRAM, during the
    session that also produced `compile_hef.py`'s precision flag.
    
    **The apparatus is partial and that is stated rather than hidden.**
    The peak was reported, not the command that produced it or the
    sampling method, and the session that measured it has ended. What can
    be said is the comparison it supports: an A40 completes what a 3090
    refuses, and the margin is 13.5 GiB rather than a few hundred MB, so
    the conclusion does not turn on how precisely the peak was sampled.
    
    Anyone re-running this should record the invocation alongside the
    figure. CLAUDE.md asks an entry to clip enough apparatus to re-run the
    test, and this entry does not yet meet its own standard.
    """

    details "`a16_w16` is refused, so `a8_w8` is the ceiling", ~S"""
    Sixteen-bit activations and weights are not merely expensive here.
    The part refuses the configuration: it inserts twelve
    `precision_change` layers, and the target will not take them.
    
    This matters more than it first reads. `precision_script` in
    `compile_hef.py` will emit `quantization_param({*}, precision_mode=...)`
    for whatever it is given, so the flag accepts a mode the device
    cannot run. The refusal arrives from the compiler rather than from the
    flag, which is the right place for it but the late one.
    
    So the honest statement of the precision range is that `a8_w8` is the
    ceiling on this part, not a midpoint chosen for speed. Anything quoted
    at sixteen bits describes a device other than this one.
    """

    details "The baseline, so the acceleration has something to beat", ~S"""
        rf-detr, full precision, CPU      2386.1 ms an inference at 576
        parameters, whole model           40.724 M
        parameters, device half           25.31 M
    
    The device half is the part that would be compiled, and it is 62 per
    cent of the whole model's parameters. A number without a baseline is
    not a measurement, and every latency claimed for the accelerator is
    read against this row.
    
    The device measurement itself, 2.27 ms hardware latency, 2.18 ms
    fixed overhead, is RFD 1130's, taken on a zoo classifier rather than
    on anything of ours. Nothing of ours has executed on the device, so
    the two rows above cannot yet be divided into a speedup.
    """

    details "What rung this leaves", ~S"""
    Rung 4 is empty. A search of the WSL filesystem, the Docker volumes
    and the Windows tree found no `.hef` from any run, including the
    `a8_w8` compile that ran on 2026-08-29 and whose container is gone.
    Statistics Collector completed in that run at 5:14; what happened
    after it is not recorded anywhere, which is the same apparatus gap
    this document already admits to.
    """

    drafted_by :ai
  end
end
