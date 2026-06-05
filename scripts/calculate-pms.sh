#!/bin/bash
# calculate-pms.sh — Calculate Package Maturity Score for all SwiftAnvil repos
# Usage: ./scripts/calculate-pms.sh [repo-path]
# If no repo-path given, scores all repos in the sibling directory

set -euo pipefail

WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../.." && pwd)}"
REPOS=(
  swiftanvil-anvil-a11y
  swiftanvil-anvil-bench
  swiftanvil-anvil-core
  swiftanvil-anvil-devmenu
  swiftanvil-anvil-docs
  swiftanvil-anvil-flags
  swiftanvil-anvil-macros
  swiftanvil-anvil-menubar
  swiftanvil-anvil-network
  swiftanvil-anvil-project
  swiftanvil-anvil-runner
  swiftanvil-anvil-settings
  swiftanvil-anvil-strings
  swiftanvil-anvil-template
  swiftanvil-anvil-window
  swiftanvil-anvil-wizard
  swiftanvil-cli
)

score_repo() {
  local repo_dir="$1"
  local repo_name
  repo_name=$(basename "$repo_dir")

  if [[ ! -f "$repo_dir/Package.swift" ]]; then
    echo "{\"error\":\"Not a Swift package\"}" >&2
    return
  fi

  cd "$repo_dir"

  # Correctness (25 pts): swift build + swift test
  local correctness=0
  if swift build 2>/dev/null >/dev/null; then
    correctness=15
    if swift test 2>/dev/null >/dev/null; then
      correctness=25
    fi
  fi

  # Coverage (20 pts): test count
  local test_count=0
  if [[ -d Tests ]]; then
    test_count=$(find Tests -name "*.swift" -exec grep -l "@Test\|func test" {} \; 2>/dev/null | wc -l | tr -d ' ')
  fi
  local coverage=0
  if (( test_count >= 5 )); then coverage=20
  elif (( test_count >= 1 )); then coverage=15
  elif [[ -d Tests ]]; then coverage=5
  fi

  # Documentation (15 pts): README + DocC
  local documentation=0
  [[ -f README.md ]] && documentation=$((documentation + 8))
  [[ -d Sources ]] && [[ $(find Sources -name "*.docc" -type d 2>/dev/null | wc -l) -gt 0 ]] && documentation=$((documentation + 7))

  # API Stability (15 pts): git tag exists
  local api_stability=0
  if git tag -l 2>/dev/null | grep -q .; then
    api_stability=15
  fi

  # Performance (10 pts): BenchmarkKit in deps
  local performance=0
  if grep -q "swiftanvil-anvil-bench\|BenchmarkKit" Package.swift 2>/dev/null; then
    performance=10
  fi

  # Ecosystem (10 pts): CI workflow + remote
  local ecosystem=0
  [[ -f .github/workflows/ci.yml ]] && ecosystem=$((ecosystem + 5))
  git remote get-url origin 2>/dev/null >/dev/null && ecosystem=$((ecosystem + 5))

  # Security (5 pts): no hardcoded secrets
  local security=5
  if [[ -d Sources ]] && grep -riq "password\|secret\|token" Sources/ 2>/dev/null; then
    # Only flag if it looks like a real secret (not just variable names)
    if grep -riqE '"[a-zA-Z0-9]{16,}"' Sources/ 2>/dev/null; then
      security=0
    fi
  fi

  local total=$((correctness + coverage + documentation + api_stability + performance + ecosystem + security))

  local grade
  if (( total >= 90 )); then grade="A+"
  elif (( total >= 80 )); then grade="A"
  elif (( total >= 70 )); then grade="B"
  elif (( total >= 60 )); then grade="C"
  else grade="F"
  fi

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local next_review
  next_review=$(date -u -v+14d +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -d "+14 days" +"%Y-%m-%dT%H:%M:%SZ")

  local json
  json=$(cat <<EOF
{
  "version": "1.0.0",
  "score": $total,
  "grade": "$grade",
  "breakdown": {
    "correctness": $correctness,
    "coverage": $coverage,
    "documentation": $documentation,
    "api_stability": $api_stability,
    "performance": $performance,
    "ecosystem": $ecosystem,
    "security": $security
  },
  "last_calculated": "$now",
  "next_review": "$next_review",
  "test_count": $test_count
}
EOF
)

  echo "$json" > package.improvement-score
  echo "$json"
}

# Main
main() {
  if [[ $# -eq 1 ]]; then
    score_repo "$1"
  else
    echo "["
    local first=true
    for repo in "${REPOS[@]}"; do
      local repo_path="$WORKSPACE/$repo"
      if [[ -d "$repo_path" ]]; then
        if $first; then first=false; else echo ","; fi
        score_repo "$repo_path" | jq -c '. + {"repo": "'"$repo"'"}' 2>/dev/null || true
      fi
    done
    echo "]"
  fi
}

main "$@"
