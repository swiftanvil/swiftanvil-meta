---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 7
child: 7.4
last_updated: 2026-06-05
---

# Child 7.4 Result: Test Coverage Sprint

## Status

**COMPLETE**

## Summary

Expanded test coverage across 4 under-tested repos. Added 125 new tests, bringing the total from 50 to 175 tests.

## Coverage Improvements

| Repo | Before | After | +New | Test Files |
|------|--------|-------|------|------------|
| swiftanvil-anvil-a11y | 17 | 21 | +4 | A11yIDExtendedTests.swift |
| swiftanvil-anvil-strings | 21 | 28 | +7 | AppStringExtendedTests.swift |
| swiftanvil-anvil-devmenu | 16 | 57 | +41 | DevMenuExtendedTests.swift |
| swiftanvil-anvil-project | 8 | 69 | +61 | ProjectExtendedTests.swift |
| **Total** | **50** | **175** | **+125** | |

## What Was Tested

### AnvilA11y (+4 tests)
- Hashable (equal/different hash, Set, Dictionary)
- Sendable (actor boundary crossing)
- Chained appending (string + int, mixed)
- Edge cases (empty literal, dots, special chars)
- RawRepresentable

### AppStrings (+7 tests)
- Localization (returns string, empty key, description match)
- Interpolation (multiple args, numeric args)
- Builder pattern (single component, optional nil/present, conditional true/false, if-else branches, complex nested)
- Catalog (custom table names, independent catalogs)
- Hashable/Sendable extended

### AnvilDevMenu (+41 tests)
- NetworkLogStore (exact 100 limit, oldest eviction, newest retention, order preservation, single append, clear)
- MenuItem (all 5 screens, Identifiable, Sendable, unique IDs)
- MenuScreen (Sendable)
- DeviceInfo (all fields non-empty, Sendable)
- DeveloperMenu (default/custom config, configure updates shared, CustomAction properties/unique ID, registry multiple actions)
- NetworkLogEntry (2xx/4xx/5xx/unknown status ranges, code inclusion, Identifiable, Sendable)
- LogCollector (exact 500 limit, oldest eviction, newest retention, file/line metadata, level preservation, clear)
- LogMessage (properties, Sendable)
- LogLevel (raw values, specific colors, CaseIterable count)

### AnvilProject (+61 tests)
- ProjectGenerator (directory structure, Package.swift, source files, unit/UI tests, accessibility helper, localization, CI workflow, AGENTS.md, immunity config, git hooks, doc registry, platform versions, destination-exists error)
- TemplateEngine (Encodable→Dictionary, nested values)
- CreateCommand (argument parsing, all options/flags, defaults, error cases, command configuration)
- ConfigValue (all type extractions, Codable round-trip for all cases, Sendable)
- ProjectConfig extended (all default options, custom options, Codable, Sendable)
- GenerationError/TemplateError (descriptions, case existence)

## Verification

- [x] All 4 repos build successfully
- [x] All 175 tests pass
- [x] All changes committed and pushed
