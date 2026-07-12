//! Visual parity fixture for TeXshade-compatible behavior.

#import "../package/lib.typ": *

#set page(width: 297mm, height: 210mm, margin: 8mm)
#set text(size: 7.4pt)
#set par(leading: 0.45em)

#let ref-protein = read("fixtures/reference/AQPpro.MSF", encoding: none)
#let ref-dna = read("fixtures/reference/AQPDNA.MSF", encoding: none)
#let species = read("fixtures/reference/AQP2spec.ALN", encoding: none)
#let tcoffee-source = read("fixtures/reference/AQP_TC.asc", encoding: none)
#let topology = read("fixtures/reference/AQP1.phd", encoding: none)
#let hmmtop = read("fixtures/reference/AQP_HMM.ext", encoding: none)
#let frustration = read("fixtures/reference/frustr.txt", encoding: none)
#let stacked-bars = read("fixtures/reference/bars.txt", encoding: none)

#let panel(title, body) = block(
  breakable: false,
  inset: 4pt,
  stroke: 0.35pt + luma(210),
  radius: 2pt,
)[
  #text(weight: "bold")[#title]
  #v(2pt)
  #body
]

#let two(a, b) = grid(columns: (1fr, 1fr), gutter: 5pt, a, b)

= Typshade Visual Parity Specimens

This document mirrors the representative figure families in TeXshade's package
overview. It is intentionally image-oriented: the parity runner converts this
PDF and the TeXshade reference manual to PNG pages for side-by-side inspection.

== Identity, Domain, Consensus, And Similarity

#two(
  panel[Identity mode with consensus][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "80..112"),
        identical(colors: "blues", threshold: 50, all-match-threshold: 80),
        consensus("bottom", scale: "ColdHot"),
        consensus-symbols(".", "lower", "upper"),
        legend(),
      ),
    )
  ],
  panel[Domain selection with ruler][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        domain(1, "80..90,100..110,120..130"),
        ruler("top", sequence: 1, every: 10),
        no-numbering(),
        no-consensus(),
      ),
    )
  ],
)

#two(
  panel[Similarity mode with feature marks][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "80..112"),
        similar(colors: "blues", threshold: 50, all-match-threshold: 80),
        no-consensus(),
        mark("top", 1, "93..93", style: "fill:v[Red]", text: "first case"),
        mark("bottom", 1, "98..98", style: "fill:^[Red]", text: "second case"),
      ),
    )
  ],
  panel[T-Coffee scoring and color scale][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "30..63"),
        tcoffee(tcoffee-source),
        graph("top", 1, "30..63", "conservation", kind: "color", options: ("T-Coffee",), text: "feat-cons"),
        consensus("bottom"),
      ),
    )
  ],
)

#pagebreak()

== Diverse And Functional Shading

#two(
  panel[Diverse mode][
    #shade(
      species,
      format: "aln",
      seq-type: "P",
      commands: (
        diverse(),
        window(1, "77..109"),
        ruler("top", sequence: 1, every: 10),
        no-numbering(),
        names(position: "left"),
        sequence-name(1, "Bos taurus"),
        sequence-name(2, "Canis familiaris"),
        sequence-name(3, "Dugong dugong"),
        sequence-name(4, "Equus caballus"),
        sequence-name(5, "Elephas maximus"),
        frame(1, "82..82,106..106", color: "Red"),
        mark("top", 1, "77..109", style: none, text: "AQP2 species variants"),
      ),
    )
  ],
  panel[Functional charge][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "138..170"),
        functional("charge"),
        graph("top", 3, "153..165", "-50,-45,-40,-30,-20,-10,0,10,20,30,40,45,50", kind: "bar", range: (-50, 50)),
        graph("bottom", 3, "167..186", "5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100", kind: "color", options: ("ColdHot",)),
        legend(),
      ),
    )
  ],
)

#two(
  panel[Hydropathy with tint and lower case][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "138..170"),
        functional("hydropathy"),
        tint-block(1, "158..163"),
        lower-block(1, "QLVLC"),
        mark("top", 1, "158..163", style: "brace", text: "tinted"),
        mark("bottom", 1, "QLVLC", style: "brace", text: "lowercased"),
        legend(),
      ),
    )
  ],
  panel[Structure-style functional mode][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "138..170"),
        functional("structure"),
        mark("top", 1, "138..157", style: "box[Blue,Red][0.5pt]:alpha[Yellow]", text: "transmembrane domain 4"),
        mark("top", 1, "158..163", style: "translate[Blue]"),
        backtranslation-label("oblique"),
        mark("bottom", 1, "[DE]RXXR[DE]", style: "brace[Blue]", text: "loop D"),
        mark("top", 1, "164..170", style: "o->[Red]", text: "trans. dom. 5"),
        legend(),
      ),
    )
  ],
)

#pagebreak()

== Functional Palettes And Graph Tracks

#grid(
  columns: (1fr, 1fr),
  gutter: 5pt,
  panel[Chemical][
    #shade(ref-protein, format: "msf", commands: (window(1, "138..170"), functional("chemical"), legend()))
  ],
  panel[Rasmol, shade all][
    #shade(ref-protein, format: "msf", commands: (window(1, "138..170"), functional("rasmol"), shade-all-residues(), ruler("top", sequence: 1, every: 1), legend()))
  ],
)

