// Copyright (C) 2026 Eito Yoneyama
// SPDX-License-Identifier: GPL-2.0

//! Public command constructors for detailed alignment control.

#import "../engine/config.typ" as _config

/// Configure sequence type.
///
/// - `value`: Value for this setting.
#let sequence-type(value) = _config.sequence-type(value)
/// Configure color scheme.
///
/// - `name`: Name used by the generated command or rendered element.
#let color-scheme(name) = _config.color-scheme(name)
/// Configure scoring mode.
///
/// - `name`: Name used by the generated command or rendered element.
/// - `option`: Optional mode-specific value.
#let scoring-mode(name, option: none) = _config.scoring-mode(name, option: option)
/// Configure tcoffee scores.
///
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let tcoffee-scores(source) = scoring-mode("T-Coffee", option: source)
/// Configure sequence window.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `start`: Inclusive start position or replacement starting number.
#let sequence-window(sequence, selection, start: none) = _config.sequence-window(sequence, selection, start: start)
/// Configure residues per line.
///
/// - `value`: Value for this setting.
#let residues-per-line(value) = _config.residues-per-line(value)
/// Configure auto layout.
///
/// - `fit`: Container-fitting strategy used by automatic layout.
/// - `min`: Minimum permitted value.
/// - `max`: Maximum permitted value, or `none` for no explicit maximum.
#let auto-layout(fit: "container", min: 1, max: none) = _config.auto-layout(fit: fit, min: min, max: max)
/// Configure auto page.
///
/// - `blocks`: Alignment blocks per page, or `auto` to calculate the count.
/// - `repeat-legend`: Whether each automatic page repeats the legend.
#let auto-page(blocks: auto, repeat-legend: true) = _config.auto-page(blocks: blocks, repeat-legend: repeat-legend)
/// Configure threshold.
///
/// - `value`: Value for this setting.
#let threshold(value) = _config.threshold(value)
/// Configure shade all residues.
#let shade-all-residues() = _config.shade-all-residues()
/// Configure all match threshold.
///
/// - `value`: Value for this setting.
#let all-match-threshold(value: 100) = _config.all-match-threshold(value: value)
/// Configure disable all match threshold.
#let disable-all-match-threshold() = _config.disable-all-match-threshold()
/// Hide all match positions.
#let hide-all-match-positions() = _config.hide-all-match-positions()
/// Show all match positions.
#let show-all-match-positions() = _config.show-all-match-positions()

/// Configure weight table.
///
/// - `name`: Name used by the generated command or rendered element.
#let weight-table(name) = _config.weight-table(name)
/// Configure set weight.
///
/// - `residue-a`: First residue symbol or number.
/// - `residue-b`: Second residue symbol or number.
/// - `value`: Value for this setting.
#let set-weight(residue-a, residue-b, value) = _config.set-weight(residue-a, residue-b, value)
/// Configure gap penalty.
///
/// - `value`: Value for this setting.
#let gap-penalty(value) = _config.gap-penalty(value)

/// Configure residue style.
///
/// - `target`: Alignment element or residue class to configure.
/// - `fg`: Foreground color.
/// - `bg`: Background color.
/// - `case`: Letter case applied to rendered residues.
/// - `style`: Visual or typographic style.
#let residue-style(target, fg, bg, case: "upper", style: "normal") = _config.residue-style(target, fg, bg, case: case, style: style)
/// Configure cell style.
///
/// - `callback`: Function called with cell context to return style overrides.
#let cell-style(callback) = _config.cell-style(callback)
/// Configure peptide groups.
///
/// - `groups`: Optional residue-group definitions.
#let peptide-groups(groups) = _config.peptide-groups(groups)
/// Configure dna groups.
///
/// - `groups`: Optional residue-group definitions.
#let dna-groups(groups) = _config.dna-groups(groups)
/// Configure peptide similarities.
///
/// - `residue`: Residue symbol or one-based residue number, as appropriate.
/// - `similars`: Residues treated as similar to the target residue.
#let peptide-similarities(residue, similars) = _config.peptide-similarities(residue, similars)
/// Configure dna similarities.
///
/// - `residue`: Residue symbol or one-based residue number, as appropriate.
/// - `similars`: Residues treated as similar to the target residue.
#let dna-similarities(residue, similars) = _config.dna-similarities(residue, similars)
/// Clear functional groups.
#let clear-functional-groups() = _config.clear-functional-groups()
/// Configure functional group.
///
/// - `name`: Name used by the generated command or rendered element.
/// - `residues`: Residue symbols or positions to target.
/// - `fg`: Foreground color.
/// - `bg`: Background color.
/// - `case`: Letter case applied to rendered residues.
/// - `style`: Visual or typographic style.
#let functional-group(name, residues, fg, bg, case: "upper", style: "normal") = _config.functional-group(name, residues, fg, bg, case: case, style: style)
/// Configure functional style.
///
/// - `residue`: Residue symbol or one-based residue number, as appropriate.
/// - `fg`: Foreground color.
/// - `bg`: Background color.
/// - `case`: Letter case applied to rendered residues.
/// - `style`: Visual or typographic style.
#let functional-style(residue, fg, bg, case: "upper", style: "normal") = _config.functional-style(residue, fg, bg, case: case, style: style)

