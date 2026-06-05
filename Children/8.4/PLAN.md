# Child 8.4 Plan: AnvilWindow (macOS Window Management)

## Context

- **Phase:** 8
- **Child:** 8.4
- **New Repo:** `swiftanvil-anvil-window`
- **Goal:** Create a macOS-only package with window management helpers: floating panels, HUD windows, window restoration, and `NSWindowController` helpers.

## Design

### API

```swift
import AnvilWindow

// Floating panel
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }

        AnvilPanel("Inspector", id: "inspector") {
            InspectorView()
        }
        .floating(true)
        .resizable(false)
        .defaultSize(width: 300, height: 400)
    }
}

// HUD window
AnvilHUD("Notification") {
    Text("Saved!")
}
.autoDismiss(after: 2.0)

// Window restoration
AnvilWindowState.shared.restore(from: savedState)
let state = await AnvilWindowState.shared.capture()
```

### Key Types

| Type | Purpose |
|------|---------|
| `AnvilPanel` | SwiftUI `Scene` wrapper for floating `NSPanel` |
| `AnvilHUD` | Transient HUD window with auto-dismiss |
| `AnvilWindowState` | Actor for saving/restoring window frames and visibility |
| `AnvilWindowController` | Helper for programmatic window management |

### Platform Support

- macOS 15+ only
- Uses `NSPanel`, `NSWindowController`, `NSWindow` APIs

## Implementation Steps

1. Create `swiftanvil-anvil-window/` with standard SPM structure
2. `Package.swift` — only `.macOS(.v15)`
3. Implement `AnvilPanel` — SwiftUI `Scene` that creates an `NSPanel`:
   - `init(_ title: String, id: String, @ViewBuilder content: () -> Content)`
   - Modifiers: `.floating(Bool)`, `.resizable(Bool)`, `.defaultSize(width:height:)`, `.level(NSWindow.Level)`
4. Implement `AnvilHUD` — transient window:
   - `init(_ title: String, @ViewBuilder content: () -> Content)`
   - `.autoDismiss(after: TimeInterval)`
   - `.animation(NSAnimationContext)`
5. Implement `AnvilWindowState` actor:
   - `capture() -> WindowStateSnapshot`
   - `restore(from: WindowStateSnapshot)`
   - `WindowStateSnapshot` = Codable struct with frame, visibility, level
6. Implement `AnvilWindowController`:
   - `showWindow(id:)` / `hideWindow(id:)` / `closeWindow(id:)`
   - `windowExists(id:)` / `windowFrame(id:)`
7. Add DocC + README
8. Write tests:
   - Panel creation
   - HUD creation
   - WindowState snapshot round-trip
   - WindowController tracking
9. Run `swift build` + `swift test`
10. Create GitHub repo, push
11. Write RESULT.md, update meta files

## Files to Create

```
swiftanvil-anvil-window/
├── Package.swift
├── README.md
├── .gitignore
├── Sources/
│   └── AnvilWindow/
│       ├── AnvilWindow.docc/
│       │   └── AnvilWindow.md
│       ├── AnvilPanel.swift
│       ├── AnvilHUD.swift
│       ├── AnvilWindowState.swift
│       └── AnvilWindowController.swift
└── Tests/
    └── AnvilWindowTests/
        └── AnvilWindowTests.swift
```

## Test Plan

- `testPanelCreation` — panel scene can be instantiated
- `testHUDCreation` — HUD can be instantiated
- `testWindowStateSnapshotCodable` — encode/decode round-trip
- `testWindowStateCaptureRestore` — capture and restore match
- `testWindowControllerTrackShowHide` — controller tracks window state
- `testWindowStateDefaultValues` — snapshot has sensible defaults

## Dependencies

- None (AppKit + SwiftUI only)

## Risks

| Risk | Mitigation |
|------|------------|
| NSWindow testing in SPM is limited | Test model/state layer; avoid UI interaction tests |
| `NSPanel` requires run loop | Don't test actual window display; test configuration |
