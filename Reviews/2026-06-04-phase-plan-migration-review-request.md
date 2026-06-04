# Review Request: Phase Plan Migration and Managed Worker Roadmap

## Intention

Review whether the phase-wise planning migration correctly prevents SwiftAnvil work from becoming scattered across
independent repositories. The original planning structure lived in a local historical repository, while the current
organization now uses `swiftanvil-meta` as shared memory. This review should validate the planning decision, not the
implementation code of AnvilRunner.

## Builder

Codex.

## Reviewer Ask

Please review the changed planning artifacts for:

1. Whether `swiftanvil-meta` is the right canonical place for the organization roadmap and child plans.
2. Whether the historical phase-child workflow was migrated in a useful way without copying stale local assumptions.
3. Whether AnvilReport, AnvilRunner, managed worker discovery, worker doctor checks, provisioning, and fleet profiles
   are sequenced correctly.
4. Whether the single-maintainer review policy is described honestly.
5. Whether the plan is sufficiently generic for different local LLM agents and worker host configurations.
6. Whether any missing child, phase gate, dependency, or enforcement rule should be added before implementation
   continues.

## Files To Review

- `roadmap.org`
- `planning.children-index`
- `planning.child-4-1`
- `planning.child-4-1-result`
- `planning.child-4-1-provenance`
- `planning.child-4-2`
- `planning.child-4-2-result`
- `planning.child-4-2-provenance`
- `planning.child-4-3`
- `planning.child-4-4`
- `planning.child-4-5`
- `workflow.general`
- `workflow.orchestration`
- `meta.agents`
- `meta.session-start`
- `meta.registry`

## Expected Output

Return one of:

- APPROVED
- APPROVED_WITH_NOTES
- NEEDS_REVISION

Lead with the verdict, then list findings by severity. Focus on planning correctness, missing governance, sequencing,
and risks that would cause future agents to do work outside the phase workflow.
