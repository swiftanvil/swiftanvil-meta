---
priority: HIGH
type: REVIEW
audience: BUILDER
phase: 5
child: 5.1
reviewer: Cross-host (Claude)
last_updated: 2026-06-04
---

# Child 5.1 Plan Review: Community Templates

## Summary

The plan is a solid, well-scoped foundation for a community template gallery. It correctly leverages existing SwiftAnvil infrastructure (AnvilTemplate, AnvilProject, AnvilWizard) and avoids scope creep by explicitly excluding package-manager features. However, several gaps in the manifest schema, security posture, and platform policy alignment need addressing before implementation can safely proceed.

---

## Strengths

1. **Leverages existing packages well.** The plan correctly identifies dependencies on Child 3.2 (Template Engine) and 3.3 (Project Generator) and does not propose reimplementing their capabilities.
2. **Scope discipline.** Non-goals are clearly stated: no dependency resolution, no in-repo hosting, no auth-gated discovery. This keeps the child tractable.
3. **Registry-first design.** A curated JSON/YAML registry in `swiftanvil-meta` is the right architectural choice — it enables PR-gated curation, auditability, and offline caching.
4. **Risk awareness.** The risk table correctly flags template drift, malicious submissions, and schema versioning as real concerns.
5. **Contributor documentation.** Including `CONTRIBUTING_TEMPLATES.md` as a first-class deliverable aligns with SwiftAnvil's documentation-first culture.

---

## Concerns

### 1. Manifest Schema Gaps (Completeness, Clarity)

The proposed YAML manifest is underspecified:

- **No `swift-tools-version` field.** Templates must declare which `Package.swift` / Swift tools version they require. Without this, a template that requires Swift 6.1 will fail cryptically on a Swift 6.0 host.
- **No `minimum-swiftanvil-version` field.** If the CLI gains new manifest features later, older CLIs need a clean way to reject incompatible manifests.
- **`files` array lacks `condition` support.** Real-world templates often have platform-conditional files (e.g., `AppDelegate.swift` vs `main.swift`). The schema should support optional `platforms` or `condition` per file entry.
- **No `post-install` hooks or validation.** The plan says a user should "get a working Vapor project," but there is no mechanism to verify that the installed template actually builds. A `postInstall` script or at least a `buildable: true` flag is needed for CI validation.
- **`variables` lacks type constraints.** The `choices` array implies an enum, but what about `Int` or `Bool` variables? The schema should specify `type: string | int | bool | choice`.
- **No `ignore` / `exclude` patterns.** Templates will contain `.git`, `.github`, CI configs, and README assets that should not be copied into the user's project.

### 2. Security of Install Path (Security)

The plan is dangerously vague about what `template install` actually does:

- **No install target directory specified.** Does it write to the current working directory? A subdirectory? Does it overwrite existing files?
- **No sandboxing or path traversal protection.** If a manifest contains `destination: ../../../.bashrc`, the CLI must reject it. The plan does not mention path canonicalization or a destination prefix check.
- **No checksum / signature verification.** The registry lists template repos, but `template install` presumably downloads from GitHub (or raw git). There is no mention of commit-SHA pinning, tag verification, or tarball checksums. A compromised template repo or MITM attack could inject malicious code.
- **No `postInstall` sandboxing.** If hooks are added later, they must run in a restricted environment. The plan should at least note this as a future constraint.

### 3. Platform Policy Inconsistency (Consistency)

- The example manifest lists `macOS 15+` only, but SwiftAnvil's platform policy requires **all five platforms** to be declared explicitly (iOS 18+, macOS 15+, tvOS 18+, watchOS 11+, visionOS 2+). A template that only supports macOS is fine, but the schema must require explicit platform declarations so the CLI can filter correctly.
- The plan does not state whether `TemplateManifest` will be a `Sendable` struct. Given SwiftAnvil's StrictConcurrency baseline, all public types must be `Sendable`. This should be explicit in the deliverables table.

### 4. Registry Design Gaps (Feasibility, Completeness)

- **No registry update mechanism.** How does the CLI cache the registry? Is there a TTL? Does it support offline mode? The plan should specify a `~/.swiftanvil/registry.json` cache with a `--refresh` flag.
- **No registry schema versioning.** The risk table mentions manifest schema versioning, but the registry itself (which lists templates and their metadata) also needs a version field so the CLI can evolve its parsing.
- **No dependency on AnvilWizard.** The `template list` and `template install` commands will likely need interactive prompts (e.g., "This template requires macOS 15+. Continue?"). The plan does not list AnvilWizard as a dependency, but it should.

