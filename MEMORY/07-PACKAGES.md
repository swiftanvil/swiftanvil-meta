---
priority: HIGH
type: REFERENCE
audience: BUILDER
last_updated: 2026-06-05
---

# Package Registry

> Auto-generated from package.improvement-score. Updated after every child completion.

| Package | Repo | Version | PMS | Grade | Status | Min iOS | Min macOS |
|---------|------|---------|-----|-------|--------|---------|-----------|
| AnvilTemplate | swiftanvil-anvil-template | 1.3.0 | 82 | A | 🟢 Healthy | 18 | 15 |
| AnvilProject | swiftanvil-anvil-project | 1.0.0 | 82 | A | 🟢 Healthy | — | 15 |
| AnvilDocs | swiftanvil-anvil-docs | 0.1.0 | — | — | 🟢 Healthy | — | 15 |
| AnvilWizard | swiftanvil-anvil-wizard | 1.0.0 | — | — | 🟢 Healthy | — | 15 |
| AnvilNetwork | swiftanvil-anvil-network | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilFlags | swiftanvil-anvil-flags | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilDevMenu | swiftanvil-anvil-devmenu | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilRunner | swiftanvil-anvil-runner | 0.3.0 | — | — | 🟢 Healthy | — | 15 |
| swiftanvil-cli | swiftanvil-cli | 0.3.0 | 85 | A | 🟢 Healthy | — | 15 |
| A11yIdentifiers | swiftanvil-anvil-a11y | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| BenchmarkKit | swiftanvil-anvil-bench | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AppStrings | swiftanvil-anvil-strings | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilCore | swiftanvil-anvil-core | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilMacros | swiftanvil-anvil-macros | 1.0.0 | — | — | 🟡 Stub | 18 | 15 |
| AnvilSettings | swiftanvil-anvil-settings | 1.0.0 | — | — | 🟢 Healthy | 18 | 15 |
| AnvilMenuBar | swiftanvil-anvil-menubar | — | — | — | ⚪ Planned | — | 15 |
| AnvilWindow | swiftanvil-anvil-window | — | — | — | ⚪ Planned | — | 15 |

## Example Projects

| Example | Repo | Type | Tests | Status |
|---------|------|------|-------|--------|
| CounterKit | swiftanvil-example-library | Library | 7/7 | 🟢 Healthy |
| WordCounter | swiftanvil-example-cli | CLI | 5/5 | 🟢 Healthy |
| TodoApp | swiftanvil-example-swiftui | SwiftUI App | 6/6 | 🟢 Healthy |
| GoldenPath | swiftanvil-example-golden-path | SwiftUI App | 5/5 | 🟡 Misleading docs |

## ✅ Platform Policy Status

All actively maintained packages are now compliant with `policy.platform` (iOS 18+ / macOS 15+ / tvOS 18+ / watchOS 11+ / visionOS 2+).

## Improvement Queue

| Priority | Package | Item | Impact | Phase |
|----------|---------|------|--------|-------|
| 🔴 High | AnvilMacros | `@Benchmark` macro is a stub — no timing or reporting | 8 | 9.1 |
| 🔴 High | GoldenPath | RESULT.md claims AnvilCore/AnvilMacros deps that don't exist in Package.swift | 5 | 9.3 |
| 🟡 Medium | All packages | Swift 6 language mode inconsistency across repos | 4 | 9.2 |
| 🟡 Medium | AnvilCore | Zero packages depend on it — needs adoption | 6 | 8.5 |
| 🟡 Medium | swiftanvil-meta | PMS framework documented but not implemented | 5 | 9.4 |
| 🟢 Low | AnvilProject | README examples | 3 | — |
| 🟢 Low | swiftanvil-example-swiftui | Missing DocC catalog | 2 | — |
