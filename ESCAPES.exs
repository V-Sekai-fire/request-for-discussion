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

    escape "2026-09-10 git sync survey",
      guard: :expect_fail,
      reported: "34 projects out of sync with their remotes",
      actual: "ls-remote --exit-code piped into cut, so the pipeline's status was cut's; a branch absent from the remote read as a mismatch, and manifest-pinned projects were compared against a moving main"


    escape "2026-09-10 git sync swept only HEAD",
      guard: :require_corpus,
      reported: "nothing unpushed across 134 projects",
      actual: "git branch -r --contains HEAD asks about one branch; five projects held other local branches on no remote"

    escape "2026-09-10 repo forall cannot see the manifest",
      guard: :require_corpus,
      reported: "the workspace is synced",
      actual: ".repo/manifests is not a manifest project, so three consecutive sweeps never opened the tree whose default.xml was modified and uncommitted"

    escape "2026-09-10 some remote read as every remote",
      guard: :require_precondition,
      reported: "the branch is pushed",
      actual: "containment by any one remote was accepted; eight projects carry a second remote and the question of which remotes are expected was never asked"

    escape "2026-09-10 tags checked against the first remote",
      guard: :require_corpus,
      reported: "twenty release tags exist on no remote",
      actual: "git remote returns sorted names and List.first picked opentelemetry-godot, a source remote that was never going to carry the engine's tags"

    escape "2026-09-10 ignoring a remote hid an unpushed branch",
      guard: :expect_fail,
      reported: "clean, with the archived upstream excluded",
      actual: "excluding every remote left nothing to be missing from, so a branch on no remote at all reported clean; caught by a planted control before the gate shipped"


    escape "2026-09-10 push reported from a local rev-parse",
      guard: :run_checked,
      reported: "pushed 9993c1f",
      actual: "git push -q wrote nothing and the sha came from a local rev-parse in the next command; the remote branch stayed at 3247de6 until a later ls-remote caught it"

    escape "2026-09-10 sweep walked refs/heads only",
      guard: :require_corpus,
      reported: "the workspace is clean",
      actual: "a commit on a detached HEAD is held by no branch, and repo sync --detach leaves all 134 projects detached; found by planting the defect, not by reading the code"


    escape "2026-09-10 lora fits reported as never written",
      guard: :require_file,
      reported: "no per-view recovery file was written for the LoRA arm, so it is not in this dataset",
      actual: "it was written and then deleted with four images a week later; git show 4931850 has all six fits and the two that did not fit"

    escape "2026-09-10 python rewrote every line ending",
      guard: :expect_fail,
      reported: "a twenty-line correction",
      actual: "Path.read_text decodes CRLF as LF and write_text wrote LF, so the diff was 106 lines; --ignore-all-space would have hidden it and the raw stat is what showed it"

  end
end
