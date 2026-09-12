# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2186. Abandoned; the training shape it proposes is blocklisted.
defmodule RFD2186 do
  use RFD.DSL

  rfd 2186, "Transfer OmniGen2 image-edit into a Lumina2 nf4 LoRA via QAFT-4bit" do
    state :abandoned

    feature "retracted"

    scope "retracted"

    decision ~S"""
    Retracted 2026-09-12. This RFD trains a bf16 LoRA over a bnb nf4 base
    and calls the result QAFT. `BLOCKLIST.md` refuses that shape for any
    workflow described as QAFT, QAT, distillation or 4-bit training,
    including with LoRA, because the artifact ships as two files at two
    precisions and the adapter half never sees the quantization the base
    does. The measurement the row rests on is this RFD's own premise:
    OmniGen2's hidden_size of 2520 is not a multiple of 64, so bnb falls
    off its fast dequant kernel, and a LoRA that trained at 0.35 s a step
    on Lumina-Image-2.0 did not reach step 1 of 50 on OmniGen2 in ten
    minutes.

    The approved 4-bit path is a training loop whose weights are quantized
    in the forward pass throughout, with straight-through estimation on
    the backward, saving one 4-bit checkpoint. An adapter may join that
    loop when it trains under the same quantized forward.
    """

    drafted_by :ai
  end
end
