# RFD 2206: Video-call VRM portrait convention
**State:** discussion
**Feature:** the visual convention for a VRM avatar staged as a
FaceTime-style portrait, fixed eye-level camera, LookAt on the
camera with periodic glance-away, breathing sway, blink cycle,
reaction blendshapes that fade over about the width of a golf ball
of time (~1.6 s)
**Scope:** any browser demo or shipped surface that presents a VRM
as an interlocutor rather than an inhabitant of a world; today's
concrete case is the Starforged play surface in
`7-service/service-sqlar-cas/docs/`

## Decision

A VRM presented as an interlocutor is staged as **a 3D character in
a small diorama, framed like a video call**. The frame is fixed;
the character animates within it; there is no world navigation.
Concretely:

`DETAILS.md` carries the full text of this RFD.

## Problem

The reflex-executor demo that shipped in
`7-service/service-sqlar-cas/docs/` first framed its VRM as an
inhabitant of a scene, WASD, orbit camera, gamepad. The Starforged
retarget of the same page kept the WASD wiring alive, and the
character read as a doll on a stage rather than as the person the
player was talking to. The retarget was a *decision-point* game
(continues in `DETAILS.md`)

## Related

- RFD 1170 (presence loop), this RFD is its visual convention.
- RFD 2205 (Taskweft in Bao), the Starforged play surface that
  this convention was first applied to.
- [RFD 2213](../2213-vrm-via-godot-sandbox-elf/), how the VRM
(continues in `DETAILS.md`)

This RFD was drafted by an AI and read by a human before it shipped.
