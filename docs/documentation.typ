//! Complete Typshade manual with executable examples and rendered results.

#import "../package/lib.typ": *

#set document(title: "Typshade Documentation", author: "Eito Yoneyama")
#set page(
  paper: "a4",
  margin: (x: 28mm, y: 25mm),
  numbering: "1",
)
#set text(size: 10pt, font: "New Computer Modern")
#set par(justify: true, leading: 0.55em)
#set heading(numbering: "1.1")
#show heading: set block(above: 1.25em, below: 0.55em)
#show heading.where(level: 1): set text(size: 13pt, weight: "bold")
#show heading.where(level: 2): set text(size: 11pt, weight: "bold")
#show table: set table(stroke: 0.35pt + luma(215))
#show table: set text(size: 8.3pt)
#show table.cell: it => {
  set par(justify: false, leading: 0.45em)
  show raw.where(block: false): set text(size: 6.8pt)
  it
}
#show table.cell.where(y: 0): set text(weight: "bold")
#show raw.where(block: false): set text(size: 8.5pt)
#show raw.where(block: true): it => block(
  width: 100%,
  fill: luma(248),
  stroke: 0.35pt + luma(220),
  radius: 2pt,
  inset: 6pt,
  below: 0.75em,
)[
  #set text(size: 7.4pt)
  #it
]

#let typshade-logo(size: 22pt) = {
  let logo-face = "New Computer Modern"
  let shaded(letter) = box(
    fill: black,
    inset: (x: 0.08em, y: 0.02em),
    outset: (y: 0.05em),
  )[#text(font: logo-face, fill: white)[#letter]]

  text(size: size)[
    Typ#text(font: logo-face)[#shaded("s")#shaded("h")a#shaded("d")e]
  ]
}

#let article-note(title, body) = align(center)[
  #block(
    width: 86%,
    inset: (x: 10pt, y: 7pt),
    stroke: (left: 1.1pt + black, rest: 0.35pt + luma(220)),
    fill: luma(252),
  )[
    #align(left)[#text(weight: "bold")[#title] #body]
  ]
]

#let article-abstract(body) = align(center)[
  #block(width: 86%, inset: (x: 0pt, y: 0.2em))[
    #align(center)[#text(weight: "bold")[Abstract]]
    #v(0.35em)
    #align(left)[#body]
  ]
]

#let example-result(body, label: none, breakable: true) = block(
  width: 100%,
  inset: 7pt,
  fill: luma(252),
  stroke: 0.35pt + luma(215),
  radius: 2pt,
  breakable: breakable,
  below: 0.9em,
)[
  #text(weight: "bold", size: 8.5pt)[Typeset result]
  #if label != none [
    #h(0.5em)
    #text(size: 8.2pt, fill: luma(80))[#label]
  ]
  #v(4pt)
  #{
    set text(size: 6.8pt)
    body
  }
]

#let browser-result(body, label: none, breakable: true) = block(
  width: 100%,
  inset: 7pt,
  fill: luma(252),
  stroke: 0.35pt + luma(215),
  radius: 2pt,
  breakable: breakable,
  below: 0.9em,
)[
  #text(weight: "bold", size: 8.5pt)[Browser-rendered HTML]
  #if label != none [
    #h(0.5em)
    #text(size: 8.2pt, fill: luma(80))[#label]
  ]
  #v(4pt)
  #body
]

#let result-panel(title, body) = block(
  width: 100%,
  inset: 5pt,
  fill: white,
  stroke: 0.3pt + luma(225),
  radius: 2pt,
)[
  #text(weight: "bold", size: 7.1pt)[#title]
  #v(3pt)
  #{
    set text(size: 6.2pt)
    body
  }
]

#let get-version = toml("../package/typst.toml")
#let demo-protein = read("../tests/fixtures/reference/AQPpro.MSF", encoding: none)
#let demo-dna = read("../tests/fixtures/reference/AQPDNA.MSF", encoding: none)
#let demo-topology = read("../tests/fixtures/reference/AQP1.phd", encoding: none)
#let demo-hmmtop = read("../tests/fixtures/reference/AQP_HMM.sgl", encoding: none)
#let demo-tcoffee = read("../tests/fixtures/reference/AQP_TC.asc", encoding: none)
#let demo-tiny-protein = read("../tests/fixtures/tiny-protein.fasta", encoding: none)
#let demo-tiny-aln = read("../tests/fixtures/tiny.aln", encoding: none)
#let demo-pdb = read("../tests/fixtures/tiny.pdb", encoding: none)

#align(center)[
  #text(size: 18pt, weight: "bold")[#typshade-logo(size: 20pt) Documentation]
  #v(0.35em)
  #text(size: 11pt)[Version #get-version.package.version]
  #v(0.25em)
  #text(size: 10pt)[Eito Yoneyama]
  #v(0.25em)
  #text(size: 10pt)[#datetime.today().display()]
  #v(0.7em)
  #line(length: 58%, stroke: 0.45pt + black)
]

#v(1.2em)

#article-abstract[
  Typshade is a Typst-native package for multiple-sequence alignment figures. It
  reimplements the practical feature set of TeXshade for shading and labeling
  nucleotide and peptide alignments, while exposing the interface as
  Typst-native building blocks: purpose-level recipes, named arguments, command
  helper lists, and reusable helper functions.
]

#v(1.2em)

#outline(title: [Contents], depth: 2)

#pagebreak()

= Design Goals

- Preserve TeXshade-style bioinformatics capabilities: shading, consensus,
  numbering, rulers, regions, features, graphs, sequence logos, subfamily logos,
  and structure tracks.
- Prefer Typst-native APIs over TeX macro compatibility.
- Make the common workflow short and readable through `shade(..., figure: (...))`.
- Keep low-level command helpers for exact, reproducible control.
- Avoid hidden global state. A figure should mostly describe itself where it is
  rendered.

= Package Overview

Typshade is not an aligner. Like TeXshade, it assumes that a scientific
alignment program has already produced an aligned nucleotide or peptide
sequence file. Typshade then turns that alignment into publication-quality
Typst content: colored residue cells, labels, rulers, consensus rows, logos,
feature tracks, graphs, legends, and optional structure/topology annotations.

The package is organized around one rendering entry point, `shade`, plus a set
of declarative helpers. The most important distinction from TeXshade is that
state is represented by Typst values rather than by TeX macro side effects.
This has practical consequences:

- Figure settings can be stored in variables, passed to functions, imported from
  other Typst files, and reviewed as data.
- The order of low-level commands still matters where the biology requires it,
  but purpose-level recipes reduce order sensitivity for common figures.
- Inspection helpers return Typst content/data instead of writing to the TeX log.
- Side-effect features such as exporting Chimera/Pymol command files are
  intentionally separated from document rendering.

== Package Contents

#table(
  columns: (1.6fr, 4.2fr),
  inset: 4pt,
  [Component], [Purpose],
  [`package/lib.typ`], [Public package entry point. Import this file locally or as `@preview/typshade`.],
  [`internal/interface`], [Public-facing API modules: rendering, recipes, tracks, annotations, controls, inspection, and presets.],
  [`internal/model`], [Parsing, palettes, logo calculations, PDB selection helpers, and text-style helpers.],
  [`internal/render`], [Alignment table rendering, feature rows, graph tracks, and structure rows.],
  [`docs/documentation.typ`], [This manual and TeXshade-to-Typshade correspondence reference.],
  [`examples`], [Small runnable examples for package development and regression checks.],
)

== System Requirements

Typshade is a Typst package. It requires a Typst compiler compatible with the
package metadata in `typst.toml`. It does not require LaTeX, `color.sty`,
PostScript drivers, `pstricks`, or TeX memory tuning.

The package can read files that Typst is allowed to access under the active
`--root`. When compiling local examples, make sure the project root includes the
alignment and annotation files:

```sh
typst compile --root /path/to/project doc.typ out.pdf
```

= Alignment Input Files

Typshade follows the TeXshade model: input files contain already-aligned
sequences. It does not compute the alignment. Use external tools such as
Clustal, MUSCLE, MAFFT, T-Coffee, or a domain-specific pipeline to create the
alignment first, then read the result in your document and pass the bytes to
`shade`. `read(..., encoding: none)` remains supported on all supported Typst
versions, including Typst 0.15 and later. With Typst 0.15 or later, you may
also pass a resolved `path(...)` to Typshade and let the package read the file.
This keeps path resolution on the project side while preserving existing
`read(..., encoding: none)` documents.

The `format:` argument defaults to `auto`, but explicit formats are recommended
when using `read(..., encoding: none)` or `path(...)` for reproducible figures:

```typst
// Works on all supported Typst versions, including Typst 0.15+.
#let msf = read("alignment.msf", encoding: none)
#let aln = read("alignment.aln", encoding: none)
#let fasta = read("alignment.fasta", encoding: none)

#shade(msf, format: "msf")
#shade(aln, format: "aln", seq-type: "P")
#shade(fasta, format: "fasta", seq-type: "N")

// Typst 0.15+: path is resolved where it is constructed.
#shade(path("alignment.msf"), format: "msf")
```

#example-result(label: [Input formats rendered with bundled fixtures])[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 5pt,
    result-panel[MSF][
      #shade(demo-protein, format: "msf", residues-per-line: 12, commands: (window(1, "80..91"), no-consensus()), font-size: 5.8pt)
    ],
    result-panel[ALN][
      #shade(demo-tiny-aln, format: "aln", seq-type: "P", residues-per-line: 4, commands: (ruler("top", sequence: 1, every: 1), no-consensus()), font-size: 5.8pt)
    ],
    result-panel[FASTA][
      #shade(">dna1\nATGC\n>dna2\nATGT", format: "fasta", seq-type: "N", residues-per-line: 4, logo: (position: "top", colorset: "DNA"), commands: (no-consensus(),), font-size: 5.8pt)
    ],
  )
]

Typshade expects alignment inputs to be rectangular: every parsed sequence must
have the same aligned column length. Empty inputs, mismatched sequence lengths,
unknown explicit `format:` values, unknown sequence names, and out-of-range
sequence indices are rejected with Typshade-level diagnostics before rendering.
Sequence references are 1-based when numeric, or exact sequence names when
textual.

== MSF Files

MSF is the richest supported input format because it can carry sequence names,
sequence type, lengths, and header metadata. Typshade uses the sequence names
and aligned sequence blocks. If the MSF header declares peptide/nucleotide type,
`seq-type: auto` can usually infer it.

Typical use:

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: publication(region: "80..112"),
)

// Typst 0.15+ alternative:
#shade(
  path("AQPpro.MSF"),
  format: "msf",
  figure: publication(region: "80..112"),
)
```

#example-result(label: [MSF input with publication recipe])[
  #shade(
    demo-protein,
    format: "msf",
    figure: publication(region: "80..112", logo: false, line-length: 40),
    font-size: 5.8pt,
  )
]

== ALN Files

ALN/Clustal-like files often lack an explicit sequence type. In such cases,
pass `seq-type: "P"` for peptide alignments or `seq-type: "N"` for nucleotide
alignments. Minimal ALN files are acceptable as long as sequence names and
aligned blocks are recoverable.

```typst
#shade(
  "AQP2spec.ALN",
  seq-type: "P",
  commands: (
    diverse(),
    window(1, "77..109"),
    ruler("top", sequence: 1),
  ),
)
```

#example-result(label: [ALN input with diverse shading])[
  #shade(
    demo-tiny-aln,
    format: "aln",
    seq-type: "P",
    residues-per-line: 4,
    commands: (
      diverse(),
      ruler("top", sequence: 1, every: 1),
      no-consensus(),
    ),
    font-size: 5.8pt,
  )
]

== FASTA Files

FASTA files are supported for aligned sequences. Each record begins with `>`,
and the first word is used as the default sequence name. FASTA does not encode
alignment type, so explicit `seq-type:` is recommended for reproducible output.

```typst
#shade(
  "alignment.fasta",
  seq-type: "N",
  figure: logo-analysis(colors: "nucleotide"),
)
```

#example-result(label: [FASTA nucleotide logo])[
  #shade(
    ">dna1\nATGC\n>dna2\nATGT\n>dna3\nATGA",
    format: "fasta",
    seq-type: "N",
    residues-per-line: 4,
    logo: (position: "top", colorset: "DNA"),
    commands: (no-consensus(),),
    font-size: 5.8pt,
  )
]

== Supplemental Files

Some features need supplemental files:

#table(
  columns: (1.4fr, 2fr, 3.2fr),
  inset: 4pt,
  [File Kind], [Used By], [Notes],
  [T-Coffee score data], [`tcoffee(source)`, `tcoffee-scores(source)`], [The score data must correspond to the displayed alignment. Pass `read(..., encoding: none)`.],
  [PHD topology/secondary files], [`phd-topology-track`, `phd-secondary-track`, `structure-map`], [Rendered as structure/feature tracks.],
  [HMMTOP files], [`hmmtop-track`, `structures`], [Optional `hmmtop-sequence` selects a prediction within multi-entry files.],
  [DSSP/STRIDE files], [`dssp-track`, `stride-track`], [Supports structure type filtering and appearance controls.],
  [PDB files], [`pdb-point`, `pdb-line`, `pdb-plane`, `pdb-selection`], [Used for distance/plane-based residue selections.],
  [Graph data sources], [`graph(..., metric: read(..., encoding: none))`], [Data should be normalized or have explicit ranges when needed.],
)

= Processing Model

TeXshade processes an environment by reading an alignment, resetting defaults,
loading an optional parameter file, executing in-environment commands, then
setting the alignment. Typshade keeps the same conceptual stages but expresses
them as Typst values.

#table(
  columns: (0.7fr, 2.5fr, 3.4fr),
  inset: 4pt,
  [Step], [TeXshade Model], [Typshade Model],
  [1], [Analyze alignment file.], [`shade(read(..., encoding: none), format: ...)` parses caller-supplied alignment bytes. Recipes may inspect the alignment before rendering.],
  [2], [Reset defaults.], [The renderer starts from built-in defaults for every figure call.],
  [3], [Load parameter file.], [`preset:`, `theme:`, imported Typst variables, or command arrays provide reusable settings.],
  [4], [Execute environment commands.], [`figure:`, top-level arguments, `regions:`, `features:`, and `commands:` are merged explicitly.],
  [5], [Set alignment line by line.], [The renderer builds Typst tables/blocks with deterministic layout.],
)

The effective command order is:

1. `figure:` recipes or figure command fragments.
2. `preset:` and `theme:`.
3. Top-level convenience arguments such as `seq-type:`, `mode:`, `ruler:`, and
   `logo:`.
4. `regions:` and `features:`.
5. Explicit `commands:`.

This order lets recipes provide useful defaults while still allowing final
manual overrides in `commands:`.

= Quick Start

```typst
#import "@preview/typshade:0.1.0": *

#shade(
  "alignment.msf",
  theme: "screen",
  figure: motif-map(auto),
)
```

#example-result(label: [Quick start motif map])[
  #shade(
    demo-protein,
    format: "msf",
    theme: "screen",
    figure: motif-map(("NPA": "motif"), sequence: 1, region: "80..112", logo: false, line-length: 40),
    font-size: 5.8pt,
  )
]

= Why The UI Is Different

TeXshade is configured by issuing many commands inside an environment. That is
natural in TeX, but it makes large figures difficult to scan because related
settings are spread across an order-sensitive command stream.

TeXshade style:

```latex
\begin{texshade}{alignment.msf}
  \shadingmode[similar]{identical}
  \shadingcolors{blues}
  \threshold{45}
  \residuesperline{45}
  \setends{1}{80..125}
  \showruler{top}{1}
  \rulersteps{10}
  \showconsensus{bottom}
  \showsequencelogo{top}
  \shaderegion{1}{NPA}{White}{BrickRed}
  \feature{top}{1}{NXX[ST]N}{box[Yellow]}{motif}
