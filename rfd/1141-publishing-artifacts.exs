# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1141. `mix rfd.render` in rfd_dsl/ renders rfd/1141-publishing-artifacts/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1141 do
  use RFD.DSL

  rfd 1141, "Publishing artifacts" do
    state :discussion

    feature "where results go"

    scope "anything produced that outlives the machine that made it"

    attest_in :none

    decision ~S"""
    Artifacts go to Hugging Face. Code stays on GitHub, and each names the
    other. A dataset repository holds corpora; a model repository holds
    weights, in safetensors, carrying only the tensors that were trained.
    
    Every artifact repository carries a `CITATION.cff` naming its title,
    its licence, and every source it derives from. An artifact without one
    cannot answer what it is made of, which is condition 1.
    
    The name matches the source repository, and the README names the side
    it sits on, so a reader who finds the artifact first reaches the code.
    """

    problem ~S"""
    Code goes to GitHub, and the goal manifest places every repository on a
    side of the hexagon. Artifacts had no such rule. A trained adapter, a
    rendered corpus and a set of vertex weights are not code: too large for
    a source repository, regenerated rather than edited, and carrying the
    licence of whatever they derive from as well as our own. Left on a desk
    they go with the desk. Pushed into a source repository they bloat a
    history nobody can shrink again.
    
    A checkpoint also lies about its own size: the trainer writes the whole
    model, so a 19.5 MiB adapter arrives as 14.8 GiB of mostly somebody
    else's Apache-2.0 base weights.
    """

    references ~S"""
    - `SKILL.md` is the procedure. `DETAILS.md` says what is not published.
    """

    related ~S"""
    RFD 1140 rents the machines. RFD 1000 gives placement.
    """

    details_title "Publishing artifacts"

    details "The size measurement that drives the weights rule", ~S"""
    Measured 2026-08-25 on `experiments/anny_camera_lora_1gpu/checkpoint-200`:
    
    | | |
    | --- | ---: |
    | checkpoint on disk | **14.8 GiB** |
    | tensors in it | 886 |
    | tensors carrying LoRA | **304** |
    | extracted adapter | **19.52 MiB** |
    | ratio | **776x** |
    
    `docs/FINETUNE.md:80-81` records why: under FSDP the trainer cannot easily separate the
    adapter parameters, so it writes all of them. Two checkpoints at `checkpoints_total_limit: 2`
    is already 30 GB for 39 MB of trained weight.
    """

    details "The rename that fails silently", ~S"""
    The trainer writes `context_refiner.0.attn.to_k.lora_A.default.weight`. PEFT reads
    `base_model.model.context_refiner.0.attn.to_k.lora_A.weight`. Two differences: the `.default.`
    segment carrying the adapter's PEFT name, and the `base_model.model.` prefix.
    
    A loader that finds nothing under its expected keys does not raise. It adds a freshly
    initialised adapter and generates from the base model, so the output is ordinary rather than
    broken, and the run reads as a model that learned nothing. `extract_lora_adapter.py` counts
    both rewrites and exits non-zero on a partial, because a rewrite that hits some keys and not
    others is the same failure wearing a smaller mask.
    """

    details "What must not be published", ~S"""
    **Quantised output.** CLAUDE.md's condition 5. NF4 outputs are device evidence. Measured
    here, four bits also bought no speed on this card, 133 s against 131 s, so there is
    nothing to trade.
    
    **Blinded-holdout derivatives.** `coco_person_commercial_val2017` is 523 licence-filtered
    COCO person images and is not inspected during development at all. Anything derived from it
    inherits that: `6-datasource/coco-ood-eval` is evaluation-only twice over, being both
    val2017-derived and generated.
    
    **`weftspun/rf-detr-keypoint-data`.** Its own README says the licence file is wrong: it claims
    CC BY 4.0 for the whole set, and **1,823 of 2,346** images carry NC, ND or share-alike terms.
    The file names look like a training split and are not one.
    
    **`alfredplpl/anime-with-caption-cc0` images.** Blocklisted for hand quality; the captions are
    permitted. An artifact using the captions says so and does not imply the images.
    
    **Anything from a set behind a registration form.** Terms that cannot be read without
    accepting them cannot be gated on, so the set is not licence-clean whatever it says after you
    accept.
    """

    details "Naming, worked through", ~S"""
    `weftspun/anny-render-corpus` on GitHub sits on `6-datasource`. Its artifacts publish under
    the same name, and the dataset card's first line links back to the GitHub repository and
    names the side.
    
    Where one source repository produces both a corpus and a weight, they are two Hugging Face
    repositories, one dataset and one model, sharing the name and differing in type. A model
    repository holding a corpus is the mistake this rule prevents, and it is easy to make because
    the run that produced both is one run.
    """

    details "Mirroring the base, measured", ~S"""
    | | |
    | --- | ---: |
    | snapshot on disk | **29.13 GiB** across 42 files |
    | new data actually uploaded | **81.6 MB** |
    | observed rate | 382 MB/s |
    
    The hub stores content-addressed, so objects it already holds are not re-sent. Mirroring a
    public model therefore costs almost nothing in bandwidth, and an earlier draft of the skill
    warned against it on exactly that ground. The warning was wrong and is withdrawn.
    
    **The local cache was incomplete.** Six README images had never been fetched, because training
    pulls weights and nothing else wanted them. `snapshot_download(..., local_files_only=True)`
    raised `IncompleteSnapshotError` and named them. Uploading anyway would have produced 36 files
    under a name that promises 42. Complete the snapshot at the pinned revision, and print that it
    happened, so the record says whether the mirror came from the cache or from a fetch.
    """

    details "Verifying a mirror, and where the hub cannot help", ~S"""
    `repo_info(..., files_metadata=True)` exposes `sha256` for **LFS objects only**. On this
    mirror that is 15 of 41 files, every weight, and none of the configs.
    
    So the first verification reported "15 compared by sha256, 0 differing" and left 26 files
    checked only for presence. Presence and identity are different claims, and the gap matters
    more than the count suggests: a mirror whose `config.json` had drifted would load a different
    model while every weight matched.
    
    The 26 are a few hundred kilobytes. Downloading both copies and hashing them locally took
    seconds and closed it: **26 small files hashed, 0 differing**.
    """

    details "Absolute paths, and the one that hid in prose", ~S"""
    Three staged files named a home directory after the first rewrite pass, and a fourth survived
    a second pass. The first three were path *fields*, `source_frame` in the measurement JSONs.
    The fourth was inside a sentence:
    
        "no person detected in C:\Users\...\az045_A.png at threshold 0.3"
    
    A check on whole-string values misses that entirely, and it discloses just as much. Substitute
    inside strings, then scan the staged tree and refuse to upload while one remains.
    
    One more, worth naming because it made a check pass while doing nothing: the scanning regex
    was written with a character class holding an escaped slash, which is just a slash. It matched
    no backslash at all, so a drive-letter path sailed through a check that reported success.
    """

    details "What is not measured here", ~S"""
    Hugging Face upload throughput, LFS behaviour on files above 5 GB, and whether the hub's own
    licence detector agrees with a dual `Apache-2.0 OR MIT` pair. The last of those has a known
    answer on GitHub, two `LICENSE-*` files at the root read as "Other" until one is on the
    default branch, and nothing here has checked the hub.
    """

    drafted_by :ai
  end
end
