# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1064. `mix rfd.render` renders rfd/1064-character-concept-generator/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1064 do
  use RFD.DSL

  rfd 1064, "Character Concept Generator" do
    state :prediscussion

    scope "To be determined"

    attest_in :none

    decision ~S"""
    Encode useful combinations of character concepts into taskweft, and
    run it on Fly.io with Nx, with no GPU acceleration.

    1. Claude inspects each dataset row by vision, and writes the
       character as a taskweft `problem.ex`. One shared `domain.ex`
       holds the actions and guards, per RFD 1037. This is the Gall's
       law step.
    2. Postpone RFD 1042 (Krea 2 Turbo) for image generation.
    3. Postpone RFD 1043 (Qwen image edit) to match a T-pose character
       pose.
    4. Postpone RFD 1044 (See-Through layer decomposition) to remove
       eyes, eyebrows, irises, and eye whites from the face.
    5. Postpone RFD 1040 (Pixal3D) to generate a mesh.
    6. Postpone RFD 1046 (SkinTokens) to auto-rig the mesh.
    7. Postpone Godot Engine 4.7's humanoid skeleton silhouette
       retargeting.
    8. Postpone research into RFD 1045 (Kimodo) to generate a body, if
       clothing, accessories, and objects need separation from the
       Soma-X body.
    """

    problem ~S"""
    Gall's law asks for the smallest working piece of character
    authoring, with appearance traits, animation, and export to an
    OpenUSD intermediate format.
    """

    related ~S"""
    RFD 1037 gives the domain/problem split. RFD 1065 gives the schema
    this step's `domain.ex` and `problem.ex` files follow. RFD 1042, RFD
    1043, RFD 1044, RFD 1040, RFD 1045, and RFD 1046 give the postponed
    stages. `DETAILS.md` holds the reference links and the critical-path
    diagram.
    """

    details_title "Character Concept Generator"

    details "The critical path", ~S"""
    Step 1 is the only active step. Everything below it runs today.
    Everything to its side does not run yet.

    ```
    RFD 1064 (root, step 1 active)
     |- RFD 1037  (domain/problem split, step 1 uses this)
     |- RFD 1065  (ETNF schema, step 1's problem.ex follows this)
     |   `- RFD 1021  (HRR library, RFD 1065's resolve step runs on this)
     `- RFD 1000  (conventions, universal)
    ```

    Steps 2 through 8 postpone RFD 1042, RFD 1043, RFD 1044, RFD 1040,
    RFD 1046, and RFD 1045. Each is sequenced future work, already
    justified by its own step, and not a candidate for deletion under
    RFD 1070's rule. A postponed step waits on order. It does not wait
    on a guess.

    A new RFD earns a place on the critical path only when a step above
    names it. RFD 1069, RFD 1071, and RFD 1072 did not clear that bar.
    RFD 1070 records the rule they failed.
    """

    details "Reference links", ~S"""
    - https://github.com/V-Sekai-fire/interactor-taskweft
    - https://github.com/0b5vr/khr-character-testbed/blob/main/README.md
    - https://github.com/Kjakubzak/glTF/tree/kjakubzak/avatar_ext/extensions/2.0/Khronos/KHR_character
    - https://huggingface.co/datasets/alfredplpl/anime-with-caption-cc0
    """

    drafted_by :ai
  end
end