/// Create a names track command.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let names-track(position: "left", color: none) = _config.names-track(position: position, color: color)
/// Disable names.
#let no-names() = _config.no-names-track()
/// Create a numbering track command.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let numbering-track(position: "right", color: none) = _config.numbering-track(position: position, color: color)
/// Disable numbering.
#let no-numbering() = _config.no-numbering-track()
/// Configure sequence name.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `name`: Name used by the generated command or rendered element.
#let sequence-name(sequence, name) = _config.sequence-name(sequence, name)
/// Configure names color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let names-color(color) = _config.names-color(color)
/// Configure sequence name color.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let sequence-name-color(sequences, color) = _config.sequence-name-color(sequences, color)
/// Hide sequence name.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
#let hide-sequence-name(sequences) = _config.hide-sequence-name(sequences)
/// Configure numbering color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let numbering-color(color) = _config.numbering-color(color)
/// Configure sequence number color.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let sequence-number-color(sequences, color) = _config.sequence-number-color(sequences, color)
/// Hide sequence number.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
#let hide-sequence-number(sequences) = _config.hide-sequence-number(sequences)

/// Configure consensus name.
///
/// - `name`: Name used by the generated command or rendered element.
#let consensus-name(name) = _config.consensus-name(name)
/// Configure consensus language.
///
/// - `name`: Name used by the generated command or rendered element.
#let consensus-language(name) = _config.language(name)
/// Configure consensus symbols.
///
/// - `none-symbol`: Consensus symbol used for non-conserved columns.
/// - `conserved-symbol`: Consensus symbol used for conserved columns.
/// - `allmatch-symbol`: Consensus symbol used for fully conserved columns.
#let consensus-symbols(none-symbol, conserved-symbol, allmatch-symbol) = _config.consensus-symbols(none-symbol, conserved-symbol, allmatch-symbol)
/// Configure consensus colors.
///
/// - `none-fg`: Foreground color for non-conserved consensus symbols.
/// - `none-bg`: Background color for non-conserved consensus symbols.
/// - `conserved-fg`: Foreground color for conserved consensus symbols.
/// - `conserved-bg`: Background color for conserved consensus symbols.
/// - `allmatch-fg`: Foreground color for fully conserved consensus symbols.
/// - `allmatch-bg`: Background color for fully conserved consensus symbols.
#let consensus-colors(none-fg: "Black", none-bg: "White", conserved-fg: "Black", conserved-bg: "White", allmatch-fg: "Black", allmatch-bg: "White") = _config.consensus-colors(
  none-fg: none-fg,
  none-bg: none-bg,
  conserved-fg: conserved-fg,
  conserved-bg: conserved-bg,
  allmatch-fg: allmatch-fg,
  allmatch-bg: allmatch-bg,
)
/// Configure consensus from sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
#let consensus-from-sequence(sequence) = _config.consensus-from-sequence(sequence)
/// Configure consensus from all sequences.
#let consensus-from-all-sequences() = _config.consensus-from-all-sequences()

