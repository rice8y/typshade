#!/usr/bin/env python3
"""Verify that every exported public Typshade function has a documentation example."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs" / "documentation.typ"
PUBLIC_SOURCES = (
    ROOT / "package" / "internal" / "interface" / "annotations.typ",
    ROOT / "package" / "internal" / "interface" / "analysis.typ",
    ROOT / "package" / "internal" / "interface" / "controls.typ",
    ROOT / "package" / "internal" / "interface" / "data.typ",
    ROOT / "package" / "internal" / "interface" / "inspect.typ",
    ROOT / "package" / "internal" / "interface" / "presets.typ",
    ROOT / "package" / "internal" / "interface" / "recipes.typ",
    ROOT / "package" / "internal" / "interface" / "selection.typ",
    ROOT / "package" / "internal" / "interface" / "shade.typ",
    ROOT / "package" / "internal" / "interface" / "shortcuts.typ",
    ROOT / "package" / "internal" / "interface" / "tracks.typ",
    ROOT / "package" / "internal" / "model" / "palette.typ",
)


def public_names() -> list[str]:
    names: set[str] = set()
    pattern = re.compile(r"^#let\s+([A-Za-z][A-Za-z0-9_-]*)\s*\(")
    for path in PUBLIC_SOURCES:
        for line in path.read_text(encoding="utf-8").splitlines():
            match = pattern.match(line)
            if match:
                name = match.group(1)
                if not name.startswith("_"):
                    names.add(name)
    return sorted(names)


def has_example(doc: str, name: str) -> bool:
    # Prefer real invocation examples. For value-only helpers such as resolve-color,
    # a binding like `#let c = resolve-color(...)` is still an invocation.
    return re.search(rf"\b{re.escape(name)}\s*\(", doc) is not None


def main() -> int:
    doc = DOC.read_text(encoding="utf-8")
    missing = [name for name in public_names() if not has_example(doc, name)]
    if missing:
        print("Public functions missing documentation examples:", file=sys.stderr)
        for name in missing:
            print(f"- {name}", file=sys.stderr)
        return 1
    print(f"OK: {len(public_names())} public Typshade functions have documentation examples.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
