//! Compile-time smoke coverage for the complete public API.

#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 8pt)
#set text(size: 8pt)

#let tcoffee-source = read("fixtures/reference/AQP_TC.asc", encoding: none)
#let structure-source = read("fixtures/reference/AQP1.phd", encoding: none)
#let hmmtop-source = read("fixtures/reference/AQP_HMM.sgl", encoding: none)
#let stride-source = read("fixtures/reference/AQP1.top", encoding: none)
#let dssp-source = read("fixtures/reference/AQP1.top", encoding: none)
#let pdb-source = read("fixtures/tiny.pdb", encoding: none)

// COMMAND-SURFACE-BEGIN
#let commands = (
  sequence-type("P"),
  color-scheme("blues"),
  scoring-mode("similar"),
  tcoffee-scores(tcoffee-source),
  sequence-window(1, "1..5"),
  residues-per-line(10),
  auto-layout(max: 10),
  auto-page(blocks: 2),
  threshold(50),
  shade-all-residues(),
  all-match-threshold(value: 80),
  disable-all-match-threshold(),
  hide-all-match-positions(),
  show-all-match-positions(),
  weight-table("BLOSUM62"),
  set-weight("A", "G", 2),
  gap-penalty(-1),
  residue-style("conserved", "White", "Blue"),
  cell-style(ctx => if ctx.at("column") == 1 { (frame: "Red") } else { none }),
  peptide-groups(("AG", "ST")),
  dna-groups(("AG", "CT")),
  peptide-similarities("S", "T"),
  dna-similarities("A", "G"),
  clear-functional-groups(),
  functional-group("acidic", "DE", "White", "Red"),
  functional-style("D", "White", "Red"),
  names-track(),
  no-names(),
  numbering-track(),
  no-numbering(),
  sequence-name(1, "Alpha"),
  names-color("Red"),
  sequence-name-color((1,), "Blue"),
  hide-sequence-name((1,)),
  numbering-color("Gray50"),
  sequence-number-color((1,), "Gray50"),
  hide-sequence-number((1,)),
  consensus-name("cons"),
  consensus-language("english"),
  consensus-symbols(".", "lower", "upper"),
  consensus-colors(),
  consensus-from-sequence(1),
  consensus-from-all-sequences(),
  ruler-steps(10),
  ruler-color("Black"),
  ruler-name("positions"),
  ruler-name-color("Black"),
  ruler-space(2pt),
  rotate-ruler(),
  unrotate-ruler(),
  gap-char("-"),
  gap-rule(0.5pt),
  gap-colors("Black", "White"),
  stop-char("*"),
  show-leading-gaps(),
  hide-leading-gaps(),
  start-number(1, 10),
  allow-zero-numbering(),
  disallow-zero-numbering(),
  sequence-length(1, 4),
  domain(1, "1..3"),
  domain-gap-rule(1pt),
  domain-gap-colors("Black", "White"),
  highlight-block(1, "1..2", "White", "Red"),
  region-color-scheme(1, "1..2", "reds"),
  lower(1, "1..2"),
  lower-block(1, "1..2"),
  emphasis-block(1, "1..2"),
  tint-block(1, "1..2"),
  tint-default("weak"),
  emphasis-default("italic"),
  frame(1, "1..2"),
  hide-sequence(1),
  hide-all-sequences(),
  show-all-sequences(),
  remove-sequence(1),
  no-shade((1,)),
  separation-line(1),
  sequence-order((2, 1)),
  feature-rule(1pt),
  codon("A", "GCA,GCG"),
  genetic-code("standard"),
  backtranslation-label("horizontal"),
  backtranslation-text("horizontal"),
  feature-text-label("top", "features"),
  feature-style-label("top", "styles"),
  hide-feature-text-label("top"),
  hide-feature-style-label("top"),
  hide-feature-text-labels(),
  hide-feature-style-labels(),
  feature-text-label-color("Red"),
  feature-style-label-color("Blue"),
  feature-text-label-color-at("top", "Red"),
  feature-style-label-color-at("top", "Blue"),
  frequency-correction(),
  no-frequency-correction(),
  subfamily((1,)),
  sequence-logo-name("logo"),
  subfamily-logo-name("sub", negative-name: "other"),
  logo-scale(),
  no-logo-scale(),
  logo-stretch(1.2),
  negative-logo-values(),
  no-negative-logo-values(),
  relevance-threshold(1.0),
  relevance-marker(),
  no-relevance-marker(),
  logo-color("DE", "Red"),
  clear-logo-colors(),
  no-legend(),
  legend-color("Black"),
  legend-offset(0pt, 0pt),
  color-swatch("Red"),
  show-structure-types("DSSP", ("alpha",)),
  hide-structure-types("DSSP", ("turn",)),
  structure-appearance("DSSP", "alpha", "top", "box", "alpha"),
  use-first-dssp-column(),
  use-second-dssp-column(),
  stride-track(1, stride-source),
  dssp-track(1, dssp-source),
  hmmtop-track(1, hmmtop-source),
  phd-topology-track(1, structure-source),
  phd-secondary-track(1, structure-source),
  keep-single-sequence-gaps(),
  shift-single-sequence(),
  hide-residues(),
  show-residues(),
  bar-graph-stretch(2),
  color-scale-stretch(2),
  alignment-position("center"),
  character-stretch(1.0),
  line-stretch(1.0),
  numbering-width(4),
  fingerprint(100),
  align-right-labels(),
  align-left-labels(),
  text-family("all", "New Computer Modern"),
  text-weight("all", "regular"),
  text-posture("all", "normal"),
  text-size("all", 8pt),
  text-style("all", "New Computer Modern", "regular", "normal", 8pt),
  caption("caption"),
  short-caption("short"),
  small-separator(),
  medium-separator(),
  large-separator(),
  no-block-gap(),
  small-block-gap(),
  medium-block-gap(),
  large-block-gap(),
  block-gap(1em),
  flexible-block-gap(),
  fixed-block-gap(),
  no-line-gap(),
  small-line-gap(),
  medium-line-gap(),
  large-line-gap(),
  line-gap(2pt),
  feature-slot-space("top", 2pt),
  molecular-weight("ACD"),
  net-charge("DEK"),
  pdb-selection(pdb-point(pdb-source, 1)),
  identical(colors: "blues", threshold: 50),
  similar(colors: "blues", threshold: 50),
  diverse(option: 1),
  functional("charge"),
  single-sequence(sequence: 1),
  tcoffee(tcoffee-source),
  lines(10),
  window(1, "1..3"),
  names(),
  no-names(),
  numbers(),
  no-numbers(),
  consensus("bottom"),
  no-consensus(),
  ruler("top"),
  no-ruler(),
  logo("top"),
  no-logo(),
  legend(),
  no-legend(),
  structures(1, topology: structure-source),
  gap-style(rule: 0.5pt),
  typography(target: "all", size: 8pt),
  consensus-track(),
  ruler-track(),
  ruler-marker(1, "one"),
  sequence-logo(),
  no-sequence-logo(),
  subfamily-logo((1,)),
  no-subfamily-logo(),
  legend-track(),
  structure-tracks(1, topology: structure-source),
  pdb-point(pdb-source, 1),
  pdb-line(pdb-source, 1, 2),
  pdb-plane(pdb-source, 1, 2, 3),
  select-all(),
  select-range(1, 2),
  select-residues(1, 3),
  select-motif("AE"),
  select-metric("coverage", at-least: 50),
  select-or(select-residues(1), select-residues(3)),
  select-and(select-range(1, 3), select-motif("AE")),
  select-not(select-residues(2)),
  select-pad(select-residues(2), 1),
  select("1..2", select-motif("AE"), padding: 1),
  highlight(1, "1..2"),
  tint(1, "1..2"),
  emphasize(1, "1..2"),
  mark("top", 1, "1..2"),
  motif(1, "AE"),
  graph("top", 1, "all", "conservation"),
  graph("bottom", 1, "all", "entropy", kind: "color"),
  publication(motifs: auto),
  motif-map(("AE": "active site")),
  structure-map(1, topology: structure-source),
  logo-analysis(subfamily: (1,)),
  overview(),
  visual-theme(colors: "blues"),
  shade-theme("screen"),
  shade-preset("publication"),
  resolve-color("Red"),
  scale-color("ColdHot", 50),
  alignment-debug(">Alpha\nAC\n>Beta\nAT\n", format: "fasta", commands: (lines(auto),)),
  cell-inspect(">Alpha\nAC\n>Beta\nAT\n", 1, 1, format: "fasta"),
)
// COMMAND-SURFACE-END

