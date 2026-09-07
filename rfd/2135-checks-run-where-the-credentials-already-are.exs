# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2135. `mix rfd.render` in rfd_dsl/ renders rfd/2135-checks-run-where-the-credentials-already-are/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2135 do
  use RFD.DSL

  rfd 2135, "Checks run where the credentials already are" do
    state :discussion

    feature "where operational monitoring lives, and what it may not live in"

    scope "weftspun-fdb's machine checks; any later production check"

    attest_in :none

    decision ~S"""
    A production check runs on the machine being checked, because that is
    the one place the credentials already are: nothing new is granted
    anywhere. It publishes a health file over a local httpd, and a Fly
    machine check turns the file into a pass or fail in `fly status`.

    Two reference cases ship, both on weftspun-fdb. `backup_fresh` reads
    the backup layer's own metadata; a backup is fresh only when it is
    running and its restorable point is close. `cluster_health` fails
    until the data state is healthy and a zone can be lost without losing
    data, so a rolling deploy waits out re-replication after each
    restart, the way the Kubernetes FDB operator gates its own rolls.

    Every check refuses to arm unless its self-test controls fire in both
    directions, and an unreadable signal always reads as failure. The
    measurements behind both checks, including the two backups that
    silently self-completed and the curl signing limits that reshaped the
    probe, are in DETAILS.md and the logbook.
    """

    problem ~S"""
    The weftspun-fdb backup needed a staleness gate, and the two obvious
    homes were both wrong. CI has no production access, and granting it
    some means a new credential with a new blast radius. The spot-broker
    keeper holds spend authority, and an admin service that accumulates
    monitoring scripts becomes the home of every capability.
    """

    section "Verification", ~S"""
    The roll gate's first live exercise was its own deploy: after each
    machine restart the check held red (`data_healthy=no`) through
    re-replication and the roll waited, then all three machines converged
    to 2 of 2 checks passing.
    """

    details_title "Checks run where the credentials already are"

    details "The placement, spelled out", ~S"""
    Three candidate homes for a backup staleness gate, two rejected:

    | home | verdict | reason |
    | --- | --- | --- |
    | CI | rejected | no production access, and granting it some is a new credential with a new blast radius |
    | the spot-broker keeper | rejected | it holds spend authority; an admin service that accumulates monitoring scripts becomes the home of every capability |
    | the cluster machine | chosen | the credentials are already there; nothing is granted anywhere |

    The delivery is a health file under /run, served by busybox httpd on
    :8081, read by a Fly machine check. A failing check is visible in
    `fly status` and gates rolling deploys. Nothing pages, and that is a
    known limit rather than an oversight: visibility comes first.
    """

    details "Duty hours, and what the checks must therefore be", ~S"""
    This workspace is one operator with no on-call rotation. The honest
    duty cycle is a few working hours a day, so the mean time between a
    check going red and a person seeing it is measured in hours and can be
    a weekend. Reliability here cannot be bought with response time; it
    has to be bought with what the system does while nobody is watching.

    That shapes the checks. Every failure is fail-closed rather than
    fail-alerting: the roll gate holds a deploy by itself, a stale backup
    blocks nothing but keeps its red state until seen, and no check
    depends on someone acting inside a window. The checks guard the
    durability layer, not the availability layer: spot-broker being down
    for a night costs a night of GPU brokering, but a backup that stopped
    silently costs the ledger, so the paging budget such as it is goes
    entirely to what cannot be replayed. And a red check must still be
    red when the operator arrives: probes publish state continuously
    rather than emitting events, because an event at 03:00 with nobody on
    duty is a fact that evaporates, and a health file that stays absent
    is one that waits.

    Paging (a phone that rings) becomes worth adding when a second
    operator exists or when a customer-facing deployment makes hours-long
    staleness a revenue event. Until then it would page the same person
    the visibility already reaches, at hours the duty cycle already
    excludes.
    """

    details "backup_fresh: two designs, one retraction", ~S"""
    The first probe listed the bucket: the newest object under data/ is
    what a restore would actually find, the more physical measurement.
    It could not survive curl 7.88's SigV4: the canonical query is signed
    unsorted and unencoded, so parameters out of alphabetical order, any
    prefix containing a slash, and every continuation token come back 403
    SignatureDoesNotMatch. A probe that cannot paginate cannot find the
    newest object, and the working hand-checks had been accidentally
    alphabetical (`list-type`, `max-keys`).

    The shipped probe reads the layer's own metadata from `status json`:
    `last_restorable_seconds_behind`, which advances only after durable
    blob writes, and `running_backup`, without which a small lag is a
    stopped backup coasting on its last snapshot.

    That guard paid for itself the same afternoon, twice:
    `fdbbackup start` defaults to stop-when-done, so both production
    submissions completed at their first restorable point and
    `running_backup` went false while the lag still read healthy (122
    seconds at one catch). Continuous is `-z`. The entrypoint's printed
    command now carries it, and `-w` is dropped: waiting on a backup
    that never completes is a terminal that never returns.
    """

    details "cluster_health: the operator's gate as a machine check", ~S"""
    Fly advances a rolling deploy only when every machine check passes.
    `cluster_health` fails until `status json` reports the data state
    healthy AND `max_zone_failures_without_losing_data` at least 1, the
    window in which a second restart can catch a shard whose two
    replicas span the healing machine and the next one, stalling those
    ranges under double redundancy. Coordination quorum was never the
    hazard: rolls are one machine at a time and three coordinators
    tolerate one down. The data layer was.

    First live exercise, on its own deploy: after each restart the check
    logged `data_healthy=no zone_tolerance=1` and held, the roll waited,
    and all three machines converged to 2 of 2 passing.
    """

    details "Controls", ~S"""
    Both probes refuse to arm unless their self-tests fire in both
    directions: a planted defect the check cannot flag is a check that
    certifies the defect. backup_fresh carries four (fresh, planted lag,
    stopped-but-recent, unreadable lag); cluster_health carries four
    (healthy, planted unhealthy state, zero tolerance, unreadable
    tolerance). In every probe an unreadable signal reads as failure,
    because a check that cannot see is not a check that passes.
    """

    details "The volumes, while the hood was open", ~S"""
    `status details` on the 1 GB volumes: 944 MB of disk used against
    0 MB of key-value data (transaction-log disk queues preallocate, and
    each machine runs two fdbserver processes), leaving 0.4 GB free on
    the fullest storage server, near FoundationDB's low-space exclusion
    threshold. All three volumes extended to 10 GB in place
    (`fly volumes extend`), filesystem grown online, no restart: 3% used
    after.
    """

    drafted_by :ai
  end
end
