---
name: agent-receipt
description: "Generate a human-readable receipt from a Claude Code session. Use when the user asks to audit, review, or summarize what an agent did during a session. Reads JSONL session logs and groups all actions (files modified, commands run, URLs fetched, packages installed) into a structured receipt with SHA256 integrity hash. Do NOT use for real-time monitoring — this is post-session analysis only."
install: "npx @safetnsr/agent-receipt"
license: MIT
compatibility: Requires Node.js 18+. Reads Claude Code JSONL session logs from ~/.claude/projects/**/*.jsonl.
metadata:
  author: safetnsr
  version: "0.1.0"
  npm: "@safetnsr/agent-receipt"
  github: "https://github.com/safetnsr/agent-receipt"
---

## Usage

```bash
# Generate receipt from latest session
npx @safetnsr/agent-receipt

# Output as JSON for agent pipelines
npx @safetnsr/agent-receipt --json

# Save receipt to file
npx @safetnsr/agent-receipt --save receipts/

# Verify receipt integrity
npx @safetnsr/agent-receipt --verify receipt.txt
```

## Agent Integration

Use `--json` output for programmatic access:

```json
{
  "actions": {
    "session_id": "abc123",
    "files_modified": ["src/index.ts"],
    "commands_run": ["npm test"],
    "urls_fetched": [],
    "packages_installed": ["express"]
  },
  "sha256": "a1b2c3...",
  "generated_at": "2026-02-28T14:45:00Z"
}
```
