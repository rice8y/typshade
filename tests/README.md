# Typshade Strict Tests

These tests are intentionally small, strict, and independent of the package
manual. They are meant to catch parser regressions, public API breakage, and
rendering-path errors before release.

The larger compatibility fixtures under `tests/fixtures/reference/` are derived
from the GPL-2.0-or-later TeXshade v1.29 distribution and examples. They are
documented in the repository [NOTICE.md](../NOTICE.md). The tiny fixtures directly under
`tests/fixtures/` are synthetic test data for typshade.

All repository sample data lives under `tests/fixtures/`. The larger
TeXshade-derived reference files are in `tests/fixtures/reference/`; the tiny
handwritten parser fixtures are directly under `tests/fixtures/`.

Run everything from the repository root:

```sh
bash tests/run.sh
```

By default, generated PDFs are written to the system temporary directory under
`typshade-tests`. Set `TYPSHADE_TEST_OUT` to choose a stable output directory:

```sh
TYPSHADE_TEST_OUT=tests/out bash tests/run.sh
```

Or run individual Typst tests:

```sh
mkdir -p "${TMPDIR:-/tmp}/typshade-tests"
typst compile --root . tests/data-and-analysis.typ "${TMPDIR:-/tmp}/typshade-tests/data-and-analysis.pdf"
typst compile --root . tests/read-input-smoke.typ "${TMPDIR:-/tmp}/typshade-tests/read-input-smoke.pdf"
typst compile --root . tests/public-api.typ "${TMPDIR:-/tmp}/typshade-tests/public-api.pdf"
typst compile --root . tests/rendering-coverage.typ "${TMPDIR:-/tmp}/typshade-tests/rendering-coverage.pdf"
python3 tests/texshade_full_command_coverage.py
```

`data-and-analysis.typ` uses `#assert` to verify parsed alignment data,
selection handling, PDB selections, and similarity/identity helpers.

`public-api.typ` constructs every intended public command helper. This catches
renames, accidental unexports, and incompatible signatures.

`rendering-coverage.typ` compiles representative Typshade figures through the
actual renderer, including recipes, tracks, annotations, logos, structure tracks,
bar/color graphs, T-Coffee data, and single-sequence mode.

`texshade_full_command_coverage.py` checks that the documentation still maps
the full TeXshade public command surface, including commands found outside the
Quick Reference, to Typshade or to an explicitly excluded item.
