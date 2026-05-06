#import "../package/lib.typ": *

#set page(width: 240mm, height: auto, margin: 8mm)
#set text(size: 8pt)

#let protein = read("fixtures/tiny-protein.fasta", encoding: none)
#let dna = read("fixtures/tiny-dna.fasta", encoding: none)
#let msf = read("fixtures/tiny.msf", encoding: none)
#let aln = read("fixtures/tiny.aln", encoding: none)
#let ref-protein = read("fixtures/reference/AQPpro.MSF", encoding: none)
#let ref-dna = read("fixtures/reference/AQPDNA.MSF", encoding: none)
#let tcoffee-source = read("fixtures/reference/AQP_TC.asc", encoding: none)
#let topology = read("fixtures/reference/AQP1.phd", encoding: none)
#let hmmtop = read("fixtures/reference/AQP_HMM.sgl", encoding: none)
#let frustration = read("fixtures/reference/frustr.txt", encoding: none)
#let stacked-bars = read("fixtures/reference/bars.txt", encoding: none)
#let pdb-source = read("fixtures/tiny.pdb", encoding: none)

#let panel(title, body) = block(
  breakable: false,
  inset: 5pt,
  stroke: 0.35pt + luma(210),
  radius: 2pt,
)[
  #text(weight: "bold")[#title]
  #v(3pt)
  #body
]

= Full Feature Visual Coverage

This document is intentionally visual. Every major public feature family is
rendered as document content, not only constructed as data.

== Input Formats And Top-Level `shade(...)`

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 6pt,
  panel[FASTA][
    #shade(protein, format: "fasta", residues-per-line: 4, ruler: "top", legend: false)
  ],
  panel[MSF][
    #shade(msf, format: "msf", residues-per-line: 4, consensus: "bottom", legend: false)
  ],
  panel[ALN][
    #shade(aln, format: "aln", seq-type: "P", residues-per-line: 4, numbering: "leftright", legend: false)
  ],
)

#shade(
  protein,
  format: "fasta",
  preset: "publication",
  theme: visual-theme(colors: "greens", names: "PineGreen", numbering: "DarkGray"),
  mode: "similar",
  residues-per-line: 4,
  names: "right",
  numbering: "leftright",
  consensus: "top",
  ruler: (position: "bottom", sequence: 1, steps: 1, color: "BrickRed"),
  logo: (position: "top", colorset: "rasmol"),
  subfamily-logo: (sequences: (1, 2), position: "bottom", colorset: "chemical"),
  legend: (color: "DarkGray"),
  regions: (
    highlight(1, "1..2", bg: "LightYellow", all: true),
    tint(2, "2..3", intensity: "strong"),
    emphasize(3, "1..2"),
    frame(1, "1..2", color: "Red"),
  ),
  features: (
    mark("top", 1, "1..2", style: "brace[Blue]", text: "brace"),
    mark("bottom", 1, "2..3", style: "fill:*[Red]", text: "fill"),
  ),
  commands: (
    ruler-marker(2, "site", position: "bottom", color: "Red"),
    alignment-position("left"),
    typography(target: "all", size: 7.5pt),
  ),
)

== Recipes

#grid(
  columns: (1fr, 1fr),
  gutter: 6pt,
  panel[Publication][
    #shade(
      ref-protein,
      format: "msf",
      figure: publication(region: "80..112", sequence: 1, motifs: ("AQ": "AQ motif"), logo: false, conservation: true),
    )
  ],
  panel[Motif Map][
    #shade(
      ref-protein,
      format: "msf",
      figure: motif-map(("AQ": "AQ", "GA": (text: "GA block", bg: "LightYellow")), sequence: 1, region: "80..112", logo: false),
    )
  ],
  panel[Structure Map][
    #shade(
      ref-protein,
      format: "msf",
      figure: structure-map(1, topology: topology, secondary: topology, hmmtop: hmmtop, region: "1..80", line-length: 40),
    )
  ],
  panel[Logo Analysis][
    #shade(
      ref-protein,
      format: "msf",
      figure: logo-analysis(sequence: 3, region: "203..235", subfamily: (3,), relevance: (threshold: 1.0, char: "*", color: "Red")),
    )
  ],
)

