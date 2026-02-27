---
name: vibe-check
description: Scan a git diff for AI agent anti-patterns before pushing. Use after making code changes in any git repo — catches hardcoded secrets, stubbed tests, deleted error handlers, empty catch blocks, and TODO comments left in production code. Do not use for code review of other people's work, for non-git projects, or for reviewing changes you did not make.
license: MIT
compatibility: Requires git and Node.js 18+. Works in any git repository with JS, TS, Python, or any language.
metadata:
  author: safetnsr
  version: "1.5.0"
  npm: "@safetnsr/vibe-check"
  github: "https://github.com/safetnsr/vibe-check"
---

# vibe-check

Scan agent-introduced anti-patterns in git diffs before pushing. Zero install.

## standard workflow (use this every time before pushing)

1. Run `npx @safetnsr/vibe-check --dry-run --json` — inspect `fixed[]` and `manual[]`
2. If `fixed[]` replacements look correct: run `npx @safetnsr/vibe-check --fix`
3. Run `git diff` to verify applied fixes
4. Resolve each item in `manual[]` using the `fix` string as guidance
5. Run `npx @safetnsr/vibe-check --json` — confirm `pass: true` before pushing

## key flags

```bash
npx @safetnsr/vibe-check --json           # scan only, machine-readable
npx @safetnsr/vibe-check --dry-run --json # preview fixes without writing
npx @safetnsr/vibe-check --fix --json     # apply fixes + structured output
npx @safetnsr/vibe-check --since HEAD~3   # scan full session across commits
npx @safetnsr/vibe-check --threshold 0    # report only, never block
```

## consuming --fix --json output

Parse the JSON. Iterate `fixed[]` to confirm `applied: true`. Iterate `manual[]` and resolve each using `fix` string. Re-run `--json` until `pass: true`.

```json
{
  "dry_run": false,
  "fixed": [{ "type": "hardcoded-secret", "file": "src/config.ts", "line": 12,
    "original": "const api_key = \"sk-****\"",
    "replacement": "const api_key = process.env.API_KEY ?? ''", "applied": true }],
  "manual": [{ "type": "deleted-error-handler", "file": "src/server.ts", "line": 45,
    "fix": "restore error handling or add .catch()", "reason": "no automatic fix available" }],
  "score_before": 73, "score_after": 28, "pass_before": false, "pass_after": false, "threshold": 50
}
```

## consuming --json scan output

Check `pass`. Iterate `critical[]` first (score ≥ 20). Use `fix_line` (when non-null) as drop-in replacement via Edit(file, old=snippet, new=fix_line). Use `fix` string for manual items.

```json
{
  "pass": false, "score": 73, "threshold": 50,
  "summary": "3 issues found — 2 critical, 1 warning",
  "critical": [{ "type": "hardcoded-secret", "file": "src/config.ts", "line": 12,
    "snippet": "const api_key = \"sk-****\"",
    "fix": "replace with process.env.API_KEY ?? ''",
    "fix_line": "const api_key = process.env.API_KEY ?? ''" }],
  "warnings": [], "findings": [], "filesScanned": 8, "linesScanned": 312
}
```

## what it detects

| type | score | fix_line |
|---|---|---|
| hardcoded-secret | 30 | yes (simple const/let/var assignments) |
| empty-catch | 25 | yes (single-line catches) |
| deleted-error-handler | 20 | no |
| test-stub | 15 | no |
| todo-in-prod | 10 | no |
| large-deletion | 5/50 lines | no |

Threshold default: 50. Exit code 1 if score ≥ threshold.

## optional config

Place `.vibecheck.yml` in repo root to configure per-project. See `references/agent-integration.md` for full config schema and advanced usage patterns.
