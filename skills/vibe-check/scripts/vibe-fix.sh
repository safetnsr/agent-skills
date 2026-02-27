#!/bin/bash
# vibe-fix — run vibe-check and print fix instructions
# usage: bash scripts/vibe-fix.sh [--since <sha>]

SINCE=""
if [ "$1" = "--since" ] && [ -n "$2" ]; then
  SINCE="--since $2"
fi

RESULT=$(npx @safetnsr/vibe-check --json $SINCE 2>/dev/null)

if [ -z "$RESULT" ]; then
  echo "vibe-check: no output (not a git repo or npx unavailable)"
  exit 1
fi

echo "$RESULT" | node -e "
process.stdin.resume();
let d='';
process.stdin.on('data',c=>d+=c);
process.stdin.on('end',()=>{
  const r=JSON.parse(d);
  if(r.pass){
    console.log('✓ clean — ' + r.summary);
    process.exit(0);
  }
  console.log('risk score: ' + r.score + '/100');
  console.log(r.summary);
  console.log('');
  if(r.critical.length){
    console.log('CRITICAL (fix before pushing):');
    r.critical.forEach(f=>{
      console.log('  ' + f.type + ' — ' + f.file + ':' + f.line);
      console.log('  snippet: ' + f.snippet);
      if(f.fix_line){
        console.log('  fix_line: ' + f.fix_line);
      } else {
        console.log('  fix: ' + f.fix);
      }
      console.log('');
    });
  }
  if(r.warnings.length){
    console.log('WARNINGS:');
    r.warnings.forEach(f=>{
      console.log('  ' + f.type + ' — ' + f.file + ':' + f.line + ' — ' + f.fix);
    });
  }
  process.exit(1);
});
"
