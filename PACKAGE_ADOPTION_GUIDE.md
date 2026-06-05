# SwiftAnvil Package Adoption Guide

> How to add SwiftAnvil packages to your existing Swift project.

---

## Quick Start

Add to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swiftanvil/swiftanvil-anvil-network.git", from: "1.0.0"),
    .package(url: "https://github.com/swiftanvil/swiftanvil-anvil-flags.git", from: "1.0.0"),
    .package(url: "https://github.com/swiftanvil/swiftanvil-anvil-a11y.git", from: "1.0.0"),
]
```

Then add products to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "AnvilNetwork", package: "swiftanvil-anvil-network"),
        .product(name: "AnvilFlags", package: "swiftanvil-anvil-flags"),
        .product(name: "A11yIdentifiers", package: "swiftanvil-anvil-a11y"),
    ]
)
```

---

## Package Reference

### Networking

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilNetwork** | `import AnvilNetwork` | Type-safe HTTP client with caching, retry, observability | 18 | 15 |

```swift
import AnvilNetwork

let client = HTTPClient(configuration: .default)
let data = try await client.get("https://api.example.com/data")
```

### Feature Flags

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilFlags** | `import AnvilFlags` | Type-safe feature flags with A/B test support | 18 | 15 |

```swift
import AnvilFlags

@FeatureFlag("new_ui", default: false)
var isNewUIEnabled: Bool

if isNewUIEnabled {
    // Show new UI
}
```

### Accessibility

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **A11yIdentifiers** | `import A11yIdentifiers` | Typed accessibility identifiers for SwiftUI/UIKit | 18 | 15 |

```swift
import A11yIdentifiers

Text("Hello")
    .accessibilityIdentifier(A11yIdentifiers.Home.greeting)
```

### Settings / UserDefaults

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilSettings** | `import AnvilSettings` | Type-safe UserDefaults with `@AnvilSetting` wrapper | 18 | 15 |

```swift
import AnvilSettings

@AnvilSetting("api_endpoint", default: "https://api.example.com")
var apiEndpoint: String
```

### Localization

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AppStrings** | `import AppStrings` | Type-safe localized string keys | 18 | 15 |

```swift
import AppStrings

Text(AppStrings.Common.save)
```

### Benchmarking

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **BenchmarkKit** | `import BenchmarkKit` | Structured benchmarking with SwiftUI dashboards | 18 | 15 |

```swift
import BenchmarkKit

@Benchmark(iterations: 1000)
func measureSorting() {
    let array = (0..<1000).shuffled()
    _ = array.sorted()
}
```

### Developer Tools

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilDevMenu** | `import AnvilDevMenu` | In-app debug menu (logs, flags, network inspect) | 18 | 15 |
| **AnvilMenuBar** | `import AnvilMenuBar` | macOS menu bar extras | — | 15 |
| **AnvilWindow** | `import AnvilWindow` | macOS window management (floating, HUD, restoration) | — | 15 |

### Templates & Generation

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilTemplate** | `import AnvilTemplate` | Lightweight template engine with variables, conditionals, loops | 18 | 15 |
| **AnvilWizard** | `import AnvilWizard` | Interactive CLI wizard engine | — | 15 |

### Core Infrastructure

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilCore** | `import AnvilCore` | Shared infrastructure (configuration, logging, tasks) | 18 | 15 |

### Macros

| Package | Import | Purpose | Min iOS | Min macOS |
|---------|--------|---------|---------|-----------|
| **AnvilMacros** | `import AnvilMacros` | Compile-time macros (`@Benchmark`, `@AnvilInjectable`) | 18 | 15 |

---

## Platform Policy

All SwiftAnvil packages target:

- **iOS 18+**
- **macOS 15+**
- **tvOS 18+**
- **watchOS 11+**
- **visionOS 2+**

Swift 6 strict concurrency is required. No `#available` checks — APIs must be available on minimum versions.

---

## Using with SwiftAnvil CLI

If you scaffolded your project with `swiftanvil create`, packages are pre-configured in `Package.swift`. To add more:

```bash
# Edit Package.swift manually, or use swift package add (Swift 6.1+)
swift package add --url https://github.com/swiftanvil/swiftanvil-anvil-network.git --from 1.0.0
```

---

## Version Compatibility

| SwiftAnvil Version | Swift Tools | Platforms |
|-------------------|-------------|-----------|
| 1.x | 6.0+ | iOS 18+, macOS 15+ |

All packages use semantic versioning. Minor versions add features. Major versions may change platforms or Swift requirements.
