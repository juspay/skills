{
  description = "AI skill pack for coding agents";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      flake.homeModules = {
        opencode = import ./nix/opencode.nix { skillsSrc = ./skills; };
        claude-code = import ./nix/claude-code.nix { skillsSrc = ./skills; };
      };
      perSystem = { pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;
        checks = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
          home-manager-module = import ./test/home-manager-module.nix { inherit pkgs inputs; };
        };
      };
    };
}
