---
name: front-leak
description: >
  Scan frontend build output (dist/, build/, .next/) for leaked secrets, API keys,
  and sensitive data. Use when: auditing production bundles before deploy, CI/CD
  pre-push checks, investigating suspected secret leaks in frontend builds.
  Trigger: 'scan build for secrets', 'check dist for api keys', 'front-leak',
  'leaked secrets in bundle', 'frontend secret scan', 'audit dist folder'.
  Negative trigger: not for scanning source code (use sub-audit), not for git
  history scanning (use trufflehog), not for dependency auditing (use dep-ghost).
license: MIT
metadata:
  author: safetnsr
  version: 0.1.0
  npm: "@safetnsr/front-leak"
  github: "https://github.com/safetnsr/front-leak"
---

# front-leak skill

scan frontend build output for leaked secrets.

## usage

```bash
npx @safetnsr/front-leak                  # auto-detect dist/, build/, .next/
npx @safetnsr/front-leak --dir ./dist     # explicit directory
npx @safetnsr/front-leak --json           # machine-readable output
npx @safetnsr/front-leak --ci             # exit 1 on critical/high findings
npx @safetnsr/front-leak --severity high  # only high and critical
```

## what it detects

- Stripe secret/publishable keys
- AWS access keys (AKIA...)
- GitHub tokens (ghp_, gho_, ghs_, ghu_, ghr_)
- Anthropic and OpenAI API keys
- Google API keys (AIza... — Gemini retroactive risk)
- JWT tokens
- Private keys (PEM format)
- Connection strings (MongoDB, Postgres, MySQL, Redis)
- Slack tokens
- Twilio and SendGrid API keys
- Source map files (expose original source)

## agent interface

```json
{
  "findings": [
    {
      "type": "Stripe Secret Key",
      "severity": "critical",
      "file": "dist/bundle.js",
      "line": 1847,
      "preview": "sk_live_****...****"
    }
  ],
  "summary": {
    "total": 3,
    "critical": 1,
    "high": 1,
    "medium": 1,
    "info": 0,
    "filesScanned": 24
  }
}
```

## instructions

When asked to scan a frontend build:

1. Run `npx @safetnsr/front-leak --json` in the project root
2. Parse the JSON output
3. Report critical findings first
4. For source map findings, advise removing them from production builds
5. Use `--ci` flag in CI pipelines to fail on critical/high findings
