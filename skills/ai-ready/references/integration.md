# ai-ready integration reference

## add to CLAUDE.md

```markdown
## pre-session checklist
before editing any JS/TS file, run:
```bash
npx @safetnsr/ai-ready <target-file-or-dir> --json
```
check `incoming_deps` and `risk_level`. if risk_level=high:
- if circular_deps: read listed files first
- if global_mutations: trace usages before touching
- if assertion_count < 5: write tests before long session
```

## consume in agent workflow

```bash
BRIEF=$(npx @safetnsr/ai-ready src/auth/index.ts --json 2>/dev/null)
RISK=$(echo "$BRIEF" | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.parse(d).files[0]?.risk_level))")
DEPS=$(echo "$BRIEF" | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.parse(d).files[0]?.incoming_deps))")

echo "risk: $RISK, incoming deps: $DEPS"
```

## decision matrix

| incoming_deps | has_test | action |
|---|---|---|
| >5 | no | write tests first |
| >5 | yes, <5 assertions | add assertions before editing |
| 1-5 | no | be careful, verify manually |
| 0 | any | edit freely |

## flags

```bash
--json         machine-readable output
--top <n>      show only N riskiest files  
--version      show version
--help         show help
```

exit code 1 if any high-risk files found (CI-friendly).
