# Review: Process Remediation PR Enforcement

- **Reviewer:** Independent sibling-host reviewer (Claude Code, Opus 4.7 1M context)
- **Date:** 2026-06-04
- **Request:** `Reviews/2026-06-04-process-remediation-review-request.md`
- **Scope:** Working trees of `swiftanvil-enforcement@enforce-pr-provenance`, `swiftanvil-meta@document-process-exception`, `.github@add-pr-provenance-template`

## Verdict

`NEEDS_REVISION`

Two small, fixable issues block approval; the overall approach is sound.

## Blocking Issues

### B1. Verdict regex accepts invalid values (`validate-pr-provenance.sh`)

`phase_row_has_valid_verdict` uses substring regex matches:

```awk
if (verdict ~ /APPROVED/ || verdict ~ /APPROVED_WITH_NOTES/ || verdict ~ /NEEDS_REVISION/ || verdict ~ /SELF-REVIEWED/) ...
```

Empirically verified: a body with `| Plan | ... | UNAPPROVED | ... |` passes the verdict check, because `/APPROVED/` matches `UNAPPROVED` as a substring. The `/APPROVED_WITH_NOTES/` clause is also unreachable (already matched by `/APPROVED/`).

**Fix:** Use exact comparison after the existing normalization (uppercase, stripped punctuation/space):

```awk
if (verdict == "APPROVED" || verdict == "APPROVED_WITH_NOTES" \
    || verdict == "NEEDS_REVISION" || verdict == "SELF-REVIEWED") ...
```

Add a self-test in `test-enforcement.sh` that asserts a row with verdict `UNAPPROVED` is rejected, so this regression is locked in.

### B2. Unrelated `actions/checkout@v4 → v6` upgrade mixed into `.github` PR

Branch `add-pr-provenance-template` also modifies `.github/workflows/ci.yml`, upgrading two `actions/checkout` references from `v4` to `v6`. That change is unrelated to the PR template and was already shipped to the enforcement repo via a *direct push* (`5b67836`) — which is exactly the failure mode this remediation is supposed to discourage. Bundling another unrelated bump into the remediation PR makes it harder to review and mirrors the pattern under remediation.

**Fix:** Either (a) drop the `checkout@v6` change from this PR and open a separate `bump-checkout-action-v6` PR, or (b) rename the branch/PR scope and call the upgrade out in the description so the reviewer is not surprised. Option (a) is preferred.

## Non-Blocking Notes

### N1. Direct-push prevention is documented, not implemented

The motivating failure was a direct push to `main`. The remediation's three changed repos enforce only at PR time. The exception doc lists `Branch rules — Tighten organization rulesets so admins cannot casually bypass PR requirements` as `Pending`, but no script, ruleset JSON, or audit step has been added. Consider committing a source-of-truth ruleset (e.g., `.github/rulesets/main.json`) plus an audit script (`scripts/audit-branch-rulesets.sh` using `gh api repos/<owner>/<repo>/rulesets`) so the direct-push gate is verifiable. Without this, PR-body enforcement is the only technical control, and a maintainer with bypass rights can repeat the original failure.

### N2. Body re-validation depends on caller event configuration

`pull_request.body` is only refreshed for events `opened`, `edited`, `synchronize`, `reopened`. The reusable workflow runs whatever the caller wires up. A caller that only listens for `opened` would let an author submit a passing body, then edit it to remove the table. The enforcement README should tell callers to use, at minimum:

```yaml
on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
```

### N3. Trigger guard works but is idiomatically odd

`if: ${{ github.event.pull_request.number != '' }}` relies on `null != ''` coercing to false. `if: ${{ github.event_name == 'pull_request' }}` reads more clearly and is what most projects use.

### N4. `pull_request_target` caveat

If a caller wires the workflow into `pull_request_target` (which has write-token access), the PR body validator runs against attacker-controlled text in a privileged context. The current step is body parsing only — no `eval`, no shell expansion of the body — so the risk is low, but the README should explicitly steer callers to `pull_request`.

### N5. Validator measures presence, not authenticity

Anyone can type `Independent reviewer | Claude | APPROVED | 1 | LGTM`. The check is a procedural gate, not a security control. This is fine — but the README and `WORKFLOW.md` should say so plainly, so contributors and future agents do not over-trust the gate.

### N6. `printf '%s' "$SWIFTANVIL_PR_BODY"` is safe — keep it that way

