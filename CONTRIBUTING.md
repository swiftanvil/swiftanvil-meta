# Contributing to SwiftAnvil

> Thank you for helping make SwiftAnvil better.

## Getting Started

1. Read `meta.agents` for project conventions
2. Check `roadmap.org` for active work
3. Open an issue before major changes

## Example Projects

When adding or modifying an example project, follow these conventions:

### Required Structure

```
swiftanvil-example-<name>/
├── Package.swift          # Swift 6, platform policy compliant
├── README.md              # Build + test instructions (meta.readme)
├── .gitignore             # .build/, .swiftpm/, .DS_Store
├── Sources/
│   └── <TargetName>/
│       └── ...
└── Tests/
    └── <TargetName>Tests/
        └── ...
```

### Required Checks

- [ ] `swift build` succeeds
- [ ] `swift test` passes (minimum 3 tests)
- [ ] `ifoundation verify --example --path .` passes
- [ ] Uses Swift 6 + StrictConcurrency
- [ ] Follows platform policy (iOS 18+, macOS 15+, etc.)

### README Template

```markdown
# <ExampleName>

> One-line description.

## What it demonstrates

| Convention | How it's used |
|------------|---------------|
| ... | ... |

## Build & Test

```bash
swift build
swift test
```

## License

MIT — see LICENSE for details.
```

See `EXAMPLES.md` for the full example project index.

## Pull Request Process

1. Branch from `main`
2. Add tests for new features
3. Update documentation
4. Ensure `ifoundation verify` passes
5. Request review

## Code of Conduct

Be respectful. Be constructive. Be inclusive.
