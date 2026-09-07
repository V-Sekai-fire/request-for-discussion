# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2115. `mix rfd.render` renders rfd/2115-a-planner-domain-document-is-a-cheap-layer-surface/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2115 do
  use RFD.DSL

  rfd 2115, "A planner domain document is a cheap layer surface" do
    state :prediscussion

    decision ~S"""
    See `DETAILS.md` for the full argument.
    """

    problem ~S"""
    `fabric-store-domain` reached for a hand-written CBOR codec before
    this RFD existed. The encoder walked a `tsl::ordered_map` and wrote
    pairs in insertion order, carrying a comment that called the order
    correct.
    """

    related ~S"""
    See `DETAILS.md` for the full argument.
    """

    details_title "A planner domain document is a cheap layer surface"

    details "The encoder that prompted this", ~S"""
    `fabric-store-domain` reached for a hand-written CBOR codec before this RFD
    existed. The encoder walked a `tsl::ordered_map` and wrote pairs in
    insertion order, carrying a comment that called the order correct.

    The comment was right about round-tripping. Encode a document, decode it,
    and the value that comes back matches the value that went in, every time.
    RFC 8949 section 4.2 wants map keys in lexicographic order, so one set of
    rules assembled by two paths becomes two byte strings, and nothing
    downstream can tell that apart from a genuine change.

    A test that encodes and then decodes never sees this. It measures whether a
    writer agrees with its own reader, and the two agreed. It would surface
    later as a ward whose fingerprint moved with nothing in the game having
    moved, which is the one signal the replay check exists to make
    trustworthy.

    That is the case for a library with production hours behind it. RFD 2003
    picked `QCBOR` on exactly that basis, and the bug above is the kind other
    people already found in it.
    """

    details "The three consumers", ~S"""
    `taskweft/nif` reads a domain document through `TwLoader::load_domain`,
    which takes an already-decoded value rather than a string. That signature
    is what lets a decoder live outside the vendored headers, which matters
    because the vendored tree stays byte-identical to upstream and a fix in it
    belongs upstream.

    `fabric-store-domain` carries one for the ward, tracked in its issue #9.

    `fabric-behaviour-domain` pairs a planner with ARDY, and the thing that
    planner is told is a domain document too.
    """

    details "Why the store plane rather than aria-storage", ~S"""
    A domain document describes a world. Keeping it in the same SQLite database
    as that world means a ward that migrates between machines does not leave
    its rules behind, since a page reference moves rather than a copy. It also
    makes the rules readable the way everything else there is readable, which
    is the premise `fabric-store-domain` runs on: what you can see of the game
    is what you can `SELECT`.

    `aria-storage` is content-addressed `casync` chunks for packages and
    assets. A domain document is neither, and RFD 2003's determinism argument
    travels with `casync` rather than with the format.
    """

    details "What this does not settle", ~S"""
    Whether the document is written into the ward at founding or read from the
    binary each run. Both end with the same bytes in the same place, and the
    choice is about who owns the migration when the schema changes.
    """

    drafted_by :ai
  end
end
