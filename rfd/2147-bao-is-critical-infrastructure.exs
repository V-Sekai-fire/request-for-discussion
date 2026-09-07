# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2147. `mix rfd.render` in rfd_dsl/ renders rfd/2147-bao-is-critical-infrastructure/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2147 do
  use RFD.DSL

  rfd 2147, "Bao is critical infrastructure now" do
    state :discussion

    scope "weftspun-bao, its consumers, its DR runbook."

    attest_in :details

    decision ~S"""
    Bao's availability class rises to match its consumers'. Recovery
    becomes hands-off, not operator-with-1P.

    1. **Replicas across zones, coordinated over FDB.** `ha_enabled = true`,
       three Bao machines minimum (matching FDB's three-zone spread and
       fault-tolerance-1 posture); consumers hit `weftspun-bao.internal`.
    2. **Auto-unseal.** HA without auto-unseal is theatre. A fleet
       restart returns the operator to the critical path. KMS-backed
       seal wrapper removes the human from routine restarts; the Shamir
       key in 1P stays as break-glass (RFD 2144 defect #11's day).
    3. **Consumers cache what they can.** A bearer held for a few
       minutes puts Bao in the critical path only at cache expiry.
    4. **No CDN proxy in front of workspace services.** CF-proxied
       records have Cloudflare terminating TLS at its edge, every byte
       plaintext at CF for the round trip. Workspace services stay
       DNS-only; edge cache, if needed, is Fly-side or origin-side.

    Details, sub-decisions, migration in `DETAILS.md`. S2147.
    """

    problem ~S"""
    Bao was one machine, Shamir seal single share, operator+1P recovery
    per restart. RFD 2140's `ha_enabled = "false"` fit that framing. RFD
    2146 then moved every routine credential read, coordination write,
    and policy check onto Bao. Every consumer now depends on Bao being
    up, and RFD 2140's reliability budget is smaller than what routes
    through Bao now needs.
    """

    related ~S"""
    RFD 2140, 2144, 2145, 2146.
    """

    details_title "Bao is critical infrastructure now"

    details "Why HA now, not before", ~S"""
    RFD 2140 chose `ha_enabled = "false"` when Bao was one machine and one
    operator. Under that arrangement, Bao being down meant one thing was
    down: the Bao API. Everything else routed around Bao by holding its
    credentials in Fly secrets or 1P.

    RFD 2146 turned that inside out. Every consumer now authenticates to
    Bao with its per-service cert, reads its credentials from Bao at
    runtime, and coordinates state through Bao's KV. When Bao goes down,
    the DNS-editing path goes down, the R2-write path goes down, the FDB
    coordinator info lookup goes down, and any new spend gate that
    follows the same pattern goes down with them. The single-machine
    posture that was fine as a convenience store is not fine as the
    switchboard.
    """

    details "Replicas: 3 in sjc, coordinated over FDB", ~S"""
    OpenBao's FDB backend supports HA by leader election over the same
    storage the writes go to. The Fly app pattern is one machine per zone,
    mirroring FDB's own three-zone spread: `weftspun-bao` scales to 3,
    each on `shared-cpu-1x` (256 MiB was enough for the single-instance
    workload; 512 MiB is the ceiling to size for once cache and
    per-connection state land). Consumers reach `weftspun-bao.internal`,
    which Fly's DNS round-robins across live replicas.

    Standby replicas can either serve reads directly (`disable_performance_
    standby = false`) or forward every request to the leader. Read-serving
    standbys are the right choice given the read/write ratio the cert-auth
    path establishes (many reads per one write), and standby-served reads
    cannot go stale beyond FDB's read version, which is what we already
    key cached grants on.

    The 3-machine scale exposes one wrinkle: three machines mean three
    seal states, three unseal calls per fleet restart. This is the reason
    auto-unseal is not optional.
    """

    details "Auto-unseal: KMS wrapper, Shamir stays as break-glass", ~S"""
    Shamir with a manual share is the right seal for one-of-one, wrong for
    three-of-three. Options:

    - **Cloud KMS seal** (AWS KMS, GCP KMS, Azure Key Vault, Oracle). The
      key stays in the cloud KMS; Bao decrypts the master key at boot via
      the KMS API. Standard pattern. Cost is per-request against the KMS,
      measured in fractions of a cent per unseal.
    - **Transit seal** (a second, seed-only Bao). Chicken-and-egg unless
      the seed Bao is truly offline (Raspberry Pi, HSM, boot-from-USB).
      Adds a second thing to maintain.
    - **HSM / PKCS#11**. Right answer for a fleet in a datacenter with
      its own HSM. Overkill for this workspace's scale.
    - **HCP Vault / OpenBao managed**. Not this workspace's shape.

    Recommendation: cloud KMS. The workspace does not yet have a KMS
    account of any of the three big providers; standing one up is the
    tax. Fly does not offer a first-party KMS at this scale. The Shamir
    key in 1P stays as break-glass for the day the KMS itself is the
    outage (RFD 2144 defect #11's day).

    An auto-unseal wrapper does not change the CRL-loop bug logged
    during the DR (Bao's authenticated paths going flaky after a
    particular sequence of issuer imports). That is a separate item.
    """

    details "Consumer-side cache: what and for how long", ~S"""
    Every read against Bao is a Bao dependency. Two ends of the spectrum:

    - Never cache. Simple, correct, hot dependency on Bao.
    - Cache forever. Wrong for rotating secrets (RFD 2145 leaves at
      90 days; a hot bearer at hour 720 leaks past its rotation).

    The middle: cache for a duration shorter than the shortest thing the
    cached value protects. For a DNS bearer that itself has a Cloudflare
    API-token lifetime, minutes-to-an-hour is safe. For an FDB cluster
    file that changes only on a scale event, an hour is safe. Cache
    should live in the CONSUMER's memory, not on disk, and it should
    refresh on a Bao error by simply retrying rather than by holding the
    stale value.
    """

    details "No CDN proxy in front of workspace services", ~S"""
    Cloudflare's `proxied: true` mode has CF terminating TLS at its edge
    using its Universal SSL cert and re-encrypting to origin. Every byte
    of the request headers and body is plaintext at CF for the round
    trip. CF is not the workspace's tenant. That is a MITM regardless of
    intent, and it is not compatible with services that carry auth
    tokens or hostname-bound credentials.

    Records for services this workspace runs stay `proxied: false`. Edge
    caching, if it is ever needed, lives Fly-side (Fly's own Anycast +
    edge) or origin-side (an in-process cache).

    One record in the `chibifire.com` zone as of 2026-09-01 is
    CF-proxied: `hub-700a.chibifire.com`, pointing at
    `173.180.240.105 / 2001:569:7e58:dd00:...`. That is a personal home
    network endpoint, outside this workspace's scope. If a workspace
    service ever lands under a subdomain that is currently proxied, the
    proxy flag comes off before the service starts serving requests.
    """

    details "Migration path", ~S"""
    Enabling all of this on the live cluster is:

    1. Update `service-openbao/config-fdb.hcl`: `ha_enabled = "true"`,
       pick a `disable_performance_standby` value.
    2. Add seal wrapper config for chosen KMS.
    3. Bring up the KMS account and store its access key as a Fly secret
       on `weftspun-bao` (the ONLY Fly secret that survives; every other
       secret is in Bao itself).
    4. `fly scale count 3 -a weftspun-bao`.
    5. Cycle the machines one at a time; leader election handles the
       handoff.
    6. Retire the manual unseal path in scripts and runbooks (leave the
       Shamir break-glass entry in RFD 2144's DR runbook).

    The blocker between now and step 1 is picking the KMS provider.
    That is a policy question with two implications: cost surface and
    "which cloud can be the workspace's identity trust anchor". Neither
    this RFD nor RFD 2140 has decided.
    """

    details "Sub-decisions open", ~S"""
    - 3 vs 5 replicas. 3 tolerates 1 loss, 5 tolerates 2. Match to FDB.
    - Standbys serve reads (`disable_performance_standby = false`) vs
      forward to leader. Read-heavy workload argues for serving.
    - Which KMS. Cost + trust-anchor decision.
    - Whether to write the CRL-loop fix (a separate bug) into this
      rollout or before it.
    """

    details "Sources", ~S"""
    - OpenBao HA storage docs (FDB backend supports HA via leader
      election on the shared FDB cluster).
    - Vault auto-unseal precedent for the KMS wrapper pattern
      (`cloud kms auto-unseal`, applies unchanged to OpenBao forks).
    - RFD 2140 (Bao on FDB, this raises its ambition), 2144 (defect
      #11: the without-auto-unseal failure mode), 2145 (leaf and CA
      rotation cadence this HA has to survive), 2146 (the capability
      topology this now underwrites).
    """

    drafted_by :ai
  end
end
