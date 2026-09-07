# RFD 2207: Nord palette (or peer) for shipped demos
**State:** discussion
**Feature:** shipped demos and artifacts pick a named FOSS design
palette (Nord as the default, Solarized / Catppuccin / Tokyo Night
/ Rose Pine / Gruvbox as acceptable peers) rather than the warm
amber-on-panel look that Claude artifacts default to
**Scope:** every shipped browser demo under `7-service/*/docs/` and
every Artifact this workspace publishes as a deliverable; the same
rule does not bind private one-shot artifacts an operator uses to
inspect an intermediate

## Decision

A demo or artifact that ships as a reviewable surface picks one of
the following six FOSS-licensed palettes verbatim and sources its
tokens from that palette's published spec:

`DETAILS.md` carries the full text of this RFD.

## Problem

The mid-session operator redirect that produced the Starforged
demo's Nord palette was blunt: the warm-terminal look that
Claude artifacts default to reads as an AI intermediate, not as a
deliverable. A reviewer who opens a shipped demo and sees the
default Claude look concludes, correctly, that nobody picked a
palette. Picking one, any of the six above, closes that reading.

## Related

- RFD 2206 (video-call VRM portrait), the shipped surface this
  palette was first applied to.
- Codebase: `7-service/service-sqlar-cas/docs/index.html`, the
  reference Nord application in this workspace.
- CLAUDE.md's "Trademarks Stay Out of Shipping Artifacts" clause —
  the six palettes are all trademark-clean and named by their own
  project names.

This RFD was drafted by an AI and read by a human before it shipped.
