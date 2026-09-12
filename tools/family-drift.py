#!/usr/bin/env python3
"""Family drift gate: the copy-inheritance smoke detector.

A family of sibling repositories often starts by copying shared organs from
one member to the next. Copies rot. A fix that lands in two siblings and
misses the third produces no error, no warning, and no failing test: it shows
up only on the day someone goes looking. This gate goes looking on a schedule
instead.

It compares the family members three ways:

1. Text organs (files meant to stay verbatim across the family): compared
   after normalizing each member's own identity tokens, so only structural
   differences remain. IDENT (equal after normalization), NEAR (a small diff,
   shown line by line), or DRIFT (large diff, counted). Python organs are
   also fingerprinted through the AST with docstrings dropped, so a comment
   only difference reads as code-identical and the prose delta is reported
   separately.
2. Feature probes on the adapted organs: a feature present in two siblings
   and absent in the third is a finding (the lesson-did-not-travel rule).
3. Config posture: dependency pins and static-analysis settings.

Standard library only, read-only, exit 0 always. It reports; a person judges.
Markdown goes to stdout, so the output drops into a report or a log.

Configuration, all through the environment:
  FAMILY_ROOT  parent directory of the family members. Default: $HOME/code
  FAMILY_APPS  space separated member names.           Default: alpha beta gamma

Each member is FAMILY_ROOT/<name>. The organ list and the probe sets below are
a worked example taken from one family of desktop applications that share a
database layer by copy; edit them for yours.

Floor: no em dashes, no ellipses. This file is an artifact.
"""

from __future__ import annotations

import ast
import difflib
import os
import re
import subprocess
from datetime import date
from pathlib import Path

APPS = os.environ.get("FAMILY_APPS", "alpha beta gamma").split()
ROOT = Path(os.environ.get("FAMILY_ROOT", Path.home() / "code"))
REPOS = {app: ROOT / app for app in APPS}

# Extra per-member phrases to neutralize before comparing, beyond the member
# name itself. A phrase that appears in one member's prose but is only a label
# difference should not drive a NOISE verdict. Example:
#   IDENTITY_PHRASES = {"alpha": ["Alpha Tool", "alpha.db", "alpha ADR"]}
IDENTITY_PHRASES: dict[str, list[str]] = {}

NEAR_LIMIT = 12  # normalized diff lines at or under this = NEAR, above = DRIFT

# Paths are relative to each member's root. These are meant to stay verbatim.
TEXT_ORGANS = [
    ("name_match.py", "core/name_match.py"),
    ("fiscal.py", "core/fiscal.py"),
    ("backup.py", "core/backup.py"),
    ("check_environment.py", "check_environment.py"),
    ("CHECK_ENV.bat", "CHECK_ENV.bat"),
    ("SETUP.bat", "SETUP.bat"),
    ("START_APP.bat", "START_APP.bat"),
]

# Probes over the adapted organs: features that should travel with the family.
DB_PROBES = [
    ("busy_timeout pragma", r"busy_timeout"),
    ("journal-mode resolver", r"_resolve_journal_mode"),
    ("journal env override", r"_JOURNAL_MODE"),
    ("mapped-drive detection", r"GetDriveTypeW"),
    ("create guard", r"DatabaseNotFoundError"),
    ("initialize_new", r"def initialize_new"),
    ("public read_conn", r"def read_conn"),
    ("snapshot publish", r"VACUUM INTO"),
    ("checkpoint before publish", r"wal_checkpoint"),
    ("unique snapshot temp", r"getpid|monotonic_ns"),
    ("UTC stamps", r"datetime\.now\(tz=|datetime\.now\(UTC|now\(UTC\)"),
]

DB_ANTI_PROBES = [
    ("naive local timestamps", r"datetime\.now\(\)\.isoformat"),
    ("column RENAME migration", r"RENAME COLUMN"),
]

SETTINGS_PROBES = [
    ("atomic config write", r"os\.replace"),
]


def norm_text(text: str, app: str) -> list[str]:
    """Neutralize member-identity tokens so only structure differences remain."""
    for phrase in IDENTITY_PHRASES.get(app, []):
        text = text.replace(phrase, "{IDENTITY}")
    text = re.sub(rf"\b{re.escape(app)}\b", "{IDENTITY}", text, flags=re.IGNORECASE)
    lines = [ln.rstrip() for ln in text.splitlines()]
    return [ln for ln in lines if ln.strip()]


