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

Planned.

## Goal

Establish a repeatable, automated release pipeline for all SwiftAnvil packages and the CLI binary.
Every release must be reproducible, signed, and documented.

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

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `.github/workflows/release.yml` | Each package repo | Tag-triggered: test, build, tag, release |
| `.github/workflows/cli-release.yml` | swiftanvil-cli | Builds universal macOS binary, signs, notarizes |
| `scripts/bump-version.sh` | swiftanvil-meta | Bumps version across repos, updates changelog |
| Homebrew formula repo | New repo `swiftanvil-homebrew-tap` | Cask + formula for CLI |
| Docker image | swiftanvil-cli | `swiftanvil/cli:latest` on GitHub Container Registry |
| SPI manifest | Each package repo | `.spi.yml` for Swift Package Index |
| Release playbook | swiftanvil-meta | `Children/5.3/RELEASE_PLAYBOOK.md` |

## Versioning Strategy

- All packages use **Semantic Versioning** (SemVer).
- Version bumps are centralized via `scripts/bump-version.sh`:
  ```bash
  ./scripts/bump-version.sh --package swiftanvil-cli --type minor
  ```
- Changelogs follow [Keep a Changelog](https://keepachangelog.com/) format.
- Git tags are prefixed with package name: `swiftanvil-cli-1.2.0`.

## Release Workflow

```
1. Developer runs bump-version.sh
2. Script updates version in Package.swift, README, CHANGELOG
3. Developer opens PR → CI runs → merge
4. Tag is pushed: git tag swiftanvil-cli-1.2.0
5. GitHub Actions triggers:
   a. Run full test suite
   b. Build release artifacts
   c. Sign + notarize (macOS CLI only)
   d. Create GitHub Release with auto-generated notes
   e. Update Homebrew formula
   f. Push Docker image (CLI only)
```

## Success Criteria

- A release can be cut by a single maintainer in < 15 minutes.
- Every release has a signed macOS binary (CLI).
- Every release has a GitHub Release page with changelog.
- Homebrew users can `brew install swiftanvil/tap/swiftanvil` within 1 hour of tag push.
- Docker users can `docker pull ghcr.io/swiftanvil/cli:1.2.0`.
- Rollback to previous version is documented and testable.

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
| Signing certificate expires | Medium | Calendar reminder 30 days before expiry; CI fails loudly |
| Homebrew formula drift | Low | Automated formula update in release workflow |
| Docker image bloat | Low | Multi-stage build; only copy binary + runtime deps |
| Release notes are incomplete | Medium | Enforce changelog entry in PR template |
