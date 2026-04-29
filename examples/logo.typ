#import "../package/lib.typ": shade, color-scheme, scoring-mode, no-consensus, sequence-logo, subfamily-logo

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    scoring-mode("similar"),
    color-scheme("blues"),
    no-consensus(),
    sequence-logo(position: "top", name: "logo", scale: "leftright", relevance-marker: (char: "*", color: "Black"), stretch: 1.1),
    subfamily-logo((1, 2, 3, 4, 5, 6, 7), position: "bottom", name: "AQPs", negative-name: "GlpFs"),
  ),
)
