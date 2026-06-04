#!/bin/bash
set -euo pipefail

# test-homebrew-formula.sh — Validate a Homebrew formula
# Usage: ./test-homebrew-formula.sh <formula-file>

FORMULA="${1:-}"

if [[ -z "$FORMULA" || ! -f "$FORMULA" ]]; then
    echo "Usage: $0 <formula-file>"
    exit 1
fi

echo "Auditing formula..."
brew audit --strict "$FORMULA"

echo "Testing formula installation..."
brew install --build-from-source "$FORMULA"

echo "Testing formula..."
brew test "$FORMULA"

echo "✓ Homebrew formula validated"
