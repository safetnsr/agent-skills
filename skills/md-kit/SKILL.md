---
name: md-kit
description: "Find and fix broken [[wikilinks]] and dead relative links in markdown workspaces. Move files with automatic link updates. Severity tiers, .mdkitignore, --since filtering. Trigger: when checking link integrity, validating markdown workspace, auditing wikilinks, finding dead links in .md files, auto-fixing broken links, moving/renaming markdown files. Negative trigger: not for HTTP link checking, not for HTML link validation."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "0.5.0"
  npm: "@safetnsr/md-kit"
  github: "https://github.com/safetnsr/md-kit"
---

## Commands

- `md-kit check [dir]` — scan for broken links (default: only shows critical severity)
- `md-kit check [dir] --json` — JSON output with severity counts (critical/warnings/info/ignored_count)
- `md-kit check [dir] --quiet-if-clean` — no output if all links valid
- `md-kit check [dir] --full` — show all severity levels in output
- `md-kit check [dir] --warnings` — show critical + warning items
- `md-kit check [dir] --critical` — show only critical items (default)
- `md-kit check [dir] --since <date>` — only files modified after date (YYYY-MM-DD, yesterday, 7days)
- `md-kit fix [dir]` — dry-run: show what would be fixed
- `md-kit fix [dir] --apply` — auto-fix broken links with fuzzy match suggestions
- `md-kit fix [dir] --patch` — write fixes to md-kit-fixes.md for review
- `md-kit mv <old> <new>` — move file and update all incoming links (wikilinks + relative)
- `md-kit mv <old> <new> --dry-run` — preview move without writing
- `md-kit watch [dir]` — watch for .md changes, auto-fix single-suggestion broken links on rename
- `md-kit ignore <link>` — add link to .mdkitignore (excluded from future checks)
- `md-kit install` — install interactive pre-commit hook
- `md-kit setup` — auto-configure for agent workspace (hook + git alias + heartbeat)

## Severity Tiers

Based on git recency of the file containing the broken link:
- **critical** — file modified < 30 days ago
- **warning** — file modified 30-90 days ago
- **info** — file modified > 90 days ago or never committed

Default output shows only critical items. Use `--full` to see all.

## .mdkitignore

Create a `.mdkitignore` file in the workspace root to exclude links from checks:
```
# Exact match
some-external-link
# Wildcard
draft-*
```

Or use: `md-kit ignore <link>` to append to the file.

## --since Flag

Filter broken links to only files modified after a given date:
```bash
md-kit check . --since yesterday     # last 24h
md-kit check . --since 7days         # last week
md-kit check . --since 2026-01-15    # specific date
```

## JSON Output Schema (v0.5.0)

```json
{
  "totalFiles": 10,
  "totalLinks": 50,
  "brokenLinks": 5,
  "broken_count": 5,
  "critical": 2,
  "warnings": 1,
  "info": 2,
  "ignored_count": 3,
  "results": [
    { "file": "a.md", "line": 4, "link": "missing", "type": "wikilink", "severity": "critical", "suggestion": null }
  ]
}
```

## Git Alias

After `md-kit setup`, use:
```bash
git mmd old-file.md new-file.md
```

## Heartbeat Hook

```bash
npx @safetnsr/md-kit check . --json --quiet-if-clean --since yesterday
# Check if critical > 0, report to pablo
```

## Agent Flow

1. **Setup:** `npx @safetnsr/md-kit setup`
2. **Check:** `npx @safetnsr/md-kit check . --json --since yesterday`
3. **Auto-fix:** `npx @safetnsr/md-kit fix . --apply`
4. **Move files:** `git mmd old.md new.md`
5. **Ignore:** `npx @safetnsr/md-kit ignore some-link`
6. **Monitor:** `npx @safetnsr/md-kit watch .`
