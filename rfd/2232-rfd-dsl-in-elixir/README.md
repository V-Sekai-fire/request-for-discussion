# RFD 2232: RFD authoring as an Elixir DSL

**State:** discussion
**Feature:** one `rfd.exs` per RFD, compiled by `RFD.DSL`; README.md and DETAILS.md are renderings of it, and the render is checked in
**Scope:** `rfd_dsl/` (the Mix project), any `rfd/NNNN-slug/rfd.exs`; RFDs without a source stay as they are

## Decision

An RFD may be an Elixir module that uses `RFD.DSL`: one `rfd` block with
`state`, `feature`, `scope`, `flight_level`, `decision`, `problem`,
`references`, `related`, `details` sections and `drafted_by`. The block
builds an `RFD.Doc` and validates it against RFD 1000 while the file
compiles, so a state outside the list, a missing Decision, a README over
40 lines or an em-dash join is a compile error that names the rule.
`mix rfd.render` writes README.md and DETAILS.md in the shape the gates
and `render_site.py` read, which is how the document reaches Quarto;
`RFD.Doc.qmd/1` adds YAML front matter for a project without that script.


`DETAILS.md` carries the rest of this RFD.

## Problem

The shape is enforced after the fact by four Python gates reading
Markdown, and 143 problems accumulated before one pass fixed them. The
taskweft domains beside many RFDs are already Elixir, so the authoring
form that can refuse a malformed document before it is written is the
language the repository already runs in its hooks.

## References

- RFD 1000, the shape
- RFD 2177, the flight_level tag on the register

## Related

RFD 1000 (the README limit and the spine), RFD 2177 (the register carries `flight_level`, so the DSL writes it to the register row, not the README), RFD 2026 (commit style the rendered files ride on).

This RFD was drafted by an AI and read by a human before it shipped.
