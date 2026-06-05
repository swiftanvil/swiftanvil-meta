---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 8
child: 8.4
last_updated: 2026-06-05
---

# Child 8.4 Result: AnvilWindow (macOS Window Management)

## Status

**COMPLETE**

## Summary

Created `swiftanvil-anvil-window` — a macOS-only package with window management helpers: floating panels, HUD windows, window restoration, and programmatic window control.

## Deliverables

| File | Purpose |
|------|---------|
| `Package.swift` | Swift tools 6.0, macOS 15+ only |
| `Sources/AnvilWindow/AnvilPanel.swift` | SwiftUI Scene wrapper for floating NSPanel |
| `Sources/AnvilWindow/AnvilHUD.swift` | Transient HUD window with auto-dismiss |
| `Sources/AnvilWindow/AnvilWindowState.swift` | Actor for save/restore window frames |
| `Sources/AnvilWindow/AnvilWindowController.swift` | Show/hide/close windows programmatically |
| `Tests/AnvilWindowTests/AnvilWindowTests.swift` | 12 tests |

## API

```swift
// Floating panel
AnvilPanel("Inspector", id: "inspector") {
    InspectorView()
}
.floating(true)
.resizable(false)
.defaultSize(width: 300, height: 400)

// HUD
AnvilHUD("Notification") { Text("Saved!") }
.autoDismiss(after: 2.0)

// State
let snapshot = await AnvilWindowState.shared.capture(id: "inspector")
await AnvilWindowState.shared.restore(from: snapshot)

// Control
await AnvilWindowController.shared.showWindow(id: "inspector")
```

## Verification

- [x] `swift build` succeeds
- [x] `swift test` passes (12 tests)
- [x] Swift 6 + StrictConcurrency
- [x] DocC catalog present
- [x] README with usage examples
- [x] GitHub repo created and pushed

## Test Results

```
Test run with 12 tests in 1 suite passed after 0.001 seconds.
```

## Commit

- `swiftanvil-anvil-window`: initial commit — feat: AnvilWindow macOS window management (Child 8.4)
