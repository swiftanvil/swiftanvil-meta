---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 5
child: 5.2
last_updated: 2026-06-04
---

# Child 5.2 Plan: Plugin System

## Status

Planned. Revised per cross-host review (NEEDS_REVISION → addressed).

## Goal

Add an extensible plugin architecture to the `swiftanvil` CLI so third-party developers can register custom
generators, commands, and hooks without modifying the core codebase.

## Scope

- Define a `SwiftAnvilPlugin` protocol and supporting types.
- Support **compile-time SPM dependency** loading (v1). Plugins are SPM packages that the CLI depends on.
- Allow plugins to register:
  - New `swiftanvil` subcommands (via `PluginCommand` protocol)
  - New project generators (via `PluginGenerator` protocol)
  - New template filters (via `PluginTemplateFilter` protocol)
  - Lifecycle hooks (pre-generate, post-generate) with context
- Build 2 minimal example plugins (Echo, Counter) to validate the architecture.
- Document the plugin API and distribution model.

## Non-Goals

- Do not support runtime-downloaded plugins (security risk).
- Do not support non-Swift plugins.
- Do not build a plugin marketplace.
- Do not support dynamic loading via `dlopen` in v1 (deferred to later child).

## Loading Model (v1: Compile-Time SPM Dependency)

Plugins are regular SPM packages. The CLI's `Package.swift` declares them as dependencies:

```swift
// swiftanvil-cli/Package.swift
.package(url: "https://github.com/example/swiftanvil-echo-plugin", from: "1.0.0")
```

The CLI's main target imports the plugin modules and instantiates them:

```swift
import EchoPlugin
let plugins: [any SwiftAnvilPlugin] = [EchoPlugin()]
for plugin in plugins {
    try await plugin.register(with: registry, configuration: config)
}
```

This is the only approach guaranteed to work with Swift 6 + StrictConcurrency. Runtime loading is deferred.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `SwiftAnvilPlugin` protocol | swiftanvil-cli | Core plugin interface |
| `PluginCommand` protocol | swiftanvil-cli | Command registration interface |
| `PluginGenerator` protocol | swiftanvil-cli | Generator registration interface |
| `PluginTemplateFilter` protocol | swiftanvil-cli | Template filter registration |
| `PluginRegistry` actor | swiftanvil-cli | Registration hub with conflict resolution |
| `PluginConfiguration` struct | swiftanvil-cli | FileSystem, logger, working directory |
| `LifecycleHook` enum + `HookContext` | swiftanvil-cli | Pre/post generate with context |
| `anvil-plugin.yml` schema | swiftanvil-cli | Manifest with moduleName, platforms, capabilities |
| Echo example plugin | New repo | `swiftanvil echo <message>` command |
| Counter example plugin | New repo | Template filter `{{ count }}` |
| Plugin API docs | swiftanvil-meta | `Children/5.2/PLUGIN_API.md` |
| Tests | swiftanvil-cli | `PluginRegistryTests`, `PluginLoaderTests`, `HookTests` |

## Plugin Protocol Design

```swift
/// A plugin that extends swiftanvil CLI capabilities.
public protocol SwiftAnvilPlugin: Sendable {
    /// Unique plugin identifier (reverse-DNS style).
    static var identifier: String { get }
    
    /// Human-readable name.
    static var displayName: String { get }
    
    /// Plugin version.
    static var version: String { get }
    
    /// Called during CLI startup to register commands, generators, filters, and hooks.
    func register(with registry: PluginRegistry, configuration: PluginConfiguration) async throws
}

/// Configuration passed to plugins during registration.
public struct PluginConfiguration: Sendable {
    public let fileSystem: any FileSystem
    public let workingDirectory: URL
    
    public init(fileSystem: any FileSystem, workingDirectory: URL) {
        self.fileSystem = fileSystem
        self.workingDirectory = workingDirectory
    }
}

/// A command registered by a plugin.
public protocol PluginCommand: Sendable {
    var name: String { get }
    var description: String { get }
    func run(arguments: [String]) async throws
}

/// A generator registered by a plugin.
public protocol PluginGenerator: Sendable {
    var name: String { get }
    var description: String { get }
    func generate(projectName: String, options: [String: String]) async throws
}

/// A template filter registered by a plugin.
public protocol PluginTemplateFilter: Sendable {
    var name: String { get }
    func apply(_ value: String) -> String
}

/// Lifecycle hook types.
public enum LifecycleHook: Sendable {
    case preGenerate
    case postGenerate
}

/// Context passed to lifecycle hooks.
public struct HookContext: Sendable {
    public let projectName: String
    public let projectPath: URL
    public let generatorName: String
    
    public init(projectName: String, projectPath: URL, generatorName: String) {
        self.projectName = projectName
        self.projectPath = projectPath
        self.generatorName = generatorName
    }
}

/// Registry that plugins use to hook into the CLI.
public actor PluginRegistry {
    public func registerCommand(_ command: any PluginCommand) throws
    public func registerGenerator(_ generator: any PluginGenerator) throws
    public func registerTemplateFilter(_ filter: any PluginTemplateFilter) throws
    public func registerHook(
        _ hook: LifecycleHook,
        priority: HookPriority = .normal,
        action: @Sendable @escaping (HookContext) async throws -> Void
    ) throws
    
    public func commands() -> [any PluginCommand]
    public func generators() -> [any PluginGenerator]
    public func filters() -> [any PluginTemplateFilter]
    public func hooks(for hook: LifecycleHook) -> [HookEntry]
}

public enum HookPriority: Int, Sendable {
    case low = 0
    case normal = 1
    case high = 2
}

public struct HookEntry: Sendable {
    public let priority: HookPriority
    public let action: @Sendable (HookContext) async throws -> Void
}

public enum PluginRegistryError: Error, Sendable {
    case duplicateCommand(String)
    case duplicateGenerator(String)
    case duplicateFilter(String)
}
```

