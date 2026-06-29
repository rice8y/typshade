#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -n "${TYPSHADE_TEST_OUT:-}" ]]; then
  OUT="${TYPSHADE_TEST_OUT%/}/expected-failures"
else
  TMP_BASE="${TMPDIR:-/tmp}"
  OUT="${TMP_BASE%/}/typshade-tests/expected-failures"
fi

mkdir -p "$OUT"

expect_failure() {
  local name="$1"
  local expected="$2"
  local input="$OUT/$name.typ"
  local output="$OUT/$name.pdf"
  local log="$OUT/$name.log"

  if typst compile --root "$ROOT" - "$output" <"$input" >"$log" 2>&1; then
    echo "error: expected Typst compile failure for $name" >&2
    exit 1
  fi

  if ! grep -Fq "$expected" "$log"; then
    echo "error: expected diagnostic containing '$expected' for $name" >&2
    echo "----- diagnostic -----" >&2
    cat "$log" >&2
    echo "----------------------" >&2
    exit 1
  fi
}

cat >"$OUT/ragged-fasta.typ" <<'TYP'
#import "/package/lib.typ": *
#alignment-data(">A\nACGT\n>B\nAC\n", format: "fasta")
TYP
expect_failure "ragged-fasta" "inconsistent column length"

cat >"$OUT/ragged-aln.typ" <<'TYP'
#import "/package/lib.typ": *
#alignment-data("Alpha ACGT\nBeta AC\n", format: "aln")
TYP
expect_failure "ragged-aln" "inconsistent column length"

cat >"$OUT/ragged-msf.typ" <<'TYP'
#import "/package/lib.typ": *
#alignment-data("PileUp\n\n MSF: 4 Type: P\n Name: Alpha Len: 4\n Name: Beta Len: 2\n//\nAlpha ACGT\nBeta AC\n", format: "msf")
TYP
expect_failure "ragged-msf" "inconsistent column length"

cat >"$OUT/unknown-format.typ" <<'TYP'
#import "/package/lib.typ": *
#alignment-data(">A\nACGT\n", format: "fastaa")
TYP
expect_failure "unknown-format" "unknown alignment format"

cat >"$OUT/unknown-sequence-name.typ" <<'TYP'
#import "/package/lib.typ": *
#selection-preview(">Alpha\nAEF-\n>Beta\nADF-\n", "Typo", "1..2", format: "fasta")
TYP
expect_failure "unknown-sequence-name" "unknown sequence"

cat >"$OUT/unknown-hidden-sequence.typ" <<'TYP'
#import "/package/lib.typ": *
#shade(">Alpha\nAEF-\n>Beta\nADF-\n", format: "fasta", commands: (hide-sequence("Typo"),))
TYP
expect_failure "unknown-hidden-sequence" "unknown sequence"

cat >"$OUT/out-of-range-sequence.typ" <<'TYP'
#import "/package/lib.typ": *
#percent-identity(">Alpha\nAEF-\n>Beta\nADF-\n", 99, 1, format: "fasta")
TYP
expect_failure "out-of-range-sequence" "out of range"

cat >"$OUT/malformed-selection.typ" <<'TYP'
#import "/package/lib.typ": *
#selection-preview(">Alpha\nAEF-\n>Beta\nADF-\n", 1, "1..", format: "fasta")
TYP
expect_failure "malformed-selection" "invalid selection"

echo "Expected-failure tests passed."
