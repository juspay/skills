{
  description = "Tests for juspay/skills";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    skills.url = "path:..";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {
        checks.home-manager-module = pkgs.testers.nixosTest {
          name = "skills-home-manager-module";

          nodes.machine = {
            imports = [
              inputs.home-manager.nixosModules.home-manager
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.users.testuser = {
              imports = [
                inputs.skills.homeModules.opencode
                inputs.skills.homeModules.claude-code
              ];
              home.stateVersion = "24.11";
              programs.opencode.enable = true;
              programs.opencode.package = null;
              programs.claude-code.enable = true;
              programs.claude-code.package = null;
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
            machine.succeed("grep -q 'name: nix-flake' /home/testuser/.config/opencode/skill/nix-flake/SKILL.md")

            # Claude Code
            machine.succeed("test -f /home/testuser/.claude/skills/nix-flake/SKILL.md")
            machine.succeed("test -f /home/testuser/.claude/skills/nix-haskell/SKILL.md")
            machine.succeed("grep -q 'name: nix-flake' /home/testuser/.claude/skills/nix-flake/SKILL.md")
          '';
        };
      };
    };
}