\end{texshade}
```

Typshade style:

```typst
#shade(
  "alignment.msf",
  figure: publication(
    similarity: "blues",
    region: "80..125",
    logo: "charge",
    motifs: (
      "NPA": (bg: "BrickRed", text: "active site"),
      "NXX[ST]N": "motif",
    ),
  ),
)
```

#example-result(label: [Typshade publication recipe output])[
  #shade(
    demo-protein,
    format: "msf",
    figure: publication(
      similarity: "blues",
      region: "80..125",
      logo: "charge",
      motifs: (
        "NPA": (bg: "BrickRed", text: "active site"),
        "NXX[ST]N": "motif",
      ),
      line-length: 46,
    ),
    font-size: 5.8pt,
  )
]

The Typshade form names the figure's scientific intent directly. This makes
documents easier to scan, review, reuse, and parameterize.

= Feature Overview

This section mirrors the role of TeXshade's package overview: it introduces the
main capabilities before the command reference.

== Predefined Shading Modes

#table(
  columns: (1.2fr, 2.3fr, 3.2fr),
  inset: 4pt,
  [Mode], [Typshade API], [Use Case],
  [Identity], [`identical(...)` or `scoring-mode("identical")`], [Shade columns where a residue reaches the threshold. Useful for basic conservation figures.],
  [Similarity], [`similar(...)` or `scoring-mode("similar")`], [Shade identical and chemically similar residues. This is the usual protein-alignment default.],
  [T-Coffee], [`tcoffee(read("scores.asc", encoding: none))`], [Use an external T-Coffee score file to drive shading and graph tracks.],
  [Diverse], [`diverse(...)`], [Highlight deviations from a reference sequence. Useful for variants and closely related homologs.],
  [Functional], [`functional("charge")`, `functional("hydropathy")`, etc.], [Shade residues by biochemical property rather than only conservation.],
  [Single sequence], [`single-sequence(sequence: 1)`], [Format one sequence with numbering, labels, translation/complement features, and manual regions.],
)

Functional modes include `charge`, `hydropathy`, `structure`, `chemical`,
`rasmol`, `standard area`, `accessible area`, and DNA-oriented functional
shading. Custom functional group definitions use `clear-functional-groups` and
`functional-group`.

== Graphs And Color Scales

Feature rows can carry numerical information as bars, color scales, stacked
bars, and conservation-derived plots. In TeXshade this is done through the
general `\feature` command. In Typshade, the preferred high-level helper is
`graph`:

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    window(1, "138..170"),
    graph("top", 1, "138..170", "conservation", kind: "bar"),
    graph("bottom", 1, "138..170", "hydrophobicity", kind: "color", options: ("GreenRed",)),
  ),
)
```

#example-result(label: [Graph tracks and color scales])[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      window(1, "138..170"),
      graph("top", 1, "138..170", "conservation", kind: "bar"),
      graph("bottom", 1, "138..170", "hydrophobicity", kind: "color", options: ("GreenRed",)),
      no-consensus(),
    ),
    font-size: 5.8pt,
  )
]

Built-in graph metrics include `conservation`, `hydrophobicity`, `molweight`,
and `charge`. Graph appearance can be tuned with `bar-graph-stretch` and
`color-scale-stretch`.

== Secondary Structures

Typshade can overlay structure information from DSSP, STRIDE, PHD, and HMMTOP
files. For ordinary figures use `structure-map` or `structures`; for exact
control use the format-specific track helpers.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)
#let topology = read("AQP1.top", encoding: none)
#let secondary = read("AQP1.phd", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: structure-map(
    1,
    topology: topology,
    secondary: secondary,
  ),
)
```

#example-result(label: [Structure map output])[
  #shade(
    demo-protein,
    format: "msf",
    figure: structure-map(1, topology: demo-topology, secondary: demo-topology, hmmtop: demo-hmmtop, region: "1..80", line-length: 40),
    font-size: 5.8pt,
  )
]

Structure visibility and appearance are controlled by `show-structure-types`,
`hide-structure-types`, `structure-appearance`, `use-first-dssp-column`, and
`use-second-dssp-column`.

== Fingerprints

The `fingerprint` control gives a compact overview of long alignments by
reducing residue cells to thin visual marks. It is compatible with the same
shading modes, feature rows, and legends as normal alignment figures.

```typst
#shade(
  "AQPpro.MSF",
  commands: (
    similar(colors: "grays", all-match-threshold: 100),
    fingerprint(360),
    legend(),
  ),
)
```

#example-result(label: [Fingerprint overview])[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      similar(colors: "grays", all-match-threshold: 100),
      window(1, "1..45"),
      fingerprint(45),
      legend(),
      no-consensus(),
    ),
    font-size: 5.8pt,
  )
]

== Sequence Logos And Subfamily Logos

Sequence logos show residue frequency and information content per alignment
position. Subfamily logos visualize residues that distinguish a subset of
sequences from the rest. Typshade supports both through explicit tracks and
through `logo-analysis`.

```typst
#shade(
  "AQPpro.MSF",
  figure: logo-analysis(
    region: "203..235",
    colors: "charge",
    subfamily: (3,),
    relevance: (threshold: 1.0, char: "*"),
  ),
)
```

#example-result(label: [Sequence and subfamily logos])[
  #shade(
    demo-protein,
    format: "msf",
    figure: logo-analysis(
      region: "203..235",
      colors: "charge",
      subfamily: (3,),
      relevance: (threshold: 1.0, char: "*"),
    ),
    font-size: 5.8pt,
  )
]

Frequency correction, logo colors, logo scales, negative subfamily values, and
relevance markers are available through `frequency-correction`, `logo-color`,
`logo-scale`, `negative-logo-values`, and `relevance-marker`.

== Single-Sequence Figures

Single-sequence display is useful for formatted ORFs, UTRs, translated regions,
complements, and motif annotations. The sequence can come from a one-sequence
file or from one row of a larger alignment.

```typst
#shade(
  "AQPDNA.MSF",
  seq-type: "N",
  commands: (
    single-sequence(sequence: 1),
    shift-single-sequence(),
    window(1, "-84..525", start: -84),
    lower(1, "-84..-1,439..525"),
    mark("bottom", 1, "390..402", fill: "Blue", text: "poly-Arg"),
  ),
)
```

#example-result(label: [Single-sequence translation/complement marks])[
  #shade(
    demo-dna,
    format: "msf",
    seq-type: "N",
    commands: (
      single-sequence(sequence: 1),
      shift-single-sequence(),
      keep-single-sequence-gaps(),
      window(1, "414..443"),
      lower(1, "414..419"),
      mark("bottom", 1, "414..443", style: "complement[LightBlue][lower]", text: "complement"),
      mark("top", 1, "414..443", style: "translate[Red]", text: "translation"),
      no-consensus(),
    ),
    font-size: 5.8pt,
  )
]

== Customization Surface

Most TeXshade customization categories have direct Typshade equivalents:
sequence labels, numbering, rulers, gaps, regional highlighting, feature tracks,
legends, captions, typography, and spacing. The important design change is that
styling is local, inspectable, and composable:

```typst
#let paper-style = (
  typography(target: "all", size: 8pt),
  names(color: "RoyalBlue"),
  numbers(position: "right"),
  ruler("top", every: 10),
)

#let alignment = read("alignment.msf", encoding: none)

#shade(alignment, format: "msf", commands: paper-style)
```

#example-result(label: [Reusable command style output])[
  #let paper-style = (
    typography(target: "all", size: 7pt),
    names(color: "RoyalBlue"),
    numbers(position: "right"),
    ruler("top", every: 10),
  )

  #shade(demo-protein, format: "msf", commands: paper-style + (window(1, "80..112"), no-consensus()), font-size: 5.8pt)
]

= Worked Examples

The examples below are intentionally small. They are meant to show how common
TeXshade-style figures translate into idiomatic Typshade source.

== Identity Shading With A Ruler

Use identity shading when exact residue conservation is the focus.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    identical(colors: "blues", threshold: 50, all-match-threshold: 80),
    window(1, "80..112"),
    ruler("top", sequence: 1, every: 10),
    no-consensus(),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      identical(colors: "blues", threshold: 50, all-match-threshold: 80),
      window(1, "80..112"),
      ruler("top", sequence: 1, every: 10),
      no-consensus(),
    ),
  )
]

The same figure can be expressed as a recipe when the intent is a standard
publication panel:

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: publication(
    mode: "identical",
    threshold: 50,
    region: "80..112",
    conservation: false,
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    figure: publication(
      mode: "identical",
      threshold: 50,
      region: "80..112",
      conservation: false,
      logo: false,
    ),
  )
]

== Similarity Shading With Motif Labels

Similarity shading is the default for many peptide alignments because it can
highlight chemically similar residues even when exact identity is low.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    similar(colors: "blues", threshold: 45),
    window(1, "80..125"),
    ruler("top", sequence: 1, every: 10),
    consensus("bottom", name: "conservation"),
    motif(1, "NPA", text: "NPA loop", fg: "White", bg: "BrickRed"),
    motif(1, "NXX[ST]N", text: "glycosylation"),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      similar(colors: "blues", threshold: 45),
      window(1, "80..125"),
      ruler("top", sequence: 1, every: 10),
      consensus("bottom", name: "conservation"),
      motif(1, "NPA", text: "NPA loop", fg: "White", bg: "BrickRed"),
      motif(1, "NXX[ST]N", text: "glycosylation"),
    ),
  )
]

For exploratory documents, `motif-map(auto)` can discover common motifs and
focus the displayed region automatically.

== Functional Shading

Functional shading groups residues by biochemical properties such as charge,
hydropathy, chemical class, or side-chain area.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    functional("charge"),
    window(1, "138..170"),
    graph("top", 1, "138..170", "charge", kind: "color", options: ("ColdHot",)),
    legend(),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      functional("charge"),
      window(1, "138..170"),
      graph("top", 1, "138..170", "charge", kind: "color", options: ("ColdHot",)),
      legend(),
    ),
  )
]

Custom functional modes are built from explicit group definitions:

```typst
#let acidic-basic = (
  functional("custom"),
  clear-functional-groups(),
  functional-group("acidic (-)", "DE", "White", "Red"),
  functional-group("basic (+)", "HKR", "White", "Blue"),
  shade-all-residues(),
)

#let alignment = read("AQPpro.MSF", encoding: none)

#shade(alignment, format: "msf", commands: acidic-basic)
```

#example-result[
  #let acidic-basic = (
    functional("custom"),
    clear-functional-groups(),
    functional-group("acidic (-)", "DE", "White", "Red"),
    functional-group("basic (+)", "HKR", "White", "Blue"),
    shade-all-residues(),
  )

  #shade(
    demo-protein,
    format: "msf",
    commands: (
      window(1, "138..170"),
      acidic-basic,
      legend(),
    ),
  )
]

== Sequence Logo Without Sequence Rows

To emphasize information content rather than individual rows, hide the
sequences and keep the logo, conservation row, and ruler.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)
#shade(
  alignment,
  format: "msf",
  figure: logo-analysis(
    region: "203..235",
    colors: "charge",
    conservation: true,
    commands: (
      hide-all-sequences(),
      ruler("bottom", sequence: 3, every: 1),
    ),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    figure: logo-analysis(
      sequence: 3,
      region: "203..235",
      colors: "charge",
      conservation: true,
      commands: (
        hide-all-sequences(),
        ruler("bottom", sequence: 3, every: 5),
      ),
    ),
  )
]

== Subfamily Logo

Subfamily logos compare a selected set of sequences against the remaining
sequences. Relevance markers help identify positions with interpretable
deviation.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: logo-analysis(
    sequence: 3,
    region: "203..235",
    subfamily: (3,),
    negative: true,
    relevance: (threshold: 1.0, char: "*", color: "Black"),
    commands: (
      hide-all-sequences(),
      subfamily-logo-name("AQP3", negative-name: "others"),
    ),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    figure: logo-analysis(
      sequence: 3,
      region: "203..235",
      subfamily: (3,),
      negative: true,
      relevance: (threshold: 1.0, char: "*", color: "Black"),
      commands: (
        hide-all-sequences(),
        subfamily-logo-name("AQP3", negative-name: "others"),
        ruler("bottom", sequence: 3, every: 5),
      ),
    ),
  )
]

== Structure And Topology Tracks

Structure tracks can be attached either manually or through `structure-map`.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)
#let topology = read("AQP1.top", encoding: none)
#let secondary = read("AQP1.phd", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: structure-map(
    1,
    topology: topology,
    secondary: secondary,
    region: "1..120",
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    figure: structure-map(
      1,
      topology: demo-topology,
      secondary: demo-topology,
      region: "1..120",
      line-length: 40,
    ),
  )
]

When exact filtering is needed, add controls:

```typst
#let alignment = read("AQPpro.MSF", encoding: none)
#let topology = read("AQP1.top", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    structures(1, topology: topology),
    show-structure-types(
      "PHDtopo",
      ("TM", "internal", "external"),
    ),
    structure-appearance(
      "PHDtopo",
      "TM",
      "top",
      "box[Blue]:TM",
      "",
    ),
  ),
)
```

#example-result[
  #scale(x: 85%, y: 85%, origin: left)[
    #shade(
      demo-protein,
      format: "msf",
      commands: (
        window(1, "1..80"),
        structures(1, topology: demo-topology),
        show-structure-types(
          "PHDtopo",
          ("TM", "internal", "external"),
        ),
        structure-appearance(
          "PHDtopo",
          "TM",
          "top",
          "box[Blue]:TM",
          "",
        ),
      ),
    )
  ]
]

== PDB-Based Selection

PDB selections are especially useful for showing residues near a structural
site without hand-transcribing residue numbers.

```typst
#let alignment = read("AQPpro.MSF", encoding: none)
#let pdb = read("1J4N.pdb", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    window(1, pdb-point(pdb, 81, distance: 8, atom: "CA")),
    ruler("top", sequence: 1, every: 1),
    highlight(1, pdb-line(pdb, 81, 168), bg: "Yellow"),
  ),
)
```

#example-result[
  #shade(
    demo-tiny-protein,
    format: "fasta",
    commands: (
      similar(colors: "blues"),
      ruler("top", sequence: 1, every: 1),
      highlight(1, pdb-selection(pdb-point(demo-pdb, 1, distance: 0.2, atom: "CA")), bg: "Yellow"),
      highlight(1, pdb-selection(pdb-line(demo-pdb, 1, 2, distance: 0.2, atom-a: "CA", atom-b: "CA")), bg: "LightGreen"),
      no-consensus(),
    ),
  )
]

== Translation And Complement Features

Single-sequence nucleotide figures can combine lowercased UTRs, complements,
translations, and manual feature labels.

```typst
#let alignment = read("AQPDNA.MSF", encoding: none)

#shade(
  alignment,
  format: "msf",
  seq-type: "N",
  commands: (
    single-sequence(sequence: 1),
    shift-single-sequence(),
    window(1, "-84..525", start: -84),
    lower(1, "-84..-1,439..525"),
    backtranslation-label("horizontal"),
    mark("bottom", 1, "390..402", fill: "Blue", text: "poly-Arg"),
  ),
)
```

#example-result[
  #shade(
    demo-dna,
    format: "msf",
    seq-type: "N",
    commands: (
      single-sequence(sequence: 1),
      shift-single-sequence(),
      window(1, "414..443"),
      lower(1, "439..443"),
      backtranslation-label("horizontal"),
      mark("bottom", 1, "424..443", style: "complement[LightBlue][lower]", text: "complement"),
      mark("top", 1, "414..443", style: "translate[Red]", text: "translation"),
      no-consensus(),
    ),
  )
]

= Public API Layers

Typshade has three layers. You can mix them, but most documents should start at
the top.

#table(
  columns: (1.3fr, 2.5fr, 2.5fr),
  inset: 5pt,
  [Layer], [Use When], [Examples],
  [`figure:` recipes], [You know the purpose of the figure.], [`publication`, `motif-map`, `structure-map`, `logo-analysis`],
  [`commands:` helpers], [You want reusable pieces or small adjustments.], [`similar`, `lines`, `ruler`, `logo`, `highlight`],
  [Fine-grained commands], [You need precise control over a TeXshade-equivalent feature.], [`weight-table`, `residue-style`, `feature-rule`, `structure-appearance`],
)

= Figure Recipes

`figure:` is the recommended API for hand-written scientific figures. Recipes
expand into lower-level track, annotation, style, and scoring commands.

#table(
  columns: (1.2fr, 3fr, 2.4fr),
  inset: 5pt,
  [Recipe], [Purpose], [Typical Use],
  [`publication`], [Balanced paper-ready alignment figure.], [`publication(motifs: auto, logo: auto)`],
  [`motif-map`], [Detect or highlight motifs and add a conservation graph.], [`motif-map(auto)`],
  [`structure-map`], [Combine alignment, ruler, consensus, and structure tracks.], [`structure-map(1, topology: read("AQP1.top", encoding: none))`],
  [`logo-analysis`], [Show sequence/subfamily logo analysis.], [`logo-analysis(colors: "charge", subfamily: (1, 2, 3))`],
  [`overview`], [Compact overview for many sequences or quick reports.], [`overview(colors: "grays")`],
)

Smart defaults use the alignment data:

- `motif-map(auto)` detects common protein or nucleotide motifs.
- `region: auto` focuses around detected motifs.
- `line-length: auto` adapts to sequence count and selected region.
- `logo: auto` enables logos only when they remain readable.
- `threshold: auto` chooses a sequence-type-aware default.

== Example: Motif Map

```typst
#let alignment = read("alignment.msf", encoding: none)

