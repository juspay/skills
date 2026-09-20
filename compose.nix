# Share runtime and canary composition without locking harnesses into this profile.
# Run locally: nix build --impure --refresh -f compose.nix picker omp codex claude
let
  distro = builtins.getFlake "github:juspay/agent-distro";
  skills = builtins.getFlake (toString ./.);
  pkgs = distro.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
in
  distro.lib.mkLaunchers { inherit pkgs; profile = skills.profile; }