/// Configure ruler steps.
///
/// - `value`: Value for this setting.
/// - `position`: Track side or alignment position to target.
#let ruler-steps(value, position: none) = _config.ruler-steps(value, position: position)
/// Configure ruler color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
/// - `position`: Track side or alignment position to target.
#let ruler-color(color, position: none) = _config.ruler-color(color, position: position)
/// Configure ruler name.
///
/// - `name`: Name used by the generated command or rendered element.
/// - `position`: Track side or alignment position to target.
#let ruler-name(name, position: none) = _config.ruler-name(name, position: position)
/// Configure ruler name color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
/// - `position`: Track side or alignment position to target.
#let ruler-name-color(color, position: none) = _config.ruler-name-color(color, position: position)
/// Configure ruler space.
///
/// - `value`: Value for this setting.
/// - `position`: Track side or alignment position to target.
#let ruler-space(value, position: none) = _config.ruler-space(value, position: position)
/// Configure rotate ruler.
///
/// - `position`: Track side or alignment position to target.
#let rotate-ruler(position: none) = _config.rotate-ruler(position)
/// Configure unrotate ruler.
///
/// - `position`: Track side or alignment position to target.
#let unrotate-ruler(position: none) = _config.unrotate-ruler(position)

/// Configure gap char.
///
/// - `symbol`: Character used for the configured residue class.
#let gap-char(symbol) = _config.gap-char(symbol)
/// Configure gap rule.
///
/// - `thickness`: Line or rule thickness.
#let gap-rule(thickness) = _config.gap-rule(thickness)
/// Configure gap colors.
///
/// - `foreground`: Foreground color.
/// - `background`: Background color.
#let gap-colors(foreground, background) = _config.gap-colors(foreground, background)
/// Configure stop char.
///
/// - `symbol`: Character used for the configured residue class.
#let stop-char(symbol) = _config.stop-char(symbol)
/// Show leading gaps.
#let show-leading-gaps() = _config.show-leading-gaps()
/// Hide leading gaps.
#let hide-leading-gaps() = _config.hide-leading-gaps()

/// Configure start number.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `start`: Inclusive start position or replacement starting number.
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let start-number(sequence, start, selection: none) = _config.start-number(sequence, start, selection: selection)
/// Allow zero numbering.
#let allow-zero-numbering() = _config.allow-zero-numbering()
/// Disallow zero numbering.
#let disallow-zero-numbering() = _config.disallow-zero-numbering()
/// Configure sequence length.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `length`: Declared sequence length or output extent.
#let sequence-length(sequence, length) = _config.sequence-length(sequence, length)
/// Configure domain.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let domain(sequence, selection) = _config.domain(sequence, selection)
/// Configure domain gap rule.
///
/// - `thickness`: Line or rule thickness.
#let domain-gap-rule(thickness) = _config.domain-gap-rule(thickness)
/// Configure domain gap colors.
///
/// - `foreground`: Foreground color.
/// - `background`: Background color.
#let domain-gap-colors(foreground, background) = _config.domain-gap-colors(foreground, background)

/// Configure highlight block.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `args`: Additional positional or named options forwarded to the command.
#let highlight-block(sequence, selection, ..args) = _config.highlight-block(sequence, selection, ..args)
/// Configure region color scheme.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `scheme`: Named color scheme.
#let region-color-scheme(sequence, selection, scheme) = _config.region-color-scheme(sequence, selection, scheme)
/// Configure lower.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let lower(sequence, selection) = _config.region-lower(sequence, selection)
/// Configure lower block.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let lower-block(sequence, selection) = _config.lower-block(sequence, selection)
/// Configure emphasis block.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `style`: Visual or typographic style.
#let emphasis-block(sequence, selection, style: "italic") = _config.emphasis-block(sequence, selection, style: style)
/// Configure tint block.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `intensity`: Tint strength.
#let tint-block(sequence, selection, intensity: "medium") = _config.tint-block(sequence, selection, intensity: intensity)
/// Configure tint default.
///
/// - `effect`: Named default tint effect.
#let tint-default(effect) = _config.tint-default(effect)
/// Configure emphasis default.
///
/// - `style`: Visual or typographic style.
#let emphasis-default(style) = _config.emphasis-default(style)
/// Configure frame.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `selection`: Residue range or Selection DSL expression to resolve.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let frame(sequence, selection, color: "Red") = _config.frame-block(sequence, selection, color: color)