#shade(
  alignment,
  format: "msf",
  figure: motif-map(
    (
      "NPA": (bg: "BrickRed", text: "active site"),
      "NXX[ST]N": "glycosylation",
    ),
    region: "80..125",
    logo: "charge",
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    figure: motif-map(
      (
        "NPA": (bg: "BrickRed", text: "active site"),
        "NXX[ST]N": "glycosylation",
      ),
      region: "80..125",
      logo: "charge",
    ),
  )
]

= Command Helpers

`commands:` is useful when a recipe is too high-level and you want to assemble
the visible parts yourself. It accepts helper output and low-level commands in
left-to-right order.

#table(
  columns: (1.2fr, 3fr, 2.4fr),
  inset: 5pt,
  [Helper], [Purpose], [Example],
  [`similar`, `identical`, `diverse`, `functional`], [Choose scoring and optional colors/thresholds.], [`similar(colors: "blues", threshold: 45)`],
  [`lines`], [Set residues per line.], [`lines(50)`],
  [`window`], [Show a selected sequence range.], [`window(1, "80..125")`],
  [`names`, `numbers`], [Configure sequence labels and numbering.], [`names(color: "RoyalBlue")`],
  [`ruler`, `consensus`, `logo`, `legend`], [Add common tracks.], [`ruler("top", every: 10)`],
  [`highlight`, `tint`, `emphasize`], [Style residue regions.], [`highlight(1, "NPA", bg: "BrickRed")`],
  [`motif`, `mark`, `graph`], [Add feature rows and graph tracks.], [`motif(1, "NXX[ST]N", text: "motif")`],
  [`structures`], [Add topology/secondary-structure tracks.], [`structures(1, topology: read("AQP1.top", encoding: none))`],
  [`typography`], [Adjust text for named parts.], [`typography(target: "names", family: "mono")`],
)

== Example: Publication Figure

```typst
#let alignment = read("alignment.msf", encoding: none)

#shade(
  alignment,
  format: "msf",
  preset: "publication",
  theme: "screen",
  commands: (
    similar(threshold: 45),
    lines(50),
    ruler("top", sequence: 1, every: 10),
    consensus("bottom", name: "conservation"),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    preset: "publication",
    theme: "screen",
    commands: (
      similar(threshold: 45),
      lines(50),
      window(1, "80..125"),
      ruler("top", sequence: 1, every: 10),
      consensus("bottom", name: "conservation"),
    ),
  )
]

== Example: Motifs And Graphs

```typst
#let alignment = read("alignment.msf", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    window(1, "80..125"),
    highlight(1, "NPA", bg: "BrickRed"),
    motif(1, "NXX[ST]N", text: "glycosylation"),
    graph("bottom", 1, "all", "conservation", kind: "color", options: ("ColdHot",)),
  ),
)
```

#example-result[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      window(1, "80..125"),
      highlight(1, "NPA", bg: "BrickRed"),
      motif(1, "NXX[ST]N", text: "glycosylation"),
      graph("bottom", 1, "all", "conservation", kind: "color", options: ("ColdHot",)),
    ),
  )
]

= Helper Function API

Helper functions are useful when a figure is assembled from reusable fragments.

```typst
#let active-site = (
  highlight(1, "NPA", fg: "White", bg: "BrickRed"),
  motif(1, "NXX[ST]N", text: "motif"),
)

#shade(
  read("alignment.msf", encoding: none),
  format: "msf",
  preset: "publication",
  theme: "screen",
  regions: active-site,
  commands: (
    scoring-mode("similar"),
    ruler-track(position: "top", sequence: 1, steps: 10),
  ),
)
```

#example-result[
  #let active-site = (
    highlight(1, "NPA", fg: "White", bg: "BrickRed"),
    motif(1, "NXX[ST]N", text: "motif"),
  )

  #shade(
    demo-protein,
    format: "msf",
    preset: "publication",
    theme: "screen",
    regions: active-site,
    commands: (
      window(1, "80..125"),
      scoring-mode("similar"),
      ruler-track(position: "top", sequence: 1, steps: 10),
    ),
  )
]

= Detailed User Guide

This section describes the public surface in the style of a user manual. The
tables below are intentionally redundant with the compatibility reference:
the guide explains how to write Typshade; the compatibility reference explains
where each TeXshade command went.

== The `shade` Function

`shade` is the only rendering function most documents need.

The following block is a signature reference, not runnable sample code:

```text
#shade(
  source,
  format: auto,
  figure: (),
  preset: none,
  theme: none,
  mode: none,
  option: none,
  seq-type: auto,
  residues-per-line: none,
  fit: none,
  names: none,
  numbering: none,
  consensus: none,
  ruler: none,
  logo: none,
  subfamily-logo: none,
  legend: none,
  regions: (),
  features: (),
  commands: (),
  caption: none,
  short-caption: none,
  font: none,
  font-size: none,
)
```

#table(
  columns: (1.35fr, 4.6fr),
  inset: 4pt,
  [Argument], [Meaning],
  [`source`], [Alignment source, normally `read("alignment.msf", encoding: none)`. This is the only required argument.],
  [`format`], [`auto` by default; use explicit formats for ambiguous MSF/ALN/FASTA-like files.],
  [`figure`], [Purpose-level recipe or array of recipes/commands. This is the recommended high-level API.],
  [`preset`], [Named reusable defaults such as publication/overview-oriented settings.],
  [`theme`], [Named or custom visual theme. Themes should express visual identity, not biology.],
  [`mode`, `option`], [Direct scoring-mode override. Prefer `similar`, `functional`, `tcoffee`, etc. inside `commands:` when assembling manually.],
  [`seq-type`], [`auto`, `"P"`, or `"N"` depending on whether type should be inferred or forced.],
  [`residues-per-line`, `fit`], [Direct line length override, or Typst-aware fitting. Use `fit: "container"` for width-based layout and `fit: "page"` to also enable page-aware block splitting. Shortcut equivalent: `lines(count)` or `lines(auto)`.],
  [`names`, `numbering`, `consensus`, `ruler`, `logo`, `legend`], [Convenience toggles or simple track declarations. Use track helpers for more control.],
  [`regions`, `features`], [Dedicated slots for highlight/annotation command fragments.],
  [`commands`], [Final explicit command list. Use this for low-level controls and final overrides.],
  [`caption`, `short-caption`], [`caption` wraps the rendered alignment in a Typst `figure`; `short-caption` stores companion metadata for workflows that need it.],
  [`font`, `font-size`], [Renderer-level fallback text settings. Prefer `typography` for targeted styling.],
)

By default, rendered alignment blocks are left-aligned. Use
`alignment-position("center")` or `alignment-position("right")` only when a
particular figure should be optically centered or flush-right inside its
containing block.

== Recipe Options

Recipes are the main UI/UX improvement over TeXshade. They describe the kind of
figure rather than the macro operations needed to build it.

#table(
  columns: (1.35fr, 4.6fr),
  inset: 4pt,
  [`publication` option], [Meaning],
  [`mode`], [Scoring mode, default `"similar"`.],
  [`similarity`], [Color scheme, default `"blues"`.],
  [`threshold`], [`auto` chooses a sequence-type-aware threshold; a number fixes it.],
  [`sequence`], [Reference sequence for region, ruler, and motif interpretation.],
  [`region`], [`auto`, `none`, range string, motif string, or dictionary with `sequence`/`selection`.],
  [`line-length`], [`auto` picks a readable line length; a number fixes residues per line.],
  [`ruler`, `every`], [Enable ruler and choose tick interval.],
  [`conservation`], [Controls consensus/conservation row.],
  [`logo`], [Logo color set, `auto`, `false`, or `none`.],
  [`motifs`, `highlights`], [Motif and region annotations.],
  [`theme`, `annotations`, `commands`], [Additional visual theme and final command fragments.],
)

#table(
  columns: (1.35fr, 4.6fr),
  inset: 4pt,
  [Recipe], [Distinctive Options],
  [`motif-map`], [`motifs`, `region`, `graph`, `logo`, and `conservation` can all be `auto` so the alignment drives the result.],
  [`structure-map`], [`topology`, `secondary`, `hmmtop`, and `hmmtop-sequence` attach structure tracks to a chosen sequence.],
  [`logo-analysis`], [`colors`, `subfamily`, `negative`, and `relevance` configure sequence/subfamily logo analysis.],
  [`overview`], [`names`, `numbers`, `conservation`, and `ruler` default to compact values for large alignments.],
)

== Selection Syntax

Selections are used by windows, highlights, motifs, feature rows, graphs, and
PDB helpers.

#table(
  columns: (1.5fr, 2.2fr, 2.6fr),
  inset: 4pt,
  [Selection Kind], [Example], [Meaning],
  [Single range], [`"80..112"`], [Residues 80 through 112 in the reference sequence.],
  [Multiple ranges], [`"80..90,100..110"`], [Union of several displayed spans.],
  [Keyword], [`"all"`], [All available positions in the selected sequence.],
  [Motif], [`"NPA"`], [All matching motif occurrences.],
  [Pattern motif], [`"NXX[ST]N"`], [`X` matches any residue; bracket groups match any listed residue.],
  [Selection DSL], [`select-or(select-motif("NPA"), select-metric("coverage", at-least: 80))`], [Composable selection objects for ranges, motifs, metrics, negation, intersections, unions, and padding.],
  [PDB point], [`pdb-point(read("1J4N.pdb", encoding: none), 81, distance: 8, atom: "CA")`], [Residues near a point around a PDB anchor.],
  [PDB line], [`pdb-line(read("1J4N.pdb", encoding: none), 81, 168)`], [Residues close to a line between two anchors.],
  [PDB plane], [`pdb-plane(read("1J4N.pdb", encoding: none), 66, 73, 199)`], [Residues close to a plane defined by three anchors.],
)

Use `selection-preview` or `selection-table` when a motif, metric, PDB, or
composed DSL selection is too subtle to trust by eye.

== Feature Rows

The general TeXshade `\feature` command is powerful but dense. Typshade splits
common cases into clearer helpers:

#table(
  columns: (1.35fr, 2.1fr, 2.8fr),
  inset: 4pt,
  [Task], [Helper], [Example],
  [Text or boxed mark], [`mark`], [`mark("top", 1, "93..93", fill: "Yellow", text: "site")`],
  [Motif highlight plus label], [`motif`], [`motif(1, "NXX[ST]N", text: "glycosylation")`],
  [Region color], [`highlight`], [`highlight(1, "NPA", fg: "White", bg: "BrickRed")`],
  [Tint existing shading], [`tint`], [`tint(1, "158..163", intensity: "strong")`],
  [Emphasize text], [`emphasize`], [`emphasize(1, "QLVLC", style: "italic")`],
  [Graph track], [`graph`], [`graph("bottom", 1, "all", "conservation", kind: "color")`],
)

Built-in graph metrics include `conservation`, `entropy`, `gap-fraction`,
`coverage`, `identity`, `hydrophobicity`, `molweight`, and `charge`. Use
external graph data only when the metric is not already derivable from the
alignment itself.

When you need exact TeXshade-style label strings, use the lower-level feature
controls through `commands:`. The renderer still supports feature positions
such as `ttttop`, `tttop`, `ttop`, `top`, `bottom`, `bbottom`, `bbbottom`,
and `bbbbottom`.

== Colors And Palettes

Typshade accepts the package color names used by its palettes and resolves them
through Typst colors. Built-in color schemes include TeXshade-style schemes
such as `blues`, `reds`, `greens`, `grays`, and `black`, plus graph scales such
as `BlueRed`, `RedBlue`, `GreenRed`, `RedGreen`, `ColdHot`, `HotCold`,
`WhiteBlack`, and `BlackWhite`.

Use these levels of control:

1. `theme:` for the document's visual direction.
2. `color-scheme` or scoring shortcuts for alignment categories.
3. `residue-style`, `cell-style`, `functional-style`, `logo-color`, or `consensus-colors` for
   exact category/residue styling.
4. `visual-theme` when creating a reusable house style.

`cell-style` accepts a Typst function and is evaluated for each rendered
sequence cell after built-in scoring and before explicit region annotations:

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    cell-style(ctx => if ctx.at("consensus-score") < 70 {
      (frame: "BrickRed")
    } else {
      none
    }),
  ),
)
```

#example-result(label: [Cell-style callback output])[
  #shade(
    demo-protein,
    format: "msf",
    commands: (
      window(1, "80..112"),
      cell-style(ctx => if ctx.at("consensus-score") < 70 {
        (frame: "BrickRed")
      } else {
        none
      }),
      no-consensus(),
    ),
    font-size: 5.8pt,
  )
]

== Typography And Layout

TeXshade exposes many short font commands because TeX font selection is macro
oriented. Typshade uses targeted text controls:

#table(
  columns: (1.4fr, 4.5fr),
  inset: 4pt,
  [Control], [Purpose],
  [`typography(target: ..., family: ..., weight: ..., posture: ..., size: ...)`], [Convenient combined text styling.],
  [`text-family`, `text-weight`, `text-posture`, `text-size`], [Set one text attribute for one target.],
  [`text-style`], [Set family, weight, posture, and size together.],
  [`character-stretch`, `line-stretch`], [Tune residue cell dimensions.],
  [`auto-layout`, `auto-page`, `fit:`], [Let Typst choose line lengths from the current container and optionally insert page-aware block breaks.],
  [`block-gap`, `line-gap`, `feature-slot-space`], [Tune vertical spacing.],
  [`caption`, `short-caption`], [`caption` attaches visible figure-style captions; `short-caption` stores compatibility metadata for external workflows.],
)

== Pairwise Similarity And Identity

TeXshade exposes `\percentsimilarity`, `\percentidentity`, and
`\similaritytable` outside the alignment environment. Typshade provides the
same analysis as explicit data/document helpers:

```typst
#let alignment = read("AQPpro.MSF", encoding: none)

#percent-similarity(alignment, 1, 2, format: "msf", selection: "80..112")
#percent-identity(alignment, "AQP1.PRO", "AQP2.PRO", format: "msf")
#similarity-table(alignment, format: "msf", selection: "80..112")
```

#example-result(label: [Pairwise identity and similarity])[
  #table(
    columns: (1fr, 1fr),
    inset: 4pt,
    [Metric], [Value],
    [`percent-similarity(1, 2)`], [#str(percent-similarity(demo-protein, 1, 2, format: "msf", selection: "80..112")) + "%"],
    [`percent-identity(AQP1, AQP2)`], [#str(percent-identity(demo-protein, "AQP1.PRO", "AQP2.PRO", format: "msf")) + "%"],
  )
  #v(0.5em)
  #similarity-table(demo-protein, format: "msf", selection: "80..112")
]

`similarity-table` follows TeXshade's combined table convention: values above
the diagonal are percent similarity and values below the diagonal are percent
identity. Calculations use shared non-gap positions in the selected alignment
span.

