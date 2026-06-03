# Independent Review: SwiftAnvil Meta + Enforcement Split

**Reviewer:** Independent sibling-host (Claude, Opus 4.7)
**Date:** 2026-06-04
**Scope:** Plan architecture and intention; not implementation minutiae.

---

## 1. Verdict

**APPROVED_WITH_NOTES**

The split is the right architectural move, the intentions are coherent, and the agent-inclusivity stance is well calibrated for a public Swift organization. There are no fatal flaws. There are, however, several non-trivial gaps in enforcement, governance, and the contract between `swiftanvil-meta` and `swiftanvil-enforcement` that should be closed before this structure is locked in and inherited by every new repo.

The notes below are the conditions I'd attach to that approval.

---

## 2. Top Risks and Flaws

### 2.1 The meta ↔ enforcement contract is implicit
`swiftanvil-meta` owns the policy artifact (`REGISTRY.yml`, ignore rules, document IDs) and `swiftanvil-enforcement` owns the validator that interprets it. That is a cross-repo API. Nothing in the plan describes:

- a schema/version for `REGISTRY.yml`,
- a compatibility guarantee between validator versions and registry versions,
- a deprecation policy for retired document IDs,
- the failure mode when the validator and registry drift.

This is the single biggest structural risk. Once product repos depend on the shape of `REGISTRY.yml`, breaking changes become organization-wide events.

### 2.2 `@main` pinning of the reusable workflow
Wrappers reference `swiftanvil-enforcement/.github/workflows/document-registry-policy.yml@main`. That is a floating reference. A bad commit in enforcement breaks every product repo at once, including unrelated PRs. It also means CI behavior is not reproducible from a product repo's commit SHA alone — the same product SHA can pass today and fail tomorrow.

### 2.3 No org-level guarantee that new repos inherit enforcement
The plan acknowledges this ("Ensure new repositories are bootstrapped from templates") but treats it as a manual hardening step. In practice, the moment a maintainer creates a repo via the GitHub UI without the template, the enforcement model has a hole and nobody will notice until a non-compliant PR merges.

### 2.4 Stable document IDs without ergonomics will create friction
The rule "refer to stable IDs, not paths" is sound, but humans and most LLMs will reach for paths by default. Without:

- an easy lookup ("which ID points where?"),
- an easy registration flow ("I'm adding a new doc, give me an ID"),
- a clear renderer/resolver that turns `meta.session-start` into a clickable link in GitHub,

the policy will be evaded by people copying paths into PR descriptions, issues, and inline references. The validator can enforce IDs in tracked docs, but the social convention will erode unless using IDs is cheaper than using paths.

### 2.5 Public-repo surface area is larger than "scan for secrets"
Making `swiftanvil-meta` public exposes more than tokens. It exposes:

- the shape of internal planning (roadmap, improvement framework, orchestration workflow),
- historical review artifacts (these reviews themselves),
- naming and routing conventions that hint at private infrastructure.

None of those are necessarily problems. But "scan for secrets" is not the same as "decide what we are comfortable being permanently indexed and quoted by third-party LLM crawlers." That decision should be made explicitly per-document class, not as a one-time pre-publish sweep.

### 2.6 The escape hatch is a single ignore file
`.swiftanvil-registry-ignore` is fine as a mechanism but invites two failure modes:

- Bulk-ignoring entire trees (`reviews/**`) to silence the validator instead of fixing real drift.
- Unexplained entries that accumulate over years with no record of *why* a path is excluded.

Without per-entry justification and periodic review, the ignore list becomes the registry's shadow truth.

---

## 3. Recommended Improvements

### 3.1 Treat `REGISTRY.yml` as a versioned schema
- Add a top-level `schema_version:` field.
- Document supported schema versions in `swiftanvil-enforcement`.
- Validator should reject unknown versions with a clear error and a link to the migration note.
- Mark document IDs with `status: active | deprecated | removed` rather than deleting entries — deprecated IDs should still resolve, with a warning, for one release cycle.

### 3.2 Pin and tag the reusable workflow
- Tag `swiftanvil-enforcement` releases (`v1`, `v1.2.0`, etc.).
- Product repo wrappers should reference a major tag (`@v1`) or a SHA, not `@main`.
- Use a Dependabot/Renovate config in product repos to surface enforcement bumps as PRs, so updates are observable and revertible.
- Keep `@main` available for `swiftanvil-enforcement`'s own self-test, not for downstream consumers.

