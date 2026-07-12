// Copyright (C) 2026 Eito Yoneyama
// SPDX-License-Identifier: GPL-2.0

//! High-level constructors for consensus, ruler, logo, legend, and structure tracks.

#import "../engine/config.typ" as _config

/// Create a consensus track command.
///
/// - `position`: Track side or alignment position to target.
/// - `scale`: Scale placement or scale configuration.
/// - `name`: Name used by the generated command or rendered element.
#let consensus-track(position: "bottom", scale: none, name: none) = _config.consensus-track(position: position, scale: scale, name: name)
/// Disable consensus.
#let no-consensus() = _config.no-consensus-track()

/// Create a ruler track command.
///
/// - `position`: Track side or alignment position to target.
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `steps`: Interval between ruler labels.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
/// - `name`: Name used by the generated command or rendered element.
/// - `name-color`: Color of the track name.
/// - `space`: Additional space reserved for the track.
#let ruler-track(position: "top", sequence: 1, steps: none, color: none, name: none, name-color: none, space: none) = {
  let out = (_config.ruler-track(position: position, sequence: sequence, steps: steps, color: color),)
  if name != none {
    out.push(_config.ruler-name(name, position: position))
  }
  if color != none {
    out.push(_config.ruler-color(color, position: position))
  }
  if name-color != none {
    out.push(_config.ruler-name-color(name-color, position: position))
  }
  if space != none {
    out.push(_config.ruler-space(space, position: position))
  }
  out
}

/// Add a labeled marker at a ruler position.
///
/// - `number`: Residue number at which to place the marker.
/// - `text`: Text displayed by the generated annotation or label.
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let ruler-marker(number, text, position: "top", color: none) = _config.ruler-marker(number, text, position: position, color: color)
/// Disable ruler.
///
/// - `position`: Track side or alignment position to target.
#let no-ruler(position: none) = _config.no-ruler-track(position: position)

/// Create a configurable sequence-logo track.
///
/// - `position`: Track side or alignment position to target.
/// - `colors`: Color scheme or explicit color configuration.
/// - `name`: Name used by the generated command or rendered element.
/// - `scale`: Scale placement or scale configuration.
/// - `relevance-marker`: Relevance-marker configuration or disablement value.
/// - `stretch`: Scale factor applied to the rendered element.
#let sequence-logo(position: "top", colors: none, name: none, scale: "leftright", relevance-marker: none, stretch: none) = {
  let out = (_config.sequence-logo-track(position: position, colorset: colors),)
  if name != none {
    out.push(_config.sequence-logo-name(name))
  }
  if scale == false {
    out.push(_config.no-logo-scale())
  } else if scale != none {
    out.push(_config.logo-scale(position: scale))
  }
  if relevance-marker != none {
    out.push(_config.relevance-marker(char: relevance-marker.at("char", default: "*"), color: relevance-marker.at("color", default: "Black")))
    if relevance-marker.at("threshold", default: none) != none {
      out.push(_config.relevance-threshold(relevance-marker.at("threshold")))
    }
  }
  if stretch != none {
    out.push(_config.logo-stretch(stretch))
  }
  out
}

/// Disable sequence logo.
#let no-sequence-logo() = _config.no-sequence-logo-track()

/// Create a logo contrasting a sequence subfamily with its complement.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
/// - `position`: Track side or alignment position to target.
/// - `colors`: Color scheme or explicit color configuration.
/// - `name`: Name used by the generated command or rendered element.
/// - `negative-name`: Optional label for the negative subfamily logo.
#let subfamily-logo(sequences, position: "bottom", colors: none, name: none, negative-name: none) = {
  let out = (_config.subfamily(sequences), _config.subfamily-logo-track(position: position, colorset: colors))
  if name != none or negative-name != none {
    out.push(_config.subfamily-logo-name(if name == none { "subfamily" } else { name }, negative-name: negative-name))
  }
  out
}

/// Disable subfamily logo.
#let no-subfamily-logo() = _config.no-subfamily-logo-track()

/// Create a legend track command.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let legend-track(color: "Black") = _config.legend-track(color: color)

/// Create all requested structural annotation tracks for a sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `hmmtop`: HMMTOP annotation source.
/// - `topology`: Topology annotation source.
/// - `secondary`: Secondary-structure annotation source.
/// - `hmmtop-sequence`: Source sequence identifier used by HMMTOP data.
#let structure-tracks(sequence, hmmtop: none, topology: none, secondary: none, hmmtop-sequence: none) = {
  let out = ()
  if hmmtop != none {
    out.push(_config.hmmtop-track(sequence, hmmtop, source-sequence: hmmtop-sequence))
  }
  if topology != none {
    out.push(_config.phd-topology-track(sequence, topology))
  }
  if secondary != none {
    out.push(_config.phd-secondary-track(sequence, secondary))
  }
  out
}
