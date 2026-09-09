# Logbook: three defects in the shipped dress-on corpus, and why differencing the decodes cannot find a garment

Apparatus: `voxhammer-upstream/tools/{write_dress_on_rows,publish_dress_on,usd_io,usd_convert}.py`,
`run_edit_test.py`, and the staged tree `work/batch1/stage3` (12 rows, 36 candidates,
2,304 score rows). Meshes measured in one shared unit-height frame. Published to
`chibifire/anny-dress-on-stage-train`; a copy pulled before 2026-09-08 carries the
first two defects.

## Three candidates shared one mesh

`stage_asset` keyed its destination on the source file's name under a directory that
was per row rather than per candidate, so rank1, rank3 and rank5 all wrote
`candidate.usda` and `candidate_gaussian.ply` to one path. The later copies were
dropped in silence, because the writer only copied when the destination was absent.
Front and back renders collapsed the same way.

    distinct meshes / candidate rows        12 / 36
    2d_render_front vs 2d_render_back       byte-equal on every row

The published dataset therefore asserted that three different candidates share one
geometry. Worse, RFD 2234's own negative control could not fail: it swaps rank1's
asset for rank5's and requires a non-zero exit, and the two already pointed at one
file. A check that cannot fail on known-broken input certifies the defect.

Fixed by keying the destination on the candidate and the side, and by refusing rather
than aliasing when two different sources reach one destination.

    distinct by content / candidate rows    36 / 36
    front differs from back                 24 / 24 that carry both
    negative control                        exits non-zero

## The edited candidates declared the wrong scale

rank1 and rank3 carried `metersPerUnit = 1` while `body.usda`, rank5 and the masks
carried the identity's stature, on all twelve targets. A consumer honouring USD units
read the two edited candidates 30 to 49 per cent too small.

Geometry was never affected. Every mesh is unit-height and only the declared scale
lied, which is why the voxel gate, which normalises, stayed green and nobody noticed.

Cause in two places. `run_edit_test.py` called `usd_io.write_mesh` without a scale and
took its default of 1.0; `usd_convert.py` then found the file present, reported
`"present"`, and skipped it. A silent skip reads exactly like a pass.

Fixed in three: the scale is a required argument on the driver, `dress_on_batch.py`
passes it from `phenotype.json`, and the skip became a check that refuses a mismatch.
24 declarations repaired, geometry asserted unchanged vertex-for-vertex.

## Payload moved into the parquet

RFD 2234 had ruled for assets beside the parquets. The operator reversed that on
2026-09-08: a path is not the data, and the publisher drops what it points at, which
is how the FBD corpora lost their diagrams.

    images round-tripped, same pixels       204 / 204
    blobs round-tripped, byte-identical     108 / 108
    mesh parsed out of the parquet          via usd_io.read_mesh
    staged / published                      441 MB / 878 MB
    files on the Hub                        8, and no assets/ tree

The 156 asset files from the collided upload were deleted. The feature declaration is
generated from the parquet schema, so a column added to the writer cannot go
undeclared.

## Differencing the decodes cannot separate the garment

The operator asked for basic segmentation by mesh and image operations, so the
original body could be reused under a new dress-on. Measured on `female-p1__g0`, and
the answer is no. Three measurements, each a reason on its own.

**Vertex colour cannot classify.** The far-from-body, near-body, in-box and
out-of-box groups all sit between 0.542 and 0.601 grey. There is no albedo to
separate cloth from skin.

**The decodes differ everywhere, not at the garment.**

    dressed / undressed vertices            137,106 / 95,482
    dressed verts >10 units-mm from nearest 59 %
    of that far set, falling inside a box   58 %
    of the in-box set, far                  72 %

A garment-shaped difference would concentrate in the torso boxes. This one runs
through the leg and head bands too.

**The decode does not conserve the body.** In one shared unit-height frame:

    body.usda        0.0388 m3    about 38 kg at water density, plausible for a
                                  1.4 m first-percentile female
    rank5 (undressed decode)  0.0143 m3
    rank1 (dressed decode)    0.0247 m3

rank1 exceeds rank5 by 0.0104 m3, about 10 litres, or a little over five 2-litre
bottles. No garment is 10 litres of cloth.

So the difference between the two decodes is dominated by what the decoder did, not
by the garment, and any distance threshold on it measures TRELLIS rather than fabric.
Recorded here rather than worked around.

**What works instead needs no model and no new capture.** The garment's extent is
already known by construction in the conditioning views. `composite.json` records the
paste (`placed_at`, `size`, `rotation_deg`, `scale`, `alpha_threshold`,
`torso_coverage`, `fraction_inside_body_mask`) and `view.json` records the camera that
saw it (`frame`, `index`, `camera_position`, `forward_dot`, `mask_bbox`). The garment
alpha is an input we hold. Back-projecting that known region onto the body surface
labels the cloth without inferring anything.

That also answers the structured-light suggestion raised the same day. A projected
pattern buys correspondence, and here correspondence is already exact, because the
camera and the paste are both ours. Structured light is the right tool for a capture
rig with no geometry, not for a render we authored.

The body was never destroyed to begin with: `body.usda` is exact, per row, and
regenerable from `identity.json`.

## A fourth defect, found on the way out

`bao login -field=token` prints a not-stored notice above the token.
`publish_dress_on.py` handed the whole of stdout to `BAO_TOKEN`, so every publish
failed with "no hf_token in bao agents row". `publish_fbd.py` and `trust.ex` already
took the last line; `publish_dress_on.py` and `publish_rollouts.py` did not. Both
fixed.
