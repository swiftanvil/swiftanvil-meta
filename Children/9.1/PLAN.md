# Child 9.1 Plan: Real `@Benchmark` Macro

## Context

- **Phase:** 9
- **Child:** 9.1
- **Repo:** `swiftanvil-anvil-macros`
- **Goal:** Fix the stub `@Benchmark` macro so it actually measures timing and reports statistics.

## Current State

The macro generates:
```swift
func benchmark_compute() {
    for _ in 0..<1000 {
        _ = compute()
    }
}
```

This calls the function N times but does **no timing, no stats, no reporting**.

## Proposed Solution

The macro should generate a wrapper that:
1. Captures `CFAbsoluteTimeGetCurrent()` before/after each iteration
2. Collects all iteration times into an array
3. Computes min, mean, median, stddev
4. Returns a `BenchmarkResult` struct with the stats

### Generated Code

```swift
@Benchmark(iterations: 1000)
func compute() -> Int { 42 }

// Expands to:
func benchmark_compute() -> BenchmarkMacroResult {
    let iterations = 1000
    var times: [Double] = []
    times.reserveCapacity(iterations)
    
    for _ in 0..<iterations {
        let start = CFAbsoluteTimeGetCurrent()
        _ = compute()
        let end = CFAbsoluteTimeGetCurrent()
        times.append(end - start)
    }
    
    return BenchmarkMacroResult(
        functionName: "compute",
        iterations: iterations,
        times: times
    )
}
```

### New Types (in AnvilMacros library)

```swift
public struct BenchmarkMacroResult: Sendable {
    public let functionName: String
    public let iterations: Int
    public let times: [Double]
    
    public var min: Double { times.min() ?? 0 }
    public var mean: Double { times.reduce(0, +) / Double(times.count) }
    public var median: Double { /* sorted middle */ }
    public var stddev: Double { /* population stddev */ }
}
```

## Implementation Steps

1. Add `BenchmarkMacroResult.swift` to `Sources/AnvilMacros/` (public API)
2. Update `BenchmarkMacro.swift` in `Sources/AnvilMacrosPlugin/`:
   - Generate timing capture code
   - Generate `BenchmarkMacroResult` return
   - Handle functions with parameters (skip — macro only works on zero-arg functions)
   - Handle `throws` functions (wrap in do-catch, report errors)
   - Handle `async` functions (await the call)
3. Update `Benchmark.swift` (public macro declaration) with new doc comments
4. Update tests:
   - Test default iterations with timing code
   - Test custom iterations
   - Test `throws` function handling
   - Test `async` function handling
   - Test `BenchmarkMacroResult` stats computation
5. Run `swift build` + `swift test`
6. Update `Children/9.1/RESULT.md`
7. Update `ROADMAP.md`
8. Commit and push

## Files to Modify

| File | Action |
|------|--------|
| `Sources/AnvilMacros/Benchmark.swift` | Update doc comments |
| `Sources/AnvilMacros/BenchmarkMacroResult.swift` | **New** — result type |
| `Sources/AnvilMacrosPlugin/BenchmarkMacro.swift` | **Rewrite** — generate timing + stats code |
| `Tests/AnvilMacrosTests/BenchmarkMacroTests.swift` | **Update** — new expected expansions |

## Test Plan

- `testDefaultIterationsWithTiming` — macro generates timing code
- `testCustomIterations` — custom iteration count in generated code
- `testThrowsFunction` — generated code handles throws
- `testAsyncFunction` — generated code uses await
- `testResultStats` — BenchmarkMacroResult computes correct stats

## Risks

| Risk | Mitigation |
|------|------------|
| Macro expansion becomes complex | Keep it simple: timing array + basic stats |
| CFAbsoluteTimeGetCurrent not available | It's in CoreFoundation, always available |
| Breaking existing API | `benchmark_` function now returns `BenchmarkMacroResult` instead of `Void` — this is the intended fix |
