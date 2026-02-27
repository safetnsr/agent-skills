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

skills follow the [agentskills.io](https://agentskills.io) open standard. each agent has its own install mechanism — pick yours below.

### claude code

```
/plugin marketplace add safetnsr/agent-skills
/plugin install vibe-check@safetnsr-agent-skills
/plugin install ai-ready@safetnsr-agent-skills
```

### cursor / gemini cli / other agents

clone and point your skills directory at the `skills/` folder:

```bash
git clone https://github.com/safetnsr/agent-skills ~/.agent-skills
```

then configure your agent to scan `~/.agent-skills/skills/` for skills (see your agent's docs for the exact config path).

### manual

copy any skill folder into your agent's configured skills directory:

```bash
cp -r skills/vibe-check /path/to/your/agent/skills/
```

## compatibility

these skills follow the [agentskills.io](https://agentskills.io) open standard and work with any compatible agent: Claude Code, Cursor, Gemini CLI, OpenHands, Goose, and others.

## license

MIT