### 3.3 Move enforcement inheritance to the org layer
- Define a GitHub **organization ruleset** that requires the "Document Registry Policy" check on the default branch of every repo matching `swiftanvil-*`.
- Rulesets attach by repo name pattern, so a freshly created repo is governed before its first commit lands — no template required.
- Keep repo templates as the *convenient* path, but do not rely on them as the *enforcing* path.
- Disable admin bypass; require an explicit, logged emergency override (e.g. a dedicated bypass role enabled only for incident response).

### 3.4 Add ergonomics around document IDs
- Provide a small CLI or `make` target in `swiftanvil-enforcement` to:
  - resolve an ID to a path/URL,
  - list all IDs grouped by domain,
  - register a new document (writes the registry entry).
- Render `REGISTRY.yml` to a human-readable index in `swiftanvil-meta` (e.g. `REGISTRY.md` generated from the YAML) so people can browse IDs on github.com.
- Document the canonical "how to link a doc from a PR" pattern (`meta.session-start` rendered as a link via the index).

### 3.5 Strengthen the ignore-list contract
- Each entry in `.swiftanvil-registry-ignore` should require an inline reason comment.
- Validator should warn (not fail) if any ignored path no longer exists — ignores should not outlive what they ignore.
- Add a periodic review checklist item ("audit the ignore list quarterly") to the meta improvement framework.

### 3.6 Define a "what is safe public" matrix
Before flipping visibility, classify each top-level doc class:

| Class | Public? | Why |
|---|---|---|
| Policy, AGENTS.md, REGISTRY.yml, ROADMAP.md | Yes | These are the artifacts contributors need. |
| Review artifacts | Yes-by-default, but explicit | These will be quoted by LLMs; decide if that is desired. |
| Session memory, orchestration logs | Case-by-case | These can leak intent and internal cadence. |
| Improvement framework drafts | Case-by-case | Often contains opinions about people/process. |

A short `PUBLIC_VISIBILITY.md` (registered as e.g. `meta.public-visibility`) makes this decision durable and reviewable.

### 3.7 Add a minimal review-artifact contract
Reviews are already an active artifact class (this file is one). The plan should specify:

- where they live,
- whether they are registry-tracked or ignored,
- what frontmatter or sections are required,
- retention/archival behavior.

Otherwise every reviewer (human or agent) will improvise, and the registry will either fight them or be silenced.

---

## 4. Missing Enforcement Mechanisms

In rough priority order:

1. **Org ruleset requiring the policy check** (see 3.3). Without this, enforcement is opt-in by convention.
2. **Schema-versioned registry + tagged enforcement releases** (3.1, 3.2). Without these, the cross-repo contract is unstable.
3. **Secret scanning and push protection at the org level**, not just a pre-publish sweep. GitHub's native secret scanning, push protection, and Dependabot alerts should be enabled org-wide for public repos.
4. **CODEOWNERS for `REGISTRY.yml`, `AGENTS.md`, `AGENT_COMPATIBILITY.md`, and platform policy.** Changes to these are organization-level changes; they should require review by a defined owner set, not whoever happens to be on the PR.
5. **A "registry must change with the doc" rule.** If a PR adds, moves, or renames a registered document, the validator should require a corresponding `REGISTRY.yml` change. This is the rule that actually keeps the registry truthful.
6. **A CI job that validates the validator** — a self-test in `swiftanvil-enforcement` that runs against a known-good and known-bad fixture set. Otherwise a silently broken validator passes every PR.
7. **Signed commits / signed tags on `swiftanvil-enforcement`** if product repos pin tags. Tag mutability is a supply-chain risk for reusable workflows.
8. **Branch protection on `swiftanvil-meta` itself.** The repo that owns policy must enforce its own policy — no direct pushes, required review, required status checks.

---

## 5. Public Visibility and Agent Inclusivity Concerns

### 5.1 Visibility
- Decide intentionally per-doc-class, as in 3.6. The biggest risk is not a leaked secret; it is permanently publishing internal *narrative* (planning sessions, review back-and-forth, opinions about tools) that the organization later wishes were private. Public repos are effectively append-only from a discoverability standpoint.
- Run secret scanning across **full git history**, not just the working tree, before flipping visibility. A token in a deleted file three commits back is still public after the flip.
- Add a `SECURITY.md` (registered, e.g. `meta.security`) describing how to report issues. Public repos that lack this attract low-quality drive-by reports through issues.

