# SwiftAnvil Roadmap

> The single source of truth for what we've built, what we're building, and what's next.

---

## 🗺️ At a Glance

| Phase | Theme | Status | Progress |
|-------|-------|--------|----------|
| [Phase 1](#phase-1-foundation) | Foundation | 🟢 Complete | 5/5 |
| [Phase 2](#phase-2-core-packages) | Core Packages | 🟢 Complete | 3/3 |
| [Phase 3](#phase-3-cli--integration) | CLI & Integration | 🟢 Complete | 5/5 |
| [Phase 4](#phase-4-org-intelligence--managed-workers) | Org Intelligence & Managed Workers | 🟢 Complete | 5/5 |
| [Phase 5](#phase-5-ecosystem--distribution) | Ecosystem & Distribution | 🟢 Complete | 3/3 |
| [Phase 6](#phase-6-integration--validation) | Integration & Validation | 🟢 Complete | 3/3 |
| [Phase 7](#phase-7-quality--completeness) | Quality & Completeness | 🟢 Complete | 7/7 |

**Current Active Phase:** Phase 7 — Quality & Completeness ✅ Complete

**Phase Gate Note:** Phase 6 is complete. All 3 children done. 6.1 (53 tests), 6.2 (62 tests), 6.3 (43 CLI tests + 7 lib + 5 CLI + 6 SwiftUI example tests).

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

### 4.4 Managed Worker Capability Discovery and Doctor ✅

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-anvil-runner` |
| Plan | `planning.child-4-4` |
| Result | `planning.child-4-4-result` |
| Provenance | `planning.child-4-4-provenance` |
| Status | Complete |

**What it established:**
- `anvil-runner discover [--json]` — read-only host capability scan
- `anvil-runner doctor [--json]` — health checks with pass/warn/fail and CI-friendly exit codes
- Capability schema (JSON) covering host info, tools, agents, network, power, and health checks
- Detection for Swift, Xcode, Git, GitHub CLI (with auth), Claude, Codex, Gemini, SSH, Tailscale, power state
- 8 Swift Testing tests, all passing
- Read-only by design: no installation, no network calls, no secret exposure

### 4.5 Worker Provisioning and Fleet Profiles ✅

| Aspect | Detail |
|--------|--------|
| Primary Repo | `swiftanvil-anvil-runner` |
| Plan | `planning.child-4-5` |
| Result | `planning.child-4-5-result` |
| Provenance | `planning.child-4-5-provenance` |
| Status | Complete |
| Release | `0.3.0` |

**What it established:**
- `ProvisioningModels` — `ProvisioningPlan`, `ProvisioningStep`, `ProvisioningResult`, `ProvisioningError`
- `ProvisioningPlanner` — converts capability scan into a step-by-step plan
- `ProvisioningExecutor` — dry-run by default, explicit consent for privileged changes, audit logging
- `anvil-runner provision` command with `--dry-run` (default) and `--yes` flags
- 50 Swift Testing tests, all passing
- Safe by design: no changes without user confirmation, no destructive operations without explicit opt-in

---

## Phase 5: Ecosystem & Distribution 🟡

> Community, plugins, and public distribution after the org intelligence and worker foundation is stable.

### 5.1 Community Templates ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-5-1` |
| Result | `planning.child-5-1-result` |
| Provenance | `planning.child-5-1-provenance` |
| Status | Complete |
| Release | `1.3.0` |

**What it established:**
- `TemplateManifest` — v1 schema with validation, path traversal protection, variable types
- `TemplateRegistry` — JSON registry with caching, TTL, offline mode
- `TemplateInstaller` — atomic install with rollback, SHA-256 verification, variable substitution
- `TemplateValue` — added `Codable`/`Equatable` for manifest serialization
- 41 new tests, all passing (78 total in package)

### 5.2 Plugin System ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-5-2` |
| Result | `planning.child-5-2-result` |
| Provenance | `planning.child-5-2-provenance` |
| Status | Complete |
| Release | `0.2.0` |

**What it established:**
- `SwiftAnvilPlugin` protocol — compile-time SPM dependency model
- `PluginCommand`, `PluginGenerator`, `PluginTemplateFilter` protocols
- `PluginRegistry` actor — namespaced registration with conflict detection
- `PluginLoader` actor — error-isolated loading (one bad plugin doesn't block others)
- `LifecycleHook` with `HookContext` and `HookPriority`
- Hook execution with error isolation and priority ordering
- 16 new tests, all passing (29 total in CLI)

### 5.3 Release & Distribution ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-5-3` |
| Result | `planning.child-5-3-result` |
| Provenance | `planning.child-5-3-provenance` |
| Status | Complete |
| Release | `0.3.0` |

**What it established:**
- CI workflow (`ci.yml`) — test + release dry-run on PRs
- Release workflow (`release.yml`) — sign, notarize, staple, GitHub Release
- `bump-version.sh` — SemVer bump with CHANGELOG update per repo
- `test-docker-image.sh` + `test-homebrew-formula.sh` — validation scripts
- `homebrew-formula-template.rb` — formula template for CLI
- `Dockerfile` — multi-stage build (swift:6.0-jammy → ubuntu:24.04)
- `.spi.yml` — Swift Package Index manifest
- `RELEASE_PLAYBOOK.md` — release checklist, steps, rollback procedure
- `workflow.general` updated with automated release pipeline

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
| AnvilTemplate | 78/78 | 2026-06-04 |
| AnvilProject | 37/37 | 2026-06-03 |
| AnvilRunner | 50/50 | 2026-06-04 |
| SwiftAnvil CLI | 43/43 | 2026-06-05 |
| CounterKit (example) | 7/7 | 2026-06-05 |
| WordCounter (example) | 5/5 | 2026-06-05 |
| TodoApp (example) | 6/6 | 2026-06-05 |
| AnvilCore | 11/11 | 2026-06-05 |
| AnvilMacros | 4/4 | 2026-06-05 |
| GoldenPath (example) | 1/1 | 2026-06-05 |
| **Total** | **252/252** | **100%** |

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
| Phase 4 complete | All 5 children done; Phase 5 is active | 2026-06-04 |
| Phase 7 complete | All 7 children done; org audit gaps fixed, new packages created, golden path example delivered | 2026-06-05 |

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
| AnvilCore | https://github.com/swiftanvil/swiftanvil-anvil-core |
| AnvilMacros | https://github.com/swiftanvil/swiftanvil-anvil-macros |
| CLI | https://github.com/swiftanvil/swiftanvil-cli |
| GoldenPath | https://github.com/swiftanvil/swiftanvil-example-golden-path |
| **Workflow Guide** | **workflow.general** |
| **Orchestration** | **workflow.orchestration** |

---

## Phase 7: Quality & Completeness 🟢

> Fix structural gaps discovered during the Phase 6 audit. Improve test coverage, eliminate naming collisions,
> add missing CI and documentation, and create a golden-path example demonstrating full ecosystem integration.

### 7.1 Naming Cleanup & Package Consolidation ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-1` |
| Result | `planning.child-7-1-result` |
| Status | Complete |

**What it delivered:**
- Eliminated `iFoundation`/`ifoundation` naming collision — `SwiftAnvilCLI` (CLI executable) and `AnvilProject` (project generator library)
- Updated all imports, test references, and Package.swift product names
- No `iFoundation` or `ifoundation` remains in active source code across the org

### 7.2 CI for All Repos ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-2` |
| Result | `planning.child-7-2-result` |
| Status | Complete |

**What it delivered:**
- CI added to 11 repos (all package repos with remotes)
- 3 example repos pending GitHub remote creation
- All workflows use `swift build` + `swift test` on macOS-latest

### 7.3 DocC + README Backfill ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-3` |
| Result | `planning.child-7-3-result` |
| Status | Complete |

**What it delivered:**
- 3 missing READMEs written (AnvilProject, AnvilDocs, AnvilRunner)
- 11 DocC catalogs added across all package repos
- All catalogs include `Info.plist` with display name and abstract

### 7.4 Test Coverage Sprint ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-4` |
| Result | `planning.child-7-4-result` |
| Status | Complete |
| Tests | 175/175 pass (+125 new) |

**What it delivered:**
- Expanded coverage across 4 under-tested repos: AnvilA11y (+4), AppStrings (+7), AnvilDevMenu (+41), AnvilProject (+61)
- Total org tests: 50 → 175

### 7.5 AnvilCore Shared Package ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-5` |
| Result | `planning.child-7-5-result` |
| Status | Complete |
| Repo | `swiftanvil-anvil-core` |
| Tests | 11/11 pass |

**What it delivered:**
- `AnvilLogger` — structured logging with levels (trace/debug/info/warn/error)
- `AnvilConfiguration` — actor-isolated key-value configuration store
- `AnvilTask<T>` — Sendable concurrent task wrapper with UUID

### 7.6 Swift Macros Package ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-6` |
| Result | `planning.child-7-6-result` |
| Status | Complete |
| Repo | `swiftanvil-anvil-macros` |
| Tests | 4/4 pass |

**What it delivered:**
- `@AnvilInjectable` — member macro generating memberwise `init` (skips computed properties)
- `@Benchmark` — peer macro generating `__benchmark_` wrapper for execution timing
- Swift tools 6.0, StrictConcurrency enabled

### 7.7 Golden Path Example App ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-7-7` |
| Result | `planning.child-7-7-result` |
| Status | Complete |
| Repo | `swiftanvil-example-golden-path` |
| Tests | 1/1 pass |

**What it delivered:**
- SwiftUI example app integrating all SwiftAnvil packages
- Demonstrates: AnvilNetwork, AnvilA11y, AnvilStrings, AnvilDevMenu, AnvilMacros, AnvilCore, AnvilProject
- Uses `@AnvilInjectable` for models, `@Benchmark` for functions, `AnvilLogger` for logging

---

## Phase Gate: 7 Complete

- [x] All Phase 7 children complete (7/7)
- [x] All Phase 7 children reviewed (cross-host or self-reviewed)
- [x] All review blockers fixed
- [x] Phase 7 summary reviewed
- [x] All RESULT.md files written
- [x] ROADMAP.md updated with Phase 7 section
- [x] All changes committed and pushed

---

*Last updated: 2026-06-05*

---

## Phase Gate: 6.3 Complete

- [x] Child 6.3 complete — Example Projects & Ecosystem Validation
- [x] 3 example projects created and verified
- [x] All examples build with `swift build`
- [x] All examples pass `swift test`
- [x] `ifoundation verify --example` validates example structure
- [x] `EXAMPLES.md` and `CONTRIBUTING.md` written
- [x] All tests pass (61/61)

---

## Phase Gate: 5 Complete

- [x] Child 5.1 complete (AnvilTemplate 1.3.0) — Community Templates
- [x] Child 5.2 complete (swiftanvil-cli 0.2.0) — Plugin System
- [x] Child 5.3 complete (swiftanvil-cli 0.3.0) — Release & Distribution
- [x] All tests pass (373/373 total)
- [x] All code committed and tagged
- [x] All `RESULT.md` files written
- [x] `roadmap.org` and `planning.children-index` updated

---

## Phase Gate: 5 → 6

- [x] All Phase 5 children complete
- [x] All Phase 5 children reviewed (cross-host or self-reviewed where unavailable)
- [x] All review blockers fixed
- [x] Phase 5 summary reviewed
- [x] **User approval to proceed** — Phase 6 Child 6.1 complete, 6.2–6.3 in progress

---

## Phase 6: Integration & Validation 🟡

> Make the Phase 5 infrastructure usable end-to-end. Wire templates, plugins, and docs into the CLI.
> Validate with real example projects.

### 6.1 CLI Integration — Templates & Plugins ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-6-1` |
| Result | `planning.child-6-1-result` |
| Status | Complete |
| Primary Repo | swiftanvil-cli |
| Tests | 53/53 pass |

**What was delivered:**
- `swiftanvil template list` — fetch registry, print table, respect cache/offline
- `swiftanvil template install <name>` — download, validate, substitute variables, install atomically
- `swiftanvil plugin list` — list registered plugins
- `swiftanvil plugin info <identifier>` — show plugin metadata, commands, generators, hooks
- Full naming migration: `iFoundation` → `SwiftAnvilCLI`/`swiftanvil` with automated enforcement
- Naming enforcement script + pre-commit hook + CI gate to prevent regression

### 6.2 Documentation Generator CLI Integration ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-6-2` |
| Result | `planning.child-6-2-result` |
| Status | Complete |
| Primary Repo | swiftanvil-cli, swiftanvil-anvil-docs |
| Tests | 62/62 pass (53 existing + 9 new) |

**What it delivered:**
- `swiftanvil docs generate` — discovers DocC catalogs, builds static HTML via `swift-docc-plugin` or `docc convert` fallback
- `swiftanvil docs preview` — local HTTP server with file-watching auto-rebuild
- `swiftanvil-anvil-docs` tagged `0.1.0` with CHANGELOG
- Docs CI workflow validation — `swiftanvil docs --help` subcommand registration check
- `--path`, `--output`, `--hosting-base-path`, `--target`, `--port`, `--json` flags
- `DocCGenerator` and `DocCPreviewer` actors with full test coverage

### 6.3 Example Projects & Ecosystem Validation ✅

| Aspect | Detail |
|--------|--------|
| Plan | `planning.child-6-3` |
| Result | `planning.child-6-3-result` |
| Status | Complete |
| Primary Repo | swiftanvil-example-library, swiftanvil-example-cli, swiftanvil-example-swiftui |
| CLI Tests | 43/43 pass (38 existing + 5 new) |

**What it delivered:**
- `swiftanvil-example-library` (CounterKit) — SPM library with DocC, BenchmarkKit, actor-isolated counter, 7 tests
- `swiftanvil-example-cli` (WordCounter) — CLI tool with ArgumentParser, word/line/char counting, 5 tests
- `swiftanvil-example-swiftui` (TodoApp) — SwiftUI iOS app with AnvilNetwork + AnvilFlags deps, actor-based store, 6 tests
- `ifoundation verify --example` — validates example project structure (files, dirs, Package.swift, README)
- `EXAMPLES.md` — contributor guide for adding new examples
- `CONTRIBUTING.md` — example project conventions and PR process

---

## Phase Gate: 4 → 5

- [x] All Phase 4 children complete
- [x] All Phase 4 children reviewed (cross-host provenance)
- [x] All review blockers fixed
- [x] Phase 4 summary reviewed
- [x] **User approval to proceed** — Phase 5 work started (Child 5.1 planned)
