# agent-skills

> agent skills for AI coding agents. compatible with the [agentskills.io](https://agentskills.io) open standard.

## skills

### vibe-check
scan agent-introduced anti-patterns in git diffs before pushing.

- catches hardcoded secrets, stubbed tests, deleted error handlers, empty catch blocks
- auto-fix for machine-applicable findings (`--fix`)
- agent-native json output with `fix_line` for direct Edit() calls
- session history + `stats` command

```bash
npx @safetnsr/vibe-check --fix --json
```

[→ skill](./vibe-check/SKILL.md) · [→ npm](https://www.npmjs.com/package/@safetnsr/vibe-check) · [→ github](https://github.com/safetnsr/vibe-check)

---

### ai-ready
map blast radius before editing files in a JS/TS codebase.

- incoming deps, circular deps, global state, missing types
- `downstream_untested`: which consumers have no tests (silent break risk)
- `action_items`: prioritized pre-session checklist
- `--summary --json` for quick agent consumption

```bash
npx @safetnsr/ai-ready src/auth/ --summary --json
```

[→ skill](./ai-ready/SKILL.md) · [→ npm](https://www.npmjs.com/package/@safetnsr/ai-ready) · [→ github](https://github.com/safetnsr/ai-ready)

---

## agent workflow

```bash
# before editing
npx @safetnsr/ai-ready [target] --summary --json

# ... edit files ...

# before pushing
npx @safetnsr/vibe-check --fix --json
```

## install

### claude code (recommended)

```
/plugin marketplace add safetnsr/agent-skills
```

then install individual skills:

```
/plugin install vibe-check@safetnsr-agent-skills
/plugin install ai-ready@safetnsr-agent-skills
```

or install everything at once:

```
/plugin install all-skills@safetnsr-agent-skills
```

### other agents (agentskills.io compatible)

clone the repo and point your agent's skills directory at it:

```bash
git clone https://github.com/safetnsr/agent-skills
```

skills are in `./skills/vibe-check` and `./skills/ai-ready`.

## compatibility

these skills follow the [agentskills.io](https://agentskills.io) open standard and work with any compatible agent: Claude Code, Cursor, Gemini CLI, OpenHands, Goose, and others.

## license

MIT
