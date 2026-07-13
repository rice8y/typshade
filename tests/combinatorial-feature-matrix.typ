/// Pairwise combinatorial regression matrix for public features.

// Visual combinatorial test for Typshade feature families.
//
// The complete Cartesian product of every numeric/string parameter is
// intentionally unbounded. This document instead combines all major public
// feature families across representative settings while tests/public-api.typ
// keeps one-by-one coverage of the public constructor surface.

#import "../package/lib.typ": *

#set document(title: "Typshade Combinatorial Feature Matrix")
#set page(paper: "a4", flipped: true, margin: 8mm)
#set text(size: 7pt, font: "Libertinus Serif")

#let tiny-protein = read("fixtures/tiny-protein.fasta", encoding: none)
#let tiny-dna = read("fixtures/tiny-dna.fasta", encoding: none)
#let tiny-msf = read("fixtures/tiny.msf", encoding: none)
#let tiny-aln = read("fixtures/tiny.aln", encoding: none)
#let ref-protein = read("fixtures/reference/AQPpro.MSF", encoding: none)
#let ref-dna = read("fixtures/reference/AQPDNA.MSF", encoding: none)
#let tcoffee-source = read("fixtures/reference/AQP_TC.asc", encoding: none)
#let topology-source = read("fixtures/reference/AQP1.phd", encoding: none)
#let hmmtop-source = read("fixtures/reference/AQP_HMM.sgl", encoding: none)
#let dssp-source = read("fixtures/reference/AQP1.top", encoding: none)
#let stride-source = read("fixtures/reference/AQP1.top", encoding: none)
#let pdb-source = read("fixtures/tiny.pdb", encoding: none)
#let frustration-source = read("fixtures/reference/frustr.txt", encoding: none)
#let stacked-bars-source = read("fixtures/reference/bars.txt", encoding: none)

#let heading(title) = [
  #v(4pt)
  #text(size: 10pt, weight: "bold")[#title]
  #v(2pt)
]

#let panel(title, body) = block(
  breakable: false,
  width: 100%,
  inset: 4pt,
  stroke: 0.35pt + rgb("#c9c9c9"),
  radius: 2pt,
  below: 5pt,
)[
  #text(size: 6.5pt, weight: "bold")[#title]
  #v(2pt)
  #body
]

#let small-shade(
  source,
  ..commands,
  format: "fasta",
  seq-type: "P",
  fit: "container",
  residues-per-line: 18,
  font-size: 4.8pt,
) = shade(
  source,
  format: format,
  seq-type: seq-type,
  fit: fit,
  residues-per-line: residues-per-line,
  legend: true,
  font-size: font-size,
  commands: commands.pos(),
)

#let scoring-packs = (
  (
    name: "identity",
    commands: (
      identical(colors: "reds", threshold: 50, all-match-threshold: 90),
      residue-style("conserved", "White", "BrickRed"),
      consensus-symbols(".", "lower", "upper"),
    ),
  ),
  (
    name: "similar",
    commands: (
      similar(colors: "blues", threshold: 50),
      peptide-groups(("AGST", "DE", "KR")),
      peptide-similarities("S", "T"),
    ),
  ),
  (
    name: "diverse",
    commands: (
      diverse(colors: "greens", threshold: 50),
      weight-table("BLOSUM62"),
      set-weight("A", "G", 2),
      gap-penalty(-2),
      residue-style("G", "Black", "LightGreen"),
    ),
  ),
  (
    name: "functional",
    commands: (
      clear-functional-groups(),
      functional-group("acidic", "DE", "White", "Red"),
      functional-group("basic", "KR", "White", "Blue"),
      functional-style("D", "White", "Red"),
      functional("charge"),
      shade-all-residues(),
      legend(),
    ),
  ),
)

