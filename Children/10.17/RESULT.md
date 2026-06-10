# Child 10.17 — Agent Instructions Generator: Result

## Status: Complete ✅

## What Was Delivered

### `swiftanvil agent instructions [--output <file>]`

Auto-generates `AGENTS.md`-style instructions from codebase analysis.

### Detected Content

| Section | Detection Method |
|---|---|
| **Build System** | Always includes `swift build` + `swift test`; adds `swiftformat` / `swiftlint` if configs exist |
| **Platforms** | Parses `platforms:` from `Package.swift` |
| **Source Structure** | Lists `Sources/` subdirectories with file counts |
| **Test Structure** | Lists `Tests/` subdirectories |
| **Dependencies** | Parses `.package(url:)` from `Package.swift` |
| **Project Description** | First non-heading paragraph from `README.md` |
| **Editing Rules** | Hardcoded SwiftAnvil conventions |

### Files Added

| File | Description |
|---|---|
| `Sources/SwiftAnvilCLI/Agent/AgentInstructionsGenerator.swift` | Instructions engine |
| `Tests/SwiftAnvilCLITests/AgentInstructionsGeneratorTests.swift` | 2 tests |

### Tests

- `swift test` — 109/109 pass ✅ (2 new tests)

## Registry References

- `roadmap.org` — Phase 10 horizon 4
