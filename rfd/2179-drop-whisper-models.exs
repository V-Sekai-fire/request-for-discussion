# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2179. `mix rfd.render` renders rfd/2179-drop-whisper-models/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2179 do
  use RFD.DSL

  rfd 2179, "Drop all Whisper models from the ASR panel" do
    state :published

    feature "documentation retraction"

    scope "RFDs 2164, 2178, 1102, 1027; CITATION.cff;\n`emit_10track_panel.py`"

    decision ~S"""
    Drop all three Whisper models (whisper-large-v3, ipa-whisper-small, ipa-whisper-base) from the ASR panel; the panel drops from 12 tracks to 9, and Whisper is not replaced.
    """

    problem ~S"""
    RFD 2164 (Rung 1 corpus)'s 12-track panel carries whisper-large-v3, ipa-whisper-small, ipa-whisper-base. whisper-large-v3 dominates panel wall-time (several seconds each on MPS versus sub-second for Voxtral and Parakeet); the ipa-whisper variants share that latency, and the IPA slot is already served by Voxtral-IPA and Gemma-IPA. A 15-clip WER pass across the surviving text tracks (DETAILS.md) puts whisper-large-v3 at 0.339 mean, beating Parakeet (0.501) and wav2vec2 (0.571); Voxtral leads at 0.000. The reason to drop is latency, not accuracy.
    """

    section "Panel after the drop", ~S"""
      text-track    Parakeet TDT 0.6B v3, Voxtral Mini 3B, wav2vec2,
                    Gemma-4-12B auto
      IPA-track     Voxtral-IPA, Gemma-4-12B GBNF-IPA
      phone-track   allosaurus (universal + eng + rus)

    Voxtral is the accuracy leader; Parakeet stays as the CC-BY-4.0 alternate.

    Follow-ups: `emit_10track_panel.py` drops the whisper backends; downstream RFDs and CITATION.cff drop Whisper entries. Gemma-auto shipped empty transcripts on all 15 clips (WER 1.000); separate follow-up to fix or drop.
    """

    related ~S"""
    Retracts three rows from RFD 2164 (Rung 1 corpus); amends RFD 2178 (QAFT stack plan), three Class B rungs go.
    """

    details_title "Drop all Whisper models from the ASR panel"

    details_preamble ~S"""
    Per-clip WER against SpeakingFaces canonical text. Lower is better.
    Zero = exact match on the canonical wording (case-insensitive, whitespace-
    split, Levenshtein / reference word count).
    """

    details "Per-clip", ~S"""
    | clip                     | parakeet | whisper | voxtral | wav2vec2 | gemma-auto |
    | ------------------------ | -------: | ------: | ------: | -------: | ---------: |
    | 100_1_2_1_1134_1         | 0.000    | 0.000   | 0.000   | 0.500    | 1.000      |
    | 100_1_2_1_1293_1         | 1.000    | 1.000   | 0.000   | 0.500    | 1.000      |
    | 100_1_2_1_574_1          | 1.000    | 1.000   | 0.000   | 1.000    | 1.000      |
    | 100_1_2_1_594_1          | 1.000    | 0.200   | 0.000   | 0.400    | 1.000      |
    | 100_1_2_1_856_1          | 0.000    | 1.000   | 0.000   | 0.200    | 1.000      |
    | 100_1_2_1_97_1           | 0.125    | 0.000   | 0.000   | 0.500    | 1.000      |
    | 100_1_2_2_1170_1         | 0.286    | 0.286   | 0.000   | 1.000    | 1.000      |
    | 100_1_2_2_1202_1         | 0.200    | 0.400   | 0.000   | 0.400    | 1.000      |
    | 100_1_2_2_288_1          | 1.000    | 0.000   | 0.000   | 0.500    | 1.000      |
    | 100_1_2_2_323_1          | 0.111    | 0.000   | 0.000   | 0.333    | 1.000      |
    | 100_1_2_2_846_1          | 1.000    | 1.000   | 0.000   | 0.500    | 1.000      |
    | 100_1_2_3_1070_1         | 0.600    | 0.000   | 0.000   | 0.400    | 1.000      |
    | 100_1_2_3_1098_1         | 0.000    | 0.000   | 0.000   | 0.400    | 1.000      |
    | 100_1_2_3_351_1          | 0.200    | 0.200   | 0.000   | 0.600    | 1.000      |
    | 100_1_2_3_380_1          | 1.000    | 0.000   | 0.000   | 1.333    | 1.000      |
    | **MEAN**                 | **0.501**| **0.339**| **0.000**| **0.571**| **1.000**  |

    Method: hypothesis is the concatenated cue text from each track's
    `.vtt` (WEBVTT header + timing lines stripped, remaining text
    whitespace-joined). Reference is the SpeakingFaces canonical text
    from `maskscore_speech.parquet`.
    """

    details "What the numbers say", ~S"""
    **Voxtral is the accuracy leader (0.000 mean WER, all 15 clips
    exact).** Same track also returns sub-second per clip on MPS.
    Whichever axis dominates the decision (speed or accuracy), Voxtral
    wins.

    **Whisper-large-v3 is not the worst on accuracy (0.339 mean).** It
    beats Parakeet (0.501) and wav2vec2 (0.571) but takes several
    seconds per clip on MPS. The reason to drop it is latency, not
    accuracy. The operator's initial "bad accuracy" observation was
    partially wrong; Whisper's problem is speed.

    **Parakeet is the workspace's stated CC-BY-4.0 canonical (RFD 2164)
    but sits at 0.501 mean WER**, worse than Whisper. Kept because the
    canonical-judge choice was made on license grounds, not accuracy
    alone; Voxtral is the accuracy-first alternate.

    **Gemma-auto shipped empty transcripts across all 15 clips**
    (WER 1.000 because the vtt files carry only the WEBVTT header, no
    cues). Separate bug: either the llama-mtmd-cli invocation failed or
    the output-parsing step drops the response. Follow-up separate from
    this RFD.
    """

    details "The 15-clip subset", ~S"""
    Sub_100 speaking English into a Kazakh L1 accent. Not a general-purpose
    benchmark. The three tracks Whisper family loses to (Voxtral wins,
    Parakeet loses, wav2vec2 loses) do not necessarily generalise to
    other accents. If a wider corpus lands (Rung 2, more SpeakingFaces
    subjects), rerun.
    """

    drafted_by :ai
  end
end