/// Hide sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
#let hide-sequence(sequence) = _config.hide-sequence(sequence)
/// Hide all sequences.
#let hide-all-sequences() = _config.hide-all-sequences()
/// Show all sequences.
#let show-all-sequences() = _config.show-all-sequences()
/// Configure remove sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
#let remove-sequence(sequence) = _config.remove-sequence(sequence)
/// Disable shade.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
#let no-shade(sequences) = _config.no-shade(sequences)
/// Configure separation line.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
#let separation-line(sequence) = _config.separation-line(sequence)
/// Configure sequence order.
///
/// - `order`: Sequence order expressed as names or one-based indices.
#let sequence-order(order) = _config.sequence-order(order)

/// Configure feature rule.
///
/// - `thickness`: Line or rule thickness.
#let feature-rule(thickness) = _config.feature-rule(thickness)
/// Configure codon.
///
/// - `residue`: Residue symbol or one-based residue number, as appropriate.
/// - `triplets`: Comma-separated codons assigned to the residue.
#let codon(residue, triplets) = _config.codon(residue, triplets)
/// Configure genetic code.
///
/// - `name`: Name used by the generated command or rendered element.
#let genetic-code(name) = _config.genetic-code(name)
/// Configure backtranslation label.
///
/// - `args`: Additional positional or named options forwarded to the command.
#let backtranslation-label(..args) = _config.backtranslation-label(..args)
/// Configure backtranslation text.
///
/// - `args`: Additional positional or named options forwarded to the command.
#let backtranslation-text(..args) = _config.backtranslation-text(..args)
/// Configure feature text label.
///
/// - `position`: Track side or alignment position to target.
/// - `name`: Name used by the generated command or rendered element.
#let feature-text-label(position, name) = _config.feature-text-label(position, name)
/// Configure feature style label.
///
/// - `position`: Track side or alignment position to target.
/// - `name`: Name used by the generated command or rendered element.
#let feature-style-label(position, name) = _config.feature-style-label(position, name)
/// Hide feature text label.
///
/// - `position`: Track side or alignment position to target.
#let hide-feature-text-label(position) = _config.hide-feature-text-label(position)
/// Hide feature style label.
///
/// - `position`: Track side or alignment position to target.
#let hide-feature-style-label(position) = _config.hide-feature-style-label(position)
/// Hide feature text labels.
#let hide-feature-text-labels() = _config.hide-feature-text-labels()
/// Hide feature style labels.
#let hide-feature-style-labels() = _config.hide-feature-style-labels()
/// Configure feature text label color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let feature-text-label-color(color) = _config.feature-text-label-color(color)
/// Configure feature style label color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let feature-style-label-color(color) = _config.feature-style-label-color(color)
/// Configure feature text label color at.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let feature-text-label-color-at(position, color) = _config.feature-text-label-color-at(position, color)
/// Configure feature style label color at.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let feature-style-label-color-at(position, color) = _config.feature-style-label-color-at(position, color)

/// Configure frequency correction.
#let frequency-correction() = _config.frequency-correction()
/// Disable frequency correction.
#let no-frequency-correction() = _config.no-frequency-correction()
/// Configure subfamily.
///
/// - `sequences`: Sequence names, indices, or selectors to target.
#let subfamily(sequences) = _config.subfamily(sequences)
/// Configure sequence logo name.
///
/// - `name`: Name used by the generated command or rendered element.
#let sequence-logo-name(name) = _config.sequence-logo-name(name)
/// Configure subfamily logo name.
///
/// - `name`: Name used by the generated command or rendered element.
/// - `negative-name`: Optional label for the negative subfamily logo.
#let subfamily-logo-name(name, negative-name: none) = _config.subfamily-logo-name(name, negative-name: negative-name)
/// Configure logo scale.
///
/// - `position`: Track side or alignment position to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let logo-scale(position: "leftright", color: "Black") = _config.logo-scale(position: position, color: color)
/// Disable logo scale.
#let no-logo-scale() = _config.no-logo-scale()
/// Configure logo stretch.
///
/// - `value`: Value for this setting.
#let logo-stretch(value) = _config.logo-stretch(value)
/// Configure negative logo values.
#let negative-logo-values() = _config.negative-logo-values()
/// Disable negative logo values.
#let no-negative-logo-values() = _config.no-negative-logo-values()
/// Configure relevance threshold.
///
/// - `value`: Value for this setting.
#let relevance-threshold(value) = _config.relevance-threshold(value)
/// Configure relevance marker.
///
/// - `char`: Character used by the marker.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let relevance-marker(char: "*", color: "Black") = _config.relevance-marker(char: char, color: color)
/// Disable relevance marker.
#let no-relevance-marker() = _config.no-relevance-marker()
/// Configure logo color.
///
/// - `residues`: Residue symbols or positions to target.
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let logo-color(residues, color) = _config.logo-color(residues, color)
/// Clear logo colors.
///
/// - `default`: Default value used when no explicit override matches.
#let clear-logo-colors(default: "Black") = _config.clear-logo-colors(default: default)

