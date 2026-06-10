# Child 11.1 Plan: Canonical Style Configuration

## Goal

Produce a single source of truth for formatting and style rules that all SwiftAnvil repositories share. This child creates the foundational configs and documentation that the rest of Phase 11 depends on.

## Non-Goals

- Do not apply configs to other repos yet — that is Child 11.4.
- Do not add SOLID heuristics — that is Child 11.2.
- Do not modify CI workflows — that is Child 11.3.
- Do not update templates — that is Child 11.5.

## Background

The SwiftAnvil ecosystem currently documents style expectations in `swiftanvil-cli/Documentation/Fragments/principles/code-style.md` and ADR-006, but no actual `.swiftformat` or `.swiftlint.yml` files exist in any SwiftAnvil repository. This creates a credibility gap: contributors and AI agents can read the principles, but nothing fails if they violate them.

This child establishes the canonical configs in `swiftanvil-enforcement` (the shared enforcement repo) and documents them in `swiftanvil-meta`.

## Tasks

### T1: Define `.swiftformat` Configuration

Create `swiftanvil-enforcement/configs/swiftformat.yml` with rules that match the documented code style:

- 4-space indentation
- 120 character line limit
- Trailing commas enabled
- Explicit `self` where required for clarity
- Protocol-oriented formatting preferences
- Grouped import ordering

### T2: Define `.swiftlint.yml` Configuration

Create `swiftanvil-enforcement/configs/swiftlint.yml` with:

- 120 character line limit (`line_length`)
- Force explicit `self` rules
- Disabled rules that conflict with SwiftFormat
- Custom rules from ADR-006:
  - `raw_accessibility_identifier`: blocks `.accessibilityIdentifier(`
  - `hardcoded_display_string`: warns on `Text("...")`, `Button("...")`, `navigationTitle("...")`
  - `undocumented_public`: warns on public declarations without `///` DocC
- Naming conventions aligned with `NAMING_REGISTRY.md`
- Exclusions for generated files, `.build/`, `DerivedData/`

### T3: Add `Sendable` Conscience Rule

Add a SwiftLint custom rule or a `swiftanvil lint source` check that flags public structs/classes without explicit `Sendable` conformance in a StrictConcurrency project.

### T4: Document the Style Guide

Create `swiftanvil-meta/STYLE_GUIDE.md` that explains:

- Where the canonical configs live
- How to install them in a new repo
- How to override specific rules in `.swiftanvil.yml`
- Why each major rule exists (human + AI readable)
- The relationship between SwiftFormat, SwiftLint, and `swiftanvil lint`

### T5: Add Configs to `swiftanvil-cli` Repository

As the first adopter and proof of concept, add:

- `swiftanvil-cli/.swiftformat` (symlink or copy of canonical config)
- `swiftanvil-cli/.swiftlint.yml`
- Run auto-fixers once to bring the repo into compliance
- Fix any remaining violations manually
- Ensure `swift build` and `swift test` still pass

### T6: Update `swiftanvil-meta` Registries

Add document IDs to `REGISTRY.yml` for:

- `STYLE_GUIDE.md`
- `Children/11.1/PLAN.md`
- `Children/11.1/RESULT.md`

## Success Criteria

- [ ] `swiftanvil-enforcement/configs/swiftformat.yml` exists and is version-pinned
- [ ] `swiftanvil-enforcement/configs/swiftlint.yml` exists with custom rules
- [ ] `swiftanvil-meta/STYLE_GUIDE.md` exists and explains every rule
- [ ] `swiftanvil-cli` repo has `.swiftformat` and `.swiftlint.yml` and passes both
- [ ] `swiftanvil-cli` tests still pass after formatting changes
- [ ] `REGISTRY.yml` updated with new document IDs
- [ ] Cross-host plan review APPROVED or APPROVED_WITH_NOTES

## Dependencies

- Phase 9 complete (✅)
- `swiftanvil-enforcement` repo exists and has a `configs/` directory or can accept one
- SwiftFormat and SwiftLint installed locally (or we add them as dev dependencies)

## Estimated Effort

3–4 hours implementation + review.
