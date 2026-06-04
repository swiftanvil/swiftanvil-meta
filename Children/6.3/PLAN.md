---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 6
child: 6.3
last_updated: 2026-06-04
---

# Child 6.3 Plan: Example Projects & Ecosystem Validation

## Status

Planned.

## Goal

Validate the entire SwiftAnvil toolchain by building 3 real example projects end-to-end.
Each example exercises templates, plugins, CLI commands, and docs generation in a realistic scenario.

## Scope

- Create 3 example project repos under `swiftanvil`:
  1. **SwiftUI iOS App** — uses `swiftui-app` template, adds AnvilNetwork + AnvilFlags.
  2. **CLI Tool** — uses `cli-tool` template, adds AnvilDocs for self-documenting help.
  3. **SPM Library** — uses `library` template, adds DocC + BenchmarkKit tests.
- Each example must:
  - Be generated from a template via `swiftanvil template install`.
  - Build successfully with `swift build`.
  - Pass tests with `swift test`.
  - Generate docs with `swiftanvil docs generate`.
  - Have a README with setup instructions.
- Add `swiftanvil verify` support for example projects (validate generated structure).
- Update `CONTRIBUTING.md` with example project conventions.

## Non-Goals

- Do not maintain examples as long-term product repos (they are living documentation).
- Do not add features to core packages just for examples.
- Do not publish examples to App Store or distribute binaries.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `swiftanvil-example-swiftui` | New repo | iOS app example |
| `swiftanvil-example-cli` | New repo | CLI tool example |
| `swiftanvil-example-library` | New repo | SPM library example |
| `ExampleProjectVerifier` | swiftanvil-cli | Validates example structure |
| `EXAMPLES.md` | swiftanvil-meta | Guide for creating new examples |
| Updated `CONTRIBUTING.md` | swiftanvil-meta | Example conventions |

## Dependencies

- `planning.child-6.1` (CLI Integration) — `template install`, `plugin list` commands.
- `planning.child-6.2` (Docs Integration) — `docs generate` for example READMEs.
- `planning.child-5.1` (Community Templates) — template registry and install logic.

## Success Criteria

- [ ] All 3 examples build with `swift build` on macOS 15+.
- [ ] All 3 examples pass `swift test`.
- [ ] All 3 examples generate docs with `swiftanvil docs generate`.
- [ ] `swiftanvil verify --example` validates example project structure.
- [ ] `EXAMPLES.md` enables a contributor to add a new example in < 30 minutes.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | Example scope, validation criteria, repo structure |
| Impl | Cross-host agent | End-to-end example builds, CI integration |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Examples drift out of sync with templates | High | CI cron job to regenerate and build examples weekly |
| Template changes break examples | Medium | Run example builds in template PR CI |
| Examples become maintenance burden | Medium | Keep minimal; delete if unmaintained |
