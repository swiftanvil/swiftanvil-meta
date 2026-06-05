# Child 9.4 Result: PMS Automation

## Status

✅ **Complete**

## What Was Delivered

### 1. `scripts/calculate-pms.sh`

Bash script that calculates Package Maturity Score (PMS) for all 17 SwiftAnvil repos.

- **Heuristics version:** 1.0 (initial approximations, documented in script header)
- **Categories:** Correctness (25), Coverage (20), Documentation (15), API Stability (15), Performance (10), Ecosystem (10), Security (5)
- **Output:** JSON to `package.improvement-score` per repo + array JSON to stdout for all repos
- **Improvement items:** Auto-generated based on low scores, with impact and effort estimates

### 2. `scripts/test-pms.sh`

Fixture-based shell test suite (5 tests, all passing):
1. Score range validation (0-100)
2. JSON schema validation (required fields)
3. Grade matches score thresholds
4. Breakdown sums to total score
5. Script runs on synthetic single-repo fixture

Tests use `$WORKSPACE` env var for portability.

### 3. `.github/workflows/pms.yml`

GitHub Actions workflow that:
- Runs on push/PR to main, weekly cron (Sundays 03:00 UTC), and manual dispatch
- Clones all 17 package repos into workspace
- Runs `calculate-pms.sh` and uploads report artifact
- Warns if any grade is C or F

### 4. `IMPROVEMENT_DASHBOARD.md`

Updated with real PMS scores for all 17 packages.

### 5. `MEMORY/07-PACKAGES.md`

Updated with real PMS scores and improvement queue. Versions preserved from git tags (not overwritten).

## Scores Summary

| Grade | Count | Packages |
|-------|-------|----------|
| A+ | 3 | AnvilBench (100), AnvilProject (90), swiftanvil-cli (90) |
| A | 10 | AnvilA11y, AnvilDevMenu, AnvilDocs, AnvilFlags, AnvilNetwork, AnvilRunner, AnvilStrings, AnvilTemplate, AnvilWizard |
| C | 4 | AnvilCore, AnvilMenuBar, AnvilSettings, AnvilWindow |
| F | 1 | AnvilMacros |

## Review History

- **Plan review:** Codex → NEEDS_REVISION (5 blockers, all fixed)
- **Implementation review:** Codex → APPROVED_WITH_NOTES (3 P2 notes, all fixed)
  1. Workflow only checked out 1 repo → fixed to clone all 17
  2. Tests hardcoded local path → fixed to use `$WORKSPACE`
  3. Registry versions overwritten → restored real versions from git tags

## Files Changed

| File | Action |
|------|--------|
| `scripts/calculate-pms.sh` | Modified — added heuristics header, improvement_items |
| `scripts/test-pms.sh` | New — fixture-based test suite |
| `.github/workflows/pms.yml` | New — GitHub Actions workflow |
| `IMPROVEMENT_DASHBOARD.md` | Updated — real scores |
| `MEMORY/07-PACKAGES.md` | Updated — real scores + versions |
| `Children/9.4/RESULT.md` | New — this file |
| `Children/9.4/REVIEW-PROVENANCE.md` | New — review record |

## Next Actions

- Tag untagged repos (AnvilCore, AnvilMenuBar, AnvilSettings, AnvilWindow, AnvilMacros) to raise API stability scores
- Add DocC catalogs to repos missing them
- Add CI workflows to repos missing them
- Add BenchmarkKit performance tests to repos missing them
