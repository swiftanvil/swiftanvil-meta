#!/bin/bash
set -euo pipefail

# bump-version.sh — Bump version in a SwiftAnvil package repo
# Usage: ./bump-version.sh --package <repo-name> --type <patch|minor|major>
#
# This script:
# 1. Reads the current version from Package.swift
# 2. Bumps according to SemVer rules
# 3. Updates version in Package.swift, README.md, and source files
# 4. Moves "Unreleased" section in CHANGELOG.md to new version
# 5. Creates a commit (does NOT push — review before pushing)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE=""
BUMP_TYPE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --package)
            PACKAGE="$2"
            shift 2
            ;;
        --type)
            BUMP_TYPE="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 --package <repo-name> --type <patch|minor|major>"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$PACKAGE" || -z "$BUMP_TYPE" ]]; then
    echo "Error: --package and --type are required"
    exit 1
fi

if [[ "$BUMP_TYPE" != "patch" && "$BUMP_TYPE" != "minor" && "$BUMP_TYPE" != "major" ]]; then
    echo "Error: --type must be patch, minor, or major"
    exit 1
fi

# Find the repo
REPO_DIR=""
for dir in "$SCRIPT_DIR/../../$PACKAGE" "$SCRIPT_DIR/../$PACKAGE" "$SCRIPT_DIR/../../../$PACKAGE"; do
    if [[ -d "$dir" && -f "$dir/Package.swift" ]]; then
        REPO_DIR="$dir"
        break
    fi
done

if [[ -z "$REPO_DIR" ]]; then
    # Try swiftanvil naming convention
    for dir in "$SCRIPT_DIR/../../swiftanvil-$PACKAGE" "$SCRIPT_DIR/../swiftanvil-$PACKAGE"; do
        if [[ -d "$dir" && -f "$dir/Package.swift" ]]; then
            REPO_DIR="$dir"
            break
        fi
    done
fi

if [[ -z "$REPO_DIR" ]]; then
    echo "Error: Could not find package '$PACKAGE' with Package.swift"
    echo "Searched in sibling directories of swiftanvil-meta"
    exit 1
fi

cd "$REPO_DIR"

# Extract current version from Package.swift
CURRENT_VERSION=$(grep -oE '[0-9]+\.[0-9]+\.[0-9]+' Package.swift | head -1)
if [[ -z "$CURRENT_VERSION" ]]; then
    echo "Error: Could not find version in Package.swift"
    exit 1
fi

echo "Current version: $CURRENT_VERSION"

# Parse version components
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

# Bump version
case "$BUMP_TYPE" in
    patch)
        PATCH=$((PATCH + 1))
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# Update Package.swift
sed -i '' "s/$CURRENT_VERSION/$NEW_VERSION/g" Package.swift

# Update README.md if it exists
if [[ -f README.md ]]; then
    sed -i '' "s/$CURRENT_VERSION/$NEW_VERSION/g" README.md
fi

# Update source files with version strings
for file in Sources/**/*.swift; do
    if [[ -f "$file" ]]; then
        # Only update lines that look like version declarations
        if grep -q "version.*$CURRENT_VERSION" "$file" 2>/dev/null; then
            sed -i '' "s/$CURRENT_VERSION/$NEW_VERSION/g" "$file"
            echo "Updated: $file"
        fi
    fi
done

# Update CHANGELOG.md
if [[ -f CHANGELOG.md ]]; then
    TODAY=$(date +%Y-%m-%d)
    # Replace "## [Unreleased]" with new version section
    sed -i '' "s/## \[Unreleased\]/## [$NEW_VERSION] - $TODAY\n\n## [Unreleased]/" CHANGELOG.md
    echo "Updated CHANGELOG.md"
else
    echo "Warning: CHANGELOG.md not found"
fi

# Show diff
echo ""
echo "Changes:"
git diff --stat

echo ""
echo "To complete the release:"
echo "  1. Review the changes above"
echo "  2. git add -A && git commit -m 'chore: bump version to $NEW_VERSION'"
echo "  3. git tag ${PACKAGE}-${NEW_VERSION}"
echo "  4. git push origin main --tags"
