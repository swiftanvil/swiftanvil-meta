# Child 10.1 — Build Optimizer

## Goal

Implement `swiftanvil build optimize` to analyze Swift package build graphs, detect inefficiencies, and suggest concrete optimizations.

## Scope

1. **Build Graph Analysis**
   - Parse `Package.swift` to extract target dependency graph
   - Identify circular dependencies
   - Measure dependency depth

2. **Module Splitting Suggestions**
   - Detect large targets (> 50 source files)
   - Suggest splitting by public API surface
   - Recommend extracting pure utility modules

3. **Redundant Rebuild Detection**
   - Check for targets that rebuild on every `swift build`
   - Identify missing `ENABLE_INCREMENTAL_BUILD` settings
   - Detect over-broad `sources` declarations

4. **WMO vs Incremental Recommendation**
   - Analyze target size and dependency fan-out
   - Recommend WMO for small leaf targets
   - Recommend incremental for large root targets

## Deliverables

| Deliverable | Location |
|---|---|
| `BuildCommand.swift` | `swiftanvil-cli/Sources/SwiftAnvilCLI/Commands/` |
| `BuildOptimizer.swift` | `swiftanvil-cli/Sources/SwiftAnvilCLI/Build/` |
| Tests | `swiftanvil-cli/Tests/SwiftAnvilCLITests/` |
| Result document | `Children/10.1/RESULT.md` |

## CLI Design

```bash
swiftanvil build optimize [--path <dir>] [--format json|table]
```

Output categories:
- `graph` — dependency graph analysis
- `splitting` — module splitting suggestions
- `rebuild` — redundant rebuild detection
- `wmo` — WMO vs incremental recommendations

## Registry References

- `roadmap.org` — Phase 10 horizon 1
