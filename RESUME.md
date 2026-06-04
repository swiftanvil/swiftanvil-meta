# SwiftAnvil — Resume Here

> Human-facing session resumption guide. For agent startup, see `meta.session-start`.

---

## Where We Left Off

| Item | Value |
|------|-------|
| **Last Session** | 2026-06-04 |
| **Active Phase** | Phase 4 — Org Intelligence & Managed Workers |
| **Active Child** | 4.3 — AnvilReport Organization Health Report |
| **Status** | Plan exists, awaiting plan review (Step 2 of 5-step workflow) |

## Quick Context

- **Phases 1–3 are complete.** All packages built, tested, reviewed, and pushed to GitHub.
- **Phase 4.1 (Governance) and 4.2 (AnvilRunner 0.1) are complete.**
- **Phase 4.3 is next.** Goal: create a shared org health report that any agent can read to understand repo status, CI state, review provenance, and next work.

## What to Do Next

1. **If resuming as agent:** Read `meta.agents` → `meta.registry` → `meta.session-start` → follow the checklist.
2. **If resuming as human:** Check `roadmap.org` for current status, then look at `planning.child-4-3` for what's planned.

## Repository Layout (Local)

```
~/Documents/v-i-s-h-a-l/swiftanvil/
├── swiftanvil-meta/          ← START HERE — org memory, roadmap, planning
├── swiftanvil-cli/           ← CLI tool (swiftanvil command)
├── swiftanvil-anvil-runner/  ← Managed worker tooling
├── swiftanvil-enforcement/   ← Shared enforcement scripts
├── .github/                  ← Org profile repo
└── swiftanvil-anvil-*/       ← Individual packages (a11y, bench, strings, etc.)
```

## Important Notes

- `swiftanvil-meta/` is the **single source of truth** for organization planning.
- The old `iFoundation` repo (in `~/Documents/v-i-s-h-a-l/github/iFoundation/`) is **archived/historical**.
- All phase children (1.1 through 4.5) now live in `swiftanvil-meta/Children/`.
- The orchestration framework requires **cross-host review** (different model from builder) for plan and implementation reviews.

---

*Last updated: 2026-06-04*
