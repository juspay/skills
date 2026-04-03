# AGENTS.md

Guidelines for AI agents contributing to this repository.

## Local CI

Run `vira ci -b` to verify changes before pushing.

## Skill structure

Each skill lives in its own directory with a `SKILL.md` inside:

```
<skill-name>/SKILL.md
```

## SKILL.md rules

- YAML frontmatter is required: `name` and `description`
- `name` **must match the directory name** exactly (lowercase alphanumeric, hyphens allowed)
- `description` is 1–1024 characters; write it as a trigger signal — "use this when..."
- Keep content **concise and directive** — no code examples unless essential
- **Do not duplicate upstream docs** — link to them instead. Skills should direct the agent, not replicate reference material
- When adding a skill, add it to the table in `README.md`
