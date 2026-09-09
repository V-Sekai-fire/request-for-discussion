# Logbook: the gates were already there, nothing ran them

Apparatus: `scripts/gate.exs`, `prek 0.5.2`, the goal manifest's 135 projects, and
GitHub run 34350300438 on `v-sekai-fabric/entities-godot`. Measured 2026-09-09.

## The cycle that paid for this

A push to the `entities-godot` assembly took **77.8 minutes** to come back and report
that one word was misspelled and thirteen files were not clang-formatted. Static checks
failed, so all seven platform build jobs were skipped, and the question the push was
asked to answer went unanswered.

The same two hooks, run on this desk against the same committed config:

    clang-format over 377 changed files (thirdparty excluded)     8 s
    codespell over the same changed set                           0 s
    the whole prek hook set for the assembly, via gate.exs        49 s

77.8 minutes against 49 seconds is a factor of about 95, and against the two hooks alone
about 580. Nothing on the slow path was necessary. prek was already installed here, the
`.pre-commit-config.yaml` was already committed, and the hook revisions were already
pinned to what CI resolves.

## What was actually missing

Not a gate. Measured across the 135 projects the manifest places:

    projects with a .pre-commit-config.yaml                        46
    projects with GitHub workflows                                 83
    projects with both                                             46
    of those 46, with the prek hook installed                       0

The config is everywhere, the runner is on the desk, and nothing invoked it. So the part
was there twice over and had no caller. Under RFD 2229 that makes this a caller rather
than a part: `gate.exs` adds no check, and dispatches to prek where a project declares a
`.pre-commit-config.yaml` and to the pixi `gate` environment where one is declared.

## Four things this ran into, each a trap worth naming

**`repo forall` visits zero projects here.** `repo forall -c 'echo x'` prints nothing and
exits 0. A sweep built on it reports "all clean" over an empty set, which is how a sweep
once reported 0 failing across 112 repositories while one of them was demonstrably red.
The cause is that `repo list -p` emits CRLF, so every `[ -d "$p" ]` test fails. The runner
parses `.repo/manifests/default.xml` instead, and its first control asserts the visited
count exceeds zero. Cross-checked: 135 from the parser, 135 from `repo list -p`.

**A `--files` list of thousands exceeds the Windows command line.** The spawn fails with
`:eacces` and "invalid port name", which names neither the length nor the limit. prek
takes `--from-ref`/`--to-ref` and computes the set itself.

**A range check cannot see uncommitted work, and this gate was decoration until its own
control caught that.** Planting the two real defects into the working tree and running the
gate returned **exit 0**. `--from-ref/--to-ref` reads committed history, so a dirty tree
full of defects passes, which is the failure the negative-control rule exists for.
The dirty set now wins when there is one, and a fourth control exercises that dispatch
rather than the hook runner, because the defect was in the dispatch.

**A pipeline reports the last stage's status.** `prek ... | grep` returned 0 while prek
had exited 1, more than once during this work. The runner never pipes the gate.

## The controls, both directions

    ok  the enumerator visits more than zero projects
    ok  a planted always-failing hook is reported as a failure
    ok  a planted always-passing hook is reported as a pass
    ok  a defect that is only in the working tree is reported as a failure
    ok  a planted unresolved engine include is reported as a failure
    ok  a generated .gen.h include is not reported as unresolved

The second and third build a hermetic repository with one local hook that exits 1 or 0.
The fourth commits a passing state and then dirties the tree, so it fails if the range and
dirty-set dispatch is ever reverted. It was observed failing against the earlier dispatch,
so it discriminates rather than merely passing.

End to end on the real repository, the runner reports the two hooks CI reported, naming
the file and line:

    FAIL  3-interactor/entities-godot-sandbox  (prek)
          clang-format .......... Failed
          codespell ............. Failed
            modules/http3/web_transport_peer.cpp:428: honoured ==> honored

## The detection floor, stated because it exceeds zero

The runner runs the hooks a project declares. A CI job doing something outside those hooks
is not reproduced, so green here is necessary for a green CI and not sufficient. It does
not compile: no desk reproduces seven platforms. And 37 projects carry workflows while
declaring no local gate; they are named and counted rather than skipped in silence.

## A finding on the way, worth more than it looks

Five of the nine failures `check_anti_entropy.py` reported were not drift. The aggregate
reaches for the default interpreter while `markdown-it-py`, `usd-core` and `jsonschema`
are declared under the pixi `gate` feature. Run as `pixi run -e gate`, the count goes 9 to
5 and `check-rfd-structure`, `check_pen_66606` and `check_usd_valid` all pass.
`pixi.lock` had also drifted behind `pixi.toml`, with `jsonschema` declared and absent
from the solve.

## The rung this entry exists for

`gate.exs` first carried its argument as a 44-line header and measured 18.1% comments
against the 10% rung a new file enters at. The agreements say the reasoning moves rather
than disappears, so it moved here and the file now measures 7.5%.

## The second mechanism: the relocation class

Where upstream moves a header rather than editing it, git reports the merge clean and the
break appears only at compile time. It bit this fork four times in one session:
`audio_stream_generator.h` and `audio_stream.h` moved to `scene/resources/audio/`, and the
speaker-mode and bus-type names moved from `AudioServer` to `AudioServerEnums`. Each cost
a CI round trip to discover.

The mechanism checks that every engine-rooted `#include "..."` in a changed source resolves
to a file. Measured on the assembly:

    377 changed sources, engine-rooted includes             0 unresolved, no false alarm
    the same tree with the real defect restored             1 unresolved, named with its file
    full gate, prek and includes together                   12.9 s

Its floor is stated rather than implied. Generated `.gen.h` headers do not exist until
SCons writes them, and a module-relative include resolves through a CPPPATH this check
cannot see, so both are excluded and only engine-rooted, non-generated includes are read.
The sixth control asserts the generated case is *not* flagged, because a check that fires
on every `.gen.h` is noise, and a noisy gate is switched off rather than fixed.

## The cycle that is actually being measured

The operator narrowed the question twice, ending at: the cycle that matters is the
operator's, not the machine's. The machine loops were then measured and are not the
bottleneck. Elixir recompiles in 1.0 s and runs 21 tests in 2.1 s; a no-op `lake build`
takes 1.3 s warm against 55 s cold after a sync; a compiler invocation costs 77 ms, of
which 66 ms is process startup, so 86 per cent of it is not work.

What the operator pays is round trips. Of 14 operator turns in the session, six carried
new direction and five were spent putting the work back on track: one question asked
three times after it had been answered, one correction of a result reported clean that
was not, and two corrections of what was being studied. Counted by the agent that caused
the corrections, on one session, so it bounds an order of magnitude and is not a rate.

Two CI round trips, 77.8 and 41.8 minutes, each bought exactly one defect class, and both
classes are now found on the desk in under thirteen seconds.
