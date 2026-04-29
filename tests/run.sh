#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -n "${TYPSHADE_TEST_OUT:-}" ]]; then
  OUT="${TYPSHADE_TEST_OUT%/}"
else
  TMP_BASE="${TMPDIR:-/tmp}"
  OUT="${TMP_BASE%/}/typshade-tests"
fi

mkdir -p "$OUT"

typst compile --root "$ROOT" "$ROOT/tests/data-and-analysis.typ" "$OUT/data-and-analysis.pdf"
typst compile --root "$ROOT" "$ROOT/tests/read-input-smoke.typ" "$OUT/read-input-smoke.pdf"
typst compile --root "$ROOT" "$ROOT/tests/public-api.typ" "$OUT/public-api.pdf"
typst compile --root "$ROOT" "$ROOT/tests/rendering-coverage.typ" "$OUT/rendering-coverage.pdf"
python3 "$ROOT/tests/texshade_full_command_coverage.py"

echo "Typshade strict tests passed. PDFs written to $OUT"
