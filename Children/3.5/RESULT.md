# Child 3.5 Result: Testing and Verification

## Outcome

Completed on 2026-06-04.

## Decision

Generated-project verification starts in `swiftanvil-cli`.

The CLI owns the developer-facing command and the first static verification contract. A separate verification package
is deferred until multiple repositories need to share verifier APIs. A separate integration-test repository is also
deferred until SwiftAnvil has a real cross-repository test matrix.

## Deliverable

| Item | Value |
|------|-------|
| Repo | swiftanvil-cli |
| PR | https://github.com/swiftanvil/swiftanvil-cli/pull/1 |
| Main commit | `b5ff712` |
| Command | `ifoundation verify --path <project>` |
| Tests | 13 Swift Testing tests |
| CI | Document Registry Policy passed |
| Enforcement | Local document registry and review artifact validation passed |

## What It Does

- Verifies required generated project files and directories.
- Verifies that the package manifest declares a test target.
- Verifies that generated CI uses the required checkout action and runs `swift build` and `swift test`.
- Verifies that the documentation registry exists and includes document sources.
- Reports structured errors and warnings through a testable verifier model.

## Review-Driven Fix

The sibling-host review recommended centralizing required paths and versions. The implementation now uses a
`ProjectVerificationPolicy` model for the generated-project contract.

## Follow-Up

- Phase 4.3 should begin AnvilReport organization health reporting.
- A later verifier iteration can add structural YAML parsing and an optional smoke-build mode.
- A separate integration-test repository should only be created when the cross-repository matrix is concrete.
