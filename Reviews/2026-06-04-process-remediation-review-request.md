# Review Request: Process Remediation PR Enforcement

## Intention

Review the remediation for a process failure where organization changes were pushed directly to `main` instead of going through the documented pull request workflow.

The desired outcome is that future SwiftAnvil changes are harder to merge without:

- a pull request,
- sibling-host review provenance,
- a filled review provenance table,
- local and CI enforcement,
- a documented exception when the process is bypassed.

## Scope

This review covers three local branches:

| Repository | Branch | Purpose |
|------------|--------|---------|
| `swiftanvil-enforcement` | `enforce-pr-provenance` | Add PR provenance validation and CI wiring |
| `swiftanvil-meta` | `document-process-exception` | Record the direct-push exception and update workflow guidance |
| `.github` | `add-pr-provenance-template` | Add the provenance table to the shared PR template |

## Changed Files

### `swiftanvil-enforcement`

- `.github/workflows/document-registry-policy.yml`
- `AGENTS.md`
- `README.md`
- `scripts/validate-pr-provenance.sh`
- `scripts/test-enforcement.sh`

### `swiftanvil-meta`

- `REGISTRY.yml`
- `WORKFLOW.md`
- `Process-Exceptions/2026-06-04-direct-push-enforcement-remediation.md`

### `.github`

- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/workflows/ci.yml`

## Implementation Summary

The enforcement repository now includes `scripts/validate-pr-provenance.sh`, which checks that a pull request body contains:

- the required `Phase / Reviewer / Model / Verdict / Rounds / Key Findings` table,
- a `Plan` row,
- an `Impl` row,
- non-placeholder values,
- a valid verdict.

The reusable policy workflow writes the pull request body to `pr-body.md` through an environment variable and runs the validator only for pull request events.

The enforcement self-test now covers:

- a valid provenance table,
- missing implementation row,
- placeholder values.

The meta repository records the prior direct-push gap as a process exception and registers it with a stable document ID.

The organization `.github` repository adds the provenance table to the PR template so contributors and agents see the required fields before CI runs.

## Local Verification Already Run

```sh
shellcheck scripts/*.sh scripts/lib/*.sh adapters/*.sh
scripts/test-enforcement.sh
scripts/enforce-local.sh --registry-root ../swiftanvil-meta --root ../swiftanvil-enforcement
../swiftanvil-enforcement/scripts/enforce-local.sh --registry-root . --root .
../swiftanvil-enforcement/scripts/enforce-local.sh --registry-root ../swiftanvil-meta --root .
```

All listed local checks passed before this review request.

## Review Questions

1. Does this remediation address the actual process failure, or does it only document it?
2. Is validating the PR body provenance table in the reusable policy workflow the right enforcement point?
3. Is the validator too strict for ordinary contributor PRs?
4. Is the process exception record specific enough to be useful later without overexposing private local details?
5. Are there missing enforcement points, especially around direct pushes and admin bypass?
6. Are there security concerns with handling pull request body text in the workflow?
7. Should the PR template use blank cells or example placeholder text?

## Requested Output

Return:

1. Verdict: `APPROVED`, `APPROVED_WITH_NOTES`, or `NEEDS_REVISION`.
2. Blocking issues, if any.
3. Non-blocking notes.
4. Specific recommended changes before opening the PRs.
5. Review provenance values suitable for the PR table.

## Revision Notes After Review Round 1

The first Claude review returned `NEEDS_REVISION`. The remediation has been updated to address the blocking findings:

- `scripts/validate-pr-provenance.sh` now uses exact verdict matching so `UNAPPROVED` cannot pass via substring matching.
- `scripts/test-enforcement.sh` now includes an invalid-verdict regression case.
- The unrelated `.github/workflows/ci.yml` checkout action bump was removed from the `.github` PR-template branch.

Additional hardening was added after reviewing the enforcement behavior:

- `scripts/validate-review-artifacts.sh` now requires at least one `APPROVED` or `APPROVED_WITH_NOTES` review for each review request. A successful reviewer run with `NEEDS_REVISION` no longer satisfies the gate.
- `scripts/test-enforcement.sh` now asserts that `NEEDS_REVISION` review metadata does not pass the artifact validator.
- The reusable workflow now uses `github.event_name == 'pull_request'` for the PR provenance step.
- The workflow includes an inline warning not to interpolate pull request body text directly into the shell script.
- The enforcement README documents the recommended `pull_request` event types and warns against `pull_request_target`.
- The direct-push/admin-bypass gap is tracked in swiftanvil-meta#1 and linked from the process exception record.

## Post-PR CI Fix

After opening the `.github` PR, the org profile repository CI failed because `.github/workflows/ci.yml` assumed every repository contains `Package.swift`.

The `.github` branch was updated to:

- use `actions/checkout@v6`,
- detect whether `Package.swift` exists,
- skip Swift build/test steps when no package exists.

The refreshed `.github` PR checks passed after this fix.