#let selection-packs = (
  (
    name: "range",
    selection: select-range(1, 6),
    commands: (
      window(1, "1..8"),
      highlight(1, "1..4", bg: "LightYellow"),
    ),
  ),
  (
    name: "residue-list",
    selection: select-residues(2, 4, 6, 8),
    commands: (
      sequence-order((2, 1, 4, 3)),
      tint(1, "2,4,6,8", intensity: "strong"),
      no-shade((4,)),
    ),
  ),
  (
    name: "motif",
    selection: select-motif("A[ED]"),
    commands: (
      motif(1, "A[ED]", fill: "LightBlue", text: "A-acidic", all: true),
      feature-text-label("top", "motifs"),
    ),
  ),
  (
    name: "metric",
    selection: select-metric("coverage", at-least: 75),
    commands: (
      graph("top", 1, "all", "coverage", kind: "bar", options: ("PineGreen", "Gray10"), text: "coverage"),
      bar-graph-stretch(1.2),
    ),
  ),
  (
    name: "logic-pad",
    selection: select-or(
      select-and(select-range(2, 8), select-not(select-residues(5))),
      select-pad(select-motif("G"), 1, after: 1),
    ),
    commands: (
      mark("top", 1, select-pad(select-motif("G"), 1, after: 1), style: "box[LightGreen]", text: "padG"),
      frame(1, "2..8", color: "ForestGreen"),
    ),
  ),
)

#let render-scoring-selection() = {
  heading("Scoring x Selection")
  let cells = ()
  for scoring in scoring-packs {
    for selection in selection-packs {
      cells.push(panel(scoring.name + " / " + selection.name)[
        #small-shade(
          tiny-protein,
          ..scoring.commands,
          ..selection.commands,
          window(1, selection.selection),
        )
      ])
    }
  }
  grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 4pt, ..cells)
}

#let track-packs = (
  (
    name: "names-numbering",
    commands: (
      names(position: "leftright", color: "DarkGray"),
      numbers(position: "leftright", color: "Gray50"),
      sequence-name(1, "alpha"),
      sequence-name-color((1,), "Blue"),
      sequence-number-color((1,), "Gray50"),
      numbering-width(3),
    ),
  ),
  (
    name: "ruler-consensus",
    commands: (
      ruler("top", every: 2, color: "DarkGray", name: "ruler"),
      ruler-marker(4, "m4", position: "top", color: "Red"),
      consensus("bottom", name: "cons"),
      consensus-symbols(".", ":", "*"),
      consensus-colors(conserved-fg: "Blue", allmatch-fg: "Red"),
    ),
  ),
  (
    name: "logo-legend",
    commands: (
      sequence-logo(position: "top", colors: "chemical", stretch: 1.05),
      subfamily-logo((1, 2), position: "bottom", colors: "charge", name: "upper"),
      logo-scale(position: "leftright", color: "Black"),
      logo-color("A", "Blue"),
      legend(),
    ),
  ),
  (
    name: "layout-type",
    commands: (
      lines(auto),
      auto-layout(min: 10, max: 24),
      text-size("all", 5pt),
      character-stretch(0.88),
      line-gap(2pt),
      block-gap(3pt),
      alignment-position("center"),
      small-separator(),
    ),
  ),
)

#let annotation-packs = (
  (
    name: "region-styles",
    commands: (
      highlight(1, "1..3", bg: "LightYellow"),
      tint(1, "4..6", intensity: "weak"),
      emphasize(1, "7..9"),
      lower(1, "10..12"),
      frame(1, "1..12", color: "Gray50"),
    ),
  ),
  (
    name: "features",
    commands: (
      mark("top", 1, "2..5", style: "box[LightGreen]", text: "site"),
      mark("bottom", 1, "4..8", style: "brace[Blue]", text: "brace"),
      feature-rule(0.5pt),
      feature-text-label("top", "text"),
      feature-style-label("top", "style"),
      feature-text-label-color("ForestGreen"),
      feature-style-label-color("Blue"),
      feature-text-label-color-at("top", "Red"),
    ),
  ),
  (
    name: "graphs",
    commands: (
      graph("top", 1, "all", "conservation", kind: "bar", options: ("Blue", "Gray10"), text: "cons"),
      graph("bottom", 1, "all", "entropy", kind: "color", options: ("WhiteBlack",), text: "entropy"),
      graph("ttop", 1, "all", "coverage", kind: "bar", options: ("PineGreen", "Gray10"), text: "coverage"),
      bar-graph-stretch(1.2),
      color-scale-stretch(1.2),
    ),
  ),
  (
    name: "visibility-order",
    commands: (
      hide-sequence(3),
      sequence-order((2, 1, 4)),
      separation-line(2),
      no-shade((4,)),
      align-right-labels(),
      show-all-sequences(),
    ),
  ),
)

