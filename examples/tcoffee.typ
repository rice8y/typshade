#import "../package/lib.typ": shade, tcoffee-scores, ruler-track, consensus-track

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let scores = read("../tests/fixtures/reference/AQP_TC.asc", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    tcoffee-scores(scores),
    ruler-track(position: "top", sequence: 1, steps: 10),
    consensus-track(position: "bottom", scale: "T-Coffee", name: "reliability"),
  ),
)
