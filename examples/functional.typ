#import "../package/lib.typ": shade, consensus-track, legend-track, scoring-mode

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    scoring-mode("functional", option: "hydropathy"),
    legend-track(color: "Black"),
    consensus-track(position: "bottom"),
  ),
)
