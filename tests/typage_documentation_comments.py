#!/usr/bin/env python3
"""Verify the documentation comments consumed by typage-plugin-typst-docs."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TYP_DIRS = (ROOT / "package", ROOT / "examples", ROOT / "docs", ROOT / "tests")
PUBLIC_LET = re.compile(r"^#let\s+([A-Za-z][A-Za-z0-9-]*)")
PARAM_DOC = re.compile(r"^/// - ([A-Za-z][A-Za-z0-9-]*) \(([^)]+)\):")
RETURN_DOC = re.compile(r"^/// -> (.+)$")
VALID_TYPES = {
    "any", "content", "none", "auto", "bool", "boolean", "false", "true",
    "int", "integer", "float", "length", "angle", "ratio", "relative",
    "fraction", "str", "string", "color", "gradient", "pattern", "symbol",
    "version", "bytes", "label", "datetime", "duration", "styles", "array",
    "dictionary", "function", "arguments", "type", "module", "plugin",
}


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
    while index >= 0 and lines[index].startswith("///"):
        docs.append(lines[index])
        index -= 1
    docs.reverse()
    return docs


def module_doc_lines(lines: list[str]) -> list[str]:
    index = 0
    while index < len(lines) and (
        not lines[index].strip()
        or lines[index].startswith("//") and not lines[index].startswith("///")
    ):
        index += 1
    docs: list[str] = []
    while index < len(lines) and lines[index].startswith("///"):
        docs.append(lines[index])
        index += 1
    return docs


def valid_type_annotation(annotation: str) -> bool:
    types = [item.strip() for item in annotation.split(",")]
    return bool(types) and all(item in VALID_TYPES for item in types)


def main() -> int:
    failures: list[str] = []
    symbols = 0
    parameters = 0
    files = typ_files()

    for path in files:
        lines = path.read_text(encoding="utf-8").splitlines()
        rel = path.relative_to(ROOT)
        if not module_doc_lines(lines):
            failures.append(f"{rel}: missing leading /// module documentation")
        if any(line.startswith("//!") for line in lines):
            failures.append(f"{rel}: legacy //! module documentation is not Tinymist-compliant")

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
            if not summary or summary.startswith("-") or summary.startswith("->"):
                failures.append(f"{rel}:{index + 1}: {name} is missing a documentation summary")

            documented: dict[str, str] = {}
            for doc in docs:
                if "/// - `" in doc:
                    failures.append(f"{rel}:{index + 1}: {name} uses legacy Markdown-style parameter documentation")
                if found := PARAM_DOC.match(doc):
                    parameter, annotation = found.groups()
                    documented[parameter] = annotation
                    if not valid_type_annotation(annotation):
                        failures.append(
                            f"{rel}:{index + 1}: {name}.{parameter} has unsupported Tinymist type annotation {annotation!r}"
                        )
            for parameter in parameter_names(signature, name):
                parameters += 1
                if parameter not in documented:
                    failures.append(
                        f"{rel}:{index + 1}: {name} is missing documentation for parameter {parameter}"
                    )

            returns = [found.group(1) for doc in docs if (found := RETURN_DOC.match(doc))]
            if len(returns) != 1:
                failures.append(f"{rel}:{index + 1}: {name} must have exactly one /// -> return type")
            elif not valid_type_annotation(returns[0]):
                failures.append(
                    f"{rel}:{index + 1}: {name} has unsupported Tinymist return type {returns[0]!r}"
                )

    if failures:
        print("Typage documentation comment failures:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print(
        f"OK: {len(files)} Typst modules, {symbols} public symbols, and "
        f"{parameters} parameters have strict Tinymist/Typage documentation comments."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
