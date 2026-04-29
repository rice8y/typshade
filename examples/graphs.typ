#import "../package/lib.typ": shade, color-scheme, gap-style, graph, ruler-marker, ruler-track, scoring-mode

#set page(width: auto, height: auto, margin: 12pt)

#let aqp = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let frustration = read("../tests/fixtures/reference/frustr.txt", encoding: none)
#let stacked-bars = read("../tests/fixtures/reference/bars.txt", encoding: none)

#shade(
  aqp,
  format: "msf",
  commands: (
    scoring-mode("similar"),
    color-scheme("greens"),
    ruler-track(position: "top", sequence: 1, steps: 10, color: "DarkGray", name: "AQP1", name-color: "RoyalBlue", space: 4pt),
    ruler-marker(150, "TM1", position: "top", color: "BrickRed"),
    gap-style(foreground: "DarkGray", background: "White", rule: 0.4pt),
    graph("tttop", 1, "138..170", frustration, kind: "frustratometer", text: ""),
    graph("top", 1, "all", "hydrophobicity", kind: "bar", range: (-4.5, 4.5), options: ("OliveGreen", "Gray10"), text: "hydropathy"),
    graph("bottom", 1, "all", "conservation", kind: "color", range: (0, 100), options: ("ColdHot",), text: "conservation"),
    graph("bbbottom", 1, "138..170", stacked-bars, kind: "stackedbars", range: (-260, 260), options: ("BlueRed", "Gray10"), text: "8-bar stack"),
  ),
)
