# Child 8.2 Plan: AnvilSettings (Type-Safe UserDefaults)

## Context

- **Phase:** 8
- **Child:** 8.2
- **New Repo:** `swiftanvil-anvil-settings`
- **Goal:** Create a type-safe UserDefaults wrapper with `@AnvilSetting` property wrapper, Codable support, migration, and Observation integration.

## Design

### API

```swift
// Property wrapper for SwiftUI integration
@AnvilSetting("apiEndpoint") var apiEndpoint: String = "https://api.example.com"
@AnvilSetting("theme") var theme: AppTheme = .system
@AnvilSetting("maxItems") var maxItems: Int = 100

// Direct actor API for programmatic access
let settings = AnvilSettings()
await settings.set("apiEndpoint", value: "https://new.api.com")
let endpoint: String? = await settings.get("apiEndpoint")

// Migration
await settings.migrate(from: 1, to: 2) { migrator in
    migrator.rename("oldKey", to: "newKey")
    migrator.transform("count", to: "maxItems") { (old: Int) in old * 10 }
}
```

### Key Types

| Type | Purpose |
|------|---------|
| `AnvilSettings` | Actor-isolated settings store backed by `UserDefaults` |
| `@AnvilSetting<T>` | Property wrapper that reads/writes `UserDefaults` and publishes changes via `Observation` |
| `SettingKey<T>` | Phantom-typed key for compile-time safety (optional advanced API) |
| `SettingsMigration` | Builder for versioned migrations |

### Platform Support

- iOS 18+, macOS 15+, tvOS 18+, watchOS 11+, visionOS 2+
- Uses `Observation` framework (`@Observable`) for reactive UI
- `UserDefaults` is the backing store
- `Codable` values are JSON-encoded for storage

## Implementation Steps

1. Create `swiftanvil-anvil-settings/` directory with standard SPM structure
2. Write `Package.swift` with Swift 6, platform policy compliant
3. Implement `AnvilSettings` actor:
   - `get<T: Codable & Sendable>(_ key: String) -> T?`
   - `set<T: Codable & Sendable>(_ key: String, value: T)`
   - `remove(_ key: String)`
   - `contains(_ key: String) -> Bool`
   - `allKeys() -> [String]`
4. Implement `@AnvilSetting<T: Codable & Sendable>` property wrapper:
   - Uses `Observation` framework for change publishing
   - Reads from `UserDefaults` on init, writes on `set`
   - Supports `projectedValue` for binding
5. Implement `SettingsMigration`:
   - `rename(from:to:)`
   - `transform<T, U>(from:to:transform:)`
   - `delete(_:)`
   - Tracks migration version in `UserDefaults`
6. Add DocC catalog
7. Add README with usage examples
8. Write tests:
   - Basic get/set/remove
   - Codable round-trip (struct)
   - Property wrapper integration
   - Migration (rename, transform)
   - Concurrent access safety
9. Run `swift build` + `swift test`
10. Create GitHub repo, add remote, push
11. Write `Children/8.2/RESULT.md`
12. Update `ROADMAP.md`, `MEMORY/07-PACKAGES.md`, `IMPROVEMENT_DASHBOARD.md`
13. Commit and push meta changes

## Files to Create

```
swiftanvil-anvil-settings/
├── Package.swift
├── README.md
├── .gitignore
├── Sources/
│   └── AnvilSettings/
│       ├── AnvilSettings.docc/
│       │   └── AnvilSettings.md
│       ├── AnvilSettings.swift
│       ├── AnvilSetting.swift
│       └── SettingsMigration.swift
└── Tests/
    └── AnvilSettingsTests/
        └── AnvilSettingsTests.swift
```

## Test Plan

- `testGetSetString` — store and retrieve a String
- `testGetSetInt` — store and retrieve an Int
- `testGetSetCodable` — store and retrieve a custom Codable struct
- `testRemove` — remove a key
- `testContains` — check key existence
- `testPropertyWrapper` — @AnvilSetting reads/writes correctly
- `testMigrationRename` — rename key preserves value
- `testMigrationTransform` — transform changes value type
- `testConcurrentAccess` — multiple tasks read/write safely

## Dependencies

- None (Foundation + Observation only)
- No external packages

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| `Observation` not available on all platforms | Minimum is iOS 17+/macOS 14+; our policy is iOS 18+/macOS 15+ so we're fine |
| `UserDefaults` is not actor-isolated | `AnvilSettings` is an actor; all access goes through it |
| Codable failures for complex types | Document that types must be Codable; test with common types |
