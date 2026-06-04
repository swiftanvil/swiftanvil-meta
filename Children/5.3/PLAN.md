---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 5
child: 5.3
last_updated: 2026-06-04
---

# Child 5.3 Plan: Release & Distribution

## Status

Planned. Revised per cross-host review (NEEDS_REVISION → addressed).

## Goal

Establish a repeatable, automated release pipeline for all SwiftAnvil packages and the CLI binary.
Every release must be reproducible, signed, and documented.

## Prerequisites

All packages are already platform-compliant (iOS 18+ / macOS 15+). The platform upgrade sprint
was completed before Phase 5 began. See `packages.registry` for current status.

## Scope

- Automated versioning strategy (SemVer + changelog automation).
- GitHub Actions workflows for:
  - Tag-triggered release builds
  - Binary artifact signing and notarization (macOS)
  - Homebrew formula updates
  - GitHub Release creation with release notes
- Swift Package Index (SPI) manifest for discoverability.
- Docker image for Linux CI/CD usage.
- Release checklist and rollback procedure.

## Non-Goals

- Do not support non-macOS/Linux platforms for binary distribution.
- Do not build a custom update mechanism (use Homebrew / SPM).
- Do not automate major version bumps (human decision).
- Do not support self-hosted release runners (use GitHub-hosted macOS runners).

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `.github/workflows/release.yml` | Each package repo | Tag-triggered: test, build, tag, release |
| `.github/workflows/cli-release.yml` | swiftanvil-cli | Builds universal macOS binary, signs, notarizes |
| `.github/workflows/release-dry-run.yml` | swiftanvil-cli | PR-triggered: builds but does not sign/push |
| `scripts/bump-version.sh` | swiftanvil-meta | Bumps version per repo, updates CHANGELOG |
| `scripts/test-homebrew-formula.sh` | swiftanvil-meta | Validates formula in CI |
| `scripts/test-docker-image.sh` | swiftanvil-meta | Runs image and checks `--version` |
| Homebrew formula repo | New repo `swiftanvil-homebrew-tap` | Formula only (CLI tool, not cask) |
| `Dockerfile` | swiftanvil-cli | Multi-stage build, swift:6.0 base |
| SPI manifest | Each package repo | `.spi.yml` for Swift Package Index |
| Release playbook | swiftanvil-meta | `Children/5.3/RELEASE_PLAYBOOK.md` |
| Updated `WORKFLOW.md` | swiftanvil-meta | Replaces manual release section |

## Versioning Strategy

- All packages use **Semantic Versioning** (SemVer).
- Version bumps are per-repo via `scripts/bump-version.sh`:
  ```bash
  ./scripts/bump-version.sh --package swiftanvil-cli --type minor
  ```
- The script:
  1. Reads `Package.swift` to find current version
  2. Updates version string in `Package.swift`, `README.md`, source code
  3. Moves "Unreleased" section in `CHANGELOG.md` to new version heading
  4. Creates a commit with message `chore: bump version to X.Y.Z`
  5. Does NOT push — developer reviews and pushes manually
