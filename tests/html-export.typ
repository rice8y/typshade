//! Smoke fixture for semantic Typst HTML export.

#import "../package/lib.typ": *

#set text(size: 8pt)

#let protein = read("fixtures/tiny-protein.fasta", encoding: none)
#let msf = read("fixtures/tiny.msf", encoding: none)

= HTML Export

#shade(
  protein,
  format: "fasta",
  residues-per-line: 4,
  legend: true,
  commands: (
    similar(colors: "blues", threshold: 50),
    ruler("top", sequence: 1, every: 1),
    no-consensus(),
  ),
)

#shade(
  msf,
  format: "msf",
  caption: [HTML frame smoke],
  fit: "container",
  commands: (
    identical(threshold: 50),
    ruler("top", sequence: 1, every: 1),
    no-consensus(),
  ),
)

#selection-table(
  protein,
  (name: "motif", selection: select-motif("A[ED]")),
  (name: "range", selection: select-range(1, 3)),
  format: "fasta",
)
