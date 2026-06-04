---
priority: HIGH
type: REVIEW
audience: BUILDER
phase: 5
child: 5.2
reviewer: Cross-host (Claude)
last_updated: 2026-06-04
---

# Child 5.2 Plan Review: Plugin System (Revised)

## Summary

The revised plan addresses all three blockers from the initial review:
1. **Loading model** — Now specifies compile-time SPM dependency linking, which is feasible with Swift 6 + StrictConcurrency.
2. **Protocol surface** — `PluginCommand`, `PluginGenerator`, `PluginTemplateFilter`, `HookContext`, and `PluginConfiguration` are all fully defined with `Sendable` requirements.
3. **Test strategy** — Success criteria now include verifiable statements and coverage targets.

## Strengths

1. **Compile-time linking is the right v1 choice.** It avoids all dynamic loading complexity while still enabling third-party extensibility.
2. **Full protocol definitions.** Every referenced type is now specified with protocols, associated types, and `Sendable` requirements.
3. **PluginConfiguration enables testability.** Injecting `FileSystem` and `workingDirectory` means plugins can be tested with `InMemoryFileSystem`.
4. **Hook context and priority.** `HookContext` with `projectName`, `projectPath`, and `generatorName` makes hooks useful. Priority levels enable ordering.
5. **Conflict resolution specified.** `PluginRegistryError.duplicateCommand` is a clear, testable behavior.
6. **Error isolation criterion is verifiable.** "A plugin whose `register` throws is logged and skipped; remaining plugins load; CLI exits 0" can be tested in CI.
7. **Aligned with Child 5.1.** Manifest schema reuses validation patterns; namespacing follows the same reverse-DNS convention.

## Concerns

### 1. `PluginRegistry` Hook Storage (Minor)

`HookEntry` stores a `@Sendable` closure. Under Swift 6 StrictConcurrency, storing a closure in an actor property is fine if the closure is `@Sendable`, which it is. However, the `hooks(for:)` method returns `[HookEntry]` — calling the closure after retrieval requires the caller to be in an async context. This is acceptable but should be documented.

### 2. `PluginCommand.run(arguments:)` Is Untyped

`[String]` arguments are simple but error-prone. A future version might want `ArgumentParser` integration. For v1, this is acceptable.

### 3. No Plugin Unloading

Once registered, a plugin cannot be unloaded. This is fine for v1 but should be noted as a known limitation.

## Suggestions

1. **Add `PluginLoader` type.** Instead of the CLI manually instantiating plugins, define a `PluginLoader` that scans a configured list of plugin types and handles error isolation:
   ```swift
   public actor PluginLoader {
       public func load(plugins: [any SwiftAnvilPlugin.Type], registry: PluginRegistry, configuration: PluginConfiguration) async
   }
   ```
   This centralizes error isolation and makes it testable.

2. **Document the `FileSystem` protocol requirement.** `PluginConfiguration` uses `any FileSystem` — this is presumably `AnvilProject`'s `FileSystem` protocol. The plan should explicitly state this dependency.

## Verdict

**APPROVED_WITH_NOTES**

The revised plan is comprehensive, feasible, and aligned with SwiftAnvil's standards. The two notes above are minor and can be addressed during implementation. Proceed to EXECUTE.
