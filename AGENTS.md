# AGENTS.md

Guidelines for AI agents contributing to this repository.

## Skill structure

Each skill lives in its own directory with a `SKILL.md` inside:

```
<skill-name>/SKILL.md
```

## SKILL.md rules

- YAML frontmatter is required: `name` and `description`
- The frontmatter schema is **closed** — the only fields the
  [Agent Skills spec](https://agentskills.io/specification) allows are `name`,
  `description`, `license`, `compatibility`, `metadata`, and `allowed-tools`.
  Any other key (e.g. `user-invocable`, `argument-hint`) makes the skill invalid
  and Agent Plugins clients will skip it; put client-specific extras under
  `metadata` instead
- `name` **must match the directory name** exactly (lowercase alphanumeric, hyphens allowed)
- `description` is 1–1024 characters; write it as a trigger signal — "use this when..."
- Keep content **concise and directive** — no code examples unless essential
- **Do not duplicate upstream docs** — link to them instead. Skills should direct the agent, not replicate reference material
- When adding a skill, add it to the table in `README.md`