= TeXshade Compatibility Reference

This section is intentionally detailed. It is the migration contract: every
major TeXshade feature is listed with the corresponding Typshade API and the
reason when the mapping is not literal.

Typshade does not keep TeX macro names as public names. Instead it preserves the
scientific capability and exposes it through Typst-style names, typed values,
recipes, and explicit command lists.

#table(
  columns: (0.9fr, 3.8fr),
  inset: 4pt,
  [Status], [Meaning],
  [`native`], [The feature is available through a Typst-native API and should be preferred for new documents.],
  [`control`], [The feature is available as a lower-level command helper, usually inside `commands:`.],
  [`recipe`], [The feature is normally expressed through a high-level `figure:` recipe.],
  [`data`], [The TeXshade command produced messages or files; Typshade exposes data/content instead.],
  [`approx`], [The visible behavior is implemented, but TeX box/glue details are intentionally not reproduced exactly.],
  [`omitted`], [The behavior is a TeX side effect, external file writer, or driver-specific hook that is not appropriate inside a Typst package.],
)

== Reading The Migration Tables

Each table row gives the TeXshade command or feature, the Typshade replacement,
the support status, and migration notes. When a row lists several TeXshade
commands, those commands are one feature family in TeXshade and are configured
together in Typshade.

For new documents, prefer this order:

1. Use `figure:` recipes when the figure has a recognizable purpose.
2. Use shortcut helpers such as `similar`, `ruler`, `logo`, `motif`, and
   `structures` when you are assembling a figure manually.
3. Use lower-level controls such as `weight-table`, `residue-style`,
   `structure-appearance`, or `feature-slot-space` only when you need exact
   control over a TeXshade-equivalent detail.

== Core Environment And Input

#table(
  columns: (1.65fr, 2.35fr, 0.75fr, 3.2fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`\begin{texshade}{file}...\end{texshade}`], [`shade(read("file", encoding: none), format: "msf", figure: publication(...))`], [`native`], [The entry point is a function call. The alignment source is explicit Typst data supplied by the caller, so package rendering does not depend on package-internal file access.],
  [TeXshade parameter files], [`#let common = (...)` plus `commands: common` or `figure: ...`], [`native`], [Use Typst variables, dictionaries, arrays, imports, and presets instead of order-sensitive parameter files.],
  [`seqtype`], [`seq-type:` or `sequence-type("P")` / `sequence-type("N")`], [`native`], [Automatic detection remains available; explicit overrides are stable and local to the figure.],
  [MSF, FASTA-like, ALN-like inputs], [`format: auto`, `format: "msf"`, or explicit parser format], [`native`], [Use `format: auto` unless an ambiguous file needs an override.],
  [TeX command stream inside the environment], [`commands: (...)`, `regions: (...)`, `features: (...)`, `figure: ...`], [`native`], [The order is visible as Typst array order; reusable command fragments can be normal variables.],
  [TeXshade inspection by compiling/log output], [`alignment-summary`, `sequence-list`, `selection-preview`, `selection-table`], [`data`], [Inspection is document content/data and can be embedded in reports.],
)

== Recommended Figure-Level Replacements

#table(
  columns: (1.65fr, 2.35fr, 0.75fr, 3.2fr),
  inset: 3.5pt,
  [TeXshade Use Case], [Typshade], [Status], [Migration Notes],
  [Publication alignment with shading, ruler, consensus], [`figure: publication(...)`], [`recipe`], [This replaces a long TeXshade setup with a purpose-level declaration. Use `similarity`, `threshold`, `region`, `motifs`, `logo`, and `ruler` options.],
  [Motif-centric figure], [`figure: motif-map(auto)` or `motif-map((...))`], [`recipe`], [Automatically detects common motifs, can focus the displayed region, and can add motif labels and conservation graphs.],
  [Structure/topology figure], [`figure: structure-map(sequence, topology: ..., secondary: ...)`], [`recipe`], [Combines alignment, ruler, consensus, and topology/secondary-structure tracks.],
  [Logo/subfamily analysis], [`figure: logo-analysis(subfamily: (...), colors: ...)`], [`recipe`], [Builds sequence-logo and subfamily-logo views without manually managing all logo commands.],
  [Dense overview of many sequences], [`figure: overview(...)`], [`recipe`], [Compact defaults for high sequence counts or report appendices.],
)

== Shading, Similarity, And Scoring

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`shadingmode[similar]{identical}`], [`identical(...)`, `similar(...)`, `diverse(...)`, `functional(...)`, `single-sequence(...)`, or `scoring-mode(...)`], [`native`], [The common modes are shortcuts; `scoring-mode` is the exact lower-level control. T-Coffee uses `tcoffee(...)` or `tcoffee-scores(...)`.],
  [`shadingcolors`], [`color-scheme("blues")` or `similar(colors: "blues")`], [`native`], [Color scheme selection is separated from scoring mode so themes can be reused.],
  [`defshadingcolors`], [`shade-theme(...)`, `visual-theme(...)`, `color-scheme(...)`, and `residue-style(...)`], [`native`], [Rather than snapshotting mutable TeX state, Typshade encourages named dictionaries and explicit style commands.],
  [`nomatchresidues`, `similarresidues`, `conservedresidues`, `allmatchresidues`], [`residue-style("nomatch", ...)`, `residue-style("similar", ...)`, `residue-style("conserved", ...)`, `residue-style("allmatch", ...)`], [`control`], [Foreground, background, case, and emphasis style can be configured per residue category.],
  [`threshold`], [`threshold(45)` or `similar(threshold: 45)`], [`native`], [Controls conservation and shading threshold. Recipes accept `threshold: auto` for sequence-type-aware defaults.],
  [`allmatchspecial`, `allmatchspecialoff`], [`all-match-threshold(value: 100)`, `disable-all-match-threshold()`], [`control`], [Controls whether very high-conservation columns receive special handling.],
  [`hideallmatchpositions`, `showallmatchpositions`], [`hide-all-match-positions()`, `show-all-match-positions()`], [`control`], [Supports removal/restoration of columns above the all-match threshold.],
  [`shadeallresidues`], [`shade-all-residues()`], [`control`], [Equivalent to lowering the threshold so every residue is eligible for shading.],
  [`weighttable`], [`weight-table("BLOSUM62")`, `weight-table("PAM250")`, `weight-table("PAM100")`, `weight-table("structural")`], [`control`], [Weighted consensus scoring is available with common TeXshade matrices.],
  [`setweight`], [`set-weight("A", "G", value)`], [`control`], [Overrides individual pair weights for custom scoring.],
  [`gappenalty`], [`gap-penalty(value)`], [`control`], [Controls how gaps contribute to weighted consensus scoring.],
  [`pepgroups`, `pepsims`], [`peptide-groups(...)`, `peptide-similarities(...)`], [`control`], [Custom peptide groupings and per-residue similarity sets.],
  [`DNAgroups`, `DNAsims`], [`dna-groups(...)`, `dna-similarities(...)`], [`control`], [Custom nucleotide groupings and per-base similarity sets.],
  [`clearfuncgroups`, `funcgroup`], [`clear-functional-groups()`, `functional-group(...)`], [`control`], [Defines a custom functional shading scheme.],
  [`funcshadingstyle`], [`functional-style(residue, fg, bg, case: ..., style: ...)`], [`control`], [Overrides style for a functional residue category.],
  [`T-Coffee` scoring file option, `includeTCoffee`], [`tcoffee(read("scores.tcs", encoding: none))` or `tcoffee-scores(read("scores.tcs", encoding: none))`], [`native`], [Loads T-Coffee confidence data as a scoring mode option.],
)

== Sequence Lines, Labels, Numbering, Gaps

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`residuesperline`, `residuesperline*`], [`lines(60)`, `lines(auto)`, `residues-per-line(auto)`, `fit: "container"`, or `auto-layout(...)`], [`native`], [Controls columns per alignment block. Auto layout uses Typst layout information to fit the current container.],
  [Manual page-break tuning], [`fit: "page"` or `auto-page(blocks: auto)`], [`native`], [Typst can split long alignment blocks using page-aware layout and optional explicit block counts.],
  [`setends`], [`window(sequence, "80..125", start: ...)`, `sequence-window(...)`, or Selection DSL values], [`native`], [Selects displayed ranges by sequence and residue selection. DSL values can combine ranges, motifs, metrics, negation, and padding.],
  [`setdomain`], [`domain(sequence, selection)`], [`control`], [Domain selection maps to the same explicit window model. Domain-specific gap styling uses normal gap controls.],
  [`shownames`, `hidenames`], [`names(position: "left")`, `no-names()`], [`native`], [Sequence-name labels are an explicit track.],
  [`nameseq`], [`sequence-name(sequence, "label")`], [`control`], [Renames an individual sequence label.],
  [`namescolor`, `namecolor`], [`names-color(color)`, `sequence-name-color(sequences, color)`], [`control`], [Global and per-sequence label colors.],
  [`hidename`], [`hide-sequence-name(sequences)`], [`control`], [Hides selected sequence labels while keeping rows.],
  [`shownumbering`, `hidenumbering`], [`numbers(position: "right")`, `no-numbers()`], [`native`], [Numbering is an explicit track.],
  [`numberingcolor`, `numbercolor`], [`numbering-color(color)`, `sequence-number-color(sequences, color)`], [`control`], [Global and per-sequence numbering colors.],
  [`hidenumber`], [`hide-sequence-number(sequences)`], [`control`], [Hides numbering for selected rows.],
  [`startnumber`], [`start-number(sequence, start, selection: ...)`], [`control`], [Overrides displayed numbering start and optional selection scope.],
  [`allowzero`, `disallowzero`], [`allow-zero-numbering()`, `disallow-zero-numbering()`], [`control`], [Controls whether zero can appear in numbering.],
  [`seqlength`], [`sequence-length(sequence, length)`], [`control`], [Overrides reported sequence length.],
  [`gapchar`], [`gap-char(symbol)`], [`control`], [Changes visible gap symbol.],
  [`gaprule`], [`gap-rule(thickness)`], [`control`], [Draws gaps as rules.],
  [`gapcolors`], [`gap-colors(foreground, background)`], [`control`], [Sets rule/character gap colors.],
  [`domaingaprule`, `domaingapcolors`], [`domain-gap-rule(thickness)`, `domain-gap-colors(foreground, background)`], [`control`], [Available as domain-oriented aliases over the same gap styling model.],
  [`showleadinggaps`, `hideleadinggaps`], [`show-leading-gaps()`, `hide-leading-gaps()`], [`control`], [Controls whether leading gaps are visible.],
  [`stopchar`], [`stop-char(symbol)`], [`control`], [Custom stop codon/terminal symbol.],
  [`shiftsingleseq`, `keepsingleseqgaps`], [`shift-single-sequence(value: ...)`, `keep-single-sequence-gaps()`], [`approx`], [Single-sequence offset behavior is represented, but TeX's unusual gap-rewriting edge cases are not treated as byte-for-byte compatibility targets.],
  [`hideresidues`, `showresidues`], [`hide-residues()`, `show-residues()`], [`control`], [Hides residue letters while preserving colored cells.],
  [`fingerprint`], [`fingerprint(value)`], [`approx`], [Provides condensed fingerprint-like rendering controls; exact TeX ultra-thin bar metrics are Typst layout approximations.],
)

== Consensus, Rulers, Logos, And Legend

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`showconsensus`, `hideconsensus`], [`consensus(position: "bottom")`, `consensus-track(...)`, `no-consensus()`], [`native`], [Adds or removes the consensus row.],
  [`nameconsensus`], [`consensus-name("consensus")`], [`control`], [Controls consensus row label.],
  [`defconsensus`], [`consensus-symbols(none, conserved, allmatch)`], [`control`], [Controls symbols used in the consensus row.],
  [`consensuscolors`], [`consensus-colors(...)`], [`control`], [Configures foreground/background colors for consensus states.],
  [`constosingleseq`, `constoallseqs`], [`consensus-from-sequence(sequence)`, `consensus-from-all-sequences()`], [`control`], [Controls the basis for consensus calculation.],
  [`germanlanguage`, `spanishlanguage`, `englishlanguage`], [`consensus-language("german")`, etc.], [`control`], [Applies to document-facing consensus labels. TeX diagnostic message localization is not reproduced.],
  [`exportconsensus`], [`alignment-data(...)`, `parse-alignment(...)`, or external tooling], [`omitted`], [Typst packages should not write arbitrary external files while rendering. Export-like workflows should use explicit build scripts.],
  [`showruler`, `hideruler`], [`ruler("top", sequence: 1)`, `ruler-track(...)`, `no-ruler(...)`], [`native`], [Adds top/bottom ruler tracks.],
  [`rulersteps`], [`ruler-steps(value, position: ...)` or `ruler(..., every: value)`], [`native`], [Controls tick interval.],
  [`rulercolor`], [`ruler-color(color, position: ...)`], [`control`], [Controls ruler color.],
  [`namerulerpos`, `nameruler`], [`ruler-marker(number, text, position: ...)`, `ruler-name(name, position: ...)`], [`control`], [Adds named ruler markers or a ruler label.],
  [`rulernamecolor`, `rulerspace`], [`ruler-name-color(color)`, `ruler-space(value)`], [`control`], [Controls ruler label styling and spacing.],
  [`rotateruler`, `unrotateruler`], [`rotate-ruler(position: ...)`, `unrotate-ruler(position: ...)`], [`approx`], [Typst rotates content, but TeX baseline/glue side effects are not copied exactly.],
  [`showsequencelogo`, `hidesequencelogo`], [`logo(position: "top")`, `sequence-logo(...)`, `no-sequence-logo()`], [`native`], [Adds or removes sequence logos.],
  [`namesequencelogo`], [`sequence-logo-name(name)` or `sequence-logo(name: ...)`], [`control`], [Controls sequence-logo label.],
  [`showlogoscale`, `hidelogoscale`], [`logo-scale(position: ..., color: ...)`, `no-logo-scale()`], [`control`], [Controls logo scale visibility and placement.],
  [`logostretch`], [`logo-stretch(value)`], [`control`], [Vertical stretch for logo display.],
  [`logocolor`, `clearlogocolors`], [`logo-color(residues, color)`, `clear-logo-colors(default: ...)`], [`control`], [Per-residue logo color control.],
  [`dofrequencycorrection`, `undofrequencycorrection`], [`frequency-correction()`, `no-frequency-correction()`], [`control`], [Controls small-sample correction for logo information content.],
  [`setsubfamily`, `showsubfamilylogo`, `hidesubfamilylogo`], [`subfamily(sequences)`, `subfamily-logo(...)`, `no-subfamily-logo()`], [`native`], [Subfamily logo support is available either as explicit commands or through `logo-analysis`.],
  [`namesubfamilylogo`], [`subfamily-logo-name(name, negative-name: ...)`], [`control`], [Controls labels for positive/negative subfamily logos.],
  [`shownegatives`, `hidenegatives`], [`negative-logo-values()`, `no-negative-logo-values()`], [`control`], [Controls negative logo values.],
  [`relevance`, `subfamilythreshold`, `showrelevance`, `hiderelevance`], [`relevance-threshold(value)`, `relevance-marker(char: ..., color: ...)`, `no-relevance-marker()`], [`control`], [Controls subfamily-logo relevance marks. `subfamilythreshold` is treated as an older spelling for the same threshold concept.],
  [`showlegend`, `hidelegend`], [`legend(color: ...)`, `legend-track(...)`, `no-legend()`], [`native`], [Legend entries derive from functional groups or the actually rendered residue style categories.],
  [`legendcolor`, `movelegend`, `shadebox`], [`legend-color(color)`, `legend-offset(dx, dy)`, `color-swatch(color)`], [`control`], [Legend placement and swatches are Typst content rather than TeX boxes.],
)

