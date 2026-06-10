# Child 11.2 Plan: SOLID & Design Principle Lint Rules

## Goal

Add mechanical checks for SOLID principles and core design principles to the `swiftanvil lint` command. This child turns the structural heuristics described in `STYLE_GUIDE.md` into executable code.

## Non-Goals

- Do not modify CI workflows — that is Child 11.3.
- Do not remediate existing repo debt — that is Child 11.4.
- Do not add full program analysis or formal proofs — heuristics only.
- Do not modify templates — that is Child 11.5.

## Background

`STYLE_GUIDE.md` documents five SOLID heuristics:

| Principle | Heuristic | Current State |
|-----------|-----------|---------------|
| SRP | File line count, top-level type count | Exists via `--structure` flag; needs promotion to default |
| OCP | `switch` over enums/protocols | Not implemented |
| LSP | `is` / `as?` casts on protocol types | Not implemented |
| ISP | Protocol requirement count > 5 | Not implemented |
| DIP | Public APIs depending on concrete types | Not implemented |

Additionally, the `type-safety-over-strings` principle needs a heuristic check.

## Tasks

### T1: Promote Structure Checks to Default

Remove the `--structure` flag requirement from `swiftanvil lint source`. Structure checks (file line count, top-level type count, mixed type kinds) should run by default with the budgets from `.swiftanvil.yml`.

If `.swiftanvil.yml` is missing, use the defaults baked into `SwiftAnvilConfig`.

### T2: Add `swiftanvil lint solid` Subcommand

Create a new `SolidLint` subcommand under `LintCommand`:

```swift
struct SolidLint: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "solid",
        abstract: "Check SOLID principle conformance"
    )
}
```

This command runs slower, deeper analysis on source files. It scans `Sources/**/*.swift` and produces a report.

### T3: Implement SOLID Heuristics

Add heuristic checks to the lint engine:

**SRP (Single Responsibility Principle)**
- File line count > budget → error
- Top-level types per file > budget → error
- Mixed type kinds ≥ budget → warning

**OCP (Open/Closed Principle)**
- Scan for `switch` statements over enums or protocol types
- If the switch is not exhaustive (no `default`) or is exhaustive but in the same file as the enum definition, flag as warning
- Rationale: adding a case to an enum requires editing the switch

**LSP (Liskov Substitution Principle)**
- Scan for `is` / `as?` / `as!` casts on protocol-typed variables
- Flag each occurrence as warning
- Rationale: downcasting a protocol suggests the abstraction is leaking

**ISP (Interface Segregation Principle)**
- Count requirements (methods, properties, associated types) in each `protocol` declaration
- If count > budget → warning

**DIP (Dependency Inversion Principle)**
- Scan public function signatures and initializers in public types
- If a parameter uses a concrete type (not a protocol) and a protocol alternative exists in the same module, flag as info
- This is a weak heuristic; start as `info` severity only

### T4: Add `.swiftanvil.yml` Budgets

Extend the config model with SOLID budgets:

```yaml
lint:
  structure:
    max_lines: 350
    max_top_level_types: 4
    mixed_type_kinds: 3
  solid:
    max_protocol_requirements: 5
    max_public_concrete_dependencies: 3
```

Update `SwiftAnvilConfig.swift` to parse and expose these values with sensible defaults.

### T5: Add Type-Safety-Over-Strings Heuristic

Add a check to `swiftanvil lint source` that flags:

- `Text("...")` — use `AppStrings`
- `Button("...")` — use `AppStrings`
- `navigationTitle("...")` — use `AppStrings`
- `.accessibilityIdentifier("...")` — use `.a11yID()`
- `Notification.Name("...")` — use typed notification names
- `UserDefaults` keys as string literals — use typed keys

Start as warnings. Allow override via `.swiftanvil.yml`.

### T6: Tests

Add tests for:
- SOLID lint pass (small, clean file)
- SRP fail (file too long, too many types)
- OCP fail (`switch` over enum in same file)
- LSP fail (`is` cast on protocol)
- ISP fail (protocol with >5 requirements)
- Type-safety fail (hardcoded strings)
- Config parsing (default, custom, malformed fallback)

## Success Criteria

- [ ] `swiftanvil lint source` runs structure checks by default (no `--structure` flag)
- [ ] `swiftanvil lint solid` exists and runs all five SOLID heuristics
- [ ] SOLID budgets are configurable in `.swiftanvil.yml`
- [ ] Type-safety-over-strings heuristic exists in `swiftanvil lint source`
- [ ] All new checks have test coverage
- [ ] `swift test` passes (existing + new tests)
- [ ] Cross-host plan review APPROVED or APPROVED_WITH_NOTES

## Dependencies

- Child 11.1 complete (✅)
- `swiftanvil-cli` has lint infrastructure (✅)
- `SwiftAnvilConfig` model exists (✅)

## Estimated Effort

6–8 hours implementation + review.
