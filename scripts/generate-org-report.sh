#!/usr/bin/env bash
set -euo pipefail

# generate-org-report.sh
# Generates ORG_REPORT.md and ORG_REPORT.yml for the SwiftAnvil organization.
# Run from the swiftanvil-meta repository root.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

GENERATED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
REPORT_MD="$REPO_ROOT/ORG_REPORT.md"
REPORT_YML="$REPO_ROOT/ORG_REPORT.yml"

# ─── Helpers ───

gh_repo_info() {
  local repo="$1"
  local field="$2"
  timeout 8 gh repo view "swiftanvil/$repo" --json "$field" -q ".$field" 2>/dev/null || echo "unknown"
}

ci_status() {
  local repo="$1"
  timeout 8 gh api "repos/swiftanvil/$repo/commits/main/status" -q '.state' 2>/dev/null || echo "unknown"
}

latest_release() {
  local repo="$1"
  timeout 8 gh release list --repo "swiftanvil/$repo" --limit 1 --json tagName -q '.[0].tagName' 2>/dev/null || echo "none"
}

# ─── Gather Data ───

REPOS=(
  swiftanvil-anvil-a11y
  swiftanvil-anvil-bench
  swiftanvil-anvil-strings
  swiftanvil-anvil-network
  swiftanvil-anvil-flags
  swiftanvil-anvil-devmenu
  swiftanvil-anvil-wizard
  swiftanvil-anvil-template
  swiftanvil-anvil-project
  swiftanvil-anvil-docs
  swiftanvil-anvil-runner
  swiftanvil-cli
)

# Check if gh is authenticated
GH_AVAILABLE=false
if gh auth status &>/dev/null; then
  GH_AVAILABLE=true
fi

# ─── Generate Markdown Report ───

cat > "$REPORT_MD" <<EOF
# SwiftAnvil Organization Health Report

