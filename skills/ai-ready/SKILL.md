---
name: ai-ready
description: Map the blast radius before editing files in a JS/TS codebase. Use when about to edit files in an existing JS/TS project — especially unfamiliar files or files with many dependents. Do not use for new projects with no existing code, non-JS/TS codebases (Python, Go, Rust), or after changes have already been made (use vibe-check instead).
license: MIT
compatibility: Requires Node.js 18+. JS/TS projects only (v1). Works with any package manager.
metadata:
  author: safetnsr
  version: "1.2.1"
  npm: "@safetnsr/ai-ready"
  github: "https://github.com/safetnsr/ai-ready"
---

# ai-ready

Map blast radius before editing JS/TS files. Zero install.

## standard workflow

1. Run `npx @safetnsr/ai-ready [target] --summary --json` on the file or directory to edit
2. Read `action_items` — complete each before starting edits
3. For files with `downstream_untested` non-empty: read those files before editing
4. For files with `circular_deps`: read the listed dependency first
5. Edit files
6. Run vibe-check after session — see vibe-check skill

## key flags

```bash
npx @safetnsr/ai-ready src/auth/ --summary --json   # quick check: action items only
npx @safetnsr/ai-ready src/auth/ --json             # full per-file briefing
npx @safetnsr/ai-ready --top 5 --json               # worst 5 files only
```

## consuming --summary --json output

Parse `action_items`. Complete each item before starting edits. Use `summary` for risk overview.

```json
{
  "action_items": [
    "write tests for logout.ts before editing index.ts (8 files depend on it)",
    "read middleware.ts before touching index.ts — circular dependency"
  ],
  "summary": "1 high risk. 2 medium. 4 low."
}
```

## consuming full --json output

For each file in `files[]`: check `risk_level`, `incoming_deps`, `downstream_untested`. See `references/integration.md` for full schema and decision matrix.

## decision rules

- `action_items` non-empty → complete all items before editing
- `downstream_untested` non-empty → read those files first (no tests = silent break risk)
- `incoming_deps > 5` + `test_coverage.assertion_count < 5` → write tests before editing
- `circular_deps` present → read listed file first
- `risk_level: low` + `incoming_deps: 0` → edit freely

## pair with vibe-check

Run ai-ready before editing. Run vibe-check after. See `references/integration.md` for the full agent workflow pattern.
