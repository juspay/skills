# skills home-manager module test
#
# Run with: nix build .#checks.x86_64-linux.home-manager-module
{ pkgs, inputs, ... }:

let
  testModule = inputs.self.homeModules.default;
in
pkgs.nixosTest {
  name = "skills-home-manager-module";

  nodes.machine = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.testuser = {
      imports = [ testModule ];
      home.stateVersion = "24.11";
      services.skills = {
        enable = true;
        targets = [ "opencode" ];
      };
    };

    users.users.testuser = {
      isNormalUser = true;
      home = "/home/testuser";
    };
  };

  testScript = ''
    machine.wait_for_unit("home-manager-testuser.service")
    machine.succeed("test -f /home/testuser/.config/opencode/skill/nix-flake/SKILL.md")
    machine.succeed("test -f /home/testuser/.config/opencode/skill/nix-haskell/SKILL.md")
    # Verify SKILL.md has correct frontmatter
    machine.succeed("grep -q 'name: nix-flake' /home/testuser/.config/opencode/skill/nix-flake/SKILL.md")
    machine.succeed("grep -q 'name: nix-haskell' /home/testuser/.config/opencode/skill/nix-haskell/SKILL.md")
  '';
}