#let render-tracks-annotations() = {
  heading("Tracks x Annotation")
  let cells = ()
  for track in track-packs {
    for annotation in annotation-packs {
      cells.push(panel(track.name + " / " + annotation.name)[
        #small-shade(
          tiny-protein,
          ..track.commands,
          ..annotation.commands,
        )
      ])
    }
  }
  grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 4pt, ..cells)
}

#let layout-packs = (
  (
    name: "container-fit",
    fit: "container",
    commands: (
      lines(auto),
      ruler("top", every: 4),
      legend(),
    ),
  ),
  (
    name: "page-fit",
    fit: (mode: "page", min: 12, max: 30, page: (blocks: 2, repeat-legend: true)),
    commands: (
      auto-page(blocks: 2, repeat-legend: true),
      auto-layout(min: 12, max: 30),
      ruler("top", every: 5),
    ),
  ),
  (
    name: "manual",
    fit: false,
    commands: (
      lines(14),
      block-gap(4pt),
      character-stretch(0.92),
      ruler("top"),
    ),
  ),
)

#let content-packs = (
  (
    name: "basic",
    source: tiny-protein,
    format: "fasta",
    seq-type: "P",
    commands: (
      identical(threshold: 50),
      similar(threshold: 50),
      consensus("bottom"),
    ),
  ),
  (
    name: "logo-graph",
    source: ref-protein,
    format: "msf",
    seq-type: "P",
    commands: (
      window(1, "138..175"),
      sequence-logo(position: "top", colors: "chemical"),
      graph("bottom", 1, "138..175", "hydrophobicity", kind: "bar", options: ("PineGreen", "Gray10"), text: "hydro"),
      consensus("bottom"),
    ),
  ),
  (
    name: "dna-translation",
    source: ref-dna,
    format: "msf",
    seq-type: "N",
    commands: (
      window(1, "414..443"),
      single-sequence(sequence: 1),
      shift-single-sequence(),
      keep-single-sequence-gaps(),
      genetic-code("standard"),
      codon("M", "ATG"),
      mark("top", 1, "414..443", style: "translate[Red]", text: "AA"),
      mark("bottom", 1, "414..443", style: "complement[LightBlue][lower]", text: "comp"),
      backtranslation-label("oblique"),
      backtranslation-text("horizontal"),
    ),
  ),
)

#let render-layout-content() = {
  heading("Auto Layout / Pagination x Content")
  let cells = ()
  for layout in layout-packs {
    for content in content-packs {
      cells.push(panel(layout.name + " / " + content.name)[
        #small-shade(
          content.source,
          ..layout.commands,
          ..content.commands,
          format: content.format,
          seq-type: content.seq-type,
          fit: layout.fit,
          residues-per-line: 22,
          font-size: 4.5pt,
        )
      ])
    }
  }
  grid(columns: (1fr, 1fr, 1fr), gutter: 4pt, ..cells)
}