def code_fingerprint(text: str, app: str) -> str | None:
    """AST dump with docstrings stripped and member tokens neutralized.

    Two Python organs with equal fingerprints are code-identical even when
    comments, docstrings, or formatting differ; prose deltas then ride in the
    note instead of driving the verdict.
    """
    text = re.sub(rf"\b{re.escape(app)}\b", "xx", text, flags=re.IGNORECASE)
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return None
    for node in ast.walk(tree):
        body = getattr(node, "body", None)
        if (
            isinstance(node, (ast.Module, ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef))
            and body
            and isinstance(body[0], ast.Expr)
            and isinstance(body[0].value, ast.Constant)
            and isinstance(body[0].value.value, str)
        ):
            body[0].value.value = ""
    return ast.dump(tree, annotate_fields=False)


def head(repo: Path) -> str:
    try:
        out = subprocess.run(
            ["git", "-C", str(repo), "rev-parse", "--short", "HEAD"],
            capture_output=True, text=True, timeout=10,
        )
        return out.stdout.strip() or "?"
    except Exception:
        return "?"


def compare_text_organ(label: str, rel: str) -> tuple[str, list[str]]:
    """Return (verdict line, detail lines) for one text organ."""
    contents: dict[str, list[str] | None] = {}
    raw: dict[str, str] = {}
    for app, repo in REPOS.items():
        path = repo / rel
        if path.exists():
            raw[app] = path.read_text(encoding="utf-8", errors="replace")
            contents[app] = norm_text(raw[app], app)
        else:
            contents[app] = None
    present_lines: dict[str, list[str]] = {}
    absent: list[str] = []
    for a, c in contents.items():
        if c is None:
            absent.append(a)
        else:
            present_lines[a] = c
    present = sorted(present_lines)
    details: list[str] = []
    if len(present) < 2:
        return (f"| {label} | absent in {', '.join(absent) or 'n/a'} | organ not shared |", details)
    is_python = rel.endswith(".py")
    prints: dict[str, str | None] = (
        {a: code_fingerprint(raw[a], a) for a in present} if is_python else {}
    )
    pairs = [(a, b) for i, a in enumerate(present) for b in present[i + 1:]]
    per_pair: dict[str, int] = {}
    code_equal: dict[str, bool] = {}
    for a, b in pairs:
        diff = list(difflib.unified_diff(present_lines[a], present_lines[b], lineterm="", n=0))
        changed = [d for d in diff if d[:1] in "+-" and d[:3] not in ("+++", "---")]
        per_pair[f"{a}/{b}"] = len(changed)
        if is_python and prints.get(a) and prints.get(b):
            code_equal[f"{a}/{b}"] = prints[a] == prints[b]
            if code_equal[f"{a}/{b}"] and changed:
                per_pair[f"{a}/{b}"] = 0
                details.append(
                    f"  - {label} {a} vs {b}: code-identical by AST; "
                    f"{len(changed)} prose or comment lines differ"
                )
                continue
        if changed and len(changed) <= NEAR_LIMIT:
            details.append(f"  - {label} {a} vs {b} ({len(changed)} lines):")
            details.extend(f"      {d}" for d in changed[:NEAR_LIMIT])
        elif changed:
            details.append(f"  - {label} {a} vs {b}: {len(changed)} normalized lines differ")
    absent_note = f"; absent in {', '.join(absent)}" if absent else ""
    best = min(per_pair.values())
    worst = max(per_pair.values())
    if best == 0:
        verdict = "IDENT"
    elif best <= NEAR_LIMIT:
        verdict = "NEAR"
    else:
        verdict = "DRIFT"
    if worst > NEAR_LIMIT >= best:
        clean_pair = min(per_pair, key=lambda k: per_pair[k])
        laggard = (set(present) - set(clean_pair.split("/"))).pop()
        verdict += f" core; {laggard} lags"
    pair_note = ", ".join(f"{k} {v}" for k, v in sorted(per_pair.items()))
    return (f"| {label} | {verdict}{absent_note} | {pair_note} |", details)