== Regions, Motifs, Features, Graphs, Translation

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`shaderegion`, `shadeblock`], [`highlight(sequence, selection, ...)` or `highlight-block(...)`], [`native`], [Selections support ranges, motif-like patterns, and PDB-derived selections.],
  [`changeshadingcolors`], [`region-color-scheme(sequence, selection, scheme)`], [`control`], [Changes the color scheme for a selected region.],
  [`tintregion`, `tintblock`], [`tint(sequence, selection, intensity: ...)`, `tint-block(...)`], [`native`], [Applies tinting to selected residues.],
  [`tintdefault`], [`tint-default(effect)`], [`control`], [Controls default tint behavior.],
  [`emphregion`, `emphblock`], [`emphasize(sequence, selection, style: ...)`, `emphasis-block(...)`], [`native`], [Applies emphasis to selected residues.],
  [`emphdefault`], [`emphasis-default(style)`], [`control`], [Controls default emphasis behavior.],
  [`lowerregion`, `lowerblock`], [`lower(sequence, selection)`, `lower-block(...)`], [`control`], [Renders selected residues in lowercase.],
  [`frameblock`], [`frame(sequence, selection, color: ...)`], [`control`], [Frames selected regions.],
  [`feature`], [`mark(position, sequence, selection, ...)`, `motif(...)`, `graph(...)`], [`native`], [Most hand-written features are easier through `mark`, `motif`, and `graph`; raw feature styles remain available via lower-level controls.],
  [Feature slots such as `top`, `ttop`, `bottom`, `bbottom`], [`mark(position, ...)`, `motif(position: ...)`, `feature-slot-space(position, value)`], [`native`], [Slot names are preserved as position strings where meaningful.],
  [`ttttopspace`, `tttopspace`, `ttopspace`, `topspace`, `bottomspace`, `bbottomspace`, `bbbottomspace`, `bbbbottomspace`], [`feature-slot-space(position, value)`], [`native`], [The separate TeX spacing macros are replaced by one explicit slot-space control keyed by position.],
  [`featurerule`], [`feature-rule(thickness)`], [`control`], [Controls boxed feature and structure row stroke thickness.],
  [`showfeaturename`, `showfeaturestylename`], [`feature-text-label(position, name)`, `feature-style-label(position, name)`], [`control`], [Names descriptive-text rows and feature-style rows.],
  [`hidefeaturename`, `hidefeaturestylename`, `hidefeaturenames`, `hidefeaturestylenames`], [`hide-feature-text-label`, `hide-feature-style-label`, `hide-feature-text-labels`, `hide-feature-style-labels`], [`control`], [Controls feature label visibility.],
  [`featurenamecolor`, `featurestylenamecolor`, `featurenamescolor`, `featurestylenamescolor`], [`feature-text-label-color-at`, `feature-style-label-color-at`, `feature-text-label-color`, `feature-style-label-color`], [`control`], [Controls feature label colors globally or per slot.],
  [Bar graph feature styles], [`graph(position, sequence, selection, metric, kind: "bar", ...)`], [`native`], [Built-in metrics include conservation, entropy, gap-fraction, coverage, identity, hydrophobicity, molecular weight, and charge.],
  [Color scale feature styles], [`graph(..., kind: "color", options: (...))`], [`native`], [Color-scale tracks support named color ramps and explicit ranges.],
  [Stacked graph styles], [`graph(..., kind: "stacked", ...)`], [`native`], [Stacked rows are available for multi-series feature data.],
  [`bargraphstretch`, `colorscalestretch`], [`bar-graph-stretch(value)`, `color-scale-stretch(value)`], [`control`], [Controls graph track height.],
  [`codon`], [`codon(residue, triplets)`], [`control`], [Custom codon mapping.],
  [`geneticcode`], [`genetic-code(name)`], [`control`], [Selects genetic-code behavior for translation features.],
  [`backtranslabel`, `backtranstext`], [`backtranslation-label(...)`, `backtranslation-text(...)`], [`approx`], [The biological annotation is preserved. Exact TeX box geometry for horizontal/vertical/oblique/zigzag labels is approximated in Typst layout.],
)

== Sequence Visibility, Ordering, Separators, Layout

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`hideseq`], [`hide-sequence(sequence)`], [`control`], [Hides one sequence row.],
  [`hideseqs`], [`hide-all-sequences()`], [`control`], [Hides all sequence rows until selectively reintroduced by other settings.],
  [`showseqs`], [`show-all-sequences()`], [`control`], [Restores sequence row visibility.],
  [`killseq`], [`remove-sequence(sequence)`], [`control`], [Removes a sequence from the displayed alignment model.],
  [`donotshade`], [`no-shade(sequences)`], [`control`], [Displays selected sequences without shading.],
  [`orderseqs`], [`sequence-order(order)`], [`control`], [Reorders sequence rows.],
  [`separationline`], [`separation-line(sequence)`], [`control`], [Adds separator after a sequence.],
  [`smallsep`, `medsep`, `bigsep`, `smallsepline`, `medsepline`, `bigsepline`, `nosepline`], [`small-separator()`, `medium-separator()`, `large-separator()`, `no-line-gap()`], [`control`], [Controls separator thickness/spacing. The older `*sepline` aliases are covered by the same explicit spacing helpers.],
  [`numberingwidth`], [`numbering-width(digits)`], [`control`], [Reserves numbering column width.],
  [`charstretch`], [`character-stretch(value)`], [`control`], [Controls cell width/stretch.],
  [`linestretch`], [`line-stretch(value)`], [`control`], [Controls row height/stretch.],
  [`alignment`], [`alignment-position(position)`], [`control`], [Controls alignment placement in its containing block. Typshade defaults to `left`; accepted values are `"left"`, `"center"`, and `"right"`.],
  [`smallblockskip`, `medblockskip`, `bigblockskip`, `noblockskip`], [`small-block-gap()`, `medium-block-gap()`, `large-block-gap()`, `no-block-gap()`], [`control`], [Block gap sizes are deterministic Typst spacing commands.],
  [`vblockspace`], [`block-gap(value)`], [`control`], [Explicit block gap.],
  [`flexblockspace`, `fixblockspace`], [`flexible-block-gap()`, `fixed-block-gap()`], [`native`], [`flexible-block-gap()` inserts weak Typst vertical space between rendered blocks so spacing can disappear cleanly at page boundaries. `fixed-block-gap()` uses fixed `stack` spacing for deterministic block separation.],
  [`vsepspace` and line-gap-like spacing], [`line-gap(value)`, `small-line-gap()`, `medium-line-gap()`, `large-line-gap()`, `no-line-gap()`], [`control`], [Explicit row/line spacing controls.],
  [`alignrightlabels`, `unalignrightlabels`], [`align-right-labels()`, `align-left-labels()`], [`control`], [Controls sequence-label column alignment.],
  [`showcaption`, `shortcaption`], [`caption(text, position: ...)`, `short-caption(text)`], [`native`], [`caption` content is ordinary Typst content and integrates with document layout. `short-caption` is metadata-only compatibility state.],
)

== Structure Tracks And PDB Selections

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`includeDSSP`], [`dssp-track(sequence, source)`], [`native`], [Adds DSSP secondary-structure annotation.],
  [`includeSTRIDE`], [`stride-track(sequence, source)`], [`native`], [Adds STRIDE annotation.],
  [`includeHMMTOP`], [`hmmtop-track(sequence, source, source-sequence: ...)`], [`native`], [Adds HMMTOP topology annotation.],
  [`includePHDtopo`], [`phd-topology-track(sequence, source)`], [`native`], [Adds PHD topology annotation.],
  [`includePHDsec`], [`phd-secondary-track(sequence, source)`], [`native`], [Adds PHD secondary-structure annotation.],
  [TeXshade `make new` structure-file modes], [External preprocessing, then `dssp-track` / `stride-track` / `hmmtop-track`], [`omitted`], [Creating new external sources is intentionally outside package rendering. Use a build step, then pass the generated source to Typshade.],
  [`showonDSSP`, `showonSTRIDE`, `showonHMMTOP`, `showonPHDtopo`, `showonPHDsec`], [`show-structure-types(format, types)`], [`control`], [Controls which structure types are visible for a format.],
  [`hideonDSSP`, `hideonSTRIDE`, `hideonHMMTOP`, `hideonPHDtopo`, `hideonPHDsec`], [`hide-structure-types(format, types)`], [`control`], [Hides selected structure types.],
  [`appearance`], [`structure-appearance(format, structure-type, position, style, text)`], [`control`], [Controls style and label text for structure annotations.],
  [`numcount`, `alphacount`, `Alphacount`, `romancount`, `Romancount`], [Template placeholders inside `structure-appearance` style/text strings.], [`native`], [Structure appearance templates expand numeric, alphabetic, and roman counters when rendering repeated structure types.],
  [`firstcolumnDSSP`, `secondcolumnDSSP`], [`use-first-dssp-column()`, `use-second-dssp-column()`], [`control`], [Selects which DSSP structure column is used.],
  [`printPDBlist`, `messagePDBlist`], [`pdb-selection(selection)`], [`data`], [Returns selection-derived residue data/content instead of writing console messages.],
  [PDB `point`, `line`, `plane` selections], [`pdb-point(...)`, `pdb-line(...)`, `pdb-plane(...)`], [`native`], [Helper functions build readable selection strings for distance-based PDB selections.],
)

== Typography, Themes, And Presets

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`setfamily`], [`text-family(target, family)` or `typography(family: ...)`], [`native`], [Targets include alignment parts such as names, numbers, residues, consensus, ruler, and features.],
  [`setseries`], [`text-weight(target, weight)` or `typography(weight: ...)`], [`native`], [Uses Typst's text weight model instead of TeX font series names.],
  [`setshape`], [`text-posture(target, posture)` or `typography(posture: ...)`], [`native`], [Uses Typst posture/style semantics.],
  [`setsize`], [`text-size(target, size)` or `typography(size: ...)`], [`native`], [Can set absolute Typst lengths or package size keywords where supported.],
  [`setfont`], [`text-style(target, family, weight, posture, size)`], [`native`], [One command can set a complete text style for a target.],
  [`featuresrm`, `featuressf`, `featurestt`, `featuresbf`, `featuresmd`, `featuresit`, `featuressl`, `featuressc`, `featuresup`, `featurestiny`, `featuresscriptsize`, `featuresfootnotesize`, `featuressmall`, `featuresnormalsize`, `featureslarge`, `featuresLarge`, `featuresLARGE`, `featureshuge`, `featuresHuge`], [`typography(target: "features", ...)`], [`native`], [TeX's many short font macros are intentionally collapsed into target-based Typst typography controls.],
  [`namesrm`, `numberingrm`, `residuesrm`, `rulerrm`, `legendrm`, `featurenamesrm`, `featurestylenames`, `featurestylenamesrm`, and corresponding family/shape/size variants], [`typography(target: ..., ...)`, `text-family`, `text-weight`, `text-posture`, `text-size`], [`native`], [All target-specific TeX font shortcuts map to the same target-based text API.],
  [Global document visual style], [`theme: "screen"`, `theme: shade-theme(...)`, `theme: visual-theme(...)`], [`native`], [Themes are explicit values, not ambient macro state.],
  [TeXshade preset-like command blocks], [`preset: "publication"` or `shade-preset(name)`], [`native`], [Reusable presets are ordinary Typst values and can be imported from local files.],
)

The legacy TeXshade typography shortcuts follow a regular naming scheme.
Typshade maps each family to `typography(target: ..., ...)`, `text-family`,
`text-weight`, `text-posture`, or `text-size`.

#table(
  columns: (1.15fr, 4.85fr),
  inset: 3.5pt,
  [TeXshade shortcut family], [Covered suffixes],
  [`features*`], [`rm`, `sf`, `tt`, `bf`, `md`, `it`, `sl`, `sc`, `up`, `tiny`, `scriptsize`, `footnotesize`, `small`, `normalsize`, `large`, `Large`, `LARGE`, `huge`, `Huge`],
  [`featurestyles*`], [`rm`, `sf`, `tt`, `bf`, `md`, `it`, `sl`, `sc`, `up`, `tiny`, `scriptsize`, `footnotesize`, `small`, `normalsize`, `large`, `Large`, `LARGE`, `huge`, `Huge`],
  [`featurenames*`, `featurestylenames*`], [`sf`, `tt`, `bf`, `md`, `it`, `sl`, `sc`, `up`, `tiny`, `scriptsize`, `footnotesize`, `small`, `normalsize`, `large`, `Large`, `LARGE`, `huge`, `Huge`],
  [`names*`, `numbering*`, `residues*`, `legend*`], [`sf`, `tt`, `bf`, `md`, `it`, `sl`, `sc`, `up`, `tiny`, `scriptsize`, `footnotesize`, `small`, `normalsize`, `large`, `Large`, `LARGE`, `huge`, `Huge`],
  [`ruler*`, `rulername*`], [`sf`, `tt`, `tiny`, `scriptsize`, `footnotesize`, `small`, `normalsize`, `large`, `Large`, `LARGE`, `huge`, `Huge`; `rulername*` also includes `rm`],
)

// Audit-only exact TeXshade shortcut names. Keep these in source so the strict
// command-surface test can verify the complete expanded macro set without
// forcing an unreadable paragraph into the public PDF:
// featurenamesHuge featurenamesLARGE featurenamesLarge featurenamesbf
// featurenamesfootnotesize featurenameshuge featurenamesit featurenameslarge
// featurenamesmd featurenamesnormalsize featurenamessc featurenamesscriptsize
// featurenamessf featurenamessl featurenamessmall featurenamestiny
// featurenamestt featurenamesup featurestylenamesHuge featurestylenamesLARGE
// featurestylenamesLarge featurestylenamesbf featurestylenamesfootnotesize
// featurestylenameshuge featurestylenamesit featurestylenameslarge
// featurestylenamesmd featurestylenamesnormalsize featurestylenamessc
// featurestylenamesscriptsize featurestylenamessf featurestylenamessl
// featurestylenamessmall featurestylenamestiny featurestylenamestt
// featurestylenamesup featurestylesHuge featurestylesLARGE featurestylesLarge
// featurestylesbf featurestylesfootnotesize featurestyleshuge featurestylesit
// featurestyleslarge featurestylesmd featurestylesnormalsize featurestylesrm
// featurestylessc featurestylesscriptsize featurestylessf featurestylessl
// featurestylessmall featurestylestiny featurestylestt featurestylesup
// legendHuge legendLARGE legendLarge legendbf legendfootnotesize legendhuge
// legendit legendlarge legendmd legendnormalsize legendsc legendscriptsize
// legendsf legendsl legendsmall legendtiny legendtt legendup namesHuge
// namesLARGE namesLarge namesbf namesfootnotesize nameshuge namesit nameslarge
// namesmd namesnormalsize namessc namesscriptsize namessf namessl namessmall
// namestiny namestt namesup numberingHuge numberingLARGE numberingLarge
// numberingbf numberingfootnotesize numberinghuge numberingit numberinglarge
// numberingmd numberingnormalsize numberingsc numberingscriptsize numberingsf
// numberingsl numberingsmall numberingtiny numberingtt numberingup residuesHuge
// residuesLARGE residuesLarge residuesbf residuesfootnotesize residueshuge
// residuesit residueslarge residuesmd residuesnormalsize residuessc
// residuesscriptsize residuessf residuessl residuessmall residuestiny residuestt
// residuesup rulerHuge rulerLARGE rulerLarge rulerfootnotesize rulerhuge
// rulerlarge rulernameHuge rulernameLARGE rulernameLarge rulernamefootnotesize
// rulernamehuge rulernamelarge rulernamenormalsize rulernamerm
// rulernamescriptsize rulernamesf rulernamesmall rulernametiny rulernamett
// rulernormalsize rulerscriptsize rulersf rulersmall rulertiny rulertt

