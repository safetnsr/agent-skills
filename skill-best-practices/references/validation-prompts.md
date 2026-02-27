# skill validation prompts
source: https://github.com/mgechev/skills-best-practices

## 1. discovery validation

paste into a fresh LLM chat to test if the description routes correctly:

```
I am building an Agent Skill. Agents decide whether to load this skill based entirely on the YAML metadata below.

name: [skill-name]
description: [paste description]

Based strictly on this description:
1. Generate 3 realistic prompts that should trigger this skill.
2. Generate 3 prompts that sound similar but should NOT trigger this skill.
3. Critique the description: is it too broad? Suggest an optimized rewrite.
```

## 2. logic validation

feed the full SKILL.md to test if steps are deterministic:

```
Here is the full draft of my SKILL.md and directory tree:

[paste directory tree]
[paste SKILL.md]

Act as an autonomous agent that has just triggered this skill. Simulate execution step-by-step for the request: [insert realistic request].

For each step, write your internal monologue:
1. What exactly are you doing?
2. Which specific file/script are you reading or running?
3. Flag any Execution Blockers: exact lines where you must guess or hallucinate because instructions are ambiguous.
```

## 3. edge case testing

```
Switch roles. Act as a ruthless QA tester. Your goal is to break this skill.

Ask 3-5 highly specific questions about edge cases, failure states, or missing fallbacks.
Focus on:
- What if [script] fails due to [specific condition]?
- What if the user's environment has [unusual configuration]?
- Are there implicit assumptions about the environment?

Do not fix these issues. Ask the numbered questions and wait.
```

## 4. architecture refinement

after answering edge case questions:

```
Based on my answers, rewrite SKILL.md enforcing Progressive Disclosure:

1. Keep SKILL.md as high-level steps only using third-person imperative commands.
2. Move dense rules, large templates, or complex schemas to references/ or assets/.
   Replace in SKILL.md with a strict command to read that file only when needed.
3. Add an Error Handling section incorporating my edge case answers.
```
