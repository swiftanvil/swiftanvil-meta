# Child 3.5 Plan: Testing and Verification

## Status

Planned.

## Goal

Add the testing and verification layer that closes Phase 3.

## Scope

- Define how SwiftAnvil verifies generated projects.
- Add built-in test runner integration where it belongs: CLI, project generator, or a dedicated verification package.
- Add snapshot testing setup for generated output where appropriate.
- Add generated CI configuration validation.
- Decide whether a `swiftanvil-integration-tests` repository is still needed.

## Non-Goals

- Do not start this child until Child 3.4 is resolved.
- Do not create integration infrastructure without a clear ownership model.
- Do not bypass review provenance because the work spans multiple repos.

## Success Criteria

- Generated project verification has tests and CI coverage.
- The roadmap can mark Phase 3 complete only after this child has review provenance.
- Any integration-test repository or package is explicitly listed in the registry and package status docs.
