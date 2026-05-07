#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

commit_if_changed() {
  local message="$1"
  shift

  git add -- "$@"
  if git diff --cached --quiet -- "$@"; then
    echo "skip: $message"
    return
  fi

  git commit -m "$message" -- "$@"
}

typst compile --root . docs/readme-overview.typ package/images/readme-overview.png
typst compile --root . docs/readme-gallery.typ 'package/images/readme-preview-{p}.png'
typst compile --root . docs/documentation.typ docs/documentation.pdf
bash tests/run.sh

commit_if_changed "fix: apply command helpers during rendering (fixes #1)" \
  package/internal/engine/commands.typ \
  package/internal/engine/config.typ \
  package/internal/interface/presets.typ \
  package/internal/interface/recipes.typ \
  package/internal/interface/shade.typ \
  package/internal/render/alignment.typ \
  package/internal/render/features.typ \
  package/internal/render/graphs.typ

commit_if_changed "test: add image-level feature coverage" \
  tests/README.md \
  tests/public-api.typ \
  tests/public_api_documentation_examples.py \
  tests/run.sh \
  tests/alignment-position-visual.typ \
  tests/auto-page-visual.typ \
  tests/full-feature-visual.typ \
  tests/texshade-visual-parity.typ \
  tests/texshade-visual-parity-report.md \
  tests/texshade_visual_parity.sh

commit_if_changed "docs: clarify public api result examples" \
  docs/documentation.pdf \
  docs/documentation.typ

commit_if_changed "docs: refresh readme previews" \
  README.md \
  docs/readme-gallery.typ \
  docs/readme-overview.typ \
  package/README.md \
  package/images/readme-overview.png \
  package/images/readme-preview-1.png \
  package/images/readme-preview-2.png \
  package/images/readme-preview-3.png

commit_if_changed "chore: include readme assets in package archive" \
  package/typst.toml

commit_if_changed "chore: add push helper" \
  push.sh

if [[ -n "$(git status --porcelain)" ]]; then
  git status --short
  echo "error: uncommitted changes remain; refusing to push." >&2
  exit 1
fi

git push origin "$(git branch --show-current)"