### 5. Success Criteria Are Insufficiently Verifiable (Clarity)

- "A user can run `swiftanvil template list` and see at least 5 templates" — this is a manual check. It should include: "…and the output includes name, description, author, and supported platforms in a tabular format."
- "Template manifests validate against a schema" — against what? A JSON Schema? A Swift `Decodable` parse? A custom validator? The criteria should specify the validation mechanism and error-reporting expectations.
- "Contributing a new template is documented in < 10 steps" — this is a readability metric, not a verifiable test. Replace with: "A new contributor can follow `CONTRIBUTING_TEMPLATES.md` to submit a PR that passes CI validation without asking for help."

### 6. Test Coverage Requirement Missing (Consistency)

SwiftAnvil requires ≥80% test coverage. The plan does not mention tests for:
- Manifest parsing / validation
- Registry fetching / caching / offline behavior
- Install path traversal rejection
- File copy / overwrite / rollback logic
- Variable substitution integration with AnvilTemplate

These must be added as deliverables, with `InMemoryFileSystem` used for fast, isolated tests per AnvilProject's pattern.

### 7. Official Template Scope Ambiguity (Feasibility)

"Host 3–5 official templates" is vague. The plan should specify exactly which templates are in scope for this child, e.g.:
1. `swiftanvil-template-vapor` (backend)
2. `swiftanvil-template-swiftui` (iOS app)
3. `swiftanvil-template-cli` (executable)
4. `swiftanvil-template-library` (SPM library + DocC)
5. `swiftanvil-template-kit` (Swift Package with resources)

Creating 5 new repos, CI pipelines, and READMEs is significant work. The builder should confirm whether all 5 are required for child completion or if 3 are sufficient.

---

## Suggestions

1. **Expand the manifest schema** to include:
   - `swiftToolsVersion: String` (required)
   - `minimumSwiftanvilVersion: String` (required)
   - `manifestVersion: Int` (required, start at 1)
   - Per-file `platforms` or `condition` (optional)
   - `variables[].type: string | int | bool | choice` (required)
   - `exclude: [String]` (glob patterns, optional)
   - `postInstall: { script: String, description: String }` (optional, sandboxed)

2. **Define install behavior explicitly:**
   - Write to a new subdirectory named after the template (or user-provided name).
   - Reject `destination` values containing `..` or absolute paths.
   - Provide `--force` to overwrite existing files; default to failing with a clear error.
   - Use atomic writes (temp dir + move) with rollback on failure, consistent with AnvilProject.

3. **Add registry caching spec:**
   - Cache path: `~/.swiftanvil/registry.json`
   - Default TTL: 1 hour
   - `--refresh` flag to bypass cache
   - `--offline` flag to use cached registry only

4. **Add security requirements:**
   - Registry entries must include a `commitSHA` or `tag` field for reproducible installs.
   - CLI verifies that the downloaded tarball/zip matches the expected SHA-256 (stored in registry).
   - Path traversal rejection is a hard requirement with unit tests.

5. **Update deliverables table:**
   - Add `swiftanvil-anvil-wizard` as a dependency for interactive prompts.
   - Add test deliverables: `TemplateManifestTests`, `TemplateRegistryTests`, `TemplateInstallTests`.
   - Explicitly state `TemplateManifest` is a `Sendable` struct with `///` documentation.

6. **Clarify success criteria:**
   - Replace subjective criteria with verifiable, testable statements.
   - Include a CI validation criterion: "All official templates build successfully with `swift build` on macOS 15+ after installation."

7. **Add a `TemplateInstallError` enum** to the deliverables, with cases for: network failure, manifest validation failure, path traversal detected, unsupported platform, overwrite without `--force`, and post-install build failure.

---

## Verdict

**APPROVED_WITH_NOTES**

The plan is architecturally sound and correctly scoped, but the manifest schema, security model, and test coverage are insufficiently detailed for safe implementation. The builder must address the **7 concerns above** in a revised plan before proceeding to implementation. Specifically:

- **Must fix:** Manifest schema gaps (swift-tools-version, type constraints, exclude patterns), install path security (path traversal, overwrite behavior), and explicit test deliverables.
- **Should fix:** Registry caching spec, registry schema versioning, and success criteria verifiability.
- **Nice to have:** Exact list of 3 vs 5 official templates, `postInstall` hook design.

Once these notes are incorporated, the plan can move to the EXECUTE phase.
