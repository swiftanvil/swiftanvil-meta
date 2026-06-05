---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 8
child: 8.1
last_updated: 2026-06-05
---

# Child 8.1 Result: macOS App Template for `swiftanvil create`

## Status

**COMPLETE**

## Summary

Made `swiftanvil create macos-app MyApp` generate a proper macOS app scaffold instead of the previous iOS-centric output. The template name was already recognized by the CLI and wizard, but `ProjectGenerator` ignored it entirely.

## Changes Made

### `swiftanvil-cli` — Sources

| File | Change |
|------|--------|
| `Configuration/ProjectConfig.swift` | Added `isMacOSApp: Bool` computed property |
| `Scaffolding/ProjectGenerator.swift` | Branched all generation methods on `config.isMacOSApp` |

### `swiftanvil-cli` — Tests

| File | Change |
|------|--------|
| `Tests/SwiftAnvilCLITests/SwiftAnvilCLITests.swift` | Added `macOSAppTemplateDetection` and `iOSAppTemplateIsNotMacOS` tests |
| `Tests/SwiftAnvilCLITests/CreateCommandTests.swift` | **New file** — 6 tests covering macOS generation and iOS regression |

## What `macos-app` Now Generates

### Package.swift
- Only `.macOS(.v15)` platform (no iOS)
- Dependencies on `AnvilNetwork` and `AnvilFlags`
- Commented-out future deps: AnvilSettings, AnvilMenuBar, AnvilWindow

### Directory Structure
- `Sources/MyApp/Models/`
- `Sources/MyApp/ViewModels/`
- `Sources/MyApp/Views/`
- `Sources/MyApp/Services/`
- `Sources/MyApp/Utilities/`
- `Sources/MyApp/MenuBar/` ← new
- `Sources/MyApp/Settings/` ← new
- `Tests/MyAppTests/`
- No `UITests/` (macOS apps don't use XCUI in SPM)

### Source Files
- `MyAppApp.swift` — `@main` with `WindowGroup`, `MenuBarExtra`, and `Settings` scenes
- `ContentView.swift` — `NavigationSplitView` with sidebar + detail
- `MenuBarView.swift` — Menu bar extra content with `NSApp` integration
- `SettingsView.swift` — Settings pane using `Form`
- `AppViewModel.swift` — `@Observable` view model
- `AppModel.swift` — `Codable, Sendable` model
- `NetworkService.swift` — Actor with `#if canImport(AnvilNetwork)` stub

### Tests
- Swift Testing unit tests only (no XCTest UI tests)
- Tests `AppModel` creation and `AppViewModel` title

### AGENTS.md
- Updated architecture description for macOS: "MVVM + MenuBar + Settings"

## What `ios-app` Still Generates (Unchanged)

- `.iOS(.v17)` + `.macOS(.v14)` platforms
- No SwiftAnvil dependencies
- `XCUIApplication` UI tests
- Same `ContentView` with globe icon

## Verification

- [x] All 53 tests pass (43 existing + 10 new)
- [x] Generated macOS project builds successfully with `swift build`
- [x] iOS template regression tests pass
- [x] No breaking changes to existing templates

## Test Results

```
Test run with 53 tests in 12 suites passed after 17.257 seconds.
```

New tests:
- `generates macOS-only Package.swift` ✅
- `creates MenuBar and Settings directories` ✅
- `generates MenuBarExtra in app entry point` ✅
- `generates MenuBarView and SettingsView` ✅
- `generated macOS project builds successfully` ✅ (17s — fetches deps)
- `iOS template still generates iOS + macOS platforms` ✅
- `iOS template creates UITests directory` ✅
- `iOS template generates XCUIApplication UI tests` ✅

## Commit

- `swiftanvil-cli`: feat: macOS app template for `swiftanvil create` (Child 8.1)
