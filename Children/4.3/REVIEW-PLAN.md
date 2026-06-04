# Child 4.3 Plan Review

## Verdict

APPROVED_WITH_NOTES

## Summary

The plan for `Children/4.3/PLAN.md` correctly scopes AnvilReport as a shared, registry-driven
organization health report that lives in `swiftanvil-meta`, and it cleanly separates this child from
the worker capability work in 4.4 and provisioning in 4.5. The framing, problem statement, non-goals,
and risk register are sound and consistent with `ROADMAP.md` (line 17, line 326–335) and
`Children/README.md` (line 52). However, the plan is too abstract to hand to an arbitrary capable
agent and have them execute deterministically: the report schema, file paths, registry IDs, generation
mechanism, and success-criteria measurability are all under-specified. These should be tightened
either by amending PLAN.md or by addressing them explicitly in the first execution step.

## Strengths

- Clear, well-articulated problem statement (lines 13–16) — explains *why* agents need this report.
- Explicit non-goals (lines 28–32) reduce scope-creep risk into Child 4.5 (provisioning) and into
  dashboard UI work that belongs in Phase 5.
- Risk register (lines 53–58) correctly identifies the staleness risk and proposes a credible
  mitigation ("Prefer generated fields and explicit last-verified dates").
- Consistent with `ROADMAP.md` line 17 ("Current Active Child: `planning.child-4-3`") and
  `Children/README.md` line 52 ("Planned Next").
- Registry already pre-allocates `planning.child-4-3` at `REGISTRY.yml` line 450–454, so the plan
  document itself does not require any new registry entry to land.
- Correctly identifies that the report contract must be defined *before* downstream docs depend on
  paths (risk-row 2) — this is good registry hygiene.

## Concerns

### Critical

- None. The plan does not violate framework rules, has verifiable (if soft) success criteria, and is
  scoped to a single primary repo.

### Major

