# Plan Review Request: SwiftAnvil Meta + Enforcement Split

## Intention

Review the plan and architecture decisions from the current SwiftAnvil organization setup session.

This is not primarily a code review. The goal is to validate whether the repository structure, enforcement model, public documentation strategy, and LLM-agent compatibility rules are coherent, scalable, and inclusive for contributors using different local or hosted AI tools.

## Context

SwiftAnvil is a public multi-repository Swift organization. Contributors may use different LLM agents or no LLM at all. The workflow should not require one provider, one CLI, one editor, one local workspace path, or private access to complete ordinary public contribution work.

The session started from a misleading legacy `iFoundation` repository that mixed product code, planning memory, roadmap, platform policy, and orchestration docs. The organization now needs clearer boundaries.

## Plan Under Review

### 1. Workspace and Repository Boundaries

Adopt a local workspace convention where organization repositories live under a dedicated `swiftanvil/` folder, separate from personal repositories.

Repository roles:

| Repository | Role |
|------------|------|
| `swiftanvil-meta` | Public policy, roadmap, shared memory, document registry, agent compatibility |
| `swiftanvil-enforcement` | Public reusable validators, local hooks, reusable GitHub Actions workflows |
| `swiftanvil-*` product repos | Swift packages and CLI implementation |
| `swiftanvil/.github` | Organization profile and shared GitHub community files |

### 2. Public Meta Repository

Make `swiftanvil-meta` public because the organization and product repositories are public, and the shared workflows are intended for all contributors and their chosen agents.

Meta owns:

- `REGISTRY.yml`
- `AGENTS.md`
- `AGENT_COMPATIBILITY.md`
- `ROADMAP.md`
- platform policy
- package registry
- improvement framework
- orchestration workflow

### 3. Central Document Registry

Use `REGISTRY.yml` as the canonical routing table for stable document IDs and paths.

Rule:

- Active docs, checklists, and agent instructions should refer to stable document IDs such as `meta.session-start`, `policy.platform`, `agents.compatibility`, and `packages.registry`.
- The registry owns physical paths.
- Historical review artifacts and generated docs may be excluded through explicit ignore rules.

### 4. Enforcement Repository

Create `swiftanvil-enforcement` as a separate public tooling repo.

It owns:

- `scripts/validate-document-registry.sh`
- `scripts/install-git-hooks.sh`
- `.github/workflows/document-registry-policy.yml`
- `templates/document-registry-policy.yml`

Rationale:

- Policy and memory stay in `swiftanvil-meta`.
- Enforcement implementation stays reusable and versionable in `swiftanvil-enforcement`.
- Product repos only include a thin workflow wrapper.

### 5. Local and CI Enforcement

Local:

- Install pre-commit hooks across cloned SwiftAnvil repos.
- Hooks call the central validator.

CI:

- Every current SwiftAnvil repo has `.github/workflows/document-registry-policy-check.yml`.
- The wrapper calls `swiftanvil-enforcement/.github/workflows/document-registry-policy.yml@main`.
- Current workflow runs are green across all existing repositories.

Remaining hardening:

- Configure GitHub branch protection or org rulesets to require the "Document Registry Policy" check before merge.
- Avoid admin bypass except for explicit emergency override.
- Ensure new repositories are bootstrapped from templates that include the workflow wrapper.

### 6. Agent Compatibility

Add `AGENT_COMPATIBILITY.md` and register it as `agents.compatibility`.

Principles:

- No specific LLM provider, product, CLI, IDE, or private account is required.
- Instructions must describe capabilities and artifacts, not a mandatory vendor command.
- Independent review may be performed by any capable second LLM, hosted review tool, IDE assistant, local model, or human reviewer.
- Optional examples can name tools, but required workflow language should remain provider-neutral.

### 7. Public Readiness

Before making `swiftanvil-meta` public:

- Scan for obvious secrets and private tokens.
- Remove personal workspace assumptions from active docs.
- Remove private-token dependency from enforcement docs.

Outcome:

- `swiftanvil-meta` is public.
- `swiftanvil-enforcement` is public.
- Registry validation passes locally across all current SwiftAnvil repositories.
- Document Registry Policy workflow is green across all current SwiftAnvil repositories.

## Specific Review Questions

1. Is the split between `swiftanvil-meta` and `swiftanvil-enforcement` the right abstraction boundary?
2. Should the document registry live in `swiftanvil-meta`, `swiftanvil-enforcement`, or be mirrored/generated between them?
3. Is enforcing stable document IDs instead of hardcoded paths a good rule, or is it likely to create too much friction?
4. Is `.swiftanvil-registry-ignore` the right escape hatch for historical/generated docs?
5. Is the agent compatibility policy sufficiently inclusive for contributors using different LLM setups?
6. What additional enforcement rules should be prioritized next?
7. What should be required at the GitHub organization level so new repos automatically inherit enforcement?
8. Are there public-repo risks in making `swiftanvil-meta` public that still need mitigation?
9. Are there better alternatives, such as GitHub organization rulesets, composite actions, reusable workflows, repo templates, or a dedicated bootstrap CLI?

## Desired Reviewer Output

Please provide:

1. Verdict: `APPROVED`, `APPROVED_WITH_NOTES`, or `NEEDS_REVISION`.
2. Top risks or flaws in the plan.
3. Recommended improvements.
4. Any missing enforcement mechanisms.
5. Any concerns about public visibility or agent inclusivity.

Focus on plan quality and architecture. Do not spend time on shell-script implementation details unless they affect the plan.
