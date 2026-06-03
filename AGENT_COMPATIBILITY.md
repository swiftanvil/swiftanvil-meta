# Agent Compatibility Policy

SwiftAnvil workflows must work for contributors using different LLM agents, local tools, and host environments.

## Core Rule

No repository may require one specific LLM provider, product, CLI, account, editor, or operating-system-specific path to complete ordinary contribution work.

## Supported Agent Model

The workflow is capability-based:

| Role | Required Capability |
|------|---------------------|
| Builder agent | Can read repository files, edit files, run tests, and summarize changes |
| Reviewer agent | Can independently review plans, diffs, or implementation artifacts |
| Human contributor | Can run documented scripts without installing a specific LLM product |

Examples of compatible setups include any combination of local CLI agents, hosted chat agents, IDE assistants, or manual human review, as long as the required artifacts are produced.

## Agent-Agnostic Requirements

- Instructions must describe the role and expected output, not a specific vendor command.
- If a command example is useful, use placeholders such as `<reviewer-command>` and document how to substitute a local tool.
- Cross-host review means an independent reviewer from the builder. It does not require a specific product.
- If no second LLM is available, a human reviewer may satisfy the independent review requirement.
- If no independent reviewer is available after documented attempts, self-review is allowed only under the fallback rules in `workflow.orchestration`.

## Forbidden Assumptions

- Do not require a contributor to install a named LLM CLI.
- Do not hardcode personal paths, account names, API keys, or machine-specific directories.
- Do not require private organization access for public contribution workflows unless the task genuinely needs private data.
- Do not make examples depend on one user's local workspace layout.

## Public Repository Rule

Public SwiftAnvil repositories must be usable from a fresh clone with:

1. Standard platform tooling for that repository, such as SwiftPM for Swift packages.
2. Documented enforcement scripts from `swiftanvil-enforcement`.
3. Public documentation and registries.

Any optional agent-specific convenience command must be clearly optional.
