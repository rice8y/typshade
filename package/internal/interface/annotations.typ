// Copyright (C) 2026 Eito Yoneyama
// SPDX-License-Identifier: GPL-2.0

//! Selection annotations, motif marks, metric graphs, and PDB geometry helpers.

#import "../engine/config.typ" as _config

/// Select residues near a point defined by one PDB residue.
///
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
/// - `residue`: Residue symbol or one-based residue number, as appropriate.
/// - `distance`: Maximum distance in angstroms from the geometric primitive.
/// - `atom`: Atom selector used to locate a residue point.
#let pdb-point(source, residue, distance: 1, atom: "side") = (
  kind: "pdb-selection",
  shape: "point",
  source: source,
  distance: distance,
  anchors: ((residue: residue, atom: atom),),
)

/// Select residues near a line defined by two PDB residues.
///
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
/// - `residue-a`: First residue symbol or number.
/// - `residue-b`: Second residue symbol or number.
/// - `distance`: Maximum distance in angstroms from the geometric primitive.
/// - `atom-a`: Atom selector for the first residue.
/// - `atom-b`: Atom selector for the second residue.
#let pdb-line(source, residue-a, residue-b, distance: 1, atom-a: "side", atom-b: "side") = (
  kind: "pdb-selection",
  shape: "line",
  source: source,
  distance: distance,
  anchors: ((residue: residue-a, atom: atom-a), (residue: residue-b, atom: atom-b)),
)

/// Select residues near a plane defined by three PDB residues.
///
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
/// - `residue-a`: First residue symbol or number.
/// - `residue-b`: Second residue symbol or number.
/// - `residue-c`: Third residue number.
/// - `distance`: Maximum distance in angstroms from the geometric primitive.
/// - `atom-a`: Atom selector for the first residue.
/// - `atom-b`: Atom selector for the second residue.
/// - `atom-c`: Atom selector for the third residue.
#let pdb-plane(source, residue-a, residue-b, residue-c, distance: 1, atom-a: "side", atom-b: "side", atom-c: "side") = (
  kind: "pdb-selection",
  shape: "plane",
  source: source,
  distance: distance,
  anchors: ((residue: residue-a, atom: atom-a), (residue: residue-b, atom: atom-b), (residue: residue-c, atom: atom-c)),
)

/// Highlight a sequence selection with foreground and background colors.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `fg`: Foreground color.
/// - `bg`: Background color.
/// - `all`: Whether the operation applies across all sequences.
#let highlight(sequence, selection, fg: "White", bg: "RoyalBlue", all: false) = _config.region-highlight(sequence, selection, fg, bg, apply-to-all: all)
/// Tint a sequence selection while preserving residue shading.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `intensity`: Tint strength.
#let tint(sequence, selection, intensity: "medium") = _config.region-tint(sequence, selection, intensity: intensity)
/// Apply typographic emphasis to a sequence selection.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `style`: Visual or typographic style.
#let emphasize(sequence, selection, style: "italic") = _config.region-emphasis(sequence, selection, style: style)

/// Add a labeled mark above or below a sequence selection.
///
/// - `position`: Track side or alignment position to target.
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `fill`: Fill color.
/// - `text`: Text displayed by the generated annotation or label.
/// - `style`: Visual or typographic style.
#let mark(position, sequence, selection, fill: "Yellow", text: "", style: none) = {
  let resolved-style = if style == none { "box[" + str(fill) + "]" } else { style }
  _config.feature(position, sequence, selection, style: resolved-style, text: text)
}

/// Highlight and label a motif selection.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `text`: Text displayed by the generated annotation or label.
/// - `position`: Track side or alignment position to target.
/// - `fg`: Foreground color.
/// - `bg`: Background color.
/// - `fill`: Fill color.
/// - `all`: Whether the operation applies across all sequences.
#let motif(sequence, selection, text: "motif", position: "top", fg: "White", bg: "RoyalBlue", fill: "Yellow", all: false) = (
  highlight(sequence, selection, fg: fg, bg: bg, all: all),
  mark(position, sequence, selection, fill: fill, text: text),
)

/// Add a metric graph or color scale for a sequence selection.
///
/// - `position`: Track side or alignment position to target.
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `metric`: Alignment metric used for selection or graph values.
/// - `kind`: Rendering or measurement variant.
/// - `range`: Explicit value range, or `none` to infer it.
/// - `options`: Optional settings for the generated object.
/// - `text`: Text displayed by the generated annotation or label.
#let graph(position, sequence, selection, metric, kind: "bar", range: none, options: none, text: "") = {
  let style = (
    kind: str(kind),
    metric: metric,
    min: if range == none { none } else { range.at(0) },
    max: if range == none { none } else { range.at(1) },
    options: if options == none { () } else { options },
  )
  _config.feature(position, sequence, selection, style: style, text: text)
}