/// Disable legend.
#let no-legend() = _config.no-legend-track()
/// Configure legend color.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let legend-color(color) = _config.legend-color(color)
/// Configure legend offset.
///
/// - `dx`: Horizontal legend offset.
/// - `dy`: Vertical legend offset.
#let legend-offset(dx, dy) = _config.legend-offset(dx, dy)
/// Configure color swatch.
///
/// - `color`: Color accepted by Typst or Typshade's named-color resolver.
#let color-swatch(color) = _config.color-swatch(color)

/// Show structure types.
///
/// - `format`: Input format, or `auto` to detect it.
/// - `types`: Structural annotation types to show or hide.
#let show-structure-types(format, types) = _config.show-structure-types(format, types)
/// Hide structure types.
///
/// - `format`: Input format, or `auto` to detect it.
/// - `types`: Structural annotation types to show or hide.
#let hide-structure-types(format, types) = _config.hide-structure-types(format, types)
/// Configure structure appearance.
///
/// - `format`: Input format, or `auto` to detect it.
/// - `structure-type`: Structural annotation type to configure.
/// - `position`: Track side or alignment position to target.
/// - `style`: Visual or typographic style.
/// - `text`: Text displayed by the generated annotation or label.
#let structure-appearance(format, structure-type, position, style, text) = _config.structure-appearance(format, structure-type, position, style, text)
/// Use the first dssp column.
#let use-first-dssp-column() = _config.use-first-dssp-column()
/// Use the second dssp column.
#let use-second-dssp-column() = _config.use-second-dssp-column()
/// Create a stride track command.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let stride-track(sequence, source) = _config.stride-track(sequence, source)
/// Create a dssp track command.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let dssp-track(sequence, source) = _config.dssp-track(sequence, source)
/// Create a hmmtop track command.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
/// - `source-sequence`: Sequence identifier represented by the annotation source.
#let hmmtop-track(sequence, source, source-sequence: none) = _config.hmmtop-track(sequence, source, source-sequence: source-sequence)
/// Create a phd topology track command.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let phd-topology-track(sequence, source) = _config.phd-topology-track(sequence, source)
/// Create a phd secondary track command.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `source`: Input data, text, bytes, or a path accepted by the selected parser.
#let phd-secondary-track(sequence, source) = _config.phd-secondary-track(sequence, source)

/// Configure keep single sequence gaps.
#let keep-single-sequence-gaps() = _config.keep-single-sequence-gaps()
/// Configure shift single sequence.
///
/// - `value`: Value for this setting.
#let shift-single-sequence(value: -1) = _config.shift-single-sequence(value)
/// Hide residues.
#let hide-residues() = _config.hide-residues()
/// Show residues.
#let show-residues() = _config.show-residues()
/// Configure bar graph stretch.
///
/// - `value`: Value for this setting.
/// - `position`: Track side or alignment position to target.
#let bar-graph-stretch(value, position: none) = _config.bar-graph-stretch(value, position: position)
/// Configure color scale stretch.
///
/// - `value`: Value for this setting.
/// - `position`: Track side or alignment position to target.
#let color-scale-stretch(value, position: none) = _config.color-scale-stretch(value, position: position)
/// Configure alignment position.
///
/// - `position`: Track side or alignment position to target.
#let alignment-position(position) = _config.alignment(position)
/// Configure character stretch.
///
/// - `value`: Value for this setting.
#let character-stretch(value) = _config.character-stretch(value)
/// Configure line stretch.
///
/// - `value`: Value for this setting.
#let line-stretch(value) = _config.line-stretch(value)
/// Configure numbering width.
///
/// - `digits`: Reserved width in decimal digits.
#let numbering-width(digits) = _config.numbering-width(digits)
/// Configure fingerprint.
///
/// - `value`: Value for this setting.
#let fingerprint(value) = _config.fingerprint(value)
/// Configure align right labels.
#let align-right-labels() = _config.align-right-labels()
/// Configure align left labels.
#let align-left-labels() = _config.align-left-labels()

