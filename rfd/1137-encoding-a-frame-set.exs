# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1137. `mix rfd.render` in rfd_dsl/ renders rfd/1137-encoding-a-frame-set/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1137 do
  use RFD.DSL

  rfd 1137, "A frame set is delivered as one CineForm clip" do
    state :discussion

    feature "encoding a render sweep for review and delivery"

    scope "`7-service/service-cineform`, `1-transport/transport-cineform-tui`"

    attest_in :none

    decision ~S"""
    The pair that exists does the work: `transport-cineform-tui` sends the
    job, `interactor-cineform` encodes, and `service-cineform` owns the bus
    and the runtime directory, every link Apache-2.0 or MIT.
    
    `SKILL.md` gives the order, from a workspace with nothing built to a
    clip on disk, and the order a clip takes when it explains a corpus row.
    `domain.ex` and `problem.ex` make that order a taskweft plan whose goal
    is `delivered`, which only a verified clip and citation satisfy. Frames
    alone leave it false, and the planner names the step that did not run.
    
    Three choices are settled rather than left to taste. The frame rate is
    8 per second, so one second is one azimuth sweep and 60 would put all 96
    frames inside 1.6 seconds. The pixel format is RGBA_4444, because a
    render carries a matte. And both files take their name from the
    citation's title, which must name what varies.
    
    Measured here: 96 frames of 1024 by 1024, 402.7 MB of raw RGBA in, 23.4
    MiB out, 554 ms in the encoder, about 173 frames per second, which is a
    rounding error beside the render.
    """

    problem ~S"""
    A 96-pose sweep left 192 files in a directory. Nobody reviews 96 PNGs,
    and a directory carries no title, no licence and no statement of what
    made it. The deliverables rule asks for a video intermediate with a
    `.cff` beside it. The encoder for one was in the workspace and had never
    been built, and the first attempt reached for a tool that is LGPL.
    """

    related ~S"""
    RFD 1136 enumerates the poses that make such a sweep. See `DETAILS.md`
    for the measurements and what the clip does to a frame hash.
    """

    details_title "A frame set is delivered as one CineForm clip"

    details "Throughput", ~S"""
    Measured on this desk, 16-thread CPU, one job:
    
    | stage           | quantity                                    |
    | --------------- | ------------------------------------------- |
    | input           | 96 frames, 1024 by 1024, packed 8-bit RGBA  |
    | raw size        | 402.7 MB, which is 96 x 1024 x 1024 x 4     |
    | output          | 23.4 MiB, CineForm RGBA_4444, quality 3     |
    | ratio           | 16.8 to 1                                   |
    | encoder time    | 554 ms                                      |
    | rate            | about 173 frames per second                 |
    | playback        | 8 fps, so 12 seconds of clip                |
    
    The clip is 12 seconds and took 0.554 s to make, which is 21 times
    realtime. `interactor-cineform` publishes 112 fps at 1920 by 1080 for
    RGB; this is a smaller frame with an alpha channel, and the two figures
    sit either side of the pixel-count scaling as expected.
    
    Against the render the encode disappears. The same 96 frames took 32.3 s
    on the card and would take 2 h 5 min at llvm's 78 s a frame.
    """

    details "What the clip does to a frame hash", ~S"""
    Every render writes a sidecar carrying a sha256 of its PNG. CineForm is
    visually lossless and is not bit-exact, so a frame decoded from the clip
    will not reproduce that digest. Nothing is wrong with either, and the
    `.cff` says which artefact the hash names.
    
    Two ways to keep a check, and neither is chosen here:
    
    - Hash the container. One digest for the sweep, which answers "is this
      the clip we made" and not "is this frame the frame we rendered".
    - Keep the PNGs as the archival form and treat the clip as the viewing
      copy. Costs the storage the clip was meant to save.
    """

    details "The build, and what it cost to find", ~S"""
    Four traps, each of which produced a wrong answer rather than an error.
    
    `repo init` inside `3-interactor/interactor-cineform` re-pointed the
    WORKSPACE manifest at that project. It reports only "repo has been
    initialized in C:\weftspun-keypoint". Recovery: the manifests git keeps
    its history, `git -C .repo/manifests reflog` names the branch, and
    `repo init -u .../weftspun-keypoint -b <branch> -m default.xml` restores
    it. `repo list | wc -l` is the check.
    
    `up.py` under `nohup` builds the library and then starts the encoder as
    its own child, so both exit together. The next command then waits on a
    service that is not there and prints nothing at all.
    
    iceoryx2's Windows PAL prints `FindNextFileA ... there are no more
    files` and `RemoveDirectoryA ... the directory is not empty` during
    normal startup. They look like failures and are not.
    
    The composing manifest was incomplete. `service-cineform/default.xml`
    listed the two programs and the bus, but a manifest root's own list is
    not read when the project is one of ninety-four, so a workspace sync
    gave the programs and nothing they link. The root manifest now carries
    iceoryx2, cineform-sdk, libwebm and FTXUI under the service, and both
    builds take them through the cache paths the CMakeLists expose.
    """

    drafted_by :ai
  end
end
