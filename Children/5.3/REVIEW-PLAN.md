---
priority: HIGH
type: REVIEW
audience: BUILDER
phase: 5
child: 5.3
reviewer: Cross-host (Claude)
last_updated: 2026-06-04
---

# Child 5.3 Plan Review: Release & Distribution (Revised)

## Summary

The revised plan addresses all major blockers from the initial review. It now includes:
- Explicit prerequisite acknowledgment (all packages platform-compliant)
- Detailed signing/notarization workflow with GitHub Secrets, keychain handling, and stapling
- Homebrew formula mechanics with template and validation script
- Docker multi-stage build specification with platform targets
- Per-artifact rollback procedure
- Release dry-run workflow for safe testing
- Updated `WORKFLOW.md` as an explicit deliverable

## Strengths

1. **Prerequisites clearly stated.** Acknowledges platform compliance was achieved before Phase 5.
2. **Signing workflow is implementable.** Exact commands for keychain creation, import, codesign, notarytool, stapling, and cleanup are provided.
3. **GitHub Secrets table is complete.** All 6 required secrets are documented with descriptions.
4. **Certificate expiry detection is concrete.** `security find-identity` check on every build with 30-day warning threshold.
5. **Homebrew formula template is provided.** The Ruby formula with `{{TAG}}` and `{{SHA256}}` placeholders is ready for workflow integration.
6. **Dockerfile is specified.** Multi-stage build with `swift:6.0-jammy` builder and `ubuntu:24.04` runtime.
7. **Rollback table is clear.** Per-artifact actions with "never delete public tags" rule.
8. **Dry-run workflow prevents production debugging.** `release-dry-run.yml` builds without signing on PRs.
9. **Test scripts are deliverables.** `test-homebrew-formula.sh` and `test-docker-image.sh` ensure validation.

## Concerns

### 1. `bump-version.sh` Still Under-Specified (Minor)

The plan says the script "updates version in Package.swift, README, source code" but does not specify:
- Which source files contain version strings (e.g., `iFoundation.swift` has `version: "0.1.0"`)
- How it handles repos without a CHANGELOG.md
- Whether it uses `sed`, `perl`, or a custom parser

This is acceptable for v1 but may cause friction during implementation.

### 2. No Mention of Release Note Auto-Generation (Minor)

The workflow says "Create GitHub Release with auto-generated notes" but does not specify:
- GitHub's built-in auto-generate (from PR labels)?
- Custom script reading CHANGELOG.md?
- Required PR labels (`bug`, `enhancement`, `breaking`)?

This can be addressed during implementation.

## Suggestions

1. **Add a note about `swiftanvil-cli` version string location.** The CLI's `iFoundation.swift` has a hardcoded version that `bump-version.sh` must update.
2. **Document PR label conventions** if using GitHub's auto-generated release notes.
3. **Consider adding a `CHANGELOG.md` template** to `swiftanvil-meta` for repos that don't have one.

## Verdict

**APPROVED_WITH_NOTES**

The revised plan is comprehensive, secure, and actionable. The two minor notes above can be addressed during implementation. Proceed to EXECUTE.
