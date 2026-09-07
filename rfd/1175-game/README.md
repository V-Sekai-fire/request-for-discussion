# RFD 1175: game

**State:** discussion
**Feature:** one native binary that is both the interactive demo and
the video head that records it
**Scope:** `3-interactor/entities-godot-sandbox`; every part the
atelier ships lands in this binary

## Decision

One Godot binary (Vulkan; MoltenVK on macOS) shows a VRM avatar
framed like a video call, and at each decision point offers the
legal Starforged moves from the Taskweft planner; the chosen move's
outcome drives a VRM expression while motion-bricks (ggml, Vulkan)
generates the body motion between decisions. The same binary with
`--headless --write-movie` walks a shot list and encodes CineForm,
so the video is the game recorded rather than a second deliverable.
`DETAILS.md` carries what the player sees, the loop, the runtime
stack and the video head.

## Problem

The demo was two deliverables, a video and a game, with two asset
paths that could drift. One binary with two heads removes the second
path and makes every shipped part prove itself in the thing a player
runs.

## Related

RFD 2210 (the shipping surface this binary is), RFD 2177 (flight
levels; this RFD is L2 in the register).
