---
name: ai-ready
description: "Scores a codebase's AI-readiness before a Claude Code session. Use when: starting an agent session on an unfamiliar or complex codebase; checking which modules to refactor before AI coding; CI integration to gate agent sessions on code quality. Do NOT use when: codebase is < 5 files; non-JS/TS project."
license: MIT
compatibility: Requires Node.js 18+.
metadata:
  author: safetnsr
  version: "1.3.0"
  npm: "@safetnsr/ai-ready"
  github: "https://github.com/safetnsr/ai-ready"
---

# ai-ready

Pre-session codebase AI-readiness scorer.

## install
npx @safetnsr/ai-ready

## usage
ai-ready [dir] [--json] [--top N] [--ci] [--explain]
