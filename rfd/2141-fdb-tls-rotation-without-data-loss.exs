# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT
#
# RFD 2141. `mix rfd.render` in rfd_dsl/ renders rfd/2141-fdb-tls-rotation-without-data-loss/README.md and
# DETAILS.md from this file; the Markdown is a build artifact (RFD 2232).
defmodule RFD2141 do
  use RFD.DSL

  rfd 2141, "FDB TLS rotation without data loss" do
    state :prediscussion

    feature "rotate the private CA and all leaf certificates on the live cluster"

    scope "weftspun-fdb (3 machines, double), weftspun-bao (FDB client)"

    attest_in :none

    decision ~S"""
    A three-phase rolling rotation using FDB's automatic TLS certificate
    refresh. The cluster stays available and data stays intact at every
    step; each phase is gated on `fdbcli status` reporting healthy.

    **Phase 1 (dual-CA trust).** Generate a new CA with the RFD 2134
    profile. Set `FDB_TLS_CA_B64` to old + new CAs concatenated. Rolling
    restart. Every machine trusts certs from either CA.

    **Phase 2 (new leaves).** Mint new certs under the new CA for all
    three machines and for bao (`fdb-bao.chibifire.com`). Replace each
    machine's cert/key secrets. Rolling restart.

    **Phase 3 (drop old CA).** Set `FDB_TLS_CA_B64` to the new CA only.
    Rolling restart. Store the new CA key in bao and in 1Password.

    The cluster file does not change (addresses keep `:tls`), so no
    coordinator reset is needed.

    The rotation tool is an Elixir TUI in weft-warp-burrito, packaged
    via Burrito. It walks the phases, gates each on cluster health, and
    stores the CA key on completion. The procedure is in DETAILS.md.
    """

    problem ~S"""
    The CA private key from RFD 2134 is not recoverable, so no new leaf
    can be issued. bao needs a client cert, and the machine certs expire
    in two years. RFD 2134's reset path wipes data, which was acceptable
    at initial setup and is not acceptable now.
    """

    related ~S"""
    RFD 2134 (initial TLS), RFD 2140 (OpenBao on FDB).
    """

    details_title "FDB TLS rotation without data loss"

    details "Why the old CA key is not recoverable", ~S"""
    The CA was generated during the RFD 2134 session. The key file
    existed in a session scratchpad (`/private/tmp/claude-502/...`) that
    was cleaned up when the session ended. It was never committed to a
    repo (correctly; a CA key does not go in source control), never
    uploaded to 1Password, and never stored as a Fly secret. The
    1Password item `OpenBao FDB CA` contains the raft-based bao init
    JSON, not the CA material.

    The CA certificate (public half) is stored as `FDB_TLS_CA_B64` on
    weftspun-fdb. The private half is lost. Without it, no new leaf
    certificate can be signed, and the cluster cannot admit a new TLS
    peer.
    """

    details "Why a reset is not needed", ~S"""
    RFD 2134 states: "there is no in-place path from a plaintext cluster
    to a TLS one." That is about the coordinator addresses on disk, which
    carry a `:tls` suffix that plaintext addresses lack. A rotation from
    one TLS identity to another does not change the addresses. The
    `:tls` suffix stays, so the coordinated state on disk remains valid.

    FoundationDB's TLS certificate refresh (documented in `tls.rst`,
    knob `tls-cert-refresh-delay-seconds`, default enabled) reloads the
    cert, key, and CA files from disk when their mtime changes. The
    entrypoint writes these files from Fly secrets at startup, so a
    `fly secrets set` followed by a machine restart delivers the new
    material.
    """

    details "The rotation in three phases", ~S"""
    ### Prerequisites

    The existing CA certificate, extracted from any running machine:

        fly ssh console -a weftspun-fdb \
          -C "cat /etc/foundationdb/tls/ca.pem"

    ### Phase 1: dual-CA trust bundle

    The `-days 3650` (10 years) on the CA below was retracted by
    RFD 2145 on 2026-09-01. Current guidance: 25-year `notAfter` on the
    offline root with 5-year policy rotation; run the command with
    `-days 9125` and schedule the ceremony date in the anti-entropy
    check. Kept in place because a reader working from the earlier text
    should see the change and where it went.

    Generate the new CA:

        openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 \
          -out new-ca.key
        openssl req -new -x509 -key new-ca.key -days 3650 \
          -subj "/CN=fdb-ca.chibifire.com" \
          -addext "basicConstraints=critical,CA:true" \
          -addext "keyUsage=critical,keyCertSign,cRLSign" \
          -addext "subjectKeyIdentifier=hash" \
          -out new-ca.pem

    Concatenate old + new CA into a bundle:

        cat old-ca.pem new-ca.pem > bundle-ca.pem
        base64 -w0 bundle-ca.pem > bundle-ca.b64

    Set the dual-CA bundle on all three machines:

        fly secrets set FDB_TLS_CA_B64="$(cat bundle-ca.b64)" \
          -a weftspun-fdb --stage
        fly deploy -a weftspun-fdb --strategy rolling

    Verify: `fdbcli status` reports healthy, entrypoint logs
    "2 self-signed anchor(s)".

    ### Phase 2: new leaf certificates

    For each machine ID (`807130c6674168`, `84e696a22e0308`,
    `84e69ef2251558`) and for bao (`bao`):

        CN="fdb-${MID}.chibifire.com"   # or fdb-bao.chibifire.com
        openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 \
          -out "${MID}.key"
        openssl req -new -key "${MID}.key" -subj "/CN=${CN}" \
          -out "${MID}.csr"
        openssl x509 -req -in "${MID}.csr" -CA new-ca.pem -CAkey new-ca.key \
          -CAcreateserial -days 730 \
          -extfile <(printf 'basicConstraints=CA:false\n\
    keyUsage=critical,digitalSignature,keyEncipherment\n\
    extendedKeyUsage=serverAuth,clientAuth\n\
    subjectKeyIdentifier=hash\n\
    authorityKeyIdentifier=keyid,issuer\n') \
          -out "${MID}.pem"

    Set each machine's cert and key:

        fly secrets set \
          "FDB_TLS_CERT_${MID}_B64=$(base64 -w0 ${MID}.pem)" \
          "FDB_TLS_KEY_${MID}_B64=$(base64 -w0 ${MID}.key)" \
          -a weftspun-fdb --stage
        fly deploy -a weftspun-fdb --strategy rolling

    After all three machines are rolled, set the bao client cert:

        fly secrets set \
          FDB_TLS_CERT_B64="$(base64 -w0 bao.pem)" \
          FDB_TLS_KEY_B64="$(base64 -w0 bao.key)" \
          FDB_TLS_CA_B64="$(cat bundle-ca.b64)" \
          -a weftspun-bao

    Verify: `fdbcli status` healthy, bao can reach the cluster.

    ### Phase 3: drop old CA

        base64 -w0 new-ca.pem > new-ca.b64
        fly secrets set FDB_TLS_CA_B64="$(cat new-ca.b64)" \
          -a weftspun-fdb --stage
        fly deploy -a weftspun-fdb --strategy rolling

        fly secrets set FDB_TLS_CA_B64="$(cat new-ca.b64)" \
          -a weftspun-bao

    Verify: `fdbcli status` healthy, 1 self-signed anchor.

    ### Store the new CA key

        # In bao (once bao reconnects with its new client cert):
        bao kv put secret/fdb/ca-key \
          ca_key_pem="$(cat new-ca.key)" \
          ca_pem="$(cat new-ca.pem)"

        # In 1Password:
        op document create new-ca.key \
          --title "weftspun-fdb CA private key" \
          --vault Private --tags weftspun,fdb,tls

        # Then delete from disk:
        shred -u new-ca.key *.key *.csr
    """

    details "Rollback at each phase", ~S"""
    If `fdbcli status` degrades after a phase:

    - **Phase 1 fails:** revert `FDB_TLS_CA_B64` to the old CA only,
      rolling restart. The cluster returns to its previous state.
    - **Phase 2 fails on one machine:** revert that machine's cert/key
      secrets to the old values, restart. The dual-CA bundle still
      trusts the old cert.
    - **Phase 3 fails:** revert `FDB_TLS_CA_B64` to the dual bundle,
      rolling restart.

    No phase touches data directories, coordinator addresses, or the
    cluster configuration. Every rollback is a secret change and a
    restart.
    """

    details "What this does NOT cover", ~S"""
    - **Tigris S3 credentials.** The backup agent's AWS key pair is
      separate from TLS and not rotated here.
    - **Verify-peers rule.** The rule
      `Check.Valid=1,S.CN>=fdb-,S.CN<=.chibifire.com` does not change;
      all new certs use the same CN namespace.
    """

    drafted_by :ai
  end
end
