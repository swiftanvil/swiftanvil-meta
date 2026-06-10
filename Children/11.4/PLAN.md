# Child 11.4 — SwiftAnvil Repo Remediation Sprint

## Goal

Roll out canonical style enforcement (SwiftFormat + SwiftLint) and CI gates to all SwiftAnvil package repositories.

## Scope

All repositories with `Package.swift` in the SwiftAnvil workspace:

1. `swiftanvil-anvil-a11y`
2. `swiftanvil-anvil-bench`
3. `swiftanvil-anvil-core`
4. `swiftanvil-anvil-devmenu`
5. `swiftanvil-anvil-docs`
6. `swiftanvil-anvil-flags`
7. `swiftanvil-anvil-host`
8. `swiftanvil-anvil-macros`
9. `swiftanvil-anvil-menubar`
10. `swiftanvil-anvil-network`
11. `swiftanvil-anvil-project`
12. `swiftanvil-anvil-runner`
13. `swiftanvil-anvil-settings`
14. `swiftanvil-anvil-strings`
15. `swiftanvil-anvil-template`
16. `swiftanvil-anvil-window`
17. `swiftanvil-anvil-wizard`
18. `swiftanvil-example-cli`
19. `swiftanvil-example-golden-path`
20. `swiftanvil-example-library`
21. `swiftanvil-example-swiftui`

## Deliverables per repo

1. **`.swiftformat`** — canonical SwiftFormat config (copied from `swiftanvil-enforcement/configs/swiftformat.yml`)
2. **`.swiftlint.yml`** — canonical SwiftLint config (copied from `swiftanvil-enforcement/configs/swiftlint.yml`)
3. **`.swiftanvil.yml`** — project-specific lint budgets (start relaxed, tighten later)
4. **`.github/workflows/ci.yml`** — build + test + lint using reusable `swiftanvil-enforcement` workflows
5. **`.github/workflows/document-registry-policy-check.yml`** — document registry validation (for repos that reference meta docs)

## Implementation Steps

1. Copy canonical configs to each repo
2. Add `.swiftanvil.yml` with relaxed defaults (prevent immediate CI failures)
3. Add/update CI workflow using `swiftanvil/swiftanvil-enforcement/.github/workflows/swift-ci.yml@v1`
4. Commit and push to each repo
5. Validate at least one repo passes CI
6. Write RESULT.md

## Registry References

- `style.guide` — canonical style configuration
- `planning.child-11-1` — canonical style configs source
- `planning.child-11-3` — pre-commit hooks and CI gates
