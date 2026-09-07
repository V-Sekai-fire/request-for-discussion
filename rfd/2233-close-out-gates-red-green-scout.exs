# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2233. `mix rfd.render` renders rfd/2233-close-out-gates-red-green-scout/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2233 do
  use RFD.DSL

  rfd 2233, "Close-out gates: red control, green, scout" do
    state :prediscussion

    feature "three gates every piece of work records at close-out"

    scope "logbook entries, all projects"

    attest_in :details

    decision ~S"""
    Work closes with three gates in the logbook, each with runnable
    apparatus. Backfilling any of them is permitted: the record is the
    requirement, not the timing.

    1. **Red control gate.** The exact command shown failing on the
       broken state. Verification rule 2 in the working agreements.
    2. **Green gate.** The same check shown passing on the fixed state.
       The probe must distinguish the two states it separates; an
       identity-blind probe (one that answers alike for both) does not
       qualify.
    3. **Scout gate.** The place left better than we arrived: an
       inventory of the session's side effects shown non-empty before
       cleanup and empty after, plus what was improved beyond the task.

    `DETAILS.md` carries the reference case with its measurements.
    """

    problem ~S"""
    A gate recorded only passing is decoration: it has never shown it
    can detect the broken state, and a pass without its command cannot
    be re-run. Sessions also shed side effects, stray processes, /tmp
    files, caches, credentials, that no gate inspects, and a defect can
    hide inside them. The first inventory run found a stale server
    holding a port behind a probe that reported the same identity for
    the broken and the fixed build.
    """

    details_title "Close-out gates: red control, green, scout"

    details_preamble ~S"""
    The gates were first run, and backfilled, on the account.chibifire.com
    DNS rollout. `logbook-taskweft-planned-dns-traces.md` holds the full
    record; this file keeps the shape each gate takes.
    """

    details "Red control gate", ~S"""
    One command, the broken state, the observed failure:

        # taskweft v0.5.3 release binary, on its own bundled example
        taskweft plan priv/plans/domains/blocks_world_dsl.ex
        taskweft: failed_to_load_domain
    """

    details "Green gate", ~S"""
    The same command on the fixed state:

        # taskweft v0.5.4, same file
        taskweft plan priv/plans/domains/blocks_world_dsl.ex
        [["a_unstack", "a"], ["a_putdown", "a"], ...]

    A green gate must tell the two states apart. The counterexample from
    the reference case: an MCP `initialize` probe reported the same
    serverInfo for v0.5.3 and v0.5.4, so it stayed green while a stale
    v0.5.3 process held the port and the v0.5.4 launch died on
    eaddrinuse into /dev/null. The qualifying probe plans a DSL domain
    over MCP, an operation only the fixed build performs.
    """

    details "Scout gate", ~S"""
    Inventory before, non-empty; the same inventory after, empty; and
    what improved beyond the task.

        # red side
        pgrep -fl "fly proxy"        →  18477 fly proxy 18300:8300
        ls /tmp/ff_cookies.sqlite    →  1.5 MB of session cookies in /tmp
        ls ~/Library/.../.burrito/   →  two stale payload directories

        # green side
        pgrep -fl "fly proxy"        →  (nothing)
        ls /tmp/ff_cookies.sqlite    →  (nothing)
        ls ~/Library/.../.burrito/   →  the current payload only

    Beyond the task: the planner defect was fixed upstream and released
    rather than worked around locally.
    """

    details "What stays out of an RFD", ~S"""
    Machine-local facts, ports, cache paths on one desk, credential
    store contents, tokens, belong to the desk that produced them, not
    to this record. The gate shapes above are the published part; the
    values flow through a logbook entry when they are measurements, and
    through nothing at all when they are secrets.
    """

    drafted_by :ai
  end
end