- **Report schema is named as a deliverable but never defined.** Line 38 says "Report schema —
  Defines fields and meanings" but the plan never enumerates the fields. The Scope bullet on lines
  22–23 lists categories ("repository status, latest release, CI status where available, review
  provenance status, registry enforcement status, and open phase ownership") but does not specify
  per-field structure, types, or required vs optional. Without a schema sketch, two different agents
  will produce two structurally different reports, defeating the "shared source of truth" goal.
  Recommendation: include at least a draft schema (YAML or table) in PLAN.md, even if marked
  provisional, before EXECUTE begins.
- **No file paths, filenames, or registry IDs proposed for the report artifacts.** The plan commits
  to a "Report schema", an "Initial report document", and a "Generation script or task plan"
  (lines 38–42), but does not say:
  - Where they live in `swiftanvil-meta` (e.g. `REPORT.md` at root? `Reports/ORG_HEALTH.md`?
    `MEMORY/`?)
  - What stable IDs to register (e.g. `report.org-health`, `report.org-health-schema`,
    `report.org-health-generator`).
  - Whether the schema is YAML, JSON, or markdown tables.
  This is needed for `REGISTRY.yml` to be updated in EXECUTE, and `ORCHESTRATION_FRAMEWORK.md` Step
  1 explicitly requires "Naming (repo, module, product)" in the plan (line 97).
- **No task breakdown with estimates.** `ORCHESTRATION_FRAMEWORK.md` line 95 ("Task breakdown with
  estimates") lists this as a required component of Step 1 / PLAN output. The PLAN has Deliverables
  (lines 36–42) but no task list, no ordering, and no effort estimates. Child 4.2's plan got away
  with this because it was a *retroactive backfill* (line 5 of 4.2 PLAN: "This child backfills…");
  4.3 is forward-looking and should not.
- **"Generation script or task plan" is ambiguous (line 40).** This is two materially different
  deliverables. A *script* implies automation against repo metadata (gh CLI, swift, shell). A *task
  plan* implies manual maintenance with a checklist. The plan should pick one for v1 and defer the
  other, or define explicit criteria for choosing during EXECUTE. The "manual-backed, then automate"
  hint in the Notes column is a direction, not a decision.
- **Success criteria are qualitative.** Lines 46–50 are reasonable but not all are objectively
  verifiable:
  - "A new agent can read the report and know the next phase child" — verifiable by manual prompt,
    but no test is described.
  - "The report distinguishes historical iFoundation planning from current SwiftAnvil source of
    truth" — verifiable by inspection.
  - "Enforcement passes locally" — which enforcement? `swiftanvil-enforcement` includes registry
    validation and review-provenance validation (per `ROADMAP.md` line 306). Be explicit.

  Recommendation: convert success criteria into a checklist where each item names the specific
  command, file, or behavior that proves it.

### Minor

- The plan's "Status" field says "Planned next." (line 5) — this matches `ROADMAP.md` and the index,
  but consider the canonical form used elsewhere ("Planned Next" capitalization, `ROADMAP.md` line
  332).
- Line 24 ("Make the report useful to any capable LLM agent, not only one named CLI.") is good
  framing but could be operationalized: include an "agent legibility" success criterion (e.g.,
  "Report front-matter or top section names the next active child by registry ID").
- The plan does not mention how AnvilReport relates to existing documents that already partially
  cover this ground:
  - `improvement.dashboard` (`REGISTRY.yml` line 474–478, `IMPROVEMENT_DASHBOARD.md`)
  - `packages.registry` (`REGISTRY.yml` line 110–114, `MEMORY/07-PACKAGES.md`)
  - `roadmap.org` (the at-a-glance table in `ROADMAP.md` lines 9–22 already encodes phase ownership)
  Clarify whether AnvilReport supersedes, summarizes, or links to these, to avoid the staleness risk
  the plan itself flags.
- "Review request" deliverable (line 42) is satisfied by this REVIEW-PLAN.md, but the plan does not
  state where the corresponding `REVIEW-PROVENANCE.md` for 4.3 will live or that it will be
  registered. Per `REGISTRY.yml`, prior phase-4 children register both the plan and a provenance
  artifact (lines 414–448); 4.3 currently only has `planning.child-4-3` registered. Plan should
  commit to registering `planning.child-4-3-result` and `planning.child-4-3-provenance` on
  completion.
- "Local enforcement support" was an explicit deliverable of 4.1 (`ROADMAP.md` line 308) and 4.2
  (line 323). The plan should explicitly state that AnvilReport's generation/validation must also
  pass `swiftanvil-enforcement` registry validation, not just be implied by "Enforcement passes
  locally."
- The risk "Report becomes another stale document" is real and the mitigation ("Prefer generated
  fields and explicit last-verified dates") is good — but consider also recording the *source
  command* alongside each generated field, so a future agent can regenerate without guessing how
  the value was produced.

## Questions for Builder

1. **Schema format**: Will the report's structured data be YAML, JSON, or only inferred from a
   Markdown document? A YAML companion file unlocks `swiftanvil-enforcement`-style validation later.
2. **Exact paths**: What is the proposed path for the human-readable report and (if separate) its
   structured data? Suggestion: `ORG_REPORT.md` at root with `org-report.yml` next to it, both
   registered.
3. **Generation mechanism for v1**: Is v1 manually authored and committed (with the "task plan"
   serving as the regeneration runbook), or is there a script in this child? If a script, in which
   language and using which APIs (`gh`, Swift, shell)?
4. **Private repository data**: Non-goals exclude private repo access (line 32). Does the org have
   any private repos that should be excluded from the report, or is this purely defensive scoping?
5. **Relationship to existing memory docs**: Does AnvilReport replace or summarize
   `IMPROVEMENT_DASHBOARD.md` and `MEMORY/07-PACKAGES.md`, or live alongside them with explicit
   cross-references?
6. **Trigger for refresh**: When is the report regenerated — at the end of every child? On a
   schedule? When `swiftanvil-enforcement` runs? Whoever updates it needs a clear rule.
7. **Worker readiness fields**: Phase 4 work blocks (4.4 doctor, 4.5 provisioning) will need to
   surface worker capability state. Should v1 of the report reserve fields/sections for that,
   marked "TBD: filled by Child 4.4"?

## Suggested Improvements

| # | Improvement | Priority | Effort |
|---|------------|----------|--------|
| 1 | Add a draft schema section to PLAN.md listing every field, its type, and whether it is generated or hand-maintained. Mark provisional. | P1 | Small |
| 2 | Pin concrete paths and registry IDs for the report, the schema, and the generator/runbook before EXECUTE. | P1 | Small |
| 3 | Replace prose Success Criteria with a verifiable checklist (each item names a file, command, or behavior to test). | P1 | Small |
| 4 | Add a Task Breakdown section with ordered tasks and rough estimates, per `ORCHESTRATION_FRAMEWORK.md` line 95. | P1 | Small |
| 5 | Decide v1 generation mechanism (manual + runbook vs script) and write the decision into the plan; defer the other to a follow-up. | P1 | Small |
| 6 | Clarify relationship to `improvement.dashboard`, `packages.registry`, and `roadmap.org` so the report does not duplicate or drift from them. | P2 | Small |
| 7 | Commit, in PLAN.md, to registering `planning.child-4-3-result` and `planning.child-4-3-provenance` on completion. | P2 | Small |
| 8 | Specify which enforcement validations must pass ("registry validation" and "review provenance validation" by name, not just "enforcement passes locally"). | P2 | Small |
| 9 | Record a "source command" or "derivation" alongside generated fields to prevent staleness. | P2 | Small |
| 10 | Reserve placeholder sections in the report for worker capability (4.4) and fleet status (4.5) so later children only fill, not restructure. | P3 | Small |
| 11 | Operationalize "useful to any capable LLM agent" — e.g., name the next active child by registry ID at the top of the report. | P3 | Small |
| 12 | Normalize the Status line to match the canonical "Planned Next" capitalization used in `ROADMAP.md` line 332. | P3 | Trivial |
