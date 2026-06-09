# Improvement Sprint — PMS Remediation (June 2026)

> **Goal:** Raise Package Maturity Score (PMS) for 5 packages above 80 to unblock Phase 9 roadmap work.
> **Type:** Improvement Sprint (cross-package)
> **Builder:** Kimi Code CLI
> **Date:** 2026-06-09

---

## Current State

| Package | Repo | PMS | Grade | Blockers |
|---------|------|-----|-------|----------|
| AnvilMacros | swiftanvil-anvil-macros | 58 | F | No DocC catalog, no CI, no tag, only 2 tests |
| AnvilCore | swiftanvil-anvil-core | 65 | C | No tag, no performance benchmarks, no CI |
| AnvilMenuBar | swiftanvil-anvil-menubar | 65 | C | No tag, no CI |
| AnvilSettings | swiftanvil-anvil-settings | 65 | C | No tag, no CI |
| AnvilWindow | swiftanvil-anvil-window | 65 | C | No tag, no CI |

**Policy Gate:** `meta.session-start` Step 2 blocks lower-priority work until these clear.

---

## Goal

Bring every package to PMS ≥ 80 (Grade A) by adding the missing structural elements: CI workflows, DocC catalogs where missing, performance benchmarks where applicable, and semantic version tags.

## Non-Goals

- No new public APIs
- No behavior changes to existing code
- No dependency additions beyond BenchmarkKit for AnvilCore benchmarks
- No changes to packages already at A or A+

---

## Task Breakdown

### AnvilMacros (58 → Target 85)

| Task | Effort | PMS Impact | Details |
|------|--------|------------|---------|
| Add DocC catalog | Small | +7 doc | `Sources/AnvilMacros/AnvilMacros.docc` with Info.plist |
| Add CI workflow | Small | +5 eco | `.github/workflows/ci.yml` (macos-15 runner) |
| Expand tests | Small | +5 cov | Add macro expansion tests for edge cases (3+ new test cases) |
| Tag v1.0.0 | Small | +15 api | Git tag + push to origin |

### AnvilCore (65 → Target 90)

| Task | Effort | PMS Impact | Details |
|------|--------|------------|---------|
| Add CI workflow | Small | +5 eco | `.github/workflows/ci.yml` (macos-15 runner) |
| Add BenchmarkKit benchmarks | Small | +10 perf | Benchmark `AnvilLogger`, `AnvilConfiguration`, `AnvilTask` |
| Tag v1.0.0 | Small | +15 api | Git tag + push to origin |

### AnvilMenuBar (65 → Target 80)

| Task | Effort | PMS Impact | Details |
|------|--------|------------|---------|
| Add CI workflow | Small | +5 eco | `.github/workflows/ci.yml` (macos-15 runner) |
| Tag v1.0.0 | Small | +15 api | Git tag + push to origin |

### AnvilSettings (65 → Target 80)

| Task | Effort | PMS Impact | Details |
|------|--------|------------|---------|
| Add CI workflow | Small | +5 eco | `.github/workflows/ci.yml` (macos-15 runner) |
| Tag v1.0.0 | Small | +15 api | Git tag + push to origin |

### AnvilWindow (65 → Target 80)

| Task | Effort | PMS Impact | Details |
|------|--------|------------|---------|
| Add CI workflow | Small | +5 eco | `.github/workflows/ci.yml` (macos-15 runner) |
| Tag v1.0.0 | Small | +15 api | Git tag + push to origin |

---

## Cross-Cutting Tasks

1. **Verify `swift build` and `swift test` pass** on every repo before tagging
2. **Update `package.improvement-score`** in each repo after changes
3. **Update `MEMORY/07-PACKAGES.md`** in swiftanvil-meta
4. **Update `IMPROVEMENT_DASHBOARD.md`** in swiftanvil-meta
5. **Update `ROADMAP.md`** gate status

---

## Success Criteria

- [ ] All 5 packages have `.github/workflows/ci.yml`
- [ ] All 5 packages build with `swift build` (no warnings)
- [ ] All 5 packages pass `swift test`
- [ ] AnvilMacros has a DocC catalog
- [ ] AnvilCore has BenchmarkKit benchmarks
- [ ] All 5 packages have git tag `v1.0.0` pushed to origin
- [ ] All 5 packages have updated `package.improvement-score` with PMS ≥ 80
- [ ] `packages.registry`, `improvement.dashboard`, and `roadmap.org` updated in swiftanvil-meta
- [ ] All changes committed and pushed

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Git push fails (no remote access) | Document tag locally; note in RESULT.md |
| BenchmarkKit not available for AnvilCore | Verify `Package.swift` can resolve BenchmarkKit dependency |
| DocC build fails on AnvilMacros | Test `swift build --target AnvilMacros` before committing |
| macOS-only packages fail on iOS CI | Use `macos-15` runner only; no iOS simulator needed |

---

## Naming

No new names. Existing repos:
- `swiftanvil-anvil-macros`
- `swiftanvil-anvil-core`
- `swiftanvil-anvil-menubar`
- `swiftanvil-anvil-settings`
- `swiftanvil-anvil-window`
