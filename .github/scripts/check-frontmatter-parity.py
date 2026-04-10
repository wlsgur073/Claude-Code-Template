#!/usr/bin/env python3
"""Check that EN and ko-KR guide frontmatter version fields match.

Compares each file in docs/guides/ against its counterpart in
docs/i18n/ko-KR/guides/. Fails if any version field differs or if
a ko-KR counterpart is missing.

Exit codes:
    0 - all versions match
    1 - mismatch or missing counterpart found
"""
from __future__ import annotations

import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent.parent
EN_GUIDES = ROOT / "docs" / "guides"
KO_GUIDES = ROOT / "docs" / "i18n" / "ko-KR" / "guides"


def extract_frontmatter(path: Path) -> dict | None:
    raw = path.read_text(encoding="utf-8")
    # Normalize line endings so CRLF files from Windows don't break parsing
    text = raw.replace("\r\n", "\n").replace("\r", "\n")
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---\n", 4)
    if end == -1:
        return None
    return yaml.safe_load(text[4:end])


def main() -> int:
    if not EN_GUIDES.exists():
        print(f"ERROR: {EN_GUIDES} does not exist")
        return 1

    errors: list[str] = []
    checked = 0

    for en_file in sorted(EN_GUIDES.glob("*.md")):
        ko_file = KO_GUIDES / en_file.name
        if not ko_file.exists():
            errors.append(f"[missing ko-KR] {en_file.relative_to(ROOT)}")
            continue

        en_fm = extract_frontmatter(en_file)
        ko_fm = extract_frontmatter(ko_file)

        if en_fm is None:
            errors.append(f"[no frontmatter] {en_file.relative_to(ROOT)}")
            continue
        if ko_fm is None:
            errors.append(f"[no frontmatter] {ko_file.relative_to(ROOT)}")
            continue

        en_ver = en_fm.get("version")
        ko_ver = ko_fm.get("version")
        if en_ver != ko_ver:
            errors.append(
                f"[version mismatch] {en_file.name}: "
                f"EN={en_ver} vs ko-KR={ko_ver}"
            )
        checked += 1

    if errors:
        print("Frontmatter parity errors:")
        for e in errors:
            print(f"  - {e}")
        return 1

    print(f"OK: checked {checked} guide pair(s), all versions match.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
