# Logbook: the G1 sim-to-real smoke run on mjlab

**Date:** 2026-09-08
**Session:** MAGI (`magi-16739d.agents.weftspun`)
**Related:** RFD 2238; RFD 2237; PITFALLS 12
**Where:** `3-interactor/motion-bricks-cpp/mujoco` (`motionbricks_task/`), WSL2
Ubuntu 26.04 on the desk, the 4090

## What was measured

The microduck formula stood up on the Unitree G1: mjlab 1.6.0 on MuJoCo Warp
3.11.0, PPO through rsl-rl 5.4.2, 50 Hz control, ONNX export with the
normaliser baked in. A throwaway run to prove the pipeline, not a gait.

| stage                       | figure                                          |
| --------------------------- | ----------------------------------------------- |
| environment build (16 envs) | actor 99, critic 111, action 29, 414 steps/s    |
| training                    | 300 iterations, 1024 envs, 341 s, ~21,600 steps/s |
| roll-out (64 envs, 1000 steps) | ROM clearance 0.7986, mean reward 0.054/step |
| envelope shifted 30 deg     | ROM clearance 0.7562 (below the 0.9 rail)       |
| export                      | `[1, 99] -> [1, 29]`, normaliser in the graph   |

The ROM clearance denominator is 1,000 frames × 64 environments × 8 gate
joints. 341 seconds of training is about the time a kettle takes to boil
twice; 21,600 environment steps a second is 432 seconds of simulated
walking every wall-clock second at 50 Hz.

## What it says

The pipeline closes: envelope artefact, environment, training, roll-out
with the ROM metric, export with the shape asserted. Nothing about the
policy: 300 iterations is the pipeline's warm-up, and the clearance sits
below the rail the real policy will be held to.

## What it does not say

The observation contract. 99 is mjlab's actor group as it stands (joint
positions and velocities, projected gravity, base velocities, last action,
the twist command) with no cloth, mocap or gamepad slots; it is recorded as
the candidate to freeze against, not the ruling. `K_max` and the E.3
reading stay open; no policy ships or publishes before they close.

## Apparatus

- `pixi install -e default` in `mujoco/` inside WSL2 (mjlab is Linux or
  macOS only), detached environments on the WSL filesystem, the 4090 chosen
  by name (`gpu.py`: bus order, then `nvidia-smi`'s name).
- `pixi run envelope-self-test`, `envelope`, `envelope-check`,
  `stack-check`, `env-check`, then `pixi run smoke --num-envs 1024
  --iterations 300`; the roll-out and export re-ran from the checkpoint
  with `--run <dir>` after the joint-selection fix.
- Records: `mujoco/bench/smoke_record.json`,
  `mujoco/bench/smoke_export_manifest.json`, `mujoco/data/g1_rom_envelope.parquet`.
