# Child 4.1 Plan: Governance and Enforcement Baseline

## Status

Complete. This child backfills the governance work completed on 2026-06-04.

## Goal

Make SwiftAnvil's organization workflow enforceable without relying on informal agent memory.

## Scope

- Establish `swiftanvil-meta` as organization memory and policy source of truth.
- Establish `swiftanvil-enforcement` as reusable enforcement scripts and workflows.
- Add document registry validation.
- Add PR provenance validation.
- Add independent review runner support with agent discovery and diagnostics.
- Record the single-maintainer branch protection exception.

## Non-Goals

- Do not place package source code in `swiftanvil-meta`.
- Do not hardcode one reviewer CLI as the only valid path.
- Do not require GitHub-native approving reviews while the organization has only one eligible maintainer.

## Deliverables

| Deliverable | Status |
|-------------|--------|
| Document registry policy | Complete |
| Review provenance enforcement | Complete |
| Agent diagnostics for redirected home directory auth failures | Complete |
| Local enforcement runner | Complete |
| Single-maintainer process exception | Complete |

## Success Criteria

- Enforcement can run locally without GitHub Actions minutes.
- PRs can be rejected for missing review provenance.
- Agents have a documented remediation path for auth failures caused by redirected `HOME`.
- The singleton maintainer exception is explicit and reversible.

## Review Provenance

See the review artifacts under `swiftanvil-meta` reviews and the merged pull requests in `swiftanvil-meta`,
`swiftanvil-enforcement`, and `.github`.