The current shape (env-injected, quoted, `%s`-formatted) avoids GitHub Actions expression injection. A future edit that replaces this with `${{ github.event.pull_request.body }}` directly in the `run:` block would be exploitable. Adding a single-line comment in the workflow saying "do not interpolate `pull_request.body` into `run:` directly" would help.

### N7. Self-test step runs on every caller invocation

`enforcement/scripts/test-enforcement.sh` runs as the final policy step on every caller PR. Defensible (it's quick and ensures the toolchain itself is healthy), but it does spend caller minutes on enforcement-repo self-tests. Consider gating it to `push` events on the enforcement repo only, and skipping it on caller PRs.

### N8. Registry ID style

`process.exception.direct-push-2026-06-04` is functional. For consistency with the filename (`2026-06-04-direct-push-enforcement-remediation.md`), `process.exception.2026-06-04-direct-push` would sort cleanly with future exceptions and keep the date prefix uniform. Cosmetic.

### N9. `WORKFLOW.md` sentence has no traceable target

> "The shared policy workflow rejects pull requests that omit the Review Provenance table or leave placeholder provenance values."

Add a registry-style reference (e.g., `enforcement.pr-provenance` if a doc exists, or a link to `swiftanvil-enforcement/README.md#pr-provenance-enforcement`) so the assertion is auditable.

### N10. Untracked files

`scripts/validate-pr-provenance.sh` (enforcement) and `Process-Exceptions/` (meta) are still untracked. Stage them by explicit path rather than `git add .` so unrelated working-tree artifacts do not leak in.

## Answers to Review Questions

1. **Addresses or only documents?** Partly documents. The PR-side gate is real; the direct-push prevention is documented but not enforced — see N1.
2. **Right enforcement point?** Yes — reusable policy workflow is the right home for a check that all caller repos need. Body parsing inside that workflow is correct as long as callers run it on `pull_request`, not `pull_request_target` (N4).
3. **Too strict for ordinary PRs?** Acceptable. The two-row table is the lightest credible artifact; rejecting placeholders (`TBD`, `n/a`, blank) is right. Documenting `SELF-REVIEWED` as a permitted verdict gives a real escape hatch for trivial PRs.
4. **Exception record specific enough?** Yes. It names repos, the gaps, and remediation owners without exposing private local detail. Good as written.
5. **Missing enforcement points?** Yes — direct push and admin bypass (N1).
6. **Security concerns with PR body handling?** Low risk as written; keep the env-var + `printf '%s'` shape (N6). Steer callers away from `pull_request_target` (N4).
7. **Blank cells vs example placeholder text in template?** Blank is correct. Example values like `Independent reviewer | Claude | APPROVED | 1 | Looks good` would pass the validator even if no review happened — strictly worse than blank cells that fail loudly.

## Recommended Changes Before Opening the PRs

1. **`swiftanvil-enforcement/scripts/validate-pr-provenance.sh`** — fix the verdict check to exact match (B1) and add a self-test for `UNAPPROVED`.
2. **`.github`** — split the `actions/checkout@v6` bump out of `add-pr-provenance-template` (B2).
3. **`swiftanvil-enforcement/.github/workflows/document-registry-policy.yml`** — replace the `pull_request.number != ''` guard with `github.event_name == 'pull_request'` (N3); add an inline comment warning future editors not to interpolate `pull_request.body` into the `run:` block (N6).
4. **`swiftanvil-enforcement/README.md`** — document caller-side `pull_request.types` requirements (N2) and the `pull_request_target` caveat (N4).
5. **`swiftanvil-meta/Process-Exceptions/2026-06-04-direct-push-enforcement-remediation.md`** — either land a ruleset audit script in the same PR (preferred) or link a tracked issue ID for the `Branch rules` row so it is not a perpetual `Pending` (N1).
6. **`swiftanvil-meta/WORKFLOW.md`** — link the new assertion to the enforcement README section (N9).
7. Stage new files by explicit path in each commit (N10).

## Review Provenance (suggested values for the PR table)

| Phase | Reviewer | Model | Verdict | Rounds | Key Findings |
|-------|----------|-------|---------|--------|--------------|
| Plan | Independent sibling-host reviewer (Claude Code) | Opus 4.7 (1M context) | APPROVED_WITH_NOTES | 1 | Exception record, validator design, and PR template scope are reasonable; direct-push remediation remains documentation-only. |
| Impl | Independent sibling-host reviewer (Claude Code) | Opus 4.7 (1M context) | NEEDS_REVISION | 1 | Verdict regex accepts `UNAPPROVED` via substring match; unrelated `checkout@v6` bump bundled into `.github` PR; ruleset audit not yet implemented. |
