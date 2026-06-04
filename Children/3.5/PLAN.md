# Child 3.5 Plan: Testing and Verification

## Status

Complete.

## Goal

Add the testing and verification layer that closes Phase 3.

## Scope

- Define how SwiftAnvil verifies generated projects.
- Add built-in verification where it belongs: command UX in `swiftanvil-cli`, with extraction to a dedicated
  package only after the verification domain grows beyond CLI ownership.
- Add snapshot testing setup for generated output where appropriate after the static verifier defines the
  generated-project contract.
- Add generated CI configuration validation.
- Decide whether a `swiftanvil-integration-tests` repository is still needed after the CLI verifier is proven in CI.

## Implementation Plan

1. Add a static generated-project verifier to `swiftanvil-cli`.
2. Expose it through an `ifoundation verify --path <project>` command.
3. Test required structure, test target presence, documentation registry presence, and generated CI workflow checks.
4. Keep integration-test repository creation deferred until a real cross-repository test matrix is needed.
5. Close Phase 3 only after PR review provenance and CI evidence are recorded.

## Non-Goals

- Do not start this child until Child 3.4 is resolved.
- Do not create integration infrastructure without a clear ownership model.
- Do not bypass review provenance because the work spans multiple repos.

## Success Criteria

- Generated project verification has tests and CI coverage.
- The roadmap can mark Phase 3 complete only after this child has review provenance.
- Any integration-test repository or package is explicitly listed in the registry and package status docs.

## Outcome

Completed on 2026-06-04. See `planning.child-3-5-result` and `planning.child-3-5-provenance`.
