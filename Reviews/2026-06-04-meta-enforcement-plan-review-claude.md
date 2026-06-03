# Plan Review: SwiftAnvil Meta + Enforcement Split

## 1. Verdict

**APPROVED_WITH_NOTES**

The architectural separation is sound and matches how successful multi-repo orgs (e.g. SwiftLang, Apple's swift-* org, Vapor) draw the line. The boundary chosen — *policy + routing in meta, executable enforcement in a separate reusable repo* — is the right one. What keeps this from a clean `APPROVED` is that several load-bearing pieces (versioning contract between the two repos, machine-checkable agent neutrality, org-level enforcement guarantees, history hygiene before flipping public) are present as intentions but not yet as concrete mechanisms.

---

## 2. Top Risks / Flaws

1. **Implicit schema contract between `swiftanvil-meta` and `swiftanvil-enforcement`.**
   The validator hard-depends on the shape of `REGISTRY.yml`, but neither side declares a schema version. The two repos can release independently and silently drift. A `schema_version` field in `REGISTRY.yml` and a supported-range check in the validator is the cheap fix.

2. **`@main` pinning of the reusable workflow.**
   Product repos pointing at `swiftanvil-enforcement/.github/workflows/document-registry-policy.yml@main` means any push to enforcement immediately changes every product repo's CI semantics. A bad merge to enforcement turns every PR red across the org. Pin product repos to a tag (`@v1`) and release enforcement with semver.

3. **Stable-IDs as a hard rule without tooling to make compliance easy.**
   Requiring `meta.session-start` instead of a path is a clean principle but will create real PR-level friction unless contributors (and their agents) have a way to:
   - look up the right ID without reading the registry by hand,
   - auto-register a new doc when adding one,
   - get an actionable error message ("Did you mean `policy.platform`?").
   Without that, the registry becomes a tax that humans dodge via the ignore file.

4. **`.swiftanvil-registry-ignore` is a quiet escape hatch.**
   Today it's a relief valve; tomorrow it's where every "I'll fix it later" file lands. Two mitigations: require an inline comment justifying each entry, and emit a CI warning (not failure) listing ignored counts so drift is visible.

5. **Branch protection is the only thing making the green-check meaningful.**
   The plan acknowledges this but it's currently the single biggest enforcement gap — the workflow exists but isn't *required*. Until a ruleset enforces it, "all repos green" is honor-system green.

6. **Public flip is irreversible per commit, not per repo.**
   The plan's pre-publish secret scan covers current tree, but `swiftanvil-meta` was extracted from a "misleading legacy `iFoundation` repo" that mixed planning memory, roadmap, and orchestration docs. The git *history* of meta may still contain pre-split content that wasn't intended for the public. Audit `git log -p` for the full history, not just `HEAD`, before flipping public — and consider a clean-history rewrite if anything sensitive surfaces.

7. **"Any capable LLM" without a defined review-artifact contract.**
   Agent neutrality as a *principle* is right, but if every agent returns review output in a different shape, downstream tooling (CI gates, dashboards) can't consume it uniformly. Either define a minimal schema for review artifacts (verdict vocabulary, required sections) or accept that "agent neutrality" applies only to authoring, not to machine-consumed outputs.

---

## 3. Recommended Improvements

**Versioning & coupling**
- Add `schema_version` to `REGISTRY.yml` and `AGENT_COMPATIBILITY.md`.
- Tag enforcement releases (`v1.0.0`, …) and require product repos to pin by tag.
- Add a `compat` test in enforcement CI that runs the validator against the current `swiftanvil-meta` `main` to catch drift early.

**Ergonomics around stable IDs**
- Ship a `validate --suggest` mode that, on unknown path, prints the nearest registered IDs.
- Add a `register <path>` subcommand that appends a stub entry to `REGISTRY.yml` with a sensible default ID.
- Document a naming convention for IDs (`<domain>.<slug>`) so contributors and agents converge without coordination.

**Agent inclusivity made enforceable**
- Add a doc-lint rule that flags vendor-specific imperatives ("run `claude ...`", "use Cursor's …") in any doc registered as policy or agent-facing. Allow them only in clearly marked "Examples" sections.
- Provide a *no-LLM* contributor path explicitly in `AGENT_COMPATIBILITY.md`: someone with just an editor and a terminal must be able to do everything. If they can't, that's a bug in the docs.
- Distinguish *required capability* (read files, edit text) from *preferred capability* (tool use, web access). Avoid implying any minimum tier of agent.

**Public-readiness hardening**
- Pre-publish checklist: secret scan over full history (`gitleaks --log-opts="--all"` or equivalent), license declaration, `CODE_OF_CONDUCT.md`, `SECURITY.md`, and a CODEOWNERS file.
- A `swiftanvil/.github` org-profile repo with shared community health files reduces drift across product repos.
- Roadmap phrasing audit — anything in `ROADMAP.md` becomes a public commitment. Frame as "directions" or "in exploration" unless you mean it.

**Bootstrap & drift prevention**
- A template repository (`swiftanvil-template`) that already contains the workflow wrapper, a registry-aware `AGENTS.md`, MIT/Apache license, and CODEOWNERS. New repos created from it inherit enforcement on day one.
- Optional: a small `swiftanvil-cli bootstrap` command that instantiates the template and registers the new repo's docs. Worth it once you're creating > ~3 new repos.

---

## 4. Missing Enforcement Mechanisms

| Gap | Why it matters | Suggested mechanism |
|---|---|---|
| Required status check at org level | "Green everywhere" today is voluntary | GitHub **org ruleset** matching `swiftanvil-*`, requiring the Document Registry Policy check |
| Required workflows | New repos can be created without the wrapper | GitHub's **required workflows** feature, or a `repo-created` automation that opens a bootstrap PR |
| Workflow-wrapper drift detection | Product repos can edit their wrapper to bypass the call | Validator should fail if a repo's wrapper diverges from `templates/document-registry-policy.yml` beyond the pinned-version line |
| Workflow YAML linting | Wrappers silently rot | `actionlint` + `yamllint` in enforcement CI |
| Schema validation of `REGISTRY.yml` | Hand-edited registry can break the validator | JSON Schema + a `validate-schema` job in `swiftanvil-meta` CI |
| Secret scan in CI | Public-repo posture must be ongoing, not one-time | `gitleaks` (or similar) as part of the reusable workflow |
| Admin-bypass audit | Emergency override needs a paper trail | Restrict bypass to a named group; require post-hoc issue/PR documenting the override |

---

## 5. Public-Visibility & Agent-Inclusivity Concerns

**Public-visibility**
- Verify the *full git history* of `swiftanvil-meta` (and any repo extracted from `iFoundation`) for personal paths, vendor credentials, prompt strategies, internal cost references, or third-party names that shouldn't be public.
- `ROADMAP.md` going public turns it into a commitment artifact. Choose phrasing accordingly.
- Anything that reveals internal review patterns or proprietary prompt structures may not be sensitive but is *strategic*. Decide deliberately whether that's an asset (transparency) or a leak.
- Reusable workflows can receive secrets from callers — audit that the workflow file doesn't expose `${{ secrets.* }}` to logs or third-party actions, since it now runs publicly across consumers.

**Agent-inclusivity**
- The current principles cover provider neutrality well but don't yet address *capability* asymmetry: agents with tool use, web access, and large context will produce richer reviews than smaller local models. State explicitly which capabilities a contributor's chosen setup must have to complete required workflows, and which are nice-to-have.
- The no-LLM contributor path is the canary: if a human with `vi` and `bash` cannot complete a required workflow, the workflow is implicitly agent-coupled.
- "Independent review by any capable second LLM" is a good principle, but consider whether *self-review by the same model under different framing* is allowed — public contributors using a single hosted account will run into this.

---

## 6. Better Alternatives to Consider

- **Composite action** vs. **reusable workflow**: keep the reusable workflow (you want a distinct check-run name on PRs) but extract the validation step into a composite action so it can also be invoked from arbitrary jobs.
- **Org rulesets** > branch protection: rulesets apply by name pattern across the org and survive repo creation. They're the right primitive here.
- **Required workflows** (GitHub feature): can guarantee the policy workflow runs on every repo without each repo needing to commit a wrapper. Worth piloting — it removes an entire class of drift.
- **Bootstrap CLI**: only worth building if you'll create new repos frequently. Until then, a `swiftanvil-template` repo plus org ruleset gets you ~90% of the benefit.

---

## Answers to Specific Questions (condensed)

1. **Meta vs enforcement boundary** — yes, correct boundary. Add a schema-version contract.
2. **Registry location** — `swiftanvil-meta`. Don't mirror. Don't generate. Single source of truth.
3. **Stable IDs** — right rule, *underpowered tooling*. Won't survive contact with contributors unless you ship a `register`/`suggest` ergonomic.
4. **`.swiftanvil-registry-ignore`** — acceptable as an escape hatch; add justification comments and a CI visibility report.
5. **Agent compatibility** — principles are inclusive; enforcement is not yet machine-checkable. Add a doc-lint and a no-LLM contributor path.
6. **Next enforcement priorities** — (1) org ruleset requiring the check, (2) tag-pin enforcement releases, (3) full-history secret scan before public, (4) schema validation of `REGISTRY.yml`.
7. **Org-level requirements** — org ruleset on `swiftanvil-*`, required workflows, `swiftanvil/.github` profile repo, template repository.
8. **Public risks remaining** — git history of meta, roadmap phrasing, reusable-workflow secret surface, license/CoC/CODEOWNERS scaffolding.
9. **Better alternatives** — org rulesets + required workflows + template repo is a stronger stack than per-repo wrappers alone. Defer a bootstrap CLI until the repo count justifies it.
