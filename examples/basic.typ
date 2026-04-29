#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let species = read("../tests/fixtures/reference/AQP2spec.ALN", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    identical(colors: "blues"),
    window(1, "80..112"),
    no-consensus(),
    ruler("top", sequence: 1, every: 10),
  ),
)

#pagebreak()

#shade(
  species,
  format: "aln",
  commands: (
    diverse(option: 1),
    consensus("bottom", scale: "ColdHot", name: "conservation"),
    ruler("top", sequence: 1, every: 10),
  ),
)
