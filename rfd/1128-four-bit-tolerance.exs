# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1128. `mix rfd.render` renders rfd/1128-four-bit-tolerance/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1128 do
  use RFD.DSL

  rfd 1128, "Does the cascade survive four bits" do
    state :discussion

    feature "quantisation tolerance for edge deployment"

    scope "`3-interactor/pixal3d-image-to-textured-mesh`"

    attest_in :none

    decision ~S"""
    Measure tolerance first, because a failure here makes RFD 1129's
    operator work pointless.

    The 3090 is the instrument. Its 24 GB holds bf16 and four-bit forms of
    one stage at once, so the same input runs both ways and the difference
    is the quantity. The device cannot do this: 8 GB holds one form.

    Three rules make it mean something: the input is identical rather than
    similar, since `render_view.py` is bit-reproducible; the baseline is
    bf16 on this card rather than a paper; and the error is millimetres of
    surface deviation rather than an impression.

    Quantise with the Dataflow Compiler: bitsandbytes measures a four-bit,
    and the DFC's host emulator runs the device's.

    See `DETAILS.md` for the apparatus, and `SKILL.md` for the order.
    """

    problem ~S"""
    The ASUS UGen300 is a Hailo-10H with 8 GB, specified for 4-bit
    weights. Pixal3D's checkpoints are 24.045 GB in bf16, three times the
    device. At four bits they are about 6 GB, which fits.

    So the arithmetic permits it and nothing says the model survives it. A
    1.3B diffusion transformer at four bits may produce a mesh nobody can
    tell from the original, or a worse one, or a broken one. RFD 1043
    records the same open question for another model.
    """

    related ~S"""
    RFD 1129 asks whether the operators compile. RFD 1040 packages the
    model, and RFD 1122 is the goal this serves.
    """

    details_title "Does the cascade survive four bits"

    details "The instrument is the card we have, and it is enough for this", ~S"""
    An RTX 3090: 24 GB, sm_86, 2020. It is not a 4090, and there is no
    high-performance inference pipeline on this desk. The machine also
    carries a Radeon 780M, which is an integrated RDNA3 part sharing
    system memory with no dedicated VRAM, so it is not a second candidate.

    Neither fact blocks this measurement, because tolerance is not a
    throughput question. It needs enough memory to hold two forms of one
    stage at once, and it needs identical inputs. 24 GB gives the first
    and a deterministic renderer gives the second.

    Windows reports the 3090 as 4 GB through `Win32_VideoController`. That
    is the 32-bit `AdapterRAM` field overflowing; `nvidia-smi` reports
    24576 MiB. The wrong number is recorded here so nobody re-derives it.
    """

    details "What is compared, and against what", ~S"""
    | run | precision                    | purpose                                 |
    | --- | ---------------------------- | --------------------------------------- |
    | A   | bf16                         | the baseline, on this card, not a paper |
    | B   | four-bit, DFC host emulation | what the device would compute           |

    Same image, same seed, same fov in radians. `render_view.py` is
    bit-reproducible at one thread: two runs, identical sha256, measured.
    """

    details "The quantity", ~S"""
    Surface deviation between the two meshes, in millimetres, paired with
    a household object. A penny is 1.52 mm and a credit card is 0.76 mm,
    so half a penny of error is a sentence somebody can act on, and "the
    mesh looks fine" is not.

    Report a distribution rather than one number: median, 95th percentile
    and maximum. A mean hides the case that matters, which is a hand or an
    ear moving while the torso stays put.
    """

    details "What would make this a failure", ~S"""
    No threshold is set here, on purpose. The RFD that consumes the mesh
    should set it. What this produces is the number a threshold can be
    written against.
    """

    details "Why the DFC and not bitsandbytes", ~S"""
    A general quantiser measures a four-bit. The device runs the Dataflow
    Compiler's four-bit, with its own calibration and layer rules, and the
    DFC ships a host emulator that runs that graph. The emulator is slow
    and exact, which is the right trade when the question is numerics
    rather than speed. `weftspun-hailo-dfc:5.3.0` is the image, built and
    verified importable on 2026-08-22.
    """

    drafted_by :ai
  end
end