#v(4pt)

#two(
  panel[Standard area][
    #shade(ref-protein, format: "msf", commands: (window(1, "138..170"), functional("standard area"), shade-all-residues(), legend()))
  ],
  panel[Accessible area with helix labels][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(1, "138..170"),
        functional("accessible area"),
        shade-all-residues(),
        mark("top", 1, "138..157,164..170", style: "helix", text: "membr."),
        mark("top", 1, "158..163", style: "---", text: "loop"),
        feature-rule(1mm),
        legend(),
      ),
    )
  ],
)

#v(4pt)

#panel[Bar, color, frustration, and stacked graphs][
  #shade(
    ref-protein,
    format: "msf",
    commands: (
      window(1, "138..170"),
      no-consensus(),
      graph("tttop", 1, "138..170", frustration, kind: "frustratometer", text: "frustr."),
      graph("ttop", 1, "138..170", "conservation", kind: "bar", text: "conserv."),
      graph("top", 1, "138..170", "charge", kind: "color", text: "charge"),
      graph("bottom", 1, "138..170", "molweight", kind: "color", options: ("ColdHot",), text: "mol. weight"),
      graph("bbottom", 1, "138..170", "hydrophobicity", kind: "bar", options: ("LightBrown", "Gray10"), text: "hydrophob."),
      graph("bbbottom", 1, "138..170", stacked-bars, kind: "stackedbars", options: ("BlueRed", "Gray10"), text: "8-bar stack"),
      bar-graph-stretch(2),
    ),
  )
]

#pagebreak()

== Structure Tracks, Fingerprints, Logos, And Single Sequence

#panel[Secondary structure and topology tracks][
  #shade(
    ref-protein,
    format: "msf",
    commands: (
      similar(colors: "blues", all-match-threshold: 100),
      window(1, "1..115"),
      lines(40),
      structure-tracks(1, topology: topology, secondary: topology, hmmtop: hmmtop),
    ),
  )
]

#v(4pt)

#panel[Fingerprint overview][
  #shade(
    ref-protein,
    format: "msf",
    commands: (
      similar(colors: "grays", all-match-threshold: 100),
      fingerprint(220),
      legend(),
      mark("top", 1, "13..36,51..68,94..112,138..156,165..185,211..232", style: ",-,", text: "TM"),
    ),
  )
  #v(4pt)
  #shade(
    ref-protein,
    format: "msf",
    commands: (
      functional("charge"),
      shade-all-residues(),
      fingerprint(220),
      gap-char("rule"),
      legend(),
    ),
  )
]

#two(
  panel[DNA sequence logo][
    #shade(
      ref-dna,
      format: "msf",
      commands: (
        window(1, "414..443"),
        sequence-logo(position: "top", colors: "DNA", name: "logo", scale: "leftright"),
        functional("DNA"),
      ),
    )
  ],
  panel[Protein sequence logo, no sequence rows][
    #shade(
      ref-protein,
      format: "msf",
      commands: (
        window(3, "203..235"),
        lines(33),
        sequence-logo(position: "top", name: "logo", scale: "leftright"),
        consensus("bottom", scale: "ColdHot", name: "conservation"),
        ruler("bottom", sequence: 3, every: 1),
        hide-all-sequences(),
        mark("top", 3, "208..210", style: "---", text: "NPA"),
        mark("top", 3, "211..219", style: "helix"),
        mark("top", 3, "220..232", style: "brace", text: "loop E"),
        mark("top", 3, "233..235", style: "helix", text: "TM6"),
      ),
    )
  ],
)

#v(4pt)

#panel[Subfamily logo, no sequence rows][
  #shade(
    ref-protein,
    format: "msf",
    commands: (
      window(3, "203..235"),
      lines(33),
      subfamily-logo((3,), position: "top", name: "AQP3", negative-name: "others"),
      logo-scale(position: "leftright"),
      relevance-threshold(1.0),
      relevance-marker(char: "*", color: "Red"),
      ruler("bottom", sequence: 3, every: 5),
      hide-all-sequences(),
      no-consensus(),
    ),
  )
]

#pagebreak()

== Single Sequence, Translation, Complement, And Tables

#shade(
  ref-dna,
  format: "msf",
  commands: (
    single-sequence(sequence: 1),
    shift-single-sequence(),
    window(1, "414..443"),
    lower(1, "439..443"),
    mark("bottom", 1, "424..443", style: "complement[LightBlue][lower]", text: "complement"),
    mark("top", 1, "414..443", style: "translate[Red]", text: "translation"),
    text-size("all", 6pt),
    no-block-gap(),
    no-consensus(),
  ),
)

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 6pt,
  panel[Similarity / identity table][
    #similarity-table(ref-protein, format: "msf")
  ],
  panel[Analysis helpers][
    #alignment-summary(ref-protein, format: "msf")
    #v(4pt)
    AQP1/AQP2 identity: #percent-identity(ref-protein, 1, 2, format: "msf")%
    #linebreak()
    AQP1/AQP2 similarity: #percent-similarity(ref-protein, 1, 2, format: "msf")%
  ],
)
