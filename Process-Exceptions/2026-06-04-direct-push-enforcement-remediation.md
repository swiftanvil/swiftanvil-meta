# Process Exception: Direct Push During Enforcement Remediation

## Summary

On 2026-06-04, several SwiftAnvil enforcement and documentation updates were pushed directly to `main` instead of going through the documented pull request workflow.

This exception record exists because the direct-push path did not satisfy `workflow.general` or `workflow.orchestration`.

## Affected Repositories

| Repository | Direct-Push Change | Reason Given During Session | Compliance Gap |
|------------|--------------------|-----------------------------|----------------|
| `swiftanvil-enforcement` | Dynamic agent review enforcement, workflow pinning, checkout action update | Urgent organization-wide enforcement cleanup | No PR, no implementation sibling-host review, no PR provenance table |
| `swiftanvil-meta` | Agent diagnostics and review status updates | Record corrected reviewer-home diagnostics | No PR provenance table |
| `swiftanvil-anvil-project` | Generated workflow checkout action update | Remove Node 20 deprecation warning from generated workflows | Direct push instead of PR |
| `swiftanvil-cli` | Generated workflow checkout action update | Remove Node 20 deprecation warning from generated workflows | Direct push instead of PR; branch rule reported admin bypass |

## Required Remediation

| Item | Remediation | Owner | Status |
|------|-------------|-------|--------|
| PR provenance | Enforce the review provenance table in pull request bodies | `swiftanvil-enforcement` | In progress |
| Contributor prompt | Add the required provenance table to the organization pull request template | `.github` | In progress |
| Exception record | Keep this exception documented and registered | `swiftanvil-meta` | In progress |
| Sibling-host review | Run independent review for the remediation PRs | Builder plus independent reviewer | Pending |
| Branch rules | Tighten organization rulesets so admins cannot casually bypass PR requirements | Organization owner | Tracked in swiftanvil-meta#1 |

## Required Review Provenance

| Phase | Reviewer | Model | Verdict | Rounds | Key Findings |
|-------|----------|-------|---------|--------|--------------|
| Plan | User process review | Human | NEEDS_REVISION | 1 | Direct pushes bypassed the documented workflow and omitted the expected summary table. |
| Impl | Pending sibling-host reviewer | Pending | NEEDS_REVISION | 0 | This exception remains open until remediation PRs are reviewed. |

## Closure Criteria

- Remediation changes are opened as pull requests.
- Each remediation pull request includes the required review provenance table.
- Enforcement CI validates pull request provenance.
- Independent sibling-host review is recorded before merge.
- Direct-push exception remains referenced by stable document ID.
- Organization ruleset hardening is completed or explicitly deferred in swiftanvil-meta#1.
