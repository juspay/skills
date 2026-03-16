{
  description = "Tests for juspay/skills";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-agent-wire.url = "github:srid/nix-agent-wire";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, system, ... }:
        let
          pkgs-unfree = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          configDir = builtins.path { path = ./..; name = "skills-config"; };
        in
        {
        checks.home-manager-module = pkgs-unfree.testers.nixosTest {
          name = "skills-home-manager-module";

          nodes.machine = {
            imports = [
              inputs.home-manager.nixosModules.home-manager
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.users.testuser = {
              imports = [
                inputs.nix-agent-wire.homeModules.opencode
                inputs.nix-agent-wire.homeModules.claude-code
              ];
              home.stateVersion = "24.11";
              programs.opencode.enable = true;
              programs.opencode.autoWire.dirs = [ configDir ];
              programs.claude-code.enable = true;
              programs.claude-code.autoWire.dirs = [ configDir ];
            };

            users.users.testuser = {
              isNormalUser = true;
              home = "/home/testuser";
            };
          };

          testScript = ''
            machine.wait_for_unit("home-manager-testuser.service")

            # OpenCode
            machine.succeed("test -f /home/testuser/.config/opencode/skill/nix-flake/SKILL.md")
            machine.succeed("test -f /home/testuser/.config/opencode/skill/nix-haskell/SKILL.md")
            machine.succeed("test -f /home/testuser/.config/opencode/skill/vhs/SKILL.md")

            # Claude Code
            machine.succeed("test -d /home/testuser/.claude/skills/nix-flake")
            machine.succeed("test -d /home/testuser/.claude/skills/nix-haskell")
            machine.succeed("test -d /home/testuser/.claude/skills/vhs")
          '';
        };
      };
    };
}
