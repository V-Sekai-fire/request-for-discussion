# RFD 2204: RECTGTN fleet coordination
**State:** discussion
**Feature:** peers pick their next work item by running the same RECTGTN
query against one shared fleet domain, rather than by reading prose
relayed from the coordinator
**Scope:** every session that participates in the coordinate-agents
ceremony (RFD 2201); the Taskweft engine already in tree; a new
fleet-domain document

## Decision

Feed the Taskweft engine a **fleet domain**, a single JSON-LD
document conforming to
`3-interactor/taskweft/priv/schemas/rectgtn_domain.schema.json`, that
names the live peers as entities, their owned resources as capability
edges, the verbs peers execute as actions, and known decompositions as
methods. Every peer answers "what should I do next?" with the same
(continues in `DETAILS.md`)

`DETAILS.md` carries the full text of this RFD.

## Problem

Peer sessions coordinate through three ad-hoc channels: Bao rows, free-
form `SendMessage` prose, and operator-typed un-park signals. There
is no shared representation of *why* a peer is doing what it is doing,
so a peer that reranks does it by hand, a peer that finishes an item
(continues in `DETAILS.md`)

## Related

- RFD 2200 (ReBAC agent roles), supplies the relation vocabulary the
  fleet domain reuses.
- RFD 2201 (coordinate-agents ceremony), step 3 gets the one-line
(continues in `DETAILS.md`)

This RFD was drafted by an AI and read by a human before it shipped.
