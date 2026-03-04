---
name: pr-patrol
description: "Scan PR diffs for AI-agent-specific anti-patterns (removed error handling, unjustified deps, complexity growth, removed safety comments, return type changes). Use when: reviewing AI-generated PRs, CI/CD pre-merge checks, auditing code quality of agent sessions. NOT for: general code linting (use ESLint), complexity metrics (use SonarQube), scanning for secrets (use sub-audit)."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "0.1.0"
  npm: "@safetnsr/pr-patrol"
  github: "https://github.com/safetnsr/pr-patrol"
---

## Usage
```bash
# scan current branch vs main
npx @safetnsr/pr-patrol

# specify branch and sensitivity
npx @safetnsr/pr-patrol --branch feature/auth --level strict

# CI mode
npx @safetnsr/pr-patrol --ci

# JSON output for agents
npx @safetnsr/pr-patrol --json
```

## What it catches
- **removed-error-handling** (critical): try/catch blocks silently removed
- **unjustified-dep** (warning): deps added without imports
- **complexity-growth** (warning): functions grew >2x
- **removed-safety-comments** (warning): TODO/FIXME/HACK removed
- **return-type-change** (critical): return types silently changed
