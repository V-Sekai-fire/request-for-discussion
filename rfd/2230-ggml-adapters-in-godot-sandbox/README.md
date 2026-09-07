# RFD 2230: ggml model adapters as sandboxed GDScript over one native module
**State:** discussion
modules into 1 shared native + N GDScript adapters)
**Feature:** ggml lives as a single native module inside
`entities-godot-sandbox`; model-specific adapter code (tokenizer,
prompt templates, LoRA scaling, sampler config, per-model quirks)
moves out of per-project C++ into GDScript loaded at runtime with
sandbox permissions
**Scope:** `entities-godot-sandbox/modules/ggml/` (new), motion-
bricks-cpp / kimodo / skin-tokens-cpp adapter code, RFD 2212
(motion-bricks-as-native-module rescopes), RFD 2229 (this is one
of its named consolidations landing)

## Decision

Operator, 2026-09-05, verbatim: *"Are you able to move the ggml
model adapters and process from c++ to godot-sandbox gdscript
if we add ggml to entities-godot?"*.

`DETAILS.md` carries the full text of this RFD.

## Related

- RFD 2188 (one ggml across workspace), the source consolidation
  this RFD ships against.
- RFD 2211 (base tree entities-godot-sandbox), the tree the
  new module lands in.
- RFD 2212 (motion-bricks-as-native-godot-module), this RFD
  supersedes 2212's shape; 2212's L1 execution work becomes
  Step 2 of this RFD's sequencing.
- RFD 2213 (VRM via godot-sandbox ELF), the parallel path for
  cases needing full ELF sandbox rather than GDScript sandbox.
- RFD 2214 (model bundle SQLite+ZSTD), the bundle loader
  surface adapters call.
- RFD 2229 (interchangeable-parts consolidation policy), the
  policy this RFD lands one of; the three-C++-module → one-
  native-module-plus-N-GDScript-adapters shape is exactly what
  2229's ggml-consumers row proposed.

This RFD was drafted by an AI and read by a human before it shipped.
