# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1008. `mix rfd.render` in rfd_dsl/ renders rfd/1008-appearance-trait-extraction-and-remix/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1008 do
  use RFD.DSL

  rfd 1008, "Appearance trait extraction and remix" do
    state :discussion

    feature "appearance traits"

    attest_in :none

    decision ~S"""
    Map See-Through layer names to appearance slots. The map uses the
    existing appearance vocabulary. Hair, eyes, and face map to Head.
    Torso and clothing map to Chest. Legs and shoes map to Legs.
    
    The layer_decomposition node stores the mapped slots. The Studio
    page shows the remix candidates. A future remix flow equips the
    layer artifacts into the avatar slots.
    """

    problem ~S"""
    The See-Through layers split an image into body parts. Each part
    maps to an appearance slot. The app should reuse the layers for
    trait remixing.
    """

    references ~S"""
    - Mapping: `src/library/appearanceClothing.js`
    - Trait authoring: `src/pages/AppearanceSimple.jsx`
    - Slots: `src/library/lootAssetsConfig.js`
    """

    related ~S"""
    RFD 1006 produces the layers. RFD 1005 defines the avatar slots.
    """

    drafted_by :ai
  end
end
