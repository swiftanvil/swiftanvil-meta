#!/bin/bash
set -euo pipefail

# test-docker-image.sh — Validate a Docker image build and run
# Usage: ./test-docker-image.sh <tag>

TAG="${1:-latest}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/swiftanvil-cli"

if [[ ! -d "$REPO_DIR" ]]; then
    echo "Error: swiftanvil-cli repo not found at $REPO_DIR"
    exit 1
fi

cd "$REPO_DIR"

echo "Building Docker image..."
docker build -t "ghcr.io/swiftanvil/cli:$TAG" .

echo "Testing image..."
docker run --rm "ghcr.io/swiftanvil/cli:$TAG" --version

echo "✓ Docker image validated"