- Changelogs follow [Keep a Changelog](https://keepachangelog.com/) format.
- Git tags are prefixed with package name: `swiftanvil-cli-1.2.0`.

## Signing and Notarization (macOS CLI)

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `APPLE_DEVELOPER_ID_CERTIFICATE` | Base64-encoded `.p12` certificate |
| `APPLE_DEVELOPER_ID_PASSWORD` | Password for the `.p12` file |
| `APPLE_TEAM_ID` | Apple Developer Team ID |
| `APPLE_ID` | Apple ID for notarytool |
| `APPLE_ID_PASSWORD` | App-specific password for notarytool |
| `HOMEBREW_TAP_TOKEN` | GitHub PAT with `contents:write` on tap repo |

### Workflow Steps

```yaml
# In .github/workflows/cli-release.yml
- name: Import signing certificate
  run: |
    echo "$APPLE_DEVELOPER_ID_CERTIFICATE" | base64 -d > certificate.p12
    security create-keychain -p "" build.keychain
    security import certificate.p12 -k build.keychain -P "$APPLE_DEVELOPER_ID_PASSWORD" -T /usr/bin/codesign
    security set-keychain-settings -lut 1200 build.keychain
    security unlock-keychain -p "" build.keychain
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "" build.keychain

- name: Sign binary
  run: codesign --sign "Developer ID Application" --force --options runtime --timestamp swiftanvil

- name: Notarize
  run: |
    ditto -c -k --keepParent swiftanvil swiftanvil.zip
    xcrun notarytool submit swiftanvil.zip \
      --apple-id "$APPLE_ID" --password "$APPLE_ID_PASSWORD" --team-id "$APPLE_TEAM_ID" \
      --wait
    xcrun stapler staple swiftanvil

- name: Verify signing
  run: codesign -dv --verbose=4 swiftanvil

- name: Cleanup keychain
  run: security delete-keychain build.keychain
```

### Certificate Expiry Detection

A CI step runs on every build:
```bash
security find-identity -v -p codesigning | grep "Developer ID Application" || exit 1
```
If the identity is missing or expiring within 30 days, the build fails with a clear error.

## Homebrew Formula

- **Type:** Formula only (CLI tool, not cask).
- **Repo:** `swiftanvil/swiftanvil-homebrew-tap`
- **Authentication:** `HOMEBREW_TAP_TOKEN` (GitHub PAT with `contents:write`).
- **Formula template** stored in `swiftanvil-meta/scripts/homebrew-formula-template.rb`.
- **Update mechanism:** Release workflow generates the formula from the template, commits to tap repo.
- **Validation:** `scripts/test-homebrew-formula.sh` runs `brew install --build-from-source` in CI.

### Formula Template

```ruby
class Swiftanvil < Formula
  desc "Swift project scaffolding with architectural enforcement"
  homepage "https://github.com/swiftanvil/swiftanvil-cli"
  url "https://github.com/swiftanvil/swiftanvil-cli/archive/refs/tags/{{TAG}}.tar.gz"
  sha256 "{{SHA256}}"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swiftanvil"
  end

  test do
    system "#{bin}/swiftanvil", "--version"
  end
end
```

## Docker Image

### Dockerfile

```dockerfile
# Build stage
FROM swift:6.0-jammy AS builder
WORKDIR /build
COPY . .
RUN swift build -c release --static-swift-stdlib

# Runtime stage
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/.build/release/swiftanvil /usr/local/bin/swiftanvil
ENTRYPOINT ["swiftanvil"]
```

### Platforms

- `linux/amd64`
- `linux/arm64`

### Validation

`scripts/test-docker-image.sh`:
```bash
#!/bin/bash
set -e
docker run --rm ghcr.io/swiftanvil/cli:$TAG --version
```

## Release Workflow

```
1. Developer runs bump-version.sh in the target repo
2. Script updates version in Package.swift, README, CHANGELOG
3. Developer reviews changes, commits, pushes
4. Tag is pushed: git tag swiftanvil-cli-1.2.0
5. GitHub Actions triggers:
   a. Run full test suite
   b. Build release artifacts
   c. Sign + notarize (macOS CLI only)
   d. Create GitHub Release with auto-generated notes
   e. Update Homebrew formula
   f. Push Docker image (CLI only)
   g. Verify: run codesign -dv, docker run --version, brew test
```

## Rollback Procedure

| Artifact | Rollback Action |
|----------|----------------|
| Git tag | **Never delete.** Push a new patch release reverting the change. |
| GitHub Release | Edit to mark as pre-release, add retraction notice, publish new release. |
| Homebrew formula | Revert the formula commit in tap repo. |
| Docker image | Retag `latest` to previous digest. Do not delete bad tag. |
| Swift Package Index | SPI updates from tags automatically — rollback is tag-dependent. |

## Success Criteria

- [ ] A release can be cut by a single maintainer in < 15 minutes.
- [ ] Every release has a signed macOS binary (CLI) with stapled notarization.
- [ ] Every release has a GitHub Release page with changelog.
- [ ] Homebrew users can `brew install swiftanvil/tap/swiftanvil` within 1 hour of tag push.
- [ ] Docker users can `docker pull ghcr.io/swiftanvil/cli:1.2.0`.
- [ ] Rollback procedure is documented with exact commands per artifact type.
- [ ] Release dry-run workflow passes on PRs (builds without signing).
- [ ] `WORKFLOW.md` updated to reflect automated pipeline.

## Dependencies

- `planning.child-4.1` (CI/CD Pipeline) — existing workflows extended.
- `planning.child-4.5` (Worker Provisioning) — release workers must be provisioned.
- Apple Developer ID for macOS signing.
- GitHub Container Registry access.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | Workflow security, signing setup, rollback procedure |
| Impl | Cross-host agent | End-to-end release test on a pre-release tag |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Signing certificate expires | Medium | CI checks identity on every build; fails if expiring within 30 days |
| Homebrew formula drift | Low | Automated formula update in release workflow; validation script |
| Docker image bloat | Low | Multi-stage build; only copy binary + runtime deps |
| Release notes are incomplete | Medium | Enforce changelog entry in PR template |
| Notarization failure | Medium | `--wait` flag ensures completion; stapling verified in CI |
