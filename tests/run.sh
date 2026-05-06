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

if ! command -v pdftoppm >/dev/null 2>&1; then
  echo "error: pdftoppm is required for image-based visual verification." >&2
  exit 1
fi

PNG_OUT="$OUT/png-$$"
mkdir -p "$PNG_OUT"

compile_typst() {
  local input="$1"
  local name="$2"
  typst compile --root "$ROOT" "$ROOT/tests/$input" "$OUT/$name.pdf"
}

verify_pngs() {
  local name="$1"
  local dir="$PNG_OUT/$name"
  mkdir -p "$dir"
  pdftoppm -png -r 144 "$OUT/$name.pdf" "$dir/page"
  local count=0
  for page in "$dir"/page-*.png; do
    if [[ ! -s "$page" ]]; then
      echo "error: missing or empty PNG page for $name: $page" >&2
      exit 1
    fi
    count=$((count + 1))
  done
  if [[ "$count" -eq 0 ]]; then
    echo "error: no PNG pages generated for $name" >&2
    exit 1
  fi
}

assert_png_width_less() {
  local image="$1"
  local max_width="$2"
  local width
  width="$(python3 -c 'import struct, sys; f = open(sys.argv[1], "rb"); f.seek(16); print(struct.unpack(">I", f.read(4))[0])' "$image")"
  if [[ "$width" -ge "$max_width" ]]; then
    echo "error: PNG page is too wide: $image is ${width}px, expected < ${max_width}px" >&2
    exit 1
  fi
}

compile_typst "data-and-analysis.typ" "data-and-analysis"
compile_typst "read-input-smoke.typ" "read-input-smoke"
compile_typst "public-api.typ" "public-api"
compile_typst "rendering-coverage.typ" "rendering-coverage"
compile_typst "full-feature-visual.typ" "full-feature-visual"
compile_typst "alignment-position-visual.typ" "alignment-position-visual"
compile_typst "auto-page-visual.typ" "auto-page-visual"

verify_pngs "data-and-analysis"
verify_pngs "read-input-smoke"
verify_pngs "public-api"
verify_pngs "rendering-coverage"
verify_pngs "full-feature-visual"
verify_pngs "alignment-position-visual"
verify_pngs "auto-page-visual"

assert_png_width_less "$PNG_OUT/auto-page-visual/page-1.png" 700

python3 "$ROOT/tests/texshade_full_command_coverage.py"
python3 "$ROOT/tests/public_api_documentation_examples.py"

echo "Typshade strict tests passed. PDFs written to $OUT"
echo "Image verification PNGs written to $PNG_OUT"