/// Configure text family.
///
/// - `target`: Alignment element or residue class to configure.
/// - `family`: Font family.
#let text-family(target, family) = _config.text-family(target, family)
/// Configure text weight.
///
/// - `target`: Alignment element or residue class to configure.
/// - `weight`: Font weight.
#let text-weight(target, weight) = _config.text-weight(target, weight)
/// Configure text posture.
///
/// - `target`: Alignment element or residue class to configure.
/// - `posture`: Font posture.
#let text-posture(target, posture) = _config.text-posture(target, posture)
/// Configure text size.
///
/// - `target`: Alignment element or residue class to configure.
/// - `size`: Text size.
#let text-size(target, size) = _config.text-size(target, size)
/// Configure text style.
///
/// - `target`: Alignment element or residue class to configure.
/// - `family`: Font family.
/// - `weight`: Font weight.
/// - `posture`: Font posture.
/// - `size`: Text size.
#let text-style(target, family, weight, posture, size) = _config.text-style(target, family, weight, posture, size)

/// Configure caption.
///
/// - `text`: Text displayed by the generated annotation or label.
/// - `position`: Track side or alignment position to target.
#let caption(text, position: "bottom") = _config.caption(text, position: position)
/// Configure short caption.
///
/// - `text`: Text displayed by the generated annotation or label.
#let short-caption(text) = _config.short-caption(text)
/// Configure small separator.
#let small-separator() = _config.small-separator()
/// Configure medium separator.
#let medium-separator() = _config.medium-separator()
/// Configure large separator.
#let large-separator() = _config.large-separator()
/// Disable block gap.
#let no-block-gap() = _config.no-block-gap()
/// Configure small block gap.
#let small-block-gap() = _config.small-block-gap()
/// Configure medium block gap.
#let medium-block-gap() = _config.medium-block-gap()
/// Configure large block gap.
#let large-block-gap() = _config.large-block-gap()
/// Configure block gap.
///
/// - `value`: Value for this setting.
#let block-gap(value) = _config.block-gap(value)
/// Configure flexible block gap.
#let flexible-block-gap() = _config.flexible-block-gap()
/// Configure fixed block gap.
#let fixed-block-gap() = _config.fixed-block-gap()
/// Disable line gap.
#let no-line-gap() = _config.no-line-gap()
/// Configure small line gap.
#let small-line-gap() = _config.small-line-gap()
/// Configure medium line gap.
#let medium-line-gap() = _config.medium-line-gap()
/// Configure large line gap.
#let large-line-gap() = _config.large-line-gap()
/// Configure line gap.
///
/// - `value`: Value for this setting.
#let line-gap(value) = _config.line-gap(value)
/// Configure feature slot space.
///
/// - `position`: Track side or alignment position to target.
/// - `value`: Value for this setting.
#let feature-slot-space(position, value) = _config.feature-slot-space(position, value)

/// Calculate the molecular weight of a protein sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `unit`: Unit used for the returned molecular weight.
#let molecular-weight(sequence, unit: "Da") = _config.molweight(sequence, unit: unit)
/// Calculate the approximate net charge of a protein sequence.
///
/// - `sequence`: Sequence name, one-based index, or supported sequence selector.
/// - `termini`: Terminal charge convention.
#let net-charge(sequence, termini: "o") = _config.charge(sequence, termini: termini)
/// Create a command from a PDB geometry selection.
///
/// - `selection`: Residue range or Selection DSL expression to resolve.
#let pdb-selection(selection) = _config.pdb-selection(selection)
