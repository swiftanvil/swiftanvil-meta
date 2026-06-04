# SwiftAnvil Example Projects

> Living documentation that validates the entire toolchain end-to-end.

## Existing Examples

| Example | Type | Packages Used | Repo |
|---------|------|---------------|------|
| **CounterKit** | SPM Library | BenchmarkKit | `swiftanvil-example-library` |
| **WordCounter** | CLI Tool | ArgumentParser | `swiftanvil-example-cli` |
| **TodoApp** | SwiftUI iOS App | AnvilNetwork, AnvilFlags | `swiftanvil-example-swiftui` |

## What Each Example Demonstrates

### CounterKit (Library)

- Actor-isolated mutable state (`Counter` actor)
- DocC documentation catalog
- BenchmarkKit performance tests
- Concurrent safety tests (100 parallel increments)

### WordCounter (CLI)

- ArgumentParser `@main` command structure
- File I/O with error handling
- Text processing (words, lines, characters)

### TodoApp (SwiftUI)

- `@State` + actor pattern for data mutation
- `NavigationStack`, `List`, `ToolbarItem`
- SwiftUI preview with `#Preview`

## Conventions

Every example must:

1. **Build** with `swift build`
2. **Test** with `swift test` (minimum 3 tests)
3. **Have** a `Package.swift` with Swift 6 language mode
4. **Have** a `README.md` with build and test instructions
5. **Have** a `.gitignore` for `.build/`, `.swiftpm/`, `.DS_Store`
6. **Pass** `ifoundation verify --example`

## Adding a New Example

1. Create a new repo: `swiftanvil-example-<name>`
2. Add `Package.swift`, `README.md`, `.gitignore`
3. Create `Sources/` and `Tests/` with meaningful code
4. Run `swift build && swift test`
5. Run `ifoundation verify --example --path .`
6. Add the example to this file

## Verification

```bash
# Verify any example project
ifoundation verify --example --path ./swiftanvil-example-library
```

## Maintenance

Examples are living documentation. If a template or package changes, update the affected examples. The `verify --example` command catches structural drift.
