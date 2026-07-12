# Typshade Strict Tests

These tests are intentionally small, strict, and independent of the package manual. They are meant to catch parser regressions, public API breakage, and rendering-path errors before release.

The larger compatibility fixtures under `tests/fixtures/reference/` are derived from the GPL-2.0-or-later TeXshade v1.29 distribution and examples. They are documented in the repository [NOTICE.md](../NOTICE.md). The tiny fixtures directly under `tests/fixtures/` are synthetic test data for typshade.

All repository sample data lives under `tests/fixtures/`. The larger TeXshade-derived reference files are in `tests/fixtures/reference/`; the tiny handwritten parser fixtures are directly under `tests/fixtures/`.

Run everything from the repository root:

```sh
bash tests/run.sh
```

By default, generated PDFs and image-verification PNGs are written to the system temporary directory under `typshade-tests`. Set `TYPSHADE_TEST_OUT` to choose a stable output directory:

```sh
TYPSHADE_TEST_OUT=tests/out bash tests/run.sh
```

Or run individual Typst tests:

```sh
mkdir -p "${TMPDIR:-/tmp}/typshade-tests"
typst compile --root . tests/data-and-analysis.typ "${TMPDIR:-/tmp}/typshade-tests/data-and-analysis.pdf"
typst compile --root . tests/read-input-smoke.typ "${TMPDIR:-/tmp}/typshade-tests/read-input-smoke.pdf"
typst compile --root . tests/public-api.typ "${TMPDIR:-/tmp}/typshade-tests/public-api.pdf"
typst compile --root . tests/semantic-behavior.typ "${TMPDIR:-/tmp}/typshade-tests/semantic-behavior.pdf"
typst compile --root . tests/rendering-coverage.typ "${TMPDIR:-/tmp}/typshade-tests/rendering-coverage.pdf"
typst compile --root . tests/full-feature-visual.typ "${TMPDIR:-/tmp}/typshade-tests/full-feature-visual.pdf"
typst compile --root . tests/combinatorial-feature-matrix.typ "${TMPDIR:-/tmp}/typshade-tests/combinatorial-feature-matrix.pdf"
typst compile --root . tests/alignment-position-visual.typ "${TMPDIR:-/tmp}/typshade-tests/alignment-position-visual.pdf"
typst compile --root . tests/auto-page-visual.typ "${TMPDIR:-/tmp}/typshade-tests/auto-page-visual.pdf"
typst compile --features html --format html --root . tests/html-export.typ "${TMPDIR:-/tmp}/typshade-tests/html-export.html" --pretty
bash tests/expected-failures.sh
python3 tests/texshade_full_command_coverage.py
python3 tests/typage_documentation_comments.py
```

`data-and-analysis.typ` uses `#assert` to verify parsed alignment data, selection handling, PDB selections, and similarity/identity helpers.

`public-api.typ` constructs every intended public command helper and renders a visual command-surface table. This catches renames, accidental unexports, incompatible signatures, and missing image-generation coverage for public command constructors.

`semantic-behavior.typ` verifies behavior that is easier to assert through internal model data than through image inspection, such as sequence-based consensus semantics and default reference resolution.

`rendering-coverage.typ` compiles representative Typshade figures through the actual renderer, including recipes, tracks, annotations, logos, structure tracks, bar/color graphs, T-Coffee data, and single-sequence mode.

`full-feature-visual.typ` renders every public feature family, including top-level `shade(...)` options, MSF/ALN/FASTA inputs, recipes, tracks, annotations, PDB selections, graphs, themes, presets, typography/layout controls, inspection helpers, data helpers, and analysis utilities.

`combinatorial-feature-matrix.typ` stress-renders representative cross-products of the major feature families: scoring x selection, tracks x annotations, auto layout/pagination x content types, recipes, structure tracks, PDB selections, T-Coffee/frustration data, inspection helpers, and analysis output. This catches feature interactions that one-by-one constructor coverage cannot.

`alignment-position-visual.typ` renders the default alignment placement together with explicit left, center, and right placement. The default must be left.

`auto-page-visual.typ` renders `shade(...)` on `#set page(width: auto, height: auto)` and the runner checks that its PNG remains narrow. This catches accidental full-width wrappers that break auto-sized pages.

`html-export.typ` compiles with Typst's experimental HTML export enabled and verifies that Typshade alignments produce non-empty SVG frames, captioned figures, and bordered native HTML tables for data-report helpers.

`run.sh` converts every generated PDF to PNG pages with `pdftoppm` and fails if any visual page is missing or empty. This keeps strict tests image-based rather than compile-only.

`expected-failures.sh` compiles intentionally invalid inputs and verifies that they fail with Typshade-level diagnostics rather than low-level indexing or parsing errors.

`texshade_full_command_coverage.py` checks that the documentation still maps the full TeXshade public command surface, including commands found outside the Quick Reference, to Typshade or to an explicitly excluded item.

`typage_documentation_comments.py` checks that every `.typ` file has `//!` module documentation and that every public package binding has a `///` summary plus descriptions for all parameters in the format consumed by `typage-plugin-typst-docs`.

## TeXshade Visual Parity Audit

When the TeXshade reference source and compiled manual are available, run the side-by-side visual parity audit:

```sh
bash tests/texshade_visual_parity.sh
```

By default, this uses:

```text
/Users/yoneyama/workspace/github/typshade-copy/texshade/texshade.dtx
/Users/yoneyama/workspace/github/typshade-copy/texshade/texshade.pdf
```

Override these paths with `TEXSHADE_REFERENCE_DTX` and `TEXSHADE_REFERENCE_PDF`. The script renders TeXshade manual pages 15..38 and `tests/texshade-visual-parity.typ` to PNG, verifies that all images are non-empty, and builds a contact sheet PDF for human image-level comparison. See `tests/texshade-visual-parity-report.md` for the current visual findings.
