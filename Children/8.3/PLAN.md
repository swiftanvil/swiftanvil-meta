# Child 8.3 Plan: AnvilMenuBar (macOS Menu Bar Extras)

## Context

- **Phase:** 8
- **Child:** 8.3
- **New Repo:** `swiftanvil-anvil-menubar`
- **Goal:** Create a macOS-only package that simplifies `MenuBarExtra` usage with dynamic items, keyboard shortcuts, and state persistence.

## Design

### API

```swift
import SwiftUI
import AnvilMenuBar

@main
struct MyApp: App {
    @State private var menuBar = AnvilMenuBar(items: [
        .button("Open Main Window", action: .openWindow),
        .button("Preferences", action: .openSettings),
        .separator,
        .button("Quit", action: .quit),
    ])

    var body: some Scene {
        WindowGroup { ContentView() }

        MenuBarExtra("MyApp", systemImage: "hammer") {
            menuBar.content
        }
    }
}
```

### Key Types

| Type | Purpose |
|------|---------|
| `AnvilMenuBar` | Observable model that holds menu items and handles actions |
| `MenuBarItem` | Enum representing button, separator, toggle, submenu items |
| `MenuBarAction` | Enum for built-in actions (openWindow, openSettings, quit, custom) |

### Platform Support

- macOS 15+ only
- Uses `MenuBarExtra` (SwiftUI) + `NSMenuItem` (AppKit) for keyboard shortcuts
- Integrates with AnvilSettings for persistence (optional, via `#if canImport`)

## Implementation Steps

1. Create `swiftanvil-anvil-menubar/` with standard SPM structure
2. `Package.swift` — only `.macOS(.v15)` platform
3. Implement `MenuBarItem` enum:
   - `.button(label: String, systemImage: String?, action: MenuBarAction)`
   - `.toggle(label: String, isOn: Binding<Bool>)`
   - `.separator`
   - `.submenu(label: String, items: [MenuBarItem])`
4. Implement `MenuBarAction` enum:
   - `.openWindow(id: String?)`
   - `.openSettings`
   - `.quit`
   - `.custom(() -> Void)`
5. Implement `AnvilMenuBar` — `@Observable` class:
   - `items: [MenuBarItem]`
   - `content: some View` — renders items as SwiftUI views inside MenuBarExtra
   - `insert(_:at:)`, `remove(at:)`, `replace(at:with:)` for dynamic items
6. Add keyboard shortcut support via `keyboardShortcut` modifier on buttons
7. Add DocC catalog + README
8. Write tests:
   - Item creation
   - Dynamic insert/remove
   - Action enum equality
   - MenuBar rendering (verify content is not empty)
9. Run `swift build` + `swift test`
10. Create GitHub repo, push
11. Write RESULT.md, update meta files

## Files to Create

```
swiftanvil-anvil-menubar/
├── Package.swift
├── README.md
├── .gitignore
├── Sources/
│   └── AnvilMenuBar/
│       ├── AnvilMenuBar.docc/
│       │   └── AnvilMenuBar.md
│       ├── AnvilMenuBar.swift
│       ├── MenuBarItem.swift
│       └── MenuBarAction.swift
└── Tests/
    └── AnvilMenuBarTests/
        └── AnvilMenuBarTests.swift
```

## Test Plan

- `testButtonItem` — create button item, verify label
- `testToggleItem` — create toggle, verify binding
- `testSeparatorItem` — separator exists
- `testSubmenuItem` — nested items
- `testDynamicInsert` — insert item at index
- `testDynamicRemove` — remove item at index
- `testMenuBarContentNotEmpty` — content view renders
- `testActionEquality` — actions are Equatable

## Dependencies

- None (SwiftUI + AppKit only)
- Optional: AnvilSettings for persistence (commented out until 8.5 integration)

## Risks

| Risk | Mitigation |
|------|------------|
| `MenuBarExtra` requires macOS 14+ | Our policy is macOS 15+, so fine |
| `NSApp` not available in tests | Use conditional compilation or mock |
| SwiftUI view testing is limited | Test model layer thoroughly; content test is lightweight |
