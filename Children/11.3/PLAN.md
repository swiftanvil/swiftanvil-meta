# Child 11.3 — Pre-commit Hook + CI Gate Integration

## Goal

Make SwiftAnvil's style guide (SwiftFormat) and lint rules (SwiftLint) enforceable at commit time and in CI, with a performance budget of < 10 seconds for incremental changes.

## Scope

1. **Pre-commit hook** (`swiftanvil-enforcement/scripts/install-git-hooks.sh`)
   - Run SwiftFormat lint on staged Swift files
   - Run SwiftLint on staged Swift files
   - Only check changed files (not full repo) for speed
   - Fail the commit if violations are found
   - Provide clear error messages with fix instructions

2. **Reusable GHA workflows** (`swiftanvil-enforcement/.github/workflows/`)
   - Add format-check step to `swift-lint.yml`
   - Add format-check step to `swift-ci.yml`
   - Ensure both use canonical configs from `swiftanvil-enforcement/configs/`

3. **Performance budget**
   - Pre-commit hook must complete in < 10s for typical incremental changes (≤ 10 files)
   - Measure and document actual timings

## Deliverables

| Deliverable | Location |
|---|---|
| Updated `install-git-hooks.sh` | `swiftanvil-enforcement/scripts/install-git-hooks.sh` |
| Updated `swift-lint.yml` | `swiftanvil-enforcement/.github/workflows/swift-lint.yml` |
| Updated `swift-ci.yml` | `swiftanvil-enforcement/.github/workflows/swift-ci.yml` |
| Performance validation | This plan + RESULT.md |

## Implementation Steps

1. Write new pre-commit hook template that:
   - Detects staged `.swift` files via `git diff --cached --name-only --diff-filter=ACM`
   - Runs `swiftformat --lint <files>` if SwiftFormat is installed
   - Runs `swiftlint lint --reporter github-actions-logging <files>` if SwiftLint is installed
   - Skips gracefully if tools are not installed (with a warning)
   - Prints fix instructions on failure

2. Update `install-git-hooks.sh` to install the new hook

3. Update `swift-lint.yml` to add a `Lint Format` job step

4. Update `swift-ci.yml` to add a `Lint Format` job step

5. Test pre-commit hook performance on swiftanvil-cli

6. Write RESULT.md and commit

## Testing

- Install hook in swiftanvil-cli
- Stage a Swift file with a format violation (e.g., wrong indentation)
- Attempt commit — should fail with clear message
- Fix the violation — commit should succeed
- Measure timing with `time`

## Registry References

- `style.guide` — canonical style configuration
- `planning.child-11-1` — canonical style config (prerequisite)
- `planning.child-11-2` — SOLID lint rules (prerequisite)
