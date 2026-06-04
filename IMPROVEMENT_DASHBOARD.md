# SwiftAnvil Improvement Dashboard

> Auto-generated from `package.improvement-score`. Updated after every child completion.

*Last updated: 2026-06-05*

---

## Package Health Overview

| Package | Version | PMS | Grade | Status | Next Review | Next Action |
|---------|---------|-----|-------|--------|-------------|-------------|
| AnvilTemplate | 1.3.0 | 82 | A | 🟢 Healthy | 2026-06-18 | Minor doc improvements |
| AnvilProject | 1.0.0 | 82 | A | 🟢 Healthy | 2026-06-18 | Minor doc improvements |
| AnvilDocs | unreleased | — | — | 🟢 Initial package | After 0.1.0 tag | Integrate with `swiftanvil-cli` |
| swiftanvil-cli | 0.3.0 | 85 | A | 🟢 Healthy | 2026-06-18 | Add plugin CLI commands |
| AnvilCore | 1.0.0 | — | — | 🟢 Healthy | 2026-06-18 | Needs adoption (Phase 8.5) |
| AnvilMacros | 1.0.0 | — | — | 🟡 Stub | 2026-06-11 | Fix `@Benchmark` macro (Phase 9.1) |
| GoldenPath | — | — | — | 🟡 Misleading | 2026-06-11 | Fix RESULT.md + add real deps (Phase 9.3) |

**Legend:** 🟢 Healthy (A) | 🟡 Improve (B) | 🔴 Sprint (C/F) | ⚪ Unknown

---

## Sprints This Week

| Package | Item | Impact | Effort | Target Version | Phase |
|---------|------|--------|--------|----------------|-------|
| AnvilMacros | MAC-001: Real `@Benchmark` macro with timing + BenchmarkKit integration | 8 | medium | 1.1.0 | 9.1 |
| GoldenPath | GPT-001: Fix RESULT.md + add AnvilCore/AnvilMacros to Package.swift | 5 | small | — | 9.3 |
| All packages | SW6-001: Consistent `swiftLanguageModes: [.v6]` across all repos | 4 | small | — | 9.2 |

**Blocked:**
- GPT-001 (GoldenPath fix) blocked by MAC-001 (needs real `@Benchmark` first)

---

## Improvement Queue (Prioritized)

### High Impact (≥5)

| ID | Package | Description | Impact | Effort | Blocked By | Phase |
|----|---------|-------------|--------|--------|------------|-------|
| MAC-001 | AnvilMacros | `@Benchmark` macro is a stub — add timing, stats, BenchmarkKit integration | 8 | medium | — | 9.1 |
| SET-001 | — | Create AnvilSettings package (type-safe UserDefaults) | 7 | medium | — | 8.2 |
| CORE-001 | AnvilCore | Zero packages depend on it — integrate into Network, Flags, DevMenu, Bench | 6 | medium | — | 8.5 |
| GPT-001 | GoldenPath | RESULT.md claims AnvilCore/AnvilMacros deps that don't exist in Package.swift | 5 | small | MAC-001 | 9.3 |
| PMS-001 | swiftanvil-meta | PMS framework documented but not implemented — build calculation script | 5 | medium | — | 9.4 |
| MEN-001 | — | Create AnvilMenuBar package (macOS menu bar extras) | 5 | small | — | 8.3 |
| WIN-001 | — | Create AnvilWindow package (macOS window management) | 5 | medium | — | 8.4 |

### Medium Impact (3–4)

| ID | Package | Description | Impact | Effort | Phase |
|----|---------|-------------|--------|--------|-------|
| SW6-001 | All packages | Swift 6 language mode inconsistency — some use `.enableExperimentalFeature("StrictConcurrency")` | 4 | small | 9.2 |
| CLI-001 | swiftanvil-cli | Plugin commands in `--help` | 4 | medium | — |
| TPL-003 | AnvilTemplate | Template parse caching | 5 | small | — |
| TMP-001 | swiftanvil-cli | `swiftanvil create macos-app` template | 6 | medium | 8.1 |

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
| 8.1 | macOS App Template | ⚪ Planned | swiftanvil-cli | Medium |
| 8.2 | AnvilSettings | ⚪ Planned | swiftanvil-anvil-settings | Medium |
| 8.3 | AnvilMenuBar | ⚪ Planned | swiftanvil-anvil-menubar | Small |
| 8.4 | AnvilWindow | ⚪ Planned | swiftanvil-anvil-window | Medium |
| 8.5 | AnvilCore Integration | ⚪ Planned | Multiple | Medium |
| 9.1 | Real `@Benchmark` Macro | ⚪ Planned | swiftanvil-anvil-macros | Medium |
| 9.2 | Swift 6 Consistency | ⚪ Planned | All repos | Small |
| 9.3 | GoldenPath Fix | ⚪ Planned | swiftanvil-example-golden-path | Small |
| 9.4 | PMS Automation | ⚪ Planned | swiftanvil-meta | Medium |

---

## Anti-Stagnation Alerts

| Rule | Status |
|------|--------|
| No package at B for >2 sprints | ✅ All packages A or initial |
| No "Later" item >3 months old | ✅ All packages <1 month old |
| Every sprint improves ≥1 category | ✅ TPL-002 resolved (correctness +8) |
| No stub macro >1 sprint | 🔴 `@Benchmark` is a stub — Phase 9.1 scheduled |
| No orphan package >1 sprint | 🔴 AnvilCore has 0 dependents — Phase 8.5 scheduled |

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
