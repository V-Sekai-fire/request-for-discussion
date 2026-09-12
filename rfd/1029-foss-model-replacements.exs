# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1029. `mix rfd.render` renders rfd/1029-foss-model-replacements/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1029 do
  use RFD.DSL

  rfd 1029, "FOSS model replacements" do
    state :published

    feature "model licensing"

    attest_in :none

    decision ~S"""
    Replace each deleted model with a permissive alternative. Prefer the
    MIT license and the BSD license.

    See `DETAILS.md` for the PartField, FastMesh, and PartPacker
    replacements, each with its candidates and its license.
    """

    problem ~S"""
    RFD 1028 removes three models from the catalog. Their tasks still
    need a model.
    """

    related ~S"""
    RFD 1028 records the license gate. RFD 1031 records the geometry
    refinement path and its alpha wrap problem.
    """

    details_title "FOSS model replacements"

    details "PartField replacement (mesh segmentation)", ~S"""
    The web search from August 2026 found three MIT candidates.

    - PartSAM (czvvd/PartSAM, ICLR 2026) segments parts on native 3D data.
      It supports a segment-every-part mode.
    - HoloPart (VAST-AI/Research) completes occluded parts.
    - OmniPart (HKU-MMLab, SIGGRAPH Asia 2025) does part-aware 3D
      generation.

    PartSAM is the primary recommendation. It trains on native 3D data, so
    it works on AI-generated meshes. PartField needs clean mesh
    connectivity, which generated meshes lack.
    """

    details "FastMesh replacement (retopology)", ~S"""
    The catalog already carries Instant Meshes under the BSD-3 license. It
    is the primary replacement. QuadriFlow, meshoptimizer,
    trimesh_decimate, and AutoRemesher are the MIT alternatives.

    The QuadWild Bi-MDF fork does not qualify. It uses the GPL-3 license.
    """

    details "Two of the candidates are already vendored", ~S"""
    Checked 2026-09-12. `entities-godot` on `feat/cassie` carries both PMP
    and Geogram under `thirdparty/`, so the decimation half of this
    replacement is checked out rather than sourced. Licenses were read
    from those copies, not from a package index.

    | library | license as vendored                                     |
    | ------- | ------------------------------------------------------- |
    | PMP     | MIT with employer disclaimer, (C) 2011-2020 PMP          |
    |         | developers and (C) 2001-2005 CG Group, RWTH Aachen       |
    | Geogram | BSD 3-Clause, (C) 2000-2022 Inria                        |

    Both clear RFD 1028's gate. PMP's variant is MIT text with an added
    employer disclaimer, so it is recorded as that and not as plain MIT.

    None of the candidates in this section carries blend shapes, and on an
    avatar that is the binding constraint rather than a detail.
    """

    details "The tri-to-quad step is ported, not adopted", ~S"""
    The Optimized-Tris-to-Quads-Converter is a Blender add-on, and Blender
    is blocklisted with no exemption. Its algorithm needs no host: an
    interior edge shared by exactly two triangles is a candidate to
    dissolve, each triangle may be dissolved at most once, and the goal is
    to dissolve as many as possible, which is a matching on the dual
    graph. It now lives in `character-fox/Tools/rig/tris_to_quads.py`,
    with the PuLP formulation carried across unchanged and an exact
    matching solver beside it as a cross-check.

    The add-on delegated the dissolve to its host, and that is the part
    with teeth. Pairs are refused before the solver sees them when the two
    triangles disagree on facing, fold past 40 degrees, would merge into a
    concave quad, or would leave a sliver corner. A bent or concave quad
    is triangulated back along the other diagonal, so the silhouette moves
    and nothing reports it.

    `jp.lilxyzw.ndmfmeshsimplifier` is blocklisted separately. It is a
    capable quadric decimator that preserves shapes, but it runs at build
    time, so the mesh that ships is not the mesh in the scene.
    """

    details "What the blend shapes on this avatar actually look like", ~S"""
    Measured 2026-09-12 on Miroir-Re: 647 shapes across ten meshes. Two
    structural facts make this the easiest possible transfer case. Every
    shape is single-frame, so there are no in-betweens to interpolate, and
    not one carries normal or tangent deltas, so only positions move.

    Individual shapes are tightly localised. Body's 448 shapes move a
    median 5.10% of its vertices; BaseBody's 31 move 2.06%; the debug
    mesh's 113 move 0.91%, which on 440 vertices is four vertices. Ear and
    Tail are the exception at 100%, being whole-mesh squashes.

    The strategy that suggests -- protect the vertices a shape touches,
    decimate the rest -- does not survive the union:

    | mesh        | verts | shapes | moved by ANY shape | free  |
    | ----------- | ----- | ------ | ------------------ | ----- |
    | BaseBody    |  9660 |     31 |              99.8% |  0.2% |
    | Body        |  7065 |    448 |              92.9% |  7.1% |
    | Ear         |  1536 |      6 |             100.0% |  0.0% |
    | Hairband    |   931 |      8 |             100.0% |  0.0% |
    | Tail        |  1902 |      8 |              98.4% |  1.6% |
    | Hair        |  7737 |     27 |              54.4% | 45.6% |
    | Dress_frill |  2755 |      1 |              11.9% | 88.1% |
    | Cardigan    |  5793 |      1 |               2.2% | 97.8% |

    Four hundred shapes at five percent each, spread over the mesh, cover
    it. Protecting the shaped vertices means protecting everything.
    """

    details "The conclusion is to avoid the transfer, not to write it", ~S"""
    Cardigan and Dress_frill carry one shape each and are 97.8% and 88.1%
    untouched, which makes them decimatable as if they were shape-free.
    Adding them to the seven genuinely shape-free meshes gives 31,834
    triangles to work with against a deficit of 8,154 -- a 25.6%
    reduction, where the shape-free meshes alone needed 47.2%. Hair adds
    another 8,944 at 45.6% free if that is not enough.

    So the meshes whose shapes cover them can be left alone. Those are the
    face tracking meshes, where a shape moving four vertices is exactly
    what decimation removes first.

    If a transfer is ever needed, the trap is recorded here. A shape that
    moves four vertices is invisible in any rest-pose comparison, because
    at weight zero the mesh is correct. Verification has to evaluate each
    shape at weight one and compare the deformed surfaces, one shape at a
    time, or a destroyed expression ships looking fine.
    """

    details "PartPacker replacement (image to raw mesh)", ~S"""
    The catalog already carries TRELLIS.2 and TRELLIS. Both use the MIT
    license. Prefer them over PartPacker.
    """

    drafted_by :ai
  end
end
