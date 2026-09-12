"""Gate: the rulesets the working agreements describe are the rulesets the repository has.

Reads the claimed ids out of CLAUDE.md and PITFALLS.md rather than restating them.

Usage:
    python check_rulesets.py [--repo owner/name]
    python check_rulesets.py --self-test
"""

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOCS = ("CLAUDE.md", "PITFALLS.md")

CLAIM = re.compile(r"ruleset\s*\(?\s*(?:id\s*)?(\d{5,})", re.I)


def claimed_ids(texts):
    found = {}
    for name, text in texts.items():
        for m in CLAIM.finditer(text):
            found.setdefault(int(m.group(1)), []).append(name)
    return found


def live_rulesets(repo):
    """Ids the repository carries, or None when the API cannot be read."""
    r = subprocess.run(
        ["gh", "api", f"repos/{repo}/rulesets", "--paginate"],
        capture_output=True, text=True,
    )
    if r.returncode != 0:
        return None, r.stderr.strip().splitlines()[-1:] or ["gh api failed"]
    try:
        return {int(x["id"]): x.get("name", "") for x in json.loads(r.stdout)}, []
    except (ValueError, KeyError, TypeError) as exc:
        return None, [f"unparseable ruleset payload: {exc}"]


def report(claims, live):
    rows = []
    for rid, docs in sorted(claims.items()):
        where = ", ".join(sorted(set(docs)))
        if rid in live:
            rows.append((True, rid, f"named by {where}, present as {live[rid]!r}"))
        else:
            rows.append((False, rid, f"named by {where}, absent from the repository"))
    return rows


def self_test():
    controls = []

    texts = {"CLAUDE.md": "the merge queue on this repo (ruleset 21131040, `MERGE` method)"}
    controls.append(("an id in prose is read", claimed_ids(texts) == {21131040: ["CLAUDE.md"]}))

    texts = {"PITFALLS.md": "main ruleset (id 21131040) enables `merge_queue`"}
    controls.append(("the parenthesised form is read", 21131040 in claimed_ids(texts)))

    controls.append(("prose naming no ruleset yields no claim",
                     claimed_ids({"CLAUDE.md": "the merge queue batches ALLGREEN PRs"}) == {}))

    claims = {21131040: ["CLAUDE.md"]}
    controls.append(("a present ruleset passes",
                     report(claims, {21131040: "main"})[0][0] is True))
    controls.append(("  control: an absent ruleset fails",
                     report(claims, {})[0][0] is False))
    controls.append(("  control: a different id does not satisfy the claim",
                     report(claims, {99999999: "main"})[0][0] is False))

    ok = all(passed for _, passed in controls)
    for label, passed in controls:
        print(f"  {'ok  ' if passed else 'FAIL'} {label}")
    print(f"\n{'ok   ' if ok else 'FAIL '}{len(controls)} controls, both directions")
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default="V-Sekai-fire/request-for-discussion")
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args()

    if args.self_test:
        return self_test()

    texts = {}
    for name in DOCS:
        p = ROOT / name
        if not p.is_file():
            print(f"FAIL {name} is absent; the claims cannot be read")
            return 1
        texts[name] = p.read_text(encoding="utf-8")

    claims = claimed_ids(texts)
    if not claims:
        print(f"ok   {len(DOCS)} document(s) name no ruleset, so nothing is claimed")
        return 0

    live, errs = live_rulesets(args.repo)
    if live is None:
        # Rule 3: an unmet precondition is a FAIL, named, never a silent skip.
        print(f"FAIL cannot read {args.repo} rulesets, so {len(claims)} claim(s) go unchecked")
        for e in errs:
            print(f"     {e}")
        return 1

    rows = report(claims, live)
    for ok, rid, detail in rows:
        print(f"  {'ok  ' if ok else 'FAIL'} ruleset {rid}  {detail}")
    bad = [r for r in rows if not r[0]]
    print(f"\n{len(rows)} claimed, {len(live)} live on {args.repo}, {len(bad)} unhonoured")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