#shade(
  ref-protein,
  format: "msf",
  figure: overview(
    line-length: 120,
    commands: (window(1, "1..120"),),
  ),
)

== Tracks, Logos, Legends, And Structure Controls

#shade(
  ref-dna,
  format: "msf",
  figure: (
    window(1, "414..443"),
    functional("DNA"),
    consensus-track(position: "bottom", scale: "ColdHot", name: "conservation"),
    ruler-track(position: "top", sequence: 1, steps: 5, color: "DarkGray", name: "ruler", name-color: "Red", space: 2pt),
    ruler-marker(424, "start", position: "top", color: "Red"),
    sequence-logo(position: "top", colors: "DNA", name: "logo", scale: "leftright", relevance-marker: (char: "*", color: "Red", threshold: 1.0), stretch: 1.1),
    legend-track(color: "Black"),
  ),
)

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "1..90"),
    similar(colors: "grays"),
    structure-tracks(1, topology: topology, secondary: topology, hmmtop: hmmtop),
    show-structure-types("PHDsec", ("alpha", "beta")),
    hide-structure-types("PHDtopo", ("external",)),
    structure-appearance("PHDtopo", "TM", "top", "box[LightBlue]", "TM"),
    use-second-dssp-column(),
    no-consensus(),
  ),
)

== Annotations, Selections, Graphs, And PDB Helpers

#shade(
  protein,
  format: "fasta",
  figure: (
    similar(colors: "blues", threshold: 50),
    motif(1, "A[ED]", text: "motif", all: true),
    highlight(1, pdb-selection(pdb-point(pdb-source, 1, distance: 0.2, atom: "CA")), bg: "LightGreen"),
    tint(2, pdb-selection(pdb-line(pdb-source, 1, 2, distance: 0.2, atom-a: "CA", atom-b: "CA"))),
    emphasize(3, pdb-selection(pdb-plane(pdb-source, 1, 2, 3, distance: 0.2, atom-a: "CA", atom-b: "CA", atom-c: "CA"))),
    graph("top", 1, "all", "conservation", kind: "color", options: ("ColdHot",), text: "color graph"),
    graph("bottom", 1, "all", "hydrophobicity", kind: "bar", options: ("Blue", "Gray10"), text: "bar graph"),
  ),
)

#shade(
  ref-protein,
  format: "msf",
  figure: (
    window(1, "138..170"),
    functional("charge"),
    graph("ttop", 1, "138..170", frustration, kind: "frustratometer", text: "frustration"),
    graph("top", 1, "138..170", "charge", kind: "color", options: ("ColdHot",), text: "charge"),
    graph("bottom", 1, "138..170", stacked-bars, kind: "stackedbars", options: ("BlueRed", "Gray10"), text: "stack"),
    legend(),
  ),
)

== Scoring, Styling, Visibility, And Layout Controls

