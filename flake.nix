{
  description = "AI skill pack for coding agents";

  outputs = _: {
    homeModules = {
      opencode = import ./nix/opencode.nix { skillsSrc = ./skills; };
      claude-code = import ./nix/claude-code.nix { skillsSrc = ./skills; };
    };
  };
}
