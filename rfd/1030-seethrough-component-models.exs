# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1030. `mix rfd.render` in rfd_dsl/ renders rfd/1030-seethrough-component-models/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1030 do
  use RFD.DSL

  rfd 1030, "See-Through component models" do
    state :published

    feature "layer decomposition"

    attest_in :none

    decision ~S"""
    Name each component here. Record its base model, its role, and its
    memory.

    See `DETAILS.md` for the component table, the two runtimes, and why
    bf16 is the ceiling while GGUF is the floor.

    **WITHDRAWN 2026-08-29 as a deployment plan, kept as a component map.**
    RFD 1166 dropped See-Through from the candidate ranking on licensing:
    the checkpoints named below state no licence, and the depth component
    derives from an OpenRAIL++-M model. The table remains accurate about
    what the project is made of and is no longer a plan to run it.
    """

    problem ~S"""
    The `seethrough_layer_decomposition` entry names one task. The task
    runs nine models. One catalog row hides that fact.
    """

    related ~S"""
    RFD 1006 records the layer decomposition design. RFD 1019 selects the
    same ggml runtime for the Elixir core. RFD 1026 carries the single
    catalog row that this RFD breaks down.
    """

    details_title "See-Through component models"

    details "The components", ~S"""
    | Component      | Base model          | Role                 | Parameters |    bf16 |
    | -------------- | ------------------- | -------------------- | ---------: | ------: |
    | layerdiff-unet | SDXL UNet           | Generates layers     |    2.567 B | 5.13 GB |
    | marigold-unet  | Marigold            | Depth estimate       |    0.865 B | 1.73 GB |
    | layerdiff-te2  | CLIP text encoder 2 | Prompt encode        |    0.695 B | 1.39 GB |
    | marigold-te    | CLIP text encoder   | Depth conditioning   |    0.340 B | 0.68 GB |
    | layerdiff-te1  | CLIP text encoder   | Prompt encode        |    0.123 B | 0.25 GB |
    | trans-vae      | TransparentVAE      | Alpha decode         |    0.100 B | 0.20 GB |
    | layerdiff-vae  | SDXL VAE            | Latent decode        |    0.084 B | 0.17 GB |
    | marigold-vae   | Marigold VAE        | Depth decode         |    0.084 B | 0.17 GB |
    | lama           | LaMa                | Inpaints hidden area |    0.051 B | 0.10 GB |
    | **total**      |                     |                      |  **4.9 B** | 9.82 GB |
    """

    details "Two runtimes", ~S"""
    Replicate runs the Cog model from RFD 1006, in bf16. There is no DGX,
    per RFD 1027 and RFD 1036. see-through.cpp runs the same models on a
    local machine, with ggml and a Vulkan backend. It reads GGUF weights
    and writes a layered PSD. It needs no Replicate connection, and it
    uses the Apache 2.0 license.
    """

    details "bf16 is the ceiling, and GGUF is the floor", ~S"""
    The local runtime does not use bf16. Q4_K_M holds one parameter in
    about 0.55 bytes, thus the same nine components need about 2.7 GB.
    Plan the Replicate path against 9.82 GB. Plan the local path against
    2.7 GB.
    """

    drafted_by :ai
  end
end
