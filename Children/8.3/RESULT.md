---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 8
child: 8.3
last_updated: 2026-06-05
---

# Child 8.3 Result: AnvilMenuBar (macOS Menu Bar Extras)

## Status

**COMPLETE**

## Summary

Created `swiftanvil-anvil-menubar` — a macOS-only package that simplifies `MenuBarExtra` usage with dynamic items and built-in actions.

## Deliverables

| File | Purpose |
|------|---------|
| `Package.swift` | Swift tools 6.0, macOS 15+ only |
| `Sources/AnvilMenuBar/MenuBarItem.swift` | Enum: button, toggle, separator, submenu |
| `Sources/AnvilMenuBar/MenuBarAction.swift` | Enum: openWindow, openSettings, quit, custom |
| `Sources/AnvilMenuBar/AnvilMenuBar.swift` | `@Observable` model with dynamic mutation + content view |
| `Tests/AnvilMenuBarTests/AnvilMenuBarTests.swift` | 13 tests |

## API

```swift
@State private var menuBar = AnvilMenuBar(items: [
    .button("Open", action: .openWindow()),
    .separator,
    .button("Quit", action: .quit),
])

MenuBarExtra("MyApp", systemImage: "hammer") {
    menuBar.content
}
```

## Verification

- [x] `swift build` succeeds
- [x] `swift test` passes (13 tests)
- [x] Swift 6 + StrictConcurrency
- [x] DocC catalog present
- [x] README with usage examples
- [x] GitHub repo created and pushed

## Test Results

```
Test run with 13 tests in 1 suite passed after 0.001 seconds.
```

## Commit

- `swiftanvil-anvil-menubar`: initial commit — feat: AnvilMenuBar macOS menu bar extras (Child 8.3)
