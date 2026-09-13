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

## Underneath both, the rig generated no force at all

With a correct metric and a horizontal chain, a loose 8-bone chain at `pull=0.01` under full
gravity bends about **5e-11 rad**, and a fully frozen one bends 1.0e-07 rad. Both are zero.

**Retracted 2026-09-12, and the reading above it is what was wrong.** This entry first said
capsule masses of around 1e-2 kg against joint stiffness of around 3 N*m/rad were why
nothing moved, repeating the module's own `UNCALIBRATED` block. That is not the cause. The
editor sweep that followed measured chains reading **exactly 0.0 deg at every setting**,
which a stiffness ratio does not produce: it would scale the deflection down, not delete it.

The cause is that imposed kinematics generate no force. `simulate` wrote the carrier's
`qpos` each step, which teleports it, and then wrote `qvel`, which clobbers the velocity
rather than producing an acceleration. A parent moving at constant velocity exerts nothing
on its children, so the chains were never driven at all. The fix is a position actuator and
a driver with real mass. This is the same root cause as the retracted collision-check
numbers.

The stiffness story was not merely incomplete. It named a plausible mechanism, which is
worse than naming none, because it reads as a diagnosis and it sent the next question at
the constants rather than at the rig.

**And the constants are wrong in more places than one.** The same sweep drove 17 chains from
one root with a 0.15 m step, varying one knob at a time:

| knob | measured | mapped as | verdict |
| --- | --- | --- | --- |
| `pull` | settling 5.00s to 0.10s across 0.05..0.8 | stiffness (`K_PULL`) | it is damping |
| `stiffness` | peak 58.721 to 58.722 deg, settling flat | stiffness (`K_STIFF`) | no measurable effect |
| `immobile` | peak 58.7 to 9.9 deg, settling flat at 1.18s | damping (`C_IMMOBILE`) | it is a forcing gain |

Three of five constants are misassigned rather than unfitted. The `UNCALIBRATED` block read
as "these need fitting"; the measurement says the mapping is wrong, which is a different
repair and a larger one.

## What is not settled

Whether the Tier 2 and Tier 3 numbers mean anything. They are scored with the corrected
metric, and the driven rig replaces the one that produced no force, but the parameter
mapping is still three constants wrong, so what they rank is not yet what the platform
does. Tier 1 is combinatorial and runs no simulation, so it is unaffected throughout.

`test_gravity_articulates_a_loose_chain` was `xfail(strict=True)` while the chain read zero.
The marker is gone: the driven rig makes the chain bend, strict turned it red as intended,
and it was deleted in the commit that landed the calibrated mapping. The suite reads 14
passed. A marker that outlives its condition is the failure the strict flag exists to
prevent, and here it did not get the chance.
