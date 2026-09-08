# Logbook: Gemma 4 E2B QAT Q4_0 on a hosted-runner CPU

**Date:** 2026-09-07
**Session:** MAGI (`magi-16739d.agents.weftspun`)
**Related:** RFD 1170 (presence loop, 500 ms whole-loop budget); PITFALLS 12
**Where:** `v-sekai-fabric/llama-cpp-npu-vision`, workflow
`gemma4-e2b-qat4-cpu-bench`, run 34162075692

## What was measured

`llama-bench` from upstream `llama.cpp` at `67672dc` and from the workspace's
TurboQuant fork at `turboquant-godot dc613ac`, on Google's own QAT Q4_0 GGUF
`google/gemma-4-E2B-it-qat-q4_0-gguf/gemma-4-E2B_q4_0-it.gguf` (3.35 GB, 4.63 B
parameters, gemma4 E2B). Runner: `ubuntu-latest`, 4 threads, AMD EPYC 7763.
Prompt 128 tokens, generation 64 tokens, 3 repetitions per row.

The bar is the human's reading speed, about 4 to 5 words per second, which is
about 6 tokens per second.

| build           | KV cache | pp128 t/s | tg64 t/s |
| --------------- | -------- | --------- | -------- |
| upstream Q4_0   | f16      | 43.67     | 18.28    |
| fork Q4_0       | f16      | 44.17     | 17.32    |
| fork Q4_0       | turbo4   | 33.06     | 16.64    |
| fork TQ4_1S     | f16      | 0.26      | 0.25     |

## What it says

Generation is 17 to 18 tokens per second: three times reading speed, and a
budget of 55 to 60 milliseconds per token before the VRChat presence loop
starts to fall behind on this class of runner. The fork tracks upstream within
one token per second, so the vendored ggml is not the cost. The TurboQuant
turbo4 KV cache is 6 per cent slower on generation and 25 per cent slower on
prompt, so today it is a memory-for-latency trade rather than a speed win.

## What it does not say

The fourth row, TQ4_1S at 0.25 tokens per second, is not a measurement of that
format. It is a Q4_0 checkpoint requantized through the fork's `llama-quantize
TQ4_1S` path and read by a CPU dispatch that has no vector kernel for the
type; every read falls through the reference loop. The row is kept because it
carries the shape (5.0 bpw, WHT-rotated 4-bit) and because a later run with a
tuned kernel wants a floor to beat.

## The guard rail

The workflow's next step reads `bench.md` and fails when the minimum tg64 or
pp128 across the rows drops below a floor stated in the job's env
(`TG64_MIN=6.0`, `PP128_MIN=32.0`). The floors are conservative: reading speed
for tg and just under upstream's own pp for the runner's class. The TQ4_1S row
is excluded from the guard until it has a real kernel, because a slow row
there is a known artefact rather than a regression. A slower model, a slower
build or a runner too small to hold the working set fails the job by name.

Run 34180629470, the first with the guard in place, passed. The guard step
read six rows (the four above, each build also at 8 threads) and printed
its floor line: tg64 minimum 16.89 tokens per second against the rail of
6.0, pp128 minimum 33.30 against 32.0. The pp128 margin is 4 per cent, so a
slower runner in the hosted pool trips it first; that is the intended
signal, and the rail moves only with a measurement beside it.

## Apparatus

- Model: `google/gemma-4-E2B-it-qat-q4_0-gguf`, file
  `gemma-4-E2B_q4_0-it.gguf`, Apache-2.0, ungated.
- Fork: `V-Sekai-fire/turboquant-godot@feat/turboquant-on-master`,
  `thirdparty/llama_cpp` alone.
- Upstream: `ggml-org/llama.cpp`, unpinned; the run records the SHA it built.
- Both trees built with `GGML_NATIVE=OFF`, `GGML_BACKEND_DL=ON`,
  `GGML_CPU_ALL_VARIANTS=ON`, tools only. The fork's ggml needs
  `GGML_BACKEND_DL` to compile at all (`ggml-backend-dl.cpp` is unconditional
  while its handle type is defined only under that flag), and that flag
  refuses `GGML_NATIVE`; both trees take the same recipe so the comparison is
  on one footing.
- Workflow file: `.github/workflows/gemma4_e2b_qat4_cpu_bench.yml` (branch
  `magi/gemma4-e2b-qat4-cpu-bench`). Rerunnable at
  `workflow_dispatch(runs=…, fork_ref=…)`.
