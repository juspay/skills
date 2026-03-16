# skills

AI skill pack — reusable [SKILL.md](https://opencode.ai/docs/skills/) definitions for use with OpenCode and compatible agents.

<img width="549" height="503" alt="image" src="https://github.com/user-attachments/assets/95f1ac62-fd85-422f-93e5-918042bff00d" />

## Skills

| Skill | Description |
|-------|-------------|
| [`nix-flake`](./skills/nix-flake/SKILL.md) | Writing flakes with flake-parts, formatter, shell scripts, and language templates |
| [`nix-haskell`](./skills/nix-haskell/SKILL.md) | Haskell projects with haskell-flake: dependencies, settings, devShell, autoWire |
| [`nix-ci`](./skills/nix-ci/SKILL.md) | CI setup for GitHub repos — GitHub Actions or Vira |
| [`vhs`](./skills/vhs/SKILL.md) | Deterministic terminal demo screencasts with VHS and wait patterns |

## Setup (home-manager)

Add the flake input:

```nix
# flake.nix inputs
skills.url = "github:juspay/skills";
```

Import the module for your agent:

```nix
# For OpenCode
imports = [ inputs.skills.homeModules.opencode ];

# For Claude Code
imports = [ inputs.skills.homeModules.claude-code ];

# Or both
imports = [
  inputs.skills.homeModules.opencode
  inputs.skills.homeModules.claude-code
];
```

All skills are automatically discovered and installed. New skills added to this repo are picked up on `flake update`.
