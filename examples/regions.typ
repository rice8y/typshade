#import "../package/lib.typ": shade, color-scheme, consensus-track, emphasize, highlight, mark, ruler-track, scoring-mode, tint

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    scoring-mode("similar"),
    color-scheme("greens"),
    ruler-track(position: "top", sequence: 1, steps: 10),
    consensus-track(position: "bottom", scale: "ColdHot"),
    highlight(1, "138..157"),
    tint(1, "158..163"),
    emphasize(1, "164..170"),
    mark("top", 1, "208..210", style: "-", text: "NPA"),
    mark("bottom", 1, "220..232", style: "=", text: "loop E"),
  ),
)
