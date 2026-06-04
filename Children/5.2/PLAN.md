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

Planned.

## Goal

Add an extensible plugin architecture to the `swiftanvil` CLI so third-party developers can register custom
generators, commands, and hooks without modifying the core codebase.

## Scope

- Define a `SwiftAnvilPlugin` protocol that plugins conform to.
- Support dynamic loading of plugins from Swift Package Manager dependencies.
- Allow plugins to register:
  - New `swiftanvil` subcommands
  - New project generators
  - New template filters/functions
  - Lifecycle hooks (pre-generate, post-generate)
- Build 1–2 example plugins to validate the architecture.
- Document the plugin API and distribution model.

## Non-Goals

- Do not support runtime-downloaded plugins (security risk).
- Do not support non-Swift plugins.
- Do not build a plugin marketplace.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `SwiftAnvilPlugin` protocol | swiftanvil-cli | Core plugin interface |
| Plugin loader | swiftanvil-cli | Scans `Package.swift` plugin dependencies, loads at runtime |
| Plugin manifest | swiftanvil-cli | `anvil-plugin.yml` in plugin package root |
| Example: DocC plugin | New repo | Auto-generates DocC catalog from source comments |
| Example: Lint plugin | New repo | Runs `swiftlint` / `swift-format` on generated projects |
| Plugin API docs | swiftanvil-meta | `Children/5.2/PLUGIN_API.md` |

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
    
    /// Called during CLI startup to register commands and generators.
    func register(with registry: PluginRegistry) async throws
}

/// Registry that plugins use to hook into the CLI.
public actor PluginRegistry {
    public func registerCommand(_ command: any PluginCommand)
    public func registerGenerator(_ generator: any PluginGenerator)
    public func registerTemplateFilter(_ filter: any TemplateFilter)
    public func registerHook(_ hook: LifecycleHook, action: @escaping () async throws -> Void)
}
```

## Plugin Manifest

```yaml
# anvil-plugin.yml
plugin:
  identifier: com.example.swiftanvil.docc
  entryPoint: DocCPlugin
  minimumCLIVersion: "1.0.0"
  dependencies: []
```

## How Plugins Work

1. User adds plugin to their project's `Package.swift`:
   ```swift
   .package(url: "https://github.com/example/swiftanvil-docc-plugin", from: "1.0.0")
   ```
2. CLI scans `.build/checkouts` for `anvil-plugin.yml` files.
3. CLI loads the plugin's module and instantiates the entry point.
4. Plugin registers its commands/generators/hooks via `PluginRegistry`.
5. CLI includes plugin contributions in help text and command dispatch.

## Success Criteria

- A third-party developer can create a plugin in < 30 minutes using the example template.
- Plugin commands appear in `swiftanvil --help`.
- Plugin generators appear in `swiftanvil generate --list`.
- Lifecycle hooks fire in the correct order.
- Plugin loading failures are isolated — one bad plugin does not crash the CLI.

## Dependencies

- `planning.child-3.1` (Wizard System) — plugins may add interactive prompts.
- `planning.child-3.2` (Template Engine) — plugins may add template filters.
- `planning.child-3.3` (Project Generator) — plugins may add generators.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | Protocol design, security model, loading mechanism |
| Impl | Cross-host agent | Error isolation, registry performance, example quality |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Plugin ABI breaks on CLI updates | Medium | Version the protocol; CLI warns on incompatible plugins |
| Plugin loading crashes CLI | Low | Catch and log plugin errors; disable failing plugins |
| Complex plugin dependency graphs | Low | Plugins are SPM packages — SPM handles resolution |
