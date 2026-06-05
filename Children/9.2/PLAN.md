# Child 9.2 Plan: Swift 6 Language Mode Consistency

## Context

- **Phase:** 9
- **Child:** 9.2
- **Scope:** All 21 Swift package repos
- **Goal:** Ensure every repo uses `swiftLanguageModes: [.v6]` at the package level consistently.

## Audit Results

| Repo | Swift 6 Mode | Location | Needs Fix? |
|---|---|---|---|
| swiftanvil-anvil-a11y | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-bench | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-core | ⚠️ `.v6` | Per-target | **Yes** |
| swiftanvil-anvil-devmenu | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-docs | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-flags | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-macros | ❌ None | — | **Yes** |
| swiftanvil-anvil-menubar | ⚠️ `.v6` | Per-target | **Yes** |
| swiftanvil-anvil-network | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-project | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-runner | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-settings | ⚠️ `.v6` | Per-target | **Yes** |
| swiftanvil-anvil-strings | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-template | ✅ `.v6` | Package level | No |
| swiftanvil-anvil-window | ⚠️ `.v6` | Per-target | **Yes** |
| swiftanvil-anvil-wizard | ✅ `.v6` | Package level | No |
| swiftanvil-cli | ✅ `.v6` | Package level | No |
| swiftanvil-example-cli | ⚠️ `.v6` + deprecated | Both | **Yes** |
| swiftanvil-example-golden-path | ❌ deprecated only | Per-target | **Yes** |
| swiftanvil-example-library | ⚠️ `.v6` + deprecated | Both | **Yes** |
| swiftanvil-example-swiftui | ⚠️ `.v6` + deprecated | Both | **Yes** |

## Fixes (9 repos)

1. **swiftanvil-anvil-core** — Move `.swiftLanguageMode(.v6)` from targets to package level
2. **swiftanvil-anvil-menubar** — Move `.swiftLanguageMode(.v6)` from targets to package level
3. **swiftanvil-anvil-settings** — Move `.swiftLanguageMode(.v6)` from targets to package level
4. **swiftanvil-anvil-window** — Move `.swiftLanguageMode(.v6)` from targets to package level
5. **swiftanvil-anvil-macros** — Add `swiftLanguageModes: [.v6]` at package level
6. **swiftanvil-example-cli** — Remove per-target `.swiftLanguageMode(.v6)` and `.enableExperimentalFeature("StrictConcurrency")`
7. **swiftanvil-example-golden-path** — Replace `.enableExperimentalFeature("StrictConcurrency")` with package-level `swiftLanguageModes: [.v6]`
8. **swiftanvil-example-library** — Remove per-target `.swiftLanguageMode(.v6)` and `.enableExperimentalFeature("StrictConcurrency")`
9. **swiftanvil-example-swiftui** — Remove per-target `.swiftLanguageMode(.v6)` and `.enableExperimentalFeature("StrictConcurrency")`

## Verification

- Run `swift build` in each modified repo
- All must compile without errors