## Plugin Manifest (`anvil-plugin.yml`)

```yaml
plugin:
  identifier: com.example.swiftanvil.echo
  moduleName: EchoPlugin
  productName: EchoPlugin
  version: 1.0.0
  minimumCLIVersion: "1.0.0"
  platforms:
    - macOS 15+
  capabilities:
    - filesystem
  entryPoint: EchoPlugin
```

### Manifest Field Rules

| Field | Required | Type | Validation |
|-------|----------|------|------------|
| `identifier` | Yes | String | Reverse-DNS, max 100 chars |
| `moduleName` | Yes | String | Valid Swift module name |
| `productName` | No | String | Defaults to `moduleName` |
| `version` | Yes | String | Valid SemVer |
| `minimumCLIVersion` | Yes | String | Valid SemVer |
| `platforms` | Yes | [String] | Subset of SwiftAnvil platform policy |
| `capabilities` | No | [String] | `filesystem`, `subprocess`, `network` |
| `entryPoint` | Yes | String | Type name conforming to `SwiftAnvilPlugin` |

## Security Requirements

- Plugins are compile-time SPM dependencies only — no runtime code loading.
- Plugin commands are namespaced: `swiftanvil <plugin-identifier>:<command-name>`.
- Conflict resolution: duplicate names throw `PluginRegistryError` during registration.
- Error isolation: a plugin whose `register` throws is logged and skipped; remaining plugins load.
- No arbitrary code execution: plugins run within the CLI process with the same privileges.

## Success Criteria

- [ ] Example plugin repo (`swiftanvil-echo-plugin`) builds with `swift build` and passes `swift test` after following `PLUGIN_API.md` alone.
- [ ] `PluginRegistry` accepts command/generator/filter/hook registrations without conflicts.
- [ ] Duplicate command names throw `PluginRegistryError.duplicateCommand`.
- [ ] Pre-generate hooks run in priority order before `ProjectGenerator.generate`; post-generate hooks run after.
- [ ] A plugin whose `register` throws is logged and skipped; remaining plugins load; CLI exits 0.
- [ ] Plugin commands are namespaced as `swiftanvil <plugin-identifier>:<command-name>`.
- [ ] Test coverage ≥ 80% for `PluginRegistry`, `PluginLoader`, and hook execution.
- [ ] `PLUGIN_API.md` enables a new developer to create a plugin in < 30 minutes.

## Dependencies

- `planning.child-3.1` (Wizard System) — plugins may add interactive prompts.
- `planning.child-3.2` (Template Engine) — plugins may add template filters.
- `planning.child-3.3` (Project Generator) — plugins may add generators.
- `planning.child-5.1` (Community Templates) — manifest validation patterns reused.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | Loading model feasibility, protocol completeness, test strategy |
| Impl | Cross-host agent | Registry concurrency, error isolation, example quality |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Plugin ABI breaks on CLI updates | Medium | Version the protocol; CLI warns on incompatible plugins |
| Plugin registration crashes CLI | Low | Catch and log plugin errors; disable failing plugins |
| Complex plugin dependency graphs | Low | Plugins are SPM packages — SPM handles resolution |
| Compile-time linking feels limiting | Medium | Document as v1; runtime loading deferred to later child |
