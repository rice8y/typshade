// Copyright (C) 2026 Eito Yoneyama
// SPDX-License-Identifier: GPL-2.0

//! Composable Selection DSL constructors.

#let _selection(op, fields) = {
  let out = fields
  out.insert("kind", "typshade-selection")
  out.insert("op", op)
  out
}

/// Combine selections with boolean logic and optional padding.
///
/// - `items`: Child selections combined by the selected boolean mode.
/// - `mode`: Combination or scoring mode.
/// - `padding`: Number of neighboring residues added around matches.
#let select(..items, mode: "or", padding: 0) = _selection(mode, (
  items: items.pos(),
  padding: padding,
))

/// Select columns matched by any child selection.
///
/// - `items`: Child selections whose matched columns are combined.
/// - `padding`: Number of neighboring residues added around matches.
#let select-or(..items, padding: 0) = select(..items.pos(), mode: "or", padding: padding)

/// Select columns matched by every child selection.
///
/// - `items`: Child selections whose shared matched columns are retained.
/// - `padding`: Number of neighboring residues added around matches.
#let select-and(..items, padding: 0) = select(..items.pos(), mode: "and", padding: padding)

/// Invert a selection.
///
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let select-not(selection) = _selection("not", (selection: selection))

/// Expand a selection by neighboring residues.
///
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `before`: Number of residues to include before each match.
/// - `after`: Number of residues to include after each match.
#let select-pad(selection, before, after: none) = _selection("pad", (
  selection: selection,
  before: before,
  after: if after == none { before } else { after },
))

/// Select every alignment column.
#let select-all() = _selection("all", (:))

/// Select an inclusive residue range.
///
/// - `start`: Inclusive start position, or a string range such as `"10..25"`.
/// - `args`: Optional end position, supplied positionally or as `stop`.
#let select-range(start, ..args) = {
  let positional = args.pos()
  let stop = if positional.len() > 0 { positional.first() } else { args.named().at("stop", default: none) }
  if stop == none and type(start) == str {
    _selection("range", (range: start))
  } else {
    _selection("range", (start: start, stop: if stop == none { start } else { stop }))
  }
}

/// Select explicit residue positions.
///
/// - `positions`: Explicit one-based residue positions.
#let select-residues(..positions) = _selection("positions", (positions: positions.pos()))

/// Select residues matching a motif pattern.
///
/// - `pattern`: Motif pattern to match.
#let select-motif(pattern) = _selection("motif", (pattern: pattern))

/// Select columns by an alignment metric threshold.
///
/// - `metric`: Alignment metric used for selection or graph values.
/// - `above`: Exclusive lower metric bound.
/// - `below`: Exclusive upper metric bound.
/// - `at-least`: Inclusive lower metric bound.
/// - `at-most`: Inclusive upper metric bound.
/// - `min`: Minimum permitted value.
/// - `max`: Maximum permitted value, or `none` for no explicit maximum.
/// - `equals`: Exact metric value to select.
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let select-metric(
  metric,
  above: none,
  below: none,
  at-least: none,
  at-most: none,
  min: none,
  max: none,
  equals: none,
  selection: "all",
) = _selection("metric", (
  metric: metric,
  above: above,
  below: below,
  at-least: at-least,
  at-most: at-most,
  min: min,
  max: max,
  equals: equals,
  selection: selection,
))
