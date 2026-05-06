#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REFERENCE_DIR="${TEXSHADE_REFERENCE_DIR:-/Users/yoneyama/workspace/github/typshade-copy/texshade}"
REFERENCE_PDF="${TEXSHADE_REFERENCE_PDF:-$REFERENCE_DIR/texshade.pdf}"
REFERENCE_DTX="${TEXSHADE_REFERENCE_DTX:-$REFERENCE_DIR/texshade.dtx}"

if [[ -n "${TYPSHADE_PARITY_OUT:-}" ]]; then
  OUT="${TYPSHADE_PARITY_OUT%/}"
else
  TMP_BASE="${TMPDIR:-/tmp}"
  OUT="${TMP_BASE%/}/typshade-texshade-visual-parity"
fi

if [[ ! -f "$REFERENCE_PDF" ]]; then
  echo "error: TeXshade reference PDF not found: $REFERENCE_PDF" >&2
  exit 1
fi

if [[ ! -f "$REFERENCE_DTX" ]]; then
  echo "error: TeXshade reference DTX not found: $REFERENCE_DTX" >&2
  exit 1
fi

if ! command -v pdftoppm >/dev/null 2>&1; then
  echo "error: pdftoppm is required for image-level comparison." >&2
  exit 1
fi

mkdir -p "$OUT/texshade" "$OUT/typshade"

TYP_PDF="$OUT/typshade-visual-parity.pdf"
CONTACT_TYP="$OUT/contact-sheet.typ"
CONTACT_PDF="$OUT/contact-sheet.pdf"

typst compile --root "$ROOT" "$ROOT/tests/texshade-visual-parity.typ" "$TYP_PDF"

# These pages cover TeXshade's visual overview specimens:
# identity/domain/similarity, T-Coffee, diverse mode, functional modes,
# graphs, secondary structure, fingerprints, logos, subfamily logos,
# structure meme explanation, and single-sequence display.
pdftoppm -png -r 120 -f 15 -l 38 "$REFERENCE_PDF" "$OUT/texshade/page"
pdftoppm -png -r 120 "$TYP_PDF" "$OUT/typshade/page"

check_pngs() {
  local label="$1"
  local pattern="$2"
  local count=0
  for image in $pattern; do
    if [[ ! -s "$image" ]]; then
      echo "error: missing or empty PNG for $label: $image" >&2
      exit 1
    fi
    count=$((count + 1))
  done
  if [[ "$count" -eq 0 ]]; then
    echo "error: no PNGs generated for $label" >&2
    exit 1
  fi
}

check_pngs "TeXshade reference" "$OUT/texshade/page-*.png"
check_pngs "Typshade parity" "$OUT/typshade/page-*.png"

for token in \
  "\\shadingmode" \
  "\\feature" \
  "\\fingerprint" \
  "\\showsequencelogo" \
  "\\showsubfamilylogo" \
  "\\includePHDtopo" \
  "\\similaritytable" \
  "\\shiftsingleseq"; do
  if ! grep -Fq "$token" "$REFERENCE_DTX"; then
    echo "error: expected TeXshade token not found in DTX audit: $token" >&2
    exit 1
  fi
done

cat > "$CONTACT_TYP" <<'TYP'
#set page(width: 297mm, height: 210mm, margin: 7mm)
#set text(size: 7pt)

#let thumb(path, caption) = block(
  breakable: false,
  inset: 3pt,
  stroke: 0.3pt + luma(210),
)[
  #text(weight: "bold")[#caption]
  #v(2pt)
  #image(path, width: 100%)
]

= TeXshade / Typshade Visual Parity Contact Sheet

The left column contains selected TeXshade manual pages rendered from the
reference PDF. The right column contains Typshade parity specimens rendered from
`tests/texshade-visual-parity.typ`. This sheet is for human image-level review;
the shell runner verifies that all pages render to non-empty PNGs.

#let tex = (
  "page-015.png", "page-016.png", "page-017.png", "page-018.png",
  "page-019.png", "page-020.png", "page-021.png", "page-022.png",
  "page-023.png", "page-024.png", "page-025.png", "page-026.png",
  "page-027.png", "page-028.png", "page-029.png", "page-030.png",
  "page-031.png", "page-032.png", "page-033.png", "page-034.png",
  "page-035.png", "page-036.png", "page-037.png", "page-038.png",
)

#let typ = (
  "page-1.png", "page-2.png", "page-3.png", "page-4.png", "page-5.png",
  "page-6.png",
)

#for i in range(0, tex.len()) {
  let typ-page = typ.at(calc.min(i, typ.len() - 1))
  grid(
    columns: (1fr, 1fr),
    gutter: 5mm,
    thumb("texshade/" + tex.at(i), "TeXshade " + tex.at(i)),
    thumb("typshade/" + typ-page, "Typshade " + typ-page),
  )
  if i + 1 < tex.len() {
    pagebreak()
  }
}
TYP

typst compile --root "$OUT" "$CONTACT_TYP" "$CONTACT_PDF"
pdftoppm -png -r 100 "$CONTACT_PDF" "$OUT/contact-sheet"
check_pngs "contact sheet" "$OUT/contact-sheet-*.png"

cat > "$OUT/README.md" <<EOF
# TeXshade / Typshade Visual Parity

- TeXshade reference PDF: $REFERENCE_PDF
- TeXshade source DTX: $REFERENCE_DTX
- Typshade parity PDF: $TYP_PDF
- Contact sheet PDF: $CONTACT_PDF

Rendered TeXshade reference pages 15..38 and all Typshade parity pages were
converted to PNG and checked for non-empty image output.

Review the contact sheet first, then inspect individual PNGs in:

- $OUT/texshade
- $OUT/typshade
EOF

echo "TeXshade/Typshade visual parity images written to $OUT"
echo "Contact sheet: $CONTACT_PDF"
