# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

defmodule Serials.Weftspun do
  use RFD.Register

  register "Weftspun" do
    layer arc: "1.3.6.1.4.1.66606.1.1",
      site: 1,
      site_name: "weftspun",
      category: 1,
      category_name: "documents",
      pen: "1.3.6.1.4.1.66606",
      rule: "rfd/1000-conventions/DETAILS.md",
      note: {:decommissioned, "Frozen 2026-08-31. No new serial is allocated under arc 66606.1.1. Existing serials stay in place and stay citable; slug edits are fine, because renaming a document does not renumber it. New RFDs in this repository take the next unused serial under site 2 (arc 66606.1.2) from SERIALS-vsekai-fabric.usda, whose 2026-08-29 decommission was reactivated on 2026-08-31 for this purpose. When site 2 fills up, RFD 1000 opens site 5 at arc 66606.1.5. See pen-66606.usda sitesDecommissioned for the full argument."}

    thesis "Every serial this site has allocated, and every one it has retired. A serial is appended once. It is never removed and never reused, because it is the last arc of an OID and an arc names one document for as long as it exists. A slug follows its directory, because a retitle renames a document and does not renumber it."

    allocated do
      serial 1000, "conventions"
      serial 1001, "app-shell-and-routing"
      serial 1002, "studio-pipeline-graph"
      serial 1003, "task-manager-job-lifecycle"
      serial 1005, "avatar-and-vrm-pipeline"
      serial 1006, "layer-decomposition-see-through"
      serial 1007, "motion-validation-kimodo"
      serial 1008, "appearance-trait-extraction-and-remix"
      serial 1010, "webxr-and-iwsdk-lab"
      serial 1011, "spatial-fabric-publish"
      serial 1013, "public-demo-deploy"
      serial 1014, "batch-processing"
      serial 1017, "fork-rebrand-to-weftspun"
      serial 1018, "m3-documentation-removal"
      serial 1020, "cockroachdb-persistence"
      serial 1021, "shared-hrr-library"
      serial 1022, "hexagonal-client"
      serial 1023, "ports-and-adapters-with-headless-cms-style"
      serial 1025, "model-memory-arithmetic"
      serial 1026, "bf16-memory-per-model"
      serial 1027, "gpu-residency-budget", flight_level: :l2
      serial 1028, "model-license-gate"
      serial 1029, "foss-model-replacements"
      serial 1030, "seethrough-component-models"
      serial 1031, "geometry-refinement-and-alpha-wrap"
      serial 1033, "geometric-algorithms"
      serial 1034, "krea-memory-cross-check"
      serial 1035, "legacy-model-identifiers"
      serial 1036, "packaging-convention", flight_level: :l2
      serial 1037, "composite-models-as-taskweft-domains"
      serial 1038, "trellis2-image-to-textured-mesh"
      serial 1039, "trellis2-image-mesh-painting"
      serial 1040, "pixal3d-image-to-textured-mesh"
      serial 1041, "p3sam-mesh-segmentation"
      serial 1042, "krea2-turbo-text-to-image"
      serial 1043, "qwen-image-edit"
      serial 1044, "seethrough-layer-decomposition"
      serial 1045, "kimodo-text-to-motion"
      serial 1046, "skintokens-auto-rig"
      serial 1047, "voxhammer-text-mesh-editing"
      serial 1048, "voxhammer-image-mesh-editing"
      serial 1053, "openusd-as-the-internal-format", flight_level: :l2
      serial 1054, "headless-cms-on-taskweft"
      serial 1055, "beam-workers-local-first"
      serial 1056, "develop-in-a-dev-container"
      serial 1057, "open-work"
      serial 1058, "zero-trust-networking"
      serial 1059, "continuous-integration"
      serial 1060, "thirdparty-reset"
      serial 1061, "glb-upload-prep-via-idtx-core"
      serial 1063, "ste-enforcement-moves-to-the-plugin"
      serial 1064, "character-concept-generator"
      serial 1065, "taskweft-domain-schema-in-etnf"
      serial 1070, "keep-options-open"
      serial 1073, "dataset-billboard-gallery"
      serial 1074, "3d-billboard-labels"
      serial 1075, "github-oauth-admin-login"
      serial 1076, "usd-viewer-app-build-integration"
      serial 1077, "h2o-edge-cdn"
      serial 1078, "h2o-fdb-game-state-server"
      serial 1079, "appsignal-observability"
      serial 1080, "fly-deploy-cost"
      serial 1082, "android-studio-ai-brief"
      serial 1083, "api-avatar-rig-contract"
      serial 1084, "avatar-pipeline"
      serial 1085, "code-map"
      serial 1086, "dev-machine-topology"
      serial 1088, "https-setup"
      serial 1092, "kimodo-backend-integration"
      serial 1093, "loot-assets-setup"
      serial 1095, "nvidia-xr-ai-integration"
      serial 1096, "openxr-face-tracking-android-xr"
      serial 1099, "scripts-cheatsheet"
      serial 1102, "supported-atelier-modules", flight_level: :l2
      serial 1103, "vercel-loot-assets"
      serial 1104, "vrm-upload-display-export"
      serial 1105, "webcam-avatar-control"
      serial 1106, "weftspun-moat-overview"
      serial 1107, "world-package"
      serial 1108, "xr-mode-floor-anchoring-and-backgrounds"
      serial 1110, "reporesident-agent-harness"
      serial 1111, "3daigc-api-reference-not-restated"
      serial 1112, "cursor-rules-kept-in-the-open"
      serial 1113, "image-preview-vs-expand-sizing"
      serial 1114, "app-chrome-layout-invariants"
      serial 1115, "vrm-animation-playback-invariants"
      serial 1116, "tasks-panel-clear-and-collapse"
      serial 1117, "text-to-image-to-3d-chain"
      serial 1118, "xr-embody-locomotion-and-menu"
      serial 1119, "generic-hardware-not-dgx-or-android-xr-specific"
      serial 1120, "split-apps-into-own-repos"
      serial 1121, "layers-from-geometry-and-the-missing-categories"
      serial 1123, "cineform-in-godot"
      serial 1124, "rfd-structure-gate"
      serial 1125, "two-prose-gates"
      serial 1126, "feed-forward-for-the-edge"
      serial 1128, "four-bit-tolerance"
      serial 1129, "hailo-operator-coverage"
      serial 1130, "ugen300-throughput"
      serial 1131, "operator-emulation-for-the-accelerator"
      serial 1133, "models-excluded-from-conversion"
      serial 1134, "notebooks-tested-in-the-browser"
      serial 1135, "one-environment-per-elixir-app"
      serial 1136, "camera-vocabulary-and-the-96-pose-grid"
      serial 1137, "encoding-a-frame-set"
      serial 1138, "where-range-of-motion-comes-from"
      serial 1139, "conventions-are-measured"
      serial 1141, "publishing-artifacts"
      serial 1142, "the-mac-against-the-ugen300"
      serial 1143, "keypoints-to-anny", flight_level: :l1
      serial 1144, "image-to-omnigen2", flight_level: :l1
      serial 1145, "stylized-to-omnigen2", flight_level: :l1
      serial 1146, "latent-to-pixal3d", flight_level: :l1
      serial 1147, "what-editscore-costs-and-returns", flight_level: :l1
      serial 1148, "the-runtime-that-reaches-the-device"
      serial 1149, "mtoon-shades-against-the-key-light"
      serial 1150, "shade-colour-solved-per-tone"
      serial 1151, "which-axes-the-survey-weights"
      serial 1152, "background-removal-photographic-corpora"
      serial 1153, "judging-matte-quality"
      serial 1157, "editscore-merger-lora"
      serial 1161, "kimodo-edge-fit"
      serial 1164, "calibration-is-training-data"
      serial 1165, "finetuning-exhausts-the-desk-card"
      serial 1167, "the-ladder-and-where-each-model-stands"
      serial 1168, "segmenting-the-3d-latent-with-rf-detr"
      serial 1169, "the-audio-tower-for-qwen3-vl"
      serial 1170, "a-cleanroom-presence-loop"
      serial 1171, "the-presence-loop-and-every-role-in-it"
      serial 1172, "a-diffusion-lm-does-not-land-on-the-npu"
      serial 1173, "a-multimodal-diffusion-pipeline"
      serial 1174, "publish-the-security-rules-against-soc2-and-iso27001"
      serial 1175, "game", flight_level: :l2
    end

    unused "A serial nothing was ever written under. These three sat in neither register: not allocated to a document, and not retired from one, so a reader counting the live rows saw a gap and had nothing telling them what it meant. Recorded so the gap reads as a decision rather than as a loss. A satellite relation rather than an empty slug on the spine, because a serial with no document is a different fact from a serial with one, and CLAUDE.md's normal form takes satellites over nullable columns. NOTE THE LIMIT: `check-rfd-serials.py` keys on the scope names Allocated and Deleted and skips this one, so nothing enforces these. What prevents reuse is RFD 1000's rule that a new serial is the next unused one, which is max plus one and never a gap." do
      never_written 1081
      never_written 1097
      never_written 1127
    end

    deleted "A deleted serial keeps its row. The RFDs above still cite it, and deleting a directory does not delete a citation." do
      retired 1024, recorded_in: 1070
      retired 1032, recorded_in: 1070
      retired 1068, recorded_in: 1070
      retired 1069, recorded_in: 1064
      retired 1071, recorded_in: 1064
      retired 1072, recorded_in: 1064
      serial 1004, "aigc-task-catalog"
      serial 1009, "viewport-and-scene-rendering"
      serial 1012, "wallet-minting-and-x402"
      serial 1015, "phygital-passport"
      serial 1016, "deep-learning-model-inventory"
      serial 1019, "strangler-fig-studio-core"
      serial 1049, "weftspun-image-to-world"
      serial 1050, "lingbot-map-environment-scan"
      serial 1051, "worldmirror2-reconstruct"
      serial 1052, "triposplat-image-to-splat"
      serial 1062, "flyio-toplevel-4090-worker-split"
      serial 1066, "differential-mamba-for-caption-encoding"
      serial 1067, "cockroachdb-reranked-against-foundationdb"
      serial 1087, "gemini"
      serial 1089, "hyworld-image-to-world-scope"
      serial 1090, "iwsdk-integration"
      serial 1091, "iwsdk-local-fork"
      serial 1094, "multi-image-splat-roadmap"
      serial 1098, "public-deploy"
      serial 1100, "spatial-fabric-integration"
      serial 1101, "ssh-host-names"
      serial 1109, "moat-payment-rails-and-phygital-registry"
      serial 1122, "the-wholebody-gap"
      serial 1132, "priority-list-of-converted-models"
      serial 1140, "rented-gpus-on-runpod"
      serial 1154, "pixal3d-at-four-bits"
      serial 1155, "gemma4-towers-not-decoder"
      serial 1156, "omnigen2-staged-residency"
      serial 1158, "seethrough-layer-decomposition-edge"
      serial 1159, "trellis2-at-the-ceiling"
      serial 1160, "skintokens-edge-fit"
      serial 1162, "voxhammer-zero-weights"
      serial 1163, "the-accelerator-in-the-loops"
      serial 1166, "scoring-the-accelerator-candidates"
    end
  end
end
