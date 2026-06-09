# Child 9.5 Result: iStudio Boundary Document & Enforcement

> **Goal:** Write the canonical boundary document that defines the separation between SwiftAnvil (toolkit + standards) and iStudio (orchestration runtime). Add enforcement mechanisms so the boundary is maintained automatically.
> **Status:** ✅ Complete
> **Date:** 2026-06-09

---

## Summary

All deliverables exist and are verified. The SwiftAnvil ↔ iStudio boundary is now formally documented, embedded in agent instructions, and enforced through the session-start checklist and cross-host review gates.

---

## Deliverables

### T1: Boundary Document (`BOUNDARY.md`)

**Location:** `swiftanvil-meta/BOUNDARY.md`  
**Registry ID:** `boundary.istudio`

Covers:
- Product Relationship (toolkit vs. orchestrator)
- Repository Independence (why they stay separate)
- Dependency Direction (iStudio → SwiftAnvil)
- What SwiftAnvil Owns (8 concern areas with CLI commands)
- What iStudio Owns (7 concern areas)
- Integration Contract (`.istudio/profile.yaml` schema, iStudio calls SwiftAnvil CLI, reusable GHA workflows)
- What is NOT Shared (explicit exclusions table)
- Redirect Rules for Future Development (decision table)
- Enforcement Mechanisms (PR templates, lint rules, cross-host review gate)

### T2: Agent Redirect Rules (`AGENTS.md`)

**Location:** `swiftanvil-meta/AGENTS.md` — Boundary Rule section  
**Registry ID:** `meta.agents`

Added explicit redirect table:
- Swift code style / platform policy / build tooling → **SwiftAnvil**
- Task orchestration / worker dispatch / credential leases → **iStudio**
- Cross-boundary → **STOP and document the split**

### T3: Session Start Checklist (`MEMORY/99-SESSION_START.md`)

**Location:** `swiftanvil-meta/MEMORY/99-SESSION_START.md` — Step 3  
**Registry ID:** `meta.session-start`

Added "Check Boundary" step (30 sec):
- Task orchestration → iStudio
- Swift policy → SwiftAnvil
- Cross-boundary → document the split

### T4: Roadmap Update (`ROADMAP.md`)

**Location:** `swiftanvil-meta/ROADMAP.md`  
**Registry ID:** `roadmap.org`

- Phase 9 unified under "iStudio Boundary & Tooling Expansion"
- Ecosystem Hardening (9.1–9.4) moved to subsection
- Progress updated to 4/6
- Gate status updated to cleared

### T5: Registry Entries (`REGISTRY.yml`)

**Location:** `swiftanvil-meta/REGISTRY.yml`  
**Registry ID:** `meta.registry`

Already contained:
- `boundary.istudio` → `BOUNDARY.md`
- `planning.child-9-5` → `Children/9.5/PLAN.md`
- `planning.child-9-6` → `Children/9.6/PLAN.md`

---

## Verification

- [x] `BOUNDARY.md` exists and is readable by humans and AI agents
- [x] `AGENTS.md` has redirect rules that an AI can follow
- [x] `99-SESSION_START.md` has boundary check step
- [x] `ROADMAP.md` shows Phase 9 correctly (fixed duplicate heading)
- [x] `REGISTRY.yml` has entries for boundary doc and child plans
- [x] Cross-host review APPROVED_WITH_NOTES (one high finding resolved)

---

## Review Fix

**High finding from review:** ROADMAP.md had two conflicting `## Phase 9` sections. Fixed by renaming the first to `### Phase 9.1–9.4: Ecosystem Hardening` and updating progress to 4/6.

---

## Next Work

Child 9.6: Migrate iStudio Validators to SwiftAnvil
- Move `SwiftSourceStructureValidator` → `swiftanvil lint source --structure`
- Move Swift-specific file health budgets → `.swiftanvil.yml` config
- iStudio pre-commit hook calls `swiftanvil lint source`
