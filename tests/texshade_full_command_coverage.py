"""Verify that docs map TeXshade's full public command surface.

The command set is intentionally broader than the TeXshade Quick Reference:
it combines commands found in the manual body, command labels, Quick Reference,
and source-defined public aliases/shortcuts from the user-command section.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs" / "documentation.typ"
SOURCE_CANDIDATES = [
    ROOT.parent / "typshade-copy" / "texshade" / "texshade.dtx",
    ROOT / "texshade" / "texshade.dtx",
]
STYLE_CANDIDATES = [
    ROOT.parent / "typshade-copy" / "texshade" / "texshade.sty",
    ROOT / "texshade" / "texshade.sty",
]

IGNORED_NON_TEXSHADE_MACROS = {
    "begin",
    "end",
    "usepackage",
    "definecolor",
    "caption",
    "label",
    "quad",
    "qquad",
    "dag",
    "dagger",
    "ddagger",
    "mathparagraph",
    "mathsection",
    "mathdollar",
    "lbrace",
    "rbrace",
    "textbf",
    "linewidth",
    "smallskip",
    "medskip",
    "bigskip",
    "baselineskip",
    "text",
    "emph",
    "hfill",
    "hline",
    "hspace",
    "ldots",
    "newpage",
    "pageref",
    "vert",
    "vspace",
    "footnote",
    "german",
    "input",
    "language",
    "med",
    "memes",
    "par",
    "rmdefault",
    "sfdefault",
    "small",
    "texshade",
    "ttdefault",
}

OBSOLETE_OR_TYPO_ONLY_REFERENCES = {
    "hideblock",
    "shownonDSSP",
    "tintreqion",
}

SOURCE_DEFINED_PUBLIC_EXTRAS = {
    "allmatchspecialoff",
    "bigsepline",
    "gaprule",
    "identitytable",
    "includeTCoffee",
    "medsepline",
    "nosepline",
    "showallmatchpositions",
    "smallsepline",
    "subfamilythreshold",
}

FONT_SHORTCUT_RE = re.compile(
    r"^(features|featurestyles|featurenames|featurestylenames|names|numbering|"
    r"residues|legend|ruler|rulername)"
    r"(rm|sf|tt|bf|md|it|sl|sc|up|tiny|scriptsize|footnotesize|small|"
    r"normalsize|large|Large|LARGE|huge|Huge)$"
)


def read_first(paths: list[Path], label: str) -> str:
    for path in paths:
        if path.exists():
            return path.read_text(errors="ignore")
    checked = "\n".join(str(path) for path in paths)
    raise SystemExit(f"{label} not found. Checked:\n{checked}")


def quick_reference_commands(source: str) -> set[str]:
    match = re.search(r"\\section\{Quick Reference\}(.*?)(?:\\section\{References\}|\\StopEventually)", source, re.S)
    if not match:
        raise SystemExit("Could not locate TeXshade Quick Reference section.")
    return set(re.findall(r"\\([A-Za-z][A-Za-z0-9]*)", match.group(1)))


def manual_body_commands(source: str) -> set[str]:
    manual = source.split(r"%    \section{References}", 1)[0]
    return set(re.findall(r"\|\\([A-Za-z][A-Za-z0-9]*)", manual))


def command_labels(source: str) -> set[str]:
    return {
        label
        for label in re.findall(r"\\label\{L([^}]+)\}", source)
        if re.match(r"^[A-Za-z][A-Za-z0-9*]*$", label)
    }


def source_public_extras(style: str) -> set[str]:
    if "%%%%% Definition of user commands" not in style:
        return set()
    section = style.split("%%%%% Definition of user commands", 1)[1].split("%%%%%  Calculate consensus", 1)[0]
    defined = set()
    patterns = [
        r"^\\def\\([A-Za-z][A-Za-z0-9]*)\b",
        r"^\\newcommand\\?\{?\\([A-Za-z][A-Za-z0-9]*)\}?",
        r"^\\renewcommand\{\\([A-Za-z][A-Za-z0-9]*)\}",
    ]
    for pattern in patterns:
        defined.update(re.findall(pattern, section, re.M))
    return {command for command in defined if FONT_SHORTCUT_RE.match(command)} | SOURCE_DEFINED_PUBLIC_EXTRAS


def texshade_commands(source: str, style: str) -> list[str]:
    commands = manual_body_commands(source) | command_labels(source) | quick_reference_commands(source) | source_public_extras(style)
    commands -= IGNORED_NON_TEXSHADE_MACROS
    commands -= OBSOLETE_OR_TYPO_ONLY_REFERENCES
    commands = {
        command
        for command in commands
        if not command.startswith("meta")
        and not command.startswith("Describe")
    }
    if not commands:
        raise SystemExit("No TeXshade commands extracted.")
    return sorted(commands)


def documented(command: str, doc: str) -> bool:
    variants = {command, command.replace("TEX", "TeX")}
    return "\\" + command in doc or any(
        re.search(r"(?<![A-Za-z0-9_-])" + re.escape(variant) + r"(?![A-Za-z0-9_-])", doc)
        for variant in variants
    )


def main() -> int:
    source = read_first(SOURCE_CANDIDATES, "TeXshade source")
    style = read_first(STYLE_CANDIDATES, "TeXshade style file")
    doc = DOC.read_text()
    commands = texshade_commands(source, style)
    missing = [command for command in commands if not documented(command, doc)]
    if missing:
        print("Missing TeXshade full command mappings in docs/documentation.typ:", file=sys.stderr)
        for command in missing:
            print(f"  \\{command}", file=sys.stderr)
        print(f"\nChecked {len(commands)} full TeXshade commands.", file=sys.stderr)
        return 1
    print(f"OK: {len(commands)} full TeXshade commands are documented.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