#grid(
  columns: (1fr, 1fr),
  gutter: 6pt,
  panel[Identity And Custom Residues][
    #shade(
      protein,
      format: "fasta",
      commands: (
        identical(colors: "reds", threshold: 50, all-match-threshold: 90),
        residue-style("conserved", "White", "BrickRed", case: "upper"),
        consensus-symbols(".", "lower", "upper"),
        consensus-colors(conserved-fg: "Blue", allmatch-fg: "Red"),
      ),
    )
    #h(4pt)#color-swatch("BrickRed") custom swatch
  ],
  panel[Custom Functional Groups][
    #shade(
      protein,
      format: "fasta",
      commands: (
        clear-functional-groups(),
        functional-group("acidic", "DE", "White", "Red"),
        functional-group("aromatic", "FWY", "Black", "Yellow"),
        scoring-mode("functional"),
        shade-all-residues(),
        legend(),
      ),
    )
  ],
  panel[Visibility And Ordering][
    #shade(
      protein,
      format: "fasta",
      commands: (
        sequence-name(1, "renamed"),
        sequence-name-color((1,), "Red"),
        sequence-number-color((2,), "Gray50"),
        hide-sequence-name((3,)),
        hide-sequence-number((3,)),
        sequence-order((4, 3, 2, 1)),
        separation-line(2),
        no-shade((4,)),
        align-right-labels(),
      ),
    )
  ],
  panel[Domain And Gaps][
    #shade(
      protein,
      format: "fasta",
      commands: (
        domain(1, "1..2,4..4"),
        domain-gap-rule(1pt),
        domain-gap-colors("Red", "LightYellow"),
        gap-style(foreground: "Red", background: "LightYellow", rule: 0.7pt),
        gap-char("rule"),
        hide-leading-gaps(),
      ),
    )
  ],
)

#shade(
  ref-dna,
  format: "msf",
  figure: (
    single-sequence(sequence: 1),
    window(1, "414..443"),
    shift-single-sequence(),
    keep-single-sequence-gaps(),
    lower(1, "414..419"),
    mark("bottom", 1, "414..443", style: "complement[LightBlue][lower]", text: "complement"),
    mark("top", 1, "414..443", style: "translate[Red]", text: "translation"),
    backtranslation-label("oblique"),
    backtranslation-text("horizontal"),
    no-consensus(),
  ),
)

#shade(
  protein,
  format: "fasta",
  commands: (
    caption("Top caption", position: "top"),
    short-caption("short"),
    lines(4),
    character-stretch(1.2),
    line-stretch(1.2),
    numbering-width(6),
    small-separator(),
    large-block-gap(),
    medium-line-gap(),
    feature-slot-space("top", 2pt),
    text-family("names", "DejaVu Sans Mono"),
    text-weight("names", "bold"),
    text-posture("features", "italic"),
    text-size("all", 7pt),
    mark("top", 1, "1..2", style: "box[LightYellow]", text: "feature label"),
    feature-style-label("top", "style"),
    feature-text-label("top", "text"),
    feature-style-label-color("Blue"),
    feature-text-label-color("Red"),
  ),
)

== Inspection, Data, And Analysis Helpers

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 6pt,
  panel[Summary][#alignment-summary(protein, format: "fasta")],
  panel[Sequences][#sequence-list(protein, format: "fasta")],
  panel[Selections][
    #selection-table(
      protein,
      (name: "motif", selection: "A[ED]"),
      (name: "first two", selection: "1..2"),
      format: "fasta",
    )
  ],
)

#similarity-table(protein, format: "fasta")

#let parsed = alignment-data(protein, format: "fasta")
#let parsed-inline = parse-alignment(">One\nACGT\n>Two\nA-GT\n", format: "fasta")

#table(
  columns: 2,
  inset: 4pt,
  [Feature], [Rendered Result],
  [`selection-preview`], [#selection-preview(protein, 1, "A[ED]", format: "fasta")],
  [`percent-identity`], [#str(percent-identity(protein, 1, 2, format: "fasta")) + "%"],
  [`percent-similarity`], [#str(percent-similarity(protein, 1, 2, format: "fasta")) + "%"],
  [`molecular-weight`], [#molecular-weight("ACD")],
  [`net-charge`], [#net-charge("DEK")],
  [`alignment-data`], [#str(parsed.at("sequences").len()) + " sequences / " + str(parsed.at("columns")) + " columns"],
  [`parse-alignment`], [#str(parsed-inline.at("sequences").len()) + " inline sequences"],
  [`resolve-color`], [#box(width: 2em, height: 0.8em, fill: resolve-color("Red"))],
  [`scale-color`], [#box(width: 2em, height: 0.8em, fill: scale-color("ColdHot", 75))],
)
