---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 6
child: 6.2
last_updated: 2026-06-05
---

# Child 6.2 Result: Documentation Generator CLI Integration

## Status

**COMPLETE**

## Summary

Closed the AnvilDocs gap by integrating DocC generation into the CLI as `swiftanvil docs generate`
and `swiftanvil docs preview`. Tagged AnvilDocs `0.1.0` and made the documentation pipeline usable
end-to-end. Preserved existing registry `compose` and `validate` commands.

## Deliverables

| Deliverable | Location | Status |
|-------------|----------|--------|
| `DocsCommand.swift` (refactored) | `swiftanvil-cli/Sources/SwiftAnvilCLI/Commands/` | ✅ Complete |
| `DocsCommand.Generate` subcommand | `DocsCommand.swift` | ✅ Complete |
| `DocsCommand.Preview` subcommand | `DocsCommand.swift` | ✅ Complete |
| `DocCGenerator` actor | `DocsCommand.swift` | ✅ Complete |
| `DocCPreviewer` actor | `DocsCommand.swift` | ✅ Complete |
| Docs command tests | `Tests/SwiftAnvilCLITests/DocsCommandTests.swift` | ✅ 9 tests |
| AnvilDocs `0.1.0` tag | `swiftanvil-anvil-docs` | ✅ Tagged |
| AnvilDocs CHANGELOG | `swiftanvil-anvil-docs/CHANGELOG.md` | ✅ Complete |
| CI docs validation | `.github/workflows/ci.yml` | ✅ Complete |
| Updated CLI README | `swiftanvil-cli/README.md` | ✅ Complete |
| Updated packages.registry | `MEMORY/07-PACKAGES.md` | ✅ Complete |
| Updated roadmap.org | `ROADMAP.md` | ✅ Complete |

## Commands Added

### `swiftanvil docs generate`

```bash
# Basic usage
swiftanvil docs generate --path ./MyPackage --output ./docs

# With GitHub Pages hosting base path
swiftanvil docs generate --path ./MyPackage --output ./docs --hosting-base-path my-package

# Scoped to a specific target
swiftanvil docs generate --path ./MyPackage --target MyTarget

# Machine-readable JSON output
swiftanvil docs generate --path ./MyPackage --json
```

**What it does:**
1. Discovers `.docc` catalogs in `Sources/` or package root.
2. Attempts `swift-docc-plugin` (`swift package generate-documentation`) first.
3. Falls back to `docc convert` directly if plugin fails.
4. Counts generated HTML pages and reports output path.

**Flags:** `--path`, `--output`, `--hosting-base-path`, `--target`, `--json`

### `swiftanvil docs preview`

```bash
# Default port 8080
swiftanvil docs preview --path ./MyPackage

# Custom port
swiftanvil docs preview --path ./MyPackage --port 3000
```

**What it does:**
1. Generates docs to `./.swiftanvil/docs-preview`.
2. Starts `python3 -m http.server` in the docs directory.
3. Polls source files every 2 seconds for changes.
4. Auto-rebuilds and prompts browser refresh on change.

**Flags:** `--path`, `--port`, `--target`

### Existing Commands Preserved

- `swiftanvil docs compose [--document <id>]` — registry-driven doc composition
- `swiftanvil docs validate` — basic registry integrity check

## Test Results

```
Test run with 62 tests in 15 suites passed after 1.728 seconds
```

Breakdown:
- Existing suites: 53 tests (all still passing)
- `DocCGenerator`: 5 tests (result codable, success with catalog, failure without catalog, hosting base path, target option)
- `DocCPreviewer`: 2 tests (serve fails when docs missing, serve fails when no index.html)
- `DocsCommand.Generate`: 2 tests (defaults, integration)

**Total: 62 tests, 0 failures**

## Design Decisions

1. **No new SPM dependencies**: DocC generation uses shell commands (`swift-docc-plugin`, `docc convert`) rather than linking DocC libraries. Keeps CLI build fast and avoids Xcode-only dependencies.

2. **Dual-path generation**: `swift-docc-plugin` is preferred (modern, SPM-native); `docc convert` is a fallback for environments where the plugin isn't available.

3. **Actor isolation**: `DocCGenerator` and `DocCPreviewer` are actors for safe concurrent access. `ShellRunner` (existing) handles all process execution.

4. **Python http.server for preview**: Cross-platform, no extra dependencies, universally available on macOS and most Linux distributions.

5. **Polling file watcher**: Simple 2-second poll instead of FSEvents/kqueue. Sufficient for docs preview; avoids platform-specific complexity.

6. **Preserved existing `compose`/`validate`**: The existing `DocsCommand` registry commands remain untouched. New `generate`/`preview` subcommands are additive.

## Files Changed

```
swiftanvil-cli/
├── Sources/SwiftAnvilCLI/
│   └── Commands/
│       └── DocsCommand.swift          (refactored: +generate, +preview, +DocCGenerator, +DocCPreviewer)
├── Tests/SwiftAnvilCLITests/
│   └── DocsCommandTests.swift         (new)
├── .github/workflows/
│   └── ci.yml                         (+ docs subcommand validation)
└── README.md                          (+ docs generate/preview examples)

swiftanvil-anvil-docs/
├── CHANGELOG.md                       (new)
└── (tagged 0.1.0)

swiftanvil-meta/
├── MEMORY/07-PACKAGES.md              (AnvilDocs version: unreleased → 0.1.0)
├── ROADMAP.md                         (Child 6.2: Planned → Complete)
└── Children/README.md                 (Child 6.2: Planned → Complete)
```

## Known Limitations

- DocC must be installed (`xcrun docc` or `docc` in PATH). No bundled DocC.
- `swift-docc-plugin` must be declared in the target package's `Package.swift`. The CLI cannot inject it.
- Preview server uses polling (2s interval), not real-time filesystem events.
- No `swiftanvil docs publish` — deferred to Child 6.3.
- No multi-package combined docs — deferred.

## Next Steps

- Child 6.3: Example Projects & Ecosystem Validation
