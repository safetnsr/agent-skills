---
name: ground
description: "Search local doc indexes for any supported platform. Use when: agent needs real API docs to avoid hallucination, user asks about a specific API/framework, grounding agent context on official docs. NOT for: web search, live API calls, HTML scraping."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "0.1.0"
  npm: "@safetnsr/ground"
  github: "https://github.com/safetnsr/ground"
---

# ground

Local docs grounding CLI.

## usage
```bash
npx @safetnsr/ground <platform> [query] [--json] [--tokens N] [--limit N] [--update] [--list]
```

## when to use
- Agent needs real API reference to avoid hallucinating endpoints
- User asks "how does stripe payment_intents work?"
- Grounding a coding session on official docs

## when NOT to use
- General web search (use web_search)
- Live API testing
- HTML scraping tasks
