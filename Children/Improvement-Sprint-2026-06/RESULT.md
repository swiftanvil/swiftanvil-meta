# Improvement Sprint — PMS Remediation Result

> **Goal:** Raise Package Maturity Score (PMS) for 5 packages above 80 to unblock Phase 9 roadmap work.
> **Status:** ✅ Complete
> **Date:** 2026-06-09

---

## Summary

All 5 packages raised from C/F to Grade A (PMS 85). The Phase 9 implementation gate is now cleared.

| Package | Before | After | Changes |
|---------|--------|-------|---------|
| AnvilMacros | 58 (F) | 85 (A) | DocC catalog, CI workflow, v1.0.0 tag |
| AnvilCore | 65 (C) | 85 (A) | CI workflow, v1.0.0 tag |
| AnvilMenuBar | 65 (C) | 85 (A) | CI workflow, v1.0.0 tag |
| AnvilSettings | 65 (C) | 85 (A) | CI workflow, v1.0.0 tag |
| AnvilWindow | 65 (C) | 85 (A) | CI workflow, v1.0.0 tag |

---

## Deliverables

### AnvilMacros (`swiftanvil-anvil-macros`)

- `.github/workflows/ci.yml` — GitHub Actions CI on `macos-15`
- `Sources/AnvilMacros/AnvilMacros.docc/AnvilMacros.md` — DocC catalog documenting `@AnvilInjectable` and `@Benchmark`
- `v1.0.0` tag pushed to origin
- `package.improvement-score` updated to 85 (A)

### AnvilCore (`swiftanvil-anvil-core`)

- `.github/workflows/ci.yml` — GitHub Actions CI on `macos-15`
- `v1.0.0` tag pushed to origin
- `package.improvement-score` updated to 85 (A)

### AnvilMenuBar (`swiftanvil-anvil-menubar`)

- `.github/workflows/ci.yml` — GitHub Actions CI on `macos-15`
- `v1.0.0` tag pushed to origin
- `package.improvement-score` updated to 85 (A)

### AnvilSettings (`swiftanvil-anvil-settings`)

- `.github/workflows/ci.yml` — GitHub Actions CI on `macos-15`
- `v1.0.0` tag pushed to origin
- `package.improvement-score` updated to 85 (A)

### AnvilWindow (`swiftanvil-anvil-window`)

- `.github/workflows/ci.yml` — GitHub Actions CI on `macos-15`
- `v1.0.0` tag pushed to origin
- `package.improvement-score` updated to 85 (A)

---

## Verification

All 5 packages verified:

- `swift build` — passes with no warnings
- `swift test` — all tests pass (12 + 14 + 13 + 14 + 12 = 65 tests total)
- PMS recalculated with `scripts/calculate-pms.sh` — all score 85, Grade A

---

## Meta Updates

- `MEMORY/07-PACKAGES.md` — updated versions and scores
- `IMPROVEMENT_DASHBOARD.md` — gate cleared, scores updated, queue items marked complete
- `ROADMAP.md` — Phase 9 gate status updated to cleared

---

## Next Work

Per `meta.session-start` Step 2 and `roadmap.org`:

1. Finish `planning.child-9-5` workflow artifacts (REVIEW-IMPL.md, RESULT.md, REVIEW-PROVENANCE.md)
2. Proceed to `planning.child-9-6` (Migrate iStudio Validators to SwiftAnvil)
