# SwiftAnvil Child Plan Index

This directory carries the phase-child workflow from the original planning repository into the current
SwiftAnvil organization memory.

## Current Source Of Truth

`swiftanvil-meta` owns organization planning. Older local planning repositories are historical references unless a
specific child plan says otherwise.

## Active Phase

Phase 4 is now the organization intelligence and managed worker phase. It captures the work that was previously
being discussed independently: org health reporting, AnvilRunner, worker capability discovery, worker doctor checks,
and eventual host provisioning.

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 4.1 | Governance and Enforcement Baseline | Complete | swiftanvil-meta, swiftanvil-enforcement, .github |
| 4.2 | AnvilRunner 0.1 Release | Complete | swiftanvil-anvil-runner |
| 4.3 | AnvilReport Organization Health Report | Planned Next | swiftanvil-meta |
| 4.4 | Managed Worker Capability Discovery and Doctor | Planned | swiftanvil-anvil-runner |
| 4.5 | Worker Provisioning and Fleet Profiles | Planned | swiftanvil-anvil-runner |

## Rules

- Every new child gets a plan before implementation.
- Plan review and implementation review must be captured through the independent review workflow when available.
- Completed children update `roadmap.org`, package status, and review provenance before merge.
- Historical work can be backfilled as completed children only when the merged PRs, tags, and CI outcomes are known.
