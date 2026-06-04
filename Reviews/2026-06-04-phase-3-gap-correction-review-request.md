# Review Request: Phase 3 Gap Correction

## Intention

Review the correction to SwiftAnvil's roadmap and workflow after discovering that Phase 3 was overstated.

The current evidence shows:

- `swiftanvil-anvil-docs` does not exist in the SwiftAnvil GitHub organization.
- The old local docs folder under the historical planning repository contains only a roadmap file and a stale remote.
- `swiftanvil-meta` previously showed Phase 3 as 4/5 complete, which is not defensible.

## Builder

Codex.

## Reviewer Ask

Please review whether the correction is appropriate:

1. Phase 3 is changed from 4/5 complete to 3/5 complete.
2. Current active child becomes `planning.child-3-4`.
3. Child 3.4 is documented as Documentation Generator Recovery and Promotion.
4. Child 3.5 remains Testing and Verification.
5. Phase 4 remains partially started because governance and AnvilRunner work already happened, but new Phase 4
   implementation should wait until Phase 3 is reconciled or explicitly de-scoped.
6. `workflow.general` now requires agents to compare `roadmap.org` with `planning.children-index`.
7. `packages.registry` no longer claims AnvilDocs is released.

## Files To Review

- `roadmap.org`
- `planning.children-index`
- `planning.child-3-4`
- `planning.child-3-5`
- `workflow.general`
- `checklist.legacy`
- `packages.registry`
- `meta.registry`

## Expected Output

Return one of:

- APPROVED
- APPROVED_WITH_NOTES
- NEEDS_REVISION

Lead with the verdict, then list findings by severity. Focus on whether the correction is honest, whether it creates
unnecessary process churn, and whether any additional phase gate or child plan is needed.
