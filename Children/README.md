# SwiftAnvil Child Plan Index

This directory carries the phase-child workflow from the original planning repository into the current
SwiftAnvil organization memory.

## Current Source Of Truth

`swiftanvil-meta` owns organization planning. Older local planning repositories are historical references unless a
specific child plan says otherwise.

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
| 4.3 | AnvilReport Organization Health Report | Planned Next | swiftanvil-meta |
| 4.4 | Managed Worker Capability Discovery and Doctor | Planned | swiftanvil-anvil-runner |
| 4.5 | Worker Provisioning and Fleet Profiles | Complete | swiftanvil-anvil-runner |

## Phase 5 — Ecosystem & Distribution

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 5.1 | Community Templates | Complete | swiftanvil-anvil-template |
| 5.2 | Plugin System | Complete | swiftanvil-cli |
| 5.3 | Release & Distribution | Planned | swiftanvil-meta, swiftanvil-cli |

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
