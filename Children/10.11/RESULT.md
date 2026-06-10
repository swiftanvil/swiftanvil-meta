# Child 10.11 — Performance Profiler: Result

## Status: Deferred ⏸️

## What Was Planned

### `swiftanvil perf profile`

Wrap `xcrun xctrace`, generate flame graphs, detect main thread blocking.

## Why Deferred

Requires **Instruments/xctrace** which is only available on macOS with Xcode installed. The trace recording and symbolication pipeline is substantial and best implemented when there is a concrete profiling need.

## Registry References

- `roadmap.org` — Phase 10 horizon 3
