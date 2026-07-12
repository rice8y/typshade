# TeXshade Visual Parity Report

Reference inputs:

- `/Users/yoneyama/workspace/github/typshade-copy/texshade/texshade.dtx`
- `/Users/yoneyama/workspace/github/typshade-copy/texshade/texshade.pdf`

Run:

```sh
bash tests/texshade_visual_parity.sh
```

The audit renders TeXshade manual pages 15..38 and `tests/texshade-visual-parity.typ` to PNG images, then builds a side-by-side contact sheet.

## Current Result

The image pipeline succeeds: all TeXshade reference pages, all Typshade parity pages, and the generated contact sheet render as non-empty PNG files.

The TeXshade PDF emits Poppler warnings such as `Unknown operator 'rgb'` while being rasterized. The warnings originate from the reference PDF and do not prevent PNG generation.

## Visually Covered Feature Families

- Identity, similarity, diverse mode, T-Coffee scoring.
- Functional modes: charge, hydropathy, structure, chemical, rasmol, standard area, accessible area.
- Domain/window selection, rulers, numbering, consensus rows, legends.
- Region highlighting, tinting, lowercasing, frames, feature labels.
- Bar/color/frustration/stacked graph track entry points.
- PHD/HMMTOP-like structure tracks.
- Fingerprints.
- DNA sequence logos, protein sequence logos, subfamily logos.
- Single-sequence display, translation/complement feature entry points.
- Similarity/identity tables and analysis helpers.

## Findings From Image Review

- Core alignment rows, sequence labels, numbering, consensus symbols, and common identity/similarity/functional color modes render in the expected visual family.
- Typshade is intentionally not pixel-identical to TeXshade. The package uses Typst-native tables, font metrics, color values, and recipe-oriented spacing, so visual parity is judged by biological/structural correspondence rather than exact glyph placement.
- Some TeXshade feature-row styles are still approximate in visual richness. The parity specimen exercises graph and feature track entry points, but the visual density does not yet match TeXshade's stacked feature-line examples.
- TeXshade's long single-sequence example uses negative starting positions and extensive UTR/translation/complement rows. Typshade covers the corresponding entry points, but exact TeX-style single-sequence line construction remains an approximation.
- Structure meme / Chimera command-file output remains intentionally omitted because it is an external side-effect workflow rather than document rendering.

## Verdict

The current Typshade output is suitable for Typst-native alignment figures and covers the TeXshade visual feature families at the image-generation level. However, this audit should not be treated as a pixel-perfect TeXshade clone approval. The remaining differences are in advanced feature-row richness, single-sequence edge-case layout, and TeX side-effect workflows that Typshade deliberately excludes or approximates.
