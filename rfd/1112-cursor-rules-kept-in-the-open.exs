# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1112. `mix rfd.render` in rfd_dsl/ renders rfd/1112-cursor-rules-kept-in-the-open/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1112 do
  use RFD.DSL

  rfd 1112, "The Cursor rules, kept in the open" do
    state :discussion

    scope "`rules/`"

    attest_in :none

    decision ~S"""
    A guard rule's design belongs in an RFD, not a raw `.mdc` file. Each
    guard rule converts, one at a time: write the RFD it names, then
    delete the `.mdc`, its content preserved, not duplicated. Once
    converted, `rules/` no longer holds it.

    A process rule stays. It names no product decision, so no RFD holds
    it, and this repository publishes its operating workflow anyway, by
    explicit choice, trading the usual DRY point-to-source rule for
    transparency. `weftspun-moat-protected.mdc` and
    `dgx-sync-reminder.mdc` stay too, unedited: RFD 1106 gives the
    public-safe summary of the first, and this file gives the working
    detail behind it, kept by the same transparency choice. See
    `DETAILS.md` for the current per-file table.
    """

    problem ~S"""
    `rules/` held 34 raw `.mdc` files, moved unfiltered from
    weftspun-3d-studio's own `.cursor/rules/` directory. No RFD covered
    the set. RFD 1000's DRY policy says an RFD points to its source and
    does not copy it. Each of these files was itself already a copy,
    kept in sync by hand with the file of the same name in the app
    repository. Twenty files remain, after the guard rules converted.

    One file, `weftspun-moat-protected.mdc`, restates RFD 1106 in a more
    raw form, and names revenue mechanisms RFD 1106 leaves out on
    purpose. A second file, `dgx-sync-reminder.mdc`, names a private
    machine's local IP address and file paths.
    """

    related ~S"""
    RFD 1000 names the DRY policy this RFD sets aside for a process
    rule, and restores once a guard rule converts. RFD 1106 gives the
    public-safe restatement of `weftspun-moat-protected.mdc`.
    """

    details_title "The Cursor rules, kept in the open"

    details_preamble ~S"""
    Three buckets. A **guard** rule blocks a regression in a feature an
    existing RFD already designs. A **process** rule runs the agent's
    own workflow and matches no RFD, since it names no product decision.
    A **restates** rule repeats a decision an RFD already states, in
    more raw or more dated words.

    All 16 guard rules are now converted. See "Converted and deleted"
    below for where each one went.
    """

    details "Converted and deleted", ~S"""
    Each row already went through: the RFD named now holds the design,
    and `rules/` no longer holds the file.

    | File                                                                                 | Converted into                                                                                                                                                                                                                                                                                                                                 |
    | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | `app-chrome-layout-protected.mdc`, `collapsed-rail-icons.mdc`, `sidebar-z-index.mdc` | RFD 1114 (new)                                                                                                                                                                                                                                                                                                                                 |
    | `image-preview-sizing-protected.mdc`                                                 | RFD 1113 (new)                                                                                                                                                                                                                                                                                                                                 |
    | `vrm-animation-protected.mdc`, `weftspun3d-vrm-animation-playback.mdc`               | RFD 1115 (new, merged; the two files were near-duplicates)                                                                                                                                                                                                                                                                                     |
    | `vrm-upload-protected.mdc`                                                           | RFD 1104 (already covered)                                                                                                                                                                                                                                                                                                                     |
    | `spark-msf-xr-url-separation.mdc`                                                    | RFD 1099's port table, RFD 1095's proxy step (already covered)                                                                                                                                                                                                                                                                                 |
    | `facekeeper-black-screen.mdc`                                                        | RFD 1082's DETAILS.md, a new section (extended, not new)                                                                                                                                                                                                                                                                                       |
    | `xr-strategy.mdc`                                                                    | its Face Bridge section into RFD 1082 and RFD 1096; its VR/AR and floor-anchor section into RFD 1010 and RFD 1108; its "Broader Character Studio WebXR Strategy" roadmap (the WebXR Face Tracking API, moeChat/AIRI, multi-user spectator) into nothing, on purpose, since RFD 1070 opens no RFD for a build this project has not committed to |
    | `tasks-panel-ui-protected.mdc`                                                       | RFD 1116 (new; RFD 1003 covers the job lifecycle, not this toolbar)                                                                                                                                                                                                                                                                            |
    | `krea2-text-to-3d-pipeline-protected.mdc`                                            | RFD 1117 (new; RFD 1042 covers model packaging, not this chain)                                                                                                                                                                                                                                                                                |
    | `lingbot-env-scan-orientation-protected.mdc`                                         | RFD 1107's DETAILS.md, a new section (extended, not new)                                                                                                                                                                                                                                                                                       |
    | `spatial-fabric-rp1-protected.mdc`                                                   | RFD 1100's DETAILS.md, a new closing note (extended, not new); RFD 1099 already covered the raw-`.msf` rule                                                                                                                                                                                                                                    |
    | `xr-floor-anchor-protected.mdc`                                                      | RFD 1107's DETAILS.md, a new section (extended, not new; RFD 1108 covers single-model floor placement, not the world-layer bounds computation this rule guarded)                                                                                                                                                                               |
    | `xr-avatar-view-locomotion-protected.mdc`                                            | RFD 1118 (new; RFD 1090 is the abandoned IWSDK lab, a different XR path)                                                                                                                                                                                                                                                                       |
    """

    details "Process rules", ~S"""
    No product decision to point at. Each one runs the agent's own
    workflow: `3daigc-character-studio-workflow.mdc` (redirect stub),
    `3daigc-weftspun3dstudio-workflow.mdc`, `agent-continuity-startup.mdc`
    (RFD 1110's own RepoResident harness), `agent-run-instructions.mdc`,
    `core.mdc`, `dgx-sync-reminder.mdc`, `graphify.mdc`, `lock-it-in.mdc`,
    `mcp-workspace.mdc`, `memory-bank.mdc`,
    `new-scripts-ops-cheatsheet.mdc`, `no-guess-use-data.mdc`,
    `pitch-deck-sync-protected.mdc`, `remember-this-retention.mdc`,
    `remote-log-first.mdc`, `security-local-only.mdc`,
    `solid-skills.mdc`, `surface-sync-reminder.mdc`,
    `terse-debug-ops.mdc`.
    """

    details "Restates", ~S"""
    `weftspun-moat-protected.mdc` restates RFD 1106. RFD 1106 states the
    open and proprietary split, in public words, with no revenue figure.
    This file states the same split for the agent's own use, and it
    names the revenue mechanisms behind each proprietary layer. This
    repository keeps both, by RFD 1112's own decision above.
    """

    drafted_by :ai
  end
end
