# Child 11.5 — Consumer Project Template Integration

## Goal

Ensure every project created by `swiftanvil create` or adopted by `swiftanvil adopt` includes canonical style enforcement (SwiftFormat + SwiftLint) out of the box.

## Scope

1. **`swiftanvil create` templates** (`ProjectGenerator.swift`)
   - Generate `.swiftformat` in new projects
   - Generate `.swiftlint.yml` in new projects
   - Generate `.swiftanvil.yml` in new projects
   - Update generated pre-commit hook to use canonical configs
   - Update generated CI workflow to include format + lint steps

2. **`swiftanvil adopt --enforce`** (`AdoptCommand.swift`)
   - New `--enforce` flag that retroactively adds style configs to existing projects
   - Scans for missing `.swiftformat`, `.swiftlint.yml`, `.swiftanvil.yml`
   - Adds them if absent

## Deliverables

| Deliverable | Location |
|---|---|
| Updated `ProjectGenerator.swift` | `swiftanvil-cli` |
| Updated `AdoptCommand.swift` | `swiftanvil-cli` |
| Tests | `SwiftAnvilCLITests` |
| Result document | `Children/11.5/RESULT.md` |

## Registry References

- `style.guide` — canonical style configuration
- `planning.child-11-1` — canonical style configs source
- `planning.child-11-3` — pre-commit hooks and CI gates
