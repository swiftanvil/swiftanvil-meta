---
priority: CRITICAL
type: CHECKLIST
audience: BUILDER
last_updated: 2026-06-04
---

# Session Start Checklist

Every session begins here. Do not skip steps.

## Step 1: Load Memory (2 min)

Read `meta.registry`, then resolve and read these document IDs in order:

**Always read (6 docs):**
- [ ] `memory.meta` — how this memory system works
- [ ] `memory.identity` — who we are
- [ ] `policy.platform` — minimum platform requirements
- [ ] `workflow.orchestration` — plan/review/execute/verify/document workflow
- [ ] `packages.registry` — package status and scores
- [ ] `planning.children-index` — current phase children and status

**Read when relevant (conditional):**
- [ ] `meta.resume` — human session resumption (human-in-the-loop sessions only)
- [ ] `improvement.framework` — if any package score < 80 (see Step 2)
- [ ] `agents.compatibility` — if using a new or unusual agent
- [ ] `agents.diagnostics` — if agent/reviewer commands fail
- [ ] `naming.registry` — if naming decisions are being made
- [ ] `upgrade.platform` — if platform policy violations are present (see Step 2)

## Step 2: Check Health (1 min)

- [ ] Any package score < 80? → Improvement sprint first
- [ ] Any platform policy violations? → Upgrade sprint first
- [ ] Any blocked items? → Check if unblocked
- [ ] Any stale branches? → Clean up

## Step 3: Plan Work (2 min)

- [ ] Read `roadmap.org` for planned child
- [ ] Check if dependencies need updating
- [ ] Verify platform requirements match policy (iOS 18+, macOS 15+)

## Step 4: Execute

Proceed with planned work, following `workflow.orchestration`.

## Step 5: Update Memory (1 min)

- [ ] Update `packages.registry` if scores changed
- [ ] Update `naming.registry` if names changed
- [ ] Update `modernization.api` if old APIs found
- [ ] Commit all memory changes

---

**Total startup time: ~7 minutes. Prevents hours of rework.**