#let render-format-recipes() = [
  #heading("Formats, Recipes, External Tracks")
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 4pt,
    panel("Recipes / publication and motif-map")[
      #shade(
        ref-protein,
        format: "msf",
        figure: publication(region: "80..112", sequence: 1, motifs: ("AQ": "AQ"), logo: false, conservation: true),
        font-size: 4.5pt,
      )
      #v(2pt)
      #shade(
        ref-protein,
        format: "msf",
        figure: motif-map(("AQ": "AQ", "GA": (text: "GA", bg: "LightYellow")), sequence: 1, region: "80..112", logo: false),
        font-size: 4.5pt,
      )
    ],
    panel("MSF / structure tracks")[
      #small-shade(
        ref-protein,
        window(1, "138..170"),
        structure-tracks(1, topology: topology-source, secondary: topology-source, hmmtop: hmmtop-source),
        dssp-track(1, dssp-source),
        stride-track(1, stride-source),
        show-structure-types("PHDsec", ("alpha", "beta")),
        hide-structure-types("PHDtopo", ("external",)),
        structure-appearance("PHDtopo", "TM", "top", "box[LightBlue]", "TM"),
        use-second-dssp-column(),
        no-consensus(),
        format: "msf",
      )
    ],
    panel("CLUSTAL / PDB and frustration")[
      #small-shade(
        tiny-aln,
        highlight(1, pdb-selection(pdb-point(pdb-source, 1, distance: 0.2, atom: "CA")), bg: "LightGreen"),
        tint(2, pdb-selection(pdb-line(pdb-source, 1, 2, distance: 0.2, atom-a: "CA", atom-b: "CA"))),
        emphasize(3, pdb-selection(pdb-plane(pdb-source, 1, 2, 3, distance: 0.2, atom-a: "CA", atom-b: "CA", atom-c: "CA"))),
        graph("top", 1, "all", "conservation", kind: "color", options: ("ColdHot",), text: "cons"),
        format: "aln",
      )
    ],
    panel("MSF / T-Coffee and graph-data")[
      #small-shade(
        ref-protein,
        window(1, "138..170"),
        tcoffee(tcoffee-source),
        graph("ttop", 1, "138..170", frustration-source, kind: "frustratometer", text: "frustration"),
        graph("top", 1, "138..170", "charge", kind: "color", options: ("ColdHot",), text: "charge"),
        graph("bottom", 1, "138..170", stacked-bars-source, kind: "stackedbars", options: ("BlueRed", "Gray10"), text: "stack"),
        consensus("bottom", scale: "T-Coffee", name: "tc"),
        format: "msf",
      )
    ],
    panel("Recipes / structure and logo analysis")[
      #shade(
        ref-protein,
        format: "msf",
        figure: structure-map(1, topology: topology-source, secondary: topology-source, hmmtop: hmmtop-source, region: "1..80", line-length: 40),
        font-size: 4.5pt,
      )
      #v(2pt)
      #shade(
        ref-protein,
        format: "msf",
        figure: logo-analysis(sequence: 3, region: "203..235", subfamily: (3,), relevance: (threshold: 1.0, char: "*", color: "Red")),
        font-size: 4.5pt,
      )
    ],
    panel("MSF / selection table and cell inspect")[
      #small-shade(
        ref-protein,
        window(1, select(select-range(1, 8), select-motif("NPA"), padding: 1)),
        cell-style(ctx => if ctx.at("column") == 2 { (frame: "Red") } else { none }),
        highlight(1, select-metric("coverage", at-least: 60), bg: "LightYellow"),
        format: "msf",
      )
      #v(2pt)
      #selection-table(
        ref-protein,
        (name: "range", selection: select-range(1, 3)),
        (name: "motif", selection: select-motif("NPA")),
        (name: "metric", selection: select-metric("coverage", at-least: 60, selection: select-range(1, 12))),
        format: "msf",
      )
      #v(2pt)
      #cell-inspect(ref-protein, 1, 2, format: "msf", commands: (cell-style(ctx => if ctx.at("column") == 2 { (frame: "Red") } else { none }),))
    ],
  )
]

#let render-output-wrappers() = [
  #heading("Wrappers And Export-Oriented Output")
  #grid(
    columns: (1fr, 1fr),
    gutter: 4pt,
    panel("Figure caption")[
      #figure(
        shade(
          tiny-msf,
          format: "msf",
          fit: "container",
          residues-per-line: auto,
          legend: true,
          commands: (
            identical(threshold: 50),
            ruler("top"),
          ),
        ),
        caption: [Combinatorial smoke figure],
      )
    ],
    panel("Debug and analysis output")[
      #alignment-debug(tiny-protein, format: "fasta", commands: (lines(auto),))
      #v(3pt)
      #alignment-summary(tiny-protein, format: "fasta")
      #v(3pt)
      #similarity-table(tiny-protein, format: "fasta")
    ],
  )
]

= Typshade Combinatorial Feature Matrix

This file is a visual regression stress test. It combines feature families
instead of attempting the infinite product of all numeric and textual settings.

#render-scoring-selection()

#pagebreak()
#render-tracks-annotations()

#pagebreak()
#render-layout-content()

#pagebreak()
#render-format-recipes()

#pagebreak()
#render-output-wrappers()
