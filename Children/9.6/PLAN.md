# Child 9.6 Plan: Migrate iStudio Validators to SwiftAnvil

## Goal

Move Swift-specific validation logic from iStudio to SwiftAnvil where it belongs. Update iStudio to consume SwiftAnvil's lint instead of duplicating concerns.

## Non-Goals

- Do not modify iStudio's orchestration logic (task state, worker dispatch, credentials)
- Do not migrate non-Swift validators (shell script lint, registry validation, sandbox checks)
- Do not implement new Horizon 1-4 tooling — those are Phase 10

## Background

iStudio currently contains Swift-specific validators that overlap with SwiftAnvil's `swiftanvil lint`:

| iStudio Validator | SwiftAnvil Equivalent | Action |
|---|---|---|
| `SwiftSourceStructureValidator` | `swiftanvil lint source` (partial) | **Migrate** — add `--structure` flag |
| `FileHealthBudgetValidator` (Swift defaults) | No equivalent | **Migrate** — add `.swiftanvil.yml` config |
| Doc comment ratchet (pre-commit hook) | `swiftanvil lint source` (already exists) | **Replace** — call `swiftanvil lint` instead |

## Tasks

### T1: Extend `swiftanvil lint source` with Structure Checks

Add to `LintCommand.swift`:
- File line count limit (default 350, configurable)
- Top-level type count limit (default 4 per file)
- Mixed type kind detection (3+ different kinds)
- Config via `.swiftanvil.yml`:
  ```yaml
  lint:
    structure:
      max_lines: 350
      max_top_level_types: 4
      mixed_type_kinds: 3
  ```

### T2: Add `.swiftanvil.yml` Configuration Support

Create `SwiftAnvilConfig` model:
- Load `.swiftanvil.yml` from project root
- Merge with defaults
- Used by `lint`, `doctor`, `immunity`

### T3: Update iStudio Pre-Commit Hook

Replace doc-comment grep with:
```bash
if [ -f Package.swift ] && command -v swiftanvil >/dev/null 2>&1; then
  swiftanvil lint source --quiet || exit 1
fi
```

### T4: Remove Migrated Validators from iStudio

Mark as deprecated in iStudio:
- `SwiftSourceStructureValidator` → redirect to `swiftanvil lint source --structure`
- Swift-specific file health budgets → redirect to `.swiftanvil.yml`
- Doc comment ratchet → redirect to `swiftanvil lint source`

### T5: Add `swiftanvil lint` Call to iStudio Validation Layer

In `IStudioValidation`, add `SwiftAnvilLintValidator` that shells out to `swiftanvil lint` when `Package.swift` exists.

## Success Criteria

- [ ] `swiftanvil lint source --structure` checks file line counts and top-level types
- [ ] `.swiftanvil.yml` config is loaded and respected
- [ ] iStudio pre-commit hook calls `swiftanvil lint source` instead of duplicating checks
- [ ] iStudio validators deprecated with clear redirect messages
- [ ] Cross-host implementation review APPROVED or APPROVED_WITH_NOTES

## Dependencies

- Child 9.5 (boundary document) — must be complete first
- `swiftanvil-cli` buildable — already true

## Estimated Effort

4-6 hours implementation + review.
