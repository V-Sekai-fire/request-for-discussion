# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1063. `mix rfd.render` in rfd_dsl/ renders rfd/1063-ste-enforcement-moves-to-the-plugin/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1063 do
  use RFD.DSL

  rfd 1063, "STE enforcement moves to the plugin" do
    state :discussion

    scope "`decisions/`, `scripts/ci.sh`, `.pre-commit-config.yaml`"

    attest_in :none

    decision ~S"""
    Delete `scripts/ste-lint-decisions.py`. Delete its `npm run lint:ste`
    entry in `thirdparty/3d_studio/package.json`. Delete its step in
    `scripts/ci.sh`, and its hook in `.pre-commit-config.yaml`. STE
    enforcement now runs once, in the plugin's `Stop` hook, at write
    time.

    See `DETAILS.md` for what moved to the plugin, including three new
    checks this repository contributed upstream. It also names what the
    deleted script's aggregate score this repository does not gain back.
    """

    problem ~S"""
    RFD 1000 named `scripts/ste-lint-decisions.py` as this repository's
    STE linter. It scored each RFD's prose at violations per 100 words.
    It ran in CI, through `npm run lint:ste`. It ran again in
    `.pre-commit-config.yaml`'s `ste-lint` hook. Three places ran the
    same check on the same files.

    `fire/claude-ste-plugin` is a Claude Code plugin. It checks at a
    better point in the process. It lints the reply before the reply
    reaches a file, and it asks for a rewrite. The old script
    caught a violation only after a commit already held it. Two
    enforcement points for one rule is the DRY policy's own complaint,
    turned on this repository's own tooling.
    """

    related ~S"""
    RFD 1000 named the deleted script. RFD 1059 wired `npm run lint:ste`
    into `scripts/ci.sh`. This RFD removes that step, and nothing
    replaces it. `fire/claude-ste-plugin#1` is the PR that carries this
    repository's contribution upstream.
    """

    details_title "STE enforcement moves to the plugin"

    details "What moved where", ~S"""
    Several checks the deleted script hand-wrote already existed in the
    plugin, and more precisely. The plugin cites an ASD-STE100 Part 1
    rule number for each one. Its sentence splitter and word counter
    follow CommonMark structure, not a line-based heuristic.

    Three checks were new. Each one went upstream instead of staying
    local, in `fire/claude-ste-plugin#1`:

    - `style.bloat`, for an inflated word such as "utilize"
    - `style.marketing`, for a marketing word such as "seamless"
    - `style.dash`, for an em dash that joins two clauses

    This repository's own `decisions/` tree is the prose the PR tested
    them against. The plugin checks all three now, in every project it
    installs into, not only this one.
    """

    details "What this repository does not gain back", ~S"""
    The deleted script scored a whole document, at violations per 100
    words. It also read many files at once and printed one pass or fail
    line per file. The plugin has no equivalent to either. It reports one
    finding per line, for one file at a time, and it does not score a
    document as a whole. A CI run that wants one pass/fail number across
    every RFD does not have that number anymore.

    This RFD accepts that loss. `decisions/README.md`'s STE policy never
    asked for a score. It asked for STE prose. The `Stop` hook catches a
    violation earlier than a CI gate can, on every reply that touches
    this repository, not only on a push.
    """

    drafted_by :ai
  end
end
