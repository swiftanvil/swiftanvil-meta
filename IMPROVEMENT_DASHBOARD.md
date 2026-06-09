# SwiftAnvil Improvement Dashboard

> Auto-generated from `package.improvement-score`. Updated after every child completion.

*Last updated: 2026-06-09*

---

## Current Gate

✅ **CLEARED** — All packages now at PMS ≥ 80 (Grade A). The improvement sprint is complete. Lower-priority roadmap implementation is unblocked. Next: finish `planning.child-9-5` workflow artifacts, then proceed to `planning.child-9-6`.

## Package Health Overview

| Package | Version | PMS | Grade | Status | Next Review | Next Action |
|---------|---------|-----|-------|--------|-------------|-------------|
| AnvilA11y | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-19 | — |
| AnvilBench | 1.0.0 | 100 | A+ | 🟢 Healthy | 2026-06-19 | — |
| AnvilCore | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilDevMenu | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilDocs | 0.1.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilFlags | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilMacros | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilMenuBar | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilNetwork | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilProject | 1.0.0 | 90 | A+ | 🟢 Healthy | 2026-06-23 | — |
| AnvilRunner | 0.2.0 | 85 | A | 🟢 Healthy | 2026-06-23 | Audit security false positive |
| AnvilSettings | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilStrings | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilTemplate | 1.3.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilWindow | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-23 | — |
| AnvilWizard | 1.0.0 | 85 | A | 🟢 Healthy | 2026-06-19 | — |
| swiftanvil-cli | 0.3.0 | 90 | A+ | 🟢 Healthy | 2026-06-19 | — |

**Legend:** 🟢 Healthy (A) | 🟡 Improve (B) | 🔴 Sprint (C/F) | ⚪ Unknown

---

## Sprints This Week

| Package | Item | Impact | Effort | Target Version | Phase |
|---------|------|--------|--------|----------------|-------|
| AnvilMacros | MAC-001: Real `@Benchmark` macro with timing + BenchmarkKit integration | 8 | medium | 1.1.0 | 9.1 ✅ |
| GoldenPath | GPT-001: Fix RESULT.md + add AnvilCore/AnvilMacros to Package.swift | 5 | small | — | 9.3 ✅ |
| All packages | SW6-001: Consistent `swiftLanguageModes: [.v6]` across all repos | 4 | small | — | 9.2 ✅ |
| swiftanvil-meta | PMS-001: Build calculation script + update dashboard | 5 | medium | — | 9.4 ✅ |
| AnvilMacros + 4 others | PMS-Sprint: CI, DocC, tags to clear PMS gate | 5 | small | 1.0.0 | Sprint ✅ |

**Blocked:**
- None

---

## Improvement Queue (Prioritized)

### High Impact (≥5)

| ID | Package | Description | Impact | Effort | Blocked By | Phase |
|----|---------|-------------|--------|--------|------------|-------|
| PMS-001 | swiftanvil-meta | PMS framework documented but not implemented — build calculation script | 5 | medium | — | 9.4 ✅ |
| DOC-005 | AnvilMacros | Add DocC catalog to raise documentation score | 5 | small | — | Sprint ✅ |
| TAG-001 | AnvilCore | Tag v1.0.0 to restore API stability score | 4 | small | — | Sprint ✅ |
| TAG-002 | AnvilMenuBar | Tag v1.0.0 to restore API stability score | 4 | small | — | Sprint ✅ |
| TAG-003 | AnvilSettings | Tag v1.0.0 to restore API stability score | 4 | small | — | Sprint ✅ |
| TAG-004 | AnvilWindow | Tag v1.0.0 to restore API stability score | 4 | small | — | Sprint ✅ |

### Medium Impact (3–4)

| ID | Package | Description | Impact | Effort | Phase |
|----|---------|-------------|--------|--------|-------|
| CLI-001 | swiftanvil-cli | Plugin commands in `--help` | 4 | medium | — |
| TPL-003 | AnvilTemplate | Template parse caching | 5 | small | — |
| PERF-001 | AnvilCore | Add performance benchmarks to raise score | 5 | small | — |

### Low Impact (1–2)

| ID | Package | Description | Impact | Effort |
|----|---------|-------------|--------|--------|
| PRJ-001 | AnvilProject | Advanced README examples | 3 | small |
| DOC-004 | AnvilDocs | Tag first package release | 3 | small |
| DOC-002 | AnvilDocs | CLI integration for docs compose | 5 | medium |
| SWU-001 | swiftanvil-example-swiftui | Missing DocC catalog | 2 | small |

---

## Phase 8–9 Tracking

| Phase | Child | Status | Repo | Est. Effort |
|-------|-------|--------|------|-------------|
| 8.1 | macOS App Template | ✅ Done | swiftanvil-cli | Medium |
| 8.2 | AnvilSettings | ✅ Done | swiftanvil-anvil-settings | Medium |
| 8.3 | AnvilMenuBar | ✅ Done | swiftanvil-anvil-menubar | Small |
| 8.4 | AnvilWindow | ✅ Done | swiftanvil-anvil-window | Medium |
| 8.5 | AnvilCore Integration | ✅ Done | Multiple | Medium |
| 9.1 | Real `@Benchmark` Macro | ✅ Done | swiftanvil-anvil-macros | Medium |
| 9.2 | Swift 6 Consistency | ✅ Done | All repos | Small |
| 9.3 | GoldenPath Fix | ✅ Done | swiftanvil-example-golden-path | Small |
| 9.4 | PMS Automation | ✅ Done | swiftanvil-meta | Medium |

---

## Anti-Stagnation Alerts

| Rule | Status |
|------|--------|
| No package at B for >2 sprints | ✅ All packages A or initial |
| No "Later" item >3 months old | ✅ All packages <1 month old |
| Every sprint improves ≥1 category | ✅ TPL-002 resolved (correctness +8) |
| No stub macro >1 sprint | ✅ `@Benchmark` is real — Phase 9.1 done |
| No orphan package >1 sprint | ✅ AnvilCore has 4 dependents — Phase 8.5 done |

---

## How to Use This Dashboard

**For AI Builders:**
1. Read this at session start
2. If any package is 🔴, improvement sprint takes priority
3. If any item is "blocked", check if blocker is resolved
4. Pick highest-impact, lowest-effort item when choosing work

**For Reviewers:**
1. Check if implementation improves PMS
2. Verify "Now" items from package ROADMAP are addressed
3. Flag if score would regress

**For Users:**
1. See what's being improved and why
2. Override priorities if business needs differ
3. Get notified when packages stagnate

---

*This dashboard is proactive. It tells you what to improve before you forget.*
