---
name: md-kit
description: "Find and fix broken [[wikilinks]] and dead relative links in markdown workspaces. Move files with automatic link updates. Trigger: when checking link integrity, validating markdown workspace, auditing wikilinks, finding dead links in .md files, auto-fixing broken links, moving/renaming markdown files. Negative trigger: not for HTTP link checking, not for HTML link validation."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "0.3.0"
  npm: "@safetnsr/md-kit"
  github: "https://github.com/safetnsr/md-kit"
---

## Commands

- `md-kit check [dir]` — scan for broken links (exit 1 if found)
- `md-kit check [dir] --json` — JSON output for agent consumption
- `md-kit check [dir] --quiet-if-clean` — no output if all links valid
- `md-kit fix [dir]` — dry-run: show what would be fixed
- `md-kit fix [dir] --apply` — auto-fix broken links with fuzzy match suggestions
- `md-kit fix [dir] --patch` — write fixes to md-kit-fixes.md for review
- `md-kit mv <old> <new>` — move file and update all incoming links (wikilinks + relative)
- `md-kit mv <old> <new> --dry-run` — preview move without writing
- `md-kit watch [dir]` — watch for .md changes, alert on broken links
- `md-kit install` — install pre-commit git hook to block commits with broken links
- `md-kit setup` — auto-configure for agent workspace (hook + heartbeat)

## Agent Flow

1. **Setup (once per repo):** `npx @safetnsr/md-kit setup` — installs hook + heartbeat entry
2. **Check:** `npx @safetnsr/md-kit check . --json` — scan workspace
3. **Auto-fix:** `npx @safetnsr/md-kit fix . --apply` — fix links with single fuzzy match
4. **Move files:** `npx @safetnsr/md-kit mv old.md new.md` — move + update all incoming links
5. **Monitor:** `npx @safetnsr/md-kit watch .` — continuous monitoring

## Heartbeat Hook

Run `md-kit check --json` in heartbeat; if `broken_count > 0`, report to pablo.

```bash
result=$(npx @safetnsr/md-kit check . --json 2>/dev/null)
broken=$(echo "$result" | jq '.brokenLinks')
if [ "$broken" -gt 0 ]; then
  echo "⚠️ $broken broken links found"
fi
```
