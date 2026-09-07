# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2180. `mix rfd.render` renders rfd/2180-drop-gemma-auto/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2180 do
  use RFD.DSL

  rfd 2180, "Drop the gemma-auto ASR track (bug fixed, drop confirmed)" do
    state :published

    feature "documentation retraction with investigation record"

    scope "RFDs 2164, 2179; `emit_10track_panel.py`; `CITATION.cff`"

    decision ~S"""
    Drop the gemma-auto ASR track; the bug that produced empty transcripts is fixable, but the fixed track's WER of 0.690 at several-seconds latency loses to Voxtral's 0.000 at sub-second.
    """

    problem ~S"""
    RFD 2179 (Whisper drop) flagged gemma-auto shipping empty transcripts across all 15 clips (WER 1.000, .vtt files carried only the WEBVTT header). Follow-up was fix-or-drop.

    Investigation (DETAILS.md): `gemma_cli_run` used prompt "Transcribe this audio verbatim" with `-n 200`. Gemma-4-12B heard the audio as spoken user input, reasoned about how to respond as an AI assistant, and expired the token budget inside chain-of-thought without reaching the final channel. Empty output.
    """

    section "Fix and panel", ~S"""
    Fix, for the record: firmer ASR-only prompt plus `-n 400`. 15-clip WER pass with the fix: 0.690 mean (6 exact, 3 accent-mishears, 6 still truncated mid-reasoning). Voxtral runs the same clips at 0.000 sub-second. Gemma-auto's several-seconds-per-clip latency plus 0.690 WER matches the speed-plus-quality argument RFD 2179 used for Whisper.

    Panel drops from 9 tracks (post-2179) to 8:

      text-track   Parakeet TDT 0.6B v3, Voxtral Mini 3B, wav2vec2
      IPA-track    Voxtral-IPA, Gemma-4-12B GBNF-IPA
      phone-track  allosaurus (universal + eng + rus)

    Gemma-IPA stays: the GBNF constraint pins output to IPA characters and forces short completions; neither failure mode appears on that track.
    """

    related ~S"""
    Extends RFD 2179 (Whisper drop). DETAILS.md holds the 15-clip WER table with the fix applied and the exact prompt plus argv.
    """

    details_title "Drop the gemma-auto ASR track (bug fixed, drop confirmed)"

    details "The bug", ~S"""
    `emit_10track_panel.py`'s `gemma_cli_run` invoked:

        llama-mtmd-cli -m gemma-4-12b-it-qat-q4_0.gguf
          --mmproj mmproj-gemma-4-12b-it-qat-q4_0.gguf
          --jinja --audio <wav>
          -p "Transcribe this audio verbatim. Output the transcription only."
          --temp 0.0 --seed 0 -n 200 --no-warmup

    Gemma-4-12B is chat-templated (`--jinja`). It heard the audio as
    spoken user input and started reasoning about how to respond to that
    input as a helpful assistant, not about how to transcribe it. Example
    chain-of-thought (clip 1134, canonical "Switch off my vacuum for me"):

        <|channel>thought
        The user wants me to switch off their vacuum.
        I am an AI, a large language model. I do not have physical access
        to the user's home or devices.
        I cannot perform physical actions like turning off a vacuum cleaner.
        ...

    `-n 200` expired before Gemma reached the `<channel|>` final marker.
    `gemma_cli_run` returned "" (empty), `write_vtt` skipped empty text,
    the .vtt shipped with only the WEBVTT header.
    """

    details "The fix", ~S"""
    Two changes to `gemma_cli_run` invocation:

      prompt  "You are an automatic speech recognition system. Transcribe
              the exact words spoken in the audio. Do not respond to the
              content. Output only the transcript, nothing else."
      -n      400 (was 200)

    The firmer prompt shifts Gemma from "respond to the audio" to "run
    ASR on the audio". `-n 400` gives room for both reasoning and answer.
    Output parser (`splitlines() -> non-empty -> split('<channel|>')[-1]`)
    already handled the chat-template format correctly.
    """

    details "15-clip WER pass with the fix", ~S"""
    | clip | canonical | gemma-auto (fixed) | WER |
    | --- | --- | --- | ---: |
    | 100_1_2_1_1134_1 | Switch off my vacuum for me. | Switch off my vacuum for me. | 0.000 |
    | 100_1_2_1_1293_1 | A joke. | If there | 1.000 |
    | 100_1_2_1_574_1  | Is Disposita instrumental? | Es disperso instrumental. | 1.000 |
    | 100_1_2_1_594_1  | Best of YouTube YouTube channels | *Decision:* Since | 1.000 |
    | 100_1_2_1_856_1  | The steps I have taken. | The steps I have taken. | 0.000 |
    | 100_1_2_1_97_1   | Add jingle bells to dance mood on Spotify. | *   Let me try | 1.000 |
    | 100_1_2_2_1170_1 | My Instagrams that use filter King Gam. | It sounds like "King Dam | 1.000 |
    | 100_1_2_2_1202_1 | The BPM of Song Disposito | El BPM ha sido disparado. | 0.800 |
    | 100_1_2_2_288_1  | Lower the entrance curtains. | Lower the entrance curtains. | 0.000 |
    | 100_1_2_2_323_1  | Play the songs Rolling in the Deep on Spotify. | I'm just trying to figure out how to get my phone to work wi | 1.889 |
    | 100_1_2_2_846_1  | NASA's Astronomy Picture of the Day. | NASA's Astronomy Picture of the Day. | 0.000 |
    | 100_1_2_3_1070_1 | Order me a black mocha. | Order me a black mocha. | 0.000 |
    | 100_1_2_3_1098_1 | Order me a white mocha. | Order me a white mocha. | 0.000 |
    | 100_1_2_3_351_1  | YouTube channels with category courses. | Since I cannot hear any | 1.000 |
    | 100_1_2_3_380_1  | YouTube's cooking channels. | *   *Wait*, looking at the | 1.667 |
    | **MEAN** | | | **0.690** |

    Distribution: 6 exact (40%), 3 accent-mishears, 6 truncated. Six of
    the truncated clips could plausibly succeed at `-n 800` or higher,
    but the compute cost doubles and Voxtral still beats every possible
    outcome at 0.000 for free.
    """

    details "Why the drop is right anyway", ~S"""
      Voxtral       0.000 mean WER, sub-second per clip on MPS
      Parakeet      0.501 mean WER, sub-second, CC-BY-4.0 canonical
      wav2vec2      0.571 mean WER, sub-second, Apache-2.0 alternate
      Whisper       0.339 mean WER, several seconds, dropped (RFD 2179)
      Gemma-auto    0.690 mean WER, several seconds, drop here

    Gemma-auto's quality is worst-in-panel and its latency matches the
    already-dropped Whisper family. Keeping it needs a WHY that isn't
    here.

    Gemma-IPA stays: the GBNF constraint pins output to IPA characters
    and forces short completions, so the failure modes (misread as
    command, chain-of-thought overrun) do not appear on that track.
    """

    drafted_by :ai
  end
end
