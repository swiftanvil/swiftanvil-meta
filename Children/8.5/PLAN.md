# Child 8.5 Plan: AnvilCore Integration into Existing Packages

## Context

- **Phase:** 8
- **Child:** 8.5
- **Scope:** Add `AnvilCore` as a dependency to packages that would benefit from it
- **Goal:** AnvilCore is currently unused (0 packages depend on it). Integrate it into packages where it provides real value.

## Target Packages & Integration Points

| Package | AnvilCore Type | Integration | Why |
|---------|---------------|-------------|-----|
| **AnvilNetwork** | `AnvilLogger` | Replace any `print` statements with structured logging | Network requests/responses should be logged consistently |
| **AnvilFlags** | `AnvilConfiguration` | Add as a `FeatureFlagSource` backend | Configuration store is a natural backend for flags |
| **AnvilDevMenu** | `AnvilLogger` | Use for unified log collection | Dev menu collects logs; AnvilLogger provides structured logs |
| **BenchmarkKit** | `AnvilTask` | Use for async benchmark execution | Concurrent benchmark tasks should use AnvilTask wrapper |

## What AnvilCore Provides

- `AnvilLogger` (actor) — 5 levels (trace/debug/info/warn/error), `allEntries`, `clear`
- `AnvilConfiguration` (actor) — `set(_:value:)`, `get<T>(_:)`, `remove`, `keys`, `clear`
- `AnvilTask<T>` (struct, Sendable) — `id: UUID`, `label: String`, `value` async property

## Implementation Plan

### 1. AnvilNetwork + AnvilLogger
- Add `AnvilCore` dependency to `Package.swift`
- Add `AnvilLogger` property to `HTTPClient` or `HTTPClientCore`
- Log requests at `.info` level, responses at `.debug`, errors at `.error`
- Add tests verifying logs are captured

### 2. AnvilFlags + AnvilConfiguration
- Add `AnvilCore` dependency to `Package.swift`
- Create `ConfigurationFeatureFlagSource: FeatureFlagSource` that wraps `AnvilConfiguration`
- Add to `FeatureFlagSystem` source chain
- Add tests for configuration-backed flags

### 3. AnvilDevMenu + AnvilLogger
- Add `AnvilCore` dependency to `Package.swift`
- Replace `LogCollector` with `AnvilLogger` or bridge them
- Dev menu reads from `AnvilLogger.allEntries` instead of its own storage
- Add tests for log integration

### 4. BenchmarkKit + AnvilTask
- Add `AnvilCore` dependency to `Package.swift`
- Use `AnvilTask<BenchmarkResult>` for async benchmark runs
- Add tests for task-based benchmark execution

## Files to Modify

| Repo | Files |
|------|-------|
| swiftanvil-anvil-network | `Package.swift`, `HTTPClient.swift` or `HTTPClientCore.swift`, tests |
| swiftanvil-anvil-flags | `Package.swift`, new `ConfigurationFeatureFlagSource.swift`, tests |
| swiftanvil-anvil-devmenu | `Package.swift`, `LogCollector.swift`, tests |
| swiftanvil-anvil-bench | `Package.swift`, `BenchmarkRun.swift` or similar, tests |

## Test Plan

- Each modified package: `swift build` + `swift test` must pass
- New tests for each integration point
- No regressions in existing tests

## Risks

| Risk | Mitigation |
|------|------------|
| Circular dependencies | AnvilCore has no dependencies, so safe |
| Breaking API changes | Only additive changes; no existing API removed |
| Test failures from new deps | Run full test suite after each change |

## Approach

**Option A: Integrate into all 4 packages in sequence** (Recommended)
- Highest impact — AnvilCore gets real adoption across the ecosystem
- Proves the core package's API design

**Option B: Integrate into 1–2 packages only**
- Lower risk but less value
- AnvilCore remains underutilized

## Decision

Proceed with **Option A** — integrate AnvilCore into all 4 packages. This justifies AnvilCore's existence and provides real value.
