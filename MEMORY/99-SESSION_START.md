---
priority: CRITICAL
type: CHECKLIST
audience: BUILDER
last_updated: 2026-06-06
---

# Session Start Checklist

Every session begins here. Do not skip steps.

## Step 1: Load Memory (2 min)

Read `meta.registry`, then resolve and read these document IDs in order.

**Always read (6 docs, ~500 lines total):**
- [ ] `memory.meta` — how this memory system works
- [ ] `memory.identity` — who we are
- [ ] `policy.platform` — minimum platform requirements
- [ ] `workflow.orchestration` — plan/review/execute/verify/document workflow
- [ ] `packages.registry` — package status and scores
- [ ] `planning.children-index` — current phase children and status

**Read when relevant (conditional — check trigger before loading):**
- [ ] `meta.resume` — human session resumption (human-in-the-loop sessions only)
- [ ] `improvement.framework` — if any package score < 80 (see Step 2) or improvement work planned
- [ ] `agents.compatibility` — if using a new or unusual agent
- [ ] `agents.diagnostics` — if agent/reviewer commands fail
- [ ] `naming.registry` — if naming decisions are being made
- [ ] `quality.standards` — if reviewing code or writing tests
- [ ] `modernization.api` — if platform policy violations are present or dropping OS version
- [ ] `upgrade.platform` — if platform policy violations are present (see Step 2)

## Step 2: Check Health (1 min)

- [ ] Any package score < 80? → Improvement sprint first
- [ ] Any platform policy violations? → Upgrade sprint first
- [ ] Any blocked items? → Check if unblocked
- [ ] Any stale branches? → Clean up

### Current Known Health Gate (2026-06-06)

`packages.registry` currently lists package PMS blockers:

- `AnvilMacros` — 58 (F): add DocC catalog, CI workflow, and git tag first
- `AnvilCore` — 65 (C): tag v1.0.0 and add performance benchmarks
- `AnvilMenuBar` — 65 (C): tag v1.0.0
- `AnvilSettings` — 65 (C): tag v1.0.0
- `AnvilWindow` — 65 (C): tag v1.0.0

Until these are resolved or explicitly overridden by the user, do not start lower-priority roadmap implementation. After the PMS gate clears, finish `planning.child-9-5` workflow artifacts before starting `planning.child-9-6`.

## Step 3: Check Boundary (30 sec)

Before planning any feature, verify it belongs in SwiftAnvil:

- [ ] Does this involve task orchestration, worker dispatch, or credential leases? → **Belongs in iStudio, not here**
- [ ] Does this involve Swift code style, platform policy, build tooling, or distribution? → **Belongs in SwiftAnvil**
- [ ] Does this cross both boundaries? → **Document the split; do not merge concerns**

Reference: `meta.agents` Boundary Rule section.

## Step 4: Plan Work (2 min)

- [ ] Read `roadmap.org` for planned child
- [ ] Check if dependencies need updating
- [ ] Verify platform requirements match policy (iOS 18+, macOS 15+)

## Step 5: Execute

Proceed with planned work, following `workflow.orchestration`.

## Step 6: Update Memory (1 min)

- [ ] Update `packages.registry` if scores changed
- [ ] Update `naming.registry` if names changed
- [ ] Update `modernization.api` if old APIs found
- [ ] Commit all memory changes

---

**Total startup time: ~7 minutes. Prevents hours of rework.**
