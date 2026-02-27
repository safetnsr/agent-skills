# vibe-check agent integration reference

## full json schema

```typescript
interface VibeCheckResult {
  pass: boolean;
  score: number;           // 0-100
  threshold: number;       // default 50
  summary: string;
  critical: Finding[];     // score >= 20
  warnings: Finding[];     // score < 20
  findings: Finding[];     // all findings (backward compat)
  filesScanned: number;
  linesScanned: number;
}

interface Finding {
  type: string;
  file: string;
  line: number;
  snippet: string;         // flagged code, secrets redacted
  fix: string;             // human-readable fix instruction
  fix_line: string | null; // drop-in replacement line, null if N/A
  message: string;
  score: number;
}

interface FixReport {
  dry_run: boolean;
  fixed: FixResult[];
  manual: ManualItem[];
  score_before: number;
  score_after: number;
  pass_before: boolean;
  pass_after: boolean;
  threshold: number;
}

interface FixResult {
  type: string;
  file: string;
  line: number;
  original: string;
  replacement: string;
  applied: boolean;
  reason?: string;
}

interface ManualItem {
  type: string;
  file: string;
  line: number;
  fix: string;
  reason: string;
}
```

## recommended agent workflow (v1.5.0+)

```bash
# 1. preview what --fix would do
npx @safetnsr/vibe-check --dry-run --json

# 2. if fixed[] looks good, apply
npx @safetnsr/vibe-check --fix

# 3. review applied changes
git diff

# 4. handle manual[] items by hand

# 5. confirm clean
npx @safetnsr/vibe-check --json
```

## legacy consume-fix loop (manual approach)

```bash
RESULT=$(npx @safetnsr/vibe-check --json 2>/dev/null)
PASS=$(echo "$RESULT" | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.parse(d).pass))")

if [ "$PASS" = "true" ]; then
  echo "vibe-check: clean"
else
  # use --fix for automatic remediation
  npx @safetnsr/vibe-check --fix --json
fi
```

## add to CLAUDE.md

```markdown
## pre-push checklist
before any git push, run `npx @safetnsr/vibe-check --dry-run --json`.
review fixed[] and manual[]. if acceptable: `npx @safetnsr/vibe-check --fix`.
verify with `git diff`, then re-run `--json` to confirm pass=true.
max 3 iterations — if still failing after 3, flag for human review.
```

## session scanning

if you made multiple commits during a single agent session, scan the full range:

```bash
npx @safetnsr/vibe-check --json --since <session-start-sha>
npx @safetnsr/vibe-check --json --since HEAD~5
```

## stats (check your own patterns)

```bash
npx @safetnsr/vibe-check stats
```

use this to calibrate your own behavior — if deleted-error-handler appears frequently, add explicit error handling to your coding patterns.
