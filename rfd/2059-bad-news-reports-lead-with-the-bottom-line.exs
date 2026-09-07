# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2059. `mix rfd.render` in rfd_dsl/ renders rfd/2059-bad-news-reports-lead-with-the-bottom-line/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2059 do
  use RFD.DSL

  rfd 2059, "Bad news reports lead with the bottom line" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    A status report carries an outcome the reader acts on: a slipped date,
    a broken build, a failed smoke. A report that opens with progress and
    buffers the outcome to the end makes the reader scan for the catch
    before the report says anything they can use. How does a report in
    this project phrase an outcome the reader needs first?
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "Bad news reports lead with the bottom line"

    details "Context and problem statement", ~S"""
    A status report carries an outcome the reader acts on: a slipped date,
    a broken build, a failed smoke. A report that opens with progress and
    buffers the outcome to the end makes the reader scan for the catch
    before the report says anything they can use. How does a report in
    this project phrase an outcome the reader needs first?
    """

    details "Decision drivers", ~S"""
    - A reader who learns the outcome in the first sentence starts
      deciding on it immediately, rather than after a paragraph of
      buildup.
    - An executive or on-call reader scans the opening line and stops; the
      rest is there for whoever needs the why.
    - The rule stays mechanical enough to apply in review without debate.
    - Urgency, a down service, a failed gate, leaves no room for a
      warm-up.
    """

    details "Considered options", ~S"""
    - Indirect approach: open with a progress buffer, then state the
      outcome.
    - Direct approach (bottom line up front): state the outcome first,
      then the explanation, then the next step.
    """

    details "Decision outcome", ~S"""
    Chosen option: "the direct approach", because the reader holds the
    outcome before the explanation, so the explanation reads as context
    rather than as suspense, and a reader who needs only the outcome stops
    after one line.
    
    A status report carries three parts in order:
    
    1. The bottom line comes first. The opening sentence states the
       outcome plainly, the slip, the failure, the result, with no
       buffer, no apology, and no warm-up. A reader who reads only this
       line knows where the work stands.
    2. The explanation follows. It gives the factual reason for the
       outcome; the reader already holds the result, so the explanation
       carries the why without holding it back.
    3. The next step closes the report: the fix underway, the alternative
       open to the reader, or the time of the next update.
    
    The voice rules out two habits:
    
    - A progress buffer that opens on what went well and defers the
      outcome to the end.
    - An apology or hedge in place of the outcome in the first sentence.
    
    A good outcome takes the same shape: the first sentence states the
    result, and the rest carries the why and the next step.
    """

    details "Consequences", ~S"""
    - Good, because the reader decides on the outcome from the first line
      instead of scanning for it.
    - Good, because one shape covers a slip, a failed gate, and a shipped
      result alike.
    - Good, because an urgent report, a down service, a recall, leads
      with the fact that drives the response.
    - Bad, because the opening reads blunt, and an author used to a buffer
      needs practice to drop it.
    """

    details "Confirmation", ~S"""
    Review checks that a status report opens on its outcome, with the
    explanation and the next step after it, and no progress buffer or
    apology ahead of the bottom line.
    """

    details "More information", ~S"""
    This applies the BLUF (bottom line up front) convention to status
    reports, and sits alongside the tenseless continuous-present voice
    (`rfd/2025-tenseless-continuous-present-voice`) for prose across the
    repo.
    """

    drafted_by :ai
  end
end
