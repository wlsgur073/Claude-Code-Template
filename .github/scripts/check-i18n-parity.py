#!/usr/bin/env python3
"""Check bidirectional file parity between EN and ko-KR directories.

For each configured (EN, ko-KR) directory pair, ensures every file in
EN has a ko-KR counterpart and vice versa. Reports both missing files
(EN present, ko-KR absent) and orphan files (ko-KR present, EN absent).

Exit codes:
    0 - all directories are in parity
    1 - missing or orphan files found
"""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent

PAIRS: list[tuple[Path, Path]] = [
    (
        ROOT / "docs" / "guides",
        ROOT / "docs" / "i18n" / "ko-KR" / "guides",
    ),
    (
        ROOT / "templates",
        ROOT / "docs" / "i18n" / "ko-KR" / "templates",
    ),
]


def list_relative_files(root: Path) -> set[Path]:
    """Return all files under root as paths relative to root."""
    if not root.exists():
        return set()
    return {
        p.relative_to(root)
        for p in root.rglob("*")
        if p.is_file()
    }


def main() -> int:
    all_errors: list[str] = []
    total_checked = 0

    for en_root, ko_root in PAIRS:
        if not en_root.exists():
            all_errors.append(
                f"[missing directory] {en_root.relative_to(ROOT)}"
            )
            continue

        en_files = list_relative_files(en_root)
        ko_files = list_relative_files(ko_root)

        missing_in_ko = en_files - ko_files
        orphan_in_ko = ko_files - en_files

        for f in sorted(missing_in_ko):
            all_errors.append(
                f"[missing in ko-KR] {(en_root / f).relative_to(ROOT)}"
            )
        for f in sorted(orphan_in_ko):
            all_errors.append(
                f"[orphan in ko-KR] {(ko_root / f).relative_to(ROOT)}"
            )

        total_checked += len(en_files)

    if all_errors:
        print("i18n parity errors:")
        for e in all_errors:
            print(f"  - {e}")
        return 1

    print(
        f"OK: {total_checked} file(s) checked across {len(PAIRS)} pair(s), "
        f"bidirectional parity confirmed."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
