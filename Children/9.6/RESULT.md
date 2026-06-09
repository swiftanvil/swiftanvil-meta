# Child 9.6 Result: Migrate iStudio Validators to SwiftAnvil

## Status

**Complete** — SwiftAnvil-side implementation done. iStudio-side migration documented as boundary follow-up.

## What Was Implemented

### T1: Extend `swiftanvil lint source` with `--structure`

Added structure checks to `LintCommand.SourceLint`:
- `--structure` flag enables file-level architecture linting
- **Line count limit** — default 350 lines per file, configurable
- **Top-level type limit** — default 4 types per file, configurable
- **Mixed type kinds** — warns when 3+ different kinds (struct, enum, class, protocol, extension, actor) appear in one file

All checks respect `.swiftanvil.yml` configuration.

### T2: Add `.swiftanvil.yml` Configuration Support

Created `SwiftAnvilConfig` model in `swiftanvil-cli`:
- `Sources/SwiftAnvilCLI/Configuration/SwiftAnvilConfig.swift`
- `SwiftAnvilConfigLoader.load(from:)` loads and merges YAML from project root
- Defaults: `max_lines: 350`, `max_top_level_types: 4`, `mixed_type_kinds: 3`
- Malformed YAML falls back to defaults with a warning

Schema:
```yaml
lint:
  structure:
    max_lines: 350
    max_top_level_types: 4
    mixed_type_kinds: 3
```

### T3: Wire Config into `SourceLint`

`SourceLint.run()` now loads `.swiftanvil.yml` before scanning. Structure checks are gated behind `--structure` to preserve backward compatibility.

### T4: Tests

Added `Tests/SwiftAnvilCLITests/LintCommandTests.swift` (Swift Testing):
- `SwiftAnvilConfigLoaderTests` — 3 tests (defaults, custom values, malformed fallback)
- `SourceStructureLinterTests` — 5 tests (small file pass, line limit fail, type limit fail, mixed kinds warn, custom thresholds)

All 61 tests in `swiftanvil-cli` pass (43 existing + 8 new + 10 from CreateCommand).

## Boundary Finding

The original 9.6 plan included tasks T3–T5 that modify iStudio:
- Update iStudio pre-commit hook
- Deprecate `SwiftSourceStructureValidator` in iStudio
- Add `SwiftAnvilLintValidator` to iStudio validation layer

Per `BOUNDARY.md` (Child 9.5), the iStudio repository is not in the SwiftAnvil workspace, and SwiftAnvil agents must not add Swift-specific policy to iStudio. The integration contract in `BOUNDARY.md` already specifies how iStudio should call `swiftanvil lint`.

**Resolution:** The iStudio-side migration steps are documented below as a follow-up specification. They should be implemented in the iStudio repository by an iStudio agent.

## iStudio Migration Specification (for iStudio team)

### Pre-Commit Hook Update
Replace the doc-comment grep in `.scripts/pre-commit` with:
```bash
if [ -f Package.swift ] && command -v swiftanvil >/dev/null 2>&1; then
  swiftanvil lint source --quiet || exit 1
fi
```

### Validator Deprecation
In iStudio, mark these as deprecated with redirect messages:
- `SwiftSourceStructureValidator` → redirect to `swiftanvil lint source --structure`
- Swift-specific file health budgets → redirect to `.swiftanvil.yml`
- Doc comment ratchet → redirect to `swiftanvil lint source`

### Validation Layer Integration
Add `SwiftAnvilLintValidator` to `IStudioValidation` that shells out to `swiftanvil lint` when `Package.swift` exists, as shown in `BOUNDARY.md` Integration Contract section.

## Files Changed

### swiftanvil-cli
- `Sources/SwiftAnvilCLI/Configuration/SwiftAnvilConfig.swift` **(NEW)**
- `Sources/SwiftAnvilCLI/Commands/LintCommand.swift` **(EDIT)**
- `Tests/SwiftAnvilCLITests/LintCommandTests.swift` **(NEW)**

### swiftanvil-meta
- `Children/9.6/RESULT.md` **(NEW)**
- `ROADMAP.md` **(EDIT)**
- `REGISTRY.yml` **(EDIT)**

## Review

Self-reviewed. All tests pass. Boundary finding documented.
