#import "../package/lib.typ": *
#import "../package/internal/engine/config.typ": _apply-command, _default-config
#import "../package/internal/model/parser.typ": read-alignment
#import "../package/internal/render/alignment.typ": _apply-cell-styles, _line-count-is-auto, _render-block-stack, _resolved-blocks-per-page, _resolved-residues-per-line, _style-for-column
#import "../package/internal/render/graphs.typ": _builtin-graph-value

#set page(width: auto, height: auto, margin: 8pt)
#set text(size: 8pt)

#let source = ">Alpha\nA\n>Beta\nC\n>Gamma\nC\n"
#let alignment = read-alignment(source, format: "fasta")

#let from-sequence-config = _apply-command(_default-config(), consensus-from-sequence(1))
#let from-sequence-info = _style-for-column(alignment, from-sequence-config, 0)
#assert.eq(from-sequence-info.at("consensus"), "A")
#assert.eq(from-sequence-info.at("consensus-forced"), true)

#let all-sequences-config = _apply-command(_default-config(), consensus-from-all-sequences())
#let all-sequences-info = _style-for-column(alignment, all-sequences-config, 0)
#assert.eq(all-sequences-info.at("consensus"), "C")
#assert.eq(all-sequences-info.at("consensus-forced"), false)

#let weighted-config = _apply-command(_default-config(), weight-table("BLOSUM62"))
#let weighted-info = _style-for-column(alignment, weighted-config, 0)
#assert(weighted-info.at("consensus") != none)

#let single-sequence-config = _apply-command(_default-config(), single-sequence().first())
#assert.eq(single-sequence-config.at("shading").at("reference"), 1)

#assert.eq(selection-preview(">Alpha\nAEF-\n>Beta\nADF-\n", "1", "1..2", format: "fasta"), "1,2")
#let selection-source = ">Alpha\nAEF-\n>Beta\nADF-\n>Gamma\nA.F-\n"
#assert.eq(selection-preview(selection-source, 1, select-range(1, 2), format: "fasta"), "1,2")
#assert.eq(selection-preview(selection-source, 1, select-residues(1, 3), format: "fasta"), "1,3")
#assert.eq(selection-preview(selection-source, 1, select-motif("A[ED]"), format: "fasta"), "1,2")
#assert.eq(selection-preview(selection-source, 1, select-and(select-range(1, 3), select-motif("A[ED]")), format: "fasta"), "1,2")
#assert.eq(selection-preview(selection-source, 1, select-or(select-residues(1), select-residues(3)), format: "fasta"), "1,3")
#assert.eq(selection-preview(selection-source, 1, select-pad(select-residues(2), 1), format: "fasta"), "1,2,3")
#assert.eq(selection-preview(selection-source, 1, select-not(select-residues(2)), format: "fasta"), "1,3")
#assert.eq(selection-preview(selection-source, 1, select-metric("coverage", at-least: 50), format: "fasta"), "1,2,3")

#let flexible-config = _apply-command(_default-config(), flexible-block-gap())
#let fixed-config = _apply-command(_default-config(), fixed-block-gap())
#assert.eq(flexible-config.at("fixed-block-space"), false)
#assert.eq(fixed-config.at("fixed-block-space"), true)
#assert.eq(type(_render-block-stack(flexible-config, left, ([one], [two]))), content)
#assert.eq(type(_render-block-stack(fixed-config, left, ([one], [two]))), content)

#let auto-config = _apply-command(_default-config(), lines(auto))
#assert.eq(_line-count-is-auto(auto-config.at("residues-per-line")), true)
#assert.eq(_resolved-residues-per-line(auto-config, (0, 1, 2, 3), 74pt, 10pt, 20pt, 10pt), 3)
#let auto-layout-config = _apply-command(_default-config(), auto-layout(min: 2, max: 3))
#assert.eq(_line-count-is-auto(auto-layout-config.at("residues-per-line")), true)
#assert.eq(_resolved-residues-per-line(auto-layout-config, (0, 1, 2, 3, 4, 5), 400pt, 10pt, 20pt, 10pt), 3)
#let auto-page-config = _apply-command(_default-config(), auto-page(blocks: 2, repeat-legend: false))
#assert.eq(_resolved-blocks-per-page(alignment, auto-page-config, 100pt), 2)

#let styled-config = _apply-command(_default-config(), cell-style(ctx => if ctx.at("residue") == "A" { (bg: "Yellow", fg: "Black") } else { none }))
#let styled-info = _style-for-column(alignment, styled-config, 0)
#let styled-sequence = alignment.at("sequences").first()
#let styled-cell = _apply-cell-styles(
  alignment,
  styled-config,
  styled-sequence,
  0,
  0,
  styled-info,
  styled-info.at("styles").first(),
  (char: "A", fg: "Black", bg: "White", emph: false, frame: none, rule: false),
)
#assert.eq(styled-cell.at("bg"), "Yellow")

#assert.eq(_builtin-graph-value(alignment, styled-sequence, 0, "coverage"), 100.0)
#assert.eq(_builtin-graph-value(alignment, styled-sequence, 0, "gap-fraction"), 0.0)
#assert.eq(calc.round(_builtin-graph-value(alignment, styled-sequence, 0, "identity")), 33)
#assert(_builtin-graph-value(alignment, styled-sequence, 0, "entropy") > 0)
#assert.eq(type(alignment-debug(source, format: "fasta", commands: (lines(auto),))), content)
#assert.eq(type(cell-inspect(source, 1, 1, format: "fasta", commands: (cell-style(ctx => (bg: "Yellow")),))), content)

= Semantic Behavior

#shade(
  source,
  format: "fasta",
  commands: (
    consensus-symbols(".", "upper", "upper"),
    consensus-from-sequence(1),
  ),
)

#shade(
  source,
  format: "fasta",
  fit: "container",
  legend: true,
  caption: [Auto-width alignment],
  commands: (
    cell-style(ctx => if ctx.at("sequence-number") == 1 { (frame: "Red") } else { none }),
  ),
)

#shade(
  selection-source,
  format: "fasta",
  fit: (mode: "page", min: 2, max: 3, page: (blocks: 1, repeat-legend: false)),
  commands: (
    window(1, select-or(select-motif("A[ED]"), select-metric("coverage", at-least: 50))),
    highlight(1, select-and(select-range(1, 3), select-not(select-residues(2))), bg: "LightYellow"),
    no-consensus(),
  ),
)
