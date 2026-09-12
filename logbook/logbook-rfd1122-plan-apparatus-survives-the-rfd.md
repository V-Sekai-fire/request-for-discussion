# RFD 1122's plan apparatus outlives the RFD

RFD 1122, the wholebody gap, is abandoned. Serial 1122 sits in `SERIALS.exs`'s
`deleted` block and commit 830a1c4 removed its README and DETAILS outright, which is
what the retraction rule asks for.

Its plan did not go with it, or should not have. `rfd1122-plan.usda` is cited by name
for numbers that live documents still rest on. `BLOCKLIST.md` settles
`neuralEngineUsefulForBackbone = 0` from it. RFD 1142's README and DETAILS take 1685.1
ms from it. `scripts/ane_bench.py` names it in its own docstring for the two booleans
that bound the M2Pro scope. Deleting the RFD deleted the file those five citations
point at, and nothing reported that, because a citation is prose and prose is not
resolved by anything.

The two layers are restored to `apparatus/1122-the-wholebody-gap/`, which is where
apparatus belongs and is a tree the RFD's deletion does not reach.
`scripts/check_rfd1122_plan.py` reads them there.

## The quantities, recorded because their reviewed home was deleted

The gate's stated property is that the stage is not allowed to be the only place a
number lives, so that a number is reviewed rather than merely asserted. DETAILS.md was
that reviewed place. These are the values it carried, transcribed from the stage so the
property holds again:

| quantity                | value  |
| ----------------------- | ------ |
| `wholebodyKeypoints`    | 104    |
| `bodyVertices`          | 13718  |
| `basemeshVertices`      | 19158  |
| `basemeshQuads`         | 18486  |
| `textureCoordinates`    | 21334  |
| `mocapClips`            | 810    |
| `qwenDefaultStrength`   | 0.8    |

The plan graph is six layers deep, and nine of the ten tasks are critical. One task has slack.

These are transcriptions, not measurements. Nothing here was observed today. Each value
is what the stage states, and the stage is what RFD 1142 and `BLOCKLIST.md` were already
reading when the RFD that reviewed them was removed.

## What this does not settle

Whether the numbers are right. The gate checks that the stage and a reviewed document
agree, and a wrong value stated identically in both still passes. RFD 1122 is abandoned,
so no live document argues for these values; they are preserved because other documents
depend on them, which is a weaker claim than the RFD made.
