---
name: spend-cap
description: Install and use @safetnsr/spend-cap to enforce a client-side daily spending cap on AI API calls (OpenAI, Anthropic, Gemini). Use when a user wants to prevent runaway AI API costs, set a hard daily budget, or add a kill-switch to any Node.js app that calls AI APIs. Trigger: "add spending cap", "limit AI API costs", "prevent runaway costs", "spend-cap", "SPEND_CAP env var". Not for: cloud-based billing controls, per-request rate limiting, or non-Node environments.
version: 0.1.0
npm: "@safetnsr/spend-cap"
github: "https://github.com/safetnsr/spend-cap"
---

# spend-cap skill

## what it does

patches `globalThis.fetch` to intercept AI API calls and enforce a daily spending cap. when the cap is hit, throws `SpendCapError` instead of making the request. zero dependencies, client-side only.

## install

```bash
npm install @safetnsr/spend-cap
```

## usage

### as a require/import hook

```bash
# ESM (--import)
SPEND_CAP=5 node --import @safetnsr/spend-cap/register app.js

# CJS (--require / -r)
SPEND_CAP=5 node -r @safetnsr/spend-cap/register app.js
```

### in code

```typescript
import { installInterceptor } from '@safetnsr/spend-cap';
installInterceptor(5.00); // $5 daily cap
```

### CLI commands

```bash
spend-cap status          # show today's spend
spend-cap status --json   # machine-readable output
spend-cap reset           # clear the counter
```

## intercepted domains

- api.openai.com
- api.anthropic.com
- generativelanguage.googleapis.com

## env vars

| var | description | default |
|-----|------------|---------|
| SPEND_CAP | daily cap in USD | required |
| SPEND_CAP_STATE_PATH | custom state file path | ~/.spend-cap-state.json |

## error handling

```typescript
import { SpendCapError } from '@safetnsr/spend-cap';

try {
  const response = await fetch('https://api.openai.com/...');
} catch (err) {
  if (err instanceof SpendCapError) {
    console.error(`Cap hit: $${err.spentUsd} of $${err.capUsd}`);
  }
}
```

## supported models (accurate pricing)

- gpt-4o, gpt-4o-mini, gpt-4.1, gpt-4.1-mini, gpt-5.4
- claude-sonnet-4-6, claude-opus-4-6, claude-haiku-3.5
- gemini-2.0-flash, gemini-2.5-pro
- unknown models: fallback estimation ($5/MTok average)

## state file format

```json
{ "date": "2026-03-07", "totalUsd": 3.42 }
```

resets automatically at midnight UTC.
