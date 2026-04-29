#import "../package/lib.typ": *

= Typst-native typshade API

New documents can use named options, presets, and readable helper functions.

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)

#alignment-summary(aqp, format: "msf")

Motif positions in sequence 1: #selection-preview(aqp, 1, "NPA", format: "msf")

#shade(
  aqp,
  format: "msf",
  preset: "publication",
  theme: "screen",
  mode: "similar",
  residues-per-line: 45,
  ruler: (position: "top", steps: 20, color: "DarkGray"),
  logo: (position: "top", colorset: "charge"),
  legend: true,
  regions: (
    highlight(1, "NPA", fg: "White", bg: "BrickRed"),
    tint(2, "20..35", intensity: "weak"),
  ),
  features: (
    motif(1, "NXX[ST]N", text: "motif", fill: "Yellow"),
    graph("bottom", 1, "all", "conservation", kind: "color", options: ("ColdHot",)),
  ),
)
