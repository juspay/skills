{
  description = "Juspay skills, and the agent-distro profile that ships them";

  # The wrapper repeats these because inner non-flake invocations ignore nixConfig.
  nixConfig = {
    extra-substituters = "https://cache.nixos.asia/oss";
    extra-trusted-public-keys = "oss:KO872wNJkCDgmGN3xy9dT89WAhvv13EiKncTtHDItVU=";
  };

  # nixpkgs only builds the launcher script; agent-distro stays unlocked to
  # avoid chained harness bumps, and supplies its own package set at runtime.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.kolu = { url = "github:juspay/kolu"; flake = false; };

  outputs = { self, nixpkgs, kolu }:
    let
      cacheUrl = "https://cache.nixos.asia/oss";
      cacheKey = "oss:KO872wNJkCDgmGN3xy9dT89WAhvv13EiKncTtHDItVU=";
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      profile = import ./profile.nix { skills = self; inherit kolu; };

      packages = forAllSystems (system: {
        # Once agent-distro accepts profiles, the wrapper can instead exec:
        # nix run github:juspay/agent-distro -- ${self} "$@"
        default = nixpkgs.legacyPackages.${system}.writeShellScriptBin "ai" ''
          exec nix --extra-experimental-features 'nix-command flakes' \
            --extra-substituters '${cacheUrl}' \
            --extra-trusted-public-keys '${cacheKey}' \
            run --impure -f ${self}/compose.nix picker -- "$@"
        '';
      });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          meta.description = "Launch the Juspay agent distribution";
          program = "${self.packages.${system}.default}/bin/ai";
        };
      });
    };
}
