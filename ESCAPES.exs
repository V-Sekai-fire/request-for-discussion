# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# Defects that got past a check. One row per escape, naming what the check
# reported and what was true. When something gets past a gate, add a row; the
# suite in test/escapes_test.exs gains a control and that class cannot recur
# silently. This file only grows.

defmodule Escapes.Weftspun do
  use RFD.Escapes

  escapes "Weftspun" do
    escape "2026-09-10 godot build check",
      guard: :run_checked,
      reported: "build failed",
      actual: "the build was clean; $PIPESTATUS is $pipestatus in zsh, so the code came from nothing"

    escape "2026-09-10 cherry-pick onto the assembly branch",
      guard: :run_checked,
      reported: "RESULT: clean",
      actual: "it conflicted; `if git cherry-pick | tail` tested tail's exit, not git's"

    escape "2026-09-10 three redirect-fix pushes",
      guard: :run_checked,
      reported: "pushed, three times",
      actual: "one 403'd against an archived repo; the loop echoed a fixed string"

    escape "2026-09-10 CI watcher",
      guard: :require_nonempty,
      reported: "ALL SETTLED",
      actual: "zero checks were returned because the installation token had expired"

    escape "2026-09-10 token renewal control",
      guard: :require_nonempty,
      reported: "behaved: minted a new token",
      actual: "the token was empty; only string inequality was tested"

    escape "2026-09-10 egit merge_base survey",
      guard: :require_file,
      reported: "merge_base is absent from egit",
      actual: "the module is git.erl, not egit.erl; merge_base is exposed via rev_parse"

    escape "2026-09-10 SERIALS lookup for a retracted RFD",
      guard: :require_corpus,
      reported: "no register names this serial",
      actual: "2235 is in SERIALS-vsekai-fabric.exs; only SERIALS.exs was searched"

    escape "2026-09-10 ar response-file control",
      guard: :require_engaged,
      reported: "behaved: response file engaged",
      actual: "400 objects made a 30 KB command against a 32768-byte threshold, so it never fired"

    escape "2026-09-10 git-assembler comment controls",
      guard: :require_precondition,
      reported: "all arms agree",
      actual: "it ran outside a git repository and exited before reading the config"

    escape "2026-09-10 godot-cpp ARG_MAX fix",
      guard: :expect_fail,
      reported: "scu_build=yes fixes the archive step",
      actual: "godot-cpp has no such variable; SCons warned and ignored it"

    escape "2026-09-10 commit message for this very corpus",
      guard: :require_literal,
      reported: "commit succeeded",
      actual: "backticks in a double-quoted -m were evaluated and a sentence vanished"

    escape "2026-09-10 audio BusType branch comparison",
      guard: :run_checked,
      reported: "the branch has none of this, so the assembly introduced it",
      actual: "zsh read $b:editor as the :e history modifier, git show failed, and grep -c counted 0 on empty input"
  end
end
