# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2236. `mix rfd.render` renders rfd/2236-fbd-teacher-in-three-steps/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2236 do
  use RFD.DSL

  rfd 2236, "A teacher that exports Function Block Diagrams, gained in three steps" do
    state :discussion

    flight_level :l2

    feature "the model behind `/fbd` on the taskweft-acp door: a constructed EditScore-shaped corpus, continued pretraining of Gemma 4 E2B under QAT, then reinforcement training with the compiler and the sandbox as the hard half of the reward"

    scope "`3-interactor/taskweft-fbd-teacher`, `3-interactor/taskweft-fbd-compiler`, the `/fbd` command of `1-transport/transport-taskweft-acp`"

    decision ~S"""
    The teacher's only output is an IEC 61131-3 Function Block Diagram in the
    PLCopen subset `taskweft-fbd-compiler` parses; a llama.cpp grammar makes any
    other output unsampleable. The model is gained in three gated steps rather
    than taken from a stock checkpoint: a constructed corpus whose labels the
    compiler and a runner set (step 1, shipped), continued pretraining of Gemma
    4 E2B on its rank1 rows with the forward pass seeing the 4-bit noise (step
    2), and reinforcement training whose reward is compile, run and effect from
    the compiler plus a frozen judge (step 3). The teacher runs on an executor
    side with the GPU, never on the hosted door. `DETAILS.md` carries the rest.
    """

    problem ~S"""
    The operator ranked four candidate efforts and picked this one: an MCP-ACP
    server whose teacher language model is forced to export a Function Block
    Diagram, with the Godot engine as the scripting engine that touches the
    operating system. A stock model behind a grammar produces well-formed
    diagrams that mean the wrong thing; nothing in the workspace measured how
    often. The compiler existed as a marker-counting skeleton, the sandbox host
    existed for exported sessions, and no corpus tied an intent to a diagram.
    """

    references ~S"""
    - RFD 2229, interchangeable parts, which decides what each leg reuses
    - RFD 2152, RFD 2154, RFD 2155, RFD 2156 and RFD 2157, the PLCopen, sandbox and compiler line this continues
    - RFD 2167, the reward-distillation shape step 3 follows
    - RFD 2234, whose writer set the frozen-judge doctrine and the three-parquet corpus shape
    """

    related ~S"""
    RFD 2235 (the door and its executors), RFD 2188 (one ggml across the workspace), RFD 2196 (dataset viewer rules the publisher follows).
    """

    details_title "A teacher that exports Function Block Diagrams, gained in three steps"

    details "Interchangeable parts", ~S"""
    | leg | the part that already exists | what changes |
    | --- | --- | --- |
    | the door, executors, session log | `transport-taskweft-acp` | `/fbd`, one executor capability, one `acp/fbd` event |
    | the model runtime | `turboquant-godot/thirdparty/llama_cpp` (RFD 2188), `llama-server` with the GBNF `grammar` field | a CUDA build on the desk |
    | the loopback server client | `qwen35-defiant/src/interactor.{h,cpp}` | an Elixir twin |
    | the FBD compiler | `taskweft-fbd-compiler` (Lean) | a real parser, the stage 1 lowering, a CLI |
    | the runtime host | `taskweft-godot-sandbox` and the host scene in `transport-taskweft-acp/priv/godot_project` | the guest is a compiled diagram rather than an exported session |
    | the dataset shape | `anny-render-corpus/maskscore_rung_1_*` (root, candidates, scores; controls before the emit) | one new stub row for the FBD task |
    | the judge | `editscore` and the frozen-judge doctrine | a text-and-trace prompt |
    | the training pattern | `tropes-removal-model/train_rewriter.py`, RFD 2167 | the same shapes on Gemma 4 E2B |
    | the publish recipe | `publish_artifacts.py` | a new dataset repository |

    No new dependency mechanism, no second model runtime, no second sandbox, no
    hosted-API generator, no post-training quantization.
    """

    details "The compiler after this RFD", ~S"""
    `Parser.lean` reads a program POU with BOOL, INT and STRING locals,
    `inVariable` literals, blocks wired through `connectionPointIn`, and
    `outVariable`s; an element outside that subset is refused by name, and the
    tag-soup fixture is the control. `Sgd.lean` lowers `WRITE_FILE`, `RUN` and
    `READ_FILE` in EN/ENO order, or localId order, to the four-call SafeGDScript
    guest the host scene already drives (`steps`, `step`, `record`, `pending`,
    RFD 2156) and to a JSON plan for any other runner; every other block is
    counted as skipped, never dropped. `Main.lean` gains `check`, `emit` and
    `plan`. The ELF emit of RFD 2157 stays the next stage; the toolchain file
    pins Lean 4.34.0-rc1 while the desk builds it on 4.30.0.
    """

    details "Step 1: the corpus", ~S"""
    Constructed, so ordinary training data under CLAUDE.md. Four templates over
    operating-system chores (write a file; write then check it exists; run a
    command that prints a number; create files then count them) turn a seed
    into an intent, the reference diagram (rank1), a diagram that compiles and
    does the wrong thing (rank3: a wrong literal, a missing file, one file
    short) and one the compiler refuses (rank5: an unwired pin, an EN/ENO
    cycle, an unknown block). The stub row is
    `("fbd", "intent_to_fbd", "instruction_following", "input_intent", "text")`.

    Scores come from `check` and `plan` (parses, compiles) and from a runner
    that performs the plan's steps in a scratch directory the way the host
    scene does (runs, steps, effect_matches, wall_ms, refusal). Three controls
    are asserted on every row before the emit: rank1 compiles, runs and
    matches; rank3 compiles and misses; rank5 is refused. The writer's own
    negative control hands rank5's verdict to rank1 and must refuse the emit.
    One row in ten is a holdout written apart. Three ZStandard parquets in
    ETNF plus the joined view; the publisher follows RFD 2196's `configs`
    block.
    """

    details "Steps 2 and 3, the gates", ~S"""
    Step 2 continues pretraining `google/gemma-4-E2B-it-qat-q4_0-unquantized`
    on rank1 rows on the desk's 4090, the grammar as a filter on anything that
    enters, quantization-aware throughout (no adapter over a quantized base, no
    quantize-after). Gate: on the holdout, the fraction of completions that
    compile, run and match, with the stock checkpoint under the grammar as the
    floor row.

    Step 3 is GRPO over that checkpoint. The hard half of the reward is the
    compiler and the runner (parses, compiles, runs, effect, summed); the soft
    half is EditScore on intent, diagram and trace with its tuple frozen
    before the run and recorded on every row, a refusal never a score.
    Sampling stays under the grammar. Gate: the same holdout table, three rows
    (stock, pretrained, reinforced); the reinforced row must beat the
    pretrained on effect without losing compile rate, or it does not ship.
    The shipped checkpoint is what `mix taskweft_acp.executor --teacher`
    serves.
    """

    details "What was measured", ~S"""
    The compiler builds on Lean 4.30.0 in 12 jobs; `check` accepts the
    reference diagram (2 blocks, 2 operating-system, 1 variable, 3 literals),
    `plan` lowers it to two steps, and `check` refuses the tag-soup control
    with "<note> is not part of the FBD subset". The writer wrote 8 rows in
    2.2 seconds on this desk with every control holding, and its negative
    control refused the emit with "identity control failed". The 5,000-row
    corpus and its holdout are the next table in this section, with the
    template counts and the compiler SHA from the manifest.
    """

    drafted_by :ai
  end
end
