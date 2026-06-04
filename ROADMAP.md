# SwiftAnvil Roadmap

> The single source of truth for what we've built, what we're building, and what's next.

---

## 🗺️ At a Glance

| Phase | Theme | Status | Progress |
|-------|-------|--------|----------|
| [Phase 1](#phase-1-foundation) | Foundation | 🟢 Complete | 5/5 |
| [Phase 2](#phase-2-core-packages) | Core Packages | 🟢 Complete | 3/3 |
| [Phase 3](#phase-3-cli--integration) | CLI & Integration | 🟢 Complete | 5/5 |
| [Phase 4](#phase-4-org-intelligence--managed-workers) | Org Intelligence & Managed Workers | 🟡 In Progress | 3/5 |
| [Phase 5](#phase-5-ecosystem--distribution) | Ecosystem & Distribution | ⚪ Planned | 0/3 |

**Current Active Child:** `planning.child-4-4` — Managed Worker Capability Discovery and Doctor.

**Phase Gate Note:** Phase 3 is closed. New implementation should proceed through Phase 4 children in order unless
explicitly re-prioritized.

**Legend:** 🟢 Complete | 🟡 In Progress | 🔴 Blocked | ⚪ Planned

---

## Phase 1: Foundation 🟢

> Extract existing code, establish patterns, create the org.

### 1.1 Research Swift OSS Best Practices ✅

**What we learned:**
- Multi-repo org model (Pointfreeco pattern) — each package is independent
- Swift 6 + StrictConcurrency as baseline
- Swift Testing over XCTest
- DocC for API docs, README for quickstart
- Issue templates + PR templates + CI from day one

**Decision:** `github.com/swiftanvil` as multi-repo org with `anvil-*` package naming.

**Review:** Self-reviewed (research task, not code).

### 1.2 A11yIdentifiers ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-a11y`](https://github.com/swiftanvil/swiftanvil-anvil-a11y) |
| Source | Extracted from Turnip iOS |
| Core Type | `A11yID` — phantom-typed, `Sendable`, `Hashable` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 17/17 pass |
| Review | ✅ Approved (Claude cross-host) |

**Key fixes from review:**
- `#if canImport(UIKit) && !os(watchOS)` guard
- Removed redundant `@available` annotation

### 1.3 BenchmarkKit ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-bench`](https://github.com/swiftanvil/swiftanvil-anvil-bench) |
| Source | Extracted from Turnip iOS, generalized |
| Products | `BenchmarkKit` (core), `BenchmarkKitSwiftUI` (dashboard UI) |
| Core Types | `BenchmarkID<T>`, `BenchmarkRun`, `BenchmarkSample`, `BenchmarkTrendEvaluator`, `BenchmarkTrait` |
| Platforms | iOS 16+, macOS 13+ |
| Tests | 78/78 pass |
| Review | ✅ Approved (Claude cross-host) |

**Key fixes from review:**
- Added `BenchmarkTrait` for `@Test(.benchmark(iterations:))`
- Added comprehensive `package.readme`
- Removed empty `BenchmarkKitSwiftUITests` target
- Removed redundant `StrictConcurrency` flags

### 1.4 AppStrings ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-strings`](https://github.com/swiftanvil/swiftanvil-anvil-strings) |
| Source | Designed from scratch |
| Core Types | `AppString`, `AppStringCatalog`, `AppStringBuilder` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 21/21 pass |
| Review | ✅ Approved (Claude cross-host) |

**Key fixes from review:**
- Added comprehensive `package.readme`
- Removed redundant `StrictConcurrency` flags

### 1.5 GitHub Organization ✅

| Aspect | Detail |
|--------|--------|
| Org | [`github.com/swiftanvil`](https://github.com/swiftanvil) |
| Brand | "⚡ Swift developer tooling forge. We forge the code. You ship it." |
| Repos | 4 code repos + `.github` profile repo |
| Configured | Issue templates, PR template, CI workflow, branch protection, discussions, LICENSE, CONTRIBUTING, CODE_OF_CONDUCT |
| Review | ✅ Approved (Claude cross-host) |

**Key fixes from review:**
- Moved org README to `org.profile-readme`
- Changed repo status from "Stable" → "In Progress"
- Added MIT LICENSE
- Added CI workflow template
- Added PR template
- Added org.contributing + org.code-of-conduct
- Added branch protection to `.github` repo

---

## Phase Gate: 1 → 2

- [x] All Phase 1 children complete
- [x] All Phase 1 children reviewed (code children: cross-host; research: self-reviewed)
- [x] All review blockers fixed
- [x] Phase 1 summary reviewed (Claude cross-host, 2026-06-03)
- [x] **User approval to proceed** — Phase 2 work started (Child 2.1 complete)

---

## Phase 2: Core Packages 🟡

> Build the packages that most apps need.

### 2.1 AnvilNetwork Package ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-network`](https://github.com/swiftanvil/swiftanvil-anvil-network) |
| Source | Designed from scratch |
| Core Types | `HTTPClient`, `HTTPRequestBuilder`, `HTTPResponse`, `HTTPTransport`, `NetworkError`, `HTTPResponseCache`, `RetryConfiguration` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 29/29 pass |
| Review | ✅ Approved (Claude cross-host, 2 rounds: plan + impl) |

**Key design decisions:**
- `HTTPClient` = `Sendable` struct wrapping `actor HTTPClientCore` for safe concurrent access
- Builder-pattern API: `client.get("/users").header("Auth", token).decode()`
- `HTTPTransport` protocol for testability (mock injection)
- Actor-isolated LRU cache with TTL + ETag support
- Exponential backoff with full jitter, respects `Retry-After`
- Interceptor chain: `RequestInterceptor` + `ResponseInterceptor` protocols

### 2.2 FeatureFlags Package ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-flags`](https://github.com/swiftanvil/swiftanvil-anvil-flags) |
| Source | Designed from scratch |
| Core Types | `FeatureFlags`, `FeatureFlagSystem`, `FeatureFlagKey`, `FeatureFlagValue`, `FeatureFlagSource`, `InMemoryFeatureFlagSource`, `JSONFileFeatureFlagSource`, `ABTest`, `StableHashBucketingStrategy` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 37/37 pass |
| Review | ✅ Approved (Claude plan v3, Codex impl — 2 rounds) |

**Key design decisions:**
- `@TaskLocal` for parallel-safe test injection (`withSystem()`)
- `FeatureFlagValueConvertible` protocol — direct unwrap for primitives, JSONDecoder for Decodable
- FNV-1a (pure Swift) for cross-platform A/B bucketing
- Actor-isolated `FeatureFlagSystem` with atomic `configure(sources:)`
- Source priority: first match wins

### 2.3 Developer Menu Package ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-devmenu`](https://github.com/swiftanvil/swiftanvil-anvil-devmenu) |
| Source | Designed from scratch |
| Core Types | `DeveloperMenu`, `DeveloperMenuConfiguration`, `NetworkLogStore`, `LogCollector`, `CustomAction`, `CustomActionRegistry`, `DeviceInfo`, `MenuItem`, `NetworkLogEntry` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 16/16 pass |
| Review | ✅ Approved (Codex cross-host — 2 rounds) |

**Key design decisions:**
- `@MainActor` singleton for UI-only access pattern (no TaskLocal needed)
- Triple-tap overlay (`GestureOverlay`) + shake-to-open (`ShakeDetectingWindow`)
- Optional integration stubs for AnvilFlags/AnvilNetwork via `#if canImport`
- Memory-safe: max 100 network entries, max 500 log messages
- `#if DEBUG` stripping at call site (package builds for all configs)

### ~~2.4 Documentation System~~

**Moved to Phase 3 CLI** — `swiftanvil docs generate` will handle DocC generation across all packages.

**Rationale:** Documentation generation is a tooling concern, not a runtime package. Fits better in CLI phase.

---

## Phase 3: CLI & Integration 🟢

> The `swiftanvil` CLI tool that ties everything together.

### 3.1 Wizard System ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-wizard`](https://github.com/swiftanvil/swiftanvil-anvil-wizard) |
| Source | Designed from scratch |
| Core Types | `Wizard<Result>`, `WizardAnswers`, `Prompt<T>`, `TextPrompt`, `ConfirmPrompt`, `ChoicePrompt`, `InputReader`, `OutputWriter`, `TerminalInputReader`, `TerminalOutputWriter` |
| Platforms | macOS 13+ |
| Tests | 20/20 pass |
| Review | ✅ Approved (Codex cross-host, 2 rounds plan + 2 rounds impl) |

**Key design decisions:**
- Generic `Wizard<Result>` with `(WizardAnswers) throws -> Result` closure for type-safe result construction
- `Prompt<T>` protocol — extensible prompt system
- `InputReader`/`OutputWriter` protocols for full testability (mock injection)
- Terminal raw mode with ISIG disabled (Ctrl-C returns byte, not SIGINT), restored via `defer`
- Non-interactive mode `.nonInteractive(answers:)` for CI/automation

### 3.2 Template Engine ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-template`](https://github.com/swiftanvil/swiftanvil-anvil-template) |
| Source | Designed from scratch |
| Core Types | `Template`, `TemplateContext`, `TemplateNode`, `TemplateValue`, `TemplateParser`, `TemplateRenderer`, `TemplateError`, `RenderMode` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 30/30 pass |
| Review | ✅ APPROVED_WITH_NOTES (Codex cross-host, 3 rounds plan + 1 round impl) |

**Key design decisions:**
- Lightweight Mustache-like syntax: `{{name}}`, `{{#items}}...{{/items}}`, `{{^empty}}...{{/empty}}`
- `TemplateValue` enum for type-safe context values (string, bool, int, double, array, dictionary)
- `RenderMode` for HTML escaping vs raw output
- No external dependencies — pure Swift implementation

### 3.3 Project Generator ✅

| Aspect | Detail |
|--------|--------|
| Repo | [`swiftanvil-anvil-project`](https://github.com/swiftanvil/swiftanvil-anvil-project) |
| Source | Designed from scratch |
| Core Types | `ProjectGenerator`, `ProjectSpec`, `ProductSpec`, `DependencySpec`, `TargetSpec`, `Platform`, `ProjectError`, `FileSystem`, `InMemoryFileSystem` |
| Platforms | iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+ |
| Tests | 37/37 pass |
| Review | ✅ APPROVED_WITH_NOTES (Codex cross-host, 3 rounds plan + 1 round impl + 1 round fixes) |

**Key design decisions:**
- Declarative `ProjectSpec` — name, platforms, products, dependencies, targets, templates
- Per-platform version enums prevent invalid combinations at compile time
- Programmatic `Package.swift` generation (not templates) for precise comma placement
- `FileSystem` protocol with `InMemoryFileSystem` for fast, isolated tests
- Atomic writes via temp+move, rollback on any failure
- Built-in source templates: `library`, `executable`, `test`, `readme`, `gitignore`

**Review fixes:**
- Product/target type mismatch validation (library→executable, executable→regular)
- Non-test targets cannot depend on test targets
- Swift identifier sanitization in templates (hyphens→underscores)

### 3.4 Documentation Generator Recovery and Promotion ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-3-4` |
| Result | `planning.child-3-4-result` |
| Review | `planning.child-3-4-provenance` |
| Repo | [`swiftanvil-anvil-docs`](https://github.com/swiftanvil/swiftanvil-anvil-docs) |
| Status | Complete |
| Tests | 6/6 pass |
| CI | Passed on main |

**Decision:** AnvilDocs is a separate package. It owns reusable registry load, validate, and compose logic.
`swiftanvil-cli` should own command-line UX in a later child.

### 3.5 Testing & Verification ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-3-5` |
| Result | `planning.child-3-5-result` |
| Review | `planning.child-3-5-provenance` |
| Repo | [`swiftanvil-cli`](https://github.com/swiftanvil/swiftanvil-cli) |
| Status | Complete |
| Tests | 13/13 pass |
| CI | Passed on main |

**Decision:** Generated-project verification starts in `swiftanvil-cli` as `ifoundation verify --path <project>`.
Package extraction and a separate integration-test repository remain deferred until there is a concrete shared
verification API or cross-repository test matrix.

---

## Phase 4: Org Intelligence & Managed Workers 🟡

> Make the multi-repo organization understandable, enforceable, and able to use managed Mac workers without
> scattering the work across unrelated threads.

Phase 4 carries forward the phase-child workflow from the original planning repository. The child plan index is
registered as `planning.children-index`.

### 4.1 Governance and Enforcement Baseline ✅

| Aspect | Detail |
|--------|--------|
| Primary Repos | `swiftanvil-meta`, `swiftanvil-enforcement`, `.github` |
| Plan | `planning.child-4-1` |
| Result | `planning.child-4-1-result` |
| Review | `planning.child-4-1-provenance` |
| Status | Complete |

**What it established:**
- `swiftanvil-meta` as the organization planning and memory source of truth.
- `swiftanvil-enforcement` as the reusable enforcement repository.
- Document registry validation and PR review provenance validation.
- Local enforcement support for cases where GitHub Actions cannot be used.
- A reversible single-maintainer exception for GitHub-native required approvals.

### 4.2 AnvilRunner 0.1 Release ✅

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-anvil-runner` |
| Plan | `planning.child-4-2` |
| Result | `planning.child-4-2-result` |
| Review | `planning.child-4-2-provenance` |
| Release | `0.1.0` |
| Status | Complete |

**What it established:**
- A hardened first release of AnvilRunner.
- CI, release hygiene, local enforcement, and managed worker vocabulary.
- A clear boundary: 0.1 is a runner baseline, not host provisioning.

### 4.3 AnvilReport Organization Health Report ✅

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-meta` |
| Plan | `planning.child-4-3` |
| Result | `planning.child-4-3-result` |
| Provenance | `planning.child-4-3-provenance` |
| Status | Complete |
| Report | `report.org-health` |
| Report Data | `report.org-health-data` |
| Generator | `script.org-report` |

**What it established:**
- Human-readable org health report (`report.org-health`) with repository status, phase progress, review coverage, and next work
- Machine-readable companion (`report.org-health-data`) for agent consumption
- Generation script (`script.org-report`) with GitHub API integration
- Two-artifact approach: Markdown for humans, YAML for machines
- Reserved sections for Child 4.4 (Worker Capabilities) and 4.5 (Fleet Status)
- All artifacts registered in `meta.registry` with stable document IDs

### 4.4 Managed Worker Capability Discovery and Doctor

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-anvil-runner` |
| Plan | `planning.child-4-4` |
| Status | Planned |

This child adds read-only worker capability discovery and doctor checks before any provisioning work. It should detect
host capabilities, installed developer tools, agent availability, auth readiness where safe, SSH posture, Tailscale
availability, and power-management posture without changing the machine.

### 4.5 Worker Provisioning and Fleet Profiles

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-anvil-runner` |
| Plan | `planning.child-4-5` |
| Status | Planned |

This child owns safe provisioning after discovery is stable: dry-run-first setup plans, explicit user consent,
worker profiles, SSH/Tailscale guidance, power-management guidance, and the first fleet vocabulary.

---

## Phase 5: Ecosystem & Distribution ⚪

> Community, plugins, and public distribution after the org intelligence and worker foundation is stable.

### 5.1 Community Templates

Template gallery contributed by the community.

### 5.2 Plugin System

Extensible plugin architecture for custom generators.

### 5.3 Release & Distribution

Homebrew tap, Swift Package Index listing, release automation.

---

## 📊 Test Summary

| Package | Tests | Last Verified |
|---------|-------|---------------|
| A11yIdentifiers | 17/17 | 2026-06-02 |
| BenchmarkKit | 78/78 | 2026-06-02 |
| AppStrings | 21/21 | 2026-06-02 |
| AnvilNetwork | 29/29 | 2026-06-03 |
| AnvilFlags | 37/37 | 2026-06-03 |
| AnvilDevMenu | 16/16 | 2026-06-03 |
| AnvilWizard | 20/20 | 2026-06-03 |
| AnvilTemplate | 30/30 | 2026-06-03 |
| AnvilProject | 37/37 | 2026-06-03 |
| AnvilRunner | CI passed for 0.1.0 release | 2026-06-04 |
| iFoundation CLI | 8/8 | 2026-06-02 |
| **Total** | **262/262** | **100%** |

*Note: historical iFoundation planning is retained as source material, but current organization planning lives in
`swiftanvil-meta`.*

---

## 🏛️ Architecture Decisions

| Decision | Rationale | Date |
|----------|-----------|------|
| Multi-repo org | Pointfreeco pattern — independent packages, independent versioning | 2026-06-02 |
| `swiftanvil` naming | Taken: `iFoundation`. Chosen: industrial, forge metaphor, Gen Z friendly | 2026-06-02 |
| Swift 6 + StrictConcurrency | Future-proof, eliminates data race bugs at compile time | 2026-06-02 |
| Swift Testing over XCTest | Modern, expressive, built-in concurrency support | 2026-06-02 |
| No website yet | Build packages first, website post-v1.0 | 2026-06-02 |
| Agent-agnostic orchestration | Any model can build, any *different* model can review | 2026-06-02 |
| Phase 2 simplified | AppNetworking builder-first (macros later), docs moved to CLI | 2026-06-02 |
| 5-step per-child workflow | PLAN → REVIEW → EXECUTE → VERIFY → DOCUMENT | 2026-06-03 |
| `swiftanvil-meta` source of truth | Planning moved out of the misleading legacy local repository into org memory | 2026-06-04 |
| Single-maintainer approval exception | GitHub-native approval requirement waits until a second eligible maintainer exists; CI and provenance remain required | 2026-06-04 |
| Managed worker phase | Runner, report, doctor, provisioning, and fleet work belong to Phase 4 children | 2026-06-04 |

---

## 🔗 Quick Links

| Resource | URL |
|----------|-----|
| Org | https://github.com/swiftanvil |
| Meta | https://github.com/swiftanvil/swiftanvil-meta |
| Enforcement | https://github.com/swiftanvil/swiftanvil-enforcement |
| AnvilRunner | https://github.com/swiftanvil/swiftanvil-anvil-runner |
| A11yIdentifiers | https://github.com/swiftanvil/swiftanvil-anvil-a11y |
| BenchmarkKit | https://github.com/swiftanvil/swiftanvil-anvil-bench |
| AppStrings | https://github.com/swiftanvil/swiftanvil-anvil-strings |
| AnvilNetwork | https://github.com/swiftanvil/swiftanvil-anvil-network |
| AnvilFlags | https://github.com/swiftanvil/swiftanvil-anvil-flags |
| AnvilDevMenu | https://github.com/swiftanvil/swiftanvil-anvil-devmenu |
| AnvilWizard | https://github.com/swiftanvil/swiftanvil-anvil-wizard |
| AnvilTemplate | https://github.com/swiftanvil/swiftanvil-anvil-template |
| AnvilProject | https://github.com/swiftanvil/swiftanvil-anvil-project |
| CLI | https://github.com/swiftanvil/swiftanvil-cli |
| **Workflow Guide** | **workflow.general** |
| **Orchestration** | **workflow.orchestration** |

---

*Last updated: 2026-06-04*
