#!/usr/bin/env bash
# Crea una nuova release: tagga e pusha.
# Uso: ./release.sh 1.5.5

set -euo pipefail

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "Uso: $0 X.Y.Z" >&2
  exit 1
fi

git tag "v${VERSION}"
git push --tags

echo "✓ Tag v${VERSION} pushato — workflow release avviato."
