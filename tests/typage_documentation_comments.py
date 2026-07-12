#!/usr/bin/env python3
"""Verify the documentation comments consumed by typage-plugin-typst-docs."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TYP_DIRS = (ROOT / "package", ROOT / "examples", ROOT / "docs", ROOT / "tests")
PUBLIC_LET = re.compile(r"^#let\s+([A-Za-z][A-Za-z0-9-]*)")
PARAM_DOC = re.compile(r"^\s*///\s+-\s+`?([A-Za-z][A-Za-z0-9-]*)`?(?:\s+\([^)]*\))?:")


def typ_files() -> list[Path]:
    return sorted(path for directory in TYP_DIRS for path in directory.rglob("*.typ"))


def signature_at(lines: list[str], start: int) -> tuple[str, int]:
    parts: list[str] = []
    paren = bracket = brace = 0
    in_string = False
    previous = ""
    for index in range(start, min(len(lines), start + 80)):
        line = lines[index]
        for offset, char in enumerate(line):
            if char == '"' and previous != "\\":
                in_string = not in_string
            if not in_string:
                if char == "(":
                    paren += 1
                elif char == ")":
                    paren -= 1
                elif char == "[":
                    bracket += 1
                elif char == "]":
                    bracket -= 1
                elif char == "{":
                    brace += 1
                elif char == "}":
                    brace -= 1
                elif char == "=" and paren == bracket == brace == 0:
                    parts.append(line[:offset])
                    return "\n".join(parts), index
            previous = char
        parts.append(line)
    return lines[start], start


def split_top_level(raw: str) -> list[str]:
    parts: list[str] = []
    start = 0
    paren = bracket = brace = 0
    in_string = False
    previous = ""
    for index, char in enumerate(raw):
        if char == '"' and previous != "\\":
            in_string = not in_string
        if not in_string:
            if char == "(":
                paren += 1
            elif char == ")":
                paren -= 1
            elif char == "[":
                bracket += 1
            elif char == "]":
                bracket -= 1
            elif char == "{":
                brace += 1
            elif char == "}":
                brace -= 1
            elif char == "," and paren == bracket == brace == 0:
                parts.append(raw[start:index])
                start = index + 1
        previous = char
    parts.append(raw[start:])
    return parts


def parameter_names(signature: str, name: str) -> list[str]:
    marker = f"{name}("
    open_index = signature.find(marker)
    if open_index < 0:
        return []
    start = open_index + len(marker)
    depth = 1
    in_string = False
    previous = ""
    end = start
    for end in range(start, len(signature)):
        char = signature[end]
        if char == '"' and previous != "\\":
            in_string = not in_string
        if not in_string:
            if char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    break
        previous = char
    names: list[str] = []
    for raw in split_top_level(signature[start:end]):
        match = re.match(r"\s*\.\.\s*([A-Za-z][A-Za-z0-9-]*)|\s*([A-Za-z][A-Za-z0-9-]*)", raw)
        if match:
            names.append(match.group(1) or match.group(2))
    return names


def doc_lines_before(lines: list[str], declaration: int) -> list[str]:
    index = declaration - 1
    docs: list[str] = []
    while index >= 0:
        stripped = lines[index].strip()
        if stripped.startswith("///"):
            docs.append(lines[index])
        elif stripped == "" or stripped.startswith("//"):
            pass
        else:
            break
        index -= 1
    docs.reverse()
    return docs


def main() -> int:
    failures: list[str] = []
    symbols = 0
    parameters = 0
    files = typ_files()

    for path in files:
        lines = path.read_text(encoding="utf-8").splitlines()
        rel = path.relative_to(ROOT)
        if not any(line.lstrip().startswith("//!") for line in lines):
            failures.append(f"{rel}: missing top-level //! module documentation")

        if not rel.parts or rel.parts[0] != "package":
            continue
        for index, line in enumerate(lines):
            match = PUBLIC_LET.match(line)
            if not match:
                continue
            name = match.group(1)
            signature, _ = signature_at(lines, index)
            docs = doc_lines_before(lines, index)
            symbols += 1
            if not docs:
                failures.append(f"{rel}:{index + 1}: {name} is missing /// documentation")
                continue
            summary = next((line.removeprefix("///").strip() for line in docs if line.removeprefix("///").strip()), "")
            if not summary or summary.startswith("-"):
                failures.append(f"{rel}:{index + 1}: {name} is missing a documentation summary")

            documented = {found.group(1) for doc in docs if (found := PARAM_DOC.match(doc))}
            for parameter in parameter_names(signature, name):
                parameters += 1
                if parameter not in documented:
                    failures.append(
                        f"{rel}:{index + 1}: {name} is missing documentation for parameter {parameter}"
                    )

    if failures:
        print("Typage documentation comment failures:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print(
        f"OK: {len(files)} Typst modules, {symbols} public symbols, and "
        f"{parameters} parameters have Typage documentation comments."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
