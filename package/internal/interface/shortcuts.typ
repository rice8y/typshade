// Copyright (C) 2026 Eito Yoneyama
// SPDX-License-Identifier: GPL-2.0

//! Concise convenience commands for common shading workflows.

#import "../engine/config.typ" as _config
#import "annotations.typ": highlight, tint, emphasize, mark, motif, graph
#import "tracks.typ": consensus-track, ruler-track, sequence-logo, legend-track, structure-tracks

#let _scoring(
  mode,
  colors: none,
  threshold: none,
  option: none,
  all-match-threshold: none,
  weight-table: none,
  gap-penalty: none,
) = {
  let out = (_config.scoring-mode(mode, option: option),)
  if colors != none {
    out.push(_config.color-scheme(colors))
  }
  if threshold != none {
    out.push(_config.threshold(threshold))
  }
  if all-match-threshold != none {
    out.push(_config.all-match-threshold(value: all-match-threshold))
  }
  if weight-table != none {
    out.push(_config.weight-table(weight-table))
  }
  if gap-penalty != none {
    out.push(_config.gap-penalty(gap-penalty))
  }
  out
}

/// Shade columns by residue identity.
///
/// - `colors`: Color scheme or explicit color configuration.
/// - `threshold`: Percentage or score threshold used by the operation.
/// - `option`: Optional mode-specific value.
/// - `rest`: Additional named scoring options forwarded to the low-level command.
#let identical(colors: none, threshold: none, option: none, ..rest) = _scoring(
  "identical",
  colors: colors,
  threshold: threshold,
  option: option,
  ..rest,
)

/// Shade columns by biochemical similarity.
///
/// - `colors`: Color scheme or explicit color configuration.
/// - `threshold`: Percentage or score threshold used by the operation.
/// - `option`: Optional mode-specific value.
/// - `rest`: Additional named scoring options forwarded to the low-level command.
#let similar(colors: none, threshold: none, option: none, ..rest) = _scoring(
  "similar",
  colors: colors,
  threshold: threshold,
  option: option,
  ..rest,
)

/// Shade columns by residue diversity.
///
/// - `colors`: Color scheme or explicit color configuration.
/// - `threshold`: Percentage or score threshold used by the operation.
/// - `option`: Optional mode-specific value.
/// - `rest`: Additional named scoring options forwarded to the low-level command.
#let diverse(colors: none, threshold: none, option: none, ..rest) = _scoring(
  "diverse",
  colors: colors,
  threshold: threshold,
  option: option,
  ..rest,
)

/// Shade residues using a functional-group preset.
///
/// - `kind`: Rendering or measurement variant.
/// - `colors`: Color scheme or explicit color configuration.
/// - `threshold`: Percentage or score threshold used by the operation.
/// - `rest`: Additional named scoring options forwarded to the low-level command.
#let functional(kind, colors: none, threshold: none, ..rest) = _scoring(
  "functional",
  colors: colors,
  threshold: threshold,
  option: kind,
  ..rest,
)

/// Shade relative to one reference sequence.
///
/// - `colors`: Color scheme or explicit color configuration.
/// - `threshold`: Percentage or score threshold used by the operation.
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `rest`: Additional named scoring options forwarded to the low-level command.
#let single-sequence(colors: none, threshold: none, sequence: none, ..rest) = _scoring(
  "singleseq",
  colors: colors,
  threshold: threshold,
  option: sequence,
  ..rest,
)

/// Shade an alignment from T-Coffee confidence scores.
///
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let tcoffee(source) = _config.scoring-mode("T-Coffee", option: source)

/// Set the number of residues rendered per line.
///
/// - `count`: Number of residues rendered per line.
#let lines(count) = _config.residues-per-line(count)

/// Display a selected sequence window.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `start`: Inclusive start position or replacement starting number.
#let window(sequence, selection, start: none) = _config.sequence-window(sequence, selection, start: start)

/// Show and configure sequence names.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let names(position: "left", color: none) = _config.names-track(position: position, color: color)

/// Disable names.
#let no-names() = _config.no-names-track()

