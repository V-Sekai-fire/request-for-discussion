# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2244. `mix rfd.render` renders rfd/2244-one-deformation-operator/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2244 do
  use RFD.DSL

  rfd 2244, "One deformation operator: identity, fit and props are the same thing applied to different corners" do
    state :discussion

    flight_level :l2

    compact_head true

    feature "one deform stage — blendshapes, correctives, driver bones — with no per-category branch"

    scope "supersedes the dress and identity overlay stages; `3-interactor/anny`"

    decision ~S"""
    A mesh is faces and corners. Everything done to one is a deformation of those
    corners in three terms and no others: static blendshape targets, pose-driven
    correctives, and a skeleton whose joints may be driver bones. Identity and fit
    are that operator over different corner sets, so they collapse into one stage.

    No category gets a branch. A garment, a face, a prop and a set piece differ in
    which corners they touch and which bones drive them, never in the operator
    applied: the pipeline asks *which corners, which drivers*, not *what kind of
    thing is this*.
    """

    problem ~S"""
    RFD 2186 and RFD 2187 describe the same machine twice: same base mesh, same
    training pattern, disjoint slices of one taxonomy, each citing the other as
    "parallel". Their only stated difference is update rate, which belongs to the
    caller and not the operator. Two stages built on it duplicate the schema, the
    training signal and the export path, and invite a prop and an environment
    stage as near-copies.
    """

    details_title "One deformation operator: identity, fit and props"

    details_preamble ~S"""
    What follows is the argument for the three terms, what "props and environment
    are not special" costs and buys, and the checks that would falsify the claim.
    """

    details "The duality, stated plainly", ~S"""
    Identity varies across characters and is constant across a character's frames.
    Fit varies across a character's frames and, for a given garment, is constant
    across characters. Swap which index is held fixed and one becomes the other.

    That is the whole of the difference the two RFDs encode. A representation that
    needs a branch to express both has privileged one index, and the privilege is
    not recoverable from the geometry — only from which loop the caller happens to
    be standing in.
    """

    details "The three terms", ~S"""
    A deformed corner position is the rest position plus a weighted sum of static
    targets, plus a weighted sum of correctives whose weights are functions of pose,
    the whole then transformed by the skinned skeleton. Driver bones are joints
    whose transforms are themselves functions of other joints rather than of
    animation input; they are a compression of correctives, not a fourth term.

    Nothing above mentions what the mesh depicts. That is the point of writing it
    down: the operator is total over meshes, and a stage that dispatches on subject
    matter is carrying a distinction the mathematics does not have.
    """

    details "Why props and environment are not a special case", ~S"""
    A prop is a mesh with corners and, usually, a skeleton with few joints. A set
    piece is a mesh with corners and, usually, no skeleton. Both are the general
    case with terms set to zero, and zero is a value rather than an absence — the
    same reason the working agreements refuse a null for "no parent".

    The saving is not that props become easy. It is that a prop and an avatar move
    through one export path, so a fix to skinning or to corrective evaluation lands
    once. The cost is that the schema must carry a corner set and a driver set
    explicitly, where two special-cased stages could leave them implicit.
    """

    details "What this does not decide", ~S"""
    It does not decide which generator produces the targets. RFD 2186 and RFD 2187
    both named one; this RFD deliberately does not, because the operator is
    indifferent to where a blendshape basis came from and the generator question has
    its own measurements pending.

    It does not decide the part taxonomy. The V3 parts those RFDs partitioned remain
    a labelling of corners, and labelling corners is compatible with a single
    operator over them.

    It does not claim a measurement. No corpus has been built against this shape
    yet, and the falsification below is what would have to run first.
    """

    details "How this could be wrong", ~S"""
    The claim is that no category needs a branch. It is falsified by exhibiting a
    deformation the workshop needs that the three terms cannot express without one.
    Two candidates are worth checking before committing:

    Topology change. A garment that adds corners rather than moving them is not a
    deformation of the base mesh, and no blendshape basis expresses it. If dressing
    requires new geometry rather than displaced geometry, fit is not the dual of
    identity and this RFD is wrong at its root.

    Pose-dependence of identity. The RFDs claim identity is frozen. If a face
    requires correctives driven by expression, identity is pose-dependent after all
    — which does not break the collapse, but does break the "frozen per character"
    justification the two stages were split on, and the split then has no stated
    basis at all.
    """

    references ["RFD 1083", "RFD 2186", "RFD 2187"]

    related ~S"""
    Supersedes RFD 2186 and RFD 2187, both retracted to this RFD. RFD 1083 is the
    export surface; RFD 2183 consumes what this produces; RFD 2184 applies once
    rather than twice. `DETAILS.md` carries the argument.
    """

    drafted_by :ai
  end
end
