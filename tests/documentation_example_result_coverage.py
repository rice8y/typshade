#!/usr/bin/env python3
"""Ensure the public API catalog pairs sample code with typeset results."""

from __future__ import annotations

import re
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
            if match and not match.group(1).startswith("_"):
                names.add(match.group(1))
    return sorted(names)


def catalog_text(doc: str) -> str:
    try:
        catalog = doc.split("= Public API Example Catalog", 1)[1]
    except IndexError:
        raise SystemExit("Could not find Public API Example Catalog section.")
    return catalog.split("\n= Typst-Specific Improvements", 1)[0]


def sections_missing_results(doc: str) -> list[str]:
    sections: list[tuple[str, list[str]]] = []
    title = "<preamble>"
    body: list[str] = []
    for line in doc.splitlines():
        if line.startswith("="):
            sections.append((title, body))
            title = line.strip()
            body = []
        body.append(line)
    sections.append((title, body))

    missing: list[str] = []
    for title, body in sections:
        text = "\n".join(body)
        if "```typst" in text and "#example-result" not in text and "#result-panel" not in text:
            missing.append(title)
    return missing


def main() -> int:
    doc = DOC.read_text(encoding="utf-8")
    catalog = catalog_text(doc)
    missing_names = [
        name
        for name in public_names()
        if re.search(rf"\b{re.escape(name)}\s*\(", catalog) is None
    ]
    missing_pairs: list[str] = []
    for raw_section in re.split(r"\n==\s+", catalog)[1:]:
        title, _, body = raw_section.partition("\n")
        if "```typst" not in body or "#example-result" not in body:
            missing_pairs.append(title.strip())
    missing_section_results = sections_missing_results(doc)
    if missing_names:
        print("Public names missing from Public API Example Catalog:")
        for name in missing_names:
            print(f"- {name}")
    if missing_pairs:
        print("Catalog subsections missing sample code or typeset result:")
        for title in missing_pairs:
            print(f"- {title}")
    if missing_section_results:
        print("Documentation sections with Typst sample code but no typeset result:")
        for title in missing_section_results:
            print(f"- {title}")
    if missing_names or missing_pairs or missing_section_results:
        return 1
    print(
        f"OK: Public API catalog covers {len(public_names())} names with code/result subsections; "
        "all Typst sample sections include typeset results."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