def probe(rel: str, probes: list[tuple[str, str]], anti: bool = False) -> list[str]:
    """2-of-N rule findings for regex feature probes over one file per member."""
    texts = {}
    for app, repo in REPOS.items():
        path = repo / rel
        texts[app] = path.read_text(encoding="utf-8", errors="replace") if path.exists() else ""
    findings = []
    for label, pattern in probes:
        have = sorted(a for a, t in texts.items() if re.search(pattern, t))
        missing = sorted(set(texts) - set(have))
        if anti:
            if have:
                findings.append(f"- {label}: PRESENT in {', '.join(have)} (siblings clean)")
        elif len(have) >= 2 and missing:
            findings.append(f"- {label}: present in {', '.join(have)}; ABSENT in {', '.join(missing)}")
        elif len(have) == 1:
            findings.append(f"- {label}: only {have[0]} has it (candidate to travel)")
    return findings


def requirements_posture() -> list[str]:
    notes = []
    for app, repo in REPOS.items():
        path = repo / "requirements.txt"
        if not path.exists():
            notes.append(f"- {app}: requirements.txt MISSING")
            continue
        uncapped, names = [], set()
        for raw in path.read_text().splitlines():
            line = raw.split("#", 1)[0].strip()
            if not line:
                continue
            name = re.split(r"[<>=!~\[; ]", line, maxsplit=1)[0].lower()
            names.add(name)
            if "==" not in line and "<" not in line:
                uncapped.append(name)
        missing_dev = sorted({"mypy", "ruff", "pytest"} - names)
        if uncapped:
            notes.append(f"- {app}: uncapped deps: {', '.join(uncapped)}")
        if missing_dev:
            notes.append(f"- {app}: dev pins missing: {', '.join(missing_dev)}")
    return notes


def tooling_posture() -> list[str]:
    notes = []
    strict, selects = {}, {}
    for app, repo in REPOS.items():
        pyproject = repo / "pyproject.toml"
        text = pyproject.read_text() if pyproject.exists() else ""
        strict[app] = bool(re.search(r"^strict\s*=\s*true", text, re.M))
        m = re.search(r"select\s*=\s*\[([^\]]*)\]", text)
        selects[app] = m.group(1).replace('"', "").replace(" ", "") if m else "?"
    lax = sorted(a for a, s in strict.items() if not s)
    if lax:
        notes.append(f"- mypy strict=true absent in: {', '.join(lax)}")
    if len(set(selects.values())) > 1:
        for app, sel in sorted(selects.items()):
            notes.append(f"- ruff select {app}: {sel}")
    return notes


def main() -> int:
    heads = ", ".join(f"{a} {head(r)}" for a, r in sorted(REPOS.items()))
    print(f"## Family drift gate: {date.today().isoformat()}")
    print()
    missing = [(a, r) for a, r in sorted(REPOS.items()) if not r.exists()]
    if missing:
        # A gate that cannot find its subjects must say so. Absent-everything
        # is not a clean bill of health, it is a misconfiguration wearing one.
        print("**GATE BLIND: configured repo paths do not exist.** Every verdict")
        print("below is an artifact of the bad path, not a finding about the code.")
        print("Fix FAMILY_ROOT or FAMILY_APPS and rerun before trusting a line of it.")
        print()
        for app, repo in missing:
            print(f"- missing: {app} -> {repo}")
        print()
    print(f"Repos at: {heads}. Rule: a feature two siblings hold and one lacks")
    print("is a finding; text organs compare after member-token normalization.")
    print()
    print("| organ | verdict | note |")
    print("|---|---|---|")
    all_details: list[str] = []
    counts = {"IDENT": 0, "NEAR": 0, "DRIFT": 0}
    for label, rel in TEXT_ORGANS:
        row, details = compare_text_organ(label, rel)
        print(row)
        for k in counts:
            if f"| {k}" in row:
                counts[k] += 1
        all_details.extend(details)
    print()
    findings = probe("core/db_manager.py", DB_PROBES)
    findings += probe("core/db_manager.py", DB_ANTI_PROBES, anti=True)
    findings += probe("core/settings.py", SETTINGS_PROBES)
    findings += requirements_posture()
    findings += tooling_posture()
    print(f"Verdict: {counts['IDENT']} ident, {counts['NEAR']} near, "
          f"{counts['DRIFT']} drift, {len(findings)} probe findings.")
    print()
    if findings:
        print("Probe findings (2-of-N rule and posture):")
        for f in findings:
            print(f)
        print()
    if all_details:
        print("Near-diff detail:")
        for d in all_details:
            print(d)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
