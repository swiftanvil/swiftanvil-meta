# Child 3.4 Result: Documentation Generator Recovery and Promotion

## Outcome

Complete on 2026-06-04.

## Decision

Documentation generation will use a separate package: `swiftanvil-anvil-docs`.

The package owns reusable documentation registry logic. `swiftanvil-cli` should integrate the library later for
command-line UX.

## Deliverable

| Item | Value |
|------|-------|
| Repo | https://github.com/swiftanvil/swiftanvil-anvil-docs |
| Package | AnvilDocs |
| Products | `AnvilDocs` library |
| Initial commit | `6e1e311` |
| Platform policy fix | `7b00bcc` |
| Tests | 6 Swift Testing tests |
| CI | Passed on main |
| Enforcement | Document Registry Policy passed on main |

## What It Does

- Loads documentation registries from YAML.
- Validates source fragment references.
- Composes one document by stable document ID.
- Composes all documents deterministically.
- Uses an explicit file-system protocol for testability.

## Follow-Up

- Child 3.5 owns testing and verification infrastructure.
- A later CLI integration should add `swiftanvil docs compose` using AnvilDocs.
- DocC archive generation remains future work after registry composition is stable.
