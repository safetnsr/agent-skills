# skill authoring rules
source: https://github.com/mgechev/skills-best-practices

## frontmatter

- `name`: 1-64 chars, lowercase letters/numbers/hyphens only, no consecutive hyphens, must match directory name exactly
- `description`: max 1,024 chars. agent sees ONLY this for routing decisions.
  - write in third person
  - include positive triggers ("use when X")
  - include negative triggers ("do not use for Y") — prevents false firing
  - bad: "React skills." (too vague)
  - good: "Creates React components with Tailwind. Use when updating component styles. Do not use for Vue or Svelte."

## structure

```
skill-name/
├── SKILL.md              # max 500 lines — navigation + high-level procedures
├── scripts/              # deterministic scripts for repetitive/fragile ops
├── references/           # supplementary context loaded JiT (one level deep only)
└── assets/               # templates, JSON schemas, static files
```

- keep files exactly one level deep (no references/db/v1/schema.md)
- do NOT create: README.md, CHANGELOG.md, INSTALLATION_GUIDE.md
- do NOT add redundant logic — if agent already handles it, delete the instruction
- do NOT put library code in scripts/ — tiny single-purpose scripts only

## instruction style

- use step-by-step numbered sequences
- write in third-person imperative: "Run X", "Parse Y", "Extract Z"
- NOT: "I will run X" or "you should run X"
- for decision trees: map them explicitly ("if X, go to step 3; otherwise skip to step 5")
- for templates: put them in assets/ and reference them ("copy structure from assets/template.json")

## progressive disclosure (JiT loading)

- agent does NOT see references/ files until explicitly directed
- always specify exactly when to read a reference: "See references/schema.md for error codes"
- use this to keep SKILL.md lean and context window small

## terminology

- use identical terms throughout — pick one and stick to it
- use domain-native terminology (in Angular: "template" not "html/markup/view")