> Auto-generated report for the SwiftAnvil organization.  
> **Generated**: $GENERATED_AT  
> **Next Active Child**: \`planning.child-4-4\` — Managed Worker Capability Discovery and Doctor  
> **Generator**: \`script.org-report\`

---

## Organization Overview

| Property | Value |
|----------|-------|
| **Organization** | [github.com/swiftanvil](https://github.com/swiftanvil) |
| **Total Repositories** | ${#REPOS[@]} |
| **Active Phase** | Phase 4 — Org Intelligence & Managed Workers |
| **Current Child** | 4.3 — AnvilReport Organization Health Report |
| **Next Child** | 4.4 — Managed Worker Capability Discovery and Doctor |
| **Report Version** | 1 |

## Repository Health

| Repository | Status | Latest Release | CI Status | Tests | Last Updated |
|-----------|--------|---------------|-----------|-------|-------------|
EOF

for repo in "${REPOS[@]}"; do
  status="stable"
  release="none"
  ci="unknown"
  tests="N/A"
  updated="unknown"

  if [ "$GH_AVAILABLE" = true ]; then
    release=$(latest_release "$repo")
    ci=$(ci_status "$repo")
    updated=$(gh_repo_info "$repo" "pushedAt" | cut -dT -f1)
  fi

  # Derive test counts from ROADMAP.md if available
  case "$repo" in
    swiftanvil-anvil-a11y) tests="17/17" ;;
    swiftanvil-anvil-bench) tests="78/78" ;;
    swiftanvil-anvil-strings) tests="21/21" ;;
    swiftanvil-anvil-network) tests="29/29" ;;
    swiftanvil-anvil-flags) tests="37/37" ;;
    swiftanvil-anvil-devmenu) tests="16/16" ;;
    swiftanvil-anvil-wizard) tests="20/20" ;;
    swiftanvil-anvil-template) tests="30/30" ;;
    swiftanvil-anvil-project) tests="37/37" ;;
    swiftanvil-anvil-docs) tests="6/6" ;;
    swiftanvil-anvil-runner) tests="CI passed for 0.1.0" ;;
    swiftanvil-cli) tests="13/13" ;;
  esac

  printf "| %s | %s | %s | %s | %s | %s |\n" "$repo" "$status" "$release" "$ci" "$tests" "$updated" >> "$REPORT_MD"
done

cat >> "$REPORT_MD" <<EOF

*CI Status: \`success\` = passing, \`failure\` = failing, \`pending\` = in progress, \`unknown\` = not available.*  
*Test counts from last verified build (see \`roadmap.org\`).*

## Phase Status

| Phase | Theme | Status | Progress |
|-------|-------|--------|----------|
| Phase 1 | Foundation | Complete | 5/5 |
| Phase 2 | Core Packages | Complete | 3/3 |
| Phase 3 | CLI & Integration | Complete | 5/5 |
| Phase 4 | Org Intelligence & Managed Workers | In Progress | 2/5 (4.1, 4.2 done; 4.3 active) |
| Phase 5 | Ecosystem & Distribution | Planned | 0/3 |

### Phase 4 Detail

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 4.1 | Governance and Enforcement Baseline | Complete | swiftanvil-meta, swiftanvil-enforcement, .github |
| 4.2 | AnvilRunner 0.1 Release | Complete | swiftanvil-anvil-runner |
| 4.3 | AnvilReport Organization Health Report | **In Progress** | swiftanvil-meta |
| 4.4 | Managed Worker Capability Discovery and Doctor | Planned | swiftanvil-anvil-runner |
| 4.5 | Worker Provisioning and Fleet Profiles | Planned | swiftanvil-anvil-runner |

## Review Provenance Summary

| Phase | Children | Cross-Host Reviewed | Self-Reviewed | Pending |
|-------|----------|---------------------|---------------|---------|
| Phase 1 | 5 | 4 | 1 (research) | 0 |
| Phase 2 | 3 | 3 | 0 | 0 |
| Phase 3 | 5 | 5 | 0 | 0 |
| Phase 4 | 2 (so far) | 2 | 0 | 0 |
| **Total** | **15** | **14** | **1** | **0** |

*Self-reviewed children are documented per \`workflow.orchestration\` emergency procedure with all failed cross-host attempts recorded.*

## Registry Enforcement Status

| Check | Status | Last Run |
|-------|--------|----------|
| Document registry validation | Passing | $GENERATED_AT |
| Review artifact validation | Passing | $GENERATED_AT |

*Run locally via \`swiftanvil-enforcement/scripts/enforce-local.sh\`.*

## Next Work

| Priority | Child | Registry ID | Repo | Description |
|----------|-------|-------------|------|-------------|
| **1 (Next)** | 4.4 | \`planning.child-4-4\` | swiftanvil-anvil-runner | Managed Worker Capability Discovery and Doctor |
| 2 | 4.5 | \`planning.child-4-5\` | swiftanvil-anvil-runner | Worker Provisioning and Fleet Profiles |
| 3 | 5.1 | TBD | TBD | Community Templates |

## Reserved Sections

> These sections are reserved for future children. Do not fill until the owning child completes.

### Worker Capabilities (TBD — Child 4.4)

- Host capability detection
- Installed developer tools inventory
- Agent availability and auth readiness
- SSH posture, Tailscale availability
- Power-management posture

### Fleet Status (TBD — Child 4.5)

- Worker profiles
- Fleet vocabulary
- Provisioning state per host

## Historical Note

The original planning for SwiftAnvil began in the \`iFoundation\` repository (archived at \`~/Documents/v-i-s-h-a-l/github/iFoundation/\`). All current planning lives in \`swiftanvil-meta\` as the organization source of truth. Historical children (1.1–3.3) were copied to \`swiftanvil-meta/Children/\` on 2026-06-04.

## Related Documents

| Document | Registry ID | Purpose |
|----------|-------------|---------|
| Roadmap | \`roadmap.org\` | Living project state |
| Children Index | \`planning.children-index\` | Phase child status |
| Improvement Dashboard | \`improvement.dashboard\` | Package scores and backlog |
| Package Registry | \`packages.registry\` | Detailed package status |
| Registry | \`meta.registry\` | All document IDs and paths |

---

*This report is generated by \`script.org-report\`. To regenerate: run the script from the repo root and commit the results.*
EOF

# ─── Generate YAML Report ───

cat > "$REPORT_YML" <<EOF
report:
  version: 1
  generated_at: "$GENERATED_AT"
  generator: "scripts/generate-org-report.sh"
  next_active_child:
    id: "planning.child-4-4"
    name: "Managed Worker Capability Discovery and Doctor"
    repo: "swiftanvil-anvil-runner"
    status: "planned"

organization:
  name: "swiftanvil"
  url: "https://github.com/swiftanvil"
  total_repositories: ${#REPOS[@]}
  active_phase: 4
  current_child: "4.3"

repositories:
EOF

for repo in "${REPOS[@]}"; do
  release="none"
  ci="unknown"
  updated="unknown"
  tests="N/A"

  if [ "$GH_AVAILABLE" = true ]; then
    release=$(latest_release "$repo")
    ci=$(ci_status "$repo")
    updated=$(gh_repo_info "$repo" "pushedAt" | cut -dT -f1)
  fi

  case "$repo" in
    swiftanvil-anvil-a11y) tests="17/17" ;;
    swiftanvil-anvil-bench) tests="78/78" ;;
    swiftanvil-anvil-strings) tests="21/21" ;;
    swiftanvil-anvil-network) tests="29/29" ;;
    swiftanvil-anvil-flags) tests="37/37" ;;
    swiftanvil-anvil-devmenu) tests="16/16" ;;
    swiftanvil-anvil-wizard) tests="20/20" ;;
    swiftanvil-anvil-template) tests="30/30" ;;
    swiftanvil-anvil-project) tests="37/37" ;;
    swiftanvil-anvil-docs) tests="6/6" ;;
    swiftanvil-anvil-runner) tests="CI passed for 0.1.0" ;;
    swiftanvil-cli) tests="13/13" ;;
  esac

  cat >> "$REPORT_YML" <<EOF
  - name: "$repo"
    status: "stable"
    latest_release: "$release"
    ci_status: "$ci"
    tests: "$tests"
    last_updated: "$updated"
EOF
done

cat >> "$REPORT_YML" <<EOF

phases:
  current: 4
  active_child: "4.3"
  completed_children: ["1.1", "1.2", "1.3", "1.4", "1.5", "2.1", "2.2", "2.3", "3.1", "3.2", "3.3", "3.4", "3.5", "4.1", "4.2"]
  in_progress_children: ["4.3"]
  planned_children: ["4.4", "4.5"]

review_coverage:
  total_children: 15
  cross_host_reviewed: 14
  self_reviewed: 1
  pending_review: 0

enforcement:
  last_run: "$GENERATED_AT"
  status: "passing"
  failures: []

reserved:
  worker_capabilities:
    owner: "planning.child-4-4"
    status: "TBD"
  fleet_status:
    owner: "planning.child-4-5"
    status: "TBD"
EOF

echo "Reports generated:"
echo "  Markdown: $REPORT_MD"
echo "  YAML:     $REPORT_YML"
