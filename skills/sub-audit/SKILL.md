# sub-audit

AI API key security audit CLI. Scans dev environments for exposed AI API keys.

## Install & Run

```bash
npx @safetnsr/sub-audit
```

## Flags

- `--dir <path>` — scan specific directory (default: cwd)
- `--no-home` — skip home directory dotfiles
- `--json` — JSON output for agent integration
- `--help` — show help

## What it detects

OpenAI (`sk-proj-`), Anthropic (`sk-ant-`), Google AI (`AIza`), Replicate (`r8_`), HuggingFace (`hf_`), Groq (`gsk_`), Fireworks (`fw_`), Cohere, Mistral, Together, DeepSeek (via env vars).

## Risk levels

- CRITICAL: git-tracked file
- HIGH: world-readable file
- MEDIUM: user-accessible
- LOW: secure location

## Agent usage

```bash
sub-audit --json
```

Exit code 1 if CRITICAL or HIGH risk found. JSON output includes findings array + summary object.

## Links

- npm: [@safetnsr/sub-audit](https://www.npmjs.com/package/@safetnsr/sub-audit)
- GitHub: [safetnsr/sub-audit](https://github.com/safetnsr/sub-audit)
- Project page: [comrade.md/projects/sub-audit](https://comrade.md/projects/sub-audit)
