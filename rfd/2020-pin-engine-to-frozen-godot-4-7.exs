# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2020. `mix rfd.render` in rfd_dsl/ renders rfd/2020-pin-engine-to-frozen-godot-4-7/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2020 do
  use RFD.DSL

  rfd 2020, "Pin engine to frozen godot 4 7" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The engine fork carries many feature branches (cassie, resonance
    audio, native media, speech, spatial audio, the fabric modules) that
    the `merge` recipe assembles onto a base. If that base tracks a moving
    upstream, every assembly can shift under the patches, so a green build
    one day can break the next from upstream churn alone. What base should
    the feature branches and the assembly build on?
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Pin engine to frozen godot 4 7"

    details "Context and problem statement", ~S"""
    The engine fork carries many feature branches (cassie, resonance
    audio, native media, speech, spatial audio, the fabric modules) that
    the `merge` recipe assembles onto a base. If that base tracks a moving
    upstream, every assembly can shift under the patches, so a green build
    one day can break the next from upstream churn alone. What base should
    the feature branches and the assembly build on?
    """

    details "Decision drivers", ~S"""
    - A stable base so assembly and CI are reproducible.
    - Patch branches that do not have to chase upstream API changes
      mid-cycle.
    - A known engine version for the docs and for downstream images.
    """

    details "Considered options", ~S"""
    - Track upstream `godotengine/godot` `master`.
    - Track an upstream release branch.
    - Pin the fork's `master` to one frozen upstream Godot 4.7 commit.
    """

    details "Decision outcome", ~S"""
    Chosen option: pin the fork's `master` to one frozen upstream Godot
    4.7 commit, because it gives the patch branches and the assembly a
    fixed target, so builds are reproducible and upstream churn cannot
    break an assembly.

    - The fork's `master` is the frozen base. Its tip is `8a337510` (Godot
      `4.7.0-beta`, per `version.py`).
    - Every feature branch in the `merge` `gitassembly` recipe stands
      alone on `master`; the recipe merges them onto the assembled branch
      from that base.
    - The pin moves only by a deliberate update to `master`, not by
      following upstream.
    """

    details "Consequences", ~S"""
    - Good: assemblies and CI are reproducible against a fixed engine.
    - Good: feature branches target one fixed engine API.
    - Bad: upstream fixes after the pin are not picked up until `master`
      is advanced on purpose.
    - Bad: the longer the pin sits on a beta, the larger the eventual
      catch-up to a later 4.7.
    """

    details "Confirmation", ~S"""
    `version.py` on the fork reports `4.7.0-beta`, and the `gitassembly`
    recipe bases its branches on `master`. Advancing the engine is a
    single, reviewable change to the `master` pin.
    """

    details "More information", ~S"""
    This pin is why the spatial audio decision notes the module targets a
    fixed engine API. The exact upstream commit that `master` mirrors
    lives in the godot fork's git history.
    """

    drafted_by :ai
  end
end
