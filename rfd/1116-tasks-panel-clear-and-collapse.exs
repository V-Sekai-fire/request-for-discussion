# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1116. `mix rfd.render` in rfd_dsl/ renders rfd/1116-tasks-panel-clear-and-collapse/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1116 do
  use RFD.DSL

  rfd 1116, "Tasks panel, Clear unloads the model, done stays separate" do
    state :committed

    scope "Tasks panel toolbar, the completed-task list"

    attest_in :none

    decision ~S"""
    The completed-task list collapses through `expand-icon-button` and
    `task-completed-expand-btn`, the same pattern the Bone Structure
    panel uses. Clear calls `clearModel()` whenever `currentModel` is
    set, unloading the viewport, then calls `clearCompletedTasks()`,
    which removes only the completed rows from the list. Task history
    outside the completed rows survives a viewport Clear.

    `bash scripts/verify_tasks_panel_ui.sh` runs before a merge touching
    this toolbar.
    """

    problem ~S"""
    The Tasks panel carries two controls a rewrite kept conflating: a
    collapse toggle on the completed-task list, and a Clear action.
    Clear must unload the viewport model, matching the Worlds panel's
    own Clear. A rewrite twice narrowed Clear back down to clearing the
    task list alone, and once dropped the completed-list collapse
    control outright.
    """

    related ~S"""
    RFD 1003 gives the task lifecycle this panel displays. RFD 1112
    lists `tasks-panel-ui-protected.mdc`, the rule this RFD replaces.
    """

    drafted_by :ai
  end
end
