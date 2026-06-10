# Git Workflow

> Document ID: `workflow.git`
>
> Mechanical enforcement: pre-commit hook blocks main commits; prepare-commit-msg enforces conventional commits; post-checkout validates branch names.

## Rule: No Direct Commits to Main

Direct commits to `main` or `master` are mechanically blocked by the pre-commit hook. All work must flow through feature branches and PRs.

## Branch Naming

| Prefix | Purpose | Example |
|---|---|---|
| `feature/` | New functionality | `feature/health-monitor` |
| `fix/` | Bug fixes | `fix/memory-leak` |
| `doc/` | Documentation | `doc/api-examples` |
| `chore/` | Maintenance, config updates | `chore/bump-deps` |

The `post-checkout` hook warns if a branch name does not match `^(feature|fix|doc|chore)/`.

## Commit Message Format

Conventional commit format is enforced by the `prepare-commit-msg` hook:

```
<type>: <description>

[optional body]
```

| Type | Use when... |
|---|---|
| `feat` | Adding functionality |
| `fix` | Fixing a bug |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change, no feature change |
| `test` | Adding or fixing tests |
| `chore` | Build, deps, tooling |
| `ci` | CI/CD changes |

## Workflow Steps

### 1. Create Feature Branch

```bash
swiftanvil-enforcement/scripts/feature-workflow.sh <type> <description>
```

This:
- Checks out `main`
- Pulls latest from origin
- Creates and checks out `<type>/<description>`

### 2. Work, Commit, Push

```bash
git add -A
git commit -m "feat: add health monitor"
git push -u origin feature/health-monitor
```

The pre-commit hook runs:
- Document registry validation
- Review artifact validation
- SwiftFormat lint on staged files
- SwiftLint on staged files
- Main-branch block

The `prepare-commit-msg` hook validates conventional commit format.

### 3. Open Pull Request

Open a PR on GitHub. The CI workflow runs:
- `swift build` + `swift test`
- `swiftanvil lint package`
- `swiftanvil lint source`
- `swiftanvil lint tests`
- `swiftanvil lint dependencies`
- `swiftanvil health scan --quick`

### 4. Merge via Worktree

After PR approval, merge using the worktree script to keep a clean linear history:

```bash
swiftanvil-enforcement/scripts/merge-via-worktree.sh feature/health-monitor
```

This:
1. Creates a temporary git worktree for `main`
2. Fetches latest `main` from origin
3. Rebases the feature branch onto `main`
4. Fast-forwards `main` to the rebased tip
5. Pushes `main`
6. Deletes the feature branch locally and on origin
7. Removes the worktree
8. Runs cleanup

### 5. Cleanup

```bash
swiftanvil-enforcement/scripts/cleanup.sh
```

Removes:
- `.build/` directories
- `~/Library/Developer/Xcode/DerivedData`
- `~/Library/Caches/org.swift.swiftpm`
- `.swiftanvil-health.json`
- Stale git worktrees (`merge-*`)
- `.DS_Store`, `*.tmp`, `*.swp`, `*~`
- `xcuserdata` directories

## Emergency Bypass

If you must bypass hooks (e.g., bulk config rollout), use:

```bash
git commit --no-verify
```

This skips all hooks. Use sparingly and document the reason in the commit message.