/// Show and configure sequence numbering.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let numbers(position: "right", color: none) = _config.numbering-track(position: position, color: color)

/// Disable numbers.
#let no-numbers() = _config.no-numbering-track()

/// Show and configure the consensus track.
///
/// - `position`: Track side or alignment position to target.
/// - `scale`: Scale placement or scale configuration.
/// - `name`: Name used by the generated command or rendered element.
#let consensus(position, scale: none, name: none) = consensus-track(position: position, scale: scale, name: name)

/// Disable consensus.
#let no-consensus() = _config.no-consensus-track()

/// Show and configure a ruler track.
///
/// - `position`: Track side or alignment position to target.
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `every`: Interval between generated ruler labels.
/// - `steps`: Interval between ruler labels.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
/// - `name`: Name used by the generated command or rendered element.
/// - `name-color`: Color of the track name.
/// - `space`: Additional space reserved for the track.
#let ruler(position, sequence: 1, every: none, steps: none, color: none, name: none, name-color: none, space: none) = {
  ruler-track(
    position: position,
    sequence: sequence,
    steps: if steps == none { every } else { steps },
    color: color,
    name: name,
    name-color: name-color,
    space: space,
  )
}

/// Disable ruler.
///
/// - `position`: Track side or alignment position to target.
#let no-ruler(position: none) = _config.no-ruler-track(position: position)

/// Show and configure a sequence-logo track.
///
/// - `position`: Track side or alignment position to target.
/// - `colors`: Color scheme or explicit color configuration.
/// - `name`: Name used by the generated command or rendered element.
/// - `scale`: Scale placement or scale configuration.
/// - `relevance-marker`: Relevance-marker configuration or disablement value.
/// - `stretch`: Scale factor applied to the rendered element.
#let logo(position, colors: none, name: none, scale: "leftright", relevance-marker: none, stretch: none) = {
  sequence-logo(
    position: position,
    colors: colors,
    name: name,
    scale: scale,
    relevance-marker: relevance-marker,
    stretch: stretch,
  )
}

/// Disable logo.
#let no-logo() = _config.no-sequence-logo-track()

/// Show and configure the shading legend.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let legend(color: "Black") = legend-track(color: color)

/// Disable legend.
#let no-legend() = _config.no-legend-track()

/// Add available structural annotation tracks for a sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `hmmtop`: HMMTOP annotation source.
/// - `topology`: Topology annotation source.
/// - `secondary`: Secondary-structure annotation source.
/// - `hmmtop-sequence`: Source sequence identifier used by HMMTOP data.
#let structures(sequence, hmmtop: none, topology: none, secondary: none, hmmtop-sequence: none) = {
  structure-tracks(
    sequence,
    hmmtop: hmmtop,
    topology: topology,
    secondary: secondary,
    hmmtop-sequence: hmmtop-sequence,
  )
}

/// Configure gap glyphs, rules, and colors.
///
/// - `foreground`: Foreground color.
/// - `background`: Background color.
/// - `rule`: Gap-rule thickness, or `none` to leave it unchanged.
#let gap-style(foreground: none, background: none, rule: none) = {
  let out = ()
  if foreground != none or background != none {
    out.push(_config.gap-colors(
      if foreground == none { "Black" } else { foreground },
      if background == none { "White" } else { background },
    ))
  }
  if rule != none {
    out.push(_config.gap-rule(rule))
  }
  out
}

/// Configure typography for alignment elements.
///
/// - `target`: Alignment element or residue class to configure.
/// - `family`: Font family.
/// - `weight`: Font weight.
/// - `posture`: Font posture.
/// - `size`: Text size.
#let typography(target: "all", family: none, weight: none, posture: none, size: none) = {
  let out = ()
  if family != none {
    out.push(_config.text-family(target, family))
  }
  if weight != none {
    out.push(_config.text-weight(target, weight))
  }
  if posture != none {
    out.push(_config.text-posture(target, posture))
  }
  if size != none {
    out.push(_config.text-size(target, size))
  }
  out
}
