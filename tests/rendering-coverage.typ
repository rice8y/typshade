#import "../package/lib.typ": *

#set page(width: 220mm, height: auto, margin: 8mm)
#set text(size: 8pt)

#let ref-protein = read("fixtures/reference/AQPpro.MSF", encoding: none)
#let ref-dna = read("fixtures/reference/AQPDNA.MSF", encoding: none)
#let tiny-protein = read("fixtures/tiny-protein.fasta", encoding: none)
#let tcoffee-scores = read("fixtures/reference/AQP_TC.asc", encoding: none)
#let frustration = read("fixtures/reference/frustr.txt", encoding: none)
#let stacked-bars = read("fixtures/reference/bars.txt", encoding: none)
#let aqp-phd = read("fixtures/reference/AQP1.phd", encoding: none)

= Rendering Coverage

== Publication Recipe

#shade(
  ref-protein,
  format: "msf",
  figure: publication(
    region: "80..112",
    sequence: 1,
    motifs: ("AQ": "aquaporin motif"),
    highlights: ("100..104": (bg: "LightYellow")),
    logo: false,
    conservation: true,
  ),
)

== Explicit Commands

#shade(
  tiny-protein,
  format: "fasta",
  figure: (
    similar(colors: "grays", threshold: 50, all-match-threshold: 90),
    names-track(position: "left"),
    numbering-track(position: "right"),
    consensus("bottom", scale: "ColdHot"),
    ruler("top", sequence: 1, every: 1),
    ruler-marker(2, "site", color: "Red"),
    legend(),
    highlight(1, "E", bg: "LightYellow"),
    tint(2, "2..3"),
    emphasize(1, "1..2"),
    frame(1, "1..2"),
    mark("top", 1, "1..2", style: "brace[Blue]", text: "brace"),
    graph("bottom", 1, "all", "conservation", kind: "bar", options: ("Blue", "Gray10")),
  ),
)

== Diverse And Functional Modes

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "138..170"),
    diverse(option: 1),
    ruler("top", sequence: 1, every: 10),
    no-consensus(),
  ),
)

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "138..170"),
    functional("chemical"),
    shade-all-residues(),
    legend(),
  ),
)

== T-Coffee And Graphs

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "30..63"),
    tcoffee(tcoffee-scores),
    graph("top", 1, "30..63", "conservation", kind: "color", options: ("T-Coffee",)),
    consensus("bottom"),
  ),
)

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "138..170"),
    graph("ttop", 1, "138..170", frustration, kind: "frustratometer"),
    graph("top", 1, "138..170", "charge", kind: "color", options: ("ColdHot",)),
    graph("bottom", 1, "138..170", "hydrophobicity", kind: "bar", options: ("LightBrown", "Gray10")),
    graph("bbottom", 1, "138..170", stacked-bars, kind: "stackedbars", options: ("BlueRed", "Gray10")),
  ),
)

== Logos

#shade(
  ref-dna,
  format: "msf",
  figure: (
    window(1, "414..443"),
    functional("DNA"),
    sequence-logo(position: "top", colors: "DNA", name: "logo"),
    logo-scale(position: "leftright"),
  ),
)

#shade(
  ref-protein,
  format: "msf",
  figure: logo-analysis(
    sequence: 3,
    region: "203..235",
    subfamily: (3,),
    relevance: (threshold: 1.0, char: "*", color: "Red"),
  ),
)

== Structure Tracks

#shade(
  ref-protein,
  format: "msf",
  figure: structure-map(
    1,
    topology: aqp-phd,
    secondary: aqp-phd,
    region: "1..90",
    line-length: 45,
  ),
)

== Single Sequence

#shade(
  ref-dna,
  format: "msf",
  figure: (
    single-sequence(sequence: 1),
    window(1, "414..443"),
    shift-single-sequence(),
    lower(1, "414..419"),
    mark("bottom", 1, "414..443", style: "complement[LightBlue][lower]"),
    mark("top", 1, "414..443", style: "translate[Red]"),
    no-consensus(),
  ),
)
