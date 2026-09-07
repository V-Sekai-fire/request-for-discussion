# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1147. `mix rfd.render` renders rfd/1147-what-editscore-costs-and-returns/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1147 do
  use RFD.DSL

  rfd 1147, "What EditScore costs and returns" do
    state :published

    flight_level :l1

    feature "the scorer shared by all four loops"

    scope "`fourloops-plan.usda`"

    attest_in :none

    decision ~S"""
    Give the scorer its own RFD, and let the loops cite it.

    `DETAILS.md` holds what it costs and what it returns: peak memory at
    512 and at 1024 square, the overall score for an instruction the edit
    matched, and the two-axis spread behind that overall. Both
    `fourloops-plan.usda` and `fourloops-etnf.usda` name it as a source, so
    a quantity in either layer resolves against the scorer's own document.

    **Its negative control is what makes the number a measurement.** A
    nonsense instruction returns 0.0 overall. A scorer that returns a
    middling figure for nonsense has not discriminated, and its score for a
    real edit would mean nothing.

    `logbook-fourloops-first-runs.md` keeps the apparatus, and this RFD
    keeps the result. The entry says how the runs were made, which is what
    lets somebody make them again.
    """

    problem ~S"""
    EditScore is the `score` stage of every loop in `fourloops-plan.usda`.
    Loops 1 through 4 each name it, and loop 1 pairs it with the Referee.

    Its measurements were written into RFD 1144 because loop 2 is the
    smallest loop that exercises it. That put a figure belonging to four
    loops inside the document for one of them, so a reader of loop 3 had to
    know to look in loop 2 for what the scorer costs.
    """

    related ~S"""
    RFD 1143 through RFD 1146 are the four loops that score with it. RFD
    1122 is the goal they serve.
    """

    details_title "What EditScore costs and returns"

    details_preamble ~S"""
    Measured on the desk described in `logbook-fourloops-first-runs.md`, which holds
    the apparatus these figures come from. The entry says how the runs were made and
    this file says what they returned; re-running them needs the entry.
    """

    details "What it returns when the instruction matched", ~S"""
    | scale max | consistency | a second axis | overall |
    | --------: | ----------: | ------------: | ------: |
    |      10.0 |         9.2 |           2.0 |    4.29 |

    The overall figure is 4.29 out of 10.0, and the spread behind it is the reason
    to carry both. Consistency scored 9.2 while the second axis scored 2.0, so a
    scorer reporting only the overall would say "middling" about a result that is
    excellent on one axis and poor on another. Which axis failed is the actionable
    half, and the overall alone discards it.

    **The negative control.** A nonsense instruction returns 0.0 overall. That is
    what makes 4.29 a measurement rather than an impression: a scorer that cannot
    return 0.0 for nonsense is not discriminating, and every score it gives is
    consistent with it having read nothing. `editscoreNonsenseOverall = 0.0` in
    `fourloops-plan.usda` carries that control beside the quantity it validates.
    """

    details "What it costs", ~S"""
    | configuration  | peak       | seconds  |
    | -------------- | ---------- | -------- |
    | NF4, 512 x 512 | 6.7506 GiB | 28 to 36 |
    | NF4, 1024 x 1024 | 8.6 GiB  |          |

    6.7506 GiB is measured; the plan rounds it to 6.75 in `editscorePeakGib512`, and
    carries 8.6 as `editscorePeakGib1024`.

    The seconds are a range rather than a median, and deliberately. The run-to-run
    spread at 512 is wider than the gap between the two OmniGen2 precisions RFD 1144
    reports, so a single figure would imply a resolution these runs do not support.
    """

    details "Why this lives in its own document", ~S"""
    Every loop in `fourloops-plan.usda` names EditScore as its `score` stage, and
    loop 1 pairs it with the Referee because an image scorer and a body scorer
    answer different questions. A figure that four loops depend on belongs beside
    none of them in particular.

    It was in RFD 1144 first, on the reasoning that loop 2 is the smallest loop
    exercising the scorer and so its numbers were the plan's. That reasoning holds
    for OmniGen2, which loops 2 and 3 use and loops 1 and 4 do not. It does not hold
    for a stage all four share.
    """

    drafted_by :ai
  end
end
