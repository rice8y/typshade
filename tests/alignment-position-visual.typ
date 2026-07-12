//! Visual regression fixture for alignment positioning.

#import "../package/lib.typ": *

#set page(width: 180mm, height: auto, margin: 8mm)
#set text(size: 8pt)

#let raw = read("fixtures/tiny-protein.fasta", encoding: none)

= Alignment Position Visual Check

Default alignment must be left-aligned. Explicit left, center, and right are
rendered below so the generated PNG can be inspected directly.

== Default

#shade(raw, format: "fasta")

== Explicit Left

#shade(
  raw,
  format: "fasta",
  commands: (alignment-position("left"),),
)

== Explicit Center

#shade(
  raw,
  format: "fasta",
  commands: (alignment-position("center"),),
)

== Explicit Right

#shade(
  raw,
  format: "fasta",
  commands: (alignment-position("right"),),
)
