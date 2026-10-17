#!/usr/bin/env bash
# Crea una nuova release: bumpa VERSION, committa, tagga e pusha.
# Uso: ./release.sh 1.5.4

set -euo pipefail

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "Uso: $0 X.Y.Z" >&2
  exit 1
fi

SCRIPT="bin/mac-health"
CURRENT=$(grep 'VERSION="' "$SCRIPT" | head -1 | grep -o '[0-9][0-9.]*')

echo "Bump versione: $CURRENT → $VERSION"
sed -i '' "s/VERSION=\"${CURRENT}\"/VERSION=\"${VERSION}\"/" "$SCRIPT"

git add "$SCRIPT"
git commit -m "chore(release): v${VERSION}"
git tag "v${VERSION}"
git push && git push --tags

echo "✓ Tag v${VERSION} pushato — workflow release avviato."
