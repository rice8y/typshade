#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: push.sh must be run inside a Git worktree." >&2
  exit 1
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "error: cannot push from a detached HEAD." >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "error: remote 'origin' is not configured." >&2
  exit 1
fi

if ! git diff --cached --quiet; then
  echo "error: the index already has staged changes." >&2
  echo "Please commit or unstage them before running push.sh." >&2
  exit 1
fi

commit_one() {
  local path="$1"
  local message="$2"

  if [[ ! -e "$path" ]]; then
    echo "skip: $path does not exist"
    return
  fi

  git add -- "$path"

  if git diff --cached --quiet -- "$path"; then
    echo "skip: $path has no staged changes"
    return
  fi

  git commit -m "$message" -- "$path"
}

commit_one "LICENSE" "chore(license): add project license"
commit_one "NOTICE.md" "chore(license): document project notices"
commit_one "README.md" "docs(readme): add project overview"
commit_one "docs/documentation.pdf" "docs(manual): add rendered documentation"
commit_one "docs/documentation.typ" "docs(manual): add Typshade documentation source"
commit_one "docs/readme-gallery.typ" "docs(readme): add README gallery source"
commit_one "docs/readme-overview.typ" "docs(readme): add overview image source"
commit_one "examples/basic.typ" "docs(examples): add basic usage example"
commit_one "examples/declarative.typ" "docs(examples): add declarative usage example"
commit_one "examples/functional.typ" "docs(examples): add functional shading example"
commit_one "examples/graphs.typ" "docs(examples): add graph track example"
commit_one "examples/logo.typ" "docs(examples): add logo example"
commit_one "examples/recipes.typ" "docs(examples): add recipe example"
commit_one "examples/regions.typ" "docs(examples): add region annotation example"
commit_one "examples/structure.typ" "docs(examples): add structure track example"
commit_one "examples/tcoffee.typ" "docs(examples): add T-Coffee example"
commit_one "examples/typst-native.typ" "docs(examples): add Typst-native API example"
commit_one "package/LICENSE" "chore(package): add package license"
commit_one "package/NOTICE.md" "chore(package): add package notices"
commit_one "package/README.md" "docs(package): add package README"
commit_one "package/images/readme-overview.png" "docs(readme): add alignment overview image"
commit_one "package/images/readme-preview-1.png" "docs(readme): add first preview image"
commit_one "package/images/readme-preview-2.png" "docs(readme): add second preview image"
commit_one "package/images/readme-preview-3.png" "docs(readme): add third preview image"
commit_one "package/internal/engine/commands.typ" "feat(engine): add command normalization"
commit_one "package/internal/engine/config.typ" "feat(engine): add renderer configuration"
commit_one "package/internal/engine/layout.typ" "feat(engine): add layout helpers"
commit_one "package/internal/interface/analysis.typ" "feat(interface): add analysis helpers"
commit_one "package/internal/interface/annotations.typ" "feat(interface): add annotation helpers"
commit_one "package/internal/interface/controls.typ" "feat(interface): add low-level controls"
commit_one "package/internal/interface/data.typ" "feat(interface): add data access helpers"
commit_one "package/internal/interface/inspect.typ" "feat(interface): add inspection helpers"
commit_one "package/internal/interface/presets.typ" "feat(interface): add presets and themes"
commit_one "package/internal/interface/recipes.typ" "feat(interface): add figure recipes"
commit_one "package/internal/interface/shade.typ" "feat(interface): add shade entry point"
commit_one "package/internal/interface/shortcuts.typ" "feat(interface): add shortcut helpers"
commit_one "package/internal/interface/tracks.typ" "feat(interface): add track helpers"
commit_one "package/internal/model/logo.typ" "feat(model): add logo calculations"
commit_one "package/internal/model/palette.typ" "feat(model): add color palettes"
commit_one "package/internal/model/parser.typ" "feat(model): add alignment parsers"
commit_one "package/internal/model/pdb.typ" "feat(model): add PDB selection helpers"
commit_one "package/internal/model/text-style.typ" "feat(model): add text style helpers"
commit_one "package/internal/render/alignment.typ" "feat(render): add alignment renderer"
commit_one "package/internal/render/features.typ" "feat(render): add feature renderer"
commit_one "package/internal/render/graphs.typ" "feat(render): add graph renderer"
commit_one "package/internal/render/logos.typ" "feat(render): add logo renderer"
commit_one "package/justfile" "chore(package): add package task runner"
commit_one "package/lib.typ" "feat(package): add public package exports"
commit_one "package/typst.toml" "chore(package): add Typst package metadata"
commit_one "tests/README.md" "docs(tests): document strict test suite"
commit_one "tests/data-and-analysis.typ" "test(analysis): add data and analysis coverage"
commit_one "tests/fixtures/reference/AQP1.phd" "test(fixtures): add PHD reference fixture"
commit_one "tests/fixtures/reference/AQP1.top" "test(fixtures): add topology reference fixture"
commit_one "tests/fixtures/reference/AQP2spec.ALN" "test(fixtures): add ALN reference fixture"
commit_one "tests/fixtures/reference/AQPDNA.MSF" "test(fixtures): add DNA MSF reference fixture"
commit_one "tests/fixtures/reference/AQP_HMM.ext" "test(fixtures): add extended HMMTOP reference fixture"
commit_one "tests/fixtures/reference/AQP_HMM.sgl" "test(fixtures): add single-line HMMTOP reference fixture"
commit_one "tests/fixtures/reference/AQP_TC.asc" "test(fixtures): add T-Coffee reference fixture"
commit_one "tests/fixtures/reference/AQPpro.MSF" "test(fixtures): add protein MSF reference fixture"
commit_one "tests/fixtures/reference/bars.txt" "test(fixtures): add graph data reference fixture"
commit_one "tests/fixtures/reference/ciliate.cod" "test(fixtures): add ciliate genetic code fixture"
commit_one "tests/fixtures/reference/frustr.txt" "test(fixtures): add frustration data reference fixture"
commit_one "tests/fixtures/reference/standard.cod" "test(fixtures): add standard genetic code fixture"
commit_one "tests/fixtures/tiny-dna.fasta" "test(fixtures): add tiny DNA FASTA fixture"
commit_one "tests/fixtures/tiny-protein.fasta" "test(fixtures): add tiny protein FASTA fixture"
commit_one "tests/fixtures/tiny.aln" "test(fixtures): add tiny ALN fixture"
commit_one "tests/fixtures/tiny.msf" "test(fixtures): add tiny MSF fixture"
commit_one "tests/fixtures/tiny.pdb" "test(fixtures): add tiny PDB fixture"
commit_one "tests/public-api.typ" "test(api): add public API coverage"
commit_one "tests/read-input-smoke.typ" "test(input): add read input smoke coverage"
commit_one "tests/rendering-coverage.typ" "test(render): add rendering coverage"
commit_one "tests/run.sh" "test(runner): add strict test runner"
commit_one "tests/texshade_full_command_coverage.py" "test(docs): add TeXshade command coverage audit"
commit_one "push.sh" "chore(release): add per-file push helper"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: uncommitted changes remain after committing known files:" >&2
  git status --short >&2
  exit 1
fi

if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
  git push
else
  git push -u origin "$branch"
fi
