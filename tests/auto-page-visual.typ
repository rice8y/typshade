#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 8pt)
#set text(size: 8pt)

#let raw = read("fixtures/tiny-protein.fasta", encoding: none)

= Auto Page

#shade(raw, format: "fasta")
