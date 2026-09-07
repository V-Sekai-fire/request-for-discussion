# RFD 2142: Zero-trust service TLS via OpenBao PKI
**State:** discussion
**Feature:** mTLS on the bao listener and cert-based service auth
**Scope:** weftspun-bao, spot-broker, weft-warp-burrito

## Decision

Implemented 2026-09-01; see RFD 2146 for the role/policy map.

`DETAILS.md` carries the full text of this RFD.

## Problem

Services on 6PN read secrets from bao over plaintext HTTP. The root
token in 1Password is for emergencies; sharing it with services is
the credential distribution problem bao exists to solve. Any 6PN
neighbor can observe or modify traffic to the listener.

## Related

RFD 2140 (bao on FDB), RFD 2141 (FDB TLS rotation).
