#import "../package/lib.typ": *

= Declarative typshade Recipes

This example uses `figure:` recipes to describe the purpose of the figure
instead of assembling a long command sequence.

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)

#shade(
  aqp,
  format: "msf",
  theme: "screen",
  figure: motif-map(
    (
      "NPA": (bg: "BrickRed", text: "active site"),
      "NXX[ST]N": "glycosylation",
    ),
    region: "80..125",
    logo: "charge",
    highlights: (
      "20..35": "PineGreen",
    ),
  ),
  commands: (
    typography(target: "names", family: "mono", weight: "regular", posture: "normal", size: "normal"),
  ),
)