== Utility And Analysis Functions

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`molweight`], [`molecular-weight(sequence, unit: "Da")`], [`native`], [Standalone sequence helper. Graph tracks can also use molecular-weight-derived metrics.],
  [`charge`], [`net-charge(sequence, termini: "o")`], [`native`], [Standalone sequence helper. Graph tracks can also use charge metrics.],
  [`percentsimilarity`], [`percent-similarity(source, sequence-a, sequence-b, ...)`], [`native`], [Computes pairwise percent similarity for an alignment source and optional displayed selection.],
  [`percentidentity`], [`percent-identity(source, sequence-a, sequence-b, ...)`], [`native`], [Computes pairwise percent identity over shared non-gap positions.],
  [`similaritytable`, `identitytable`], [`similarity-table(source, ...)`], [`native`], [Returns a Typst table with similarity values above the diagonal and identity values below the diagonal, matching TeXshade's combined table concept.],
  [Current-alignment macro access], [`alignment-data(source)`, `parse-alignment(text)`], [`data`], [The parsed alignment is explicit data that can be reused in Typst logic.],
  [Sequence list diagnostics], [`sequence-list(source)`], [`data`], [Document-facing sequence index/name table.],
  [Selection diagnostics], [`selection-preview(source, sequence, selection)`, `selection-table(source, ...)`], [`data`], [Preview motif/range/PDB selections without relying on TeX log output.],
)

== External Scripts And Side Effects

TeXshade includes helper behavior that prints messages, writes files, or
generates external helper script text. Typshade deliberately avoids hidden
render-time side effects:

#table(
  columns: (1.75fr, 2.35fr, 0.75fr, 3.1fr),
  inset: 3.5pt,
  [TeXshade], [Typshade], [Status], [Migration Notes],
  [`exportconsensus`], [Use `alignment-data` or an explicit build script.], [`omitted`], [No arbitrary file writes during Typst package evaluation.],
  [`messagePDBlist`], [`pdb-selection(...)` as content/data], [`data`], [The information is available, but it is not sent to TeX's console.],
  [`printPDBlist`], [`pdb-selection(...)` or `selection-table(...)`], [`data`], [Use document content rather than TeX output streams.],
  [`structurememe`, `memeStandardcolors`, `memeRed`, `memeYellow`, `memeBlue`, `memeWhite`, `memeBlack`], [External script generation outside the package.], [`omitted`], [Structure meme rendering requires generating Chimera-style command files; this side-effect belongs in an external build/tooling layer.],
  [`chimerachain`, `chimeraballScale`, `memelabelcutoff`, `chimeraaxisdistance`, `chimeraxisdistance`, `echostructurefile`], [External script generation outside the package.], [`omitted`], [These configure TeXshade's Chimera command-file output and are intentionally not public Typshade document-rendering controls.],
  [Driver-dependent specials], [Typst-native rendering only.], [`omitted`], [DVI/PDF driver hooks and TeX specials are not part of the Typst package model.],
)

== Complete Feature Coverage Summary

Typshade provides the TeXshade feature set through these current public groups:

#table(
  columns: (1.7fr, 4.9fr),
  inset: 4pt,
  [Feature Family], [Current Typshade Coverage],
  [Alignment rendering], [`shade`, `format:`, `seq-type:`, `commands:`, `figure:`, `regions:`, `features:`.],
  [Purpose-level figures], [`publication`, `motif-map`, `structure-map`, `logo-analysis`, `overview`.],
  [Scoring and shading], [`identical`, `similar`, `diverse`, `functional`, `single-sequence`, `tcoffee`, `scoring-mode`, `threshold`, `color-scheme`, `residue-style`, matrix/weight controls.],
  [Sequence display], [`lines`, `window`, `auto-layout`, `auto-page`, `fit:`, label and numbering controls, sequence visibility/order controls, gap controls, residue hiding, fingerprint controls.],
  [Consensus and ruler tracks], [`consensus`, `consensus-track`, `ruler`, `ruler-track`, symbols/colors/language/marker/rotation controls.],
  [Logos and legends], [`logo`, `sequence-logo`, `subfamily-logo`, frequency correction, negative values, relevance markers, logo colors, logo scale, legend controls.],
  [Regions and annotations], [`highlight`, `tint`, `emphasize`, `lower`, `frame`, `motif`, `mark`, `graph`, feature label and graph controls.],
  [Translation features], [`codon`, `genetic-code`, `backtranslation-label`, `backtranslation-text`, translation/complement feature styles.],
  [Structure tracks], [`structures`, `structure-tracks`, `dssp-track`, `stride-track`, `hmmtop-track`, `phd-topology-track`, `phd-secondary-track`, structure visibility and appearance controls.],
  [Selections], [`select`, `select-or`, `select-and`, `select-not`, `select-pad`, `select-all`, `select-range`, `select-residues`, `select-motif`, `select-metric`, plus PDB selection helpers.],
  [PDB selections], [`pdb-point`, `pdb-line`, `pdb-plane`, `pdb-selection`, `selection-preview`, `selection-table`.],
  [Typography and layout], [`typography`, `text-family`, `text-weight`, `text-posture`, `text-size`, `text-style`, spacing, separator, block-gap, line-gap, caption controls, `auto-layout`, `auto-page`.],
  [Analysis utilities], [`alignment-data`, `parse-alignment`, `alignment-summary`, `alignment-debug`, `cell-inspect`, `sequence-list`, `selection-preview`, `selection-table`, `percent-identity`, `percent-similarity`, `similarity-table`, `molecular-weight`, `net-charge`.],
)

= Public API Index

This index is organized from the Typshade side. Use it when you know the kind
of object you want to control but do not remember the exact helper name.

#table(
  columns: (1.55fr, 5fr),
  inset: 4pt,
  [Group], [Public Names],
  [Renderer], [`shade`],
  [Recipes], [`publication`, `motif-map`, `structure-map`, `logo-analysis`, `overview`],
  [Presets and themes], [`shade-preset`, `shade-theme`, `visual-theme`, `resolve-color`, `scale-color`],
  [Inspection and data], [`alignment-data`, `parse-alignment`, `alignment-summary`, `alignment-debug`, `cell-inspect`, `selection-preview`, `sequence-list`, `selection-table`, `percent-identity`, `percent-similarity`, `similarity-table`],
  [Selection DSL], [`select`, `select-or`, `select-and`, `select-not`, `select-pad`, `select-all`, `select-range`, `select-residues`, `select-motif`, `select-metric`],
  [Scoring shortcuts], [`identical`, `similar`, `diverse`, `functional`, `single-sequence`, `tcoffee`],
  [Layout shortcuts], [`lines`, `window`, `names`, `no-names`, `numbers`, `no-numbers`, `no-numbering`, `typography`, `gap-style`],
  [Track shortcuts], [`consensus`, `no-consensus`, `ruler`, `no-ruler`, `logo`, `no-logo`, `legend`, `no-legend`, `structures`],
  [Track controls], [`consensus-track`, `ruler-track`, `ruler-marker`, `sequence-logo`, `no-sequence-logo`, `subfamily-logo`, `no-subfamily-logo`, `legend-track`, `structure-tracks`],
  [Annotations], [`highlight`, `tint`, `emphasize`, `mark`, `motif`, `graph`, `pdb-point`, `pdb-line`, `pdb-plane`],
  [Core controls], [`sequence-type`, `color-scheme`, `scoring-mode`, `tcoffee-scores`, `sequence-window`, `residues-per-line`, `auto-layout`, `auto-page`, `threshold`],
  [Conservation controls], [`shade-all-residues`, `all-match-threshold`, `disable-all-match-threshold`, `hide-all-match-positions`, `show-all-match-positions`, `weight-table`, `set-weight`, `gap-penalty`],
  [Residue/group controls], [`residue-style`, `cell-style`, `peptide-groups`, `dna-groups`, `peptide-similarities`, `dna-similarities`, `clear-functional-groups`, `functional-group`, `functional-style`],
  [Names and numbering], [`names-track`, `numbering-track`, `sequence-name`, `names-color`, `sequence-name-color`, `hide-sequence-name`, `numbering-color`, `sequence-number-color`, `hide-sequence-number`, `start-number`, `allow-zero-numbering`, `disallow-zero-numbering`, `sequence-length`],
  [Consensus/ruler details], [`consensus-name`, `consensus-language`, `consensus-symbols`, `consensus-colors`, `consensus-from-sequence`, `consensus-from-all-sequences`, `ruler-steps`, `ruler-color`, `ruler-name`, `ruler-name-color`, `ruler-space`, `rotate-ruler`, `unrotate-ruler`],
  [Gap and sequence display], [`gap-char`, `gap-rule`, `gap-colors`, `stop-char`, `show-leading-gaps`, `hide-leading-gaps`, `hide-residues`, `show-residues`, `keep-single-sequence-gaps`, `shift-single-sequence`],
  [Regions and sequence rows], [`domain`, `domain-gap-rule`, `domain-gap-colors`, `highlight-block`, `region-color-scheme`, `lower`, `lower-block`, `emphasis-block`, `tint-block`, `tint-default`, `emphasis-default`, `frame`, `hide-sequence`, `hide-all-sequences`, `show-all-sequences`, `remove-sequence`, `no-shade`, `separation-line`, `sequence-order`],
  [Feature and translation controls], [`feature-rule`, `codon`, `genetic-code`, `backtranslation-label`, `backtranslation-text`, `feature-text-label`, `feature-style-label`, `hide-feature-text-label`, `hide-feature-style-label`, `hide-feature-text-labels`, `hide-feature-style-labels`, `feature-text-label-color`, `feature-style-label-color`, `feature-text-label-color-at`, `feature-style-label-color-at`],
  [Logo controls], [`frequency-correction`, `no-frequency-correction`, `subfamily`, `sequence-logo-name`, `subfamily-logo-name`, `logo-scale`, `no-logo-scale`, `logo-stretch`, `negative-logo-values`, `no-negative-logo-values`, `relevance-threshold`, `relevance-marker`, `no-relevance-marker`, `logo-color`, `clear-logo-colors`],
  [Legend controls], [`legend-color`, `legend-offset`, `color-swatch`],
  [Structure controls], [`show-structure-types`, `hide-structure-types`, `structure-appearance`, `use-first-dssp-column`, `use-second-dssp-column`, `stride-track`, `dssp-track`, `hmmtop-track`, `phd-topology-track`, `phd-secondary-track`],
  [Graph/layout controls], [`bar-graph-stretch`, `color-scale-stretch`, `alignment-position`, `character-stretch`, `line-stretch`, `numbering-width`, `fingerprint`, `align-right-labels`, `align-left-labels`, `auto-layout`, `auto-page`. Default block placement is left-aligned.],
  [Typography and spacing], [`text-family`, `text-weight`, `text-posture`, `text-size`, `text-style`, `caption`, `short-caption`, `small-separator`, `medium-separator`, `large-separator`, `no-block-gap`, `small-block-gap`, `medium-block-gap`, `large-block-gap`, `block-gap`, `flexible-block-gap`, `fixed-block-gap`, `no-line-gap`, `small-line-gap`, `medium-line-gap`, `large-line-gap`, `line-gap`, `feature-slot-space`],
  [Sequence utilities], [`molecular-weight`, `net-charge`, `pdb-selection`],
)

= Public API Example Catalog

This catalog gives an example invocation for every public Typshade function and
pairs each feature family with a compiled Typst result. The snippets are
intentionally compact, but the result panels are real document content produced
by the same package during compilation. When several low-level controls belong
to one feature family, the sample code lists the individual controls and the
typeset result demonstrates the family in a compact alignment or table.

== Rendering, Recipes, Presets, Themes, And Colors

Use `shade` for rendering, recipe functions for common figure purposes, presets
and themes for reusable visual defaults, and color helpers when building custom
Typst logic around Typshade colors.

```typst
#let alignment = read("alignment.msf", encoding: none)

#shade(alignment, format: "msf")

#shade(alignment, format: "msf", figure: publication(region: "80..112"))
#shade(alignment, format: "msf", figure: motif-map(("NPA": "loop")))
#shade(alignment, format: "msf", figure: structure-map(1, topology: read("AQP1.top", encoding: none)))
#shade(alignment, format: "msf", figure: logo-analysis(sequence: 3, region: "203..235"))
#shade(alignment, format: "msf", figure: overview(colors: "grays"))
#let resolved-figure = resolve-figure(
  alignment,
  "msf",
  publication(region: "80..112"),
)

#shade(alignment, format: "msf", preset: "publication")
#shade(alignment, format: "msf", theme: "screen")
#shade(
  alignment,
  format: "msf",
  theme: visual-theme(names: "RoyalBlue", ruler: "DarkGray"),
)

#let preset-commands = shade-preset("publication")
#let theme-commands = shade-theme((names: "RoyalBlue", ruler: "DarkGray"))
#let resolved-red = resolve-color("BrickRed")
#let midpoint = scale-color("ColdHot", 50)
```

#example-result(label: [Rendering, recipes, presets, themes, and colors])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Basic `shade`][
      #shade(demo-tiny-protein, format: "fasta", residues-per-line: 4, legend: false)
    ],
    result-panel[`publication(...)`][
      #shade(
        demo-protein,
        format: "msf",
        figure: publication(
          mode: "similar",
          region: "80..112",
          line-length: 40,
          conservation: false,
        ),
      )
    ],
    result-panel[`motif-map(...)`][
      #shade(
        demo-protein,
        format: "msf",
        figure: motif-map(("NPA": "NPA"), sequence: 1, region: "80..112", line-length: 40, logo: false),
      )
    ],
    result-panel[`structure-map(...)`][
      #shade(
        demo-protein,
        format: "msf",
        figure: structure-map(1, topology: demo-topology, region: "1..45", line-length: 45, conservation: false),
      )
    ],
    result-panel[`logo-analysis(...)`][
      #shade(
        demo-protein,
        format: "msf",
        figure: logo-analysis(sequence: 3, region: "203..235", subfamily: (3,), relevance: (threshold: 1.0, char: "*", color: "Red")),
      )
    ],
    result-panel[`overview(...)`][
      #shade(
        demo-protein,
        format: "msf",
        figure: overview(line-length: 50, commands: (window(1, "1..50"),)),
      )
    ],
    result-panel[Preset and theme][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        preset: "publication",
        theme: visual-theme(colors: "greens", names: "PineGreen", ruler: "DarkGray"),
        residues-per-line: 4,
        legend: false,
      )
    ],
    result-panel[Data helpers for recipes and colors][
      #let resolved = resolve-figure(demo-protein, "msf", publication(region: "80..112"))
      `resolve-figure`: #str(resolved.len()) command fragments \
      `shade-preset`: #str(shade-preset("publication").len()) fragments \
      `shade-theme`: #str(shade-theme("screen").len()) fragments \
      `resolve-color`: #box(width: 1.6em, height: 0.8em, fill: resolve-color("BrickRed")) \
      `scale-color`: #box(width: 1.6em, height: 0.8em, fill: scale-color("ColdHot", 50))
    ],
  )
]

== Data, Inspection, And Analysis

These functions return parsed alignment data, diagnostic tables, or numerical
sequence comparisons. They are useful both in prose and in figure-building
logic.

```typst
#let alignment = read("alignment.msf", encoding: none)
#let parsed = alignment-data(alignment, format: "msf")
#let tiny = parse-alignment(">A\nACD\n>B\nA-D", format: "fasta")

#alignment-summary(alignment, format: "msf")
#sequence-list(alignment, format: "msf")
#alignment-debug(alignment, format: "msf", commands: (lines(auto),))
#selection-preview(alignment, 1, "80..112", format: "msf")
#selection-table(
  alignment,
  "80..112",
  "NPA",
  format: "msf",
  sequence: 1,
)
#cell-inspect(alignment, 1, 80, format: "msf")

#percent-identity(alignment, 1, 2, format: "msf")
#percent-similarity(alignment, 1, 2, format: "msf")
#similarity-table(alignment, format: "msf")
```