#assert(commands.len() > 180)
#assert.eq(type(resolve-color("Red")), color)
#assert.eq(type(scale-color("ColdHot", 50)), color)
#assert.eq(molecular-weight("ACD"), "343")
#assert.eq(type(net-charge("DEK")), str)

Public API command constructors: #commands.len()

#let command-label(item) = {
  if type(item) == dictionary and item.keys().contains("kind") {
    item.at("kind")
  } else {
    str(type(item))
  }
}

#let command-cells = ()
#for (idx, item) in commands.enumerate() {
  command-cells.push([
    #text(font: "DejaVu Sans Mono", size: 5.6pt)[#str(idx + 1) #command-label(item)]
  ])
}

= Visual Command Surface

Every public command constructor above is represented in this rendered table.
The strict runner converts this PDF to PNG pages so command-surface coverage is
checked through the same visual pipeline as rendered alignment figures.

#table(
  columns: 4,
  inset: 2pt,
  stroke: 0.25pt + luma(220),
  ..command-cells,
)

== Visual Constructor Source

The following source excerpt is rendered intentionally. It makes the generated
PNG contain the exact public helper names, including helpers that expand to the
same lower-level command kind.

#let public-api-source = read("public-api.typ")
#let constructor-source = (
  public-api-source
  .split("// COMMAND-SURFACE-BEGIN")
  .at(1)
  .split("// COMMAND-SURFACE-END")
  .at(0)
)

#raw(constructor-source, lang: "typst", block: true)
