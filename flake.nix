{
  description = "Juspay skills, and the agent-distro profile that ships them";

  nixConfig = {
    extra-substituters = "https://cache.nixos.asia/oss";
    extra-trusted-public-keys = "oss:KO872wNJkCDgmGN3xy9dT89WAhvv13EiKncTtHDItVU=";
  };

  # Harness updates belong to agent-distro, so this lock only tracks plugins.
  inputs.kolu = { url = "github:juspay/kolu"; flake = false; };

  outputs = { self, kolu }: {
    profile = import ./profile.nix { skills = self; inherit kolu; };
  };
}
