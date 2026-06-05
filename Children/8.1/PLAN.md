# Child 8.1 Plan: macOS App Template for `swiftanvil create`

## Context

- **Phase:** 8
- **Child:** 8.1
- **Primary Repo:** `swiftanvil-cli`
- **Related Repo:** `swiftanvil-anvil-project` (ProjectGenerator lives in CLI, not the library)
- **Goal:** Make `swiftanvil create macos-app MyApp` generate a proper macOS app scaffold instead of the current iOS-centric output.

## Current State

The `swiftanvil-cli` already recognizes `macos-app` as a template name in `InteractiveWizard.selectTemplate()`, but `ProjectGenerator` completely ignores `config.template` and always emits:
- `Package.swift` with `.iOS(.v17)` + `.macOS(.v14)` platforms
- SwiftUI `ContentView` with iOS-style `#Preview`
- `XCUIApplication` UI tests (iOS-only)
- MVVM + I/O architecture with `Models/ViewModels/Views/Services/Utilities` folders
- No SwiftAnvil package dependencies

## Problem

Users selecting `macos-app` get an iOS project with macOS as an afterthought. The generated code uses `XCUIApplication` (doesn't work on macOS), includes iOS-only platform versions, and doesn't leverage any SwiftAnvil packages.

## Proposed Solution

Branch `ProjectGenerator` on `config.template`. When template is `macos-app`:

1. **Package.swift**: Only `.macOS(.v15)`, no iOS. Add SwiftAnvil deps: AnvilNetwork, AnvilFlags, AnvilSettings (when ready), AnvilMenuBar, AnvilWindow.
2. **Directory structure**: Omit `UITests` (macOS apps typically don't use XCUI in SPM). Add `MenuBar/` and `Settings/` folders.
3. **Source files**:
   - `MyApp.swift` — `@main` with `MenuBarExtra` + `WindowGroup`
   - `ContentView.swift` — macOS-appropriate layout (sidebar + detail, not iOS tab bar)
   - `MenuBarView.swift` — menu bar extra content
   - `SettingsView.swift` — settings pane using `Settings` scene
   - `AppViewModel.swift` — `@Observable` view model
   - `AppModel.swift` — basic `Codable, Sendable` model
   - `NetworkService.swift` — uses `AnvilNetwork` (with `#if canImport` fallback stub)
4. **Tests**: Swift Testing unit tests only. No UI tests.
5. **AGENTS.md**: Update to reflect macOS-specific architecture (MenuBar + WindowGroup + Settings).

## Files to Modify

| File | Action | Reason |
|------|--------|--------|
| `Sources/SwiftAnvilCLI/Scaffolding/ProjectGenerator.swift` | Edit heavily | Add template branching for `macos-app` |
| `Tests/SwiftAnvilCLITests/SwiftAnvilCLITests.swift` | Edit | Add `ProjectConfig` test for `macos-app` template |
| `Tests/SwiftAnvilCLITests/CreateCommandTests.swift` | Create | Test that `macos-app` generates correct files |

## Files to Create (in swiftanvil-meta)

| File | Reason |
|------|--------|
| `Children/8.1/PLAN.md` | This plan (already being written) |
| `Children/8.1/RESULT.md` | Completion documentation |

## Implementation Steps

1. Add `isMacOSApp: Bool` computed property to `ProjectConfig` (or check `template == "macos-app"` inline)
2. In `ProjectGenerator.createDirectoryStructure`: skip `UITests` for macOS, add `MenuBar/` and `Settings/`
3. In `ProjectGenerator.generatePackageManifest`: branch on template for platforms and dependencies
4. In `ProjectGenerator.generateSourceStructure`: branch on template for source file content
5. In `ProjectGenerator.generateTestStructure`: skip UI tests for macOS
6. In `ProjectGenerator.generateAgentsMD`: branch on template for architecture description
7. Add tests verifying `macos-app` template produces correct `Package.swift` and file structure
8. Run `swift test` in `swiftanvil-cli` to verify no regressions
9. Write `Children/8.1/RESULT.md`
10. Update `ROADMAP.md` to mark 8.1 complete
11. Commit and push

## Test Plan

- `ProjectConfigTests`: verify `macos-app` template string is preserved
- `CreateCommandTests` (new): generate a temp project with `macos-app`, verify:
  - `Package.swift` contains only `.macOS(.v15)`
  - `Package.swift` contains AnvilNetwork dependency
  - No `UITests` directory created
  - `MenuBar/` and `Settings/` directories exist
  - `Sources/MyApp/MyApp.swift` contains `MenuBarExtra`
  - `swift build` succeeds on the generated project

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Breaking existing `ios-app` generation | Keep iOS path unchanged; only add macOS branch |
| AnvilSettings/AnvilMenuBar don't exist yet | Use `branch: "main"` deps; they'll be created in 8.2–8.4. Or comment them out with TODOs. |
| `#Preview` doesn't work well on macOS | Use `#Preview` anyway — it works on macOS 14+ |

## Decision: Include Future Package Dependencies?

**Recommendation:** Include AnvilNetwork and AnvilFlags (they exist). Add AnvilSettings, AnvilMenuBar, AnvilWindow as commented-out dependencies with TODOs referencing their future Phase 8 children. This way the template is forward-compatible.
