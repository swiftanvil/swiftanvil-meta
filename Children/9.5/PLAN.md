# Child 9.5 Plan: iStudio Boundary Document & Enforcement

## Goal

Write the canonical boundary document that defines the separation between SwiftAnvil (toolkit + standards) and iStudio (orchestration runtime). Add enforcement mechanisms so the boundary is maintained automatically, not just documented.

## Non-Goals

- Do not migrate code in this child — migration is Child 9.6
- Do not modify iStudio repository — SwiftAnvil-side changes only
- Do not implement Horizon 1-4 tooling — those are Phase 10

## Background

SwiftAnvil and iStudio are separate repositories with separate concerns. SwiftAnvil owns Swift-specific policy, lint, scaffolding, and build tooling. iStudio owns task orchestration, worker dispatch, credential leases, and goal workflow. The boundary has been discussed and agreed but not formally documented or enforced.

## Tasks

### T1: Write Boundary Document

Create `BOUNDARY.md` in `swiftanvil-meta` with:

1. **Product Relationship** — Toolkit vs. Orchestrator
2. **Repository Independence** — Why they stay separate
3. **Dependency Direction** — iStudio → SwiftAnvil (already true via AnvilRunner)
4. **Policy Sharing** — SwiftAnvil defines policy; iStudio references it
5. **Tool Sharing** — `swiftanvil lint` is a CLI tool iStudio can invoke
6. **Workflow Sharing** — Reusable GHA workflows for Swift projects
7. **Integration Contract** — `.istudio/profile.yaml` schema for SwiftAnvil-enabled projects
8. **What is NOT Shared** — iStudio's task state, credentials, worker dispatch; SwiftAnvil's package internals

### T2: Update AGENTS.md with Redirect Rules

Add explicit redirect rules:
- "If feature involves task orchestration → STOP, belongs in iStudio"
- "If feature involves Swift policy → STOP, belongs in SwiftAnvil"
- "If cross-boundary → document the split, do not merge concerns"

### T3: Update Session Start Checklist

Add "Check Boundary" step (30 sec) to `MEMORY/99-SESSION_START.md`.

### T4: Add Boundary to ROADMAP

Phase 9 is now active with two children: 9.5 (boundary doc) and 9.6 (validator migration).

### T5: Update REGISTRY.yml

Add document IDs for boundary doc and child plans.

## Success Criteria

- [ ] `BOUNDARY.md` exists and is readable by humans and AI agents
- [ ] `AGENTS.md` has redirect rules that an AI can follow
- [ ] `99-SESSION_START.md` has boundary check step
- [ ] `ROADMAP.md` shows Phase 9 active with 9.5 and 9.6
- [ ] `REGISTRY.yml` has entries for boundary doc and child plans
- [ ] Cross-host plan review APPROVED or APPROVED_WITH_NOTES

## Estimated Effort

2-3 hours writing + review.
