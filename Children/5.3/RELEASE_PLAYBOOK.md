---
priority: HIGH
type: REFERENCE
audience: BUILDER
phase: 5
child: 5.3
last_updated: 2026-06-04
---

# SwiftAnvil Release Playbook

## Pre-Release Checklist

- [ ] All tests pass on `main` (`swift build && swift test`)
- [ ] CHANGELOG.md has an "Unreleased" section with all changes
- [ ] Version bump script has been run and changes reviewed
- [ ] Platform policy compliance verified (no `#available`, no `@available`)
- [ ] No compiler warnings

## Release Steps

### 1. Bump Version

```bash
cd /path/to/swiftanvil-meta
./scripts/bump-version.sh --package swiftanvil-cli --type minor
```

Review the diff, then:
```bash
git add -A
git commit -m "chore: bump version to X.Y.Z"
git tag swiftanvil-cli-X.Y.Z
git push origin main --tags
```

### 2. Wait for CI

The `release.yml` workflow will:
1. Run tests
2. Build universal binary
3. Sign and notarize
4. Create GitHub Release
5. Update Homebrew formula
6. Push Docker image

Monitor at: `https://github.com/swiftanvil/swiftanvil-cli/actions`

### 3. Verify Release

```bash
# Verify GitHub Release exists
curl -s https://api.github.com/repos/swiftanvil/swiftanvil-cli/releases/latest | grep tag_name

# Verify Homebrew formula
brew update
brew info swiftanvil/tap/swiftanvil

# Verify Docker image
docker pull ghcr.io/swiftanvil/cli:X.Y.Z
docker run --rm ghcr.io/swiftanvil/cli:X.Y.Z --version
```

## Rollback Procedure

| Artifact | Action |
|----------|--------|
| Git tag | **Never delete.** Push a new patch release reverting the change. |
| GitHub Release | Edit to mark as pre-release, add retraction notice, publish new release. |
| Homebrew formula | Revert the formula commit in `swiftanvil-homebrew-tap`. |
| Docker image | Retag `latest` to previous digest. Do not delete bad tag. |

## Post-Release

- [ ] Update `packages.registry` with new version
- [ ] Announce in GitHub Discussions (if significant release)
- [ ] Update dependent packages' `Package.swift` if needed

## Emergency Contacts

- Primary: @vishalsingh (single maintainer)
- Escalation: File issue in `swiftanvil-meta`
