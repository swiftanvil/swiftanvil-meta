---
priority: HIGH
type: RESULT
audience: REVIEWER
phase: 9
child: 9.1
last_updated: 2026-06-05
---

# Child 9.1 Result: Real `@Benchmark` Macro

## Status

**COMPLETE**

## Summary

Rewrote the `@Benchmark` macro from a stub into a real benchmarking tool that captures timing per iteration and reports statistics.

## Changes

| File | Change |
|------|--------|
| `Sources/AnvilMacros/Benchmark.swift` | Updated doc comments to reflect new behavior |
| `Sources/AnvilMacros/BenchmarkMacroResult.swift` | **New** — result type with min/max/mean/median/stddev/totalElapsed |
| `Sources/AnvilMacrosPlugin/BenchmarkMacro.swift` | **Rewritten** — generates timing capture code |
| `Tests/AnvilMacrosTests/BenchmarkMacroTests.swift` | **Updated** — 10 new tests |

## Before (Stub)

```swift
func benchmark_compute() {
    for _ in 0..<1000 { _ = compute() }
}
```

## After (Real)

```swift
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
    return BenchmarkMacroResult(functionName: "compute", iterations: iterations, times: times)
}
```

## Supported Function Types

- Regular: `func f() -> T`
- `async`: `func f() async -> T`
- `throws`: `func f() throws -> T` (errors caught, iteration still timed)
- `async throws`: `func f() async throws -> T`

## BenchmarkMacroResult API

```swift
let result = benchmark_compute()
print(result.min)      // fastest iteration
print(result.mean)     // average
print(result.median)   // median
print(result.stddev)   // standard deviation
print(result.totalElapsed) // total time
print(result)          // pretty-printed summary
```

## Verification

- [x] `swift build` succeeds
- [x] `swift test` passes (12 tests: 5 macro expansion + 5 result stats + 2 existing injectable)
- [x] All function variants tested (sync, async, throws, async+throws)
- [x] Stats computation verified mathematically

## Test Results

```
Test run with 12 tests in 3 suites passed after 0.039 seconds.
```

## Commit

- `swiftanvil-anvil-macros`: feat: real @Benchmark macro with timing and stats (Child 9.1)
