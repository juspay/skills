{
  description = "AI skill pack for coding agents";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      flake.homeModules = {
        opencode = import ./nix/opencode.nix { skillsSrc = ./skills; };
        claude-code = import ./nix/claude-code.nix { skillsSrc = ./skills; };
      };
      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