### 5.2 Agent inclusivity
The `AGENT_COMPATIBILITY.md` stance — capability-and-artifact based, no mandated vendor — is correct and aligns with the public-org intent. A few refinements:

- **State the negative case explicitly.** "No PR may require a specific provider's CLI to validate, reproduce, or merge." This is the rule; the rest is examples.
- **Pin the interface, not the agent.** Document the *artifacts* an agent must produce (a review file with sections X, Y, Z; a verdict from an enumerated set; a registered location) rather than the commands it runs. Any agent that can produce the artifact is compliant.
- **Be explicit that humans-without-LLMs are first-class.** "Independent review may be performed by any capable second LLM … or human reviewer" is good, but the doc should also state that no workflow step requires an LLM at all.
- **Avoid optional examples that quietly become required.** "For example, run `claude -p …`" tends to become "everyone uses `claude -p …`." Either keep examples in an appendix clearly marked non-normative, or rotate examples across multiple providers so none becomes the default.
- **Document a non-LLM fallback** for each automated step (e.g. "validation also runs as a plain shell command without any agent"). This is the proof that the workflow is genuinely provider-neutral.

The current attempt log in `Reviews/2026-06-04-meta-enforcement-plan-review-status.md` — where the Claude CLI needed a specific home directory and the Gemini CLI hit auth/trust issues — is itself evidence that the *review tooling* is currently provider-coupled even though the *policy* says it shouldn't be. The compatibility doc should acknowledge that gap and describe the path to closing it (e.g. a thin `run-agent-review.sh` that accepts any compliant agent and a documented artifact contract).

---

## 6. Answers to Specific Questions

1. **Split between `swiftanvil-meta` and `swiftanvil-enforcement`** — right boundary. Policy/memory vs. mechanism is a clean cut and matches how each side evolves.
2. **Where should the registry live** — in `swiftanvil-meta`. It is policy. Enforcement consumes it. Do not mirror; mirroring creates two sources of truth. Generate human-readable views from it instead.
3. **Stable IDs vs. paths** — good rule, but it will only stick if ID lookup/registration is as cheap as typing a path. Invest in ergonomics (3.4) or the rule will be quietly bypassed.
4. **`.swiftanvil-registry-ignore` as escape hatch** — acceptable, but require per-entry justification and periodic audit (3.5). Otherwise it becomes the shadow registry.
5. **Agent compatibility sufficiently inclusive** — directionally yes, with the refinements in 5.2. The current reviewer-tooling reality lags the stated policy; close that gap.
6. **Next enforcement priorities** — in order: org ruleset (3.3), registry schema version + tagged enforcement releases (3.1, 3.2), CODEOWNERS on policy files, "registry changes with doc" rule, validator self-test.
7. **Org-level requirements for new repos** — organization rulesets matching `swiftanvil-*`, org-wide secret scanning + push protection, default branch protection profile, repo creation restricted to maintainers, template repos as convenience not as enforcement.
8. **Public-repo risks needing mitigation** — full-history secret scan, explicit visibility classification per doc class (3.6), `SECURITY.md`, decision about whether review artifacts and session memory should be public-by-default.
9. **Better alternatives** — yes, in combination, not as replacements:
   - **Org rulesets** for inheritance (replaces template-as-enforcement).
   - **Composite action** wrapping the validator, so the wrapper workflow in product repos shrinks to ~5 lines.
   - **Reusable workflow** remains useful for richer orchestration; keep it tagged.
   - **Repo template** stays, but as ergonomics not enforcement.
   - **Bootstrap CLI** is worth it only if it does more than `git clone template` — e.g. installs hooks, registers the repo in `REGISTRY.yml`'s `repos:` section, and opens the initial PR.

---

## 7. Summary

The plan is sound. The split is correct, the public stance is correct, and the agent-neutral framing is correct. The work that remains is not architectural — it is hardening: versioning the contract between meta and enforcement, making inheritance automatic at the org layer rather than manual at repo creation, making the document-ID convention cheaper than the path convention, and being explicit about what "public" means for each class of artifact.

Address the items in §4 (especially 1–4) before depending on this structure across many repos, and the approval becomes unconditional.
