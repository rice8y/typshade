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

#{
  if sys.version >= version(0, 15, 0) {
    let path-source = path("fixtures/tiny-protein.fasta")
    let path-alignment = alignment-data(path-source, format: "fasta")
    assert.eq(path-alignment.at("sequences").at(0).at("name"), "Alpha")
  }
}

#if sys.version >= version(0, 15, 0) [
  #shade(
    path("fixtures/tiny-protein.fasta"),
    format: "fasta",
    commands: (
      similar(),
      consensus("bottom"),
      highlight(1, pdb-point(path("fixtures/tiny.pdb"), 2, distance: 2), bg: "Yellow"),
    ),
  )

  #shade(
    path("fixtures/reference/AQPpro.MSF"),
    format: "msf",
    commands: (
      window(1, "138..145"),
      graph("top", 1, "138..145", path("fixtures/reference/bars.txt"), kind: "stackedbars"),
      structures(1, topology: path("fixtures/reference/AQP1.phd")),
      no-consensus(),
    ),
  )
]
