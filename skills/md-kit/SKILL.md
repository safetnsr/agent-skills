---
name: md-kit
description: "Find and fix broken [[wikilinks]] and dead relative links in markdown workspaces. Move files with automatic link updates. Trigger: when checking link integrity, validating markdown workspace, auditing wikilinks, finding dead links in .md files, auto-fixing broken links, moving/renaming markdown files. Negative trigger: not for HTTP link checking, not for HTML link validation."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "0.4.0"
  npm: "@safetnsr/md-kit"
  github: "https://github.com/safetnsr/md-kit"
---

## Commands

- `md-kit check [dir]` — scan for broken links (exit 1 if found, shows tip with `md-kit mv` hint)
- `md-kit check [dir] --json` — JSON output for agent consumption (includes `tip` and `broken_count` fields)
- `md-kit check [dir] --quiet-if-clean` — no output if all links valid
- `md-kit fix [dir]` — dry-run: show what would be fixed
- `md-kit fix [dir] --apply` — auto-fix broken links with fuzzy match suggestions
- `md-kit fix [dir] --patch` — write fixes to md-kit-fixes.md for review
- `md-kit mv <old> <new>` — move file and update all incoming links (wikilinks + relative)
- `md-kit mv <old> <new> --dry-run` — preview move without writing
- `md-kit watch [dir]` — watch for .md changes, auto-fix single-suggestion broken links on rename
- `md-kit install` — install interactive pre-commit hook (asks [Y/n] to auto-fix before commit)
- `md-kit setup` — auto-configure for agent workspace (hook + git alias + heartbeat)
- `md-kit setup --git-alias` — install git mmd alias for move+link-update in one command

## Git Alias

After `md-kit setup` or `md-kit setup --git-alias`, use:
```bash
git mmd old-file.md new-file.md
```
This runs `md-kit mv` + `git add -A` in one command — moves the file and updates all links.

## Interactive Pre-Commit Hook

The hook installed by `md-kit install` or `md-kit setup`:
1. Detects changed .md files in staging
2. Runs `md-kit check` to find broken links
3. Asks `fix broken links automatically? [Y/n]`
4. If yes: auto-fixes, re-stages, continues commit
5. If no: blocks commit with instructions

## Watch with Auto-Fix

`md-kit watch .` detects file renames and automatically fixes broken links when there's a single clear suggestion. Multi-suggestion links are reported for manual fix.

## Agent Flow

1. **Setup (once per repo):** `npx @safetnsr/md-kit setup` — installs hook + git alias + heartbeat entry
2. **Check:** `npx @safetnsr/md-kit check . --json` — scan workspace
3. **Auto-fix:** `npx @safetnsr/md-kit fix . --apply` — fix links with single fuzzy match
4. **Move files:** `npx @safetnsr/md-kit mv old.md new.md` or `git mmd old.md new.md`
5. **Monitor:** `npx @safetnsr/md-kit watch .` — continuous monitoring with auto-fix

## Heartbeat Hook

Run `md-kit check --json` in heartbeat; if `broken_count > 0`, report to pablo.

```bash
result=$(npx @safetnsr/md-kit check . --json 2>/dev/null)
broken=$(echo "$result" | jq '.brokenLinks')
if [ "$broken" -gt 0 ]; then
  echo "⚠️ $broken broken links found"
fi
```