#example-result(label: [Data, inspection, and analysis helpers])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[`alignment-data` and `parse-alignment`][
      #let parsed = alignment-data(demo-tiny-protein, format: "fasta")
      #let inline = parse-alignment(">A\nACD\n>B\nA-D", format: "fasta")
      Parsed fixture: #str(parsed.at("sequences").len()) sequences / #str(parsed.at("columns")) columns \
      Parsed inline: #str(inline.at("sequences").len()) sequences / #str(inline.at("columns")) columns
    ],
    result-panel[`alignment-summary` and `sequence-list`][
      #alignment-summary(demo-tiny-protein, format: "fasta")
      #v(0.4em)
      #sequence-list(demo-tiny-protein, format: "fasta")
    ],
    result-panel[`alignment-debug`][
      #alignment-debug(demo-tiny-protein, format: "fasta", commands: (lines(auto), similar()))
    ],
    result-panel[`selection-preview` and `selection-table`][
      Motif columns: #selection-preview(demo-tiny-protein, 1, "A[ED]", format: "fasta")
      #v(0.4em)
      #selection-table(
        demo-tiny-protein,
        (name: "motif", selection: "A[ED]"),
        (name: "first two", selection: "1..2"),
        format: "fasta",
      )
    ],
    result-panel[`cell-inspect`][
      #cell-inspect(demo-tiny-protein, 1, 1, format: "fasta", commands: (similar(),))
    ],
    result-panel[Pairwise analysis][
      Identity 1/2: #percent-identity(demo-tiny-protein, 1, 2, format: "fasta")% \
      Similarity 1/2: #percent-similarity(demo-tiny-protein, 1, 2, format: "fasta")%
      #v(0.4em)
      #similarity-table(demo-tiny-protein, format: "fasta")
    ],
  )
]

== Auto Layout, Pagination, And Selection DSL

Auto layout uses Typst layout information to choose the rendered line length.
Selection DSL helpers produce selection values that can be passed anywhere a
range, motif, or PDB selection is accepted.

```typst
#let alignment = read("alignment.msf", encoding: none)

#shade(
  alignment,
  format: "msf",
  fit: "container",
  commands: (
    window(1, select-or(
      select-range(80, 112),
      select-motif("NPA"),
      select-metric("coverage", at-least: 80),
    )),
  ),
)

#shade(
  alignment,
  format: "msf",
  fit: (mode: "page", min: 25, max: 55, page: (blocks: auto)),
  commands: (
    auto-layout(max: 55),
    auto-page(blocks: auto, repeat-legend: true),
    highlight(1, select-and(select-range(80, 112), select-not(select-residues(95))), bg: "LightYellow"),
    mark("top", 1, select-pad(select-residues(93), 2), text: "site"),
  ),
)

#selection-table(
  alignment,
  (name: "all", selection: select-all()),
  (name: "motif", selection: select-motif("NPA")),
  (name: "combined", selection: select(select-range(80, 112), select-metric("coverage", at-least: 80))),
  format: "msf",
)
```

#example-result(label: [Auto layout, pagination, and Selection DSL])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Selection DSL previews][
      #selection-table(
        demo-tiny-protein,
        (name: "`select-all`", selection: select-all()),
        (name: "`select-range`", selection: select-range(1, 2)),
        (name: "`select-residues`", selection: select-residues(1, 3)),
        (name: "`select-motif`", selection: select-motif("A[ED]")),
        (name: "`select-metric`", selection: select-metric("coverage", at-least: 50)),
        (name: "`select-or`", selection: select-or(select-residues(1), select-residues(3))),
        (name: "`select-and`", selection: select-and(select-range(1, 3), select-motif("A[ED]"))),
        (name: "`select-not`", selection: select-not(select-residues(2))),
        (name: "`select-pad`", selection: select-pad(select-residues(2), 1)),
        format: "fasta",
      )
    ],
    result-panel[Fit and auto commands][
      #table(
        columns: (auto, 1fr),
        inset: 3pt,
        [`auto-layout(max: 4)`], [#auto-layout(max: 4).at("kind")],
        [`auto-page(blocks: 1)`], [#auto-page(blocks: 1).at("kind")],
      )
      #v(0.4em)
      #shade(
        demo-tiny-protein,
        format: "fasta",
        fit: (mode: "page", min: 2, max: 4, page: (blocks: 1, repeat-legend: false)),
        legend: false,
        commands: (
          window(1, select(select-range(1, 4), select-motif("A[ED]"))),
          highlight(1, select-pad(select-residues(2), 1), bg: "LightYellow"),
          no-consensus(),
        ),
      )
    ],
  )
]

== Scoring, Shading, And Sequence-Type Controls

Scoring helpers are usually placed in `commands:`. The lower-level controls are
available when a figure needs exact threshold, residue style, similarity, or
weight-table behavior.

```typst
#let alignment = read("alignment.msf", encoding: none)
#let tcoffee-data = read("AQP_TC.asc", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    sequence-type("P"),
    identical(colors: "blues", threshold: 50),
    similar(colors: "greens", threshold: 45),
    diverse(option: 1),
    functional("charge"),
    single-sequence(sequence: 1),
    tcoffee(tcoffee-data),
    scoring-mode("similar"),
    tcoffee-scores(tcoffee-data),
    color-scheme("reds"),
    threshold(60),
    all-match-threshold(value: 90),
    disable-all-match-threshold(),
    shade-all-residues(),
    hide-all-match-positions(),
    show-all-match-positions(),
    weight-table("BLOSUM62"),
    set-weight("E", "Q", 2),
    gap-penalty(-5),
  ),
)
```

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    residue-style("conserved", "White", "RoyalBlue", case: "upper", style: "bold"),
    peptide-groups(("FYW", "ILVM", "RK", "DE", "GA", "ST", "NQ")),
    dna-groups(("GAR", "CTY")),
    peptide-similarities("S", "TA"),
    dna-similarities("A", "GR"),
    clear-functional-groups(),
    functional-group("acidic (-)", "DE", "White", "Red"),
    functional-style("D", "White", "BrickRed"),
  ),
)
```

#example-result(label: [Scoring, shading, residue styles, and sequence type controls])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[`similar`, `threshold`, and color scheme][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          sequence-type("P"),
          window(1, "138..170"),
          similar(colors: "greens", threshold: 45),
          all-match-threshold(value: 90),
          no-ruler(),
        ),
      )
    ],
    result-panel[`identical`, custom residue style, and `cell-style`][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          identical(colors: "reds", threshold: 50),
          residue-style("conserved", "White", "BrickRed", case: "upper", style: "bold"),
          cell-style(ctx => if ctx.at("sequence-number") == 1 { (frame: "Red") } else { none }),
          residues-per-line(4),
        ),
      )
    ],
    result-panel[`functional`, groups, and legend][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          clear-functional-groups(),
          functional-group("acidic", "DE", "White", "Red"),
          functional-group("basic", "KRH", "White", "Blue"),
          functional-style("D", "White", "BrickRed"),
          scoring-mode("functional"),
          shade-all-residues(),
          legend(),
        ),
      )
    ],
    result-panel[`diverse`, weights, and gap penalty][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          diverse(option: 1),
          weight-table("BLOSUM62"),
          set-weight("E", "Q", 2),
          gap-penalty(-5),
          no-consensus(),
        ),
      )
    ],
    result-panel[`single-sequence`][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          single-sequence(sequence: 1),
          no-consensus(),
          ruler("top", sequence: 1, every: 10),
        ),
      )
    ],
    result-panel[`tcoffee` and T-Coffee scale][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          tcoffee(demo-tcoffee),
          consensus("bottom", scale: "T-Coffee", name: "reliability"),
        ),
      )
    ],
  )
]

== Windows, Labels, Numbering, Rulers, And Gaps

The shortcut functions cover common cases. The track/control functions expose
individual knobs for sequence labels, numbering, ruler names, ruler markers,
gap characters, stop symbols, and leading-gap behavior.

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    lines(40),
    residues-per-line(40),
    window(1, "80..112"),
    sequence-window(1, "80..112", start: 80),

    names(position: "left", color: "RoyalBlue"),
    no-names(),
    numbers(position: "right", color: "DarkGray"),
    no-numbers(),
    names-track(position: "left", color: "RoyalBlue"),
    no-numbering(),
    numbering-track(position: "leftright", color: "DarkGray"),

    sequence-name(1, "AQP1"),
    names-color("RoyalBlue"),
    sequence-name-color((1, 3), "Red"),
    hide-sequence-name((2,)),
    numbering-color("DarkGray"),
    sequence-number-color((1, 3), "Red"),
    hide-sequence-number((2,)),

    start-number(1, 80, selection: "80..112"),
    allow-zero-numbering(),
    disallow-zero-numbering(),
    sequence-length(1, 269),
  ),
)
```

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    ruler("top", sequence: 1, every: 10, name: "AQP1 positions"),
    no-ruler("bottom"),
    ruler-track(position: "bottom", sequence: 1, steps: 5, color: "DarkGray"),
    ruler-marker(100, "site", position: "top", color: "Red"),
    ruler-steps(10),
    ruler-color("DarkGray"),
    ruler-name("positions"),
    ruler-name-color("Red"),
    ruler-space(2pt),
    rotate-ruler(),
    unrotate-ruler(),

    gap-style(foreground: "Gray60", background: "White", rule: 0.5pt),
    gap-char("."),
    gap-rule(0.5pt),
    gap-colors("Gray60", "White"),
    stop-char("*"),
    show-leading-gaps(),
    hide-leading-gaps(),
  ),
)
```

#example-result(label: [Windows, labels, numbering, rulers, and gaps])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Window, names, and numbering][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          lines(auto),
          window(1, "80..112"),
          sequence-window(1, "80..112", start: 80),
          names(position: "left", color: "RoyalBlue"),
          numbers(position: "leftright", color: "DarkGray"),
          sequence-name(1, "AQP1"),
          sequence-name-color((1,), "Red"),
          sequence-number-color((1,), "Red"),
          start-number(1, 80),
          sequence-length(1, 269),
          no-consensus(),
        ),
      )
    ],
    result-panel[Hidden labels and numbering][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          names-track(position: "right", color: "DarkGray"),
          numbering-track(position: "leftright", color: "Gray50"),
          hide-sequence-name((2,)),
          hide-sequence-number((2,)),
          no-consensus(),
        ),
      )
    ],
    result-panel[Ruler details][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "80..112"),
          ruler("top", sequence: 1, every: 10, name: "AQP1 positions", name-color: "Red", space: 2pt),
          ruler-track(position: "bottom", sequence: 1, steps: 5, color: "DarkGray"),
          ruler-marker(90, "site", position: "top", color: "Red"),
          ruler-color("DarkGray"),
          ruler-name("positions", position: "bottom"),
          ruler-name-color("RoyalBlue", position: "bottom"),
          rotate-ruler(position: "bottom"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Gap and stop controls][
      #shade(
        ">Alpha\n-AE*\n>Beta\n.A-*",
        format: "fasta",
        seq-type: "P",
        commands: (
          residues-per-line(4),
          gap-style(foreground: "Gray60", background: "LightYellow", rule: 0.5pt),
          gap-char("rule"),
          gap-rule(0.5pt),
          gap-colors("Gray60", "LightYellow"),
          stop-char("!"),
          show-leading-gaps(),
          no-consensus(),
        ),
      )
    ],
    result-panel[`no-names`, `no-numbering`, and hidden leading gaps][
      #shade(
        ">Alpha\n-AE*\n>Beta\n.A-*",
        format: "fasta",
        seq-type: "P",
        commands: (
          residues-per-line(4),
          no-names(),
          no-numbering(),
          hide-leading-gaps(),
          no-consensus(),
        ),
      )
    ],
  )
]

== Consensus, Logos, Legends, And Swatches

Consensus, logo, and legend helpers can be used as shortcuts or as explicit
tracks. Logo controls cover frequency correction, subfamily views, scale labels,
negative values, relevance markers, and custom residue colors.

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    consensus("bottom", scale: "ColdHot", name: "conservation"),
    no-consensus(),
    consensus-track(position: "top", scale: "BlueRed", name: "consensus"),
    consensus-name("agreement"),
    consensus-language("english"),
    consensus-symbols(".", "lower", "upper"),
    consensus-colors(
      none-fg: "Black",
      none-bg: "White",
      conserved-fg: "White",
      conserved-bg: "RoyalBlue",
      allmatch-fg: "Yellow",
      allmatch-bg: "RoyalPurple",
    ),
    consensus-from-sequence(1),
    consensus-from-all-sequences(),
  ),
)
```

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    logo("top", colors: "charge", name: "logo"),
    no-logo(),
    sequence-logo(position: "top", colors: "rasmol", name: "logo"),
    no-sequence-logo(),
    subfamily-logo((3,), position: "bottom", colors: "charge", name: "AQP3", negative-name: "others"),
    no-subfamily-logo(),
    frequency-correction(),
    no-frequency-correction(),
    subfamily((3,)),
    sequence-logo-name("sequence logo"),
    subfamily-logo-name("AQP3", negative-name: "others"),
    logo-scale(position: "leftright", color: "DarkGray"),
    no-logo-scale(),
    logo-stretch(1.2),
    negative-logo-values(),
    no-negative-logo-values(),
    relevance-threshold(1.0),
    relevance-marker(char: "*", color: "Red"),
    no-relevance-marker(),
    logo-color("DE", "Red"),
    clear-logo-colors(default: "Black"),
  ),
)

#shade(alignment, format: "msf", commands: (legend(color: "Black"),))
#shade(alignment, format: "msf", commands: (no-legend(), legend-track(color: "Black")))
#shade(alignment, format: "msf", commands: (legend-color("DarkGray"), legend-offset(6pt, 0pt)))
#color-swatch("RoyalBlue")
```

#example-result(label: [Consensus, logos, legends, and swatches])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Consensus symbols and colors][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          consensus("bottom", scale: "ColdHot", name: "agreement"),
          consensus-name("agreement"),
          consensus-language("english"),
          consensus-symbols(".", "lower", "upper"),
          consensus-colors(conserved-fg: "White", conserved-bg: "RoyalBlue", allmatch-fg: "Yellow", allmatch-bg: "RoyalPurple"),
          consensus-from-sequence(1),
        ),
      )
    ],
    result-panel[All-sequence consensus and no consensus][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          consensus-from-all-sequences(),
          consensus-track(position: "top", scale: "BlueRed", name: "consensus"),
          no-ruler(),
        ),
      )
      #v(0.4em)
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (residues-per-line(4), no-consensus()),
      )
    ],
    result-panel[Sequence logo controls][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(3, "203..235"),
          sequence-logo(position: "top", colors: "rasmol", name: "logo", scale: "leftright", relevance-marker: (char: "*", color: "Red", threshold: 1.0), stretch: 1.1),
          logo-scale(position: "leftright", color: "DarkGray"),
          logo-stretch(1.1),
          logo-color("DE", "Red"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Subfamily logo controls][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(3, "203..235"),
          subfamily((3,)),
          subfamily-logo((3,), position: "bottom", colors: "charge", name: "AQP3", negative-name: "others"),
          subfamily-logo-name("AQP3", negative-name: "others"),
          frequency-correction(),
          negative-logo-values(),
          relevance-threshold(1.0),
          relevance-marker(char: "*", color: "Red"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Logo/legend toggles][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          no-logo(),
          no-sequence-logo(),
          no-subfamily-logo(),
          clear-logo-colors(default: "Black"),
          no-logo-scale(),
          no-negative-logo-values(),
          no-frequency-correction(),
          no-relevance-marker(),
        ),
      )
    ],
    result-panel[Legend and swatches][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          functional("charge"),
          shade-all-residues(),
          legend-track(color: "Black"),
          legend-color("DarkGray"),
          legend-offset(4pt, 0pt),
        ),
      )
      #v(0.4em)
      #color-swatch("RoyalBlue") #h(0.6em)
      #color-swatch("BrickRed")
    ],
  )
]

== Regions, Domains, Motifs, Marks, Graphs, And PDB Selections

Region and annotation helpers handle the common TeXshade feature patterns:
selected domains, block highlighting, tinting, emphasis, lowercase regions,
frames, marks, motifs, graph tracks, and structure-derived selections.

```typst
#let pdb = read("1J4N.pdb", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    domain(1, "80..90,100..112"),
    domain-gap-rule(0.6pt),
    domain-gap-colors("Gray70", "White"),

    highlight(1, "NPA", fg: "White", bg: "BrickRed"),
    highlight-block(1, "80..112", "White", "LightBlue"),
    region-color-scheme(1, "80..112", "reds"),
    tint(1, "158..163", intensity: "strong"),
    tint-block(1, "158..163", intensity: "weak"),
    tint-default("normal"),
    emphasize(1, "NPA", style: "italic"),
    emphasis-block(1, "158..163", style: "bold"),
    emphasis-default("italic"),
    lower(1, "80..90"),
    lower-block(1, "80..90"),
    frame(1, "82..82,106..106", color: "Red"),
  ),
)
```

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    mark("top", 1, "93..93", fill: "Yellow", text: "site"),
    motif(1, "NXX[ST]N", text: "glycosylation", position: "top"),
    graph("top", 1, "138..170", "conservation", kind: "bar"),
    graph("top", 1, "138..170", "entropy", kind: "color", options: ("WhiteBlack",)),
    graph("bottom", 1, "138..170", "coverage", kind: "bar"),
    graph("bottom", 1, "138..170", "hydrophobicity", kind: "color", options: ("ColdHot",)),
    bar-graph-stretch(1.4),
    color-scale-stretch(1.2),
    feature-rule(0.7pt),
    feature-text-label("top", "features"),
    feature-style-label("bottom", "graph"),
    hide-feature-text-label("top"),
    hide-feature-style-label("bottom"),
    hide-feature-text-labels(),
    hide-feature-style-labels(),
    feature-text-label-color("DarkGray"),
    feature-style-label-color("DarkGray"),
    feature-text-label-color-at("top", "Red"),
    feature-style-label-color-at("bottom", "Blue"),
  ),
)
```

