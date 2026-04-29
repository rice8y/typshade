#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 8pt)
#set text(size: 8pt)

#let data = read("fixtures/tiny-protein.fasta")
#let raw = read("fixtures/tiny-protein.fasta", encoding: none)

#assert.eq(type(data), str)
#assert.eq(type(raw), bytes)

#let alignment = alignment-data(raw, format: "fasta")
#assert.eq(alignment.at("sequences").at(0).at("name"), "Alpha")

#shade(raw, format: "fasta", figure: (similar(), consensus("bottom")))
