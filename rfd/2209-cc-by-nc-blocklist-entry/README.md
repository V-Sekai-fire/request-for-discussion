# RFD 2209: CC-BY-NC as a blocklist entry
**State:** discussion
**Feature:** add `CC-BY-NC` (all versions) to CLAUDE.md's blocklist
alongside `CC-BY-SA`, and gate build scripts to drop CC-BY-NC rows
before shipping any derived corpus
**Scope:** every corpus builder that reads a mixed-licence source
document; today's concrete case is
`scripts/build_starforged_hf.py` and `build_starforged_sqlite.py`
against the dataforged repo

## Decision

Add a row to CLAUDE.md's "Blocklists" table:

`DETAILS.md` carries the full text of this RFD.

## Problem

Concrete case that produced this RFD: **dataforged**, the
community JSON rendering of the Starforged and Ironsworn SRDs at
`github.com/rsek/dataforged`, carries a mixed licence:

## Related

- CLAUDE.md's existing `CC-BY-SA` row, same shape, same argument.
- RFD 2205 (Taskweft in Bao), the Starforged play surface whose
  corpus is the concrete case.
- Codebase: `2-contract/manuals-weftspun/scripts/build_starforged_hf.py`
  and `build_starforged_sqlite.py`, the reference filter
  implementations.
- Codebase: `2-contract/manuals-weftspun/scripts/check_starforged_hf.py`
 , the downstream CI assertion.

This RFD was drafted by an AI and read by a human before it shipped.
