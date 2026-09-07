# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2018. `mix rfd.render` renders rfd/2018-feature-classification-poc-baseline-stretch/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2018 do
  use RFD.DSL

  rfd 2018, "Feature classification poc baseline stretch" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    The capabilities table lists features with a free-text status
    ("working", "loses about 90%"). Free text does not say whether a
    feature is a throwaway experiment, a committed part of the product, or
    a nice-to-have. The team needs one shared vocabulary for how far along
    and how committed a feature is, so planning and the docs agree on what
    "done" means for each one.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Feature classification poc baseline stretch"

    details "Context and Problem Statement", ~S"""
    The capabilities table lists features with a free-text status ("working",
    "loses about 90%"). Free text does not say whether a feature is a
    throwaway experiment, a committed part of the product, or a
    nice-to-have. The team needs one shared vocabulary for how far along and
    how committed a feature is, so planning and the docs agree on what
    "done" means for each one.
    """

    details "Decision Drivers", ~S"""
    - One vocabulary shared between planning and the manuals.
    - A reader should know at a glance whether a feature is committed or
      exploratory.
    - Cheap to apply and to move as a feature matures.
    """

    details "Considered Options", ~S"""
    - Keep free-text status only.
    - A maturity ladder (alpha / beta / stable).
    - A three-tier commitment classification: proof of concept, baseline,
      stretch.
    """

    details "Consequences", ~S"""
    - Good: planning and docs share one word per feature for its commitment
      level.
    - Good: the tier is a small, reversible edit as features move.
    - Bad: a tier is a judgement call and can drift from reality if the
      table is not kept current.
    """

    details "Confirmation", ~S"""
    The capabilities table has a Tier column, and every row carries one of
    the three tiers. New capabilities are added with a tier.

    - consulted: lyuma
    """

    drafted_by :ai
  end
end
