# RFD 2136: The gacha critical path, as a ladder
**State:** discussion
**Feature:** the plan of record for the public roll button, as a ladder of small working systems
**Scope:** the gacha demo; `page.qmd` beside this file carries the figure

## Decision

Rebuild the plan as a ladder, in Gall's Law's sense: each rung is a
small working system that the next one extends, and no rung is added
until the one below it demonstrably runs. That replaces the parallel
tracks with a sequence where every step shows something, and it
puts Pixal3D and EditScore on the spine where they belong.

`DETAILS.md` carries the full text of this RFD.

## Problem

The prior draft of this RFD ran a PERT network with a chain
A → I → D → E → G, and I → D skipped every step that turns a text prompt
into a mesh good enough to skin: no image-to-3D via Pixal3D, no
EditScore judge, no repair loop. A pull is not a gacha item without
those, so the network was drawing a schedule around a pipeline that
did not yet exist end to end.
