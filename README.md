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

## Usage

Use [nix-agent-wire](https://github.com/srid/nix-agent-wire) to wire these skills into your agent config:

```nix
# flake.nix
{
  inputs.nix-agent-wire.url = "github:srid/nix-agent-wire";
  inputs.skills.url = "github:juspay/skills";

  outputs = { inputs, ... }: {
    homeConfigurations.myuser = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        inputs.nix-agent-wire.homeModules.opencode
        {
          programs.openable.enable = true;
          programs.opencode.autoWire.dirs = [ "${inputs.skills}/skills" ];
        }
      ];
    };
  };
}
```

See [nix-agent-wire](https://github.com/srid/nix-agent-wire) for full documentation.
