#import "../package/lib.typ": shade, color-scheme, scoring-mode, ruler-track, structure-tracks

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let hmmtop = read("../tests/fixtures/reference/AQP_HMM.ext", encoding: none)
#let structure = read("../tests/fixtures/reference/AQP1.phd", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    scoring-mode("similar"),
    color-scheme("greens"),
    ruler-track(position: "top", sequence: 1, steps: 10),
    structure-tracks(1, hmmtop: hmmtop, topology: structure, secondary: structure),
  ),
)