```typst
#let point = pdb-point(pdb, 81, distance: 8, atom: "CA")
#let line = pdb-line(pdb, 81, 168, distance: 1)
#let plane = pdb-plane(pdb, 66, 73, 199, distance: 1)

#shade(
  alignment,
  format: "msf",
  commands: (
    window(1, point),
    highlight(1, line, bg: "Yellow"),
    mark("top", 1, plane, text: "plane"),
  ),
)

#pdb-selection(point)
```

#example-result(label: [Regions, motifs, marks, graphs, and PDB selections])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Domains and domain gaps][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          domain(1, "80..90,100..112"),
          domain-gap-rule(0.6pt),
          domain-gap-colors("Gray70", "LightYellow"),
          ruler("top", sequence: 1, every: 10),
          no-consensus(),
        ),
      )
    ],
    result-panel[Highlights, tint, emphasis, lower, and frame][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          highlight(1, "138..145", fg: "White", bg: "BrickRed"),
          highlight-block(1, "146..150", "White", "RoyalBlue"),
          region-color-scheme(1, "151..155", "greens"),
          tint(1, "156..160", intensity: "strong"),
          tint-block(1, "161..163", intensity: "weak"),
          tint-default("normal"),
          emphasize(1, "164..166", style: "italic"),
          emphasis-block(1, "167..168", style: "bold"),
          emphasis-default("italic"),
          lower(1, "169..170"),
          lower-block(1, "138..139"),
          frame(1, "150..150", color: "Red"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Marks and motifs][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "80..112"),
          mark("top", 1, "93..93", fill: "Yellow", text: "site"),
          motif(1, "NPA", text: "NPA motif", position: "bottom"),
          feature-rule(0.7pt),
          feature-text-label("top", "features"),
          feature-style-label("bottom", "motif"),
          feature-text-label-color("DarkGray"),
          feature-style-label-color("Blue"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Graph metrics and graph controls][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "138..170"),
          graph("ttop", 1, "138..170", "conservation", kind: "bar"),
          graph("top", 1, "138..170", "entropy", kind: "color", options: ("WhiteBlack",)),
          graph("bottom", 1, "138..170", "coverage", kind: "bar", options: ("PineGreen", "Gray10")),
          graph("bbottom", 1, "138..170", "hydrophobicity", kind: "color", options: ("ColdHot",)),
          bar-graph-stretch(1.2),
          color-scale-stretch(1.1),
          no-consensus(),
        ),
      )
    ],
    result-panel[Feature label hiding][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "80..112"),
          mark("top", 1, "93..93", fill: "Yellow", text: "hidden label"),
          hide-feature-text-label("top"),
          hide-feature-style-label("bottom"),
          hide-feature-text-labels(),
          hide-feature-style-labels(),
          feature-text-label-color-at("top", "Red"),
          feature-style-label-color-at("bottom", "Blue"),
          no-consensus(),
        ),
      )
    ],
    result-panel[PDB selections][
      #let point = pdb-point(demo-pdb, 2, distance: 2, atom: "CA")
      #let line-sel = pdb-line(demo-pdb, 1, 2, distance: 0.2, atom-a: "CA", atom-b: "CA")
      #let plane-sel = pdb-plane(demo-pdb, 1, 2, 3, distance: 0.2, atom-a: "CA", atom-b: "CA", atom-c: "CA")
      #shade(
        demo-tiny-protein,
        format: "fasta",
        seq-type: "P",
        commands: (
          ruler("top", sequence: 1, every: 1),
          highlight(1, pdb-selection(point), bg: "Yellow"),
          tint(2, pdb-selection(line-sel)),
          mark("bottom", 1, pdb-selection(plane-sel), text: "plane"),
          no-consensus(),
        ),
      )
    ],
  )
]

== Sequence Visibility, Ordering, Layout, Typography, And Spacing

These controls cover sequence visibility, row ordering, separators, figure
placement, character metrics, fingerprints, label alignment, target-specific
typography, captions, and block/line/feature spacing.

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    hide-sequence(2),
    hide-all-sequences(),
    show-all-sequences(),
    remove-sequence(5),
    no-shade((1, 3)),
    separation-line(3),
    sequence-order((5, 4, 3, 2, 1)),

    hide-residues(),
    show-residues(),
    fingerprint(360),
    alignment-position("left"),
    character-stretch(1.1),
    line-stretch(1.05),
    numbering-width(6),
    align-right-labels(),
    align-left-labels(),
  ),
)
```

```typst
#shade(
  alignment,
  format: "msf",
  commands: (
    typography(target: "all", family: "mono", size: 8pt),
    text-family("names", "mono"),
    text-weight("names", "bold"),
    text-posture("features", "italic"),
    text-size("residues", 7pt),
    text-style("ruler", "sans", "regular", "normal", 7pt),

    caption([Aquaporin alignment], position: "bottom"),
    short-caption([AQP alignment]),
    small-separator(),
    medium-separator(),
    large-separator(),
    no-block-gap(),
    small-block-gap(),
    medium-block-gap(),
    large-block-gap(),
    block-gap(0.8em),
    flexible-block-gap(),
    fixed-block-gap(),
    no-line-gap(),
    small-line-gap(),
    medium-line-gap(),
    large-line-gap(),
    line-gap(0.2pt),
    feature-slot-space("top", 2pt),
  ),
)
```

#example-result(label: [Sequence visibility, ordering, layout, typography, and spacing])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Visibility, ordering, separators, and no-shade][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          residues-per-line(4),
          sequence-name(1, "first"),
          hide-sequence(3),
          remove-sequence(4),
          no-shade((2,)),
          separation-line(2),
          sequence-order((2, 1)),
          no-consensus(),
        ),
      )
    ],
    result-panel[Hidden residues, fingerprint, and alignment][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          fingerprint(4),
          hide-residues(),
          alignment-position("center"),
          character-stretch(1.1),
          line-stretch(1.05),
          numbering-width(6),
          align-right-labels(),
          no-consensus(),
        ),
      )
      #v(0.4em)
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (residues-per-line(4), show-residues(), align-left-labels(), no-consensus()),
      )
    ],
    result-panel[Typography controls][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "80..112"),
          typography(target: "names", weight: "bold"),
          text-family("names", "mono"),
          text-weight("names", "bold"),
          text-posture("features", "italic"),
          text-size("residues", 7pt),
          text-style("ruler", "sans", "regular", "normal", 7pt),
          ruler("top", sequence: 1, every: 10),
          no-consensus(),
        ),
      )
    ],
    result-panel[Captions and spacing commands][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (
          caption([Top caption], position: "top"),
          caption([Bottom caption], position: "bottom"),
          short-caption([Short metadata caption]),
          residues-per-line(2),
          small-separator(),
          medium-separator(),
          large-separator(),
          block-gap(4pt),
          flexible-block-gap(),
          line-gap(1pt),
          feature-slot-space("top", 2pt),
          mark("top", 1, "1..2", text: "feature"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Block and line gap presets][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (residues-per-line(2), no-block-gap(), no-line-gap(), no-consensus()),
      )
      #v(0.4em)
      #shade(
        demo-tiny-protein,
        format: "fasta",
        commands: (residues-per-line(2), large-block-gap(), medium-line-gap(), fixed-block-gap(), no-consensus()),
      )
    ],
    result-panel[Native Typst figure wrapper][
      #shade(
        demo-tiny-protein,
        format: "fasta",
        residues-per-line: 4,
        caption: [Alignment wrapped by Typst `figure`],
        short-caption: [AQP alignment],
        commands: (no-consensus(),),
      )
    ],
  )
]

== Translation, Structure Tracks, And Sequence Utilities

Translation helpers configure codon handling and backtranslation display.
Structure helpers attach DSSP, STRIDE, HMMTOP, PHD topology, or PHD secondary
structure data and control which structure classes are visible.

```typst
#let dna = read("dna-alignment.msf", encoding: none)

#shade(
  dna,
  format: "msf",
  seq-type: "N",
  commands: (
    single-sequence(sequence: 1),
    keep-single-sequence-gaps(),
    shift-single-sequence(value: -1),
    codon("A", "GCA,GCG,GCC,GCT,GCU,GCN"),
    genetic-code("standard"),
    backtranslation-label(style: "oblique", size: "tiny"),
    backtranslation-text(style: "horizontal", size: "tiny"),
    mark("bottom", 1, "1..90", style: "translate[Red]", text: "translation"),
    mark("bottom", 1, "1..90", style: "complement[LightBlue][lower]", text: "complement"),
  ),
)
```

```typst
#let topology = read("AQP1.top", encoding: none)
#let secondary = read("AQP1.phd", encoding: none)
#let hmmtop = read("AQP_HMM.ext", encoding: none)
#let dssp = read("model.dssp", encoding: none)
#let stride = read("model.stride", encoding: none)

#shade(
  alignment,
  format: "msf",
  commands: (
    structures(
      1,
      topology: topology,
      secondary: secondary,
      hmmtop: hmmtop,
    ),
    structure-tracks(
      1,
      topology: topology,
      secondary: secondary,
      hmmtop: hmmtop,
    ),
    phd-topology-track(1, topology),
    phd-secondary-track(1, secondary),
    hmmtop-track(1, hmmtop, source-sequence: 1),
    dssp-track(1, dssp),
    stride-track(1, stride),
    show-structure-types(
      "PHDtopo",
      ("TM", "internal", "external"),
    ),
    hide-structure-types("PHDtopo", ("internal",)),
    structure-appearance(
      "PHDtopo",
      "TM",
      "top",
      "box[Blue]:TM",
      "",
    ),
    use-first-dssp-column(),
    use-second-dssp-column(),
  ),
)
```

```typst
#molecular-weight("ACDEFGHIK", unit: "Da")
#molecular-weight("ACDEFGHIK", unit: "kDa")
#net-charge("ACDEFGHIK", termini: "o")
#net-charge("ACDEFGHIK", termini: "i")
```

#example-result(label: [Translation, structure tracks, and sequence utilities])[
  #grid(
    columns: (1fr,),
    gutter: 5pt,
    result-panel[Translation and complement feature styles][
      #shade(
        demo-dna,
        format: "msf",
        seq-type: "N",
        commands: (
          single-sequence(sequence: 1),
          keep-single-sequence-gaps(),
          shift-single-sequence(value: -1),
          window(1, "414..443"),
          codon("A", "GCA,GCG,GCC,GCT,GCU,GCN"),
          genetic-code("standard"),
          backtranslation-label(style: "oblique", size: "tiny"),
          backtranslation-text(style: "horizontal", size: "tiny"),
          mark("bottom", 1, "414..443", style: "translate[Red]", text: "translation"),
          mark("bottom", 1, "414..443", style: "complement[LightBlue][lower]", text: "complement"),
          no-consensus(),
        ),
      )
    ],
    result-panel[Structure tracks and appearance][
      #shade(
        demo-protein,
        format: "msf",
        commands: (
          window(1, "1..50"),
          structures(1, topology: demo-topology, secondary: demo-topology, hmmtop: demo-hmmtop),
          structure-tracks(1, topology: demo-topology, secondary: demo-topology, hmmtop: demo-hmmtop),
          phd-topology-track(1, demo-topology),
          phd-secondary-track(1, demo-topology),
          hmmtop-track(1, demo-hmmtop),
          show-structure-types("PHDtopo", ("TM", "internal", "external")),
          hide-structure-types("PHDtopo", ("external",)),
          structure-appearance("PHDtopo", "TM", "top", "box[LightBlue]", "TM"),
          no-consensus(),
        ),
      )
    ],
    result-panel[DSSP/STRIDE command constructors][
      #table(
        columns: (auto, 1fr),
        inset: 3pt,
        [`dssp-track`], [#dssp-track(1, demo-topology).at("kind")],
        [`stride-track`], [#stride-track(1, demo-topology).at("kind")],
        [`use-first-dssp-column`], [#use-first-dssp-column().at("kind")],
        [`use-second-dssp-column`], [#use-second-dssp-column().at("kind")],
      )
    ],
    result-panel[Sequence utilities][
      #table(
        columns: (auto, 1fr),
        inset: 3pt,
        [`molecular-weight("ACDEFGHIK")`], [#molecular-weight("ACDEFGHIK", unit: "Da") Da],
        [`molecular-weight(..., "kDa")`], [#molecular-weight("ACDEFGHIK", unit: "kDa") kDa],
        [`net-charge("ACDEFGHIK")`], [#net-charge("ACDEFGHIK", termini: "o")],
        [`net-charge(..., termini: "i")`], [#net-charge("ACDEFGHIK", termini: "i")],
      )
    ],
  )
]

= Typst-Specific Improvements

- `figure:` recipes let hand-written figures read as scientific intent.
- `commands:` keeps custom figures explicit without adding another top-level API.
- Dictionaries and arrays make presets easy to share.
- Inspection helpers such as `alignment-summary`, `sequence-list`, and
  `selection-table` can be embedded in documents.
- `alignment-data` and `parse-alignment` expose parsed data for custom Typst
  logic.
- HTML export uses Typst's HTML target to produce scrollable SVG alignment
  frames and semantic captions.
- Public names follow Typst conventions instead of TeX macro naming.

== HTML Export

Typst HTML export is experimental and currently requires the HTML feature flag.
Compile with `--features html --format html`; Typshade will detect the HTML
target and wrap `shade(...)` output in a scrollable `html.frame` SVG. A
`caption:` on `shade(...)` becomes semantic `figure`/`figcaption` HTML.
Data-report helpers such as `selection-table` emit native HTML tables with
explicit border styling.

The following smoke-test source is exported with the command below. The
browser screenshot is generated from the same source.

```sh
typst compile --features html --format html --root . tests/html-export.typ html-export.html
```

#raw(read("../tests/html-export.typ"), lang: "typst", block: true)

#browser-result(label: [Chrome rendering of the exported HTML], breakable: false)[
  #align(center)[
    #image("images/html-export-browser.png", width: 72%)
  ]
]

= Known Typst Differences

Some TeXshade behavior depends on TeX box construction, console messages, or
external file writes. Typshade keeps equivalent document-facing behavior where
it is meaningful, but does not promise byte-for-byte or box-for-box output.

#table(
  columns: (1.2fr, 3fr),
  inset: 5pt,
  [Area], [Typshade behavior],
  [External file writes], [Package evaluation does not perform arbitrary side-effect exports. Return data/content or use external tooling when needed.],
  [Console messages], [Inspection helpers return Typst content/data instead of writing TeX messages.],
  [Page breaking glue], [Typst uses deterministic layout controls rather than TeX glue side effects.],
  [Exact box geometry], [Ruler and backtranslation geometry is represented in Typst layout, not TeX box primitives.],
)

= License

This project is distributed under the GPL v2 License.
