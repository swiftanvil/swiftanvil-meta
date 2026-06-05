# Child 9.4 Plan: PMS Automation

## Context

- **Phase:** 9
- **Child:** 9.4
- **Primary Repo:** `swiftanvil-meta`
- **Goal:** Implement the Package Maturity Score (PMS) framework that's currently only documented in `IMPROVEMENT_FRAMEWORK.md`.

## What PMS Is

Every package gets a score 0-100 across 7 categories:

| Category | Weight | How Measured |
|----------|--------|--------------|
| Correctness | 25% | `swift test` passes, no warnings |
| Coverage | 20% | Test count + presence of edge case tests |
| Documentation | 15% | README + DocC catalog exist |
| API Stability | 15% | Semver tag exists |
| Performance | 10% | BenchmarkKit tests exist |
| Ecosystem | 10% | CI workflow + GitHub repo |
| Security | 5% | No hardcoded secrets in source |

## Implementation

### 1. `scripts/calculate-pms.sh` — Bash script

For each package repo:
1. `cd` into repo
2. Run `swift build` → correctness score (25 if pass, 0 if fail)
3. Run `swift test` → correctness bonus (already covered)
4. Count test files → coverage score (20 if >5 tests, 15 if >0, 0 if none)
5. Check README exists → documentation score (8 pts)
6. Check DocC catalog exists → documentation score (7 pts)
7. Check git tag exists → API stability score (15 pts)
8. Check BenchmarkKit in deps → performance score (10 pts)
9. Check `.github/workflows/ci.yml` → ecosystem score (5 pts)
10. Check repo has remote → ecosystem score (5 pts)
11. `grep -r "password\|secret\|token" Sources/` → security score (5 if clean)
12. Output JSON to stdout

### 2. `package.improvement-score` — JSON output per repo

The script writes `package.improvement-score` in each repo:
```json
{
  "version": "1.0.0",
  "score": 78,
  "grade": "B",
  "breakdown": { ... },
  "last_calculated": "2026-06-05T...",
  "next_review": "2026-06-19T..."
}
```

### 3. Update `IMPROVEMENT_DASHBOARD.md`

Replace placeholder data with actual PMS scores from the script.

### 4. Tests

Add Swift tests in `swiftanvil-meta` that verify:
- `calculate-pms.sh` runs without errors
- Output JSON is valid
- Score is in range 0-100

## Files to Create/Modify

| File | Action |
|------|--------|
| `scripts/calculate-pms.sh` | **New** — PMS calculation script |
| `Tests/MetaTests/PMSTests.swift` | **New** — tests for script |
| `IMPROVEMENT_DASHBOARD.md` | **Update** — real scores |
| `Children/9.4/RESULT.md` | **New** — completion doc |

## Risks

| Risk | Mitigation |
|------|------------|
| Script fails on some repos | Test on all repos before marking complete |
| Score calculation is subjective | Document the heuristic clearly; it's a starting point |
| Slow to run on all repos | Script runs ~1s per repo; acceptable for batch |
