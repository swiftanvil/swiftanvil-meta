# SwiftAnvil Child Plan Index

This directory carries the phase-child workflow from the original planning repository into the current
SwiftAnvil organization memory.

## Current Source Of Truth

`swiftanvil-meta` owns organization planning. Older local planning repositories are historical references unless a
specific child plan says otherwise.

## Current Entry Point

Before starting roadmap implementation, apply the health gates from `meta.session-start`:

- `packages.registry` currently has PMS blockers below 80.
- Start with the `AnvilMacros` improvement sprint from `improvement.dashboard`.
- After PMS is recalculated and no lower-priority blocker remains, finish `planning.child-9-5` workflow artifacts.
- Only start `planning.child-9-6` after Child 9.5 is workflow-complete.

## Phase 1 — Foundation

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 1.1 | Research Swift OSS Best Practices | Complete | N/A (research) |
| 1.2 | A11yIdentifiers | Complete | swiftanvil-anvil-a11y |
| 1.3 | BenchmarkKit | Complete | swiftanvil-anvil-bench |
| 1.4 | AppStrings | Complete | swiftanvil-anvil-strings |
| 1.5 | GitHub Organization Setup | Complete | github.com/swiftanvil |

## Phase 2 — Core Packages

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 2.1 | AnvilNetwork Package | Complete | swiftanvil-anvil-network |
| 2.2 | FeatureFlags Package | Complete | swiftanvil-anvil-flags |
| 2.3 | Developer Menu Package | Complete | swiftanvil-anvil-devmenu |

## Phase 3 — CLI & Integration

The historical roadmap overstated Phase 3 completion. The missing documentation package was recovered as
`swiftanvil-anvil-docs`, and generated-project verification now exists in `swiftanvil-cli`.

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 3.1 | Wizard System | Complete | swiftanvil-anvil-wizard |
| 3.2 | Template Engine | Complete | swiftanvil-anvil-template |
| 3.3 | Project Generator | Complete | swiftanvil-anvil-project |
| 3.4 | Documentation Generator Recovery and Promotion | Complete | swiftanvil-anvil-docs |
| 3.5 | Testing and Verification | Complete | swiftanvil-cli |

## Phase 4

Phase 4 is now the organization intelligence and managed worker phase. It captures the work that was previously
being discussed independently: org health reporting, AnvilRunner, worker capability discovery, worker doctor checks,
and eventual host provisioning.

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 4.1 | Governance and Enforcement Baseline | Complete | swiftanvil-meta, swiftanvil-enforcement, .github |
| 4.2 | AnvilRunner 0.1 Release | Complete | swiftanvil-anvil-runner |
| 4.3 | AnvilReport Organization Health Report | Complete | swiftanvil-meta |
| 4.4 | Managed Worker Capability Discovery and Doctor | Complete | swiftanvil-anvil-runner |
| 4.5 | Worker Provisioning and Fleet Profiles | Complete | swiftanvil-anvil-runner |

## Phase 5 — Ecosystem & Distribution

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 5.1 | Community Templates | Complete | swiftanvil-anvil-template |
| 5.2 | Plugin System | Complete | swiftanvil-cli |
| 5.3 | Release & Distribution | Complete | swiftanvil-meta, swiftanvil-cli |

## Phase 6 — Integration & Validation

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 6.1 | CLI Integration — Templates & Plugins | Complete | swiftanvil-cli |
| 6.2 | Documentation Generator CLI Integration | Complete | swiftanvil-cli, swiftanvil-anvil-docs |
| 6.3 | Example Projects & Ecosystem Validation | Complete | swiftanvil-example-library, swiftanvil-example-cli, swiftanvil-example-swiftui |

## Phase 7 — Quality & Completeness

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 7.1 | Naming Cleanup & Package Consolidation | Complete | Multiple |
| 7.2 | CI for All Repos | Complete | Multiple |
| 7.3 | DocC + README Backfill | Complete | Multiple |
| 7.4 | Test Coverage Sprint | Complete | Multiple |
| 7.5 | AnvilCore Shared Package | Complete | swiftanvil-anvil-core |
| 7.6 | Swift Macros Package | Complete | swiftanvil-anvil-macros |
| 7.7 | Golden Path Example App | Complete | swiftanvil-example-golden-path |

## Phase 8 — macOS App Toolkit

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 8.1 | macOS App Template for `swiftanvil create` | Complete | swiftanvil-cli |
| 8.2 | AnvilSettings (Type-Safe UserDefaults) | Complete | swiftanvil-anvil-settings |
| 8.3 | AnvilMenuBar (macOS Menu Bar Extras) | Complete | swiftanvil-anvil-menubar |
| 8.4 | AnvilWindow (Window Management) | Complete | swiftanvil-anvil-window |
| 8.5 | AnvilCore Integration into Existing Packages | Complete | Multiple |

## Phase 9 — iStudio Boundary & Tooling Expansion

Phase 9 is complete. All 6 children done.

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 9.1 | Real `@Benchmark` Macro | Complete | swiftanvil-anvil-macros |
| 9.2 | Swift 6 Language Mode Consistency | Complete | Multiple |
| 9.3 | GoldenPath Fix + AnvilMacros/AnvilCore Integration | Complete | swiftanvil-example-golden-path |
| 9.4 | Package Maturity Score (PMS) Automation | Complete | swiftanvil-meta |
| 9.5 | Boundary Document & Enforcement | Complete | swiftanvil-meta |
| 9.6 | Migrate iStudio Validators to SwiftAnvil | Complete | swiftanvil-cli |

## Phase 11 — Engineering Standards Enforcement

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 11.1 | Canonical Style Configuration | Complete | swiftanvil-enforcement, swiftanvil-meta, swiftanvil-cli |
| 11.2 | SOLID & Design Principle Lint Rules | Complete | swiftanvil-cli |
| 11.3 | Pre-commit Hook + CI Gate Integration | Planned | swiftanvil-enforcement |
| 11.4 | SwiftAnvil Repo Remediation Sprint | Planned | Multiple |
| 11.5 | Consumer Project Template Integration | Planned | swiftanvil-cli, swiftanvil-anvil-template |

## Review Artifact Conventions by Phase

The review artifacts evolved across phases. This is historical reality, not inconsistency:

| Phase | Convention | Files |
|-------|-----------|-------|
| **Phase 1** (1.1–1.5) | Single combined review | `REVIEW.md` |
| **Phase 2** (2.1–2.3) | Plan review + implementation review split | `REVIEW-PLAN.md` + `REVIEW-IMPL.md` |
| **Phase 3+** (3.1+) | Provenance-focused with cross-host enforcement | `REVIEW-PROVENANCE.md` (+ plan/impl variants where applicable) |

When reading historical children, expect the convention that was current at the time. Do not retroactively rename files.

## Rules

- Every new child gets a plan before implementation.
- Plan review and implementation review must be captured through the independent review workflow when available.
- Completed children update `roadmap.org`, package status, and review provenance before merge.
- Historical work can be backfilled as completed children only when the merged PRs, tags, and CI outcomes are known.
