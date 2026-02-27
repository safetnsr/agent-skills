---
name: skill-best-practices
description: Create, refine, or audit OpenClaw agent skills using best practices from mgechev/skills-best-practices. Use when creating a new skill, improving an existing skill's description or structure, or validating that a skill will trigger correctly. Do not use for general coding tasks or non-skill files.
---

# skill-best-practices

Apply skill authoring best practices when creating or refining agent skills.

## creating a new skill

1. Run `python3 /usr/lib/node_modules/openclaw/skills/skill-creator/scripts/init_skill.py [name] --path /root/.openclaw/workspace/skills --resources references`
2. Write `SKILL.md` following the rules in `references/rules.md`
3. Validate description using the discovery prompt in `references/validation-prompts.md`
4. Run `python3 /usr/lib/node_modules/openclaw/skills/skill-creator/scripts/package_skill.py /root/.openclaw/workspace/skills/[name]`

## refining an existing skill

1. Read the existing SKILL.md
2. Check against rules in `references/rules.md` — identify violations
3. Rewrite to fix violations (description, structure, instruction style)
4. Re-package with the package_skill.py script

## key rules (see references/rules.md for full list)

- description max 1,024 chars — include negative triggers ("do not use for X")
- SKILL.md max 500 lines — offload schemas and verbose context to references/
- instructions must be imperative third-person ("Run X", "Parse Y", not "I will" or "you should")
- use step-by-step numbered workflows, not prose
- use JiT loading: explicitly tell the agent when to read a references/ file

## validation

After writing a skill, validate using prompts in `references/validation-prompts.md`:
- discovery validation: will the right prompts trigger it?
- logic validation: are steps deterministic?
- edge case testing: what breaks it?
