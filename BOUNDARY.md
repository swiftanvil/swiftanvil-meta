# SwiftAnvil ↔ iStudio Boundary

> Canonical separation of concerns between the SwiftAnvil toolkit and the iStudio orchestration runtime.

---

## One-Sentence Summary

**SwiftAnvil defines the rules. iStudio enforces them through orchestration.**

---

## Product Relationship

| Aspect | SwiftAnvil | iStudio |
|--------|-----------|---------|
| **Role** | Toolkit + standards | Orchestration runtime |
| **Defines** | What code should look like | When and how work happens |
| **Consumes** | Nothing from iStudio | SwiftAnvil CLI, policy docs, reusable workflows |
| **Dependency arrow** | None | `iStudio → swiftanvil-anvil-runner` (already true) |
| **User sees** | `swiftanvil lint`, `swiftanvil create` | `istudio goal start`, worker sessions, chain status |

---

## Repository Independence

SwiftAnvil and iStudio remain separate GitHub organizations/repositories:

- **SwiftAnvil**: `github.com/swiftanvil` — Swift packages, CLI, policy docs, reusable workflows
- **iStudio**: Independent repo — Orchestration kernel, task DAGs, credential system, worker dispatch

**Why separate:**
- SwiftAnvil packages can be used without iStudio (standalone SPM packages)
- iStudio can orchestrate non-SwiftAnvil projects (any Apple-platform repo)
- Different release cycles, different governance models

---

## What SwiftAnvil Owns

| Concern | Examples | CLI Command |
|---------|----------|-------------|
| **Swift code quality** | No `#available`, DocC on public APIs, Swift 6 strict concurrency | `swiftanvil lint source` |
| **Platform policy** | iOS 18+, macOS 15+, API modernization matrix | `swiftanvil lint package` |
| **Project scaffolding** | `Package.swift`, README, .gitignore, CI workflow, pre-commit hook | `swiftanvil create`, `swiftanvil adopt` |
| **Build tooling** | Build graph optimization, binary size analysis, cache efficiency | `swiftanvil build optimize` |
| **Distribution** | TestFlight upload, App Store submission, metadata validation | `swiftanvil distribute testflight` |
| **Documentation** | DocC generation, registry composition, preview server | `swiftanvil docs generate` |
| **Reusable CI** | `swift-lint.yml`, `swift-ci.yml`, `document-registry-policy.yml` | GHA `workflow_call` |
| **AI agent support** | Context packet generation, auto-generated AGENTS.md, review packets | `swiftanvil agent context` |

---

## What iStudio Owns

| Concern | Examples |
|---------|----------|
| **Task orchestration** | Goal workflow, plan → execute → verify → document |
| **Worker dispatch** | Multi-machine execution, capability-based routing, Xcode worker delegation |
| **Credential management** | Lease-based secrets, synthetic homes, vault permissions |
| **Review orchestration** | Cross-host review scheduling, review bus, failover providers |
| **Runtime state** | Task state machine, event log, chain progress, decision inbox |
| **Goal discovery** | Next-goal recommendation, architecture-refresh candidates, drift detection |
| **Field project profile** | `.istudio/profile.yaml` — project identity, build commands, secret scopes |

---

## Integration Contract

### iStudio's `.istudio/profile.yaml` for SwiftAnvil Projects

```yaml
project:
  name: MyApp
  type: ios-app

  swiftanvil:
    enabled: true
    lint: true
    adopt: false
    platform_policy:
      source: swiftanvil/swiftanvil-meta
      document: policy.platform
      ref: main

  build:
    command: swift build
    test: swift test
    lint: swiftanvil lint

  ci_template: swiftanvil/swiftanvil-enforcement/.github/workflows/swift-ci.yml@v1
```

### iStudio Calls SwiftAnvil

```swift
// In IStudioValidation — SwiftAnvilLintValidator
struct SwiftAnvilLintValidator {
    func validate(repo: URL) async throws -> ValidationResult {
        guard FileManager.default.fileExists(
            atPath: repo.appendingPathComponent("Package.swift").path
        ) else {
            return .skipped(reason: "No Package.swift")
        }
        // Shell out to swiftanvil lint
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/swiftanvil")
        process.arguments = ["lint", "source"]
        process.currentDirectoryURL = repo
        // ... capture output, map to ValidationIssue
    }
}
```

### iStudio CI Calls SwiftAnvil Reusable Workflow

```yaml
# iStudio-generated ci.yml for a Swift field project
jobs:
  ci:
    uses: swiftanvil/swiftanvil-enforcement/.github/workflows/swift-ci.yml@v1
    with:
      swiftanvil-version: '0.3.0'
      fail-on-warning: true
      enable-registry-check: false
```

---

## What is NOT Shared

| SwiftAnvil does NOT... | iStudio does NOT... |
|------------------------|---------------------|
| Manage task state or worker dispatch | Define Swift platform policy or API modernization rules |
| Handle credential leases or vaults | Generate `Package.swift` or scaffold Swift projects |
| Schedule cross-host reviews | Run `swiftanvil lint` — it calls it |
| Maintain chain progress or decision inbox | Own DocC conventions or `#available` bans |
| Dispatch to remote Xcode workers | Define binary size budgets or build optimization rules |

---

## Redirect Rules for Future Development

When someone proposes a feature, use this table:

| If the feature is about... | It belongs in... |
|---|---|
| Swift code style, platform versions, API modernization | **SwiftAnvil** |
| DocD conventions, README templates, .gitignore rules | **SwiftAnvil** |
| Build optimization, binary size, cache efficiency | **SwiftAnvil** |
| TestFlight upload, App Store submission, metadata validation | **SwiftAnvil** |
| Performance profiling, logging audit, accessibility check | **SwiftAnvil** |
| Task orchestration, goal workflow, chain state | **iStudio** |
| Worker dispatch, multi-machine execution, capability routing | **iStudio** |
| Credential leases, vault management, synthetic homes | **iStudio** |
| Cross-host review scheduling, review bus, failover | **iStudio** |
| When to run lint, when to submit to TestFlight | **iStudio** (orchestrates timing) |
| What lint checks, what metadata to validate | **SwiftAnvil** (defines content) |

---

## Enforcement Mechanisms

### 1. PR Template Checklist

**SwiftAnvil PRs:**
```markdown
## Boundary Check
- [ ] This change does not introduce orchestration logic (task state, worker dispatch, credentials)
- [ ] If this adds CI workflow, it uses `swiftanvil-enforcement` reusable workflows
- [ ] If this adds validation, it's Swift-specific (not generic project orchestration)
```

**iStudio PRs:**
```markdown
## Boundary Check
- [ ] This change does not introduce Swift-specific policy (platform versions, API modernization, DocC rules)
- [ ] If this adds Swift project support, it shells out to `swiftanvil` CLI rather than reimplementing
- [ ] If this adds field project scaffolding, it references SwiftAnvil docs rather than duplicating
```

### 2. Lint Rules (Future)

- **SwiftAnvil lint**: Detect orchestration vocabulary (`task state`, `worker dispatch`, `credential lease`) in SwiftAnvil source → flag as leak
- **iStudio validation**: Detect Swift policy vocabulary (`#available`, `platform matrix`, `DocC catalog`) in iStudio source → flag as leak

### 3. Cross-Host Review Gate

Reviewer must explicitly check:
- "Does this PR introduce orchestration logic into SwiftAnvil?"
- "Does this PR duplicate SwiftAnvil policy in iStudio?"
- Verdict: `NEEDS_REVISION` if boundary is violated

---

## Version History

| Date | Change |
|------|--------|
| 2026-06-05 | Initial boundary document |
