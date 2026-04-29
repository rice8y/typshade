#import "../package/lib.typ": *

= Recipe Gallery

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let topology = read("../tests/fixtures/reference/AQP1.top", encoding: none)
#let secondary = read("../tests/fixtures/reference/AQP1.phd", encoding: none)

== Publication Figure

#shade(
  aqp,
  format: "msf",
  theme: "screen",
  figure: publication(motifs: auto, logo: auto),
)

== Logo Analysis

#shade(
  aqp,
  format: "msf",
  figure: logo-analysis(
    colors: "charge",
    subfamily: (1, 2, 3),
    relevance: 1.0,
  ),
)

== Structure Map

#shade(
  aqp,
  format: "msf",
  figure: structure-map(
    1,
    topology: topology,
    secondary: secondary,
    region: "80..125",
  ),
)
