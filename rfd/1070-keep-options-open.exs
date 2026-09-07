# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1070. `mix rfd.render` renders rfd/1070-keep-options-open/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1070 do
  use RFD.DSL

  rfd 1070, "Keep options open" do
    state :published

    scope "`decisions/`"

    attest_in :none

    decision ~S"""
    Do not open an RFD for a build this project has not committed to.

    Kent Beck's price-theory reading of YAGNI names the cost: an
    unexercised option costs twice if the guess is wrong, so a thing not
    yet committed to is worth more left unbuilt. Waiting holds an asset.
    It does not delay work.

    The rule stops a new RFD from opening before commitment. It does not
    reach back into one already running.

    See `DETAILS.md` for the three RFDs this rule removed, what made each
    speculative, and what the rule left in place.
    """

    problem ~S"""
    This repository wrote down three RFDs for a build nobody started.
    Each carried a reading cost, a cross-reference to keep current, and
    an index row, for an option nobody had exercised.
    """

    references ~S"""
    - Kent Beck, "The Cost YAGNI Was Never About":
      https://newsletter.kentbeck.com/p/the-cost-yagni-was-never-about
    """

    related ~S"""
    RFD 1000 gives the state ladder a speculative RFD would otherwise
    sit on. RFD 1031 keeps the fallback RFD 1032 would have replaced.
    """

    details_title "Keep options open"

    details "What each one was", ~S"""
    RFD 1024 picked nx-ggml, and RFD 1019 replaced it, yet RFD 1024
    stayed in the index as a live decision. RFD 1032 sketched a
    clean-room alpha wrap algorithm RFD 1031's fallback already made
    unneeded. RFD 1068 picked a training approach for a model that needs
    data RFD 1064 has not finished producing.
    """

    details "What the rule left in place", ~S"""
    This session deleted RFD 1024, RFD 1032, and RFD 1068 under this
    rule. RFD 1031 keeps its existing fallback, with no successor RFD
    promised.

    Committed work already under way, such as RFD 1064 and RFD 1065, is
    not this rule's target.
    """

    details "The register of deleted numbers", ~S"""
    A later session deleted RFD 1069, RFD 1071, and RFD 1072 under this
    rule. RFD 1064 records the bar each one failed.

    A deleted number is not reused, and the RFDs above still cite it.
    Deleting a directory does not delete a citation. `SERIALS.usda` keeps a
    row for each of the six, and RFD 1124's gate reads that file when it
    checks that a citation resolves. RFD 1000 gives the register's rule.
    """

    drafted_by :ai
  end
end
