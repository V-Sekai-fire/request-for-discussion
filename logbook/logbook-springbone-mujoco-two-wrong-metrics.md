# Two wrong bend metrics, and a chain that was welded the whole time

`apparatus/springbone_mujoco.py` scores a spring-bone chain reduction by how much the
garment silhouette moves. Three things about it were wrong at once, and each hid the next.

## The metric measured the carrier, not the chain

Two forms were tried before one worked.

**World-space displacement.** The carrier body that drives the motion suite translates the
whole chain, so the chain's own bending is a rounding error beside it. Every parameter
setting returned the same number.

**Anchor-relative displacement.** `traj - traj[:, :1, :]` subtracts the first body's
position, which removes the carrier's translation and leaves its **yaw**. A perfectly rigid
chain swung through an arc still scores. Measured on a horizontal 8-bone chain over two
seconds:

| chain | anchor-relative displacement | segment-angle bend |
| --- | --- | --- |
| loose, `gravity=1.0`, `pull=0.01` | 2.9367e-01 | 4.9651e-11 rad |
| frozen, `gravity=0`, `pull=1`, `immobile=1` | 2.9367e-01 | 1.0174e-07 rad |

Identical to five figures, for two models whose MJCF genuinely differs: `gravcomp` 0.0000
against 1.0000, `damping` 1.9150 against 10.0000, `stiffness` 2.9000 against 42.5000. The
parameters reached the model and the metric could not see them.

**What works.** The angle between consecutive segments cannot be changed by translating or
rotating the body it belongs to, so a rigid chain scores zero however it is flung around.
The metric is the largest change in that angle signature across the run.

## The fixture hid it by lying on both axes at once

Every dynamics test built its chain along `-Y`. Gravity is `0 -9.81 0`, so the chain hung
collinear with the force: the moment arm is zero and it cannot bend. The carrier's yaw is
also about `Y`, so a chain on that axis is invariant to the rotation the old metric was
accidentally measuring. One geometry cancelled both the physics and the defect.

Along `-Y` all three arms read the same number, including one built to bend:

    loose, gravity=1.0                            5.551e-17
    FALSIFY arm, gravity=0, pull=1, immobile=1    5.551e-17
    arm that must bend, gravity=1, pull=0         5.551e-17

`test_FALSIFY_frozen_chain_does_not_articulate` therefore could not fail. Its own docstring
says it exists to stop the harness "reading integrator noise -- or rigid transport -- as
dynamics", which is the thing it was doing.

## Underneath both, the chain is welded

With a correct metric and a horizontal chain, a loose 8-bone chain at `pull=0.01` under full
gravity bends about **5e-11 rad**. Capsule masses are around 1e-2 kg against joint stiffness
around 3 N*m/rad, so neither gravity nor carrier acceleration moves the joints.

The module's `UNCALIBRATED` block already recorded this and named the fix: drive a known
spring-bone chain in the editor's play mode, record tip deflection and settling time per
parameter, and fit the constants to that. Nothing here calibrates anything, and no number
above is a claim about the platform's solver. Until that measurement exists, Tier 1 is the
only sound output of the module, because it is combinatorial and runs no simulation.

`test_gravity_articulates_a_loose_chain` is `xfail(strict=True)` against that. Strict so
that calibration landing turns the marker red and forces its removal, rather than leaving a
passing test quietly marked as expected to fail.

## What is not settled

Whether the two Tier 2 and Tier 3 numbers mean anything. They are scored with the corrected
metric now, but they are scored on a welded chain, so they rank candidates by almost
nothing. The reduction tiers stay unsafe to trust in the same way the module already says
they are.
