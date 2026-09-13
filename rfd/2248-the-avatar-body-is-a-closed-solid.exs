# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2248. `mix rfd.render` renders rfd/2248-the-avatar-body-is-a-closed-solid/README.md
# and DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2248 do
  use RFD.DSL

  rfd 2248,
      "The avatar body is a closed solid" do
    state :discussion

    flight_level :l1

    feature "a body mesh that answers inside-or-out, so fitting, penetration depth and coverage all measure the same thing"

    scope "avatar body meshes entering any geometric tool: cloth fit, cloth simulation, convex decomposition, coverage measurement"

    decision ~S"""
    An avatar body mesh is welded by position, has every boundary loop capped,
    and has its closed pieces unioned into one solid before any tool asks a
    geometric question about it.

    A garment fit, a penetration depth and an intersection test all ask whether a
    point is inside the body, and that has no answer on an open surface. The
    tools do not refuse to answer. They answer differently, and the disagreement
    stays hidden until something downstream fails for an unrelated-looking
    reason.
    """

    problem ~S"""
    The avatar's body showed through its clothing, and every attempt to fix that
    by fitting the garment failed at the same place: the solver refused to start,
    and each tool that measured the body disagreed with the next.

    The body had no inside. Welded by position it was eleven open pieces with 220
    boundary edges and zero enclosed volume: one shell with a 20-edge hole, and
    ten detached toes. A renderer does not care whether a toe is stitched to a
    foot; a solver that must decide what is inside does.
    """

    details_title "What was measured, and the two readings that were wrong"

    details_preamble ~S"""
    Every number below is from the same avatar, a figure 2.21 m tall. The point
    of recording them is that the first column was believed and acted on for
    some time.
    """

    details "The body, before and after", ~S"""
    |                     | as exported | welded | after this change |
    |---------------------|-------------|--------|-------------------|
    | vertices            | 9,660       | 8,387  | 8,736             |
    | boundary edges      | 2,736       | 220    | 0                 |
    | non-manifold edges  | 0           | 0      | 0                 |
    | connected pieces    | 40          | 11     | 1                 |
    | genus               | n/a         | n/a    | 0                 |
    | self-intersections  | n/a         | 576    | 0                 |
    | volume, cubic metres| 0           | 0      | 0.120876          |

    0.120876 cubic metres is about 121 litres, roughly two and a half bathroom
    basins.
    """

    details "Weld before counting anything", ~S"""
    The engine's render mesh splits vertices at UV, normal and material seams, so
    one surface arrives index-disconnected. Unwelded the body reads as 40 pieces
    with 2,736 boundary edges, and that reading is an exporter artifact.

    The same trap fired twice. The garment appeared to carry 5,706
    self-intersections; welded it has none at all, and every one of those 5,706
    was a pair of adjacent triangles that shared a position but not an index.

    Both wrong readings were confident, stable and repeatable. Welding is the
    first call in any measurement, not a cleanup step.
    """

    details "Union the pieces; do not self-union the soup", ~S"""
    Capping the ten toes individually leaves 576 self-intersections, because each
    toe overlaps the foot it belongs to and its new cap cuts through the foot
    surface.

    A boolean union of the whole shape against itself also reports success and is
    wrong: its output carries 602 non-manifold edges once welded, because the
    pieces are left touching rather than fused. Unioning eleven well-formed
    solids is the operation the library is built for, and the difference shows as
    a result that survives a second weld unchanged.

    A tool reporting NoError is not the same as a correct result. Both paths
    report it.
    """

    details "The boundary walk pivots through the triangle fan", ~S"""
    Two holes meeting at a single vertex share one boundary curve, and that curve
    visits the meeting vertex twice. A walk that takes any unused edge at a
    vertex splices them into one loop, and a fan then spans both holes with one
    patch: zero holes reported, a non-manifold edge left behind.

    The walk pivots through the triangle fan instead and splits a walk that
    revisits a vertex. This is pure combinatorics on the triangle table, so it
    needs no normals and no orientation guess, which matters because the normals
    on a mesh in this state cannot be trusted.

    All 793 hole patterns on a cube now cap clean. Before, 178 did not.
    """

    details "What this unblocked", ~S"""
    The contact query in the cloth solver asks the body mesh directly by
    generalised winding number, which is exact on a closed surface and needs no
    convex approximation. That path is only available because the body is closed.

    A convex decomposition can now be checked rather than trusted. At 72 pieces
    the hulls call inside exactly the same 74 garment vertices the body does, at
    the same depths, and the build refuses a decomposition whose extent does not
    match the body it came from. An earlier decomposition sat in an output
    directory with no code that produced it, spanning half the body's height, and
    the simulation ran happily with the garment floating above it.
    """

    details "Retracted claims", ~S"""
    **"The body self-intersects at the head."** The solver named a triangle on
    the centreline at 72 percent height, and hidden mouth or eye interior
    geometry was the obvious reading. The real defect was openness.

    **"The body is 40 open patches."** That was the unwelded count.
    """

    related ~S"""
    RFD 2249 (cloth by vertex block descent, which depends on this), RFD 2247
    (property testing with falsification). Baerentzen and Aanaes, IEEE TVCG 2005,
    whose pseudonormal is exact only on a closed surface. Jacobson et al.,
    SIGGRAPH 2013. `character-fox/Tools/rig/mesh_cap.py`.
    """

    drafted_by :ai
  end
end
