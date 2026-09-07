# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 1080. `mix rfd.render` renders rfd/1080-fly-deploy-cost/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD1080 do
  use RFD.DSL

  rfd 1080, "What the three Fly deploys cost" do
    state :published

    scope "the deploy target"

    attest_in :none

    decision ~S"""
    Record it, from Fly's own published pricing page, against this
    deployment's own real machine sizes, checked live with `flyctl`, not
    estimated. See `DETAILS.md` for the full breakdown.

    **Total: $0.012845/hour, $9.26/month, $111.12/year**, at today's
    sizes: three `shared-cpu-1x` machines (two 512MB, one 256MB, the
    last scaled from Fly's default 2-machine HA pair to one), a 3GB
    Volume, and a 1GB Volume.

    Not included: outbound bandwidth (usage-based, has a free tier
    before per-GB billing), and any future Tigris usage RFD 1073's
    still-open fetch-path work would add.
    """

    problem ~S"""
    `weftspun-studio`, `weftspun-character-taxonomy`, and
    `weftspun-usd-viewer` all run as real, billed Fly Machines and
    Volumes now. No record states what that costs, hourly, monthly, or
    yearly.
    """

    related ~S"""
    RFD 1062 gives the Fly.io toplevel. RFD 1076 gives the `apps/` split
    across three Fly apps. RFD 1079 gives `versitygw`'s removal, no
    change to this total since it ran inside an already-billed machine.
    """

    details_title "What the three Fly deploys cost"

    details "Source prices", ~S"""
    From `fly.io/docs/about/pricing/`, the published rates this
    breakdown uses directly:

    | Resource               | Per-second  | Per-month |
    | ---------------------- | ----------- | --------- |
    | `shared-cpu-1x`, 256MB | $0.00000078 | $2.02     |
    | `shared-cpu-1x`, 512MB | $0.00000128 | $3.32     |
    | Volume storage         |,           | $0.15/GB  |

    Hourly = per-second × 3600. Yearly = per-month × 12, the number Fly
    itself bills against, not hourly × 8760 (the two differ slightly
    because a month is not exactly 730 hours; the per-month figure is
    the one Fly actually charges).
    """

    details "This deployment's real sizes, checked live", ~S"""
    `flyctl machine list` and `flyctl volumes list`, run against all
    three apps, the same session these prices apply to:

    | App                           | Machine(s)                | Volume |
    | ----------------------------- | ------------------------- | ------ |
    | `weftspun-studio`             | 1× `shared-cpu-1x`, 512MB | 3GB    |
    | `weftspun-character-taxonomy` | 1× `shared-cpu-1x`, 512MB | 1GB    |
    | `weftspun-usd-viewer`         | 1× `shared-cpu-1x`, 256MB | none   |

    `weftspun-usd-viewer` started as Fly's default 2-machine HA pair
    (zero-downtime deploys); scaled to one (`min_machines_running = 0`
    in its own `fly.toml`, then `flyctl scale count 1`) per the user's
    own choice of cost over restart-window downtime.

    No dedicated IPv4 anywhere (checked with `flyctl ips list` against
    all three apps): only shared IPv4 and free dedicated IPv6, so no
    extra per-app IP charge applies.
    """

    details "The breakdown, hourly / monthly / yearly", ~S"""
    | App                                        | Hourly        | Monthly   | Yearly      |
    | ------------------------------------------ | ------------- | --------- | ----------- |
    | `weftspun-studio` (machine)                | $0.004608     | $3.32     | $39.84      |
    | `weftspun-studio` (3GB volume)             | $0.000616     | $0.45     | $5.40       |
    | `weftspun-character-taxonomy` (machine)    | $0.004608     | $3.32     | $39.84      |
    | `weftspun-character-taxonomy` (1GB volume) | $0.000205     | $0.15     | $1.80       |
    | `weftspun-usd-viewer` (machine)            | $0.002808     | $2.02     | $24.24      |
    | **Total**                                  | **$0.012845** | **$9.26** | **$111.12** |

    Volume hourly figures divide the monthly rate by 730 (Fly's own
    average hours-per-month), since Fly bills Volumes monthly, not
    per-second; machine hourly figures are the real per-second billing
    rate × 3600, both shown for a like-for-like row.
    """

    details "What this excludes", ~S"""
    - **Outbound bandwidth.** Usage-based, not a fixed size like a
      Machine or a Volume. Fly's free tier covers a baseline before
      per-GB egress billing starts; this deployment's actual traffic
      was not measured this session.
    - **Tigris.** RFD 1073's still-open fetch-path work (`apps/usd_viewer_app/`
      fetching gallery assets from Tigris instead of baking them into
      its own image) would add real, usage-based storage and bandwidth
      cost once built. Not yet built, so not yet billed, so not in this
      total.
    - **`taskweft-mcp`**, a fourth already-deployed Fly app in the same
      org, unrelated to the three this RFD scopes (`weftspun-studio`,
      `weftspun-character-taxonomy`, `weftspun-usd-viewer`). Its own
      cost is real but out of this RFD's scope.
    """

    drafted_by :ai
  end
end
